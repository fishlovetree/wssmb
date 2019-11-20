package com.ssm.wssmb.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ssm.wssmb.model.User;
import com.ssm.wssmb.service.CommonTreeService;
import com.ssm.wssmb.service.ThreeModelService;
import com.ssm.wssmb.service.VisualizationService;

@Controller
@RequestMapping(value="/visualization")
public class VisualizationController {

	@Resource
	private CommonTreeService commonTreeService;
	
	@Resource
	private ThreeModelService threeModelService;
	
	@Resource
	private VisualizationService visualizationService;
	
	//读取配置文件中的websocketip
	@Value("${websocketip}") 
	private String websocketip;
	//读取配置文件中的websocketport
	@Value("${websocketport}") 
	private String websocketport;
		
	/**
	 * @Description 实时曲线-组帧
	 * @return
	 * @throws Exception
	 * @Time 2018年7月05日
	 * @Author hxl
	 * @type 前端方法
	 */
	@RequestMapping(value="/realtimeFrame",method=RequestMethod.POST,produces = "text/html;charset=UTF-8;")
	public @ResponseBody String realtimeFrame(HttpServletRequest re, Integer equipmentid,Integer type) throws Exception{
		//初始时根据用户权限加载type
		User user = CommonMethod.getUserBySession(re, "wssmb_front_user", false);
		return visualizationService.makeRealtimeFrame(equipmentid, user.getId(),type);
	}
}
