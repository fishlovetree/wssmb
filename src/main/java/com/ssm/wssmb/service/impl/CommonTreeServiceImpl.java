package com.ssm.wssmb.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ssm.wssmb.mapper.CommonTreeMapper;
import com.ssm.wssmb.mapper.OrgAndCustomerMapper;
import com.ssm.wssmb.mapper.RegionMapper;
import com.ssm.wssmb.model.TreeNode;
import com.ssm.wssmb.model.TreeSetting;
import com.ssm.wssmb.service.CommonTreeService;
import com.ssm.wssmb.util.EventLogAspect;
import com.ssm.wssmb.util.TreeNodeLevel;
import com.ssm.wssmb.util.TreeType;

@Service
public class CommonTreeServiceImpl implements CommonTreeService {

	@Resource
	OrgAndCustomerMapper orgAndCustomerMapper;

	@Resource
	private RegionMapper regionMapper;

	@Resource
	private CommonTreeMapper commonTreeMapper;

	@Resource
	private EventLogAspect log;

	// ********************************************通用树*************************************************
	/**
	 * @Description 组织结构树
	 * @param organizationcode 登录账号所在组织机构代码
	 * @param treeLevel        最低层级
	 * @return
	 * @throws Exception
	 * @Time 2018年12月13日
	 * @Author rcd
	 */
	@Override
	public List<TreeNode> getOrganizationTree(String organizationcode, TreeNodeLevel treeLevel) throws Exception {
		List<TreeNode> nodeList = new ArrayList<TreeNode>();
		// 加载组织机构
		String organizationid = commonTreeMapper.getOrganizationidByorganizationcode(organizationcode);
		List<TreeNode> orgList = commonTreeMapper.selectOrganization(organizationid);
		nodeList.addAll(orgList);
		if (treeLevel.getIndex() >= TreeNodeLevel.MeasureFile.getIndex()) {
			// 加载表箱
			List<TreeNode> measureList = commonTreeMapper.selectMeasureFile(organizationid);
			nodeList.addAll(measureList);
		}
		if (treeLevel.getIndex() >= TreeNodeLevel.Concentrator.getIndex()) {
			// 加载集中器
			List<TreeNode> concentratorList = commonTreeMapper.selectConcentrator(organizationid);
			nodeList.addAll(concentratorList);
		}
		if (treeLevel.getIndex() >= TreeNodeLevel.Terminal.getIndex()) {
			// 加载终端
			List<TreeNode> terminalList = commonTreeMapper.selectTerminal(organizationid);
			nodeList.addAll(terminalList);
		}	
		if (treeLevel.getIndex() >= TreeNodeLevel.Ammeter.getIndex()) {
			// 加载电表
			List<TreeNode> ammeterList = commonTreeMapper.selectAmmeter(organizationid);
			nodeList.addAll(ammeterList);
		}
		// 生成树
		List<TreeNode> result = new ArrayList<TreeNode>();
		Map<String, TreeNode> map = new LinkedHashMap<String, TreeNode>();
		// 获取通用树需要收起的节点
		List<TreeSetting> settingNodes = commonTreeMapper
				.selectSettingNodes(organizationcode == null ? "0" : organizationcode);
		// 将节点集合转换成map
		for (int i = 0; i < nodeList.size(); i++) {
			TreeNode item = nodeList.get(i);
			item.setChildren(new ArrayList<TreeNode>());
			// 设置节点收起状态
			boolean isClosed = false;
			for (int j = 0; j < settingNodes.size(); j++) {
				if (settingNodes.get(j).getNodeid().equals(item.getId())
						&& settingNodes.get(j).getTreetype() == TreeType.Organization.getIndex()) {
					isClosed = true;
					break;
				}
			}
			if (isClosed) {
				// 是否是叶子节点
				boolean isLeaf = true;
				for (int k = 0; k < nodeList.size(); k++) {
					if (nodeList.get(k).getParentid().equals(item.getId())) {
						isLeaf = false;
						break;
					}
				}
				if (isLeaf) {
					item.setState("open");
				} else {
					item.setState("closed");
				}
				// 设置节点选中
				item.setChecked(true);
			} else {
				item.setState("open");
				item.setChecked(false);
			}
			map.put(item.getId(), item);
		}
		// 节点级联关系
		for (Map.Entry<String, TreeNode> entry : map.entrySet()) {
			if (map.containsKey(entry.getValue().getParentid())) {
				TreeNode parent = map.get(entry.getValue().getParentid());
				parent.getChildren().add(entry.getValue());
			} else {
				result.add(entry.getValue());
			}
		}
		return result;
	}

