package com.ssm.wssmb.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.ssm.wssmb.mapper.ConstantDetailMapper;
import com.ssm.wssmb.mapper.EarlyWarnAnnexMapper;
import com.ssm.wssmb.mapper.EarlyWarningMapper;
import com.ssm.wssmb.mapper.MbAmmeterMapper;
import com.ssm.wssmb.mapper.MeasureFileMapper;
import com.ssm.wssmb.mapper.TerminalMapper;
import com.ssm.wssmb.model.EarlyWarnAnnex;
import com.ssm.wssmb.model.EarlyWarnMX;
import com.ssm.wssmb.model.EarlyWarning;
import com.ssm.wssmb.model.EarlyWarningData;
import com.ssm.wssmb.model.MbAmmeter;
import com.ssm.wssmb.model.MeasureFile;
import com.ssm.wssmb.model.Terminal;
import com.ssm.wssmb.service.EarlyWarnService;
import com.ssm.wssmb.service.UntilService;
import com.ssm.wssmb.util.EventLogAspect;
import com.ssm.wssmb.util.ResponseResult;

@Service
public class EarlyWarnServiceImpl implements EarlyWarnService {

	@Resource
	private EarlyWarnAnnexMapper earlyWarnAnnexMapper;

	@Autowired
	EarlyWarningMapper earlyWarningMapper;

	@Resource
	MeasureFileMapper measureFileMapper;

	@Resource
	MbAmmeterMapper mbAmmeterMapper;

	@Resource
	TerminalMapper terminalMapper;

	@Resource
	private UntilService untilService;

	@Resource
	private ConstantDetailMapper constantDetailMapper;

	@Resource
	private EventLogAspect log;

	/***
	 * 查询告警
	 *
	 * rcd
	 */
	@Override
	public String queryEarly(Integer id, Integer type, Integer organizationId, String startTime, String endTime,
			String equipmentname, String address, int startindex, int endindex) throws Exception {
		if (null == startTime || startTime.trim().equals("") || null == endTime || endTime.trim().equals("")) {
			Date d = new Date();
			SimpleDateFormat sdfStart = new SimpleDateFormat("yyyy-MM-dd 00:00:00");
			SimpleDateFormat sdfEnd = new SimpleDateFormat("yyyy-MM-dd 23:59:59");
			startTime = sdfStart.format(d);
			endTime = sdfEnd.format(d);
		}
		List<EarlyWarning> list = new ArrayList<EarlyWarning>();
		int count = 0;
		startindex = startindex - 1;
		if (id == null && type == null) {
			list = earlyWarningMapper.selectByQueryEarly(organizationId, startTime, endTime, equipmentname, address,
					startindex, endindex);
			count = earlyWarningMapper.selectByQueryEarlyCount(organizationId, startTime, endTime, equipmentname,
					address);
		} else {
			if (type == 3) {// 表箱
				list = earlyWarningMapper.selectEquipmentEarly(id, startTime, endTime, equipmentname, address,
						startindex, endindex);
				count = earlyWarningMapper.selectByEquipmentEarlyCount(id, startTime, endTime, equipmentname, address);
			}
			if (type == 2) {// 区域
				list = earlyWarningMapper.selectRegionEarly(id, startTime, endTime, equipmentname, address, startindex,
						endindex);
				count = earlyWarningMapper.selectByRegionEarlyCount(id, startTime, endTime, equipmentname, address);
			}
		}
		String json = untilService.getDataPager(list, count);
		return json;
	}

	/**
	 * @Description 结束告警
	 * @param model
	 * @return
	 * @Time
	 * @Author
	 */
	@Override
	public String endEarlyWarning(String id) {
		int result = earlyWarningMapper.updateEndTime(Integer.parseInt(id));
		if (result > 0) {
			EarlyWarning earlyWarning = earlyWarningMapper.selectByPrimaryKey(Integer.parseInt(id));
			if (null != earlyWarning) {
				// 记录操作日志
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				String content = "终端地址：" + earlyWarning.getTerminalAddress() + ", 设备地址："
						+ earlyWarning.getEquipmentaddress() + ", 发生时间："
						+ formatter.format(earlyWarning.getOccurtime());
				log.addLog("wssmb_front_user", "结束告警", content, 2);
			}
			return "success";
		} else {
			return "error";
		}
	}

