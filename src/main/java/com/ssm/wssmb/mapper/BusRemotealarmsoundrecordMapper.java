package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.BusRemotealarmsmsrecord;
import com.ssm.wssmb.model.BusRemotealarmsoundrecord;

public interface BusRemotealarmsoundrecordMapper {

	List<BusRemotealarmsoundrecord> selectList(@Param("orgnazationId") Integer orgnazationId,
			@Param("eventid") String eventid, @Param("result") String result, @Param("startTime") String startTime,
			@Param("endTime") String endTime, @Param("equipmentaddress") String equipmentaddress,
			@Param(value = "equipmentname") String equipmentname, @Param(value = "startindex") int startindex,
			@Param(value = "endindex") int endindex);

	int selectListCount(@Param("orgnazationId") Integer orgnazationId, @Param("eventid") String eventid,
			@Param("result") String result, @Param("startTime") String startTime, @Param("endTime") String endTime,
			@Param("equipmentaddress") String equipmentaddress, @Param(value = "equipmentname") String equipmentname);

	List<BusRemotealarmsoundrecord> selectAmmeterRecord(@Param("id") Integer id,
			@Param("orgnazationId") Integer orgnazationId, @Param("eventid") String eventid,
			@Param("result") String result, @Param("startTime") String startTime, @Param("endTime") String endTime,
			@Param("equipmentaddress") String equipmentaddress, @Param(value = "equipmentname") String equipmentname,
			@Param(value = "startindex") int startindex, @Param(value = "endindex") int endindex);

	int selectByAmmeterRecordCount(@Param("id") Integer id, @Param("orgnazationId") Integer orgnazationId,
			@Param("eventid") String eventid, @Param("result") String result, @Param("startTime") String startTime,
			@Param("endTime") String endTime, @Param("equipmentaddress") String equipmentaddress,
			@Param(value = "equipmentname") String equipmentname);
	
	List<BusRemotealarmsoundrecord> selectTerminalRecord(@Param("id") Integer id,
			@Param("orgnazationId") Integer orgnazationId, @Param("eventid") String eventid,
			@Param("result") String result, @Param("startTime") String startTime, @Param("endTime") String endTime,
			@Param("equipmentaddress") String equipmentaddress, @Param(value = "equipmentname") String equipmentname,
			@Param(value = "startindex") int startindex, @Param(value = "endindex") int endindex);

	int selectByTerminalRecordCount(@Param("id") Integer id, @Param("orgnazationId") Integer orgnazationId,
			@Param("eventid") String eventid, @Param("result") String result, @Param("startTime") String startTime,
			@Param("endTime") String endTime, @Param("equipmentaddress") String equipmentaddress,
			@Param(value = "equipmentname") String equipmentname);


	List<BusRemotealarmsoundrecord> selectEquipmentRecord(@Param("terdition") String terdition,
			@Param("amdition") String amdition, @Param(value = "id") Integer id,
			@Param("orgnazationId") Integer orgnazationId, @Param("eventid") String eventid,
			@Param("result") String result, @Param("startTime") String startTime, @Param("endTime") String endTime,
			@Param("equipmentaddress") String equipmentaddress, @Param(value = "equipmentname") String equipmentname,
			@Param(value = "startindex") int startindex, @Param(value = "endindex") int endindex);

	int selectByEquipmentRecordCount(@Param("terdition") String terdition, @Param("amdition") String amdition,
			@Param(value = "id") Integer id, @Param("orgnazationId") Integer orgnazationId,
			@Param("eventid") String eventid, @Param("result") String result, @Param("startTime") String startTime,
			@Param("endTime") String endTime, @Param("equipmentaddress") String equipmentaddress,
			@Param(value = "equipmentname") String equipmentname);

	List<BusRemotealarmsoundrecord> selectRegionRecord(@Param("id") Integer id,
			@Param("orgnazationId") Integer orgnazationId, @Param("eventid") String eventid,
			@Param("result") String result, @Param("startTime") String startTime, @Param("endTime") String endTime,
			@Param("equipmentaddress") String equipmentaddress, @Param(value = "equipmentname") String equipmentname,
			@Param(value = "startindex") int startindex, @Param(value = "endindex") int endindex);

	int selectByRegionRecordCount(@Param("id") Integer id, @Param("orgnazationId") Integer orgnazationId,
			@Param("eventid") String eventid, @Param("result") String result, @Param("startTime") String startTime,
			@Param("endTime") String endTime, @Param("equipmentaddress") String equipmentaddress,
			@Param(value = "equipmentname") String equipmentname);
}