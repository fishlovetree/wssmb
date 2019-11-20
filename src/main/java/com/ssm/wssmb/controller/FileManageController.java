package com.ssm.wssmb.controller;

import java.util.ArrayList;
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

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.ssm.wssmb.mapper.OrgAndCustomerMapper;
import com.ssm.wssmb.mapper.OrganizationMapper;
import com.ssm.wssmb.model.MbAmmeter;
import com.ssm.wssmb.model.Terminal;
import com.ssm.wssmb.model.TreeNode;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.model.ViewEquipment;
import com.ssm.wssmb.service.CommonTreeService;
import com.ssm.wssmb.service.FileManageService;
import com.ssm.wssmb.service.UntilService;
import com.ssm.wssmb.service.ViewEquipmentService;
import com.ssm.wssmb.util.TreeNodeLevel;

/**
 * @Description: 终端-档案管理
 * @Author dj
 * @Time: 2018年1月29号
 */
@Controller
@RequestMapping(value = "/fileManage")
public class FileManageController {

	@Resource
	private FileManageService filemanageservice;

	@Resource
	private ViewEquipmentService viewEquipmentService;

	// 读取配置文件中的websocketip
	@Value("${websocketip}")
	private String websocketip;

	// 读取配置文件中的websocketport
	@Value("${websocketport}")
	private String websocketport;

	/**
	 * @Description 下发选中档案
	 * @param ID
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author
	 */
	@RequestMapping(value = "/issued", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String issued(HttpServletRequest request) throws Exception {
		String[] ids = request.getParameterValues("id[]");
		String type = request.getParameter("type");
		if (type.equals("1")) {
			List<Terminal> list = viewEquipmentService.getTerminalListByIDs(ids);
			Gson gson = new GsonBuilder().disableHtmlEscaping().create();
			return gson.toJson(filemanageservice.issued(list));
		} else {
			List<MbAmmeter> list = viewEquipmentService.getAmmeterlListByIDs(ids);
			Gson gson = new GsonBuilder().disableHtmlEscaping().create();
			return gson.toJson(filemanageservice.issue(list));
		}
	}

	/**
	 * @Description 解析前置机回传数据
	 * @param record
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author
	 */
	@RequestMapping(value = "/parseResponse", produces = "application/json;charset=UTF-8;")
	public @ResponseBody Map<String, Object> parseResponse(HttpServletRequest request, String strXML) throws Exception {
		String type = request.getParameter("type");
		if (type.equals("1")) {
			return filemanageservice.parseTerminalResponse(strXML);
		}else {
			return filemanageservice.parseAmmeterResponse(strXML);
		}
		
	}
}
