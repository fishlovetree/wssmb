package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.MbAmmeter;
import com.ssm.wssmb.model.Organization;
import com.ssm.wssmb.model.Region;
import com.ssm.wssmb.model.Terminal;
import com.ssm.wssmb.model.ViewEquipment;

public interface ViewEquipmentMapper {

	/**
	 * @Description 通过设备id或设备地址获取设备（唯一）
	 * @param equipmentid      设备id
	 * @param equipmentaddress 设备地址
	 * @return
	 * @Time 2018年12月18日
	 * @Author dj
	 */
	List<ViewEquipment> selectByIdOrAddr(@Param("equipmentid") Integer equipmentid,
			@Param("equipmentaddress") String equipmentaddress);

}