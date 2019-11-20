package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.Elecdayfreezedata;
import com.ssm.wssmb.model.Elecrealtimefreezedata;

public interface BusFreezedataMapper {

	/**
	 * 根据设备地址和选取时间获取冻结主表id rcd
	 */
	List<Integer> getDayIdByEquipmentAddress(@Param("equipmentaddress") String equipmentaddress,
			@Param("type") Integer type, @Param("startdate") String startdate, @Param("enddate") String enddate);

	/**
	 * 获取设备冻结数据 rcd
	 */
	List<Elecdayfreezedata> getDayFreezeData(@Param("id") Integer id, @Param("name") String name);
	
	/**
	 * 根据设备地址和选取时间获取实时数据主表id rcd
	 */
	List<Integer> getRealIdByEquipmentAddress(@Param("equipmentaddress") String equipmentaddress,
			@Param("type") Integer type, @Param("startdate") String startdate, @Param("enddate") String enddate);

	/**
	 * 获取设备实时数据 rcd
	 */
	List<Elecdayfreezedata> getRealFreezeData(@Param("id") Integer id, @Param("name") String name);

	String getRealtimePsitiveelectricity(@Param("equipmentaddress") String equipmentaddress);

	Elecrealtimefreezedata getTerminalDataForVirtual(@Param("equipmentaddress") String equipmentaddress);

}