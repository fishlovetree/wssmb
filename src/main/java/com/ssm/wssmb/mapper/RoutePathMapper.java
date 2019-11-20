package com.ssm.wssmb.mapper;

import com.ssm.wssmb.model.RoutePath;

public interface RoutePathMapper {
    int insert(RoutePath record);

    int insertSelective(RoutePath record);
}