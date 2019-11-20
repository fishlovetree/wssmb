package com.ssm.wssmb.service;

import java.util.List;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.ssm.wssmb.model.Terminal;

public interface TerminalService {

	// 查询终端集合
	List<Terminal> getList(Integer organizationId);

	// 点击树查询
	List<Terminal> cliekTreeList(Integer type, Integer id, String name, String address);

	String addOrUpdate(Terminal terminal) throws Exception;

	String delete(Terminal record) throws Exception;

	// 搜索
	String searchInf(Integer organizationId, String terminalName, String address, Integer startindex, int endindex)
			throws Exception;

	XSSFWorkbook exportExcelInfo(String nameDate, List<Terminal> list) throws Exception;

	List<Terminal> readExcelFile(CommonsMultipartFile excelfil) throws Exception;

	boolean dealList(List<Terminal> list) throws Exception;

	Terminal queryTerminalByAddress(String address);

}
