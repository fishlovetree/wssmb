package com.ssm.wssmb.service;

import java.util.List;

import com.ssm.wssmb.model.AmmeterStatus;

public interface EquipmentStatusService {
	
	List<AmmeterStatus> getConcentratorStatus(Integer orgId,Integer id,Integer type,Integer status) throws Exception;
			
	List<AmmeterStatus> getTerminalStatus(Integer orgId,Integer id,Integer type,Integer status) throws Exception;
	
	List<AmmeterStatus> getAmmeterStatus(Integer orgId,Integer id,Integer type,Integer status) throws Exception;

}
