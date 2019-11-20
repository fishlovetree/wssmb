package com.ssm.wssmb.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

//import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.ssm.wssmb.model.Organization;
import com.ssm.wssmb.model.OrganizationUser;
import com.ssm.wssmb.model.TreeNode;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.service.CommonTreeService;
import com.ssm.wssmb.service.OrganizationService;
import com.ssm.wssmb.util.TreeNodeLevel;

@Controller
@RequestMapping(value = "/organization")
public class OrganizationController {

	@Resource
	private OrganizationService organizationService;

	@Resource
	private CommonTreeService commonTreeService;

	@RequestMapping(value = "/organizationPage")
//	@RequiresPermissions("organization:organizationPage")
	public ModelAndView index(HttpServletRequest req, HttpServletResponse response) {

		ModelAndView mv = new ModelAndView();
		mv.setViewName("System/Organization");
		return mv;
	}

	/**
	 * @Description 获取组织机构树列表
	 * @return
	 * @throws Exception
	 * @Time 2018年1月6日
	 * @Author hxl
	 */
	@RequestMapping(value = "/organizationTreeGrid", produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<Map<String, Object>> organizationTreeGrid(HttpServletRequest req, Integer id)
			throws Exception {
		User user = (User) req.getSession(true).getAttribute("user");
		List<Map<String, Object>> organizationMapList = organizationService
				.getOrganizationTreeGrid(user.getOrganizationid(), id == null ? 0 : id);
		return organizationMapList;
	}

	/**
	 * @Description 获取组织机构树
	 * @return
	 * @throws Exception
	 * @Time 2019年1月9日
	 * @Author dj
	 * @type 后端方法
	 */
	@RequestMapping(value = "/organizationTree", produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<TreeNode> organizationTree(HttpServletRequest req, HttpServletResponse response)
			throws Exception {
		User user = (User) req.getSession(true).getAttribute("user");
		if (user==null) {
			 user = CommonMethod.getUserBySession(req, "wssmb_front_user", false);
		}	
		List<TreeNode> organizationMapList = commonTreeService.getOrganizationTree(user.getOrganizationcode(),
				TreeNodeLevel.Organization);
		return organizationMapList;
	}

	/**
	 * @Description 添加组织机构
	 * @param organization
	 * @return
	 * @throws Exception
	 * @Time 2018年1月6日
	 * @Author hxl
	 */
	@RequestMapping(value = "/addOrganization", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String addOrganization(HttpServletRequest req, Organization organization) throws Exception {
		User user = (User) req.getSession(true).getAttribute("user");
		organization.setCompactor(user.getId());
		if (organization.getParentid() == null)
			organization.setParentid(0);
		return organizationService.addOrganization(organization);
	}

	/**
	 * @Description 编辑组织机构
	 * @param organization
	 * @return
	 * @throws Exception
	 * @Time 2018年1月6日
	 * @Author hxl
	 */
	@RequestMapping(value = "/editOrganization", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String editOrganization(Organization organization) throws Exception {
		return organizationService.editOrganization(organization);
	}

	/**
	 * @Description 通过id删除组织机构
	 * @param id
	 * @return
	 * @throws Exception
	 * @Time 2018年1月6日
	 * @Author hxl
	 */
	@RequestMapping(value = "/deleteOrganization", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String deleteOrganization(int id) throws Exception {
		return organizationService.deleteOrganization(id);
	}

	/**
	 * @Description 获取组织机构告警人员
	 * @return
	 * @throws Exception
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
	@RequestMapping(value = "/getAlarmUser", produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<OrganizationUser> getAlarmUser(int organizationid) throws Exception {
		return organizationService.getAlarmUser(organizationid);
	}

	/**
	 * @Description 添加组织机构告警人员
	 * @return
	 * @throws Exception
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
	@RequestMapping(value = "/addAlarmUser", produces = "text/html;charset=UTF-8;")
	public @ResponseBody String addAlarmUser(OrganizationUser record) throws Exception {
		return organizationService.addAlarmUser(record);
	}

	/**
	 * @Description 删除组织机构告警人员
	 * @return
	 * @throws Exception
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
	@RequestMapping(value = "/deleteAlarmUser", produces = "text/html;charset=UTF-8;")
	public @ResponseBody String deleteAlarmUser(int id) throws Exception {
		return organizationService.deleteAlarmUser(id);
	}
}
