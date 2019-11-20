package com.ssm.wssmb.service;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.ssm.wssmb.model.MeasureFile;

public interface MeasureFileService {

	// 查询表箱集合
	List<MeasureFile> getList(Integer organizationid);

	// 点击树查询
	List<MeasureFile> cliekTreeList(Integer type, Integer id, String name, String number, String address);

	String addOrUpdate(String measureId, String measureNumber, String measureName, String longitude, String latitude,
			String longlatitude, Integer organizationId, String manufacturer, String produceDate, String creater,
			Date createDate, String region) throws Exception;

	String delete(MeasureFile record) throws Exception;

	// 搜索
	String searchInf(Integer organizationId, String MeasureName, String MeasureNumber, String Address,
			Integer startindex, int endindex) throws Exception;

	List<MeasureFile> readExcelFile(CommonsMultipartFile excelfil) throws Exception;

	boolean dealList(List<MeasureFile> list) throws Exception;

	XSSFWorkbook exportExcelInfo(String nameDate, List<MeasureFile> list) throws Exception;

	// 查询组织机构下的表箱
	List<MeasureFile> getMeasurefileByOrganizationId(Integer OrganizationId);

	// 更改表箱门节点状态
	String changeOpenStatus(Integer openStatus, Integer measureId) throws Exception;
}
