package com.ssm.wssmb.controller.front;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.ssm.wssmb.controller.CommonMethod;
import com.ssm.wssmb.mapper.MbAmmeterMapper;
import com.ssm.wssmb.mapper.OrgAndCustomerMapper;
import com.ssm.wssmb.mapper.TerminalMapper;
import com.ssm.wssmb.model.ConstantDetail;
import com.ssm.wssmb.model.MbAieLock;
import com.ssm.wssmb.model.MbAmmeter;
import com.ssm.wssmb.model.Menu;
import com.ssm.wssmb.model.Terminal;
import com.ssm.wssmb.model.TreeNode;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.redis.RedisService;
import com.ssm.wssmb.service.BusFaultService;
import com.ssm.wssmb.service.CommonTreeService;
import com.ssm.wssmb.service.ConstantService;
import com.ssm.wssmb.service.EarlyWarnService;
import com.ssm.wssmb.service.MbAieLockService;
import com.ssm.wssmb.service.MbBlueBreakerService;
import com.ssm.wssmb.service.MeasureFileService;
import com.ssm.wssmb.service.MenuService;
import com.ssm.wssmb.service.MonitorService;
import com.ssm.wssmb.service.RegionService;
import com.ssm.wssmb.service.UntilService;
import com.ssm.wssmb.service.UserService;
import com.ssm.wssmb.util.FrontShiroRealm;
import com.ssm.wssmb.util.MD5Util;
import com.ssm.wssmb.util.ResponseResult;
import com.ssm.wssmb.util.TreeNodeLevel;
import com.ssm.wssmb.util.TreeType;

/**
 * @Description: 前台系统首页控制器
 * @Author hxl
 * @Time: 2018年2月7日
 */
@RestController
@Controller
public class FrontController {

	@Resource
	private CommonTreeService commonTreeService;

	@Resource
	private UserService userService;

	@Resource
	private MenuService menuService;

	@Resource
	private OrgAndCustomerMapper orgAndCustomerMapper;

	@Resource
	private UntilService untilService;

	@Resource
	private RegionService regionService;

	@Resource
	private ConstantService constantService;

	@Autowired
	MonitorService monitorservice;

	@Autowired
	EarlyWarnService earlyWarnService;

	@Autowired
	BusFaultService faultService;

	@Autowired
	RedisService redisService;

	@Autowired
	MbAieLockService mbAieLockService;

	@Autowired
	TerminalMapper terminalMapper;

	@Resource
	MbAmmeterMapper ammeterMapper;

	@Resource
	MeasureFileService measureFileService;

	@Resource
	MbBlueBreakerService mbBlueBreakerService;

	// 读取配置文件中的语言信息
	@Value("${language}")
	private String mlanguage;

	// 读取配置文件中的版本号
	@Value("${version}")
	private String mversion;

	// 读取配置文件中的websocketip
	@Value("${websocketip}")
	private String websocketip;
	// 读取配置文件中的websocketport
	@Value("${websocketport}")
	private String websocketport;

	// 读取配置文件中的账号最大登录次数
	@Value("${maxlogintimes}")
	private String maxlogintimes;

