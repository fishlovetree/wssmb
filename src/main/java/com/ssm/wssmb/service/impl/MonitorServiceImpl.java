package com.ssm.wssmb.service.impl;

import java.security.spec.ECField;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ws.data698.PIID_ACD;

import net.sf.ehcache.search.aggregator.Count;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.ssm.wssmb.mapper.AmmeterStatusMapper;
import com.ssm.wssmb.mapper.BusFreezedataMapper;
import com.ssm.wssmb.mapper.ConcentratorMapper;
import com.ssm.wssmb.mapper.MbAmmeterMapper;
import com.ssm.wssmb.mapper.PowerQualityAnalysisMapper;
import com.ssm.wssmb.mapper.TerminalMapper;
import com.ssm.wssmb.mapper.ViewEquipmentstatusMapper;
import com.ssm.wssmb.mapper.ViewOnlineunitMapper;
import com.ssm.wssmb.model.AmmeterStatus;
import com.ssm.wssmb.model.Concentrator;
import com.ssm.wssmb.model.Elecdayfreezedata;
import com.ssm.wssmb.model.Elecrealtimefreezedata;
import com.ssm.wssmb.model.MbAmmeter;
import com.ssm.wssmb.model.PowerQualityAnalysis;
import com.ssm.wssmb.model.Terminal;
import com.ssm.wssmb.model.ViewEquipmentstatus;
import com.ssm.wssmb.model.ViewOnlineunit;
import com.ssm.wssmb.service.MonitorService;
import com.ssm.wssmb.service.UntilService;

@Service
public class MonitorServiceImpl implements MonitorService {

	@Autowired
	ViewOnlineunitMapper unitonlineMapper;

	@Resource
	private UntilService untilService;

	@Resource
	private ViewEquipmentstatusMapper equipmentstatusMapper;

	@Resource
	private BusFreezedataMapper freezedataMapper;

	@Autowired
	PowerQualityAnalysisMapper powerQualityAnalysisMapper;

	@Autowired
	ConcentratorMapper concentratorMapper;

	@Autowired
	AmmeterStatusMapper ammeterStatusMapper;

	@Autowired
	TerminalMapper terminalMapper;

	@Autowired
	MbAmmeterMapper ammeterMapper;

	@Override
	public Map<String, String[]> unitonline(Integer organizationId, Integer id, Integer type) throws Exception {
		List<ViewOnlineunit> onlinelist = getUnitFileList(organizationId, id, type);

		Map<String, String[]> map = new HashMap<>();
		for (ViewOnlineunit online : onlinelist) {
			String[] tempList = map.get(online.getType());
			int on = 0, off = 0, total = 0;
			/* 如果取不到数据,那么直接new一个空的ArrayList */
			if (tempList == null) {
				tempList = new String[] { "", "0", "0", "0" };
			} else {
				on = Integer.parseInt(tempList[1]);
				off = Integer.parseInt(tempList[2]);
				total = Integer.parseInt(tempList[3]);
			}

			tempList[0] = online.getTypename();// 类型名

			if (online.getStatus() == 1)
				tempList[1] = Integer.toString(on + 1);// 在线数
			else
				tempList[2] = Integer.toString(off + 1);// 离线数

			tempList[3] = Integer.toString(total + 1);// 总数
			map.put(online.getType(), tempList);
		}
		return map;
	}

