package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.ProxyAlarmPlan;
import com.ssm.wssmb.model.ProxyAlarmPlanEvent;

public interface ProxyAlarmPlanMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(ProxyAlarmPlan record);

    int insertSelective(ProxyAlarmPlan record);

    ProxyAlarmPlan selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(ProxyAlarmPlan record);

    int updateByPrimaryKey(ProxyAlarmPlan record);
    
	List<ProxyAlarmPlan> selectSchemeList(@Param("plantype")Integer plantype, @Param("organizationid")Integer organizationid);
    
    List<ProxyAlarmPlanEvent> selectEventList(Integer planid);
    
    int deleteAlarmEvent(Integer planid);
    
    int insertAlarmEvent(@Param(value = "events")List<ProxyAlarmPlanEvent> events);
    
    int entrust(Integer id);
    
    int unentrust(Integer id);
    
    ProxyAlarmPlan selectByProxyid(@Param("organizationid")Integer organizationid);
}