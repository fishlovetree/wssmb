package com.ssm.wssmb.controller;

import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.ssm.wssmb.mapper.MbAmmeterMapper;
import com.ssm.wssmb.mapper.OrgAndCustomerMapper;
import com.ssm.wssmb.mapper.TerminalMapper;
import com.ssm.wssmb.model.ViewOnlineunit;
import com.ssm.wssmb.redis.RedisService;
import com.ssm.wssmb.model.AmmeterStatus;
import com.ssm.wssmb.model.MbAmmeter;
import com.ssm.wssmb.model.Terminal;
import com.ssm.wssmb.model.TreeNode;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.model.ViewEquipment;
import com.ssm.wssmb.service.CommonTreeService;
import com.ssm.wssmb.service.EarlyWarnService;
import com.ssm.wssmb.service.EquipmentStatusService;
import com.ssm.wssmb.service.MonitorService;
import com.ssm.wssmb.service.UntilService;
import com.ssm.wssmb.service.ViewEquipmentService;
import com.ssm.wssmb.util.TreeNodeLevel;

/**
 * @Description: 数据分析
 * @Author dj
 * @Time: 2018年2月1号
 */
@Controller
@RequestMapping(value = "/sysMonitor")
public class MonitorController {

	@Resource
	private MonitorService monitorservice;

	@Resource
	private CommonTreeService commonTreeService;

	@Resource
	private UntilService untilService;

	@Resource
	private ViewEquipmentService viewEquipmentService;

	@Resource
	private EarlyWarnService earlyWarnService;

	@Autowired
	TerminalMapper terminalMapper;

	@Autowired
	MbAmmeterMapper ammeterMapper;

	@Autowired
	EquipmentStatusService equipStatusService;

	// 读取配置文件中的websocketip
	@Value("${websocketip}")
	private String websocketip;
	// 读取配置文件中的websocketport
	@Value("${websocketport}")
	private String websocketport;

