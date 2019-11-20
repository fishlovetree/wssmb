package com.ssm.wssmb.service;

import java.util.List;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.ssm.wssmb.model.SysLog;
import com.ssm.wssmb.model.User;

public interface LogService {

	/**
	 * @Description 插入日志
	 * @param log
	 * @return
	 * @throws Exception
	 * @Time 2018年1月8日
	 * @Author lmn
	 */
	public boolean insert(SysLog log) throws Exception;

	/**
	 * @Description 通过id获取日志
	 * @param id
	 * @return
	 * @throws Exception
	 * @Time 2018年1月8日
	 * @Author lmn
	 */
	public SysLog getLogByID(Integer id) throws Exception;

	/**
	 * @Description 获取日志集合
	 * @return
	 * @throws Exception
	 * @Time 2018年1月8日
	 * @Author lmn
	 * @Update hxl 2018-12-05 增加currentorgcode（当前登录账号所在组织机构）字段
	 */
	public List<SysLog> getLogList(String currentorgcode, String organization, String user, String starttime,
			String endtime, String keyword, String operatetype, int startindex, int endindex) throws Exception;

	/**
	 * @Description 获取导出日志集合
	 * @return
	 * @throws Exception
	 * @Time 2018年11月22日
	 * @Author lmn
	 * @Update hxl 2018-12-05 增加currentorgcode（当前登录账号所在组织机构）字段
	 */
	public List<SysLog> getExportLogList(String currentorgcode, String organization, String user, String starttime,
			String endtime, String keyword, String operatetype) throws Exception;

	/**
	 * @Description 获取日志总数
	 * @return
	 * @throws Exception
	 * @Time 2018年6月3日
	 * @Author hxl
	 * @Update hxl 2018-12-05 增加currentorgcode（当前登录账号所在组织机构）字段
	 */
	public int getLogListCount(String currentorgcode, String organization, String user, String starttime,
			String endtime, String keyword, String operatetype) throws Exception;

	/**
	 * @Description 生成excel文件
	 * @param nameDate 文件名称
	 * @param list     数据
	 * @return
	 * @Time 2018年11月22日
	 * @Author lmn
	 */
	public XSSFWorkbook exportExcelInfo(String nameDate, List<SysLog> list) throws Exception;

	/**
	 * @Description 后台综合查询获取日志集合，根据树节点类型和id获取日志
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author rcd
	 * 
	 */
	List<SysLog> getLogListByIdAndType(User user, Integer id, Integer type, String starttime, String endtime,
			String operatetype, int startindex, int endindex) throws Exception;

	/**
	 * @Description 后台综合查询获取日志集合，根据树节点类型和id获取日志数量
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author rcd
	 * 
	 */
	int getLogCountByIdAndType(User user, Integer id, Integer type, String starttime, String endtime,
			String operatetype) throws Exception;

}
