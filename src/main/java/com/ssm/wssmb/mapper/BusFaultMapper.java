package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.BusFault;
import com.ssm.wssmb.model.MbAmmeter;
import com.ssm.wssmb.model.Terminal;

public interface BusFaultMapper {

	int updateByPrimaryKeySelective(BusFault record);

	int updateEndTime(@Param("id") Integer id);

	List<BusFault> queryFault(@Param(value = "organizationId") Integer organizationId,
			@Param(value = "status") Integer status, @Param(value = "end") Integer end,
			@Param(value = "startTime") String startTime, @Param(value = "endTime") String endTime,
			@Param(value = "faulttype") String faulttype, @Param(value = "equipmentname") String equipmentname,
			@Param("address") String address, @Param(value = "startindex") int startindex,
			@Param(value = "endindex") int endindex);

	int queryFaultCount(@Param(value = "organizationId") Integer organizationId,
			@Param(value = "status") Integer status, @Param(value = "end") Integer end,
			@Param(value = "startTime") String startTime, @Param(value = "endTime") String endTime,
			@Param(value = "faulttype") String faulttype, @Param(value = "equipmentname") String equipmentname,
			@Param("address") String address);

	List<BusFault> selectAmmeterFault(@Param(value = "id") Integer id,
			@Param(value = "organizationId") Integer organizationId, @Param(value = "status") Integer status,
			@Param(value = "end") Integer end, @Param(value = "startTime") String startTime,
			@Param(value = "endTime") String endTime, @Param(value = "faulttype") String faulttype,
			@Param(value = "equipmentname") String equipmentname, @Param("address") String address,
			@Param(value = "startindex") int startindex, @Param(value = "endindex") int endindex);

	int selectByAmmeterFaultCount(@Param(value = "id") Integer id,
			@Param(value = "organizationId") Integer organizationId, @Param(value = "status") Integer status,
			@Param(value = "end") Integer end, @Param(value = "startTime") String startTime,
			@Param(value = "endTime") String endTime, @Param(value = "faulttype") String faulttype,
			@Param(value = "equipmentname") String equipmentname, @Param("address") String address);
	
	List<BusFault> selectTerminalFault(@Param(value = "id") Integer id,
			@Param(value = "organizationId") Integer organizationId, @Param(value = "status") Integer status,
			@Param(value = "end") Integer end, @Param(value = "startTime") String startTime,
			@Param(value = "endTime") String endTime, @Param(value = "faulttype") String faulttype,
			@Param(value = "equipmentname") String equipmentname, @Param("address") String address,
			@Param(value = "startindex") int startindex, @Param(value = "endindex") int endindex);

	int selectByTerminalFaultCount(@Param(value = "id") Integer id,
			@Param(value = "organizationId") Integer organizationId, @Param(value = "status") Integer status,
			@Param(value = "end") Integer end, @Param(value = "startTime") String startTime,
			@Param(value = "endTime") String endTime, @Param(value = "faulttype") String faulttype,
			@Param(value = "equipmentname") String equipmentname, @Param("address") String address);


	List<BusFault> selectEquipmentFault(@Param(value = "amdition") String amdition,
			@Param(value = "terdition") String terdition, @Param(value = "id") Integer id,
			@Param(value = "organizationId") Integer organizationId, @Param(value = "status") Integer status,
			@Param(value = "end") Integer end, @Param(value = "startTime") String startTime,
			@Param(value = "endTime") String endTime, @Param(value = "faulttype") String faulttype,
			@Param(value = "equipmentname") String equipmentname, @Param("address") String address,
			@Param(value = "startindex") int startindex, @Param(value = "endindex") int endindex);

	int selectByEquipmentFaultCount(@Param(value = "amdition") String amdition,
			@Param(value = "terdition") String terdition, @Param(value = "id") Integer id,
			@Param(value = "organizationId") Integer organizationId, @Param(value = "status") Integer status,
			@Param(value = "end") Integer end, @Param(value = "startTime") String startTime,
			@Param(value = "endTime") String endTime, @Param(value = "faulttype") String faulttype,
			@Param(value = "equipmentname") String equipmentname, @Param("address") String address);

	List<BusFault> selectRegionFault(@Param(value = "id") Integer id,
			@Param(value = "organizationId") Integer organizationId, @Param(value = "status") Integer status,
			@Param(value = "end") Integer end, @Param(value = "startTime") String startTime,
			@Param(value = "endTime") String endTime, @Param(value = "faulttype") String faulttype,
			@Param(value = "equipmentname") String equipmentname, @Param("address") String address,
			@Param(value = "startindex") int startindex, @Param(value = "endindex") int endindex);

	int selectByRegionFaultCount(@Param(value = "id") Integer id,
			@Param(value = "organizationId") Integer organizationId, @Param(value = "status") Integer status,
			@Param(value = "end") Integer end, @Param(value = "startTime") String startTime,
			@Param(value = "endTime") String endTime, @Param(value = "faulttype") String faulttype,
			@Param(value = "equipmentname") String equipmentname, @Param("address") String address);

	List<BusFault> statisticsFaultList(@Param(value = "organizationId") Integer organizationId,
			@Param(value = "id") Integer id, @Param("year") String year, @Param("month") String month,
			@Param("day") String day, @Param("hour") String hour);

	List<BusFault> measureFaultList(@Param(value = "terdition") String terdition,
			@Param(value = "amdition") String amdition, @Param(value = "organizationId") Integer organizationId,
			@Param(value = "id") Integer id, @Param("year") String year, @Param("month") String month,
			@Param("day") String day, @Param("hour") String hour);

	List<BusFault> terminalFaultList(@Param(value = "organizationId") Integer organizationId,
			@Param(value = "id") Integer id, @Param("year") String year, @Param("month") String month,
			@Param("day") String day, @Param("hour") String hour);
	
	List<BusFault> ammeterFaultList(@Param(value = "organizationId") Integer organizationId,
			@Param(value = "id") Integer id, @Param("year") String year, @Param("month") String month,
			@Param("day") String day, @Param("hour") String hour);
	
	Terminal getTerminalNameByEquipId(@Param(value = "equipId") Integer equipId);
	
	MbAmmeter getAmmeterNameByEquipId(@Param(value = "equipId") Integer equipId);
}