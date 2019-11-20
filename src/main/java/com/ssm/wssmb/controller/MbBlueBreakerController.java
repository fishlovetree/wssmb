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
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.ssm.wssmb.model.MbBlueBreaker;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.service.MbBlueBreakerService;
import com.ssm.wssmb.service.UntilService;
import com.ssm.wssmb.util.ResponseResult;

@RestController
@RequestMapping("/mbBlueBreaker")
public class MbBlueBreakerController {

	@Autowired
	MbBlueBreakerService mbBlueBreakerService;

	@Resource
	private UntilService untilService;

	/**
	 * @Description 型号管理主页面
	 * @return
	 * @Time 2019年8月23日
	 * @Author Eric
	 */
	@RequestMapping(value = "/index")
	@RequiresPermissions("mbBlueBreaker:index")
	public ModelAndView EquipmentFilePage() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("BlueBreaker/BlueBreaker");
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
	@PostMapping("/getAllBlueBreaker")
	public ResponseResult getAllBlueBreaker(HttpServletRequest req, int page, int rows) {
		User user = CommonMethod.getUserBySession(req, "user", false);
		if (user == null) {
			user = (User) req.getSession().getAttribute("wssmb_front_user");
		}
		return mbBlueBreakerService.selectAll(user.getOrganizationid(), (page - 1) * rows + 1, rows);
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
	@PostMapping("/addBlueBreaker")
	public ResponseResult addBlueBreaker(HttpServletRequest req, MbBlueBreaker mbBlueBreaker) {
		User user = CommonMethod.getUserBySession(req, "user", false);
		mbBlueBreaker.setCreatePerson(user.getUsername());
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		mbBlueBreaker.setCreateTime(sdf.format(new Date()));
		return mbBlueBreakerService.addBlueBreaker(mbBlueBreaker);
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
	@PostMapping("/editBlueBreaker")
	public ResponseResult editBlueBreaker(MbBlueBreaker mbBlueBreaker, HttpServletRequest request) {
		return mbBlueBreakerService.editBlueBreaker(mbBlueBreaker);
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
	@PostMapping("/deleteBlueBreaker")
	public ResponseResult deleteBlueBreaker(int id) {
		return mbBlueBreakerService.deleteBlueBreaker(id);
	}

	/**
	 * @Description 导出excel
	 * @param
	 * @return
	 * @throws Exception
	 * @Time 2019年8月23日
	 * @Author Eric
	 */
	@GetMapping("/exportBlueBreakerToExcel")
	public @ResponseBody void exportBlueBreakerToExcel(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		User user = CommonMethod.getUserBySession(request, "user", false);
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
		String nameDate = "蓝牙断路器信息" + formatter.format(new Date());// excel名称
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
		workbook = mbBlueBreakerService.exportBlueBreakerToExcel(user.getOrganizationid());
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
		List<MbBlueBreaker> list = mbBlueBreakerService.readExcelFile(excelfile);
		if (list.size() == 0) {
			return "success";
		}
		boolean flag = mbBlueBreakerService.dealList(list);
		if (flag == true) {
			return "success";
		} else {
			return "error";
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
	@PostMapping("/queryBlueBreaker")
	public ResponseResult queryBlueBreaker(HttpServletRequest request, String selectValue, String inputValue, int page,
			int rows) {
		User user = CommonMethod.getUserBySession(request, "user", false);
		return mbBlueBreakerService.queryBlueBreaker(user.getOrganizationid(), selectValue, inputValue,
				(page - 1) * rows + 1, rows);
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
	@PostMapping("/queryBlueBreakerByTree")
	public @ResponseBody String queryBlueBreakerByTree(HttpServletRequest request, int type, int gid, int page,
			int rows) throws Exception {
		User user = CommonMethod.getUserBySession(request, "user", false);
		if (type == 1) {// 公用树点击组织机构
			String treeType = "Organization";
			int orgId = gid;
			List<MbBlueBreaker> queryAmmeterByTree = mbBlueBreakerService.queryBlueBreakerByTree(treeType, orgId);
			return untilService.getDataPager(queryAmmeterByTree, page, rows);
		} else if (type == 3) {// 公用树点击表箱
			String treeType = "MeasureFile";
			int measureId = gid;
			List<MbBlueBreaker> queryAmmeterByTree = mbBlueBreakerService.queryBlueBreakerByTree(treeType, measureId);
			return untilService.getDataPager(queryAmmeterByTree, page, rows);
		} else if (type == 4) {// 公用树点击集中器
			String treeType = "Concentrator";
			int orgId = gid;
			List<MbBlueBreaker> queryAmmeterByTree = mbBlueBreakerService.queryBlueBreakerByTree(treeType, orgId);
			return untilService.getDataPager(queryAmmeterByTree, page, rows);
		} else if (type == 2) {
			String treeType = "Area";
			int orgId = gid;
			List<MbBlueBreaker> queryAmmeterByTree = mbBlueBreakerService.queryBlueBreakerByTree(treeType, orgId);
			return untilService.getDataPager(queryAmmeterByTree, page, rows);
		} else {
			return "";
			// return mbAmmeterService.queryAmmeter(user.getOrganizationid(),
			// "", "", (page - 1) * rows + 1, rows);
		}
	}

}
