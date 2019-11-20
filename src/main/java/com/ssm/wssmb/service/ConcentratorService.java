package com.ssm.wssmb.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import com.ssm.wssmb.model.Concentrator;
import com.ssm.wssmb.model.MeasureFile;

public interface ConcentratorService {

	//查询集中器
	List<Concentrator> getList(Integer organizationId);

	//点击树查询
	List<Concentrator> cliekTreeList(Integer type, Integer id,String name,String address);

	String addOrUpdate(Concentrator concentrator);

	String delete(String concentratorId);

	List<Concentrator> readExcelFile(CommonsMultipartFile excelfil) throws Exception;

	boolean dealList(List<Concentrator> list) throws Exception;

	XSSFWorkbook exportExcelInfo(String nameDate, List<Concentrator> list) throws Exception;

	//搜索
	String searchInf(Integer organizationId, String ConcentratorName, String Address, Integer startindex, int endindex)
			throws Exception;

	// 查询表箱下的集中器
	List<Concentrator> getConcentratorByMeasureId(Integer measureId);

	List<Concentrator> getConcentratorByMeasurefile(String measureId);
}
