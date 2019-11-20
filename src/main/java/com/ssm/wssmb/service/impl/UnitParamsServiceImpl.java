package com.ssm.wssmb.service.impl;

import java.util.ArrayList;
import java.util.List;
import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.ssm.wssmb.mapper.ConcentratorMapper;
import com.ssm.wssmb.model.Concentrator;
import com.ssm.wssmb.service.UnitParamsService;
import com.ssm.wssmb.util.EventLogAspect;
import com.ssm.wssmb.util.TreeNodeType;
import com.ws.apdu698.GetRequestNormal;
import com.ws.data698.OAD;
import com.ws.data698.PIID;
import com.ws.interfaceClass.ENUM_COMMAND_TYPE;
import com.ws.interfaceClass.ENUM_MSG_TYPE;
import com.ws.interfaceClass.QueryKeyVersion;
import com.ws.interfaceClass.TaskInfo;
import com.ws.xml.PacketXML;

@Service
public class UnitParamsServiceImpl implements UnitParamsService {

    @Resource
    ConcentratorMapper concentratorMapper;
    
    @Resource
	private EventLogAspect log;

    /**
	 * @Description 读取终端版本号
	 * @return
	 * @throws Exception
	 * @Time 2018年10月12日
	 * @Author hxl
	 */
	@Override
	public String getVersion(Integer id, Integer type, String address, Integer organizationId){
		List<String> listResult = new ArrayList<String>();
		TreeNodeType treeType = TreeNodeType.values()[type - 1];
		List<Concentrator> listConcentrator = new ArrayList<Concentrator>();
//		List<BusEquipmentfile> listGprsEqu = new ArrayList<BusEquipmentfile>();
		List<String> addressList= new ArrayList<String>();//查询的所有地址
	    switch(treeType){
	       case Concentrator:	    	   
	    	   Concentrator unit = concentratorMapper.getConcentratorByid(id);
	    	   listConcentrator.add(unit);
	    	   break;
//	       case GprsDevice:
//	    	   BusEquipmentfile equ = equipmentMapper.selectByPrimaryKey(id);
//	    	   listGprsEqu.add(equ);
//	    	   break;
	       default:
	    	   break;
	    }
	    
//	    if(null != listUnit && listUnit.size() > 0) {
//	    	for (int i = 0;i < listUnit.size();i++) {
//	    		addressList.add(listUnit.get(i).getUnitaddress());
//	    	}
//	    }
	    
	    if(null != listConcentrator && listConcentrator.size() > 0) {
	    	for (int i = 0;i < listConcentrator.size();i++) {
	    		addressList.add(listConcentrator.get(i).getAddress());
	    	}
	    }
	    
	    if(null != addressList && addressList.size() > 0) {
	    	for (int i = 0;i < addressList.size();i++) {
	    		PIID piid = new PIID("0");
	    		OAD oad = new OAD("6000");
	    		GetRequestNormal getRequestNormal = new GetRequestNormal(piid, oad);
		    	TaskInfo taskInfo = new TaskInfo();
		        taskInfo.msgType = ENUM_MSG_TYPE.msg_Request;
		        taskInfo.commandType = ENUM_COMMAND_TYPE.get;
		        taskInfo.typeFlagCode = 215;
		        taskInfo.priority = 0;
		        taskInfo.communicationChannel = 0;
		        taskInfo.userDeviceAddr = addressList.get(i);
		        String taskinfoXML = PacketXML.Packet_TaskInfo(taskInfo);
		        
				List<QueryKeyVersion> list = new ArrayList<QueryKeyVersion>();
				QueryKeyVersion queryKeyVersion = new QueryKeyVersion();
				queryKeyVersion.keyVersion = 0;
				queryKeyVersion.softVersion = "";
				list.add(queryKeyVersion);
				String dataXML = PacketXML.Packet_QueryKeyVersion(list);
				
				//记录操作日志
		        String content = "终端地址：" + addressList.get(i);
		        log.addLog("", "读取终端版本号", content, 5);
				
		        listResult.add(taskinfoXML + dataXML);
	    	}
	    }
	    Gson gson = new GsonBuilder().disableHtmlEscaping().create();
	    //System.out.println(addressList.size()+","+gson.toJson(listResult));
	    return gson.toJson(listResult);
	}
    
   
}
