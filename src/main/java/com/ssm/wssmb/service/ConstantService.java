package com.ssm.wssmb.service;

import java.util.List;
import java.util.Map;

import com.ssm.wssmb.model.Constant;
import com.ssm.wssmb.model.ConstantDetail;

public interface ConstantService {

	/**
	 * @Description 获取常量集合
	 * @return
	 * @Time 2018年1月12日
	 * @Author hxl
	 */
	public List<Constant> getConstantList();
	
	/**
	 * @Description 获取常量子项集合
	 * @return
	 * @Time 2018年1月12日
	 * @Author hxl
	 */
	public List<ConstantDetail> getDetailList(int coding);
	
	/**
	 * @Description 添加常量
	 * @param constant
	 * @return
	 * @Time 2018年1月12日
	 * @Author hxl
	 */
	public String addConstant(Constant constant) throws Exception;

	/**
	 * @Description 编辑常量
	 * @param constant
	 * @return
	 * @throws Exception
	 * @Time 2018年1月12日
	 * @Author hxl
	 */
	public String editConstant(Constant constant) throws Exception;

	/**
	 * @Description 通过coding删除常量
	 * @param coding
	 * @return
	 * @throws Exception
	 * @Time 2018年1月12日
	 * @Author hxl
	 */
	public String deleteConstant(int coding) throws Exception;
	
	/**
	 * @Description 添加常量子项
	 * @param constantDetail
	 * @return
	 * @Time 2018年1月12日
	 * @Author hxl
	 */
	public String addDetail(ConstantDetail constantDetail) throws Exception;

	/**
	 * @Description 编辑常量子项
	 * @param constantDetail
	 * @return
	 * @throws Exception
	 * @Time 2018年1月12日
	 * @Author hxl
	 */
	public String editDetail(ConstantDetail constantDetail) throws Exception;

	/**
	 * @Description 通过id删除常量子项
	 * @param id
	 * @return
	 * @throws Exception
	 * @Time 2018年1月12日
	 * @Author hxl
	 */
	public String deleteDetail(int id) throws Exception;
	
	/**
	 * @Description 常量树
	 * @param id
	 * @return
	 * @throws Exception
	 * @Time 2018年1月12日
	 * @Author hxl
	 */
	public List<Map<String, Object>> getTreeData();
	
	/**
	 * @Description 获取常量子项集合(根据上级常量子项值进行归类)
	 * @return
	 * @Time 2018年12月24日
	 * @Author hxl
	 */
	public Map<String, List<ConstantDetail>> getDetailMap(int coding);
}
