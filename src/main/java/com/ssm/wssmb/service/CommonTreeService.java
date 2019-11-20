package com.ssm.wssmb.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ssm.wssmb.model.TreeNode;
import com.ssm.wssmb.model.TreeSetting;
import com.ssm.wssmb.util.TreeNodeLevel;

public interface CommonTreeService {
	
	/**
	 * @Description 组织结构树
	 * @param organizationcode 登录账号所在组织机构代码
	 * @param treeLevel 最低层级
	 * @param systemtype 系统类型
	 * @param showGprs 是否显示GPRS设备
	 * @param showLora 是否显示LORA设备
	 * @param showNB 是否显示NB设备
	 * @param showTransmission 是否显示用户传输装置和设备
	 * @return
	 * @throws Exception
	 * @Time 2018年12月13日
	 * @Author hxl
	 */
	List<TreeNode> getOrganizationTree(String organizationcode, TreeNodeLevel treeLevel) throws Exception;
	
	/**
	 * @Description 区域树
	 * @param organizationcode 登录账号所在组织机构代码
	 * @param treeLevel 最低层级
	 * @param systemtype 系统类型
	 * @param showGprs 是否显示GPRS设备
	 * @param showLora 是否显示LORA设备
	 * @param showNB 是否显示NB设备
	 * @param showTransmission 是否显示用户传输装置和设备
	 * @return
	 * @throws Exception
	 * @Time 2018年12月14日
	 * @Author hxl
	 */
	List<TreeNode> getRegionTree(String organizationcode, TreeNodeLevel treeLevel) throws Exception;
	
	
	/**
	 * @Description 保存通用树节点收起配置
	 * @param
	 * @return
	 * @throws Exception
	 * @Time 2018年12月27日
	 * @Author hxl
	 */
	String saveSettingNodes(String code, List<TreeSetting> settingNodes)throws Exception;
	
	/**
	 * @Description 获取账号下的区域列表、用户列表、终端列表、设备列表、建筑列表、摄像头列表
	 * @param organizationcode 登录账号所在组织机构代码
	 * @Author dj
	 */
	Map<String, List<TreeNode>> treeNode(String organizationcode) throws Exception;
	
	
	
}
