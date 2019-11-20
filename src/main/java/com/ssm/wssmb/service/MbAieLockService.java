package com.ssm.wssmb.service;

import java.util.List;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.ssm.wssmb.model.MbAieLock;
import com.ssm.wssmb.util.ResponseResult;;

public interface MbAieLockService {

	// 查询所有aie
	public ResponseResult selectAll(int organizationId, int startindex, int endindex);

	public ResponseResult queryAieLock(int orgId, String selectValue, String inputValue, int startindex, int endindex);

	// 添加一个智能表箱
	public ResponseResult addAieLock(MbAieLock mbAieLock);

	public ResponseResult editAieLock(MbAieLock mbAieLock);

	public ResponseResult deleteAieLock(int id);

	public XSSFWorkbook exportAieLockToExcel(int orgId) throws Exception;

	public List<MbAieLock> readExcelFile(CommonsMultipartFile excelfil) throws Exception;

	public boolean dealList(List<MbAieLock> list) throws Exception;

	public List<MbAieLock> queryAieLockByTree(String treeType, int orgId);

	public MbAieLock getLockByMac(String mac);

	// public String oneNetCreateDevice(String apiKey, MbAieLock mbAieLock)
	// throws Exception;
	
	//更改表e锁开关状态
    String changeOpenStatus(Integer openStatus, Integer id) throws Exception;
}
