package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.LoadAnalysis;

public interface LoadAnalysisMapper {
	
	//获取所有类型
	List<String> getAllType();

	List<LoadAnalysis> getLoadAnalysis(@Param("address") String address, @Param("startdate") String startdate,
			@Param("enddate") String enddate,@Param("elecType") String elecType);

	


}
