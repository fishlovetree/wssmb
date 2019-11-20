package com.ssm.wssmb.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssm.wssmb.mapper.ConstantDetailMapper;
import com.ssm.wssmb.mapper.MbAmmeterMapper;
import com.ssm.wssmb.mapper.TerminalMapper;
import com.ssm.wssmb.mapper.ViewEquipmentMapper;
import com.ssm.wssmb.model.ConstantDetail;
import com.ssm.wssmb.model.MbAmmeter;
import com.ssm.wssmb.model.Terminal;
import com.ssm.wssmb.model.ViewEquipment;
import com.ssm.wssmb.service.FileManageService;
import com.ssm.wssmb.util.EventLogAspect;
import com.ws.interfaceClass.ENUM_COMMAND_TYPE;
import com.ws.interfaceClass.ENUM_ERRORCODE_TYPE;
import com.ws.interfaceClass.ENUM_MSG_TYPE;
import com.ws.interfaceClass.EquipmentConfiguration;
import com.ws.interfaceClass.FileConfiguration;
import com.ws.interfaceClass.FileInitialization;
import com.ws.interfaceClass.ReportFileConfiguration;
import com.ws.interfaceClass.TaskInfo;
import com.ws.xml.PacketXML;
import com.ws.xml.ParseXML;

@Service
public class FileManageServiceImpl implements FileManageService {

	@Resource
	private ConstantDetailMapper constantDetailMapper;

	@Resource
	private ViewEquipmentMapper view_EquipmentMapper;

	@Resource
	private EventLogAspect log;
	
	@Autowired
	TerminalMapper terminalMapper;
	
	@Autowired
	MbAmmeterMapper mbAmmeterMapper;

	/**
	 * 将设备list转为map，键为终端地址
	 * 
	 * @param list
	 * @return
	 */
	public Map<String, ArrayList<Terminal>> toMap(List<Terminal> list) {
		Map<String, ArrayList<Terminal>> map = new HashMap<String, ArrayList<Terminal>>();
		for (int i = 0; i < list.size(); i++) {
			Terminal terminal = list.get(i);
			String mkey = terminal.getAddress();

			if (map.containsKey(mkey)) {
				map.get(mkey).add(terminal);
			} else {
				ArrayList<Terminal> e = new ArrayList<Terminal>();
				e.add(terminal);
				map.put(mkey, e);
			}
		}
		return map;
	}

