package com.ssm.wssmb.service;

import java.util.List;

import com.ssm.wssmb.model.SysErrorlog;



/**
 * @Description:系统异常日志业务逻辑接口
 * @Author lmn
 * @Time: 2018年1月8日
 */
public interface ErrorLogService {
	
	/**
	 * @Description 插入异常日志
	 * @param errorlog
	 * @return
	 * @throws Exception
	 * @Time: 2018年1月8日
	 * @Author lmn
	 */
	public boolean insert(SysErrorlog log)throws Exception;
	
	/**
	 * @Description 获取异常日志集合
	 * @return
	 * @throws Exception
	 * @Time: 2018年1月8日
	 * @Author lmn
	 */
	public List<SysErrorlog> getLogList(String organization,String user,String starttime,String endtime,int startindex, int endindex)throws Exception;
	
	/**
	 * @Description 获取异常日志总数
	 * @return
	 * @throws Exception
	 * @Time: 2018年6月2日
	 * @Author hxl
	 */
	public int getLogListCount(String organization,String user,String starttime,String endtime)throws Exception;
	
	/**
	 * @Description 根据日志id获取异常明细
	 * @return
	 * @throws Exception
	 * @Time: 2018年1月8日
	 * @Author lmn
	 */
	public SysErrorlog getLogRow(Integer logid)throws Exception;
}