package com.ssm.wssmb.controller;

import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.locks.Lock;

import javax.annotation.Resource;
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
import com.ssm.wssmb.mapper.MeasureFileMapper;
import com.ssm.wssmb.model.MeasureFile;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.service.CommonTreeService;
import com.ssm.wssmb.service.MeasureFileService;
import com.ssm.wssmb.service.UntilService;
import com.ws.apdu698.BaseRequest;

import cmcciot.onenet.nbapi.sdk.elock.ELock;

@Controller
@RequestMapping(value = "/measureFile")
public class MeasureFileManageController {

	@Autowired
	MeasureFileService measureFileService;

	@Resource
	private UntilService untilService;

	@Resource
	MeasureFileMapper measureFileMapper;

	@Resource
	private CommonTreeService commonTreeService;

	@RequestMapping(value = "/index")
	public ModelAndView index(HttpServletRequest req, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("ArchivesManagement/MeasureFileManage");
		return mv;
	}

	/**
	 * 获取表箱，点击树查询表箱
	 * 
	 * @Description 获取表箱列表
	 * @return
	 * @throws @Time
	 * @Author
	 */
	@RequestMapping(value = "/getDataGrid", produces = "text/html;charset=UTF-8;")
	public @ResponseBody String getDataGrid(HttpServletRequest req, Integer id, Integer type, String name,
			String number, String address) throws Exception {
		User user = CommonMethod.getUserBySession(req, "user", false);
		// 防止报空指针
		if (user == null) {
			user = (User) req.getSession(true).getAttribute("wssmb_front_user");
		}
		// 当前页
		String page = req.getParameter("page");
		// 每页的条数
		String rows = req.getParameter("rows");
		List<MeasureFile> list = new ArrayList<MeasureFile>();
		if (id == null) {
			list = measureFileService.getList(user.getOrganizationid());
		} else {
			list = measureFileService.cliekTreeList(type, id, name, number, address);
		}

		return untilService.getDataPager(list, Integer.parseInt(page), Integer.parseInt(rows));
	}

	/**
	 * @Description 处理添加或修改请求
	 * @return
	 * @throws @Time
	 * @Author
	 */
	@RequestMapping(value = "/addOrUpdate", produces = "text/html;charset=UTF-8;")
	public @ResponseBody String addOrUpdate(HttpServletRequest req, String measureId, String measureNumber,
			String measureName, String address, String longitude, String latitude, Integer organizationId,
			String manufacturer, String produceDate, String region) throws Exception {
		User user = CommonMethod.getUserBySession(req, "user", false);
		String creater = user.getUsername();
		Date createDate = new Date();
		return measureFileService.addOrUpdate(measureId, measureNumber, measureName, address, longitude, latitude,
				organizationId, manufacturer, produceDate, creater, createDate, region);
	}

	/**
	 * @Description 删除
	 * @param id
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author
	 */
	@RequestMapping(value = "/delete", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String delete(MeasureFile record) throws Exception {
		return measureFileService.delete(record);
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
		List<MeasureFile> list = measureFileService.readExcelFile(excelfile);
		if (list.size() == 0) {
			return "success";
		}
		boolean flag = measureFileService.dealList(list);
		if (flag) {
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
	 * @Author rcd
	 */
	@RequestMapping("/exportExcel")
	public @ResponseBody void exportExcel(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Integer id = Integer.parseInt(request.getParameter("nodegid"));
		Integer type = Integer.parseInt(request.getParameter("nodetype"));
		String searchname = request.getParameter("searchname");
		String searchnumber = request.getParameter("searchnumber");
		String searchaddress = request.getParameter("searchaddress");
		User user = CommonMethod.getUserBySession(request, "user", false);
		// 根据条件查询数据，把数据装载到一个list中
		List<MeasureFile> list = new ArrayList<MeasureFile>();	
		if (id == null) {
			list = measureFileService.getList(user.getOrganizationid());
		} else {
			list = getListByAddtion(id, type, searchname, searchnumber, searchaddress);
		}
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
		String nameDate = "MeasureFile" + formatter.format(new Date());// excel名称
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
			workbook = measureFileService.exportExcelInfo(nameDate, list);
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

	// 根据条件获取表箱列表
	public List<MeasureFile> getListByAddtion(Integer id, Integer type, String name, String number, String address) {
		return measureFileService.cliekTreeList(type, id, name, number, address);
	}

	/**
	 * 根据名称，编号，地址查询表箱
	 * 
	 * @param re
	 * @param MeasureName
	 * @param MeasureNumber
	 * @param Address
	 * @param page
	 * @param rows
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/MeasureFilInf", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String MeasureFilInf(HttpServletRequest re, String MeasureName, String MeasureNumber,
			String Address, int page, int rows) throws Exception {
		User user = CommonMethod.getUserBySession(re, "user", false);
		return measureFileService.searchInf(user.getOrganizationid(), MeasureName, MeasureNumber, Address,
				(page - 1) * rows + 1, page * rows);
	}

	/**
	 * 查询组织机构下的表箱
	 * 
	 * @param OrganizationId
	 * @return
	 */
	@RequestMapping(value = "/getMeasurefileByOrganizationId", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String getMeasurefileByOrganizationId(Integer OrganizationId) {
		List<MeasureFile> list = measureFileService.getMeasurefileByOrganizationId(OrganizationId);
		Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
		return gson.toJson(list);
	}

	/**
	 * 根据measureId查找一个表箱信息
	 * 
	 * @param measureId
	 * @return
	 */
	@RequestMapping(value = "/getMeasurefileByMeasureId", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String getMeasurefileByMeasureId(Integer id) {
		Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
		return gson.toJson(measureFileMapper.getMeasurefileByMeasureId(id));
	}
}
