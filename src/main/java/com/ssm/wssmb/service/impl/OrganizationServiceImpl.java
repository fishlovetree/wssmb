package com.ssm.wssmb.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.ssm.wssmb.mapper.OrganizationMapper;
import com.ssm.wssmb.model.Organization;
import com.ssm.wssmb.model.OrganizationUser;
import com.ssm.wssmb.service.OrganizationService;
import com.ssm.wssmb.util.EventLogAspect;

@Service
public class OrganizationServiceImpl implements OrganizationService {
	@Resource
	private OrganizationMapper organizationMapper;
	
	@Resource
	private EventLogAspect log;

	/**
	 * @Description 获取组织机构树状列表
	 * @param list
	 * @return
	 * @Time 2018年1月6日
	 * @Author hxl
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getOrganizationTreeGrid(Integer parentid, Integer id){
		List<Organization> organizations = organizationMapper.selectList(parentid, id);
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		Map<Integer, Map<String, Object>> map = new LinkedHashMap<Integer, Map<String, Object>>();
		for (int i = 0; i < organizations.size(); i++){
			Map<String, Object> cmap = new HashMap<String, Object>();
			cmap = setOrganization(cmap, organizations.get(i));
			cmap.put("state", "open");//默认打开
			cmap.put("children", new ArrayList<Map<String, Object>>());//子级组织机构
			map.put(organizations.get(i).getOrganizationid(), cmap);
		}
		//节点级联关系
		for (Map.Entry<Integer, Map<String, Object>> entry : map.entrySet()) {
			if (map.containsKey(entry.getValue().get("parentid"))) {
				Map<String, Object> parent = map.get(entry.getValue().get("parentid"));
				((List<Map<String, Object>>)parent.get("children")).add(entry.getValue());
			} else {
				result.add(entry.getValue());
			}
		}
			
		return result;
	}
	
	/**
	 * @Description 设置map集合
	 * @param map
	 * @param organization
	 * @return
	 * @Time 2018年1月6日
	 * @Author hxl
	 */
	private Map<String, Object> setOrganization(Map<String, Object> map, Organization organization) {
		map.put("id", organization.getOrganizationid());
		map.put("organizationid", organization.getOrganizationid()); // id
		map.put("organizationcode", organization.getOrganizationcode()); // 组织机构编码
		map.put("organizationname", organization.getOrganizationname()); //组织机构名称
		map.put("text", organization.getOrganizationname()); //组织机构名称
		map.put("parentid", organization.getParentid()); //上级组织机构id
		return map;
	}

	/**
	 * @Description 添加组织机构
	 * @param organizaiton
	 * @return
	 * @Time 2018年1月6日
	 * @Author hxl
	 */
	@Override
	public String addOrganization(Organization organization){
		try{
			int count = organizationMapper.selectCountByCode(organization.getOrganizationcode(), 0);
			if (count > 0) return "repeat"; //编码已存在
			organizationMapper.insertSelective(organization);
			log.addLog("","添加组织机构", "组织机构名称："+organization.getOrganizationname(), 0);
		    return "success";
		}catch(Exception e){
        	log.addErrorLog("","OrganizationServiceImpl: public String addOrganization(Organization organization){}", e);
            return "error";
        }finally{
            //System.out.println("不管是否出现异常都执行此代码");
        }
	}

	/**
	 * @Description 编辑组织机构
	 * @param organizaiton
	 * @return
	 * @throws Exception
	 * @Time 2018年1月6日
	 * @Author hxl
	 */
	@Override
	public String editOrganization(Organization organization) throws Exception{
		int count = organizationMapper.selectCountByCode(organization.getOrganizationcode(), organization.getOrganizationid());
		if (count > 0) return "repeat"; //编码已存在
		int result = organizationMapper.updateByPrimaryKeySelective(organization);
		if (result > 0){
			log.addLog("","修改组织机构", "组织机构名称："+organization.getOrganizationname(), 2);
			return "success";
		}
		else{
			return "error";
		}
	}

	/**
	 * @Description 通过id删除组织机构
	 * @param id
	 * @return
	 * @throws Exception
	 * @Time 2018年1月6日
	 * @Author hxl
	 */
	@Override
	public String deleteOrganization(int id) throws Exception{
		Organization organization = organizationMapper.selectByPrimaryKey(id);
		List<Organization> list = organizationMapper.selectListByParentId(id);
		if(null != list && list.size() > 0){
			return "children"; //先删除子集组织机构
		}else{
			int result = organizationMapper.deleteByPrimaryKey(id);
			if (result > 0){
				//删除代理告警方案
				organizationMapper.deleteProxyAlarmPlan(id);
				log.addLog("","删除组织机构", "组织机构名称："+organization.getOrganizationname(), 1);
				return "success";
			}
			else{
				return "error";
			}
		}
	}
	
	/**
	 * 获取告警人员
	 * 
	 * @param organizationid 组织机构id
	 * @return
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
	@Override
	public List<OrganizationUser> getAlarmUser(int organizationid) {
		return organizationMapper.selectUserList(organizationid);
	}
	
	/**
	 * 添加告警人员
	 * 
	 * @param record 告警人员信息
	 * @return
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
	@Override
	public String addAlarmUser(OrganizationUser record) throws Exception {
		int count = organizationMapper.selectUserCount(record);
		if (count > 0)
			return "repeat"; //电话号码重复
    	int result = organizationMapper.insertAlarmUser(record);
		if (result > 0){
			log.addLog("","添加组织机构告警人员", "姓名："+record.getName() + ", 电话：" + record.getPhone() + ", 组织机构id：" + record.getOrganizationid(), 0);
			return "success";
		}
		else{
			return "error";
		} 
	}
	
	/**
	 * 删除告警人员
	 * 
	 * @param id 告警人员id
	 * @return
	 * @Time 2018年8月15日
	 * @Author hxl
	 */
	@Override
	public String deleteAlarmUser(int id) throws Exception {
		int result = organizationMapper.deleteAlarmUser(id);
		if (result > 0){
			log.addLog("","删除组织机构告警人员", "id："+id, 1);
			return "success";
		}
		else{
			return "error";
		} 
	}
}
