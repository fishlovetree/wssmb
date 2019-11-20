package com.ssm.wssmb.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.ssm.wssmb.model.AmmeterStatus;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.model.ViewEquipmentstatus;
import com.ssm.wssmb.model.ViewOnlineunit;
import com.ssm.wssmb.service.MonitorService;

/**
 * @Description: 数据分析控制器
 * @Author rcd
 * @Time: 
 */
@Controller
@RequestMapping(value="/subsystem")
public class SubsystemController {
	
	@Resource
	private MonitorService monitorservice;

	/**
	 * @Description 后台综合查询-集中器状态数据
	 * @param 
	 * @return
	 * @throws Exception
	 * @Time 
	 * @Author rcd
	 */
	@RequestMapping(value="/getConcentratorData",produces = "application/json;charset=UTF-8;")
	public @ResponseBody String getConcentratorData(HttpServletRequest re, Integer id,Integer type) throws Exception{
		ViewOnlineunit unit = monitorservice.getUnitRowByID(id,type);
		if(null!=unit){
			Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").disableHtmlEscaping().create();
			return gson.toJson(unit);
		}
		else
			return "null";
	}
	
	/**
	 * @Description 后台综合查询-电表、终端状态数据
	 * @param 
	 * @return
	 * @throws Exception
	 * @Time 
	 * @Author rcd
	 */
	@RequestMapping(value="/getEquipmentData",produces = "application/json;charset=UTF-8;")
	public @ResponseBody String getEquipmentData(HttpServletRequest re, Integer id,Integer type) throws Exception{		
		AmmeterStatus equipment = monitorservice.getEquipmentRowByID(id,type);
		if(null!=equipment){	
			Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").disableHtmlEscaping().create();
			return gson.toJson(equipment);
		}
		else
			return "error";
	}
}
