package com.ssm.wssmb.service;

import java.util.List;

import com.ssm.wssmb.model.BusMessagepushrecord;

public interface BusMessageService {

	int deleteByPrimaryKey(Integer id);

    int insert(BusMessagepushrecord record);

    int insertSelective(BusMessagepushrecord record);

    BusMessagepushrecord selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(BusMessagepushrecord record);

    int updateByPrimaryKey(BusMessagepushrecord record);

    String queryMessage( Integer id,Integer type,Integer organizationId ,String msgtypecode,
			String startTime, String endTime, String address, String equipmentname,
			int startindex, int endindex)throws Exception;
}
