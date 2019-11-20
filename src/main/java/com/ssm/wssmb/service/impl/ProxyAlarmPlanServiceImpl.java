package com.ssm.wssmb.service.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.ssm.wssmb.mapper.ProxyAlarmPlanMapper;
import com.ssm.wssmb.model.ProxyAlarmPlan;
import com.ssm.wssmb.model.ProxyAlarmPlanEvent;
import com.ssm.wssmb.service.ProxyAlarmPlanService;
import com.ssm.wssmb.util.EventLogAspect;
import com.ssm.wssmb.util.Operation;

@Service
public class ProxyAlarmPlanServiceImpl implements ProxyAlarmPlanService {
	@Resource
	ProxyAlarmPlanMapper proxyAlarmPlanMapper;
	
	@Resource
	private EventLogAspect log;
	
	/**
	 * @Description 添加代理告警方案
	 * @return
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
	@Override
    public String addScheme(ProxyAlarmPlan model)throws Exception{
    	int result = proxyAlarmPlanMapper.insertSelective(model);
		if (result > 0){
	        String content = "组织机构编号：" + model.getOrganizationcode();
	        log.addLog("", "添加代理告警方案", content, 0);
			return "success";
		}
		else{
			return "error";
		} 
    }

    /**
	 * @Description 修改代理告警方案
	 * @return
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
	@Override
    public String editScheme(ProxyAlarmPlan model)throws Exception{
		int result = proxyAlarmPlanMapper.updateByPrimaryKeySelective(model);
		if (result > 0){
	        String content = "代理告警方案ID：" + model.getId();
	        log.addLog("", "修改代理告警方案", content, 2);
			return "success";
		}
		else{
			return "error";
		} 
	}

    /**
	 * @Description 删除代理告警方案
	 * @return
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
	@Override
	public String deleteScheme(Integer id)throws Exception{
		int result = proxyAlarmPlanMapper.deleteByPrimaryKey(id);
		if (result > 0){
	        String content = "代理告警方案ID：" + id;
	        log.addLog("", "删除代理告警方案", content, 1);
			return "success";
		}
		else{
			return "error";
		} 
	}
	
	/**
	 * @Description 根据id获取代理告警方案
	 * @return
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
	@Override
	public ProxyAlarmPlan getSchemeById(Integer id)throws Exception{
		return proxyAlarmPlanMapper.selectByPrimaryKey(id);
	}
	
	/**
	 * @Description 获取告警方案列表
	 * @param plantype 0-基础，1-代理
	 * @param organizationid 登录账号的组织机构id
	 * @return
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
	@Override
	public List<ProxyAlarmPlan> getSchemeList(Integer plantype, Integer organizationid)throws Exception{
		return proxyAlarmPlanMapper.selectSchemeList(plantype, organizationid);
	}
	
	/**
	 * 获取告警方案事件
	 * 
	 * @param id 方案id
	 * @return
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
	@Override
	public List<ProxyAlarmPlanEvent> getAlarmEvent(int id) {
		return proxyAlarmPlanMapper.selectEventList(id);
	}
	
	/**
	 * 设置告警方案事件
	 * 
	 * @param id 方案id
	 * @return
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
	@Override
	public String saveAlarmEvent(int id, String events) throws Exception {
		int _result = proxyAlarmPlanMapper.deleteAlarmEvent(id);
		String reusltStr = "";
		if (_result >= 0) {
			List<ProxyAlarmPlanEvent> list = new ArrayList<ProxyAlarmPlanEvent>();
			if (events != "") {
				String[] ids = events.split(",");
				for (int i = 0; i < ids.length; i++) {
					ProxyAlarmPlanEvent event = new ProxyAlarmPlanEvent();
					event.setPlanid(id);
					event.setEventid(Integer.valueOf(ids[i]));
					list.add(event);
				}
			}
			int result = proxyAlarmPlanMapper.insertAlarmEvent(list);
			if (result > 0){
		        String content = "代理告警方案ID：" + id + "，告警方案事件：" + events;
		        log.addLog("", "设置告警方案事件", content, 2);
				reusltStr = "success";
			}else
				reusltStr = "error";
		} else {
			reusltStr = "error";
		}
		return reusltStr;
	}
	
	/**
	 * 设置告警委托
	 * 
	 * @param id 方案id
	 * @return
	 * @Time 2019年4月4日
	 * @Author hxl
	 */
	@Override
	public String entrust(int id) throws Exception {
		int result = proxyAlarmPlanMapper.entrust(id);
		if (result >= 0) {
	        String content = "代理告警方案ID：" + id;
	        log.addLog("", "设置告警委托", content, 2);
			return "success";
		} else {
			return "error";
		}
	}
	
	/**
	 * 取消告警委托
	 * 
	 * @param id 方案id
	 * @return
	 * @Time 2019年4月4日
	 * @Author hxl
	 */
	@Override
	public String unentrust(int id) throws Exception {
		int result = proxyAlarmPlanMapper.unentrust(id);
		if (result >= 0) {
	        String content = "代理告警方案ID：" + id;
	        log.addLog("", "取消告警委托", content, 2);
			return "success";
		} else {
			return "error";
		}
	}
}