	@Override
	public boolean processEarly(String sessionname, EarlyWarning earlyWarning, MultipartFile annex) {
		earlyWarning.setStatus(1);// 切换状态为以处理
		try { // 附件转为二进制存储
			int resultAnnex = 1;
			if (!annex.isEmpty()) {
				EarlyWarnAnnex earlyAnnex = new EarlyWarnAnnex(earlyWarning.getId(), annex.getOriginalFilename(),
						annex.getBytes());
				resultAnnex = earlyWarnAnnexMapper.insert(earlyAnnex);
			}
			int result = earlyWarningMapper.updateByPrimaryKeySelective(earlyWarning);
			Gson gson = new Gson();

			String content = "告警处理：" + gson.toJson(earlyWarning) + "，附件：";
			if (StringUtils.isNotBlank(annex.getOriginalFilename())) {
				content += gson.toJson(annex);
			}

			log.addLog(sessionname, "处理告警", content, 2);
			if (result == 1 && resultAnnex == 1)
				return true;
			else
				return false;
		} catch (Exception e) {
			e.printStackTrace();
			log.addErrorLog(sessionname,
					"EarlyWarnServiceImpl：public boolean processEarly(EarlyWarning earlyWarning,MultipartFile annex){}",
					e);
			return false;
		}
	}

	@Override
	public List<EarlyWarnMX> queryEarlyDataDetails(Integer alarmId, Integer dataType, Integer alarmType) {
		return earlyWarningMapper.selectEarlyMXByEarlyIdAndType(alarmId, dataType);
	}

	/**
	 * @Description 查询所有告警
	 * @param model
	 * @return
	 * @Time
	 * @Author
	 */
	@Override
	public ResponseResult getHistoryAlarm(int orgId) {
		List<MeasureFile> historyAlarm = measureFileMapper.getHistoryAlarm(orgId);
		ResponseResult responseResult = new ResponseResult();
		if (historyAlarm != null) {
			for (MeasureFile measureFile : historyAlarm) {
				int measureId = measureFile.getMeasureId();
				List<MbAmmeter> ammeterWarnByMeasureId = mbAmmeterMapper.getAmmeterWarnByMeasureId(measureId);
				measureFile.setMbAmmeterList(ammeterWarnByMeasureId);
				List<Terminal> terminalWarnByMeasureId = terminalMapper.getTerminalWarnByMeasureId(measureId);
				measureFile.setTerminals(terminalWarnByMeasureId);
			}
			responseResult.setRows(historyAlarm);
			responseResult.setTotal(historyAlarm.size());
		}
		responseResult.setCode(200);
		responseResult.setMessage("查询所有告警的表箱成功");
		return responseResult;
	}

	/**
	 * @Description 查询所有故障
	 * @param model
	 * @return
	 * @Time
	 * @Author
	 */
	@Override
	public ResponseResult getHistoryFault(int orgId) {
		List<MeasureFile> historyAlarm = measureFileMapper.getHistoryFault(orgId);
		ResponseResult responseResult = new ResponseResult();
		if (historyAlarm != null) {
			for (MeasureFile measureFile : historyAlarm) {
				int measureId = measureFile.getMeasureId();
				List<MbAmmeter> ammeterWarnByMeasureId = mbAmmeterMapper.getAmmeterFaultByMeasureId(measureId);
				measureFile.setMbAmmeterList(ammeterWarnByMeasureId);
				List<Terminal> terminalWarnByMeasureId = terminalMapper.getTerminalFaultByMeasureId(measureId);
				measureFile.setTerminals(terminalWarnByMeasureId);
			}
			responseResult.setRows(historyAlarm);
			responseResult.setTotal(historyAlarm.size());
		}
		responseResult.setCode(200);
		responseResult.setMessage("查询所有故障的表箱成功");
		return responseResult;
	}

	/**
	 * @Description 查询所有消息
	 * @param model
	 * @return
	 * @Time
	 * @Author
	 */
	@Override
	public ResponseResult getOfflineInfo(int orgId) {
		List<MeasureFile> historyAlarm = measureFileMapper.getHistoryMessage(orgId);
		ResponseResult responseResult = new ResponseResult();
		if (historyAlarm != null) {
			for (MeasureFile measureFile : historyAlarm) {
				int measureId = measureFile.getMeasureId();
				List<MbAmmeter> ammeterWarnByMeasureId = mbAmmeterMapper.getAmmeterMessageByMeasureId(measureId);
				measureFile.setMbAmmeterList(ammeterWarnByMeasureId);
				List<Terminal> terminalWarnByMeasureId = terminalMapper.getTerminalMessageByMeasureId(measureId);
				measureFile.setTerminals(terminalWarnByMeasureId);
			}
			responseResult.setRows(historyAlarm);
			responseResult.setTotal(historyAlarm.size());
		}
		responseResult.setCode(200);
		responseResult.setMessage("查询所有消息的表箱成功");
		return responseResult;
	}

