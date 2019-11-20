package com.ssm.wssmb.service;

import java.util.List;

public interface EventRecordService {
	
	String smsRecordDataGrid(Integer id,Integer type,Integer orgnazationId,String eventid,String result, String startTime,
			String endTime, String address, String equipmentname,int startindex, int endindex)throws Exception;
	
	String soundRecordDataGrid(Integer id,Integer type,Integer orgnazationId, String eventid,String result, String startTime,
			String endTime, String address, String equipmentname,int startindex, int endindex)throws Exception;

}
