package com.ssm.wssmb.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ssm.wssmb.model.ConstantDetail;
import com.ssm.wssmb.service.ConstantService;


@Controller
@RequestMapping(value = "/dataQuery")
public class DataQueryController {

	// 读取配置文件中的websocketip
	@Value("${websocketip}")
	private String websocketip;
	// 读取配置文件中的websocketport
	@Value("${websocketport}")
	private String websocketport;

	@Resource
	private ConstantService constantService;

	/**
	 * @Description 获取故障类型列表
	 * @return
	 * @throws Exception
	 * @Time 
	 * @Author rcd
	 */
	@RequestMapping(value = "/getFaultType", produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<ConstantDetail> getFaultType() throws Exception {
		List<ConstantDetail> list = constantService.getDetailList(1084);
		ConstantDetail constantdetail = new ConstantDetail();
		constantdetail.setDetailname("所有");
		constantdetail.setDetailvalue("255");
		list.add(0, constantdetail);
		return list;
	}

	/**
	 * @Description 获取消息类型列表
	 * @return
	 * @throws Exception
	 * @Time 
	 * @Author rcd
	 */
	@RequestMapping(value = "/getMessageType", produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<ConstantDetail> getMessageType() throws Exception {
		List<ConstantDetail> list = constantService.getDetailList(1120);
		ConstantDetail constantdetail = new ConstantDetail();
		constantdetail.setDetailname("所有");
		constantdetail.setDetailvalue("255");
		list.add(0, constantdetail);
		return list;
	}

}
