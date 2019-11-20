package com.ssm.wssmb.service;

import java.util.List;

import com.ssm.wssmb.model.ThreeModel;

/**
 * @Description: 三维模型业务接口
 * @Author hxl
 * @Time: 2018年1月13日
 */
public interface ThreeModelService {
	
	/**
	 * @Description 获取三维模型集合
	 * @return
	 * @Time 2018年1月13日
	 * @Author hxl
	 */
	public List<ThreeModel> getModelList();
	
	/**
	 * @Description 获取三维模型集合
	 * @return
	 * @Time 2018年1月13日
	 * @Author hxl
	 */
	public ThreeModel getModelByCode(String code);
}
