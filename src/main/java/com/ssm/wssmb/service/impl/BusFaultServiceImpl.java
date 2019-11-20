package com.ssm.wssmb.service.impl;

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

import com.google.gson.Gson;
import com.ssm.wssmb.mapper.BusFaultMapper;
import com.ssm.wssmb.model.BusFault;
import com.ssm.wssmb.model.MbAmmeter;
import com.ssm.wssmb.model.Terminal;
import com.ssm.wssmb.service.BusFaultService;
import com.ssm.wssmb.service.UntilService;
import com.ssm.wssmb.util.EventLogAspect;

@Service
public class BusFaultServiceImpl implements BusFaultService {

	@Autowired
	BusFaultMapper faultMapper;

	@Autowired
	UntilService untilService;

	@Resource
	private EventLogAspect log;

	/**
	 * 查询故障 rcd
	 */
	@Override
	public String queryFault(Integer id, Integer type, Integer organizationId, Integer status, Integer end,
			String startTime, String endTime, String faulttype, String equipmentname, String address, int startindex,
			int endindex) throws Exception {
		if (null == startTime || startTime.trim().equals("") || null == endTime || endTime.trim().equals("")) {
			Date d = new Date();
			SimpleDateFormat sdfStart = new SimpleDateFormat("yyyy-MM-dd 00:00:00");
			SimpleDateFormat sdfEnd = new SimpleDateFormat("yyyy-MM-dd 23:59:59");
			startTime = sdfStart.format(d);
			endTime = sdfEnd.format(d);
		}
		startindex = startindex - 1;
		List<BusFault> list = new ArrayList<BusFault>();
		List<String> terminalDition = new ArrayList<String>();
		List<String> ammeterDition = new ArrayList<String>();
		int count = 0;
		if (id == null && type == null) {
			list = faultMapper.queryFault(organizationId, status, end, startTime, endTime, faulttype, equipmentname,
					address, startindex, endindex);
			count = faultMapper.queryFaultCount(organizationId, status, end, startTime, endTime, faulttype,
					equipmentname, address);
		} else {
			if (type == 6) {// 电表
				list = faultMapper.selectAmmeterFault(id, organizationId, status, end, startTime, endTime, faulttype,
						equipmentname, address, startindex, endindex);
				count = faultMapper.selectByAmmeterFaultCount(id, organizationId, status, end, startTime, endTime,
						faulttype, equipmentname, address);
			}
			if (type == 5) {// 终端
				list = faultMapper.selectTerminalFault(id, organizationId, status, end, startTime, endTime, faulttype,
						equipmentname, address, startindex, endindex);
				count = faultMapper.selectByTerminalFaultCount(id, organizationId, status, end, startTime, endTime,
						faulttype, equipmentname, address);
			}
			if (type == 4) {// 集中器
				terminalDition.add("t.concentratorId=#{id,jdbcType=INTEGER}");
				ammeterDition.add("a.concentratorCode=#{id,jdbcType=INTEGER}");
				String terdition = StringUtils.join(terminalDition.toArray());
				String amdition = StringUtils.join(ammeterDition.toArray());
				list = faultMapper.selectEquipmentFault(amdition, terdition, id, organizationId, status, end, startTime,
						endTime, faulttype, equipmentname, address, startindex, endindex);
				count = faultMapper.selectByEquipmentFaultCount(amdition, terdition, id, organizationId, status, end,
						startTime, endTime, faulttype, equipmentname, address);
			}
			if (type == 3) {// 表箱
				terminalDition.add("t.measureId=#{id,jdbcType=INTEGER}");
				ammeterDition.add("a.boxCode=#{id,jdbcType=INTEGER}");
				String terdition = StringUtils.join(terminalDition.toArray());
				String amdition = StringUtils.join(ammeterDition.toArray());
				list = faultMapper.selectEquipmentFault(amdition, terdition, id, organizationId, status, end, startTime,
						endTime, faulttype, equipmentname, address, startindex, endindex);
				count = faultMapper.selectByEquipmentFaultCount(amdition, terdition, id, organizationId, status, end,
						startTime, endTime, faulttype, equipmentname, address);
			}
			if (type == 2) {// 区域
				list = faultMapper.selectRegionFault(id, organizationId, status, end, startTime, endTime, faulttype,
						equipmentname, address, startindex, endindex);
				count = faultMapper.selectByRegionFaultCount(id, organizationId, status, end, startTime, endTime,
						faulttype, equipmentname, address);
			}
		}
		String json = untilService.getDataPager(list, count);
		return json;
	}

