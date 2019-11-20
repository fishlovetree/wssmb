package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.PowerQualityAnalysis;

public interface PowerQualityAnalysisMapper {
	
	List<PowerQualityAnalysis> selectTerminalAnalysis(@Param("id") Integer id,
			@Param("organizationid") Integer organizationid, @Param("type") Integer type,
			@Param("startdate") String startdate, @Param("enddate") String enddate,
			@Param("startindex") int startindex, @Param("endindex") int endindex);
	
	int selectTerminalAnalysisCount(@Param("id") Integer id,
			@Param("organizationid") Integer organizationid, @Param("type") Integer type,
			@Param("startdate") String startdate, @Param("enddate") String enddate,
			@Param("startindex") int startindex, @Param("endindex") int endindex);

	List<PowerQualityAnalysis> selectAmmeterAnalysis(@Param("id") Integer id,
			@Param("organizationid") Integer organizationid, @Param("type") Integer type,
			@Param("startdate") String startdate, @Param("enddate") String enddate,
			@Param("startindex") int startindex, @Param("endindex") int endindex);
	
	int selectAmmeterAnalysisCount(@Param("id") Integer id,
			@Param("organizationid") Integer organizationid, @Param("type") Integer type,
			@Param("startdate") String startdate, @Param("enddate") String enddate,
			@Param("startindex") int startindex, @Param("endindex") int endindex);
}
