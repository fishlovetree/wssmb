package com.ssm.wssmb.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import com.ssm.wssmb.model.EarlyWarnAnnex;
import com.ssm.wssmb.model.EarlyWarnMX;
import com.ssm.wssmb.model.EarlyWarning;
import com.ssm.wssmb.model.EarlyWarningData;
import com.ssm.wssmb.util.ResponseResult;

public interface EarlyWarnService {

	/**
	 * @Description 查询预警
	 * @param queryEarly
	 * @return
	 * @Time
	 * @Author
	 */
	public String queryEarly(Integer id, Integer type, Integer organizationId, String startTime, String endTime,
			String equipmentname, String address, int startindex, int endindex) throws Exception;

	/**
	 * @Description 结束告警
	 * @param id
	 * @return
	 * @Time
	 * @Author
	 */
	public String endEarlyWarning(String id);

	/**
	 * @Description 处理预警
	 * @param earlyWarning
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author
	 */
	public boolean processEarly(String sessionname, EarlyWarning earlyWarning, MultipartFile annex) throws Exception;

	/**
	 * @Description 根据预警id和数据类型查询数据详情
	 * @param alarmId   预警id
	 * @param dataType  事件数据类型 1:事件发送时数据 2: 事件结束时数据
	 * @param alarmType 事件类型id
	 * @return
	 * @Time
	 * @Author
	 */
	public List<EarlyWarnMX> queryEarlyDataDetails(Integer alarmId, Integer dataType, Integer alarmType);

	public ResponseResult getHistoryAlarm(int orgId);

	public List<EarlyWarning> statisticsAlarmList(Integer organizationId, Integer id, Integer type, String year,
			String month, String day, String hour, String alarmtype) throws Exception;

	public Map<Integer, Map<Integer, String[]>> statisticsAlarmRate(Integer organizationId, Integer id, Integer type,
			String year, String month, String day, String hour, String alarmtype) throws Exception;

	/**
	 * @Description 通过预警id获取预警附件
	 * @param earlyId
	 * @return
	 * @Time 2018年2月2日
	 * @Author wys
	 */
	public EarlyWarnAnnex getEarlyAnnaxByEarlyId(Integer earlyId);

	public ResponseResult getHistoryFault(int orgId);

	public ResponseResult getOfflineInfo(int orgId);

	public String[] getEqualTime(int equalNumber, String dateType);

	/**
	 * @Description 根据条件获取预警同期对比
	 * @param earlyComparisonBar
	 * @return
	 * @Time 2018年2月2日
	 * @Author wys
	 */
	public List<EarlyWarningData> getEarlyComparison(Integer organizationId, Integer id, String dateType,
			String[] equalTime);

	/**
	 * @Description 获取预警同期对比柱形图json字符串
	 * @param list
	 * @return
	 * @Time 2018年2月2日
	 * @Author wys
	 */
	public String getComparisonBarDataStr(List<EarlyWarningData> list, String[] equalTime);

	/**
	 * @Description 获取预警类型名称
	 * @return
	 * @Time 2018年1月23日
	 * @Author wys
	 */
	public String[] getEarlyWarningTypeName();

}