	@Override
	public List<ViewOnlineunit> getUnitFileList(Integer organizationId, Integer id, Integer type) throws Exception {
		List<ViewOnlineunit> list = new ArrayList<ViewOnlineunit>();
		List<String> terminalDition = new ArrayList<String>();
		List<String> ammeterDition = new ArrayList<String>();
		List<String> concentratorDition = new ArrayList<String>();
		if (id == null && type == null) {
			list = unitonlineMapper.selectList(id, organizationId);
		} else {
			if (type == 5) {// 终端
				list = unitonlineMapper.selectTerminalList(id, organizationId);
			}
			if (type == 4) {// 集中器
				terminalDition.add("t.concentratorId=#{id,jdbcType=INTEGER}");
				ammeterDition.add("a.concentratorCode=#{id,jdbcType=INTEGER}");
				concentratorDition.add("c.concentratorId=#{id,jdbcType=INTEGER}");
				String terdition = StringUtils.join(terminalDition.toArray());
				String amdition = StringUtils.join(ammeterDition.toArray());
				String condition = StringUtils.join(concentratorDition.toArray());
				list = unitonlineMapper.selectListEquipmentList(terdition, amdition, condition, id, organizationId);
			}
			if (type == 3) {// 表箱
				terminalDition.add("t.measureId=#{id,jdbcType=INTEGER}");
				ammeterDition.add("a.boxCode=#{id,jdbcType=INTEGER}");
				concentratorDition.add("c.measureId=#{id,jdbcType=INTEGER}");
				String terdition = StringUtils.join(terminalDition.toArray());
				String amdition = StringUtils.join(ammeterDition.toArray());
				String condition = StringUtils.join(concentratorDition.toArray());
				list = unitonlineMapper.selectListEquipmentList(terdition, amdition, condition, id, organizationId);
			}
			if (type == 2) {// 区域
				list = unitonlineMapper.selectRegionList(id, organizationId);
			}
			if (type == 1) {
				list = unitonlineMapper.selectOrganizationList(id);
			}
		}
		return list;
	}

