package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.BusRemotealarmsmsrecord;

public interface BusRemotealarmsmsrecordMapper {

	List<BusRemotealarmsmsrecord> selectList(@Param("organizationId") Integer organizationId,
			@Param("eventid") String eventid, @Param("result") String result, @Param("startTime") String startTime,
			@Param("endTime") String endTime, @Param("address") String address,
			@Param(value = "equipmentname") String equipmentname, @Param(value = "startindex") int startindex,
			@Param(value = "endindex") int endindex);

	int selectListCount(@Param("organizationId") Integer organizationId, @Param("eventid") String eventid,
			@Param("result") String result, @Param("startTime") String startTime, @Param("endTime") String endTime,
			@Param("address") String address, @Param(value = "equipmentname") String equipmentname);

	List<BusRemotealarmsmsrecord> selectAmmeterRecord(@Param(value = "id") Integer id,
			@Param("organizationId") Integer organizationId, @Param("eventid") String eventid,
			@Param("result") String result, @Param("startTime") String startTime, @Param("endTime") String endTime,
			@Param("address") String address, @Param(value = "equipmentname") String equipmentname,
			@Param(value = "startindex") int startindex, @Param(value = "endindex") int endindex);

	int selectByAmmeterRecordCount(@Param(value = "id") Integer id, @Param("organizationId") Integer organizationId,
			@Param("eventid") String eventid, @Param("result") String result, @Param("startTime") String startTime,
			@Param("endTime") String endTime, @Param("address") String address,
			@Param(value = "equipmentname") String equipmentname);
	
	List<BusRemotealarmsmsrecord> selectTerminalRecord(@Param(value = "id") Integer id,
			@Param("organizationId") Integer organizationId, @Param("eventid") String eventid,
			@Param("result") String result, @Param("startTime") String startTime, @Param("endTime") String endTime,
			@Param("address") String address, @Param(value = "equipmentname") String equipmentname,
			@Param(value = "startindex") int startindex, @Param(value = "endindex") int endindex);

	int selectByTerminalRecordCount(@Param(value = "id") Integer id, @Param("organizationId") Integer organizationId,
			@Param("eventid") String eventid, @Param("result") String result, @Param("startTime") String startTime,
			@Param("endTime") String endTime, @Param("address") String address,
			@Param(value = "equipmentname") String equipmentname);

	List<BusRemotealarmsmsrecord> selectEquipmentRecord(@Param("terdition") String terdition,
			@Param("amdition") String amdition, @Param(value = "id") Integer id,
			@Param("organizationId") Integer organizationId, @Param("eventid") String eventid,
			@Param("result") String result, @Param("startTime") String startTime, @Param("endTime") String endTime,
			@Param("address") String address, @Param(value = "equipmentname") String equipmentname,
			@Param(value = "startindex") int startindex, @Param(value = "endindex") int endindex);

	int selectByEquipmentRecordCount(@Param("terdition") String terdition, @Param("amdition") String amdition,
			@Param(value = "id") Integer id, @Param("organizationId") Integer organizationId,
			@Param("eventid") String eventid, @Param("result") String result, @Param("startTime") String startTime,
			@Param("endTime") String endTime, @Param("address") String address,
			@Param(value = "equipmentname") String equipmentname);

	List<BusRemotealarmsmsrecord> selectRegionRecord(@Param(value = "id") Integer id,
			@Param("organizationId") Integer organizationId, @Param("eventid") String eventid,
			@Param("result") String result, @Param("startTime") String startTime, @Param("endTime") String endTime,
			@Param("address") String address, @Param(value = "equipmentname") String equipmentname,
			@Param(value = "startindex") int startindex, @Param(value = "endindex") int endindex);

	int selectByRegionRecordCount(@Param(value = "id") Integer id, @Param("organizationId") Integer organizationId,
			@Param("eventid") String eventid, @Param("result") String result, @Param("startTime") String startTime,
			@Param("endTime") String endTime, @Param("address") String address,
			@Param(value = "equipmentname") String equipmentname);

}