	@Override
	public Map<Integer, Map<Integer, String[]>> statisticsAlarmRate(Integer organizationId, Integer id, Integer type,
			String year, String month, String day, String hour, String alarmtype) throws Exception {
		List<EarlyWarning> list = statisticsAlarmList(organizationId, id, type, year, month, day, hour, alarmtype);

		Map<Integer, Map<Integer, String[]>> map = new HashMap<>();
		for (EarlyWarning alarm : list) {
			if (null != alarm.getType()) {
				Map<Integer, String[]> submap = map.get(alarm.getType());
				if (null == submap)
					submap = new HashMap<>();

				Integer key = alarm.getAlarmtype();
				String[] tempList = submap.get(key);
				/* 如果取不到数据,那么直接new一个空的ArrayList */
				if (tempList == null) {
					tempList = new String[] { alarm.getAlarmName(), "0" };
				}
				tempList[1] = Integer.parseInt(tempList[1]) + 1 + "";
				submap.put(key, tempList);

				map.put(alarm.getType(), submap);
			}
		}
		return map;
	}

	/**
	 * @Description 前台系统-数据分析-告警率-告警统计-列表
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author
	 * @type 前端方法
	 */
	@Override
	public List<EarlyWarning> statisticsAlarmList(Integer organizationId, Integer id, Integer type, String year,
			String month, String day, String hour, String alarmtype) throws Exception {
		List<EarlyWarning> list = new ArrayList<EarlyWarning>();
		if (id == null) {
			id = 100000;
		}
		if (type == null) {
			list = earlyWarningMapper.statisticsAlarmRate(organizationId, id, year, month, day, hour, alarmtype);
			// 根据集合中的type和equipId获取设备名字
			for (EarlyWarning earlyWarning : list) {
				type = earlyWarning.getEquipType();
				Integer equipId = earlyWarning.getEquipId();
				if (type == 2) {
					String equipname = earlyWarningMapper.getTerminalName(equipId);
					earlyWarning.setEquipname(equipname);
					String install = earlyWarningMapper.getTerminalInstall(equipId);
					earlyWarning.setInstallationLocation(install);
				}
				if (type == 3) {
					String equipname = earlyWarningMapper.getAmmterName(equipId);
					earlyWarning.setEquipname(equipname);
					String install = earlyWarningMapper.getAmmeterInstall(equipId);
					earlyWarning.setInstallationLocation(install);
				}
			}
		} else {
			if (type == 6) {// 电表
				list = earlyWarningMapper.ammeterStatic(organizationId, id, year, month, day, hour, alarmtype);
			}
			if (type == 5) {// 终端
				list = earlyWarningMapper.terminalStatic(organizationId, id, year, month, day, hour, alarmtype);
			}
			if (type == 4) {// 集中器
				list = earlyWarningMapper.concentratorStatic(organizationId, id, year, month, day, hour, alarmtype);
			}
			if (type == 3) {// 表箱
				list = earlyWarningMapper.measureStatic(organizationId, id, year, month, day, hour, alarmtype);
			}
			if (type == 2) {// 区域
				list = earlyWarningMapper.regionStatic(organizationId, id, year, month, day, hour, alarmtype);
			}
		}
		return list;
	}

	@Override
	public EarlyWarnAnnex getEarlyAnnaxByEarlyId(Integer earlyId) {
		EarlyWarnAnnex annax = earlyWarnAnnexMapper.selectByEarlyId(earlyId);
		return annax;
	}

