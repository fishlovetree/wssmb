package com.ssm.wssmb.service.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssm.wssmb.mapper.EarlyWarningMapper;
import com.ssm.wssmb.mapper.MbAmmeterMapper;
import com.ssm.wssmb.mapper.TerminalMapper;
import com.ssm.wssmb.mapper.ViewEquipmentMapper;
import com.ssm.wssmb.model.EarlyWarning;
import com.ssm.wssmb.model.MbAmmeter;
import com.ssm.wssmb.model.Terminal;
import com.ssm.wssmb.model.ViewEquipment;
import com.ssm.wssmb.model.VrImg;
import com.ssm.wssmb.model.VrLink;
import com.ssm.wssmb.model.VrMark;
import com.ssm.wssmb.service.VisualizationService;
import com.ssm.wssmb.util.EventLogAspect;
import com.ssm.wssmb.util.Operation;
import com.ws.interfaceClass.ENUM_COMMAND_TYPE;
import com.ws.interfaceClass.ENUM_MSG_TYPE;
import com.ws.interfaceClass.EventRecord;
import com.ws.interfaceClass.FreezeData;
import com.ws.interfaceClass.PeaswayParamSet;
import com.ws.interfaceClass.QueryTerminalPlan;
import com.ws.interfaceClass.RemoteMsgRequest;
import com.ws.interfaceClass.ReportEventRecord;
import com.ws.interfaceClass.ReportRequestInfo;
import com.ws.interfaceClass.TaskInfo;
import com.ws.interfaceClass.TerminalLinkage;
import com.ws.interfaceClass.VideoCommData;
import com.ws.interfaceClass.VideoCommand;
import com.ws.interfaceClass.VideoGetWay;
import com.ws.interfaceClass.VideoPlayWay;
import com.ws.xml.PacketXML;
import com.ws.xml.ParseXML;

@Service
public class VisualizationServiceImpl implements VisualizationService {
	
	@Autowired
	TerminalMapper terminalMapper;
	
	@Autowired
	MbAmmeterMapper ammeterMapper;
	
	/**
	 * @Description 请求实时曲线-组帧
	 * @return
	 * @throws Exception
	 * @Time 2018年7月5日
	 * @Author hxl
	 */
    @Override
	public String makeRealtimeFrame(Integer equipmentid, Integer userID,Integer type) throws Exception {
    	if (type==5) {
    		List<Terminal> e = terminalMapper.selectByIdAndType(equipmentid);
    		if (e.size()==0) {
    			return null;
    		}else {
    			TaskInfo taskInfo = new TaskInfo();
                taskInfo.msgType = ENUM_MSG_TYPE.msg_RequestReport;
                taskInfo.commandType = ENUM_COMMAND_TYPE.get;
                taskInfo.typeFlagCode = 162;
                taskInfo.userDeviceAddr="";
                String taskinfoXML = PacketXML.Packet_TaskInfo(taskInfo);
                
            	ReportRequestInfo request = new ReportRequestInfo();
        	    request.userID = userID;
        	    request.reportEvent = 0;
        	    request.reportFreezeData = 1;
        	    request.reportFreezeDataType = 1;
        	    request.reportStateData = 0;
        	    request.listRepostUIUAddr = new ArrayList<String>();
        	    request.listRepostUIUAddr.add(e.get(0).getAddress());
        	    return taskinfoXML + PacketXML.Packet_ReportRequestInfo(request);
			}		
		}else {
			List<MbAmmeter> e = ammeterMapper.selectByIdAndType(equipmentid);
    		if (e.size()==0) {
    			return null;
    		}else {
    			TaskInfo taskInfo = new TaskInfo();
                taskInfo.msgType = ENUM_MSG_TYPE.msg_RequestReport;
                taskInfo.commandType = ENUM_COMMAND_TYPE.get;
                taskInfo.typeFlagCode = 162;
                taskInfo.userDeviceAddr="";
                String taskinfoXML = PacketXML.Packet_TaskInfo(taskInfo);                
            	ReportRequestInfo request = new ReportRequestInfo();
        	    request.userID = userID;
        	    request.reportEvent = 0;
        	    request.reportFreezeData = 1;
        	    request.reportFreezeDataType = 1;
        	    request.reportStateData = 0;
        	    request.listRepostUIUAddr = new ArrayList<String>();
        	    request.listRepostUIUAddr.add(e.get(0).getAmmeterCode());
        	    return taskinfoXML + PacketXML.Packet_ReportRequestInfo(request);
			}  		
		}    	    	   	
	}
}