	@Override
	public List<String> issued(List<Terminal> list) {
		Map<String, ArrayList<Terminal>> map = toMap(list);

		List<String> resultList = new ArrayList<String>();

		List<FileConfiguration> flistA = new ArrayList<FileConfiguration>();
		List<FileConfiguration> flistD = new ArrayList<FileConfiguration>();

		// 记录操作日志
		String logContent = "";
		for (Map.Entry<String, ArrayList<Terminal>> entry : map.entrySet()) {

			TaskInfo taskInfo = new TaskInfo();
			taskInfo.msgType = ENUM_MSG_TYPE.msg_Request;
			taskInfo.commandType = ENUM_COMMAND_TYPE.set;
			taskInfo.typeFlagCode = 129;
			taskInfo.priority = 0;
			taskInfo.communicationChannel = 0;
			taskInfo.userDeviceAddr = entry.getKey();
			String taskinfoXML = PacketXML.Packet_TaskInfo(taskInfo);

			logContent += "终端地址：" + entry.getKey();

			List<Terminal> terminallist = entry.getValue();
			if (null != terminallist && terminallist.size() > 0) {
				for (int i = 0; i < terminallist.size(); i++) {
					Terminal terminal = terminallist.get(i);
					FileConfiguration fileConfiguration = new FileConfiguration();
					fileConfiguration.configurationCode = terminal.getDOWNSTATUS();// 规约内--增加：0，删除：1
					// fileConfiguration.systemCode = Integer.parseInt(terminal.getSystemtype());
					// fileConfiguration.systemAddr = Integer.parseInt(terminal.getSystemaddress());
					// fileConfiguration.equipmentCode =
					// Integer.parseInt(terminal.getEquipmenttype());
					fileConfiguration.equipmentAddr = terminal.getAddress();
					// fileConfiguration.description = terminal.getEquipmentnote();
					if (fileConfiguration.configurationCode == 0) {
						flistA.add(fileConfiguration);
						logContent += ", 设备地址：" + terminal.getAddress() + ", 命令类型：增加";
					} else {
						flistD.add(fileConfiguration);
						logContent += ", 设备地址：" + terminal.getAddress() + ", 命令类型：删除";
					}
				}
			}

			logContent += ";";

			// 先下发删除XML，后下发增加XML
			List<FileConfiguration> subList = new ArrayList<FileConfiguration>();
			for (int i = 0; i < flistD.size(); i++) {
				subList.add(flistD.get(i));
				if ((i + 1) % 10 == 0) {
					resultList.add(taskinfoXML + PacketXML.Packet_FileConfiguration(subList));
					subList.clear();
				}
			}
			if (subList.size() > 0) {
				resultList.add(taskinfoXML + PacketXML.Packet_FileConfiguration(subList));
				subList.clear();
			}

			subList = new ArrayList<FileConfiguration>();
			for (int i = 0; i < flistA.size(); i++) {
				subList.add(flistA.get(i));
				if ((i + 1) % 10 == 0) {
					resultList.add(taskinfoXML + PacketXML.Packet_FileConfiguration(subList));
					subList.clear();
				}
			}
			if (subList.size() > 0) {
				resultList.add(taskinfoXML + PacketXML.Packet_FileConfiguration(subList));
				subList.clear();
			}
			flistD.clear();
			flistA.clear();
		}
		// 记录操作日志
		log.addLog("", "档案设置", logContent, 7);
		return resultList;
	}

	/**
	 * 将设备list转为map，键为终端地址
	 * 
	 * @param list
	 * @return
	 */
	public Map<String, ArrayList<MbAmmeter>> ammeterToMap(List<MbAmmeter> list) {
		Map<String, ArrayList<MbAmmeter>> map = new HashMap<String, ArrayList<MbAmmeter>>();
		for (int i = 0; i < list.size(); i++) {
			MbAmmeter mbAmmeter = list.get(i);
			String mkey = mbAmmeter.getAmmeterCode();

			if (map.containsKey(mkey)) {
				map.get(mkey).add(mbAmmeter);
			} else {
				ArrayList<MbAmmeter> e = new ArrayList<MbAmmeter>();
				e.add(mbAmmeter);
				map.put(mkey, e);
			}
		}

		return map;
	}

