package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.MbBlueBreaker;

public interface MbBlueBreakerMapper {

	public List<MbBlueBreaker> selectAll(@Param("organizationId") int organizationId, @Param("startin") int startin,
			@Param("endindex") int endindex);

	//
	public List<MbBlueBreaker> queryBlueBreakerByName(@Param("organizationId") int organizationId,
			@Param("inputValue") String inputValue, @Param("startin") int startin, @Param("endindex") int endindex);

	public List<MbBlueBreaker> queryBlueBreakerByCode(@Param("organizationId") int organizationId,
			@Param("inputValue") String inputValue, @Param("startin") int startin, @Param("endindex") int endindex);

	public int addBlueBreaker(MbBlueBreaker mbBlueBreaker);

	public boolean editBlueBreaker(MbBlueBreaker mbBlueBreaker);

	public boolean addOneBluebreaker(MbBlueBreaker mbBlueBreaker);

	public boolean deleteBlueBreaker(int id);

	//
	public List<Integer> queryTotal(@Param("organizationId") int organizationId);

	public List<Integer> queryTotalByName(@Param("organizationId") int organizationId,
			@Param("inputValue") String inputValue);

	public List<Integer> queryTotalByCode(@Param("organizationId") int organizationId,
			@Param("inputValue") String inputValue);

	public List<MbBlueBreaker> getBlueBreakerByAmmeterId(@Param("mbAmmeterId") int mbAmmeterId);

	public List<MbBlueBreaker> getBlueBreakerByMeasureId(@Param("measureId") int measureId);

	public List<MbBlueBreaker> getBlueBreakerByConcentratorId(@Param("concentratorId") int concentratorId);
	
	//更改蓝牙断路器开关状态
    int changeOpenStatus(@Param(value = "openStatus") int openStatus, @Param(value = "ammeterId") int ammeterId);

}
