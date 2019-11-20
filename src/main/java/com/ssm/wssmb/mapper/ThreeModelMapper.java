package com.ssm.wssmb.mapper;

import java.util.List;

import com.ssm.wssmb.model.ThreeModel;

public interface ThreeModelMapper {
    int deleteByPrimaryKey(String modelcode);

    int insert(ThreeModel record);

    int insertSelective(ThreeModel record);

    ThreeModel selectByPrimaryKey(String modelcode);

    int updateByPrimaryKeySelective(ThreeModel record);

    int updateByPrimaryKey(ThreeModel record);
    
    List<ThreeModel> selectList();
}