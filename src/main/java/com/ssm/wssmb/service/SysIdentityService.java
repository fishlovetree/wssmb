package com.ssm.wssmb.service;

import com.ssm.wssmb.model.SysIdentity;

public interface SysIdentityService {
    int deleteByPrimaryKey(String identityname);

    int insert(SysIdentity record);

    int insertSelective(SysIdentity record);

    SysIdentity selectByPrimaryKey(String identityname);

    int updateByPrimaryKeySelective(SysIdentity record);

    int updateByPrimaryKey(SysIdentity record);

    long selectRow(String identityname);
}
