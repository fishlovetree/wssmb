package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.MbAmmeter;

public interface MbAmmeterMapper {

	public List<MbAmmeter> selectAll(@Param("organizationId") int organizationId, @Param("startin") int startin,
			@Param("endindex") int endindex);

	public List<MbAmmeter> selectAll2(@Param("startin") int startin, @Param("endindex") int endindex);

	public List<MbAmmeter> queryAmmeterByName(@Param("organizationId") int organizationId,
			@Param("inputValue") String inputValue, @Param("startin") int startin, @Param("endindex") int endindex);

	public List<MbAmmeter> queryAmmeterByCode(@Param("organizationId") int organizationId,
			@Param("inputValue") String inputValue, @Param("startin") int startin, @Param("endindex") int endindex);

	public int addAmmeter(@Param("ammeterName") String ammeterName, @Param("ammeterCode") String ammeterCode,
			@Param("installAddress") String installAddress, @Param("concentratorCode") int concentratorCode,
			@Param("organizationCode") int organizationCode, @Param("produce") String produce,
			@Param("produceTime") String produceTime, @Param("createPerson") String createPerson,
			@Param("createTime") String createTime, @Param("boxCode") int boxCode,
			@Param("ammeterType") String ammeterType, @Param("softType") String softType,
			@Param("hardType") String hardType);

	public boolean editAmmeter(MbAmmeter mbAmmeter);

	public boolean addOneAmmeter(MbAmmeter mbAmmeter);

	public boolean deleteAmmeter(int id);

	public List<Integer> queryTotal(@Param("organizationId") int organizationId);

	public List<Integer> queryTotalByName(@Param("organizationId") int organizationId,
			@Param("inputValue") String inputValue);

	public List<Integer> queryTotalByCode(@Param("organizationId") int organizationId,
			@Param("inputValue") String inputValue);

	public List<MbAmmeter> getAmmeterByMeasurefile(@Param("measureId") String measureId);

	public MbAmmeter getOneAmmeterByCode(@Param("ammeterCode") int ammeterCode);

	public int getCodeByName(@Param("ammeterName") String ammeterName);

	public MbAmmeter nameExisted(@Param("ammeterName") String ammeterName);

	public MbAmmeter nameExistedAndId(@Param("ammeterName") String ammeterName, @Param("id") int id);

	public List<MbAmmeter> getAmmeterByConcentratorId(@Param("concentratorId") int concentratorId);

	public List<MbAmmeter> getAmmeterByMeasureId(@Param("measureId") int measureId);

	public List<MbAmmeter> getAmmeterWarnByMeasureId(@Param("measureId") int measureId);

	public List<MbAmmeter> getAmmeterFaultByMeasureId(@Param("measureId") int measureId);

	public List<MbAmmeter> getAmmeterMessageByMeasureId(@Param("measureId") int measureId);

	/**
	 * @Description 通过设备ids设备列表(档案管理-下发档案)
	 * @param 设备ID
	 * @return 设备列表
	 * @Time 2018年12月26日
	 * @Author dj
	 */
	List<MbAmmeter> getAmmeterListByIDs(@Param("ids") String[] ids);

	// 根据地址查找电表
	MbAmmeter selectByAddress(@Param("ammeterCode") String ammeterCode);

	// 根据id查询电表
	List<MbAmmeter> selectByIdAndType(@Param("equipmentid") Integer equipmentid);

	MbAmmeter getAmmeterByAmmeterCode(@Param("ammeterCode") String ammeterCode);

	public MbAmmeter getAmmeterCodeByid(@Param("id") int id);
	
}
