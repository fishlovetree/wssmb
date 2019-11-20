package com.ssm.wssmb.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.ssm.wssmb.model.TreeNode;

import com.ssm.wssmb.model.User;
import com.ssm.wssmb.service.CommonTreeService;
import com.ssm.wssmb.service.UnitParamsService;
import com.ssm.wssmb.util.TreeNodeLevel;

@Controller
@RequestMapping(value="/unitParams")
public class UnitParamsController {
    
	@Resource
	UnitParamsService unitParamsService;
	
	@Resource
	CommonTreeService commonTreeService;
	
	//读取配置文件中的websocketip
	@Value("${websocketip}") 
	private String websocketip;
	//读取配置文件中的websocketport
	@Value("${websocketport}") 
	private String websocketport;
	
	/**
	 * @Description 读取终端版本号
	 * @return
	 * @throws Exception
	 * @Time 2018年10月10日
	 * @Author hxl
	 */
	@RequestMapping(value="/getVersion",produces = "text/html;charset=UTF-8;")
	public @ResponseBody String getVersion(HttpServletRequest req, Integer id, Integer type, String address) throws Exception {	
		User user = CommonMethod.getUserBySession(req, "user", false);
		return unitParamsService.getVersion(id, type, address, user.getOrganizationid());
	}
}
