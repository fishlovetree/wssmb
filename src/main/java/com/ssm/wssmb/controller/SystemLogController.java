package com.ssm.wssmb.controller;

import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.ssm.wssmb.model.SysLog;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.service.LogService;
import com.ssm.wssmb.service.UntilService;

/**
 * @Description:
 * @Author
 * @Time:
 */
@Controller
@RequestMapping(value = "/sysLog")
public class SystemLogController {
	@Resource
	private LogService logService;

	@Resource
	private UntilService untilService;

	/**
	 * @Description 日志主页面
	 * @return
	 * @Time
	 * @Author
	 */
	@RequestMapping(value = "/logMessage")
	@RequiresPermissions("sysLog:logMessage")
	public String logMessage() {

		return "System/SystemLog";
	}

	/**
	 * @Description 日志分页
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author rcd
	 */
	@RequestMapping(value = "/logInf", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String logInf(HttpServletRequest re, String organization, String user, String starttime,
			String endtime, String keyword, String operatetype, int page, int rows) throws Exception {
		// 根据登录账号获取本组织机构
		User loginUser = (User) re.getSession(true).getAttribute("user");
		System.out.print(loginUser);

		// long start = new Date().getTime();
		List<SysLog> list = logService.getLogList(loginUser == null ? null : loginUser.getOrganizationcode(),
				organization, user, starttime, endtime, keyword, operatetype, (page - 1) * rows + 1, page * rows);
		// long middle = new Date().getTime();
		int count = logService.getLogListCount(loginUser == null ? null : loginUser.getOrganizationcode(), organization,
				user, starttime, endtime, keyword, operatetype);
		// long end = new Date().getTime();
		// System.out.println("time1="+(middle-start));
		// System.out.println("time2="+(end-middle));
		String json = untilService.getDataPager(list, count);
		return json;
	}

	/**
	 * @Description 日志明细
	 * @param req
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author
	 */
	@RequestMapping(value = "/logDetails", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String logDetails(Integer logid) throws Exception {
		SysLog log = logService.getLogByID(logid);
		// 将对象转换为json输出到页面，并设置时间的格式
		Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
		String json = gson.toJson(log);
		return json;
	}

	/**
	 * @Description 导出excel
	 * @param
	 * @return
	 * @throws Exception
	 * @Time 2018年11月22日
	 * @Author lmn
	 */
	@RequestMapping(value = "/exportExcel", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody void export(HttpServletRequest request, HttpServletResponse response, String organizationcode,
			String user, String starttime, String endtime, String keyword, String operatetype) throws Exception {
		// 根据登录账号获取本组织机构
		User loginUser = (User) request.getSession(true).getAttribute("user");
		// 根据条件查询数据，把数据装载到一个list中
		List<SysLog> list = logService.getExportLogList(loginUser == null ? null : loginUser.getOrganizationcode(),
				organizationcode, user, starttime, endtime, keyword, operatetype);
		for (int i = 0; i < list.size(); i++) {
			list.get(i).setLogid(i + 1);
		}
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
		String nameDate = "Syslog" + formatter.format(new Date());// excel名称
		if (nameDate != "") {
			response.reset(); // 清除buffer缓存
			// Map<String,Object> map=new HashMap<String,Object>();
			// 指定下载的文件名
			response.setHeader("Content-Disposition", "attachment;filename=" + nameDate + ".xlsx");
			response.setContentType("application/vnd.ms-excel;charset=UTF-8"); // 下载文件类型
			// 不要缓存
			response.setHeader("Pragma", "no-cache"); // Pragma(HTTP1.0)
			response.setHeader("Cache-Control", "no-cache"); // Cache-Control(HTTP1.1)
			response.setDateHeader("Expires", 0); // Expires:过时期限值

			XSSFWorkbook workbook = null;
			// 导出Excel对象
			workbook = logService.exportExcelInfo(nameDate, list);
			OutputStream output = null;
			BufferedOutputStream bufferedOutPut = null;
			try {
				output = response.getOutputStream();
				bufferedOutPut = new BufferedOutputStream(output);
				workbook.write(bufferedOutPut);
				bufferedOutPut.flush();
				output.flush();
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				if (output != null) {
					output.close();
					output = null;
				}
				if (bufferedOutPut != null) {
					bufferedOutPut.close();
					bufferedOutPut = null;
				}
			}
		}
		return;// Cannot forward after response has been committed
	}

	/**
	 * @Description 后台综合查询-操作日志-分页
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author rcd
	 */
	@RequestMapping(value = "/logInfo", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String logInfo(HttpServletRequest re, Integer id, Integer type, String starttime,
			String endtime, String operatetype, int page, int rows) throws Exception {
		// 根据登录账号获取本组织机构
		User user = (User) re.getSession(true).getAttribute("user");
		List<SysLog> list = logService.getLogListByIdAndType(user, id, type, starttime, endtime, operatetype,
				(page - 1) * rows + 1, page * rows);
		int count = logService.getLogCountByIdAndType(user, id, type, starttime, endtime, operatetype);
		String json = untilService.getDataPager(list, count);
		return json;
	}

}
