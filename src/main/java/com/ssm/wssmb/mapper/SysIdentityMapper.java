package com.ssm.wssmb.mapper;

import com.ssm.wssmb.model.SysIdentity;

public interface SysIdentityMapper {
    int deleteByPrimaryKey(String identityname);

    int insert(SysIdentity record);

    int insertSelective(SysIdentity record);

    SysIdentity selectByPrimaryKey(String identityname);

    int updateByPrimaryKeySelective(SysIdentity record);

    int updateByPrimaryKey(SysIdentity record);
}