package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.EarlyWarnMX;
import com.ssm.wssmb.model.EarlyWarning;
import com.ssm.wssmb.model.EarlyWarningData;

public interface EarlyWarningMapper {

	EarlyWarning selectByPrimaryKey(Integer id);

	int updateEndTime(@Param(value = "id") Integer id);

	int updateByPrimaryKeySelective(EarlyWarning record);

	/**
	 * @Description 根据预警id和事件发生类型查询数据详情
	 * @param id            预警id
	 * @param eventdatatype 1:事件发送时数据 2: 事件结束时数据
	 * @return
	 * @Time
	 * @Author
	 */
	public List<EarlyWarnMX> selectEarlyMXByEarlyIdAndType(@Param(value = "id") Integer id,
			@Param(value = "eventdatatype") Integer eventdatatype);

	/**
	 *
	 * @Description 获取所有告警
	 * @param organizationId
	 * @param status
	 * @param end
	 * @param startTime
	 * @param endTime
	 * @param alarmtype
	 * @param equipmentname
	 * @param address
	 * @param startindex
	 * @param endindex
	 * @return
	 * @author rcd
	 */
	List<EarlyWarning> selectByQueryEarly(@Param(value = "organizationId") Integer organizationId,
			@Param(value = "startTime") String startTime, @Param(value = "endTime") String endTime,
			@Param(value = "equipmentname") String equipmentname, @Param("address") String address,
			@Param(value = "startindex") int startindex, @Param(value = "endindex") int endindex);

	int selectByQueryEarlyCount(@Param(value = "organizationId") Integer organizationId,
			@Param(value = "startTime") String startTime, @Param(value = "endTime") String endTime,
			@Param(value = "equipmentname") String equipmentname, @Param("address") String address);

	//根据区域获取告警
	List<EarlyWarning> selectRegionEarly(@Param(value = "id") Integer id, @Param(value = "startTime") String startTime,
			@Param(value = "endTime") String endTime, @Param(value = "equipmentname") String equipmentname,
			@Param("address") String address, @Param(value = "startindex") int startindex,
			@Param(value = "endindex") int endindex);

	int selectByRegionEarlyCount(@Param(value = "id") Integer id, @Param(value = "startTime") String startTime,
			@Param(value = "endTime") String endTime, @Param(value = "equipmentname") String equipmentname,
			@Param("address") String address);

	List<EarlyWarning> selectAmmeterEarly(@Param(value = "id") Integer id,
			@Param(value = "organizationId") Integer organizationId, @Param(value = "status") Integer status,
			@Param(value = "end") Integer end, @Param(value = "startTime") String startTime,
			@Param(value = "endTime") String endTime, @Param(value = "alarmtype") String alarmtype,
			@Param(value = "equipmentname") String equipmentname, @Param("address") String address,
			@Param(value = "startindex") int startindex, @Param(value = "endindex") int endindex);

	int selectByAmmeterEarlyCount(@Param(value = "id") Integer id,
			@Param(value = "organizationId") Integer organizationId, @Param(value = "status") Integer status,
			@Param(value = "end") Integer end, @Param(value = "startTime") String startTime,
			@Param(value = "endTime") String endTime, @Param(value = "alarmtype") String alarmtype,
			@Param(value = "equipmentname") String equipmentname, @Param("address") String address);

	List<EarlyWarning> selectTerminalEarly(@Param(value = "id") Integer id,
			@Param(value = "organizationId") Integer organizationId, @Param(value = "status") Integer status,
			@Param(value = "end") Integer end, @Param(value = "startTime") String startTime,
			@Param(value = "endTime") String endTime, @Param(value = "alarmtype") String alarmtype,
			@Param(value = "equipmentname") String equipmentname, @Param("address") String address,
			@Param(value = "startindex") int startindex, @Param(value = "endindex") int endindex);

	int selectByTerminalEarlyCount(@Param(value = "id") Integer id,
			@Param(value = "organizationId") Integer organizationId, @Param(value = "status") Integer status,
			@Param(value = "end") Integer end, @Param(value = "startTime") String startTime,
			@Param(value = "endTime") String endTime, @Param(value = "alarmtype") String alarmtype,
			@Param(value = "equipmentname") String equipmentname, @Param("address") String address);

	List<EarlyWarning> selectEquipmentEarly(@Param(value = "id") Integer id,
			@Param(value = "startTime") String startTime, @Param(value = "endTime") String endTime,
			@Param(value = "equipmentname") String equipmentname, @Param("address") String address,
			@Param(value = "startindex") int startindex, @Param(value = "endindex") int endindex);

	int selectByEquipmentEarlyCount(@Param(value = "id") Integer id, @Param(value = "startTime") String startTime,
			@Param(value = "endTime") String endTime, @Param(value = "equipmentname") String equipmentname,
			@Param("address") String address);

	EarlyWarning getWarnByMeasureAddress(@Param(value = "measureAddress") String measureAddress);

	List<EarlyWarning> statisticsAlarmRate(@Param(value = "organizationId") Integer organizationId,
			@Param(value = "id") Integer id, @Param(value = "year") String year, @Param(value = "month") String month,
			@Param(value = "day") String day, @Param(value = "hour") String hour,
			@Param(value = "alarmtype") String alarmtype);

	List<EarlyWarning> ammeterStatic(@Param(value = "organizationId") Integer organizationId,
			@Param(value = "id") Integer id, @Param(value = "year") String year, @Param(value = "month") String month,
			@Param(value = "day") String day, @Param(value = "hour") String hour,
			@Param(value = "alarmtype") String alarmtype);

	List<EarlyWarning> terminalStatic(@Param(value = "organizationId") Integer organizationId,
			@Param(value = "id") Integer id, @Param(value = "year") String year, @Param(value = "month") String month,
			@Param(value = "day") String day, @Param(value = "hour") String hour,
			@Param(value = "alarmtype") String alarmtype);

	List<EarlyWarning> concentratorStatic(@Param(value = "organizationId") Integer organizationId,
			@Param(value = "id") Integer id, @Param(value = "year") String year, @Param(value = "month") String month,
			@Param(value = "day") String day, @Param(value = "hour") String hour,
			@Param(value = "alarmtype") String alarmtype);

	List<EarlyWarning> measureStatic(@Param(value = "organizationId") Integer organizationId,
			@Param(value = "id") Integer id, @Param(value = "year") String year, @Param(value = "month") String month,
			@Param(value = "day") String day, @Param(value = "hour") String hour,
			@Param(value = "alarmtype") String alarmtype);

	List<EarlyWarning> regionStatic(@Param(value = "organizationId") Integer organizationId,
			@Param(value = "id") Integer id, @Param(value = "year") String year, @Param(value = "month") String month,
			@Param(value = "day") String day, @Param(value = "hour") String hour,
			@Param(value = "alarmtype") String alarmtype);

	String getTerminalName(@Param("equipId") Integer equipId);

	String getAmmterName(@Param("equipId") Integer equipId);

	String getTerminalInstall(@Param("equipId") Integer equipId);

	String getAmmeterInstall(@Param("equipId") Integer equipId);

	/**
	 * @Description 查询预警同期对比图形数据
	 * @param earlyComparisonBar 预警同期对比图形查询对象
	 * @param list               区域集合
	 * @return
	 * @Time 2018年3月1日
	 * @Author wys
	 */
	public List<EarlyWarningData> getEarlyComparison(@Param(value = "organizationId") Integer organizationId,
			@Param(value = "id") Integer id, @Param(value = "dateType") String dateType,
			@Param(value = "equalTime") String[] equalTime);

}