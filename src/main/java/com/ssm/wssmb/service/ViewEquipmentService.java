package com.ssm.wssmb.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.ssm.wssmb.model.MbAmmeter;
import com.ssm.wssmb.model.Terminal;
import com.ssm.wssmb.model.ViewEquipment;

public interface ViewEquipmentService {
	
	List<ViewEquipment> selectByIdOrAddr(Integer equipmentid, String equipmentaddress);
	
	List<Terminal> getTerminalListByIDs(String[] ids);
	
	List<MbAmmeter> getAmmeterlListByIDs(String[] ids);

}