	// 实时曲线
	@RequestMapping(value = "/index")
	public ModelAndView index() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("Monitor/Analysis/index");
		return mv;
	}

	/**
	 * @Description 后台系统-数据分析-曲线tab页面加载
	 * @param type 类型
	 * @return
	 * @Time 2018年3月21日
	 * @Author dj
	 */
	@RequestMapping(value = "/curvetype")
	public ModelAndView curvetype(String type) {
		ModelAndView mv = new ModelAndView();
		String viewName = "";
		switch (type) {
		case "day":
			viewName = "Monitor/Analysis/DayCurve";
			break;
		case "online":
			viewName = "Monitor/Analysis/Online";
			break;
		case "alarm":
			viewName = "Monitor/Analysis/AlarmRate";
			break;
		case "fault":
			viewName = "Monitor/Analysis/FaultRate";
			break;
		default:
			viewName = "Monitor/Analysis/RealTimeCurve";
			break;
		}
		mv.setViewName(viewName);
		return mv;
	}

	/**
	 * 
	 * @param equipmentid
	 * @param startdate
	 * @param enddate
	 * @param checkbox
	 * @param type
	 * @param realdata
	 * @return
	 * @throws Exception rcd
	 */
	// 实时曲线-获取数据
	@RequestMapping(value = "/realtimedata")
	public @ResponseBody Map<String, Object> realtimedata(Integer equipmentid, String startdate, String enddate,
			String checkbox, Integer type) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		if (type == 5) {
			List<Terminal> equipmentlist = terminalMapper.selectByIdAndType(equipmentid);
			if (equipmentlist.size() == 1) {
				Terminal equipment = equipmentlist.get(0);
				String equipmentaddress = equipment.getAddress();
				String result = monitorservice.realtimedata( type,equipmentaddress, checkbox,
						startdate, enddate);
				if (result.equals("null")) {
					map.put("result", null);
				} else {
					map.put("result", result);
				}
				return map;
			} else {
				map.put("result", null);
				return map;
			}
		} else {
			List<MbAmmeter> equipmentlist = ammeterMapper.selectByIdAndType(equipmentid);
			if (equipmentlist.size() == 1) {
				MbAmmeter equipment = equipmentlist.get(0);
				String equipmentaddress = equipment.getAmmeterCode();
				String result = monitorservice.realtimedata( type, equipmentaddress, checkbox,
						startdate, enddate);
				if (result.equals("null")) {
					map.put("result", null);
				} else {
					map.put("result", result);
				}
				return map;
			} else {
				map.put("result", null);
				return map;
			}

		}
	}

	/**
	 * 
	 * @param equipmentid
	 * @param startdate
	 * @param enddate
	 * @param checkbox
	 * @param type
	 * @return
	 * @throws Exception rcd
	 */
	// 冻结日曲线-获取数据
	@RequestMapping(value = "/daydata")
	public @ResponseBody Map<String, Object> daydata(Integer equipmentid, String startdate, String enddate,
			String checkbox, Integer type) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		if (type == 5) { // 终端
			List<Terminal> equipmentlist = terminalMapper.selectByIdAndType(equipmentid);
			if (equipmentlist.size() == 1) {
				Terminal equipment = equipmentlist.get(0);
				String equipmentaddress = equipment.getAddress();		
				String result = monitorservice.daydata(type, equipmentaddress, checkbox, startdate, enddate);
				if (result.equals("null")) {
					map.put("result", null);
				} else {
					map.put("result", result);
				}
				return map;
			} else
				map.put("result", null);
			return map;
		} else {
			List<MbAmmeter> equipmentlist = ammeterMapper.selectByIdAndType(equipmentid);
			if (equipmentlist.size() == 1) {
				MbAmmeter equipment = equipmentlist.get(0);
				String equipmentaddress = equipment.getAmmeterCode();
				String result = monitorservice.daydata(type, equipmentaddress, checkbox, startdate, enddate);
				if (result.equals("null")) {
					map.put("result", null);
				} else {
					map.put("result", result);
				}
				return map;
			} else
				map.put("result", null);
			return map;
		}
	}

	/**
	 * 用电质量
	 * 
	 * @param re
	 * @param id
	 * @param type
	 * @param startdate
	 * @param enddate
	 * @param page
	 * @param rows
	 * @return
	 * @throws Exception rcd
	 */
	@RequestMapping(value = "/powerdata", method = RequestMethod.POST, produces = "application/json;charset=UTF-8;")
	public @ResponseBody String powerdata(HttpServletRequest re, Integer id, Integer type, String startdate,
			String enddate, int page, int rows) throws Exception {
		User user = CommonMethod.getUserBySession(re, "wssmb_front_user", false);
		if (user == null) {
			user = CommonMethod.getUserBySession(re, "user", false);
		}
		return monitorservice.powerdata(id, type, user.getOrganizationid(), startdate, enddate, (page - 1) * rows + 1,
				page * rows);
	}

	/**
	 * @Description 电表状态
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author rcd
	 */
	@RequestMapping(value = "/ammeterStatus", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String ammeterStatus(HttpServletRequest req, Integer id, Integer type, Integer status,
			Integer page, Integer rows) throws Exception {
		User user = CommonMethod.getUserBySession(req, "user", false);
		List<AmmeterStatus> list = equipStatusService.getAmmeterStatus(user.getOrganizationid(), id, type, status);
		return untilService.getDataPager(list, page, rows);
	}

	/**
	 * @Description 终端状态
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author rcd
	 */
	@RequestMapping(value = "/terminalStatus", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String terminalStatus(HttpServletRequest req, Integer id, Integer type, Integer status,
			Integer page, Integer rows) throws Exception {
		User user = CommonMethod.getUserBySession(req, "user", false);
		List<AmmeterStatus> list = equipStatusService.getTerminalStatus(user.getOrganizationid(), id, type, status);
		return untilService.getDataPager(list, page, rows);
	}

	/**
	 * @Description 集中器状态
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author rcd
	 */
	@RequestMapping(value = "/concentratorStatus", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String concentratorStatus(HttpServletRequest req, Integer id, Integer type, Integer status,
			Integer page, Integer rows) throws Exception {
		User user = CommonMethod.getUserBySession(req, "user", false);
		List<AmmeterStatus> list = equipStatusService.getConcentratorStatus(user.getOrganizationid(), id, type, status);
		return untilService.getDataPager(list, page, rows);
	}

}
