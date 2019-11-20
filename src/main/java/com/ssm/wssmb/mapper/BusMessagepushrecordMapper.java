package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.BusMessagepushrecord;
import com.ssm.wssmb.model.Region;

public interface BusMessagepushrecordMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(BusMessagepushrecord record);

    int insertSelective(BusMessagepushrecord record);

    BusMessagepushrecord selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(BusMessagepushrecord record);

    int updateByPrimaryKey(BusMessagepushrecord record);

	List<BusMessagepushrecord> queryMessage(@Param(value = "organizationId") Integer organizationId,
			@Param("msgtypecode")String msgtypecode, @Param("startTime")String startTime, 
			@Param("endTime")String endTime, @Param("equipmentaddress")String equipmentaddress,
			@Param(value="equipmentname")String equipmentname,@Param(value="startindex")int startindex, 
			@Param(value="endindex")int endindex);

	int queryMessageCount(@Param(value = "organizationId") Integer organizationId,
			@Param("msgtypecode")String msgtypecode, @Param("startTime")String startTime, 
			@Param("endTime")String endTime, @Param("equipmentaddress")String equipmentaddress,
			@Param(value="equipmentname")String equipmentname);
	
	List<BusMessagepushrecord> selectAmmeterMessage(@Param(value = "id") Integer id,@Param(value = "organizationId") Integer organizationId,
			@Param("msgtypecode")String msgtypecode, @Param("startTime")String startTime, 
			@Param("endTime")String endTime, @Param("equipmentaddress")String equipmentaddress,
			@Param(value="equipmentname")String equipmentname,@Param(value="startindex")int startindex, 
			@Param(value="endindex")int endindex);

	int selectByAmmeterMessageCount(@Param(value = "id") Integer id,@Param(value = "organizationId") Integer organizationId,
			@Param("msgtypecode")String msgtypecode, @Param("startTime")String startTime, 
			@Param("endTime")String endTime, @Param("equipmentaddress")String equipmentaddress,
			@Param(value="equipmentname")String equipmentname);
	
	List<BusMessagepushrecord> selectTerminalMessage(@Param(value = "id") Integer id,@Param(value = "organizationId") Integer organizationId,
			@Param("msgtypecode")String msgtypecode, @Param("startTime")String startTime, 
			@Param("endTime")String endTime, @Param("equipmentaddress")String equipmentaddress,
			@Param(value="equipmentname")String equipmentname,@Param(value="startindex")int startindex, 
			@Param(value="endindex")int endindex);

	int selectByTerminalMessageCount(@Param(value = "id") Integer id,@Param(value = "organizationId") Integer organizationId,
			@Param("msgtypecode")String msgtypecode, @Param("startTime")String startTime, 
			@Param("endTime")String endTime, @Param("equipmentaddress")String equipmentaddress,
			@Param(value="equipmentname")String equipmentname);
	
	List<BusMessagepushrecord> selectEquipmentMessage(@Param(value = "terdition") String terdition,
			@Param(value = "amdition") String amdition,
			@Param(value = "id") Integer id,@Param(value = "organizationId") Integer organizationId,
			@Param("msgtypecode")String msgtypecode, @Param("startTime")String startTime, 
			@Param("endTime")String endTime, @Param("equipmentaddress")String equipmentaddress,
			@Param(value="equipmentname")String equipmentname,@Param(value="startindex")int startindex, 
			@Param(value="endindex")int endindex);

	int selectByEquipmentMessageCount(@Param(value = "terdition") String terdition,
			@Param(value = "amdition") String amdition,
			@Param(value = "id") Integer id,@Param(value = "organizationId") Integer organizationId,
			@Param("msgtypecode")String msgtypecode, @Param("startTime")String startTime, 
			@Param("endTime")String endTime, @Param("equipmentaddress")String equipmentaddress,
			@Param(value="equipmentname")String equipmentname);
	
	List<BusMessagepushrecord> selectRegionMessage(@Param(value = "id") Integer id,@Param(value = "organizationId") Integer organizationId,
			@Param("msgtypecode")String msgtypecode, @Param("startTime")String startTime, 
			@Param("endTime")String endTime, @Param("equipmentaddress")String equipmentaddress,
			@Param(value="equipmentname")String equipmentname,@Param(value="startindex")int startindex, 
			@Param(value="endindex")int endindex);

	int selectByRegionMessageCount(@Param(value = "id") Integer id,@Param(value = "organizationId") Integer organizationId,
			@Param("msgtypecode")String msgtypecode, @Param("startTime")String startTime, 
			@Param("endTime")String endTime, @Param("equipmentaddress")String equipmentaddress,
			@Param(value="equipmentname")String equipmentname);
}