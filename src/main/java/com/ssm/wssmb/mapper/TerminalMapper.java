package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.Terminal;

public interface TerminalMapper {

	// 获取消防终端列表
	List<Terminal> selectList(@Param("organizationId") Integer organizationId);

	// 树点击查询
	List<Terminal> organizationClickTreeList(@Param("id") Integer id, @Param("name") String name,
			@Param("address") String address);

	List<Terminal> regionClickTreeList(@Param("id") Integer id, @Param("name") String name,
			@Param("address") String address);

	int insert(Terminal terminal);

	int update(Terminal terminal);

	int delete(Terminal record);

	// 搜索
	List<Terminal> searchInf(@Param("organizationId") Integer organizationId,
			@Param("terminalName") String terminalName, @Param("address") String address,
			@Param(value = "startindex") Integer startindex, @Param(value = "endindex") int endindex);

	int getTerminalCount(@Param("terminalName") String terminalName, @Param("address") String address);

	int selectCount(int i);

	int getTerminalCountByMeasureId(@Param("measureId") Integer measureId);

	List<Terminal> getTerminalWarnByMeasureId(@Param("measureId") int measureId);

	List<Terminal> getTerminalFaultByMeasureId(@Param("measureId") int measureId);

	List<Terminal> getTerminalMessageByMeasureId(@Param("measureId") int measureId);

	/**
	 * @Description 通过设备ids设备列表(档案管理-下发档案)
	 * @param 设备ID
	 * @return 设备列表
	 * @Time 2018年12月26日
	 * @Author dj
	 */
	List<Terminal> getTerminalListByIDs(@Param("ids") String[] ids);

	// 根据设备地址获取设备
	Terminal selectByAddress(@Param("address") String address);

	// 获取所有
	String[] getAllAddress();

	/**
	 * 获取实时曲线方法，根据id和type获取设备
	 */
	List<Terminal> selectByIdAndType(@Param("equipmentid") Integer equipmentid);

	/**
	 * @Description 通过表箱Id获取监测终端
	 * @param 表箱ID
	 * @return 监测终端列表
	 * @Time 2019年9月29日
	 * @Author hxl
	 */
	List<Terminal> getTerminalByMeasureId(@Param("measureId") int measureId);

	Terminal queryTerminalByAddress(String address);

	// 根据表箱ID获取终端和其他信息
	List<Terminal> getTerminalAndNameByMeasureId(@Param("measureId") int measureId, @Param("name") String name,
			@Param("address") String address);

	// 根据集中器ID获取终端和其他信息
	List<Terminal> getTerminalAndNameByConcentratorId(@Param("id") int id, @Param("name") String name,
			@Param("address") String address);

	// 根据终端ID获取终端和其他信息
	List<Terminal> getTerminalAndNameByTerminalId(@Param("id") int id);

	List<Terminal> getTerminalAndNameByTerminalIds(@Param("id") int id, @Param("name") String name,
			@Param("address") String address);

}
