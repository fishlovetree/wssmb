package com.ssm.wssmb.controller;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import com.google.gson.Gson;
import com.ssm.wssmb.mapper.OrgAndCustomerMapper;
import com.ssm.wssmb.model.TreeNode;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.service.CommonTreeService;
import com.ssm.wssmb.service.MenuService;
import com.ssm.wssmb.service.UntilService;
import com.ssm.wssmb.service.UserService;
import com.ssm.wssmb.util.TreeNodeLevel;

import java.util.ArrayList;

@Controller
@RequestMapping(value = "/admin")
public class LoginController {

	@Resource
	private UserService userService;

	@Resource
	private UntilService untilService;

	@Resource
	private OrgAndCustomerMapper orgAndCustomerMapper;

	@Resource
	private MenuService menuService;

	@Resource
	private CommonTreeService commonTreeService;

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

	@RequestMapping(value = "/login")
	public ModelAndView index(HttpServletRequest req, HttpServletResponse response) {
		// 设置系统语言
		if (mlanguage.equals("zh")) {
			Locale locale1 = new Locale("zh", "CN");
			req.getSession().setAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME, locale1);
		} else if (mlanguage.equals("en")) {
			Locale locale1 = new Locale("en", "US");
			req.getSession().setAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME, locale1);
		}
		// System.out.println("当前系统语言："+LocaleContextHolder.getLocale().getLanguage());

		ModelAndView mv = new ModelAndView();
		mv.setViewName("Login/login");
		return mv;
	}

	/**
	 * @Description 后端用户登录
	 * @param req
	 * @return
	 * @throws Exception
	 * @Time 2018-11-05
	 * @Author wys
	 * @type 后端方法
	 */
	@RequestMapping(value = "/userLogin", produces = "text/html;charset=UTF-8;")
	public @ResponseBody String userLogin(User user, String authcode, boolean rememberme, HttpServletRequest req,
			HttpServletResponse response) throws Exception {
		if (null != user) {
			/*
			 * //用户输入的验证码的值 String kaptchaExpected = (String) req.getSession().getAttribute(
			 * com.google.code.kaptcha.Constants.KAPTCHA_SESSION_KEY);
			 * 
			 * //校验验证码是否正确 if (authcode == null || !authcode.equals(kaptchaExpected)) {
			 * return "-1";//返回验证码错误 }
			 */

			// 登录验证
			System.out.print(user.getPassword() + "：：：：" + user.getUsername());
			boolean falg = userService.ValidateUser(user.getUsername(), user.getPassword(), maxlogintimes);
			if (falg) {
				User muser = userService.getUserByName(user.getUsername());

				if (muser.getUsertype() != 0)
					return "-2";// 非后台用户

				req.getSession().setAttribute("user", muser);

				// 放到cookie中
				// 如果需要记住账户就存储账号和密码
				if (rememberme == true) {
					Cookie cookie = new Cookie("user", user.getUsername() + "-" + user.getPassword());
					cookie.setMaxAge(60 * 60 * 24 * 3);// 保存 3天
					response.addCookie(cookie);
				} else {// 如果没有要求记住账户密码，就保存账户
					Cookie cookie = new Cookie("user", user.getUsername());
					cookie.setMaxAge(60 * 60 * 24 * 30); // 保存 30天
					response.addCookie(cookie);
				}

				String authorityStr = "1#1#1#1";
				if (muser.getUserLevel() != 0) {
					List<Map<String, Object>> menuList = menuService.getUserMenuJson(muser.getId(), "");
					int c = 0, d = 0, cur = 0, w = 0;
					Gson gson = new Gson();
					String json = gson.toJson(menuList);
					if (json.indexOf("用户档案") != -1)
						c = 1;
					if (json.indexOf("设备档案") != -1)
						d = 1;
					if (json.indexOf("设备状态") != -1)
						cur = 1;
					if (json.indexOf("告警列表") != -1)
						w = 1;

					authorityStr = c + "#" + d + "#" + cur + "#" + w;
				}
				Cookie authority = new Cookie("authority", authorityStr);
				authority.setMaxAge(60 * 60 * 24 * 30); // 保存 30天
				response.addCookie(authority);

				return "1";
			} else {
				return "0";
			}
		} else {
			return "0";
		}
	}

	/**
	 * @Description 鎴愬姛鐧婚檰璺宠浆鑷充富椤甸潰
	 * @param req
	 * @return
	 * @throws Exception
	 * @Time 2017骞�2鏈�8鏃�
	 * @Author wys
	 * @type 后端方法
	 */
	@RequestMapping(value = "/successLogin", produces = "text/html;charset=UTF-8;")
	public ModelAndView successLogin(HttpServletRequest req) throws Exception {
		ModelAndView mv = new ModelAndView();
		User user = CommonMethod.getUserBySession(req, "user", true);
		if (null == user) {
			mv.setViewName("Login/login");
			return mv;
		}

		String viewName = "Index/index";
		mv.addObject("username",
				user.getOrganizationname() == null || user.getOrganizationname().equals("") ? user.getUsername()
						: user.getOrganizationname());
		mv.addObject("version", mversion);
		user.setTheme(2);
		switch (user.getTheme()) {
		case 2:
			mv.addObject("theme", "Blue");
			break;
		default:
			mv.addObject("theme", "Yellow");
			break;
		}

		if (user.getUserLevel() == 0) { // 内部账号
			mv.addObject("permissions", "-1");
		} else {
			mv.addObject("permissions", user.getPermissions());
		}

		mv.addObject("websocketip", websocketip);
		mv.addObject("websocketport", websocketport);

		mv.setViewName(viewName);
		return mv;
	}

	/**
	 * @Description 修改密码
	 * @param req
	 * @return
	 * @throws Exception
	 * @Time 2018年1月5号
	 * @Author dj
	 * @type 后端方法
	 */
	@RequestMapping(value = "/modifyPassword", produces = "text/html;charset=UTF-8;")
	public ModelAndView modifyPassword(HttpServletRequest req) throws Exception {
		ModelAndView mv = new ModelAndView();
		User user = CommonMethod.getUserBySession(req, "user", false);

		String viewName = "Index/modifyPassword";
		mv.addObject("username", user.getUsername());

		mv.setViewName(viewName);
		return mv;
	}

	/**
	 * @Description 欢迎页
	 * @param req
	 * @return
	 * @throws Exception
	 * @Time 2018年1月5号
	 * @Author dj
	 */
	@RequestMapping(value = "/welcome", produces = "text/html;charset=UTF-8;")
	public ModelAndView welcome(HttpServletRequest re) throws Exception {
		ModelAndView mv = new ModelAndView();

		String viewName = "";
		viewName = "Index/welcome";

		mv.setViewName(viewName);
		return mv;
	}

	/*
	 * 截取列表
	 */
	public static <T> List<T> getSubListPage(List<T> list, int startIndex, int endIndex) {
		if (list == null || list.isEmpty()) {
			return null;
		}
		if (startIndex > endIndex || startIndex > list.size()) {
			return null;
		}
		if (endIndex > list.size()) {
			endIndex = list.size();
		}
		return list.subList(startIndex, endIndex);
	}

	/**
	 * @Description 关于页
	 * @param req
	 * @return
	 * @throws Exception
	 * @Time 2018年1月5号
	 * @Author dj
	 */
	@RequestMapping(value = "/about", produces = "text/html;charset=UTF-8;")
	public ModelAndView about(HttpServletRequest req) throws Exception {
		ModelAndView mv = new ModelAndView();
		String viewName = "Index/about";
		mv.setViewName(viewName);
		return mv;
	}

	/**
	 * @Description 退出后端系统
	 * @param req
	 * @return
	 * @throws Exception
	 * @Time 2018年12月05号
	 * @Author dj
	 * @type 后端方法
	 */
	@RequestMapping("/logout")
	public ModelAndView logout(HttpServletRequest req) {
		User user = (User) req.getSession().getAttribute("user");
		if (null != user) {
			req.getSession(true).removeAttribute("user");
		}
		/*
		 * if (null != req.getSession().getAttribute("info")){
		 * req.getSession().removeAttribute("info"); }
		 */
		ModelAndView mv = new ModelAndView("Login/login");
		return mv;
	}

	//////////// ************************ 公用树 ************************////////////
	/**表箱树
	 * @Description 后台系统-树
	 * @return
	 * @throws Exception
	 * @Time 2018年7月25日
	 * @Author rcd
	 * @type 后端方法
	 */
	@RequestMapping(value = "/measureFileTree", produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<TreeNode> measureFileTree(HttpServletRequest req, HttpServletResponse response,
			String treetype) throws Exception {
		User user = CommonMethod.getUserBySession(req, "user", false);
		List<TreeNode> mapList = new ArrayList<TreeNode>();
		if(treetype.equals("1"))
			mapList = commonTreeService.getOrganizationTree(user.getOrganizationcode(), 
					TreeNodeLevel.MeasureFile);
		else
			mapList = commonTreeService.getRegionTree(user.getOrganizationcode(), 
					TreeNodeLevel.MeasureFile);
		return mapList;
	}
	
	/**集中器树
	 * @Description 后台系统树
	 * @return
	 * @throws Exception
	 * @Time 
	 * @Author rcd
	 * @type 后端方法
	 */
	@RequestMapping(value = "/concentratorTree", produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<TreeNode> concentratorTree(HttpServletRequest req, HttpServletResponse response,
			String treetype) throws Exception {
		User user = CommonMethod.getUserBySession(req, "user", false);
		if (user==null) {
			user= (User) req.getSession().getAttribute("wssmb_front_user");
		}
		List<TreeNode> mapList = new ArrayList<TreeNode>();
		if(treetype.equals("1"))
			mapList = commonTreeService.getOrganizationTree(user.getOrganizationcode(), 
					TreeNodeLevel.Concentrator);
		else
			mapList = commonTreeService.getRegionTree(user.getOrganizationcode(), 
					TreeNodeLevel.Concentrator);
		return mapList;
	}
	
	/**终端树
	 * @Description 后台系统树
	 * @return
	 * @throws Exception
	 * @Time 
	 * @Author rcd
	 * @type 后端方法
	 */
	@RequestMapping(value = "/terminalTree", produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<TreeNode> terminalTree(HttpServletRequest req, HttpServletResponse response,
			String treetype) throws Exception {
		User user = CommonMethod.getUserBySession(req, "user", false);
		List<TreeNode> mapList = new ArrayList<TreeNode>();
		if(treetype.equals("1"))
			mapList = commonTreeService.getOrganizationTree(user.getOrganizationcode(), 
					TreeNodeLevel.Terminal);
		else
			mapList = commonTreeService.getRegionTree(user.getOrganizationcode(), 
					TreeNodeLevel.Terminal);
		return mapList;
	}
	
	/**电表树
	 * @Description 后台系统树
	 * @return
	 * @throws Exception
	 * @Time 
	 * @Author rcd
	 * @type 后端方法
	 */
	@RequestMapping(value = "/ammeterTree", produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<TreeNode> ammeterTree(HttpServletRequest req, HttpServletResponse response,
			String treetype) throws Exception {
		User user = CommonMethod.getUserBySession(req, "user", false);
		List<TreeNode> mapList = new ArrayList<TreeNode>();
		if(treetype.equals("1"))
			mapList = commonTreeService.getOrganizationTree(user.getOrganizationcode(), 
					TreeNodeLevel.Ammeter);
		else
			mapList = commonTreeService.getRegionTree(user.getOrganizationcode(), 
					TreeNodeLevel.Ammeter);
		return mapList;
	}



	/**
	 * @Description 账户下各类型的节点列表
	 * @return
	 * @throws Exception
	 * @Time 2019年5月29日
	 * @Author rcd
	 */
	@RequestMapping(value = "/treeNode", produces = "application/json;charset=UTF-8;")
	public @ResponseBody Map<String, List<TreeNode>> treeNode(HttpServletRequest req, HttpServletResponse response,
			int type)
			throws Exception {
		User user = CommonMethod.getUserBySession(req, "user", false);
		if (null == user)
			return null;
		Map<String, List<TreeNode>> map = commonTreeService.treeNode(user.getOrganizationcode());
		return map;
	}
	//////////// ************************ 公用树 ************************////////////
}