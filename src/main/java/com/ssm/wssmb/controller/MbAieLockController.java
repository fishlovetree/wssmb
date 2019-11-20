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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.ssm.wssmb.model.MbAieLock;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.service.MbAieLockService;
import com.ssm.wssmb.service.UntilService;
import com.ssm.wssmb.util.ResponseResult;

import cmcciot.onenet.nbapi.sdk.elock.ELock;

@RestController
@RequestMapping("/mbAieLock")
public class MbAieLockController {

	// 读取配置文件中的websocketip
	@Value("${websocketip}")
	private String websocketip;
	// 读取配置文件中的websocketport
	@Value("${websocketport}")
	private String websocketport;
	// 读取配置文件中的apiKey
	@Value("${apiKey}")
	private String apiKey;

	@Autowired
	MbAieLockService mbAieLockService;

	@Resource
	private UntilService untilService;

	/**
	 * @Description 型号管理主页面
	 * @return
	 * @Time 2019年8月23日
	 * @Author Eric
	 */
	@RequestMapping(value = "/index")
	@RequiresPermissions("mbAmmeter:index")
	public ModelAndView EquipmentFilePage() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("AieLock/AieLock");
		return mv;
	}

	/**
	 * @Description 综合查询-数据分析-集中器在线率
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time 2019年8月23日
	 * @Author Eric
	 */
	// 所有集中器-获取数据
	@PostMapping("/getAllAieLock")
	public ResponseResult getAllAieLock(HttpServletRequest req, int page, int rows) {
		User user = CommonMethod.getUserBySession(req, "user", false);
		return mbAieLockService.selectAll(user.getOrganizationid(), (page - 1) * rows + 1, rows);
	}

	/**
	 * @Description 综合查询-数据分析-在线率
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time 2019年8月23日
	 * @Author Eric
	 */
	// 在线集中器-获取数据
	@PostMapping("/addAieLock")
	public ResponseResult addAieLock(HttpServletRequest req, MbAieLock mbAieLock) {
		User user = CommonMethod.getUserBySession(req, "user", false);
		mbAieLock.setCreatePerson(user.getUsername());
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		mbAieLock.setCreateTime(sdf.format(new Date()));
		return mbAieLockService.addAieLock(mbAieLock);
	}

	/**
	 * @Description 综合查询-数据分析-集中器在线率
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time 2019年8月23日
	 * @Author Eric
	 */
	// 在线集中器-获取数据
	@PostMapping("/editAieLock")
	public ResponseResult editAieLock(MbAieLock mbAieLock, HttpServletRequest request) {
		return mbAieLockService.editAieLock(mbAieLock);
	}

	/**
	 * @Description 综合查询-数据分析-集中器在线率
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time 2019年8月23日
	 * @Author Eric
	 */
	// 在线集中器-获取数据
	@PostMapping("/deleteAieLock")
	public ResponseResult deleteAmmeter(int id) {
		return mbAieLockService.deleteAieLock(id);
	}

	/**
	 * @Description 导出excel
	 * @param
	 * @return
	 * @throws Exception
	 * @Time 2019年8月23日
	 * @Author Eric
	 */
	@GetMapping("/exportAieLockToExcel")
	public @ResponseBody void exportAieLockToExcel(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		User user = CommonMethod.getUserBySession(request, "user", false);
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
		String nameDate = "智能e锁信息" + formatter.format(new Date());// excel名称
		response.reset(); // 清除buffer缓存
		// 指定下载的文件名
		response.setHeader("Content-Disposition",
				"attachment;filename=" + new String(nameDate.getBytes("gbk"), "ISO-8859-1") + ".xlsx");
		response.setContentType("application/vnd.ms-excel;charset=UTF-8");
		response.setHeader("Pragma", "no-cache");
		response.setHeader("Cache-Control", "no-cache");
		response.setDateHeader("Expires", 0);
		XSSFWorkbook workbook = null;
		// 导出Excel对象
		workbook = mbAieLockService.exportAieLockToExcel(user.getOrganizationid());
		OutputStream output = null;
		BufferedOutputStream bufferedOutPut = null;
		try {
			output = response.getOutputStream();
			bufferedOutPut = new BufferedOutputStream(output);
			bufferedOutPut.flush();
			workbook.write(bufferedOutPut);
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
		return;// Cannot forward after response has been committed
	}

	/**
	 * @Description 导入excel
	 * @param file
	 * @return
	 * @throws Exception
	 * @Time 2019年8月23日
	 * @Author Eric
	 */
	@PostMapping(value = "/importExcel", produces = "text/html;charset=UTF-8;")
	public @ResponseBody String importExcel(@RequestParam("excelfile") CommonsMultipartFile excelfile)
			throws Exception {
		try {
			List<MbAieLock> list = mbAieLockService.readExcelFile(excelfile);
			if (list.size() == 0) {
				return "success";
			}
			boolean flag = mbAieLockService.dealList(list);
			if (flag == true) {
				return "success";
			} else {
				return "error";
			}
		} catch (Exception e) {
			return e.getMessage();
		}
	}

	/**
	 * @Description 综合查询-数据分析-集中器在线率
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time 2019年8月23日
	 * @Author Eric
	 */
	// 所有集中器-获取数据
	@PostMapping("/queryAieLock")
	public ResponseResult queryAieLock(HttpServletRequest request, String selectValue, String inputValue, int page,
			int rows) {
		User user = CommonMethod.getUserBySession(request, "user", false);
		return mbAieLockService.queryAieLock(user.getOrganizationid(), selectValue, inputValue, (page - 1) * rows + 1,
				rows);
	}

	/**
	 * @Description 综合查询-数据分析-集中器在线率
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time 2019年8月23日
	 * @Author Eric
	 */
	// 所有集中器-获取数据
	@PostMapping("/queryAielockByTree")
	public @ResponseBody String queryAielockByTree(HttpServletRequest request, int type, int gid, int page, int rows)
			throws Exception {
		User user = CommonMethod.getUserBySession(request, "user", false);
		if (type == 1) {// 公用树点击组织机构
			String treeType = "Organization";
			int orgId = gid;
			List<MbAieLock> queryAieLockByTree = mbAieLockService.queryAieLockByTree(treeType, orgId);
			return untilService.getDataPager(queryAieLockByTree, page, rows);
		} else if (type == 3) {// 公用树点击表箱
			String treeType = "MeasureFile";
			int measureId = gid;
			List<MbAieLock> queryAieLockByTree = mbAieLockService.queryAieLockByTree(treeType, measureId);
			return untilService.getDataPager(queryAieLockByTree, page, rows);
		} else if (type == 2) {
			String treeType = "Area";
			int orgId = gid;
			List<MbAieLock> queryAmmeterByTree = mbAieLockService.queryAieLockByTree(treeType, orgId);
			return untilService.getDataPager(queryAmmeterByTree, page, rows);
		} else {
			return "";
			// return mbAmmeterService.queryAmmeter(user.getOrganizationid(),
			// "", "", (page - 1) * rows + 1, rows);
		}
	}

	/**
	 * @Description 综合查询-数据分析-集中器在线率
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time 2019年8月23日
	 * @Author Eric
	 */
	// 所有集中器-获取数据
	@PostMapping("/queryAielockOpenStatus")
	public @ResponseBody String queryAielockOpenStatus(HttpServletRequest request, int id, String apikey, String imei)
			throws Exception {
		ELock eLock = new ELock();
		String openLock = eLock.OpenLock(apikey, imei);
		return openLock;

	}

	/**
	 * @Description 综合查询-数据分析-集中器在线率
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time 2019年8月23日
	 * @Author Eric
	 */
	// 所有集中器-获取数据
	@PostMapping("/queryAielockCloseStatus")
	public @ResponseBody String queryAielockCloseStatus(HttpServletRequest request, int id, String apikey, String imei)
			throws Exception {
		ELock eLock = new ELock();
		String openLock = eLock.CloseLock(apikey, imei);
		return openLock;

	}
	//
	// /**
	// * @Description 创建到onenet平台
	// * @param 设备
	// * @return
	// * @throws Exception
	// * @Time 2019年9月24日
	// * @Author Eric
	// */
	// @PostMapping(value = "/oneNetCreateAieLock")
	// public @ResponseBody String oneNetCreateAieLock(MbAieLock mbAieLock)
	// throws Exception {
	// return mbAieLockService.oneNetCreateDevice(apiKey, mbAieLock);
	// }
}
