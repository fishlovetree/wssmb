package com.ssm.wssmb.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.ssm.wssmb.model.MbAmmeter;
import com.ssm.wssmb.model.Terminal;
import com.ssm.wssmb.model.ViewEquipment;

public interface FileManageService {

	List<String> issued(List<Terminal> list);

	List<String> issue(List<MbAmmeter> list);

	Map<String, Object> parseTerminalResponse(String strXML) throws Exception;
	
	Map<String, Object> parseAmmeterResponse(String strXML) throws Exception;

}
