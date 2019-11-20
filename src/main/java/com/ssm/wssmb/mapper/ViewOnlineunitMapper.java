package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.ViewOnlineunit;

public interface ViewOnlineunitMapper {

	List<ViewOnlineunit> selectList(@Param("id") Integer id, @Param("organizationId") Integer organizationId);

	List<ViewOnlineunit> selectTerminalList(@Param("id") Integer id, @Param("organizationId") Integer organizationId);

	List<ViewOnlineunit> selectListEquipmentList(@Param("terdition") String terdition,
			@Param("amdition") String amdition, @Param("condition") String condition, @Param("id") Integer id,
			@Param("organizationId") Integer organizationId);

	List<ViewOnlineunit> selectRegionList(@Param("id") Integer id, @Param("organizationId") Integer organizationId);

	List<ViewOnlineunit> getConcentratorList(@Param("organizationId") Integer organizationId, @Param("id") Integer id,
			@Param("status") String status, @Param("startindex") Integer startindex,
			@Param("endindex") Integer endindex);

	int getConcentratorCount(@Param("organizationId") Integer organizationId, @Param("id") Integer id,
			@Param("status") String status);

	List<ViewOnlineunit> getConcentratorListById(@Param("tdition") String tdition,
			@Param("organizationId") Integer organizationId, @Param("id") Integer id, @Param("status") String status,
			@Param("startindex") Integer startindex, @Param("endindex") Integer endindex);

	int getConcentratorCountById(@Param("tdition") String tdition, @Param("organizationId") Integer organizationId,
			@Param("id") Integer id, @Param("status") String status);

	List<ViewOnlineunit> getTerminalListById(@Param("tdition") String tdition,
			@Param("organizationId") Integer organizationId, @Param("id") Integer id, @Param("status") String status,
			@Param("startindex") Integer startindex, @Param("endindex") Integer endindex);

	int getTerminalCountById(@Param("tdition") String tdition, @Param("organizationId") Integer organizationId,
			@Param("id") Integer id, @Param("status") String status);

	List<ViewOnlineunit> getAmmeterListById(@Param("tdition") String tdition,
			@Param("organizationId") Integer organizationId, @Param("id") Integer id, @Param("status") String status,
			@Param("startindex") Integer startindex, @Param("endindex") Integer endindex);

	int getAmmeterCountById(@Param("tdition") String tdition, @Param("organizationId") Integer organizationId,
			@Param("id") Integer id, @Param("status") String status);

	List<ViewOnlineunit> getTerminalList(@Param("organizationId") Integer organizationId, @Param("id") Integer id,
			@Param("status") String status, @Param("startindex") Integer startindex,
			@Param("endindex") Integer endindex);

	int getTerminalCount(@Param("organizationId") Integer organizationId, @Param("id") Integer id,
			@Param("status") String status);

	List<ViewOnlineunit> getAmmeterList(@Param("organizationId") Integer organizationId, @Param("id") Integer id,
			@Param("status") String status, @Param("startindex") Integer startindex,
			@Param("endindex") Integer endindex);

	int getAmmeterCount(@Param("organizationId") Integer organizationId, @Param("id") Integer id,
			@Param("status") String status);

	List<ViewOnlineunit> getAllList(@Param("organizationId") Integer organizationId, @Param("id") Integer id,
			@Param("status") String status, @Param("startindex") Integer startindex,
			@Param("endindex") Integer endindex);

	int getAllCount(@Param("organizationId") Integer organizationId, @Param("id") Integer id,
			@Param("status") String status);

	List<ViewOnlineunit> getAllListById(@Param("cdition") String cdition, @Param("tdition") String tdition,
			@Param("adition") String adition, @Param("organizationId") Integer organizationId, @Param("id") Integer id,
			@Param("status") String status, @Param("startindex") Integer startindex,
			@Param("endindex") Integer endindex);

	int getAllCountById(@Param("cdition") String cdition, @Param("tdition") String tdition,
			@Param("adition") String adition, @Param("organizationId") Integer organizationId, @Param("id") Integer id,
			@Param("status") String status);
	
	//根据id和树节点获取在线信息
	ViewOnlineunit getUnitRowByID(@Param("unitid")Integer unitid,@Param("type")Integer type);
	
	List<ViewOnlineunit> selectOrganizationList(@Param("id") Integer id);	

}