package com.ssm.wssmb.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.ssm.wssmb.mapper.MbAmmeterMapper;
import com.ssm.wssmb.mapper.OrgAndCustomerMapper;
import com.ssm.wssmb.mapper.RegionMapper;
import com.ssm.wssmb.mapper.TerminalMapper;
import com.ssm.wssmb.model.MbAmmeter;
import com.ssm.wssmb.model.Terminal;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.model.ViewEquipmentstatus;
import com.ssm.wssmb.redis.RedisService;
import com.ssm.wssmb.service.BusFaultService;
import com.ssm.wssmb.service.CommonTreeService;
import com.ssm.wssmb.service.ComplexService;
import com.ssm.wssmb.service.EarlyWarnService;
import com.ssm.wssmb.service.MonitorService;
import com.ssm.wssmb.service.UntilService;
import com.ssm.wssmb.service.ViewEquipmentService;

@Controller
@RequestMapping(value = "/complex")
public class ComplexController {

	@Resource
	private MonitorService monitorservice;

	@Resource
	private ComplexService complexService;

	@Autowired
	private EarlyWarnService earlyWarnService;

	@Autowired
	private BusFaultService faultService;

	@Autowired
	RedisService redisService;

	@Autowired
	TerminalMapper terminalMapper;

	@Autowired
	MbAmmeterMapper ammeterMapper;

	// 读取配置文件中的websocketip
	@Value("${websocketip}")
	private String websocketip;
	// 读取配置文件中的websocketport
	@Value("${websocketport}")
	private String websocketport;

	// 综合查询首页
	@RequestMapping(value = "/inquire")
	public ModelAndView inquire(HttpServletRequest req, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("Complex/Inquire");
		mv.addObject("websocketip", websocketip);
		mv.addObject("websocketport", websocketport);
		return mv;
	}

	// 综合查询-在线率
	@RequestMapping(value = "/online")
	public ModelAndView online(HttpServletRequest req, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("Complex/Online");
		return mv;
	}

	/**
	 * @Description 综合查询-数据分析-在线率
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author
	 */
	// 终端在线率-获取数据
	@RequestMapping(value = "/unitonline")
	public @ResponseBody Map<String, String[]> unitonline(HttpServletRequest re, Integer id, Integer type)
			throws Exception {
		// 初始时根据用户权限加载type
		User user = CommonMethod.getUserBySession(re, "user", false);
		return monitorservice.unitonline(user.getOrganizationid(), id, type);
	}

	/**
	 * @Description 综合查询-数据分析-终端状态
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author
	 */
	@RequestMapping(value = "/unitFileInf", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String unitFileInf(HttpServletRequest re, Integer id, Integer type, String nodeName,
			Integer parentid, Integer unitid, String status, Integer unittype, int page, int rows) throws Exception {
		// 初始时根据用户权限加载type
		User user = CommonMethod.getUserBySession(re, "user", false);
		return monitorservice.getUnitFilePage(user.getOrganizationid(), id, status, unittype, type,
				(page - 1) * rows + 1, page * rows);
	}

	// 综合查询-设备数据
	@RequestMapping(value = "/devicedata")
	public ModelAndView devicedata(HttpServletRequest req, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("Complex/DeviceData");
		return mv;
	}

	/**
	 * 
	 * @param req
	 * @param response
	 * @return
	 * @author rcd
	 */
	// 后台系统-数据分析-综合查询-参数管理
	@RequestMapping(value = "/unitparams")
	public ModelAndView unitparams(HttpServletRequest req, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("Complex/Dialog/UnitParams");
		return mv;
	}

	/**
	 * @Description 解析前置机回传数据
	 * @param record
	 * @return
	 * @throws Exception
	 * @Time 2019年5月16日
	 * @Author dj
	 */
	@RequestMapping(value = "/parseResponse", produces = "application/json;charset=UTF-8;")
	public @ResponseBody Map<String, Object> parseResponse(String strXML) throws Exception {
		return complexService.parseResponse(strXML);
	}

	/**
	 * 后台用电质量分析
	 * 
	 * @return rcd
	 */
	@RequestMapping(value = "/PowerQualityAnalysis")
	public ModelAndView PowerQualityAnalysis() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("Complex/PowerAnalysis/index");
		return mv;
	}

