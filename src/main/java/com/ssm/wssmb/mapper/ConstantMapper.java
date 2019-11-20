package com.ssm.wssmb.mapper;

import java.util.List;

import com.ssm.wssmb.model.Constant;

public interface ConstantMapper {
    int deleteByPrimaryKey(Integer coding);

    int insert(Constant record);

    int insertSelective(Constant record);

    Constant selectByPrimaryKey(Integer coding);

    int updateByPrimaryKeySelective(Constant record);

    int updateByPrimaryKey(Constant record);
    
    List<Constant> selectConstantList();
}