	/**
	 * rcd
	 */
	@Override
	public String getUnitFilePage(Integer organizationId, Integer id, String status, Integer unittype, Integer type,
			Integer startindex, Integer endindex) throws Exception {
		List<ViewOnlineunit> list = new ArrayList<ViewOnlineunit>();
		int count = 0;
		startindex = startindex - 1;
		List<String> dition = new ArrayList<String>();
		if (id == null) {// id为空时，设为中国
			id = 100000;
		}
		if (type == null) {
			type = 2;
		}
		if (unittype == 0) {// 总计
			if (type == 2) {
				list = unitonlineMapper.getAllList(organizationId, id, status, startindex, endindex);
				count = unitonlineMapper.getAllCount(organizationId, id, status);
			}
			if (type == 3) {// 根据表箱id
				dition.add("c.measureId=#{id,jdbcType=INTEGER}");
				String cdition = StringUtils.join(dition.toArray());
				dition.remove(0);
				dition.add("t.measureId=#{id,jdbcType=INTEGER}");
				String tdition = StringUtils.join(dition.toArray());
				dition.remove(0);
				dition.add("a.boxCode=#{id,jdbcType=INTEGER}");
				String adition = StringUtils.join(dition.toArray());
				list = unitonlineMapper.getAllListById(cdition, tdition, adition, organizationId, id, status,
						startindex, endindex);
				count = unitonlineMapper.getAllCountById(cdition, tdition, adition, organizationId, id, status);
			}
			if (type == 4) {// 集中器
				dition.add("c.concentratorId=#{id,jdbcType=INTEGER}");
				String cdition = StringUtils.join(dition.toArray());
				dition.remove(0);
				dition.add("t.concentratorId=#{id,jdbcType=INTEGER}");
				String tdition = StringUtils.join(dition.toArray());
				dition.remove(0);
				dition.add("a.concentratorCode=#{id,jdbcType=INTEGER}");
				String adition = StringUtils.join(dition.toArray());
				list = unitonlineMapper.getAllListById(cdition, tdition, adition, organizationId, id, status,
						startindex, endindex);
				count = unitonlineMapper.getAllCountById(cdition, tdition, adition, organizationId, id, status);
			}
			if (type == 5) {// 终端
//				list = unitonlineMapper.getAllTerminalByternimalId(organizationId, id, status, startindex, endindex);
				dition.add("c.concentratorId=0");
				String cdition = StringUtils.join(dition.toArray());
				dition.remove(0);
				dition.add("t.terminalId=#{id,jdbcType=INTEGER}");
				String tdition = StringUtils.join(dition.toArray());
				dition.remove(0);
				dition.add("a.id=0");
				String adition = StringUtils.join(dition.toArray());
				list = unitonlineMapper.getAllListById(cdition, tdition, adition, organizationId, id, status,
						startindex, endindex);
				count = unitonlineMapper.getAllCountById(cdition, tdition, adition, organizationId, id, status);
			}
		}
		if (unittype == 1) {// 集中器
			if (type == 2) {
				list = unitonlineMapper.getConcentratorList(organizationId, id, status, startindex, endindex);
				count = unitonlineMapper.getConcentratorCount(organizationId, id, status);
			}
			if (type == 3) {// 根据表箱id
				dition.add("c.measureId=#{id,jdbcType=INTEGER}");
				String tdition = StringUtils.join(dition.toArray());
				list = unitonlineMapper.getConcentratorListById(tdition, organizationId, id, status, startindex,
						endindex);
				count = unitonlineMapper.getConcentratorCountById(tdition, organizationId, id, status);
			}
			if (type == 4) {// 根据集中器id
				dition.add("c.concentratorId=#{id,jdbcType=INTEGER}");
				String tdition = StringUtils.join(dition.toArray());
				list = unitonlineMapper.getConcentratorListById(tdition, organizationId, id, status, startindex,
						endindex);
				count = unitonlineMapper.getConcentratorCountById(tdition, organizationId, id, status);
			}
		}
		if (unittype == 2) {// 终端
			if (type == 2) {
				list = unitonlineMapper.getTerminalList(organizationId, id, status, startindex, endindex);
				count = unitonlineMapper.getTerminalCount(organizationId, id, status);
			}
			if (type == 3) {// 根据表箱id
				dition.add("t.measureId=#{id,jdbcType=INTEGER}");
				String tdition = StringUtils.join(dition.toArray());
				list = unitonlineMapper.getTerminalListById(tdition, organizationId, id, status, startindex, endindex);
				count = unitonlineMapper.getTerminalCountById(tdition, organizationId, id, status);
			}
			if (type == 4) {// 根据集中器id
				dition.add("t.concentratorId=#{id,jdbcType=INTEGER}");
				String tdition = StringUtils.join(dition.toArray());
				list = unitonlineMapper.getTerminalListById(tdition, organizationId, id, status, startindex, endindex);
				count = unitonlineMapper.getTerminalCountById(tdition, organizationId, id, status);
			}
			if (type == 5) {// 终端
				dition.add("t.terminalId=#{id,jdbcType=INTEGER}");
				String tdition = StringUtils.join(dition.toArray());
				list = unitonlineMapper.getTerminalListById(tdition, organizationId, id, status, startindex, endindex);
				count = unitonlineMapper.getTerminalCountById(tdition, organizationId, id, status);
			}
		}
		if (unittype == 3) {// 电表
			if (type == 2) {
				list = unitonlineMapper.getAmmeterList(organizationId, id, status, startindex, endindex);
				count = unitonlineMapper.getAmmeterCount(organizationId, id, status);
			}
			if (type == 3) {// 根据表箱id
				dition.add("a.boxCode=#{id,jdbcType=INTEGER}");
				String tdition = StringUtils.join(dition.toArray());
				list = unitonlineMapper.getAmmeterListById(tdition, organizationId, id, status, startindex, endindex);
				count = unitonlineMapper.getAmmeterCountById(tdition, organizationId, id, status);
			}
			if (type == 4) {// 根据集中器id
				dition.add("a.concentratorCode=#{id,jdbcType=INTEGER}");
				String tdition = StringUtils.join(dition.toArray());
				list = unitonlineMapper.getAmmeterListById(tdition, organizationId, id, status, startindex, endindex);
				count = unitonlineMapper.getAmmeterCountById(tdition, organizationId, id, status);
			}
		}
		String json = untilService.getDataPager(list, count);
		return json;
	}

	/**
	 * rcd
	 */
	@Override
	public ViewOnlineunit getUnitRowByID(Integer unitid, Integer type) {
		ViewOnlineunit onlineunit = unitonlineMapper.getUnitRowByID(unitid, type);
		Concentrator concentrator = concentratorMapper.getConcentratorByid(unitid);
		onlineunit.setEquipname(concentrator.getConcentratorName());
		onlineunit.setDevicetype(concentrator.getConcentratorType());
		return onlineunit;
	}

