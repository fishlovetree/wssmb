package com.ssm.wssmb.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import org.apache.commons.lang.StringUtils;
import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssm.wssmb.mapper.BusRemotealarmsmsrecordMapper;
import com.ssm.wssmb.mapper.BusRemotealarmsoundrecordMapper;
import com.ssm.wssmb.model.BusRemotealarmsmsrecord;
import com.ssm.wssmb.model.BusRemotealarmsoundrecord;
import com.ssm.wssmb.service.EventRecordService;
import com.ssm.wssmb.service.UntilService;

@Service
public class EventRecordServiceImpl implements EventRecordService {

	@Resource
	private UntilService untilService;

	@Resource
	private BusRemotealarmsmsrecordMapper smsrecordMapper;

	@Autowired
	BusRemotealarmsoundrecordMapper soundrecordMapper;

	/**
	 * 短信通知日志
	 */
	@Override
	public String smsRecordDataGrid(Integer id, Integer type, Integer organizationId, String eventid, String result,
			String startTime, String endTime, String address, String equipmentname, int startindex, int endindex)
			throws Exception {
		if (null == startTime || startTime.trim().equals("") || null == endTime || endTime.trim().equals("")) {
			Date d = new Date();
			SimpleDateFormat sdfStart = new SimpleDateFormat("yyyy-MM-dd 00:00:00");
			SimpleDateFormat sdfEnd = new SimpleDateFormat("yyyy-MM-dd 23:59:59");
			startTime = sdfStart.format(d);
			endTime = sdfEnd.format(d);
		}
		startindex = startindex - 1;
		int count = 0;
		List<BusRemotealarmsmsrecord> list = new ArrayList<BusRemotealarmsmsrecord>();
		List<String> terminalDition = new ArrayList<String>();
		List<String> ammeterDition = new ArrayList<String>();

		if (id == null && type == null) {
			list = smsrecordMapper.selectList(organizationId, eventid, result, startTime, endTime, address,
					equipmentname, startindex, endindex);
			count = smsrecordMapper.selectListCount(organizationId, eventid, result, startTime, endTime, address,
					equipmentname);
		} else {
			if (type==6) {//电表
				list = smsrecordMapper.selectAmmeterRecord(id, organizationId, eventid, result, startTime, endTime,
						address, equipmentname, startindex, endindex);
				count = smsrecordMapper.selectByAmmeterRecordCount(id, organizationId, eventid, result, startTime,
						endTime, address, equipmentname);
			}
			if (type == 5) {// 终端
				list = smsrecordMapper.selectTerminalRecord(id, organizationId, eventid, result, startTime, endTime,
						address, equipmentname, startindex, endindex);
				count = smsrecordMapper.selectByTerminalRecordCount(id, organizationId, eventid, result, startTime,
						endTime, address, equipmentname);
			}
			if (type == 4) {// 集中器
				terminalDition.add("t.concentratorId=#{id,jdbcType=INTEGER}");
				ammeterDition.add("a.concentratorCode=#{id,jdbcType=INTEGER}");
				String terdition = StringUtils.join(terminalDition.toArray());
				String amdition = StringUtils.join(ammeterDition.toArray());
				list = smsrecordMapper.selectEquipmentRecord(terdition, amdition, id, organizationId, eventid, result,
						startTime, endTime, address, equipmentname, startindex, endindex);
				count = smsrecordMapper.selectByEquipmentRecordCount(terdition, amdition, id, organizationId, eventid,
						result, startTime, endTime, address, equipmentname);
			}
			if (type == 3) {// 表箱
				terminalDition.add("t.measureId=#{id,jdbcType=INTEGER}");
				ammeterDition.add("a.boxCode=#{id,jdbcType=INTEGER}");
				String terdition = StringUtils.join(terminalDition.toArray());
				String amdition = StringUtils.join(ammeterDition.toArray());
				list = smsrecordMapper.selectEquipmentRecord(terdition, amdition, id, organizationId, eventid, result,
						startTime, endTime, address, equipmentname, startindex, endindex);
				count = smsrecordMapper.selectByEquipmentRecordCount(terdition, amdition, id, organizationId, eventid,
						result, startTime, endTime, address, equipmentname);
			}
			if (type == 2) {// 区域
				list = smsrecordMapper.selectRegionRecord(id, organizationId, eventid, result, startTime, endTime,
						address, equipmentname, startindex, endindex);
				count = smsrecordMapper.selectByRegionRecordCount(id, organizationId, eventid, result, startTime,
						endTime, address, equipmentname);
			}
		}

		String json = untilService.getDataPager(list, count);
		return json;
	}

