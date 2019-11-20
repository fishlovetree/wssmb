package com.ssm.wssmb.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.ssm.wssmb.mapper.ThreeModelMapper;
import com.ssm.wssmb.model.ThreeModel;
import com.ssm.wssmb.service.ThreeModelService;

@Service
public class ThreeModelServiceImpl implements ThreeModelService {
	
	@Resource
	ThreeModelMapper threeModelMapper;
	
	/**
	 * @Description 获取三维模型集合
	 * @return
	 * @Time 2018年1月13日
	 * @Author hxl
	 */
	public List<ThreeModel> getModelList(){
		return threeModelMapper.selectList();
	}
	
	/**
	 * @Description 获取三维模型集合
	 * @return
	 * @Time 2018年1月13日
	 * @Author hxl
	 */
	public ThreeModel getModelByCode(String code){
		return threeModelMapper.selectByPrimaryKey(code);
	}
}
