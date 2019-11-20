package com.ssm.wssmb.controller;

import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.ssm.wssmb.model.ConstantDetail;
import com.ssm.wssmb.model.ProxyAlarmPlan;
import com.ssm.wssmb.model.ProxyAlarmPlanEvent;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.service.ConstantService;
import com.ssm.wssmb.service.ProxyAlarmPlanService;
import com.ssm.wssmb.service.UntilService;

/**
 * @Description: 代理告警方案控制器
 * @Author hxl
 * @Time: 2019年4月3日
 */
@Controller
@RequestMapping(value="/proxyAlarmPlan")
public class ProxyAlarmPlanController {
	
	@Resource
	private ProxyAlarmPlanService proxyAlarmPlanService;
	
	@Resource
	private ConstantService constantService;
	
	@Resource
	private UntilService untilService;
	
	/**
	 * @Description 代理告警方案页面
	 * @return
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
	@RequestMapping(value="/index")
	public ModelAndView index(){
		ModelAndView mv = new ModelAndView();
		mv.setViewName("Maintenance/ProxyAlarmPlan/Index");
		List<ConstantDetail> eventList = constantService.getDetailList(1011);
		mv.addObject("eventList", eventList);
		return  mv;
	}
	
	/**
	 * @Description 代理基础告警方案页面
	 * @return
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
	@RequestMapping(value="/basic")
	public ModelAndView basic(){
		ModelAndView mv = new ModelAndView();
		mv.setViewName("Maintenance/ProxyAlarmPlan/Basic");
		List<ConstantDetail> eventList = constantService.getDetailList(1011);
		mv.addObject("eventList", eventList);
		return  mv;
	}
	
	/**
	 * @Description 获取代理告警方案列表
	 * @param plantype 0-基础，1-代理
	 * @return
	 * @throws Exception
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
	@RequestMapping(value="/getDataGrid", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String getDataGrid(HttpServletRequest req, Integer plantype) throws Exception {	
		// 当前页
		String page = req.getParameter("page");
		// 每页的条数
		String rows = req.getParameter("rows");
		User user = CommonMethod.getUserBySession(req, "user", false);
		List<ProxyAlarmPlan> list = proxyAlarmPlanService.getSchemeList(plantype, user.getOrganizationid());	
		return untilService.getDataPager(list, Integer.parseInt(page),
				Integer.parseInt(rows));
	}
	
	/**
	 * @Description 添加代理告警方案
	 * @return
	 * @throws Exception
	 * @Time 2019年4月3日
	 * @Author hxl
	 * @type 后端方法
	 */
	@RequestMapping(value="/addScheme",method=RequestMethod.POST,produces = "text/html;charset=UTF-8;")
	public @ResponseBody String addScheme(HttpServletRequest req, ProxyAlarmPlan model) throws Exception {
		User user = CommonMethod.getUserBySession(req, "user", false);
		model.setCompactor(user.getId());
		model.setCompilationtime(new Date());
		return proxyAlarmPlanService.addScheme(model);	
	}
	
	/**
	 * @Description 修改代理告警方案
	 * @return
	 * @throws Exception
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
	@RequestMapping(value="/editScheme",method=RequestMethod.POST,produces = "text/html;charset=UTF-8;")
	public @ResponseBody String editScheme(ProxyAlarmPlan model) throws Exception{
		return proxyAlarmPlanService.editScheme(model);		
	}
	
	/**
	 * @Description 通过id删除告警方案
	 * @param id
	 * @return
	 * @throws Exception
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
	@RequestMapping(value="/deleteScheme",method=RequestMethod.POST,produces = "text/html;charset=UTF-8;")
	public @ResponseBody String deleteScheme(int id) throws Exception{
		return proxyAlarmPlanService.deleteScheme(id);			
	}
	
	/**
	 * @Description 获取告警方案事件
	 * @param id 方案id
	 * @return
	 * @throws Exception
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
	@RequestMapping(value="/getAlarmEvent",produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<ProxyAlarmPlanEvent> getAlarmEvent(int id) throws Exception {	
		return proxyAlarmPlanService.getAlarmEvent(id);	
	}
	
	/**
	 * @Description 保存告警方案事件
	 * @param id 方案id
	 * @param events 事件id集合
	 * @return
	 * @throws Exception
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
	@RequestMapping(value="/saveAlarmEvent", produces = "text/html;charset=UTF-8;")
	public @ResponseBody String saveAlarmEvent(int id, String events) throws Exception {	
		return proxyAlarmPlanService.saveAlarmEvent(id, events);	
	}
	
	/**
	 * @Description 设置告警委托
	 * @param id 方案id
	 * @return
	 * @throws Exception
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
	@RequestMapping(value="/entrust", produces = "text/html;charset=UTF-8;")
	public @ResponseBody String entrust(int id) throws Exception {	
		return proxyAlarmPlanService.entrust(id);	
	}
	
	/**
	 * @Description 取消告警委托
	 * @param id 方案id
	 * @return
	 * @throws Exception
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
	@RequestMapping(value="/unentrust", produces = "text/html;charset=UTF-8;")
	public @ResponseBody String unentrust(int id) throws Exception {	
		return proxyAlarmPlanService.unentrust(id);	
	}
}