	/**
	 * 后台用电质量分析
	 * 
	 * @return rcd
	 */
	@RequestMapping(value = "/load")
	public ModelAndView load() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("Complex/PowerAnalysis/PowerQualityAnalysis");
		return mv;
	}

	/**
	 * 后台电表状态
	 * 
	 * @return rcd
	 */
	@RequestMapping(value = "/ammeterStatus")
	public ModelAndView ammeterStatus() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("Complex/EquipmentStatus/ammeterStatus");
		return mv;
	}

	/**
	 * 后台终端状态
	 * 
	 * @return rcd
	 */
	@RequestMapping(value = "/terminalStatus")
	public ModelAndView terminalStatus() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("Complex/EquipmentStatus/terminalStatus");
		return mv;
	}

	/**
	 * 后台集中器状态
	 * 
	 * @return rcd
	 */
	@RequestMapping(value = "/concentratorStatus")
	public ModelAndView concentratorStatus() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("Complex/EquipmentStatus/concentratorStatus");
		return mv;
	}

	/**
	 * @Description 后台综合查询-冻结曲线
	 * @param req
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author rcd
	 */
	@RequestMapping(value = "/freezeCurve", produces = "text/html;charset=UTF-8;")
	public ModelAndView freezeCurve(HttpServletRequest req, Integer type, String text, Integer gid) throws Exception {
		ModelAndView mv = new ModelAndView();
		String viewName = "";
		mv.addObject("gid", gid);
		mv.addObject("text", text);
		mv.addObject("type", type);
		if (type == 5) {// 终端
			viewName = "Complex/Dialog/DayCurve";
		} else {// 电表
			viewName = "Complex/Dialog/AmmeterDayCurve";
		}
		mv.setViewName(viewName);
		return mv;
	}

	/**
	 * @Description 后台综合查询-告警列表
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author rcd
	 */
	@RequestMapping(value = "/alarmList", method = RequestMethod.POST, produces = "application/json;charset=UTF-8;")
	public @ResponseBody String alarmList(HttpServletRequest re, String startTime, String endTime, Integer id,
			Integer type, int page, int rows) throws Exception {
		User user = CommonMethod.getUserBySession(re, "user", false);
		return earlyWarnService.queryEarly(id, type, user.getOrganizationid(), startTime, endTime, null, null,
				(page - 1) * rows + 1, page * rows);
	}

	/**
	 * @Description 后台综合查询-故障列表
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author rcd
	 */
	@RequestMapping(value = "/faultList", method = RequestMethod.POST, produces = "application/json;charset=UTF-8;")
	public @ResponseBody String faultList(HttpServletRequest re, Integer id, Integer type, Integer status, Integer end,
			String startTime, String endTime, String faultType, int page, int rows) throws Exception {
		User user = CommonMethod.getUserBySession(re, "user", false);
		return faultService.queryFault(id, type, user.getOrganizationid(), status, end, startTime, endTime, faultType,
				null, null, (page - 1) * rows + 1, page * rows);
	}

	/**
	 * @Description 后台综合查询-实时曲线
	 * @param req
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author rcd
	 */
	@RequestMapping(value = "/realtimeCurve", produces = "text/html;charset=UTF-8;")
	public ModelAndView realtimeCurve(HttpServletRequest req, Integer nodetype, Integer id) throws Exception {
		ModelAndView mv = new ModelAndView();
		User user = (User) req.getSession().getAttribute("wssmb_front_user");
		if (user == null) {
			user = CommonMethod.getUserBySession(req, "user", false);
		}
		mv.addObject("userid", user.getId());
		mv.addObject("username", user.getUsername());
		// websocket-事件上报通道
		mv.addObject("websocketip", websocketip);
		mv.addObject("websocketport", websocketport);
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
		String viewName = "";
		if (nodetype == 5) {
			// 根据树节点类型和id获取设备地址
			List<Terminal> list = terminalMapper.selectByIdAndType(id);
			String address = list.get(0).getAddress();
			mv.addObject("address", address);
			viewName = "Complex/Dialog/RealTimeCurve";
		}
		if (nodetype == 6) {
			// 根据树节点类型和id获取设备地址
			List<MbAmmeter> list = ammeterMapper.selectByIdAndType(id);
			String address = list.get(0).getAmmeterCode();
			mv.addObject("address", address);
			viewName = "Complex/Dialog/AmmeterRealTimeCurve";
		}
		mv.setViewName(viewName);
		return mv;
	}

	/**
	 * @Description 后台综合查询-事件阀值
	 * @param req
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author rcd
	 */
	@RequestMapping(value = "/eventthreshold")
	public ModelAndView eventthreshold(HttpServletRequest req, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("Complex/Dialog/EventThreshold");
		return mv;
	}

}