	@Override
	public List<String> issue(List<MbAmmeter> list) {
		Map<String, ArrayList<MbAmmeter>> map = ammeterToMap(list);

		List<String> resultList = new ArrayList<String>();

		List<FileConfiguration> flistA = new ArrayList<FileConfiguration>();
		List<FileConfiguration> flistD = new ArrayList<FileConfiguration>();

		// 记录操作日志
		String logContent = "";
		for (Map.Entry<String, ArrayList<MbAmmeter>> entry : map.entrySet()) {

			TaskInfo taskInfo = new TaskInfo();
			taskInfo.msgType = ENUM_MSG_TYPE.msg_Request;
			taskInfo.commandType = ENUM_COMMAND_TYPE.set;
			taskInfo.typeFlagCode = 129;
			taskInfo.priority = 0;
			taskInfo.communicationChannel = 0;
			taskInfo.userDeviceAddr = entry.getKey();
			String taskinfoXML = PacketXML.Packet_TaskInfo(taskInfo);

			logContent += "终端地址：" + entry.getKey();

			List<MbAmmeter> mbAmmeterlist = entry.getValue();
			if (null != mbAmmeterlist && mbAmmeterlist.size() > 0) {
				for (int i = 0; i < mbAmmeterlist.size(); i++) {
					MbAmmeter mbAmmeter = mbAmmeterlist.get(i);
					FileConfiguration fileConfiguration = new FileConfiguration();
					fileConfiguration.configurationCode = mbAmmeter.getDOWNSTATUS();// 规约内--增加：0，删除：1
					// fileConfiguration.systemCode = Integer.parseInt(terminal.getSystemtype());
					// fileConfiguration.systemAddr = Integer.parseInt(terminal.getSystemaddress());
					// fileConfiguration.equipmentCode =
					// Integer.parseInt(terminal.getEquipmenttype());
					fileConfiguration.equipmentAddr = mbAmmeter.getAmmeterCode();
					// fileConfiguration.description = terminal.getEquipmentnote();
					if (fileConfiguration.configurationCode == 1) {
						flistA.add(fileConfiguration);
						logContent += ", 设备地址：" + mbAmmeter.getAmmeterCode() + ", 命令类型：增加";
					} else {
						flistD.add(fileConfiguration);
						logContent += ", 设备地址：" + mbAmmeter.getAmmeterCode() + ", 命令类型：删除";
					}
				}
			}

			logContent += ";";

			// 先下发删除XML，后下发增加XML
			List<FileConfiguration> subList = new ArrayList<FileConfiguration>();
			for (int i = 0; i < flistD.size(); i++) {
				subList.add(flistD.get(i));
				if ((i + 1) % 10 == 0) {
					resultList.add(taskinfoXML + PacketXML.Packet_FileConfiguration(subList));
					subList.clear();
				}
			}
			if (subList.size() > 0) {
				resultList.add(taskinfoXML + PacketXML.Packet_FileConfiguration(subList));
				subList.clear();
			}

			subList = new ArrayList<FileConfiguration>();
			for (int i = 0; i < flistA.size(); i++) {
				subList.add(flistA.get(i));
				if ((i + 1) % 10 == 0) {
					resultList.add(taskinfoXML + PacketXML.Packet_FileConfiguration(subList));
					subList.clear();
				}
			}
			if (subList.size() > 0) {
				resultList.add(taskinfoXML + PacketXML.Packet_FileConfiguration(subList));
				subList.clear();
			}

			flistD.clear();
			flistA.clear();
		}

		// 记录操作日志
		log.addLog("", "档案设置", logContent, 7);

		return resultList;
	}

	@Override
	public Map<String, Object> parseTerminalResponse(String strXML) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
        String separator = "</xmlTaskInfo>";
        String[] arrXml = strXML.split(separator);
        if (arrXml.length != 2) return map;
        
        //根据终端地址获取终端ID
        TaskInfo taskInfoData = ParseXML.Parse_TaskInfo(arrXml[0] + separator);
        Terminal terminal = terminalMapper.selectByAddress(taskInfoData.userDeviceAddr);

        List<String> dataList = new ArrayList<String>();

