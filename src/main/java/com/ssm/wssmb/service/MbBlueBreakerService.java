package com.ssm.wssmb.service;

import java.util.List;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.ssm.wssmb.model.MbBlueBreaker;
import com.ssm.wssmb.util.ResponseResult;;

public interface MbBlueBreakerService {

	// 查询所有aie
	public ResponseResult selectAll(int orgId, int startindex, int endindex);

	public ResponseResult queryBlueBreaker(int orgId, String selectValue, String inputValue, int startindex,
			int endindex);

	// 添加一个路断器
	public ResponseResult addBlueBreaker(MbBlueBreaker mbBlueBreaker);

	public ResponseResult editBlueBreaker(MbBlueBreaker mbBlueBreaker);

	public ResponseResult deleteBlueBreaker(int id);

	public XSSFWorkbook exportBlueBreakerToExcel(int orgId) throws Exception;

	public List<MbBlueBreaker> readExcelFile(CommonsMultipartFile excelfil) throws Exception;

	public boolean dealList(List<MbBlueBreaker> list) throws Exception;

	public List<MbBlueBreaker> queryBlueBreakerByTree(String treeType, int orgId);
	
	//更改蓝牙断路器开关状态
	public String changeOpenStatus(Integer openStatus, Integer ammeterId) throws Exception;
}
