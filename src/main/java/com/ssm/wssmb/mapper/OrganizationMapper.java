package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.Organization;
import com.ssm.wssmb.model.OrganizationUser;

public interface OrganizationMapper {
    int deleteByPrimaryKey(Integer organizationid);
    
    //删除代理告警方案
    int deleteProxyAlarmPlan(Integer organizationid);

    int insert(Organization record);

    int insertSelective(Organization record);

    Organization selectByPrimaryKey(Integer organizationid);
    
    Organization selectBycode(@Param(value = "organizationcode")String organizationcode);

    int updateByPrimaryKeySelective(Organization record);

    int updateByPrimaryKey(Organization record);

    List<Organization> selectList(@Param(value = "parentid")Integer parentid, @Param(value = "organizationid")Integer organizationid);
    
    List<Organization> selectListByParentId(Integer id);
    
    /**
     * @Description 根据organizationid获取下级所有组织机构集合（by prior）
     * @param organizationid
     * @return
     * @Time 2018年2月26日
     * @Author lmn
     */
    List<Organization> selectAllList(Integer organizationid);
    
    int selectCountByCode(@Param(value = "organizationcode")String organizationcode, @Param(value = "organizationid")Integer organizationid);
    
    /**
     * @Description 根据organizationid获取组织机构告警人员
     * @param organizationid
     * @return
     * @Time 2019年4月3日
     * @Author hxl
     */
    List<OrganizationUser> selectUserList(int organizationid);
    
    /**
     * @Description 删除组织机构告警人员
     * @param id 告警人员id
     * @return
     * @Time 2019年4月3日
     * @Author hxl
     */
    int deleteAlarmUser(int id);
    
    /**
     * @Description 添加组织机构告警人员
     * @param record
     * @return
     * @Time 2019年4月3日
     * @Author hxl
     */
    int insertAlarmUser(OrganizationUser record);
    
    /**
     * @Description 组织机构告警人员的电话号码查重
     * @param record
     * @return
     * @Time 2019年4月3日
     * @Author hxl
     */
    int selectUserCount(OrganizationUser record);
    
    int getCodeByName(String organizationname);
}