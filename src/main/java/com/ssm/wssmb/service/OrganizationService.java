package com.ssm.wssmb.service;

import java.util.List;
import java.util.Map;

import com.ssm.wssmb.model.Organization;
import com.ssm.wssmb.model.OrganizationUser;

/**
 * @Description: 组织机构业务接口
 * @Author hxl
 * @Time: 2018年1月6日
 */
public interface OrganizationService {
	
	/**
	 * @Description 获取组织机构树状列表
	 * @param list
	 * @return
	 * @Time 2018年1月6日
	 * @Author hxl
	 */
	public List<Map<String, Object>> getOrganizationTreeGrid(Integer parentid, Integer id);
	
	
	/**
	 * @Description 添加组织机构
	 * @param organizaiton
	 * @return
	 * @Time 2018年1月6日
	 * @Author hxl
	 */
	public String addOrganization(Organization organization);
	
	/**
	 * @Description 编辑组织机构
	 * @param organizaiton
	 * @return
	 * @throws Exception
	 * @Time 2018年1月6日
	 * @Author hxl
	 */
	public String editOrganization(Organization organization)throws Exception;
	
	/**
	 * @Description 通过id删除组织机构
	 * @param id
	 * @return
	 * @throws Exception
	 * @Time 2018年1月6日
	 * @Author hxl
	 */
	public String deleteOrganization(int id)throws Exception;
	
	/**
	 * 获取告警人员
	 * 
	 * @param organizationid 组织机构id
	 * @return
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
	public List<OrganizationUser> getAlarmUser(int organizationid);
	
	/**
	 * 添加告警人员
	 * 
	 * @param record 告警人员信息
	 * @return
	 * @Time 2019年4月3日
	 * @Author hxl
	 */
	public String addAlarmUser(OrganizationUser record) throws Exception;
	
	/**
	 * 删除告警人员
	 * 
	 * @param id 告警人员id
	 * @return
	 * @Time 2018年8月15日
	 * @Author hxl
	 */
	public String deleteAlarmUser(int id) throws Exception;
}
