package com.ssm.wssmb.service;

import java.util.List;
import java.util.Map;

import com.ssm.wssmb.model.Menu;

/**
 * @Description:工具类接口（主要用于json数据的拼装）
 * @Author wys
 * @Time: 2017年4月26日
 */
public interface UntilService {
	
	
	/**
	 * @Description 获取分页json数据
	 * @param list 对象集合
	 * @param page 当前页
	 * @param rows 每页行数
	 * @return
	 * @throws Exception
	 * @Time 2018年1月5日
	 * @Author lmn
	 */
	public String getDataPager(List<?> list, int page,int rows)throws Exception;
	
	/**
	 * @Description 获取分页json数据
	 * @param list 对象集合
	 * @param page 当前页
	 * @param rows 每页行数
	 * @return
	 * @throws Exception
	 * @Time 2018年1月31日
	 * @Author lmn
	 */
	public String getGsonDataPager(List<?> list, int page,int rows)throws Exception;
	
	/**
	 * @Description 转datagrid json
	 * @param list
	 * @return
	 * @throws Exception
	 * @Time 2018年1月5日
	 * @Author lmn
	 */
	public String getDataPager(List<?> list, int page, int rows, Boolean flag,String footer)throws Exception;
	
	/**
	 * @Description 转datagrid json (sql语句分页)
	 * @param list
	 * @return
	 * @throws Exception
	 * @Time 2018年6月2日
	 * @Author hxl
	 */
	public String getDataPager(List<?> list, int count) throws Exception;
	
	public List<Map<String, Object>> createTreeGrid(List<Menu> list, int pid)throws Exception;
	
}
