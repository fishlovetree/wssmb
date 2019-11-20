package com.ssm.wssmb.mapper;

import java.math.BigDecimal;

import com.ssm.wssmb.model.UserTest;

public interface UserTestMapper {
    int deleteByPrimaryKey(BigDecimal userid);

    int insert(UserTest record);

    int insertSelective(UserTest record);

    UserTest selectByPrimaryKey(BigDecimal userid);
    
    UserTest selectByUserlogin(String userlogin);

    int updateByPrimaryKeySelective(UserTest record);

    int updateByPrimaryKey(UserTest record);
}