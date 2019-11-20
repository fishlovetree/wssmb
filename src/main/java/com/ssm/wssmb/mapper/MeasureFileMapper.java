package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.MeasureFile;

public interface MeasureFileMapper {
	int insert(MeasureFile record);

	// 点击树查询
	List<MeasureFile> organizationClickTreeList(@Param("id") Integer id, @Param("name") String name,
			@Param("number") String number, @Param("address") String address);

	List<MeasureFile> regionClickTreeList(@Param("id") Integer id);
	
	List<MeasureFile> regionClickTreeLists(@Param("id") Integer id, @Param("name") String name,
			@Param("number") String number, @Param("address") String address);

	// 查询表箱列表
	List<MeasureFile> selectList(@Param("organizationId") Integer organizationId);

	int selectCount(int i);

	int update(MeasureFile record);

	int delete(MeasureFile record);

	Integer getOrganizationId(@Param("organizationName") String organizationName);

	// 根据表箱id获取组织机构
	Integer getOrganizationIdByMeasureId(@Param("measureId") Integer measureId);

	// 搜索
	List<MeasureFile> searchInf(@Param("organizationId") Integer organizationId,
			@Param("MeasureName") String MeasureName, @Param("MeasureNumber") String MeasureNumber,
			@Param("Address") String Address, @Param(value = "startindex") Integer startindex,
			@Param(value = "endindex") int endindex);

	int getMeasureFileCount(@Param("MeasureName") String MeasureName, @Param("MeasureNumber") String MeasureNumber,
			@Param("Address") String Address);

	// 查询组织机构下的表箱
	List<MeasureFile> getMeasurefileByOrganizationId(@Param("OrganizationId") Integer OrganizationId);

	// 根据表箱Id获取区域
	int getRegionByMeasureId(@Param("measureId") Integer measureId);

	// 根据表箱名字id
	int getMeasureId(@Param("measureName") String measureName);

	// 查询组织机构下的表箱
	MeasureFile getMeasurefileByMeasureId(@Param("measureId") int measureId);

	int getCodeByName(String measureName);

	// 查询组织机构下表箱，不通过parentid筛选下级组织机构
	List<MeasureFile> getMeasurefileByOrgId(@Param("OrganizationId") Integer OrganizationId);

	List<MeasureFile> getHistoryAlarm(@Param(value = "orgId") int orgId);

	List<MeasureFile> getHistoryFault(@Param(value = "orgId") int orgId);

	List<MeasureFile> getHistoryMessage(@Param(value = "orgId") int orgId);

	// 获取所有表箱的地址
	String[] getAllMeasureNumber();

	// 根据表箱id获取表箱
	List<MeasureFile> getByIdAndType(@Param("id") Integer id, @Param("name") String name,
			@Param("number") String number, @Param("address") String address);

	// 更改表箱门节点状态
	int changeOpenStatus(@Param(value = "openStatus") int openStatus, @Param(value = "measureId") int measureId);

}
