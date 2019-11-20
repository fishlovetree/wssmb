package com.ssm.wssmb.mapper;

import com.ssm.wssmb.model.RouteVertices;

public interface RouteVerticesMapper {
    int insert(RouteVertices record);

    int insertSelective(RouteVertices record);
}