        switch(taskInfoData.typeFlagCode){
	        case 151: //档案清空
	        	List<FileInitialization> ilist = ParseXML.Parse_FileInitialization(arrXml[1]);
	        	if (null != ilist && ilist.size() > 0){
	        		if (taskInfoData.errorCode == ENUM_ERRORCODE_TYPE.ok){
	        			dataList.add("success");
	        		}
	        	}
	    	break;
//	        case 207: //查询档案
//	        	List<ReportFileConfiguration > rlist = ParseXML.Parse_ReportFileConfiguration(arrXml[1]);
//	        	if (null != rlist && rlist.size() > 0){
//	        		if (taskInfoData.errorCode == ENUM_ERRORCODE_TYPE.ok){
//	        			List<Integer> equipmentids = new ArrayList<Integer>();
//	        			List<ViewEquipment> resultlist = new ArrayList<ViewEquipment>();
//		        		for (int i = 0; i < rlist.size(); i++){
//		        			ReportFileConfiguration reportFileConfiguration = rlist.get(i);
//		        			//int num=reportFileConfiguration.initialSequence;
//
//		        			for(int j=0;j<reportFileConfiguration.listEquipment.size();j++){
//		        				EquipmentConfiguration equip=reportFileConfiguration.listEquipment.get(j);
//		        				
//		        				ConstantDetail system=constantDetailMapper.selectByDetailValue(1003,reportFileConfiguration.systemCode+"");
//		        				ConstantDetail equipmenttype=constantDetailMapper.selectByDetailValue(1007,equip.equipmentCode+"");
//		        				
//		        				String equipmenttypename=(null==equipmenttype.getDetailname()? "" :equipmenttype.getDetailname());
//		        				String systemtypename=(null==system.getDetailname()? "" :system.getDetailname());
//
//		        				QueryEquipment value = new QueryEquipment();
//		        				value.setUnitid(terminal.getUnitid());
//		        				value.setEquipmentaddress(equip.equipmentAddr);
//		        				value.setSystemtype(system.getDetailvalue());
//		        				value.setDevicestatus("1");
//		        				List<ViewEquipment> list=view_EquipmentMapper.getEquipListByKey(value);
//		        				
//		        				String equipmentname="";
//		        				Integer equipmentid=0;
//		        				ViewEquipment equipment=new ViewEquipment();
//		        				if(list.size()==1 && null != list.get(0).getEquipmentname()){
//		        					equipment=list.get(0);
//		        					equipmentname=equipment.getEquipmentname();
//		        					equipmentid=equipment.getEquipmentid();
//		        					equipmentids.add(equipmentid);
//		        					resultlist.add(equipment);
//		        				}
//		        				else{
//		        					equipment.setEquipmentid(equipmentid);
//		        					equipment.setSystemtypename(systemtypename);
//		        					equipment.setSystemaddress(reportFileConfiguration.systemAddr+"");
//		        					equipment.setEquipmentname(equipmentname);
//		        					equipment.setEquipmenttypename(equipmenttypename);
//		        					equipment.setEquipmentaddress(equip.equipmentAddr);
//		        					equipment.setEquipmentnote(equip.description);
//		        					resultlist.add(equipment);
//		        				}
//		        			}
//		        		}
//		        		map.put("equipmentids", equipmentids);
//		        		map.put("resultlist", resultlist);
//	        		}
//	        	}
//        	break;
//	        case 129: //设置档案
//	        	List<FileConfiguration > flist = ParseXML.Parse_FileConfiguration(arrXml[1]);
//	        	if (null != flist && flist.size() > 0){
//	        		if (taskInfoData.errorCode == ENUM_ERRORCODE_TYPE.ok){
//	        			int result=0;
//	        			
//		        		for (int i = 0; i < flist.size(); i++){
//		        			FileConfiguration fileConfiguration = flist.get(i);
//		        			fileConfiguration.configurationCode=flist.get(i).configurationCode;//数据库内--增加：0，删除：1
//
//		        			result+=equipmentfileMapper.updateUnDownFile(fileConfiguration.equipmentAddr, fileConfiguration.configurationCode);
//		        			
//		        		}
//
//		        		if(result>0){
//		        			dataList.add("success");
//		        		}else{
//		        			dataList.add("fail");
//		        		}
//
//	        		}
//	        	}
//        	break;
        }
        map.put("result", taskInfoData.errorCode.ordinal());
        map.put("data", dataList);
        map.put("typeFlagCode", taskInfoData.typeFlagCode);
        return map;
	}
	
	@Override
	public Map<String, Object> parseAmmeterResponse(String strXML) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
        String separator = "</xmlTaskInfo>";
        String[] arrXml = strXML.split(separator);
        if (arrXml.length != 2) return map;
        
        //根据终端地址获取终端ID
        TaskInfo taskInfoData = ParseXML.Parse_TaskInfo(arrXml[0] + separator);
        MbAmmeter mbAmmeter = mbAmmeterMapper.selectByAddress(taskInfoData.userDeviceAddr);

        List<String> dataList = new ArrayList<String>();

        switch(taskInfoData.typeFlagCode){
	        case 151: //档案清空
	        	List<FileInitialization> ilist = ParseXML.Parse_FileInitialization(arrXml[1]);
	        	if (null != ilist && ilist.size() > 0){
	        		if (taskInfoData.errorCode == ENUM_ERRORCODE_TYPE.ok){
	        			dataList.add("success");
	        		}
	        	}
	    	break;
//	        case 207: //查询档案
//	        	List<ReportFileConfiguration > rlist = ParseXML.Parse_ReportFileConfiguration(arrXml[1]);
//	        	if (null != rlist && rlist.size() > 0){
//	        		if (taskInfoData.errorCode == ENUM_ERRORCODE_TYPE.ok){
//	        			List<Integer> equipmentids = new ArrayList<Integer>();
//	        			List<ViewEquipment> resultlist = new ArrayList<ViewEquipment>();
//		        		for (int i = 0; i < rlist.size(); i++){
//		        			ReportFileConfiguration reportFileConfiguration = rlist.get(i);
//		        			//int num=reportFileConfiguration.initialSequence;
//
//		        			for(int j=0;j<reportFileConfiguration.listEquipment.size();j++){
//		        				EquipmentConfiguration equip=reportFileConfiguration.listEquipment.get(j);
//		        				
//		        				ConstantDetail system=constantDetailMapper.selectByDetailValue(1003,reportFileConfiguration.systemCode+"");
//		        				ConstantDetail equipmenttype=constantDetailMapper.selectByDetailValue(1007,equip.equipmentCode+"");
//		        				
//		        				String equipmenttypename=(null==equipmenttype.getDetailname()? "" :equipmenttype.getDetailname());
//		        				String systemtypename=(null==system.getDetailname()? "" :system.getDetailname());
//
//		        				QueryEquipment value = new QueryEquipment();
//		        				value.setUnitid(terminal.getUnitid());
//		        				value.setEquipmentaddress(equip.equipmentAddr);
//		        				value.setSystemtype(system.getDetailvalue());
//		        				value.setDevicestatus("1");
//		        				List<ViewEquipment> list=view_EquipmentMapper.getEquipListByKey(value);
//		        				
//		        				String equipmentname="";
//		        				Integer equipmentid=0;
//		        				ViewEquipment equipment=new ViewEquipment();
//		        				if(list.size()==1 && null != list.get(0).getEquipmentname()){
//		        					equipment=list.get(0);
//		        					equipmentname=equipment.getEquipmentname();
//		        					equipmentid=equipment.getEquipmentid();
//		        					equipmentids.add(equipmentid);
//		        					resultlist.add(equipment);
//		        				}
//		        				else{
//		        					equipment.setEquipmentid(equipmentid);
//		        					equipment.setSystemtypename(systemtypename);
//		        					equipment.setSystemaddress(reportFileConfiguration.systemAddr+"");
//		        					equipment.setEquipmentname(equipmentname);
//		        					equipment.setEquipmenttypename(equipmenttypename);
//		        					equipment.setEquipmentaddress(equip.equipmentAddr);
//		        					equipment.setEquipmentnote(equip.description);
//		        					resultlist.add(equipment);
//		        				}
//		        			}
//		        		}
//		        		map.put("equipmentids", equipmentids);
//		        		map.put("resultlist", resultlist);
//	        		}
//	        	}
//        	break;
//	        case 129: //设置档案
//	        	List<FileConfiguration > flist = ParseXML.Parse_FileConfiguration(arrXml[1]);
//	        	if (null != flist && flist.size() > 0){
//	        		if (taskInfoData.errorCode == ENUM_ERRORCODE_TYPE.ok){
//	        			int result=0;
//	        			
//		        		for (int i = 0; i < flist.size(); i++){
//		        			FileConfiguration fileConfiguration = flist.get(i);
//		        			fileConfiguration.configurationCode=flist.get(i).configurationCode;//数据库内--增加：0，删除：1
//
//		        			result+=equipmentfileMapper.updateUnDownFile(fileConfiguration.equipmentAddr, fileConfiguration.configurationCode);
//		        			
//		        		}
//
//		        		if(result>0){
//		        			dataList.add("success");
//		        		}else{
//		        			dataList.add("fail");
//		        		}
//
//	        		}
//	        	}
//        	break;
        }
        map.put("result", taskInfoData.errorCode.ordinal());
        map.put("data", dataList);
        map.put("typeFlagCode", taskInfoData.typeFlagCode);
        return map;
	}
}