	/**
	 * 语音列表
	 * rcd
	 */
	@Override
	public String soundRecordDataGrid(Integer id, Integer type, Integer orgnazationId, String eventid, String result,
			String startTime, String endTime, String address, String equipmentname, int startindex, int endindex)
			throws Exception {
		if (null == startTime || startTime.trim().equals("") || null == endTime || endTime.trim().equals("")) {
			Date d = new Date();
			SimpleDateFormat sdfStart = new SimpleDateFormat("yyyy-MM-dd 00:00:00");
			SimpleDateFormat sdfEnd = new SimpleDateFormat("yyyy-MM-dd 23:59:59");
			startTime = sdfStart.format(d);
			endTime = sdfEnd.format(d);
		}
		startindex = startindex - 1;
		int count = 0;
		List<BusRemotealarmsoundrecord> list = new ArrayList<BusRemotealarmsoundrecord>();
		List<String> terminalDition = new ArrayList<String>();
		List<String> ammeterDition = new ArrayList<String>();
		if (id == null && type == null) {
			list = soundrecordMapper.selectList(orgnazationId, eventid, result, startTime, endTime, address,
					equipmentname, startindex, endindex);
			count = soundrecordMapper.selectListCount(orgnazationId, eventid, result, startTime, endTime, address,
					equipmentname);
		}else {			
			if (type==6) {//电表
				list = soundrecordMapper.selectAmmeterRecord(id, orgnazationId, eventid, result, startTime, endTime,
						address, equipmentname, startindex, endindex);
				count = soundrecordMapper.selectByAmmeterRecordCount(id, orgnazationId, eventid, result, startTime,
						endTime, address, equipmentname);
			}
			if(type==5) {//终端
				list = soundrecordMapper.selectTerminalRecord(id, orgnazationId, eventid, result, startTime, endTime,
						address, equipmentname, startindex, endindex);
				count = soundrecordMapper.selectByTerminalRecordCount(id, orgnazationId, eventid, result, startTime,
						endTime, address, equipmentname);
			}if (type==4) {//集中器
				terminalDition.add("t.concentratorId=#{id,jdbcType=INTEGER}");
				ammeterDition.add("a.concentratorCode=#{id,jdbcType=INTEGER}");
				String terdition = StringUtils.join(terminalDition.toArray());
				String amdition = StringUtils.join(ammeterDition.toArray());
				list = soundrecordMapper.selectEquipmentRecord(terdition, amdition, id, orgnazationId, eventid, result,
						startTime, endTime, address, equipmentname, startindex, endindex);
				count = soundrecordMapper.selectByEquipmentRecordCount(terdition, amdition, id, orgnazationId, eventid,
						result, startTime, endTime, address, equipmentname);
			}
			if (type==3) {//表箱
				terminalDition.add("t.measureId=#{id,jdbcType=INTEGER}");
				ammeterDition.add("a.boxCode=#{id,jdbcType=INTEGER}");
				String terdition = StringUtils.join(terminalDition.toArray());
				String amdition = StringUtils.join(ammeterDition.toArray());
				list = soundrecordMapper.selectEquipmentRecord(terdition, amdition, id, orgnazationId, eventid, result,
						startTime, endTime, address, equipmentname, startindex, endindex);
				count = soundrecordMapper.selectByEquipmentRecordCount(terdition, amdition, id, orgnazationId, eventid,
						result, startTime, endTime, address, equipmentname);
			}
			if (type==2) {//区域		
				list = soundrecordMapper.selectRegionRecord(id, orgnazationId, eventid, result, startTime, endTime,
						address, equipmentname, startindex, endindex);
				count = soundrecordMapper.selectByRegionRecordCount(id, orgnazationId, eventid, result, startTime,
						endTime, address, equipmentname);
			}
		}

		String json = untilService.getDataPager(list, count);
		return json;
	}
}
