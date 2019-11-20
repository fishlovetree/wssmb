package com.ssm.wssmb.controller;

import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.ssm.wssmb.model.Concentrator;
import com.ssm.wssmb.model.MeasureFile;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.service.ConcentratorService;
import com.ssm.wssmb.service.UntilService;

@Controller
@RequestMapping(value = "/concentratorFile")
public class ConcentratorController {

	@Autowired
	ConcentratorService concentratorService;

	@Autowired
	UntilService untilService;

	@RequestMapping(value = "/index")
	public ModelAndView index(HttpServletRequest req, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("ArchivesManagement/ConcentratorFileManage");
		return mv;
	}

	/**
	 * 获取表箱列表、点击树查询表箱
	 * 
	 * @Description 获取表箱列表
	 * @return
	 * @throws @Author
	 * @return
	 */
	@RequestMapping(value = "/getDataGrid", produces = "text/html;charset=UTF-8;")
	public @ResponseBody String getDataGrid(HttpServletRequest req, Integer id, Integer type, String name,
			String address) throws Exception {
		User user = CommonMethod.getUserBySession(req, "user", false);
		// 当前页
		String page = req.getParameter("page");
		// 每页的条数
		String rows = req.getParameter("rows");
		List<Concentrator> list = new ArrayList<Concentrator>();
		if (id == null) {
			list = concentratorService.getList(user.getOrganizationid());
		} else {
			list = concentratorService.cliekTreeList(type, id, name, address);
		}

		return untilService.getDataPager(list, Integer.parseInt(page), Integer.parseInt(rows));
	}

	/**
	 * @Description 处理添加或修改请求
	 * @return
	 * @param req
	 * @throws @Author
	 */
	@RequestMapping(value = "/addOrUpdate", produces = "text/html;charset=UTF-8;")
	public @ResponseBody String addOrUpdate(HttpServletRequest req, Concentrator concentrator) throws Exception {
		User user = CommonMethod.getUserBySession(req, "user", false);
		String creater = user.getUsername();
		Date createDate = new Date();
		concentrator.setCreater(creater);
		concentrator.setCreateDate(createDate);
		return concentratorService.addOrUpdate(concentrator);
	}

	/**
	 * @Description 删除
	 * @param
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author
	 */
	@RequestMapping(value = "/delete", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String delete(String concentratorId) throws Exception {
		return concentratorService.delete(concentratorId);
	}

	/**
	 * @Description 导入excel
	 * @param file
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author
	 */
	@RequestMapping(value = "/importExcel", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String importExcel(@RequestParam(required = false) CommonsMultipartFile excelfile)
			throws Exception {
		List<Concentrator> list = concentratorService.readExcelFile(excelfile);
		if (list.size() == 0) {
			return "success";
		}
		boolean flag = concentratorService.dealList(list);
		if (flag == true) {
			return "success";
		} else {
			return "error";
		}
	}

	/**
	 * @Description 导出excel
	 * @param
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author
	 * 
	 */
	@RequestMapping("/exportExcel")
	public @ResponseBody void exportExcel(HttpServletRequest request, HttpServletResponse response) throws Exception {
		User user = CommonMethod.getUserBySession(request, "user", false);
		Integer id = Integer.parseInt(request.getParameter("nodegid"));
		Integer type = Integer.parseInt(request.getParameter("nodetype"));
		String searchname = request.getParameter("searchname");
		String searchaddress = request.getParameter("searchaddress");
		// 根据条件查询数据，把数据装载到一个list中
		List<Concentrator> list = new ArrayList<Concentrator>();
		if (id == null) {
			list = concentratorService.getList(user.getOrganizationid());
		} else {
			list = getListByAddtion(id, type, searchname, searchaddress);
		}
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
		String nameDate = "Concentrator" + formatter.format(new Date());// excel名称
		if (nameDate != "") {
			response.reset(); // 清除buffer缓存
			// 指定下载的文件名
			response.setHeader("Content-Disposition", "attachment;filename=" + nameDate + ".xlsx");
			response.setContentType("application/vnd.ms-excel;charset=UTF-8");
			response.setHeader("Pragma", "no-cache");
			response.setHeader("Cache-Control", "no-cache");
			response.setDateHeader("Expires", 0);
			XSSFWorkbook workbook = null;
			// 导出Excel对象
			workbook = concentratorService.exportExcelInfo(nameDate, list);
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
		}
		return;// Cannot forward after response has been committed
	}

	// 根据条件获取集中器列表
	public List<Concentrator> getListByAddtion(Integer id, Integer type, String name, String address) {
		return concentratorService.cliekTreeList(type, id, name, address);
	}

	/**
	 * 根据名称，地址查询集中器
	 * 
	 * @param re
	 * @param ConcentratorName
	 * @param Address
	 * @param page
	 * @param rows
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ConcentratorInf", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String ConcentratorInf(HttpServletRequest re, String ConcentratorName, String Address,
			int page, int rows) throws Exception {
		User user = CommonMethod.getUserBySession(re, "user", false);
		return concentratorService.searchInf(user.getOrganizationid(), ConcentratorName, Address, (page - 1) * rows + 1,
				page * rows);
	}

	/**
	 * 获取表箱下的集中器
	 * 
	 * @param measureId
	 * @return
	 */
	@RequestMapping(value = "/getConcentratorByMeasureId", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String getConcentratorByMeasureId(Integer measureId) {
		List<Concentrator> list = concentratorService.getConcentratorByMeasureId(measureId);
		Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
		return gson.toJson(list);
	}
}
