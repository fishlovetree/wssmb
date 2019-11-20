package com.ssm.wssmb.controller;

import javax.annotation.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.ssm.wssmb.model.EventThreshold;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.ssm.wssmb.service.CommonTreeService;
import com.ssm.wssmb.service.EventThresholdService;

@Controller
@RequestMapping(value = "/eventThreshold")
public class EventThresholdController {
	@Resource
	CommonTreeService commonTreeService;

	@Autowired
	EventThresholdService eventThresholdService;

	// 读取配置文件中的websocketip
	@Value("${websocketip}")
	private String websocketip;
	// 读取配置文件中的websocketport
	@Value("${websocketport}")
	private String websocketport;

	/**
	 * @Description 查询阀值
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author rcd
	 */
	@RequestMapping(value = "/getThreshold", produces = "text/html;charset=UTF-8;")
	public @ResponseBody String getThreshold(EventThreshold record) throws Exception {
		Gson gson = new GsonBuilder().disableHtmlEscaping().create();
		return gson.toJson(eventThresholdService.getThreshold(record));
	}

}
