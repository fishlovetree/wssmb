package com.ssm.wssmb.service;

import java.util.List;
import java.util.Map;

import org.springframework.aop.ThrowsAdvice;

import com.ssm.wssmb.model.AmmeterStatus;
import com.ssm.wssmb.model.ViewEquipmentstatus;
import com.ssm.wssmb.model.ViewOnlineunit;

public interface MonitorService {

	public Map<String, String[]> unitonline(Integer organizationId, Integer id, Integer type) throws Exception;

	public List<ViewOnlineunit> getUnitFileList(Integer organizationId, Integer id, Integer type) throws Exception;

//	public Map<String, Map<String, Integer[]>> deviceonlineByType(String status, String equipmentname) throws Exception;
//
//	public List<ViewEquipmentstatus> getEquipmentList(String status, String[] equipmenttype, String equipmentname)
//			throws Exception;

	public String getUnitFilePage(Integer organizationId, Integer id, String status, Integer unittype, Integer type,
			Integer startindex, Integer endindex) throws Exception;

//	public Map<String, Map<String, Integer[]>> deviceonlineByType(Integer organization, Integer id, Integer type,
//			String status, String equipmentname) throws Exception;

	public ViewOnlineunit getUnitRowByID(Integer unitid, Integer type);

	public AmmeterStatus getEquipmentRowByID(Integer unitid, Integer type) throws Exception;

	public String realtimedata(Integer type, String equipmentaddress, String checkbox, String startdate, String enddate)
			throws Exception;

	public String daydata(Integer type, String equipmentaddress, String checkbox, String startdate, String enddate)
			throws Exception;

	public String powerdata(Integer id, Integer type, int organizationid, String startdate, String enddate,
			int startindex, int endindex) throws Exception;
}
