package com.ssm.wssmb.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import org.apache.commons.lang.StringUtils;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.ssm.wssmb.mapper.BusMessagepushrecordMapper;
import com.ssm.wssmb.mapper.OrgAndCustomerMapper;
import com.ssm.wssmb.model.BusMessagepushrecord;
import com.ssm.wssmb.service.BusMessageService;
import com.ssm.wssmb.service.UntilService;
import com.ssm.wssmb.util.TreeNodeType;

@Service
public class BusMessageServiceImpl implements BusMessageService {
	@Resource
	private BusMessagepushrecordMapper messageMapper;
	
	@Resource
	private UntilService untilService;
	
	@Override
	public int deleteByPrimaryKey(Integer id) {
		return messageMapper.deleteByPrimaryKey(id);
	}

	@Override
	public int insert(BusMessagepushrecord record) {
		return messageMapper.insert(record);
	}

	@Override
	public int insertSelective(BusMessagepushrecord record) {
		return messageMapper.insertSelective(record);
	}

	@Override
	public BusMessagepushrecord selectByPrimaryKey(Integer id) {
		return messageMapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKeySelective(BusMessagepushrecord record) {
		return messageMapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(BusMessagepushrecord record) {
		return messageMapper.updateByPrimaryKey(record);
	}

	/**
	 * 消息列表
	 * rcd
	 */
	@Override
	public String queryMessage(Integer id, Integer type, Integer organizationId, String msgtypecode, String startTime,
			String endTime, String address, String equipmentname, int startindex, int endindex) throws Exception {
		if (null == startTime || startTime.trim().equals("") || null == endTime || endTime.trim().equals("")) {
			Date d = new Date();
			SimpleDateFormat sdfStart = new SimpleDateFormat("yyyy-MM-dd 00:00:00");
			SimpleDateFormat sdfEnd = new SimpleDateFormat("yyyy-MM-dd 23:59:59");
			startTime = sdfStart.format(d);
			endTime = sdfEnd.format(d);
		}
		List<String> terminalDition = new ArrayList<String>();
		List<String> ammeterDition = new ArrayList<String>();
		List<BusMessagepushrecord> list = new ArrayList<BusMessagepushrecord>();
		Integer count = 0;
		startindex = startindex - 1;
		if (id == null && type == null) {
			list = messageMapper.queryMessage(organizationId, msgtypecode, startTime, endTime, address, equipmentname,
					startindex, endindex);
			count = messageMapper.queryMessageCount(organizationId, msgtypecode, startTime, endTime, address,
					equipmentname);
		} else {
			if (type==6) {//电表
				list = messageMapper.selectAmmeterMessage(id, organizationId, msgtypecode, startTime, endTime, address,
						equipmentname, startindex, endindex);
				count = messageMapper.selectByAmmeterMessageCount(id, organizationId, msgtypecode, startTime, endTime,
						address, equipmentname);
			}
			if (type == 5) {// 终端
				list = messageMapper.selectTerminalMessage(id, organizationId, msgtypecode, startTime, endTime, address,
						equipmentname, startindex, endindex);
				count = messageMapper.selectByTerminalMessageCount(id, organizationId, msgtypecode, startTime, endTime,
						address, equipmentname);
			}
			if (type == 4) {// 集中器
				terminalDition.add("t.concentratorId=#{id,jdbcType=INTEGER}");
				ammeterDition.add("a.concentratorCode=#{id,jdbcType=INTEGER}");				
				String terdition=StringUtils.join(terminalDition.toArray());
				String amdition=StringUtils.join(ammeterDition.toArray());
				list = messageMapper.selectEquipmentMessage(terdition,amdition,id, organizationId, msgtypecode, startTime, endTime, address,
						equipmentname, startindex, endindex);
				count = messageMapper.selectByEquipmentMessageCount(terdition,amdition,id, organizationId, msgtypecode, startTime, endTime, address,
						equipmentname);
			}
			if(type==3) {//表箱
				terminalDition.add("t.measureId=#{id,jdbcType=INTEGER}");
				ammeterDition.add("a.boxCode=#{id,jdbcType=INTEGER}");				
				String terdition=StringUtils.join(terminalDition.toArray());
				String amdition=StringUtils.join(ammeterDition.toArray());
				list = messageMapper.selectEquipmentMessage(terdition,amdition,id, organizationId, msgtypecode, startTime, endTime, address,
						equipmentname, startindex, endindex);
				count = messageMapper.selectByEquipmentMessageCount(terdition,amdition,id, organizationId, msgtypecode, startTime, endTime, address,
						equipmentname);
			}
			if(type==2) {
				list = messageMapper.selectRegionMessage(id, organizationId, msgtypecode, startTime, endTime, address,
						equipmentname, startindex, endindex);
				count = messageMapper.selectByRegionMessageCount(id, organizationId, msgtypecode, startTime, endTime, address,
						equipmentname);
			}
		}

		String json = untilService.getDataPager(list, count);
		return json;
	}

}
