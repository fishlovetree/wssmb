package com.ssm.wssmb.service;

import java.util.List;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.ssm.wssmb.model.MbAmmeter;
import com.ssm.wssmb.util.ResponseResult;;

public interface MbAmmeterService {

	public ResponseResult selectAll(int organizationId, int startindex, int endindex);

	public ResponseResult queryAmmeter(int orgId, String selectValue, String inputValue, int startindex, int endindex);

	public ResponseResult addAmmeter(String ammeterName, String ammeterCode, String installAddress,
			int concentratorCode, int organizationCode, String produce, String produceTime, String createPerson,
			String createTime, int boxCode, String ammeterType, String softType, String hardType);

	public ResponseResult editAmmeter(MbAmmeter mbAmmeter);

	public ResponseResult deleteAmmeter(int id);

	public XSSFWorkbook exportAmmeterToExcel(int organizationId) throws Exception;

	public List<MbAmmeter> readExcelFile(CommonsMultipartFile excelfil) throws Exception;

	public boolean dealList(List<MbAmmeter> list) throws Exception;

	public List<MbAmmeter> getAmmeterByMeasurefile(String measureId);

	public boolean nameExisted(String ammeterName);

	public boolean nameExistedAndId(String ammeterName, int id);

	public List<MbAmmeter> queryAmmeterByTree(String treeType, int orgId);

	public MbAmmeter queryAmmeterByAmmeterCode(String ammeterCode);

	public MbAmmeter getAmmeterCodeByid(int id);

}