	/**
	 * rcd
	 * 
	 * @throws Exception
	 */
	@Override
	public AmmeterStatus getEquipmentRowByID(Integer id, Integer type) throws Exception {
		AmmeterStatus equipmentStatus = new AmmeterStatus();
		equipmentStatus = ammeterStatusMapper.getTerminalStatusById(id, type).get(0);
		if (type == 5) {// 终端
			equipmentStatus.setTypename("监测终端");
			equipmentStatus.setDevicetype(terminalMapper.getTerminalAndNameByTerminalId(id).get(0).getTerminalType());
			equipmentStatus.setLastEarlyWarnTime(ammeterStatusMapper.getLastEarlyWarnTimeByTerminalId(id));
			equipmentStatus.setLastFreezeTime(ammeterStatusMapper.getLastFreezeTimeByTerminalId(equipmentStatus.getAmmeterCode()));
			// 获取最近冻结时间
			String lastFreezeTime = equipmentStatus.getLastFreezeTime();
			if (lastFreezeTime != null) {
				// 判断冻结时间是否是在一天内
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date freezing = sdf.parse(lastFreezeTime);
				Date now = new Date();
				long timecha = now.getTime() - freezing.getTime();
				if (timecha <= 172800000) {// 时间差在一天之内
					equipmentStatus.setStatus(1);
				} else {
					equipmentStatus.setStatus(0);
				}
			}else {
				equipmentStatus.setStatus(0);
			}
		}
		if (type == 6) {// 电表
			equipmentStatus.setTypename("电表");
			MbAmmeter ammeter = ammeterMapper.selectByIdAndType(id).get(0);
			if (ammeter.getAmmeterType().isEmpty()) {
			} else {
				equipmentStatus.setDevicetype(Integer.parseInt(ammeter.getAmmeterType()));
			}
			equipmentStatus.setAmmeterName(ammeter.getAmmeterName());
			equipmentStatus.setAmmeterCode(ammeter.getAmmeterCode());
			equipmentStatus.setInstallAddress(ammeter.getInstallAddress());
			equipmentStatus.setLastEarlyWarnTime(ammeterStatusMapper.getLastEarlyWarnTimeByAmmeterId(id));
			equipmentStatus.setLastFreezeTime(ammeterStatusMapper.getLastFreezeTimeByAmmeterId(equipmentStatus.getAmmeterCode()));
			// 获取最近冻结时间
			String lastFreezeTime = equipmentStatus.getLastFreezeTime();
			if (lastFreezeTime != null) {
				// 判断冻结时间是否是在一天内
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date freezing = sdf.parse(lastFreezeTime);
				Date now = new Date();
				long timecha = now.getTime() - freezing.getTime();
				if (timecha <= 172800000) {// 时间差在一天之内
					equipmentStatus.setStatus(1);
				} else {
					equipmentStatus.setStatus(0);
				}
			}else {
				equipmentStatus.setStatus(0);
			}
		}
		return equipmentStatus;
	}

	/**
	 * rcd
	 */
	@Override
	public String realtimedata(Integer type, String equipmentaddress, String checkbox, String startdate, String enddate)
			throws Exception {
		Gson gson = new GsonBuilder().disableHtmlEscaping().create();
		String json = "";
		if (type == 5) {// 终端对应2
			type = 2;
		}
		if (type == 6) {// 电表对应3
			type = 3;
		}
		checkbox = "1,2,3,4,5,6,7,8,9,a";
		// 根据设备地址和选取时间获取冻结主表id
		List<Integer> id = freezedataMapper.getRealIdByEquipmentAddress(equipmentaddress, type, startdate, enddate);
		StringBuffer columns = new StringBuffer();
		if (checkbox.contains("1")) {
			columns.append("正向有功电能,");
		}
		if (checkbox.contains("2")) {
			columns.append("反向有功电能,");
		}
		if (checkbox.contains("3")) {
			columns.append("电压,");
		}
		if (checkbox.contains("4")) {
			columns.append("电流,");
		}
		if (checkbox.contains("5")) {
			columns.append("有功功率,");
		}
		if (checkbox.contains("6")) {
			columns.append("功率因数,");
		}
		if (checkbox.contains("7")) {
			if (type == 2) {
				columns.append("环境温度,");
			}
			if (type == 3) {
				columns.append("表内温度,");
			}
		}
		if (checkbox.contains("9")) {
			columns.append("空气相对湿度,");
		}
		if (checkbox.contains("a")) {
			columns.append("大气压力,");
		}
		if (checkbox.contains("8")) {
			columns.append("烟感浓度,");
		}
		columns.append("1");
		String name = columns.toString();
		Map<String, Object> map = new HashMap<String, Object>();
		List<Elecdayfreezedata> list = new ArrayList<Elecdayfreezedata>();
		List<Elecdayfreezedata> elecdayfreezedataList = new ArrayList<Elecdayfreezedata>();
		for (int i = 0; i < id.size(); i++) {
			elecdayfreezedataList = freezedataMapper.getRealFreezeData(id.get(i), name);
			list.addAll(elecdayfreezedataList);
		}
		map.put("result", list);
		if (elecdayfreezedataList.size() == 0) {
			map.put("result", null);
		}
		json = gson.toJson(map.get("result"));
		return json;
	}