	/**
	 * @Description 获取同期对比日期数组
	 * @param number
	 * @param type
	 * @return
	 * @Time
	 * @Author
	 */
	public String[] getEqualTime(int equalNumber, String dateType) {
		String[] equalTime = new String[equalNumber + 1];
		Calendar cal = Calendar.getInstance();
		int year = cal.get(Calendar.YEAR);
		int month = cal.get(Calendar.MONTH) + 1;
		if (dateType.equals("yyyy")) {// 年份
			for (int i = 0; i < equalTime.length; i++) {
				equalTime[i] = String.valueOf((year - i));
			}
		} else {// 月份
			for (int i = 0; i < equalTime.length; i++) {
				String myMonth = (month - i) < 10 ? "0" + (month - i) : String.valueOf(month - i);
				String myMonthX = (month - i + 12) < 10 ? "0" + (month - i + 12) : String.valueOf(month - i + 12);
				if (month - i <= 0)
					equalTime[i] = (year - 1) + "-" + myMonthX;
				else
					equalTime[i] = year + "-" + myMonth;
			}
		}
		return equalTime;
	}

	@Override
	public String getComparisonBarDataStr(List<EarlyWarningData> list, String[] equalTime) {
		// x-预警类型
		String[] arrayName = getEarlyWarningTypeName();
		arrayName = insertElement(arrayName, "其他", arrayName.length);
		// legend:data
		List<Map<String, Object>> seriesList = new LinkedList<Map<String, Object>>();
		List<Map<String, Object>> listPoint = new LinkedList<Map<String, Object>>();
		Gson gson = new GsonBuilder().disableHtmlEscaping().create();
		for (int j = equalTime.length - 1; j >= 0; j--) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("name", equalTime[j]);
			map.put("type", "bar");
			if (null != list && list.size() > 0)
				map.put("data", getDataArray(equalTime[j], list, arrayName));

			else
				map.put("data", listPoint);
			// map.put("markPoint", getPointMap());
			// map.put("markLine", getLineMap());
			map.put("label", gson.fromJson("{ normal: { show: true, position: top } }", Object.class));
			seriesList.add(map);
			// JSONObject allJson = new JSONObject();
			// allJson.put("ww", map);
			// System.out.println(allJson);
		}
		return comparisonBarDataStr(arrayName, equalTime, seriesList);
	}

	@Override
	public String[] getEarlyWarningTypeName() {
		String[] array = constantDetailMapper.selectNameArrayByCoding(1003);
		return array;
	}

	// 数组添加元素
	private static String[] insertElement(String original[], String element, int index) {
		int length = original.length;
		String destination[] = new String[length + 1];
		System.arraycopy(original, 0, destination, 0, index);
		destination[index] = element;
		System.arraycopy(original, index, destination, index + 1, length - index);
		return destination;
	}

	/**
	 * @Description 获取每个月份或年份的数据数组
	 * @param dateName
	 * @param list
	 * @param arrayName
	 * @return
	 * @Time 2018年2月2日
	 * @Author rcd
	 */
	private Integer[] getDataArray(String dateName, List<EarlyWarningData> list, String[] arrayName) {
		Integer[] arrayData = new Integer[arrayName.length];
		for (int i = 0; i < arrayName.length; i++) {
			for (EarlyWarningData earlyWarningData : list) {
				if (arrayName[i].trim().equals(earlyWarningData.getName().trim())
						&& earlyWarningData.getDateStr().trim().equals(dateName)) {
					arrayData[i] = earlyWarningData.getValue();
					break;
				} else {
					arrayData[i] = 0;
				}
			}
		}
		return arrayData;
	}

	/**
	 * @Description 预警同期对比json数据
	 * @param array
	 * @param equalTime
	 * @return
	 * @Time 2018年2月2日
	 * @Author rcd
	 */
	private String comparisonBarDataStr(String[] array, String[] equalTime, List<Map<String, Object>> seriesList) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("xNameJson", array);
		for (int start = 0, end = equalTime.length - 1; start < end; start++, end--) {
			String temp = equalTime[end];
			equalTime[end] = equalTime[start];
			equalTime[start] = temp;
		} // 数组倒序
		map.put("legendData", equalTime);
		map.put("series", seriesList);
		// 将集合转换为json输出到页面
		Gson gson = new GsonBuilder().disableHtmlEscaping().create();
		String json = gson.toJson(map);
		return json;
	}

	@Override
	public List<EarlyWarningData> getEarlyComparison(Integer organizationId, Integer id, String dateType,
			String[] equalTime) {
		if (id == null) {
			id = 100000;
		}
		return earlyWarningMapper.getEarlyComparison(organizationId, id, dateType, equalTime);
	}
}
