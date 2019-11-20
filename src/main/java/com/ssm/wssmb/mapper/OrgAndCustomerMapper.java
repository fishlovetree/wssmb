package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.OrgAndCustomer;

public interface OrgAndCustomerMapper {
    /**
     * @Description 根据组织机构代码获取子集
     * @return
     * @Time 2018年1月17日
     * @Author hxl
     */
    public List<OrgAndCustomer> selectListByCode(@Param(value="organizationcode")String organizationcode);
    
    /**
     * @Description 根据组织机构代码获取子集(用户id数组)
     * @param organizationcode
     * @return
     * @Time 2018年1月19日
     * @Author wys
     */
    public Integer[] selectCustomerArrayByCode(@Param(value="organizationcode")String organizationcode);
    
    /**
     * @Description 根据组织机构代码获取子集(用户集合)
     * @param organizationcode
     * @return
     * @Time 2018年1月19日
     * @Author wys
     */
    public List<OrgAndCustomer> selectCustomerListByCode(@Param(value="organizationcode")String organizationcode);
    
    
	/**
     * @Description 根据code获取
     * @return
     * @Time 2018年2月7日
     * @Author lmn
     */
    public OrgAndCustomer selectOrgAndCustomersBycode(@Param(value="code")String code);
    
}