	/**
	 * @Description 区域树
	 * @param organizationcode 
	 * @param treeLevel       
	 * @return
	 * @throws Exception
	 * @Time
	 * @Author rcd
	 */
	@Override
	public List<TreeNode> getRegionTree(String organizationcode, TreeNodeLevel treeLevel) throws Exception {
		List<TreeNode> nodeList = new ArrayList<TreeNode>();
		// 加载区域
		// 获取IN范围
		String organizationid = commonTreeMapper.getOrganizationidByorganizationcode(organizationcode);
		List<TreeNode> regionList = commonTreeMapper.selectRegion(organizationid);
		nodeList.addAll(regionList);
		if (treeLevel.getIndex() >= TreeNodeLevel.MeasureFile.getIndex()) {
			// 加载表箱
			List<TreeNode> measureList = commonTreeMapper.selectRegionMeasureFile(organizationid);
			nodeList.addAll(measureList);

		}
		if (treeLevel.getIndex() >= TreeNodeLevel.Concentrator.getIndex()) {
			// 加载集中器
			List<TreeNode> concentratorList = commonTreeMapper.selectConcentrator(organizationid);
			nodeList.addAll(concentratorList);
		}
		if (treeLevel.getIndex() >= TreeNodeLevel.Terminal.getIndex()) {
			// 加载终端
			List<TreeNode> terminalList = commonTreeMapper.selectTerminal(organizationid);
			nodeList.addAll(terminalList);
		}
		if (treeLevel.getIndex() >= TreeNodeLevel.Ammeter.getIndex()) {
			// 加载电表
			List<TreeNode> ammeterlList = commonTreeMapper.selectAmmeter(organizationid);
			nodeList.addAll(ammeterlList);
		}
		// 生成树
		List<TreeNode> result = new ArrayList<TreeNode>();
		Map<String, TreeNode> map = new LinkedHashMap<String, TreeNode>();
		// 获取通用树需要收起的节点
		List<TreeSetting> settingNodes = commonTreeMapper
				.selectSettingNodes(organizationcode == null ? "0" : organizationcode);
		// 将节点集合转换成map
		for (int i = 0; i < nodeList.size(); i++) {
			TreeNode item = nodeList.get(i);
			item.setChildren(new ArrayList<TreeNode>());
			// 设置节点收起状态
			boolean isClosed = false;
			for (int j = 0; j < settingNodes.size(); j++) {
				if (settingNodes.get(j).getNodeid().equals(item.getId())
						&& settingNodes.get(j).getTreetype() == TreeType.Region.getIndex()) {
					isClosed = true;
					break;
				}
			}
			if (isClosed) {
				// 是否是叶子节点
				boolean isLeaf = true;
				for (int k = 0; k < nodeList.size(); k++) {
					if (nodeList.get(k).getParentid().equals(item.getId())) {
						isLeaf = false;
						break;
					}
				}
				if (isLeaf) {
					item.setState("open");
				} else {
					item.setState("closed");
				}
				// 设置节点选中
				item.setChecked(true);
			} else {
				item.setState("open");
				item.setChecked(false);
			}
			map.put(item.getId(), item);
		}
		// 节点级联关系
		for (Map.Entry<String, TreeNode> entry : map.entrySet()) {
			if (map.containsKey(entry.getValue().getParentid())) {
				TreeNode parent = map.get(entry.getValue().getParentid());
				parent.getChildren().add(entry.getValue());
			} else {
				result.add(entry.getValue());
			}
		}
		return result;
	}

	/**
	 * @Description
	 * @param organizationcode 登录账号所在组织机构代码
	 * @return
	 * @throws Exception
	 * @Time 2019年6月11日
	 * @Author rcd
	 */
	@Override
	public @ResponseBody Map<String, List<TreeNode>> treeNode(String organizationcode) throws Exception {
		Map<String, List<TreeNode>> map = new HashMap<String, List<TreeNode>>();
		// 根据组织结构code获取组织id
		String organizationid = commonTreeMapper.getOrganizationidByorganizationcode(organizationcode);
		// 获取组织结构集合放入map中
		List<TreeNode> orglist = commonTreeMapper.selectOrganization(organizationid);
		map.put("orglist", orglist);
		// 组织机构权限下的表箱集合
		List<TreeNode> measurelist = commonTreeMapper.selectMeasureFile(organizationid);
		map.put("measurelist", measurelist);
		// 组织机构权限下的集中器集合
		List<TreeNode> concentratorlist = commonTreeMapper.selectConcentrator(organizationid);
		map.put("concentratorlist", concentratorlist);
		// 组织机构权限下的终端集合
		List<TreeNode> terminallist = commonTreeMapper.selectTerminal(organizationid);
		map.put("terminallist", terminallist);
		//组织机构权限下的电表集合
		List<TreeNode> ammeterList = commonTreeMapper.selectAmmeter(organizationid);
		map.put("ammeterList", ammeterList);
		// 组织机构权限下的区域
		List<TreeNode> regionList = commonTreeMapper.selectRegion(organizationid);
		map.put("regionlist", regionList);
		return map;
	}

	// ********************************************通用树节点收起配置*************************************************
	/**
	 * @Description 保存通用树节点收起配置
	 * @param
	 * @return
	 * @throws Exception
	 * @Time 2018年12月27日
	 * @Author hxl
	 */
	@Override
	public String saveSettingNodes(String code, List<TreeSetting> settingNodes) throws Exception {
		int result = commonTreeMapper.deleteSettingNodes(code);
		if (result >= 0 && settingNodes.size() > 0) {
			result = commonTreeMapper.insertSettingNodes(code, settingNodes);
		}

		// 记录操作日志
		String content = "用户编号：" + code;
		log.addLog("", "保存通用树节点收起配置", content, 2);

		if (result >= 0)
			return "success";
		else
			return "error";
	}

}
