package com.ssm.wssmb.service;

import java.util.List;

import com.ssm.wssmb.model.ProxyAlarmPlan;
import com.ssm.wssmb.model.ProxyAlarmPlanEvent;

/**
 * @Description: 告警方案业务接口
 * @Author hxl
 * @Time: 2018年8月13日
 */
public interface ProxyAlarmPlanService {
	
	/**
	 * @Description 添加代理告警方案
	 * @return
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
    String addScheme(ProxyAlarmPlan model)throws Exception;

    /**
	 * @Description 修改代理告警方案
	 * @return
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
    String editScheme(ProxyAlarmPlan model)throws Exception;

    /**
	 * @Description 删除代理告警方案
	 * @return
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
	String deleteScheme(Integer id)throws Exception;
	
	/**
	 * @Description 根据id获取代理告警方案
	 * @return
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
	ProxyAlarmPlan getSchemeById(Integer id)throws Exception;
	
	/**
	 * @Description 获取告警方案列表
	 * @param plantype 0-基础，1-代理
	 * @param organizationid 登录账号的组织机构id
	 * @return
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
	List<ProxyAlarmPlan> getSchemeList(Integer plantype, Integer organizationid)throws Exception;
	
	/**
	 * 获取告警方案事件
	 * 
	 * @param id 方案id
	 * @return
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
	List<ProxyAlarmPlanEvent> getAlarmEvent(int id);
	
	/**
	 * 设置告警方案事件
	 * 
	 * @param id 方案id
	 * @return
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
	String saveAlarmEvent(int id, String events) throws Exception;
	
	/**
	 * 设置告警委托
	 * 
	 * @param id 方案id
	 * @return
	 * @Time 2019年4月4日
	 * @Author hxl
	 */
	String entrust(int id) throws Exception;
	
	/**
	 * 取消告警委托
	 * 
	 * @param id 方案id
	 * @return
	 * @Time 2019年4月4日
	 * @Author hxl
	 */
	String unentrust(int id) throws Exception;
	
}