	/**
	 * @Description 前台系统登录页面
	 * @param req
	 * @return
	 * @throws Exception
	 * @Time 2018-07-25
	 * @Author hxl
	 */
	@RequestMapping(value = "/login")
	public ModelAndView login(HttpServletRequest req, HttpServletResponse response) {
		// 设置系统语言
		if (mlanguage.equals("zh")) {
			Locale locale1 = new Locale("zh", "CN");
			req.getSession().setAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME, locale1);
		} else if (mlanguage.equals("en")) {
			Locale locale1 = new Locale("en", "US");
			req.getSession().setAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME, locale1);
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("Front/login");
		return mv;
	}

	/**
	 * @Description 退出前端系统
	 * @param req
	 * @return
	 * @throws Exception
	 * @Time 2018-12-05
	 * @Author dj
	 * @type 前端方法
	 */
	@RequestMapping("/logout")
	public ModelAndView logout(HttpServletRequest req) {
		User user = (User) req.getSession().getAttribute("wssmb_front_user");
		if (null != user) {
			req.getSession().removeAttribute("wssmb_front_user");
		}
		/*
		 * if (null != req.getSession().getAttribute("wssf_front_info")){
		 * req.getSession().removeAttribute("wssf_front_info"); }
		 */
		ModelAndView mv = new ModelAndView("Front/login");
		return mv;
	}

	/**
	 * @Description 前台系统登录
	 * @param req
	 * @return
	 * @throws Exception
	 * @Time 2018-07-25
	 * @Author hxl
	 * @type 前端方法
	 */
	@RequestMapping(value = "/userLogin", produces = "text/html;charset=UTF-8;")
	public @ResponseBody String userLogin(User user, boolean rememberme, HttpServletRequest req,
			HttpServletResponse response) throws Exception {
		if (null != user) {

			boolean flag = userService.ValidateUser(user.getUsername(), user.getPassword(), maxlogintimes);
			if (flag) {
				User muser = userService.getUserByName(user.getUsername());

				if (muser.getUsertype() != 1)
					return "-1";// 非前端用户
				// 设置session
				req.getSession().setAttribute("wssmb_front_user", muser);

				// 放到cookie中
				// 如果需要记住账户就存储账号和密码
				if (rememberme == true) {
					Cookie cookie = new Cookie("wssmb_front_user", user.getUsername() + "-" + user.getPassword());
					cookie.setMaxAge(60 * 60 * 24 * 3);// 保存 3天
					response.addCookie(cookie);
				} else {// 如果没有要求记住账户密码，就保存账户
					Cookie cookie = new Cookie("wssmb_front_user", user.getUsername());
					cookie.setMaxAge(60 * 60 * 24 * 30); // 保存 30天
					response.addCookie(cookie);
				}
				return "1";
			} else {
				return "0";
			}
		} else {
			return "0";
		}
	}

	/**
	 * @Description 前台系统登录成功页面
	 * @param req
	 * @return
	 * @throws Exception
	 * @Time 2018-07-25
	 * @Author hxl
	 * @type 前端方法
	 */
	@RequestMapping(value = "/successLogin", produces = "text/html;charset=UTF-8;")
	public ModelAndView successLogin(HttpServletRequest req) throws Exception {
		ModelAndView mv = new ModelAndView();
		User user = (User) req.getSession().getAttribute("wssmb_front_user");
		String viewName = "Front/index";
		if (null == user) {
			mv.setViewName("Front/login");
			return mv;
		}
		mv.addObject("username", user.getOrganizationname() == null || user.getOrganizationname().equals("")
				? user.getUsername() : user.getOrganizationname());
		mv.addObject("version", mversion);
		switch (user.getTheme()) {
		case 2:
			mv.addObject("theme", "Blue");
			break;
		default:
			mv.addObject("theme", "Yellow");
			break;
		}

		// 获取特殊权限
		if (user.getUserLevel() == 0) { // 内部账号
			mv.addObject("permissions", "-1");
		} else {
			mv.addObject("permissions", user.getPermissions());
		}

		// websocket-事件上报通道
		mv.addObject("websocketip", websocketip);
		mv.addObject("websocketport", websocketport);

		mv.setViewName(viewName);

		// 获取联动动作集合
		Map<String, List<ConstantDetail>> actionMap = constantService.getDetailMap(1183);
		Gson gson = new GsonBuilder().disableHtmlEscaping().create();
		String actions = gson.toJson(actionMap);
		mv.addObject("actions", actions);
		return mv;
	}

	/**
	 * @Description 获取前台菜单Json
	 * @param name,value
	 * @return
	 * @throws Exception
	 * @Time 2018年7月25号
	 * @Author hxl
	 * @type 前端方法
	 */
	@RequestMapping(value = "/getMenuJson", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String getMenuJson(HttpServletRequest req) throws Exception {
		User user = CommonMethod.getUserBySession(req, "wssmb_front_user", false);
		List<Map<String, Object>> menuList;
		menuList = menuService.getUserMenuJson(user.getId(), "1");
		// 回写用户菜单权限
		List<Menu> m = menuService.getUserMenuList(user.getId(), "1");
		user.setMenuList(m);
		req.getSession().setAttribute("wssmb_front_user", user);
		req.getSession().setAttribute("wssmb_front_info", FrontShiroRealm.setAuthorizationInfo(m));
		// 将集合转换为json输出到页面
		Gson gson = new Gson();
		String json = gson.toJson(menuList);
		return json;
	}

	/**
	 * @Description 前台系统首页
	 * @param req
	 * @return
	 * @throws Exception
	 * @Time 2018年7月3号
	 * @Author dj
	 * @type 前端方法
	 */
	@RequestMapping(value = "/home", produces = "text/html;charset=UTF-8;")
	public ModelAndView home(HttpServletRequest req) throws Exception {
		ModelAndView mv = new ModelAndView();
		String viewName = "Front/home";
		mv.addObject("theme", "Blue");
		mv.setViewName(viewName);
		mv.addObject("websocketip", websocketip);
		mv.addObject("websocketport", websocketport);
		// 特殊权限
		User user = (User) req.getSession(true).getAttribute("wssmb_front_user");
		if (user.getUserLevel() == 0) { // 内部账号
			mv.addObject("permissions", "-1");
		} else {
			mv.addObject("permissions", user.getPermissions());
		}

		// 获取联动动作集合
		Map<String, List<ConstantDetail>> actionMap = constantService.getDetailMap(1183);
		Gson gson = new GsonBuilder().disableHtmlEscaping().create();
		String actions = gson.toJson(actionMap);
		mv.addObject("actions", actions);
		return mv;
	}

	/**
	 * @description 前台系统-实时监控页面
	 * @param req
	 * @param response
	 * @return
	 * @throws Exception
	 * @time 2018年1月29日
	 * @author jiym
	 * @type 前端方法
	 */
	@RequestMapping(value = "/monitor")
	public ModelAndView monitor(HttpServletRequest req, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("Front/monitor");
		mv.addObject("websocketip", websocketip);
		mv.addObject("websocketport", websocketport);
		// 特殊权限
		User user = (User) req.getSession(true).getAttribute("wssmb_front_user");
		if (user.getUserLevel() == 0) { // 内部账号
			mv.addObject("permissions", "-1");
		} else {
			mv.addObject("permissions", user.getPermissions());
		}

		// 获取联动动作集合
		Map<String, List<ConstantDetail>> actionMap = constantService.getDetailMap(1183);
		Gson gson = new GsonBuilder().disableHtmlEscaping().create();
		String actions = gson.toJson(actionMap);
		mv.addObject("actions", actions);
		return mv;
	}

	/**
	 * @description 前台系统-实时曲线页面
	 * @param req
	 * @param response
	 * @return
	 * @throws Exception
	 * @time 2018年7月12日
	 * @author hxl
	 */
	@RequestMapping(value = "/realtimeCurve", produces = "text/html;charset=UTF-8;")
	public ModelAndView realtimeCurve(HttpServletRequest req, HttpServletResponse response, String equipmentid,
			String equipmentname) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("Front/realtimeCurve");
		mv.addObject("websocketip", websocketip);
		mv.addObject("websocketport", websocketport);
		mv.addObject("equipmentid", equipmentid);
		equipmentname = java.net.URLDecoder.decode(equipmentname, "UTF-8");
		mv.addObject("equipmentname", equipmentname);

		return mv;
	}

	/**
	 * @Description 前台系统-通用树设置页-获取通用树
	 * @return
	 * @throws Exception
	 * @Time 2018年12月27日
	 * @Author hxl
	 * @type 前端方法
	 */
	@RequestMapping(value = "/getCommonTree", produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<TreeNode> getCommonTree(HttpServletRequest req, HttpServletResponse response, int type)
			throws Exception {
		User user = (User) req.getSession(true).getAttribute("wssmb_front_user");
		List<TreeNode> mapList = new ArrayList<TreeNode>();
		if (type == TreeType.Organization.getIndex())
			mapList = commonTreeService.getOrganizationTree(user.getOrganizationcode(), TreeNodeLevel.Device);
		else if (type == TreeType.Region.getIndex()) {
			mapList = commonTreeService.getRegionTree(user.getOrganizationcode(), TreeNodeLevel.Device);
		} else {
			// mapList =
			// commonTreeService.getBuildingRegionTree(user.getOrganizationcode());
		}
		return mapList;
	}

	/**
	 * @Description 前台系统-数据分析-设备树(GPRS-LORA-Transmission)
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time 2018年12月24日
	 * @Author dj
	 * @type 前端方法
	 */
	@RequestMapping(value = "/terminaldeviceTree", produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<TreeNode> onlinedeviceTree(HttpServletRequest req, HttpServletResponse response,
			String type) throws Exception {
		User user = (User) req.getSession(true).getAttribute("wssmb_front_user");
		List<TreeNode> mapList = new ArrayList<TreeNode>();
		if (type.equals("1"))
			mapList = commonTreeService.getOrganizationTree(user.getOrganizationcode(), TreeNodeLevel.Device);
		else
			mapList = commonTreeService.getRegionTree(user.getOrganizationcode(), TreeNodeLevel.Device);
		return mapList;
	}

	/**
	 * @Description 前台系统-数据分析-(只显示电气火灾监控系统的设备)设备树
	 * @return
	 * @throws Exception
	 * @Time 2018年7月31日
	 * @Author dj
	 * @type 前端方法
	 */
	@RequestMapping(value = "/elecDeviceTree", produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<TreeNode> elecDeviceTree(HttpServletRequest req, HttpServletResponse response,
			String type) throws Exception {
		User user = (User) req.getSession(true).getAttribute("wssmb_front_user");
		List<TreeNode> mapList = new ArrayList<TreeNode>();
		if (type.equals("1"))
			mapList = commonTreeService.getOrganizationTree(user.getOrganizationcode(), TreeNodeLevel.Device);
		else
			mapList = commonTreeService.getRegionTree(user.getOrganizationcode(), TreeNodeLevel.Device);
		return mapList;
	}

	/**
	 * @Description 前台系统-告警日志页面，默认加载第一个tab页
	 * @return
	 * @Time 2018年7月25日
	 * @Author hxl
	 */
	// @RequiresPermissions("earlyWarnManage")
	@RequestMapping(value = "/earlyWarnManage")
	public ModelAndView earlyWarnManage() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("Front/EarlyWarnManager/EarlyWarn");
		return mv;
	}

	/**
	 * @Description 前台系统-数据分析
	 * @return
	 * @throws Exception
	 * @Time 2018年7月12日
	 * @Author dj
	 */
	// @RequiresPermissions("subsystem")
	@RequestMapping(value = "/subsystem")
	public ModelAndView subsystem(HttpServletRequest req) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("Front/Subsystem/Index");
		return mv;
	}

	/**
	 * @Description 前台系统-数据分析-按不同设备类型，内容不同
	 * @param type
	 *            类型
	 * @return
	 * @Time 2018年3月21日
	 * @Author dj
	 */
	@RequestMapping(value = "/subsystemtype")
	public ModelAndView subsystemtype(String type) {
		ModelAndView mv = new ModelAndView();
		String viewName = "";
		switch (type) {
		case "transmission":
			viewName = "Front/Subsystem/Transmission/Index";
			break;
		case "gprs":
			viewName = "Front/Subsystem/Terminal/GPRS";
			break;
		case "nb_smoke":
			viewName = "Front/Subsystem/NB/Smoke";
			break;
		case "nb_gas":
			viewName = "Front/Subsystem/NB/Gas";
			break;
		case "nb_water":
			viewName = "Front/Subsystem/NB/Water";
			break;
		default:
			viewName = "Front/Subsystem/Terminal/Index";
			break;
		}
		mv.setViewName(viewName);
		return mv;
	}

	/**
	 * @Description 前台系统-数据分析
	 * @return
	 * @Time 2018年7月12日
	 * @Author dj
	 */
	// @RequiresPermissions("curve")
	@RequestMapping(value = "/curve")
	public ModelAndView curve() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("Front/Analysis/Index");
		return mv;
	}

	/**
	 * @Description 前台系统-数据分析-曲线tab页面加载
	 * @param type
	 *            类型
	 * @return
	 * @Time 
	 * @Author rcd
	 */
	@RequestMapping(value = "/curvetype")
	public ModelAndView curvetype(String type, HttpServletRequest req, Integer nodetype, Integer id) {
		ModelAndView mv = new ModelAndView();
		User user = (User) req.getSession().getAttribute("wssmb_front_user");
		mv.addObject("userid", user.getId());
		mv.addObject("username", user.getUsername());
		// websocket-事件上报通道
		mv.addObject("websocketip", websocketip);
		mv.addObject("websocketport", websocketport);
		if (type.equals("realtime")) {
			// 帧序号
			Integer seq = (Integer) redisService.get("seq");
			if (seq == null) {
				seq = 1;
				redisService.set("seq", 1);
			}	
			if (seq > 1023) {			
				redisService.set("seq", 1);
				seq = 1;
			}
			mv.addObject("seq", seq.toString());
		}
		String viewName = "";
		if (nodetype == 5 || nodetype == 6) {
			if (nodetype == 5) {
				// 根据树节点类型和id获取设备地址
				List<Terminal> list = terminalMapper.selectByIdAndType(id);
				String address = list.get(0).getAddress();
				mv.addObject("address", address);
				switch (type) {
				case "day":
					viewName = "Front/Analysis/TerminalDayCurve";
					break;
				case "realtime":
					viewName = "Front/Analysis/TerminalRealTimeCurve";
					break;
				case "online":
					viewName = "Front/Analysis/Online";
					break;
				case "alarm":
					viewName = "Front/Analysis/AlarmRate";
					break;
				case "fault":
					viewName = "Front/Analysis/FaultRate";
					break;
				case "quality":
					viewName = "Front/Analysis/PowerQualityAnalysis";
					break;
				}
			}
			if (nodetype == 6) {
				// 根据树节点类型和id获取设备地址
				List<MbAmmeter> list = ammeterMapper.selectByIdAndType(id);
				String address = list.get(0).getAmmeterCode();
				mv.addObject("address", address);
				switch (type) {
				case "day":
					viewName = "Front/Analysis/AmmeterDayCurve";
					break;
				case "realtime":
					viewName = "Front/Analysis/AmmeterRealTimeCurve";
					break;
				case "online":
					viewName = "Front/Analysis/Online";
					break;
				case "alarm":
					viewName = "Front/Analysis/AlarmRate";
					break;
				case "fault":
					viewName = "Front/Analysis/FaultRate";
					break;
				case "quality":
					viewName = "Front/Analysis/PowerQualityAnalysis";
					break;
				}
			}
		} else {
			switch (type) {
			case "online":
				viewName = "Front/Analysis/Online";
				break;
			case "alarm":
				viewName = "Front/Analysis/AlarmRate";
				break;
			case "fault":
				viewName = "Front/Analysis/FaultRate";
				break;
			case "quality":
				viewName = "Front/Analysis/PowerQualityAnalysis";
				break;
			}
		}
		mv.setViewName(viewName);
		return mv;
	}

	/**
	 * @Description 前台系统-修改密码页面
	 * @param req
	 * @return
	 * @throws Exception
	 * @Time 2018年7月25号
	 * @Author dj
	 * @type 前端方法
	 */
	@RequestMapping(value = "/modifyPassword", produces = "text/html;charset=UTF-8;")
	public ModelAndView modifyPassword(HttpServletRequest req) throws Exception {
		ModelAndView mv = new ModelAndView();
		String viewName = "Front/modifyPassword";
		User user = (User) req.getSession().getAttribute("wssmb_front_user");
		mv.addObject("username", user.getUsername());

		mv.setViewName(viewName);
		return mv;
	}

	/**
	 * @Description 前台系统-修改密码
	 * @param id
	 * @param username
	 * @return
	 * @throws Exception
	 *             * @Time 2018年7月25日
	 * @Author hxl
	 * @type 前端方法
	 */
	@RequestMapping(value = "/changePassword", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String changePassword(HttpServletRequest req, String name, String oldpassword, String password)
			throws Exception {
		User user = (User) req.getSession().getAttribute("wssmb_front_user");
		if (oldpassword.equals(password)) {
			return "The new password cannot be equal to the old password!";
		}
		if (name.equals(user.getUsername()) && MD5Util.MD5(oldpassword).equals(user.getPassword())) {
			return userService.changePassword(name, password);
		} else
			return "Old Password is wrong!";
	}

	/**
	 * @Description 前台系统-关于系统
	 * @param req
	 * @return
	 * @throws Exception
	 * @Time 2018年7月25号
	 * @Author hxl
	 */
	@RequestMapping(value = "/about", produces = "text/html;charset=UTF-8;")
	public ModelAndView about(HttpServletRequest req) throws Exception {
		ModelAndView mv = new ModelAndView();
		String viewName = "Front/about";
		mv.setViewName(viewName);
		return mv;
	}

	/**
	 * @Description 前台系统-处理告警
	 * @param req
	 * @return
	 * @throws Exception
	 * @Time 2018年12月28号
	 * @Author dj
	 * @type 前端方法
	 */
	@RequestMapping(value = "/dealAlarm", produces = "text/html;charset=UTF-8;")
	public ModelAndView dealAlarm(HttpServletRequest req, Integer id) throws Exception {
		ModelAndView mv = new ModelAndView();
		String viewName = "Front/dealAlarm";
		mv.addObject("id", id);
		mv.addObject("date", new Date());
		mv.setViewName(viewName);
		return mv;
	}

	/**
	 * @Description 前台系统-处理故障
	 * @param req
	 * @return
	 * @throws Exception
	 * @Time 2019年1月3号
	 * @Author dj
	 * @type 前端方法
	 */
	@RequestMapping(value = "/dealFault", produces = "text/html;charset=UTF-8;")
	public ModelAndView dealFault(HttpServletRequest req, Integer id) throws Exception {
		ModelAndView mv = new ModelAndView();
		String viewName = "Front/dealFault";
		mv.addObject("id", id);
		mv.addObject("date", new Date());
		mv.setViewName(viewName);
		return mv;
	}

	/**
	 * @Description 帮助文档页
	 * @param req
	 * @return
	 * @throws Exception
	 * @Time 2019年4月2号
	 * @Author dj
	 */
	@RequestMapping(value = "/helpDocument", produces = "text/html;charset=UTF-8;")
	public ModelAndView helpDocument(HttpServletRequest req) throws Exception {
		ModelAndView mv = new ModelAndView();
		String viewName = "Front/helpDocument";
		mv.setViewName(viewName);
		return mv;
	}

	//////////// ************************ 公用树
	//////////// ************************////////////
	/**
	 * @Description 前台系统-用户树
	 * @return
	 * @throws Exception
	 * @Time 2018年7月25日
	 * @Author hxl
	 * @type 前端方法
	 */
	@RequestMapping(value = "/customerTree", produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<TreeNode> customerTree(HttpServletRequest req, HttpServletResponse response,
			String treetype) throws Exception {
		User user = (User) req.getSession(true).getAttribute("wssmb_front_user");
		List<TreeNode> mapList = new ArrayList<TreeNode>();
		// if("1".equals(treetype))
		// mapList =
		// commonTreeService.getOrganizationTree(user.getOrganizationcode(),
		// TreeNodeLevel.Customer, "", false, false, false, false);
		// else
		// mapList = commonTreeService.getRegionTree(user.getOrganizationcode(),
		// TreeNodeLevel.Customer, "", false, false, false, false);
		return mapList;
	}

	/**
	 * @Description 前端系统-终端树
	 * @return
	 * @throws Exception
	 * @Time 2019年5月29日
	 * @Author dj
	 * @type 前端方法
	 */
	@RequestMapping(value = "/unitTree", produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<TreeNode> unitTree(HttpServletRequest req, HttpServletResponse response, String treetype,
			boolean showGprs, boolean showLora, boolean showNB, boolean showTransmission) throws Exception {
		User user = (User) req.getSession(true).getAttribute("wssmb_front_user");
		List<TreeNode> mapList = new ArrayList<TreeNode>();
		if (treetype.equals("1"))
			mapList = commonTreeService.getOrganizationTree(user.getOrganizationcode(), TreeNodeLevel.Terminal);
		else
			mapList = commonTreeService.getRegionTree(user.getOrganizationcode(), TreeNodeLevel.Terminal);
		return mapList;
	}

	/**
	 * @Description 前端系统-设备树
	 * @return
	 * @throws Exception
	 * @Time 2019年5月29日
	 * @Author
	 * @type 前端方法
	 */
	@RequestMapping(value = "/deviceTree", produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<TreeNode> deviceTree(HttpServletRequest req, HttpServletResponse response,
			String treetype) throws Exception {
		User user = (User) req.getSession(true).getAttribute("wssmb_front_user");
		if (user == null) {
			user = (User) req.getSession(true).getAttribute("user");
		}
		List<TreeNode> mapList = new ArrayList<TreeNode>();
		String code = user.getOrganizationcode();
		if (code == null || code.equals("")) {// code为0，权限为最大
			user.setOrganizationcode("10001");
		}
		if (treetype.equals("1")) {
			mapList = commonTreeService.getOrganizationTree(user.getOrganizationcode(), TreeNodeLevel.Terminal);
		} else if (treetype.equals("2")) {
			mapList = commonTreeService.getRegionTree(user.getOrganizationcode(), TreeNodeLevel.Ammeter);
		} else
			mapList = commonTreeService.getRegionTree(user.getOrganizationcode(), TreeNodeLevel.Terminal);
		return mapList;
	}

	/**
	 * @Description 前端系统-表箱树
	 * @return
	 * @throws Exception
	 * @Time 2019年9月27日
	 * @Author hxl
	 * @type 前端方法
	 */
	@RequestMapping(value = "/boxTree", produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<TreeNode> boxTree(HttpServletRequest req, HttpServletResponse response, String treetype)
			throws Exception {
		User user = (User) req.getSession(true).getAttribute("wssmb_front_user");
		List<TreeNode> mapList = new ArrayList<TreeNode>();
		String code = user.getOrganizationcode();
		if (code.equals("")) {
			user.setOrganizationcode("10001");
		}
		if (treetype.equals("1")) {
			mapList = commonTreeService.getOrganizationTree(user.getOrganizationcode(), TreeNodeLevel.MeasureFile);
		} else
			mapList = commonTreeService.getRegionTree(user.getOrganizationcode(), TreeNodeLevel.MeasureFile);
		return mapList;
	}

	/**
	 * @Description 前台系统-数据分析-在线率
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author rcd
	 * @type
	 */
	// 终端在线率-获取数据
	@RequestMapping(value = "/unitonline")
	public @ResponseBody Map<String, String[]> unitonline(HttpServletRequest re, Integer id, Integer type)
			throws Exception {
		// 初始时根据用户权限加载type
		User user = CommonMethod.getUserBySession(re, "wssmb_front_user", false);
		return monitorservice.unitonline(user.getOrganizationid(), id, type);
	}

	/**
	 * @Description 前台树
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author rcd
	 */
	@RequestMapping(value = "/treeNode", produces = "application/json;charset=UTF-8;")
	public @ResponseBody Map<String, List<TreeNode>> treeNode(HttpServletRequest req, HttpServletResponse response,
			int type) throws Exception {
		User user = CommonMethod.getUserBySession(req, "wssmb_front_user", false);
		if (user == null) {
			user = (User) req.getSession(true).getAttribute("user");
		}
		String code = user.getOrganizationcode();
		if (code == null || code.equals("")) {// code为0时，权限为最大
			user.setOrganizationcode("10001");
		}
		Map<String, List<TreeNode>> map = commonTreeService.treeNode(user.getOrganizationcode());
		return map;
	}

	/**
	 * @Description 首页-结束告警
	 * @param model
	 * @return
	 * @Time
	 * @Author
	 */
	@RequestMapping(value = "/endEarlyWarning", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String endEarlyWarning(String id) throws Exception {
		return earlyWarnService.endEarlyWarning(id);
	}

	/**
	 * @Description 首页-获取历史告警信息
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time 2018年7月25日
	 * @Author hxl
	 * @type 前端方法
	 */
	@PostMapping("/getOfflineInfo")
	public ResponseResult getOfflineInfo(HttpServletRequest req) throws Exception {
		User user = (User) req.getSession(true).getAttribute("wssmb_front_user");
		ResponseResult historyMessage = earlyWarnService.getOfflineInfo(user.getOrganizationid());
		return historyMessage;
		// return null;
	}

	/**
	 * @Description 首页-结束故障
	 * @param model
	 * @return
	 * @Time 2018年10月22日
	 * @Author
	 */
	@RequestMapping(value = "/endFault", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String endFault(String id) throws Exception {
		return faultService.endFault(id);
	}

	/**
	 * @Description 前台系统-数据分析-终端状态
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author
	 * @type 前端方法
	 */
	@RequestMapping(value = "/unitFileInf", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String unitFileInf(HttpServletRequest re, Integer id, String status, Integer unittype,
			Integer type, int page, int rows) throws Exception {
		// 初始时根据用户权限加载type
		User user = CommonMethod.getUserBySession(re, "wssmb_front_user", false);
		return monitorservice.getUnitFilePage(user.getOrganizationid(), id, status, unittype, type,
				(page - 1) * rows + 1, page * rows);
	}

	/**
	 * @Description 前台系统-数据分析-终端状态
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author Eric
	 * @type 前端方法
	 */
	@PostMapping("/getUserMessage")
	public User getUserMessage(HttpServletRequest req) throws Exception {
		User user = (User) req.getSession(true).getAttribute("wssmb_front_user");
		return user;
	}

	/**
	 * @Description 告警 - e锁 - mac查询
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author Eric
	 * @type 前端方法
	 */
	@PostMapping("/getLockByMac")
	public MbAieLock getLockByMac(String mac) throws Exception {
		return mbAieLockService.getLockByMac(mac);

	}

	/**
	 * @Description 更改e锁开关状态
	 * @param openStatus0-关闭，1-打开
	 * @param id
	 *            e锁id
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author hxl
	 * @type 前端方法
	 */
	@PostMapping("/changeElockOpenStatus")
	public String changeElockOpenStatus(Integer openStatus, Integer id) throws Exception {
		return mbAieLockService.changeOpenStatus(openStatus, id);
	}

	/**
	 * @Description 更改表箱门节点状态
	 * @param openStatus0-关闭，1-打开
	 * @param measureId
	 *            表箱id
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author hxl
	 * @type 前端方法
	 */
	@PostMapping("/changeBoxOpenStatus")
	public String changeBoxOpenStatus(Integer openStatus, Integer measureId) throws Exception {
		return measureFileService.changeOpenStatus(openStatus, measureId);
	}

	/**
	 * @Description 更改蓝牙断路器开关状态
	 * @param openStatus0-关闭，1-打开
	 * @param ammeterId
	 *            电表id
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author hxl
	 * @type 前端方法
	 */
	@PostMapping("/changeMeterBreakerOpenStatus")
	public String changeMeterBreakerOpenStatus(Integer openStatus, Integer ammeterId) throws Exception {
		return mbBlueBreakerService.changeOpenStatus(openStatus, ammeterId);
	}

	/**
	 * @Description 前台系统-电表实时曲线
	 * @return
	 * @Time 2019年10月25日
	 * @Author Eric
	 */
	@RequestMapping(value = "/ammeterAnalysis")
	public ModelAndView ammeterAnalysis(String type, HttpServletRequest req, Integer nodetype, Integer id) {
		ModelAndView mv = new ModelAndView();
		User user = (User) req.getSession().getAttribute("wssmb_front_user");
		mv.addObject("userid", user.getId());
		mv.addObject("username", user.getUsername());
		// websocket-事件上报通道
		mv.addObject("websocketip", websocketip);
		mv.addObject("websocketport", websocketport);
		if (type.equals("realtime")) {
			// 帧序号
			Integer seq = (Integer) redisService.get("seq");
			if (seq == null) {
				seq = 1;
				redisService.set("seq", 1);
			} else {
				Integer num = (Integer) redisService.get("seq") + 1;
				if (num > 1024) {
					num = 1;
				}
				redisService.set("seq", num);
			}
			mv.addObject("seq", seq.toString());
		}
		String viewName = "";
		if (nodetype == 5 || nodetype == 6) {
			if (nodetype == 5) {
				// 根据树节点类型和id获取设备地址
				List<Terminal> list = terminalMapper.selectByIdAndType(id);
				String address = list.get(0).getAddress();
				mv.addObject("address", address);
				switch (type) {
				case "realtime":
					viewName = "Front/real";
					break;
				}
			}
			if (nodetype == 6) {
				// 根据树节点类型和id获取设备地址
				List<MbAmmeter> list = ammeterMapper.selectByIdAndType(id);
				String address = list.get(0).getAmmeterCode();
				mv.addObject("address", address);
				switch (type) {
				case "realtime":
					viewName = "Front/real";
					break;
				}
			}
		}
		mv.setViewName(viewName);
		return mv;
	}

}
