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
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.ssm.wssmb.model.MeasureFile;
import com.ssm.wssmb.model.Terminal;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.service.TerminalService;
import com.ssm.wssmb.service.UntilService;

@RequestMapping(value = "/terminal")
@RestController
public class TerminalController {

	@Autowired
	TerminalService terminalService;

	@Autowired
	UntilService untilService;

	// 读取配置文件中的websocketip
	@Value("${websocketip}")
	private String websocketip;
	// 读取配置文件中的websocketport
	@Value("${websocketport}")
	private String websocketport;
	// 读取配置文件中的apiKey
	@Value("${apiKey}")
	private String apiKey;

	@RequestMapping(value = "/index")
	public ModelAndView index(HttpServletRequest req, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("ArchivesManagement/terminalManage");
		mv.addObject("websocketip", websocketip);
		mv.addObject("websocketport", websocketport);
		return mv;
	}

	/**
	 * 获取消防终端，点击树查询
	 * 
	 * @Description 获取消防终端列表
	 * @return
	 * @throws @Time
	 * @Author
	 */
	@RequestMapping(value = "/getDataGrid", produces = "text/html;charset=UTF-8;")
	public @ResponseBody String getDataGrid(HttpServletRequest req, Integer id, Integer type, String name,
			String address) throws Exception {
		User user = CommonMethod.getUserBySession(req, "user", false);
		// 当前页
		String page = req.getParameter("page");
		// 每页的条数
		String rows = req.getParameter("rows");
		List<Terminal> list = new ArrayList<Terminal>();
		if (id == null) {
			list = terminalService.getList(user.getOrganizationid());
		} else {
			list = terminalService.cliekTreeList(type, id, name, address);
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
	public @ResponseBody String addOrUpdate(HttpServletRequest req, Terminal terminal) throws Exception {
		User user = CommonMethod.getUserBySession(req, "user", false);
		String creater = user.getUsername();
		Date createDate = new Date();
		terminal.setCreater(creater);
		terminal.setCreateDate(createDate);
		return terminalService.addOrUpdate(terminal);
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
	public @ResponseBody String delete(Terminal record) throws Exception {
		return terminalService.delete(record);
	}

	/**
	 * 根据名称，地址查询终端
	 * 
	 * @param req
	 * @param terminalName
	 * @param address
	 * @param page
	 * @param rows
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/TerminalInf", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String TerminalInf(HttpServletRequest req, String terminalName, String address, int page,
			int rows) throws Exception {
		User user = CommonMethod.getUserBySession(req, "user", false);
		return terminalService.searchInf(user.getOrganizationid(), terminalName, address, (page - 1) * rows + 1,
				page * rows);
	}

	/**
	 * @Description 导出excel
	 * @param
	 * @return
	 * @throws Exception
	 * @Time 2018年10月16日
	 * @Author hxl
	 */
	@RequestMapping("/exportExcel")
	public @ResponseBody void exportExcel(HttpServletRequest request, HttpServletResponse response) throws Exception {
		User user = CommonMethod.getUserBySession(request, "user", false);
		// 根据条件查询数据，把数据装载到一个list中
		String id = request.getParameter("nodegid");
		Integer type = Integer.parseInt(request.getParameter("nodetype"));
		String searchname = request.getParameter("searchname");
		String searchaddress = request.getParameter("searchaddress");
		List<Terminal> list = new ArrayList<Terminal>();
		if (null == id) {
			list = terminalService.getList(user.getOrganizationid());
		} else {
			list = getListByAddtion(Integer.parseInt(id), type, searchname, searchaddress);
		}
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
		String nameDate = "Terminal" + formatter.format(new Date());// excel名称
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
			workbook = terminalService.exportExcelInfo(nameDate, list);
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

	// 根据条件获取终端列表
	public List<Terminal> getListByAddtion(Integer id, Integer type, String name, String address) {
		return terminalService.cliekTreeList(type, id, name, address);
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
		List<Terminal> list = terminalService.readExcelFile(excelfile);
		if (list.size() == 0) {
			return "success";
		}
		boolean flag = terminalService.dealList(list);
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
	 * @Time 2019年8月29日
	 * @Author Eric
	 */
	// 所有集中器-获取数据
	@PostMapping("/queryTerminalByAddress")
	public Terminal queryTerminalByAddress(String address) {
		return terminalService.queryTerminalByAddress(address);
	}
}
