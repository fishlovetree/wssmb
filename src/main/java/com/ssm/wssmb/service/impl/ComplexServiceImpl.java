package com.ssm.wssmb.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ssm.wssmb.mapper.ConstantDetailMapper;
import com.ssm.wssmb.mapper.UnitParamsMapper;
import com.ssm.wssmb.service.ComplexService;
import com.ssm.wssmb.util.EventLogAspect;
import com.ssm.wssmb.util.Operation;
import com.ws.interfaceClass.CommunicationConfiguration;
import com.ws.interfaceClass.ENUM_ERRORCODE_TYPE;
import com.ws.interfaceClass.EventThresholdConfiguration;
import com.ws.interfaceClass.FreezeData;
import com.ws.interfaceClass.FreezePeriodConfiguration;
import com.ws.interfaceClass.QueryKeyVersion;
import com.ws.interfaceClass.TaskInfo;
import com.ws.interfaceClass.TerminalTime;
import com.ws.xml.ParseXML;

@Service
public class ComplexServiceImpl implements ComplexService {

	@Resource
	private EventLogAspect log;

	@Override
	public Map<String, Object> parseResponse(String strXML) throws Exception {
		return null;

	}
}
