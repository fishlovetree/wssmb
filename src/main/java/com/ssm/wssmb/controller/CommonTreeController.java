package com.ssm.wssmb.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.ssm.wssmb.model.TreeNode;
import com.ssm.wssmb.model.TreeSetting;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.service.CommonTreeService;
import com.ssm.wssmb.util.TreeNodeLevel;

import net.sf.json.JSONArray;

@Controller
@RequestMapping(value = "/commonTree")
public class CommonTreeController {
	@Resource
	CommonTreeService commonTreeService;

	@RequestMapping(value = "/index")
	public ModelAndView index(HttpServletRequest req, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("Index/CommonTree");
		return mv;
	}

	/**
	 * @Description 获取组织机构树
	 * @return organizationMapList
	 * @param req
	 * @param response
	 * @throws Exception
	 * @Time 2018年12月26日
	 * @Author hxl
	 */
	@RequestMapping(value = "/organizationTreeJson", produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<TreeNode> organizationTreeJson(HttpServletRequest req, HttpServletResponse response)
			throws Exception {
		User user = (User) req.getSession(true).getAttribute("user");
		List<TreeNode> organizationMapList = commonTreeService.getOrganizationTree(user.getOrganizationcode(),
				TreeNodeLevel.Device);
		return organizationMapList;
	}

	/**
	 * @Description 获取区域树
	 * @return
	 * @throws Exception
	 * @Time 2018年12月26日
	 * @Author hxl
	 */
	@RequestMapping(value = "/regionTreeJson", produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<TreeNode> regionTreeJson(HttpServletRequest req, HttpServletResponse response)
			throws Exception {
		User user = (User) req.getSession(true).getAttribute("user");
		List<TreeNode> regionMapList = commonTreeService.getRegionTree(user.getOrganizationcode(), TreeNodeLevel.Device);
		return regionMapList;
	}

	/**
	 * @Description 保存树节点收起配置
	 * @return
	 * @throws Exception
	 * @Time 2018年12月26日
	 * @Author hxl
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/saveSettingNodes", produces = "text/html;charset=UTF-8;")
	public @ResponseBody String saveSettingNodes(HttpServletRequest req) throws Exception {
		User user = (User) req.getSession(true).getAttribute("user");
		// 从前台获取JSON格式的参数并转换成JSONArray数组
		JSONArray jsonArray = JSONArray.fromObject(req.getParameter("json"));
		// 将jsonArray型数组转化为Student型，并封装为一个student数组；这一句等同于下面的绿色字体部分
		@SuppressWarnings("static-access")
		List<TreeSetting> settingNodes = (List<TreeSetting>) jsonArray.toCollection(jsonArray, TreeSetting.class);
		return commonTreeService.saveSettingNodes(user.getOrganizationcode() == null ? "0" : user.getOrganizationcode(),
				settingNodes);
	}
}
