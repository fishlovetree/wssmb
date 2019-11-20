package com.ssm.wssmb.service.impl;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssm.wssmb.mapper.MbAmmeterMapper;
import com.ssm.wssmb.mapper.OrgAndCustomerMapper;
import com.ssm.wssmb.mapper.OrganizationMapper;
import com.ssm.wssmb.mapper.SysLogMapper;
import com.ssm.wssmb.mapper.UserMapper;
import com.ssm.wssmb.model.OrgAndCustomer;
import com.ssm.wssmb.model.SysLog;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.service.LogService;
import com.ssm.wssmb.util.ExcelBean;
import com.ssm.wssmb.util.ExcelUtil;

@Service
public class LogServiceImpl implements LogService {

	@Resource
	private SysLogMapper logMapper;

	@Resource
	private OrganizationMapper organizationMapper;

	@Resource
	OrgAndCustomerMapper orgAndCustomerMapper;

	@Autowired
	UserMapper userMapper;
	
	@Autowired
	MbAmmeterMapper ammeterMapper;

	@Override
	public boolean insert(SysLog log) throws Exception {
		int result = logMapper.insertSelective(log);
		if (result == 1) {
			return true;
		} else {
			return false;
		}

	}

	@Override
	public List<SysLog> getLogList(String currentorgcode, String organization, String user, String starttime,
			String endtime, String keyword, String operatetype, int startindex, int endindex) throws Exception {
		/*
		 * if(null!=endtime && ""!=endtime){ endtime =
		 * DatePoccess.getAfterDay(endtime);//yy-MM-dd 获取后一天的日期 }
		 */
		Integer startin = startindex - 1;
		List<SysLog> list = new ArrayList<SysLog>();
		if (null == organization || "" == organization) {
			list = logMapper.selectLogs(null, user, starttime, endtime, keyword, operatetype, currentorgcode, startin,
					endindex);
		} else {
			List<OrgAndCustomer> orgAndCustomers = orgAndCustomerMapper.selectListByCode(organization);
			list = logMapper.selectLogs(orgAndCustomers, user, starttime, endtime, keyword, operatetype, currentorgcode,
					startin, endindex);
		}
		return list;
	}

	@Override
	public int getLogListCount(String currentorgcode, String organization, String user, String starttime,
			String endtime, String keyword, String operatetype) throws Exception {
		/*
		 * if(null!=endtime && ""!=endtime){ endtime =
		 * DatePoccess.getAfterDay(endtime);//yy-MM-dd 获取后一天的日期 }
		 */

		int count;
		if (null == organization || "" == organization) {
			count = logMapper.selectLogsCount(null, user, starttime, endtime, keyword, operatetype, currentorgcode);
		} else {
			List<OrgAndCustomer> orgAndCustomers = orgAndCustomerMapper.selectListByCode(organization);
			count = logMapper.selectLogsCount(orgAndCustomers, user, starttime, endtime, keyword, operatetype,
					currentorgcode);
		}
		return count;
	}

	@Override
	public SysLog getLogByID(Integer id) throws Exception {
		SysLog log = logMapper.selectByPrimaryKey(id);
		return log;
	}

	@Override
	public List<SysLog> getExportLogList(String currentorgcode, String organization, String user, String starttime,
			String endtime, String keyword, String operatetype) throws Exception {
		List<SysLog> list = new ArrayList<SysLog>();
		if (null == organization || "" == organization) {
			list = logMapper.selectExportLogs(null, user, starttime, endtime, keyword, operatetype, currentorgcode);
		} else {
			List<OrgAndCustomer> orgAndCustomers = orgAndCustomerMapper.selectListByCode(organization);
			list = logMapper.selectExportLogs(orgAndCustomers, user, starttime, endtime, keyword, operatetype,
					currentorgcode);
		}
		return list;
	}

	@Override
	public XSSFWorkbook exportExcelInfo(String nameDate, List<SysLog> list) throws Exception {
		List<ExcelBean> excel = new ArrayList<>();
		Map<Integer, List<ExcelBean>> map = new LinkedHashMap<>();
		XSSFWorkbook xssfWorkbook = null;
		// 设置标题栏
		excel.add(new ExcelBean("操作人", "username", 0));
		excel.add(new ExcelBean("操作人IP地址", "ip", 0));
		excel.add(new ExcelBean("操作类型", "operatename", 0));
		excel.add(new ExcelBean("标题", "title", 0));
		excel.add(new ExcelBean("内容", "content", 0));
		excel.add(new ExcelBean("操作时间", "intime", 0));
		map.put(0, excel);
		String sheetName = nameDate + "操作日志";
		// 调用ExcelUtil的方法
		xssfWorkbook = ExcelUtil.createExcelFile(SysLog.class, list, map, sheetName);
		return xssfWorkbook;
	}

	/**
	 * 后台综合查询获取日志集合，根据树节点类型和id获取日志 
	 * rcd
	 */
	@Override
	public List<SysLog> getLogListByIdAndType(User user, Integer id, Integer type, String starttime, String endtime,
			String operatetype, int startindex, int endindex) throws Exception {
		List<SysLog> list = new ArrayList<SysLog>();
		List<User> userlist = new ArrayList<User>();
		startindex = startindex - 1;
		String keyword="";
		if (type == 4) {// 集中器
			keyword = "集中器id：" + id.toString();			
		}
		if (type == 5) {//终端
			keyword = "消防终端id：" + id.toString();			
		}
		if (type == 6) {
		String	ammeterCode =  ammeterMapper.selectByIdAndType(id).get(0).getAmmeterCode();
			keyword = "表号：" + ammeterCode;			
		}
		if (user.getOrganizationcode().equals("")) {// 超级管理员账号
			userlist = null;
			list = logMapper.getLogListByIdAndType(userlist, keyword, starttime, endtime, operatetype, startindex,
					endindex);
		} else {//普通账号
			userlist = userMapper.SelectUserByOrg(user.getOrganizationid());
			list = logMapper.getLogListByIdAndType(userlist, keyword, starttime, endtime, operatetype, startindex,
					endindex);
		}
		return list;
	}

	/**
	 * 后台综合查询获取日志集合，根据树节点类型和id获取日志数量 
	 * rcd
	 */
	@Override
	public int getLogCountByIdAndType(User user, Integer id, Integer type, String starttime, String endtime,
			String operatetype) throws Exception {
		int count = 0;
		List<User> userlist = new ArrayList<User>();
		String keyword="";
		if (type == 4) {// 集中器
			keyword = "集中器id：" + id.toString();			
		}
		if (type == 5) {//终端
			keyword = "消防终端id：" + id.toString();			
		}
		if (type == 6) {
		String	ammeterCode =  ammeterMapper.selectByIdAndType(id).get(0).getAmmeterCode();
			keyword = "表号：" + ammeterCode;			
		}
		if (user.getOrganizationcode().equals("")) {// 超级管理员账号
			userlist = null;
			count = logMapper.getLogCountByIdAndType(userlist, keyword, starttime, endtime, operatetype);
		} else {
			userlist = userMapper.SelectUserByOrg(user.getOrganizationid());
			count = logMapper.getLogCountByIdAndType(userlist, keyword, starttime, endtime, operatetype);
		}
		return count;
	}

}
