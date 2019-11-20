package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.TreeNode;
import com.ssm.wssmb.model.TreeSetting;

public interface CommonTreeMapper {
	//组织机构树
	String getOrganizationidByorganizationcode(@Param("organizationcode")String organizationcode);
	List<TreeNode> selectOrganization(@Param(value = "organizationid")String organizationid);
	List<TreeNode> selectMeasureFile(@Param(value = "organizationid")String organizationid);
	
	//行政区域树
	List<TreeNode> selectRegion(@Param(value = "organizationid")String organizationid);
	List<TreeNode> selectRegionMeasureFile(@Param(value = "organizationid")String organizationid);
	
	//公用树
	List<TreeNode> selectConcentrator(@Param(value = "organizationid")String organizationid);
	List<TreeNode> selectTerminal(@Param(value = "organizationid")String organizationid);
	List<TreeNode> selectAmmeter(@Param(value = "organizationid")String organizationid);
	
	//通用树节点收起配置
	/**
	 * 获取树节点收起配置
	 * @param code
	 * @return
	 */
	List<TreeSetting> selectSettingNodes(@Param(value = "code")String code);
	
	/**
	 * 删除树节点收起配置
	 * @param code
	 * @return
	 */
	int deleteSettingNodes(@Param(value = "code")String code);
	
	/**
	 * 插入树节点收起配置
	 * @param nodes
	 * @return
	 */
	int insertSettingNodes(@Param(value = "code")String code, @Param(value = "nodes")List<TreeSetting> nodes);

	
}