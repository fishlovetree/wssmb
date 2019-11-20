package com.ssm.wssmb.controller;

import java.util.List;
import java.util.Map;
import org.springframework.http.MediaType;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.ssm.wssmb.model.EarlyWarnAnnex;
import com.ssm.wssmb.model.EarlyWarnMX;
import com.ssm.wssmb.model.EarlyWarning;
import com.ssm.wssmb.model.EarlyWarningData;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.service.EarlyWarnService;
import com.ssm.wssmb.service.UntilService;

import aj.org.objectweb.asm.Type;

@Controller
@RequestMapping(value = "/earlyWarn")
public class EarlyWarnController {

	@Autowired
	EarlyWarnService earlyWarnService;

	@Resource
	private UntilService untilService;

	/**
	 * @Description 预警主页面，默认加载第一个tab页
	 * @return
	 * @Time
	 * @Author
	 */
	@RequestMapping(value = "/earlyWarnManage")
	@RequiresPermissions("earlyWarn:earlyWarnManage")
	public ModelAndView earlyWarnManage() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("Front/EarlyWarnManager/EarlyWarn");
		return mv;
	}

	/**
	 * @Description 预警处理列表
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author rcd
	 * @type 前端方法
	 */
	@RequestMapping(value = "/earlyDataGrid", method = RequestMethod.POST, produces = "application/json;charset=UTF-8;")
	public @ResponseBody String earlyDataGrid(HttpServletRequest re, Integer id, Integer type, String startTime,
			String endTime, String address, String name, int page, int rows) throws Exception {
		User user = CommonMethod.getUserBySession(re, "wssmb_front_user", false);
		if (user == null) {
			user = (User) re.getSession(true).getAttribute("user");
		}
		return earlyWarnService.queryEarly(id, type, user.getOrganizationid(), startTime, endTime,
				name, address, (page - 1) * rows + 1, page * rows);
	}

	/**
	 * @Description 处理预警
	 * @param earlyWarning
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author
	 * @type 前端方法
	 */
	@RequestMapping(value = "/processEarly", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String processEarly(EarlyWarning earlyWarning, @RequestParam("myAnnex") MultipartFile myAnnex,
			HttpServletRequest request) throws Exception {
		User user = (User) request.getSession(true).getAttribute("wssmb_front_user");
		earlyWarning.setHandlepeople(user.getId() + "");
		boolean falg = earlyWarnService.processEarly("wssmb_front_user", earlyWarning, myAnnex);
		if (falg == true)
			return "success";
		else
			return "error";
	}

	/**
	 * @Description 获取数据详情
	 * @param alarmId   告警表id
	 * @param dataType  数据类型：1-开始数据,2-结束数据
	 * @param alarmType 事件类型id
	 * @return
	 * @Time
	 * @Author
	 */
	@RequestMapping(value = "/earlyDataDetail", method = RequestMethod.POST, produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<EarlyWarnMX> earlyDataDetail(Integer alarmId, Integer dataType, Integer alarmType) {
		List<EarlyWarnMX> list = earlyWarnService.queryEarlyDataDetails(alarmId, dataType, alarmType);
		return list;
	}

	/**
	 * @Description 前台系统-数据分析-告警率-告警统计-饼图
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author rcd
	 * @type 前端方法
	 */
	@RequestMapping(value = "/statisticsAlarmRateQT")
	public @ResponseBody Map<Integer, Map<Integer, String[]>> statisticsAlarmRateQT(HttpServletRequest re, Integer id,
			Integer type, String year, String month, String day, String hour, String alarmtype) throws Exception {
		User user = CommonMethod.getUserBySession(re, "wssmb_front_user", false);
		return earlyWarnService.statisticsAlarmRate(user.getOrganizationid(), id, type, year, month, day, hour,
				alarmtype);
	}

	/**
	 * @Description 前台系统-数据分析-告警率-告警统计-列表
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author rcd
	 * @type 前端方法
	 */
	@RequestMapping(value = "/statisticsAlarmListQT")
	public @ResponseBody String statisticsAlarmListQT(HttpServletRequest re, Integer id, Integer type, String year,
			String month, String day, String hour, String alarmtype) throws Exception {
		User user = CommonMethod.getUserBySession(re, "wssmb_front_user", false);
		List<EarlyWarning> list = earlyWarnService.statisticsAlarmList(user.getOrganizationid(), id, type, year, month,
				day, hour, alarmtype);
		// 当前页
		String page = re.getParameter("page");
		// 每页的条数
		String rows = re.getParameter("rows");
		String json = untilService.getDataPager(list, Integer.parseInt(page), Integer.parseInt(rows));
		return json;
	}

	/**
	 * @Description 前台系统-数据分析-告警率-告警同期对比-饼图
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author rcd
	 * @type 前端方法
	 */
	@RequestMapping(value = "/alarmComparedQT", method = RequestMethod.POST, produces = "application/json;charset=UTF-8;")
	public @ResponseBody String alarmComparedQT(HttpServletRequest re, Integer id, Integer type, String nodeName,
			Integer parentid, String dateType, int equalNumber) throws Exception {
		if (dateType.equals("1")) {
			dateType = "%Y-%m";
		} else {
			dateType = "%Y";
		}
		String[] equalTime = earlyWarnService.getEqualTime(equalNumber, dateType);
		User user = (User) re.getSession(true).getAttribute("wssmb_front_user");

		List<EarlyWarningData> list = earlyWarnService.getEarlyComparison(user.getOrganizationid(), id, dateType,
				equalTime);
		return earlyWarnService.getComparisonBarDataStr(list, equalTime);
	}

	/**
	 * @Description 下载附件
	 * @param request
	 * @param id
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author
	 */
	@RequestMapping(value = "/downLoadAnnex", produces = "text/html;charset=UTF-8;")
	public @ResponseBody ResponseEntity<byte[]> downLoadAnnex(HttpServletRequest request, Integer id) throws Exception {
		EarlyWarnAnnex annax = earlyWarnService.getEarlyAnnaxByEarlyId(id);
		HttpHeaders headers = new HttpHeaders();
		// 下载显示的文件名，解决中文名称乱码问题
		String downloadFielName = new String(annax.getAnnexname().getBytes("UTF-8"), "iso-8859-1");
		// 通知浏览器以attachment（下载方式）打开图片
		headers.setContentDispositionFormData("attachment", downloadFielName);
		// application/octet-stream ： 二进制流数据（最常见的文件下载）。
		headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
		return new ResponseEntity<byte[]>(annax.getAnnex(), headers, HttpStatus.OK);
	}
}
