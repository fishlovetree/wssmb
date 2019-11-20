package com.ssm.wssmb.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.ssm.wssmb.model.SysErrorlog;
import com.ssm.wssmb.service.ErrorLogService;
import com.ssm.wssmb.service.UntilService;


/**
 * @Description:系统错误日志控制器
 * @Author lmn
 * @Time: 2018年1月8日
 */
@Controller
@RequestMapping(value = "/errorLog")
public class ErrorLogController {
	@Resource
	private ErrorLogService logService;

	@Resource
	private UntilService untilService;

	/**
	 * @Description 日志主页面
	 * @return
	 * @Time 2018年1月8日
	 * @Author lmn
	 */
	@RequestMapping(value = "/logMessage")
	@RequiresPermissions("errorLog:logMessage")
	public String logMessage() {

		return "System/ErrorLog";
	}

	/**
	 * @Description 日志分页
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time 2018年1月8日
	 * @Author lmn
	 */
	@RequestMapping(value = "/logInf", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String logInf(HttpServletRequest re,String organization,String user,String starttime,
			String endtime,int page, int rows) throws Exception {
		List<SysErrorlog> list = logService.getLogList(organization,user,starttime,endtime,(page - 1) * rows + 1,page * rows);
		int count = logService.getLogListCount(organization,user,starttime,endtime);
		String json = untilService.getDataPager(list, count);
		return json;
	}

	/**
	 * @Description 异常明细
	 * @param req
	 * @return
	 * @throws Exception
	 * @Time 2018年1月8日
	 * @Author lmn
	 */
	@RequestMapping(value = "/logDetails", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String logDetails(Integer logid) throws Exception {
		SysErrorlog model = new SysErrorlog();
		model = logService.getLogRow(logid);
		// 将对象转换为json输出到页面，并设置时间的格式
		Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss")
				.create();
		String json = gson.toJson(model);
		return json;
	}
}