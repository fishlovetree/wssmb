package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.Concentrator;
import com.ssm.wssmb.model.MeasureFile;

public interface ConcentratorMapper {

	// 根据组织结构id查询集中器
	List<Concentrator> selectList(@Param("organizationId") Integer organizationId);

	// 树点击查询
	List<Concentrator> organizationClickTreeList(@Param("id") Integer id, @Param("name") String name,
			@Param("address") String address);

	List<Concentrator> regionClickTreeList(@Param("id") Integer id);
	
	List<Concentrator> regionClickTreeLists(@Param("id") Integer id, @Param("name") String name,
			@Param("address") String address);

	int insert(Concentrator concentrator);

	int update(Concentrator concentrator);

	int delete(Integer concentratorId);

	int selectCount(int i);

	// 搜索
	List<Concentrator> searchInf(@Param("organizationId") Integer organizationId,
			@Param("ConcentratorName") String ConcentratorName, @Param("Address") String Address,
			@Param(value = "startindex") Integer startindex, @Param(value = "endindex") int endindex);

	int getConcentratorCount(@Param("ConcentratorName") String ConcentratorName, @Param("Address") String Address);

	// 查询表箱下的集中器
	List<Concentrator> getConcentratorByMeasureId(@Param("measureId") Integer measureId);

	int getConcentratorCountByMeasureId(@Param("measureId") Integer measureId);

	// 根据集中器名字查询集中器id
	Integer getConcentratorId(@Param("concentratorName") String concentratorName);

	// 查询表箱下的集中器
	List<Concentrator> getConcentratorByMeasurefile(@Param("measureId") String measureId);

	// 根据集中器id获取集中器
	Concentrator getConcentratorByid(@Param("concentratorId") int concentratorId);

	int getCodeByName(String concentratorName);

	// 获取所有集中器的地址
	String[] getAllAddress();

	// 根据集中器id获取集中器
	List<Concentrator> getByIdAndType(@Param("id") Integer id, @Param("name") String name,
			@Param("address") String address);

	// 根据表箱ID查询集中器
	List<Concentrator> getConcentratorAndNameByMeasureId(@Param("measureId") String measureId,
			@Param("name") String name, @Param("address") String address);
}
