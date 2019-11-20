package com.ssm.wssmb.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import org.springframework.web.bind.annotation.ResponseBody;

import com.ssm.wssmb.model.BusFault;
import com.ssm.wssmb.model.EarlyWarning;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.service.BusFaultService;
import com.ssm.wssmb.service.UntilService;

/**
 * @Description: 设备故障
 * @Author
 * @Time: 
 */
@Controller
@RequestMapping(value = "/fault")
public class FaultController {

	@Resource
	private BusFaultService faultService;

	@Resource
	private UntilService untilService;

	/**
	 * @Description 设备故障列表
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author rcd
	 * @type 前端方法
	 */
	@RequestMapping(value = "/faultDataGrid", method = RequestMethod.POST, produces = "application/json;charset=UTF-8;")
	public @ResponseBody String faultDataGrid(HttpServletRequest re, Integer id, Integer type, Integer status,
			Integer end, String startTime, String endTime, String faultType, String systemtype, String address,
			String name, int page, int rows) throws Exception {
		User user = (User) re.getSession(true).getAttribute("wssmb_front_user");
		return faultService.queryFault(id, type, user.getOrganizationid(), status, end, startTime, endTime, faultType,
				name, address, (page - 1) * rows + 1, page * rows);
	}

	/**
	 * @Description 处理故障
	 * @param fault
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author rcd
	 * @type 前端方法
	 */
	@RequestMapping(value = "/processFault", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String processFault(BusFault fault, HttpServletRequest request) throws Exception {
		User user = (User) request.getSession(true).getAttribute("wssmb_front_user");
		fault.setHandlepeople(user.getId() + "");
		boolean falg = faultService.processFault("wssmb_front_user", fault);
		if (falg == true)
			return "success";
		else
			return "error";
	}

	/**
	 * @Description 前台系统-数据分析-告警率-故障统计-饼图
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author rcd
	 * @type 前端方法
	 */
	@RequestMapping(value = "/statisticsFaultRateQT")
	public @ResponseBody Map<String, Map<Integer, String[]>> statisticsFaultRateQT(HttpServletRequest re, Integer id,
			Integer type, String year, String month, String day, String hour) throws Exception {
		User user = CommonMethod.getUserBySession(re, "wssmb_front_user", false);
		return faultService.statisticsFaultRate(user.getOrganizationid(), id, type, year, month, day, hour);
	}
	
	/**
	 * @Description 前台系统-数据分析-告警率-故障统计-列表
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time 
	 * @Author rcd
	 * @type 前端方法
	 */
	@RequestMapping(value="/statisticsFaultListQT")
	public @ResponseBody String statisticsFaultListQT(HttpServletRequest re,Integer id,Integer type, String year,String month,String day,String hour,String faulttype) throws Exception{
		User user = CommonMethod.getUserBySession(re, "wssmb_front_user", false);
		List<BusFault> list = faultService.statisticsFaultList( user.getOrganizationid(),id,type,year, month, day, hour);	
		//当前页
		String page = re.getParameter("page");
		//每页的条数
        String rows = re.getParameter("rows");
        String json=untilService.getDataPager(list,Integer.parseInt(page),Integer.parseInt(rows));
		return json;
	}
	
}