	/**
	 * rcd
	 */
	@Override
	public String daydata(Integer type, String equipmentaddress, String checkbox, String startdate, String enddate)
			throws Exception {
		Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").disableHtmlEscaping().create();
		String json = "";
		if (type == 5) {// 终端对应2
			type = 2;
		}
		if (type == 6) {// 电表对应3
			type = 3;
		}
		// 根据设备地址和选取时间获取冻结主表id
		List<Integer> id = freezedataMapper.getDayIdByEquipmentAddress(equipmentaddress, type, startdate, enddate);
		// 根据勾选的checkbox获取OI
		StringBuffer columns = new StringBuffer();
		if (checkbox.contains("1")) {
			columns.append("正向有功电能,");
		}
		if (checkbox.contains("2")) {
			columns.append("反向有功电能,");
		}
		if (checkbox.contains("3")) {
			columns.append("电压,");
		}
		if (checkbox.contains("4")) {
			columns.append("电流,");
		}
		if (checkbox.contains("5")) {
			columns.append("有功功率,");
		}
		if (checkbox.contains("6")) {
			columns.append("功率因数,");
		}
		if (checkbox.contains("7")) {
			if (type == 2) {
				columns.append("环境温度,");
			}
			if (type == 3) {
				columns.append("表内温度,");
			}
		}
		if (checkbox.contains("9")) {
			columns.append("空气相对湿度,");
		}
		if (checkbox.contains("a")) {
			columns.append("大气压力,");
		}
		if (checkbox.contains("b")) {
			columns.append("烟感浓度,");
		}
		columns.append("1");
		String name = columns.toString();
		Map<String, Object> map = new HashMap<String, Object>();
		List<Elecdayfreezedata> list = new ArrayList<Elecdayfreezedata>();
		List<Elecdayfreezedata> elecdayfreezedataList = new ArrayList<Elecdayfreezedata>();
		for (int i = 0; i < id.size(); i++) {
			elecdayfreezedataList = freezedataMapper.getDayFreezeData(id.get(i), name);
			list.addAll(elecdayfreezedataList);
		}
		map.put("result", list);
		if (elecdayfreezedataList.size() == 0) {
			map.put("result", null);
		}
		json = gson.toJson(map.get("result"));
		return json;
	}

	/**
	 * rcd
	 */
	@Override
	public String powerdata(Integer id, Integer type, int organizationid, String startdate, String enddate,
			int startindex, int endindex) throws Exception {
		List<PowerQualityAnalysis> list = new ArrayList<PowerQualityAnalysis>();
		int count = 0;
		startindex = startindex - 1;
		if (type == 5) {// 终端
			type = 2;
			list = powerQualityAnalysisMapper.selectTerminalAnalysis(id, organizationid, type, startdate, enddate,
					startindex, endindex);
			count = powerQualityAnalysisMapper.selectTerminalAnalysisCount(id, organizationid, type, startdate, enddate,
					startindex, endindex);
		} else if (type == 6) {// 电表
			type = 3;
			list = powerQualityAnalysisMapper.selectAmmeterAnalysis(id, organizationid, type, startdate, enddate,
					startindex, endindex);
			count = powerQualityAnalysisMapper.selectAmmeterAnalysisCount(id, organizationid, type, startdate, enddate,
					startindex, endindex);
		}
		String json = untilService.getDataPager(list, count);
		return json;
	}

}
