package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.ViewEquipmentstatus;

public interface ViewEquipmentstatusMapper {
	List<ViewEquipmentstatus> selectList(@Param("status") String status, @Param("equipmenttype") String[] equipmenttype,
			@Param("equipmentname") String equipmentname);

}