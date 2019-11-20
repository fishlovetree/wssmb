package com.ssm.wssmb.service;

import java.util.List;
import java.util.Map;

import com.ssm.wssmb.model.BusFault;

public interface BusFaultService {

	String queryFault(Integer id, Integer type, Integer organizationId, Integer status, Integer end, String startTime,
			String endTime, String faultType, String equipmentname, String address, int startindex, int endindex)
			throws Exception;

	boolean processFault(String sessionname, BusFault fault);

	String endFault(String id);

	Map<String, Map<Integer, String[]>> statisticsFaultRate(Integer organizationId, Integer id, Integer type,
			String year, String month, String day, String hour);

	List<BusFault> statisticsFaultList(Integer organizationId, Integer id, Integer type, String year, String month,
			String day, String hour);
}