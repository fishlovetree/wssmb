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

import com.ssm.wssmb.model.BusMessagepushrecord;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.service.EventRecordService;

/**
 * @Description: 告警通知日志
 * @Author dj
 * @Time: 2019年1月14日
 */
@Controller
@RequestMapping(value = "/eventrecord")
public class EventRecordController {

	@Resource
	private EventRecordService eventRecordService;
	
	/**
	 * @Description 短信通知列表
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author rcd
	 * @type 前端方法
	 */
	@RequestMapping(value = "/smsRecordDataGrid", method = RequestMethod.POST, produces = "application/json;charset=UTF-8;")
	public @ResponseBody String smsRecordDataGrid(HttpServletRequest re, Integer id, Integer type, String eventid,
			String result, String startTime, String endTime, String address, String name, int page, int rows)
			throws Exception {
		User user = (User) re.getSession(true).getAttribute("wssmb_front_user");
		return eventRecordService.smsRecordDataGrid(id,type,user.getOrganizationid(),eventid, result, startTime, endTime, address, name,
				(page - 1) * rows + 1, page * rows);
	}
	
	/**
	 * @Description 语音通知列表
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time 2019年1月14日
	 * @Author  rcd
	 * @type 前端方法
	 */
	@RequestMapping(value="/soundRecordDataGrid",method=RequestMethod.POST,produces = "application/json;charset=UTF-8;")
	public  @ResponseBody String soundRecordDataGrid(HttpServletRequest re,Integer id,Integer type,String nodeName,
			Integer parentid,String uptype,String commtype, String eventid,String result, String startTime, 
			String endTime, String address, String name, int page, int rows) throws Exception{
		User user = (User)re.getSession(true).getAttribute("wssmb_front_user");
		return eventRecordService.soundRecordDataGrid(id,type,user.getOrganizationid(), eventid, 
				result, startTime, endTime, address, name,(page - 1) * rows + 1,page * rows);
	} 

}