	@Override
	public boolean processFault(String sessionname, BusFault fault) {
		fault.setStatus(1);// 切换状态为以处理
		try {
			int result = faultMapper.updateByPrimaryKeySelective(fault);
			Gson gson = new Gson();
			log.addLog(sessionname, "故障排除", "故障排除：" + gson.toJson(fault), 2);
			if (result == 1)
				return true;
			else
				return false;
		} catch (Exception e) {
			e.printStackTrace();
			log.addErrorLog(sessionname, "BusFaultServiceImpl：public boolean processFault(BusFault fault){}", e);
			return false;
		}
	}

	@Override
	public String endFault(String id) {
		int result = faultMapper.updateEndTime(Integer.parseInt(id));

		if (result > 0) {
			return "success";
		} else {
			return "error";
		}
	}

	@Override
	public Map<String, Map<Integer, String[]>> statisticsFaultRate(Integer organizationId, Integer id, Integer type,
			String year, String month, String day, String hour) {
		List<BusFault> list = statisticsFaultList(organizationId, id, type, year, month, day, hour);

		Map<String, Map<Integer, String[]>> map = new HashMap<>();
		for (BusFault fault : list) {
			if (null != fault.getEquipmenttypename()) {
				Map<Integer, String[]> submap = map.get(fault.getEquipmenttypename());
				if (null == submap)
					submap = new HashMap<>();

				Integer key = fault.getFaulttype();
				String[] tempList = submap.get(key);
				/* 如果取不到数据,那么直接new一个空的ArrayList */
				if (tempList == null) {
					tempList = new String[] { fault.getFaultname(), "0" };
				}
				tempList[1] = Integer.parseInt(tempList[1]) + 1 + "";
				submap.put(key, tempList);

				map.put(fault.getEquipmenttypename(), submap);
			}
		}
		return map;
	}

	@Override
	public List<BusFault> statisticsFaultList(Integer organizationId, Integer id, Integer type, String year,
			String month, String day, String hour) {
		if (id == null) {
			id = 100000;
		}
		List<BusFault> list = new ArrayList<BusFault>();
		List<String> terminalDition = new ArrayList<String>();
		List<String> ammeterDition = new ArrayList<String>();
		if (type == null || type == 2) {
			list = faultMapper.statisticsFaultList(organizationId, id, year, month, day, hour);
			for (BusFault busFault : list) {
				type = busFault.getType();
				Integer equipId = busFault.getEquipId();
				if (type == 2) {
					Terminal terminal = faultMapper.getTerminalNameByEquipId(equipId);
					busFault.setEquipname(terminal.getTerminalName());
					busFault.setInstallationLocation(terminal.getInstallationLocation());// 安装地址为1-6的数字
				}
				if (type == 3) {
					MbAmmeter ammeter = faultMapper.getAmmeterNameByEquipId(equipId);
					busFault.setEquipname(ammeter.getAmmeterName());
					busFault.setInstallationLocation(ammeter.getInstallAddress());
				}
			}
		} else {
			// if (type==2) {
			// list = faultMapper.statisticsFaultList(organizationId, id, year,
			// month, day, hour);
			// }
			if (type == 3) {// 表箱
				terminalDition.add("t.measureId=#{id,jdbcType=INTEGER}");
				ammeterDition.add("a.boxCode=#{id,jdbcType=INTEGER}");
				String terdition = StringUtils.join(terminalDition.toArray());
				String amdition = StringUtils.join(ammeterDition.toArray());
				list = faultMapper.measureFaultList(terdition, amdition, organizationId, id, year, month, day, hour);
			}
			if (type == 4) {// 集中器
				terminalDition.add("t.concentratorId=#{id,jdbcType=INTEGER}");
				ammeterDition.add("a.concentratorCode=#{id,jdbcType=INTEGER}");
				String terdition = StringUtils.join(terminalDition.toArray());
				String amdition = StringUtils.join(ammeterDition.toArray());
				list = faultMapper.measureFaultList(terdition, amdition, organizationId, id, year, month, day, hour);
			}
			if (type == 5) {// 终端
				list = faultMapper.terminalFaultList(organizationId, id, year, month, day, hour);
			}
			if (type == 6) {// 电表
				list = faultMapper.ammeterFaultList(organizationId, id, year, month, day, hour);
			}
		}

		return list;
	}

}
