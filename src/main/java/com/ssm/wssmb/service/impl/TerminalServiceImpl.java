package com.ssm.wssmb.service.impl;

import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.ArrayUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.ssm.wssmb.mapper.ConcentratorMapper;
import com.ssm.wssmb.mapper.MeasureFileMapper;
import com.ssm.wssmb.mapper.TerminalMapper;
import com.ssm.wssmb.model.MeasureFile;
import com.ssm.wssmb.model.Terminal;
import com.ssm.wssmb.service.TerminalService;
import com.ssm.wssmb.service.UntilService;
import com.ssm.wssmb.util.CustomException;
import com.ssm.wssmb.util.EventLogAspect;
import com.ssm.wssmb.util.ExcelBean;
import com.ssm.wssmb.util.ExcelUtil;

@Service
public class TerminalServiceImpl implements TerminalService {

	/**
	 * Excel 2003
	 */
	private final static String XLS = "xls";
	/**
	 * Excel 2007
	 */
	private final static String XLSX = "xlsx";
	SimpleDateFormat time = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	// SimpleDateFormat sdfEnd = new SimpleDateFormat("yyyy-MM-dd 23:59:59");
	SimpleDateFormat dateFmt = new SimpleDateFormat("yyyy-MM-dd");

	@Autowired
	TerminalMapper terminalMapper;

	@Resource
	private EventLogAspect log;

	@Autowired
	UntilService untilService;

	@Autowired
	MeasureFileMapper measureFileMapper;

	@Autowired
	ConcentratorMapper concentratorMapper;

	/**
	 * 查询终端
	 */
	@Override
	public List<Terminal> getList(Integer organizationId) {
		List<Terminal> list = terminalMapper.selectList(organizationId);
		for (Terminal terminal : list) {
			terminal.setOrganizationName(terminal.getOrganization().getOrganizationname());
			terminal.setConcentratorName(terminal.getConcentrator().getConcentratorName());
			terminal.setMeasureName(terminal.getMeasureFile().getMeasureName());
		}
		return list;
	}

	/**
	 * 点击树查询
	 */
	@Override
	public List<Terminal> cliekTreeList(Integer type, Integer id, String name, String address) {
		List<Terminal> list = new ArrayList<Terminal>();
		if (type == 1) {
			list = terminalMapper.organizationClickTreeList(id, name, address);
			for (Terminal terminal : list) {
				terminal.setOrganizationName(terminal.getOrganization().getOrganizationname());
				terminal.setConcentratorName(terminal.getConcentrator().getConcentratorName());
				terminal.setMeasureName(terminal.getMeasureFile().getMeasureName());
			}
		} else {
			if (type == 3) {
				list = terminalMapper.getTerminalAndNameByMeasureId(id, name, address);
			} else if (type == 4) {
				list = terminalMapper.getTerminalAndNameByConcentratorId(id, name, address);
			} else if (type == 5) {
				list = terminalMapper.getTerminalAndNameByTerminalIds(id, name, address);
			} else {
				list = terminalMapper.regionClickTreeList(id, name, address);
			}
			for (Terminal terminal : list) {
				terminal.setOrganizationName(terminal.getOrganization().getOrganizationname());
				terminal.setConcentratorName(terminal.getConcentrator().getConcentratorName());
				terminal.setMeasureName(terminal.getMeasureFile().getMeasureName());
			}
		}
		return list;
	}

	@Override
	public String addOrUpdate(Terminal terminal) throws Exception {
		int result = 0;
		String success = "success";
		String error = "error";
		// 判断地址是否重复
		boolean falg = true;
		String[] address = terminalMapper.getAllAddress();
		// 保持设备的组织机构和表箱的一样，防止出现表箱为浙江总经销，设备为智慧消防安全系统这种情况
		Integer orgnazationId = measureFileMapper.getOrganizationIdByMeasureId(terminal.getMeasureId());
		terminal.setOrganizationId(orgnazationId);
		if (null == terminal.getTerminalId()) {
			Integer num = terminalMapper.getTerminalCountByMeasureId(terminal.getMeasureId());
			if (num == 0) {// 添加
				for (int j = 0; j < address.length; j++) {
					if (address[j].equals(terminal.getAddress())) {
						falg = false;
						error = "终端地址重复";
					}
				}
				if (falg) {
					result = terminalMapper.insert(terminal);
				}
			} else {
				error = "所选表箱已有终端";
			}

		} else {// 修改
			String tsa = terminalMapper.selectByIdAndType(terminal.getTerminalId()).get(0).getAddress();
			if (tsa.equals(terminal.getAddress())) {
				falg = true;
			} else {
				for (int j = 0; j < address.length; j++) {
					if (address[j].equals(terminal.getAddress())) {
						falg = false;
						error = "终端地址重复";
					}
				}
			}
			if (falg) {
				result = terminalMapper.update(terminal);
			}
		}
		String content = "消防终端id：" + terminal.getTerminalId() + "消防终端名字：" + terminal.getTerminalName();
		log.addLog("", "添加或修改消防终端档案", content, 0);
		return result > 0 ? success : error;
	}

	@Override
	public String delete(Terminal record) throws Exception {
		int result = terminalMapper.delete(record);
		String content = "消防终端id：" + record.getTerminalId() + "消防终端名字：" + record.getTerminalName();
		log.addLog("", "删除消防终端档案", content, 1);
		return result > 0 ? "success" : "error";

	}

	/**
	 * 搜索
	 */
	@Override
	public String searchInf(Integer organizationId, String terminalName, String address, Integer startindex,
			int endindex) throws Exception {
		List<Terminal> list = new ArrayList<Terminal>();
		startindex = startindex - 1;
		list = terminalMapper.searchInf(organizationId, terminalName, address, startindex, endindex);
		for (Terminal terminal : list) {
			terminal.setOrganizationName(terminal.getOrganization().getOrganizationname());
			terminal.setConcentratorName(terminal.getConcentrator().getConcentratorName());
			terminal.setMeasureName(terminal.getMeasureFile().getMeasureName());
		}
		int count = terminalMapper.getTerminalCount(terminalName, address);
		String json = untilService.getDataPager(list, count);
		return json;
	}

	@Override
	public XSSFWorkbook exportExcelInfo(String nameDate, List<Terminal> list) throws Exception {
		List<ExcelBean> excel = new ArrayList<>();
		Map<Integer, List<ExcelBean>> map = new LinkedHashMap<>();
		XSSFWorkbook xssfWorkbook = null;
		// 设置标题栏
		excel.add(new ExcelBean("终端id", "terminalId", 0));
		excel.add(new ExcelBean("终端名称", "terminalName", 0));
		excel.add(new ExcelBean("终端地址", "address", 0));
		excel.add(new ExcelBean("安装位置", "installationLocation", 0));
		excel.add(new ExcelBean("所属集中器", "concentratorName", 0));
		excel.add(new ExcelBean("组织机构", "organizationName", 0));
		excel.add(new ExcelBean("所属表箱", "measureName", 0));
		excel.add(new ExcelBean("生产厂家", "manufacturer", 0));
		excel.add(new ExcelBean("生产日期", "produceDate", 0));
		excel.add(new ExcelBean("创建人", "creater", 0));
		excel.add(new ExcelBean("创建日期", "createDate", 0));
		excel.add(new ExcelBean("终端型号", "terminalType", 0));
		excel.add(new ExcelBean("软件版本号", "softType", 0));
		excel.add(new ExcelBean("硬件版本号", "hardType", 0));

		map.put(0, excel);
		String sheetName = nameDate + "表箱档案信息";
		// 调用ExcelUtil的方法
		xssfWorkbook = ExcelUtil.createExcelFile(Terminal.class, list, map, sheetName);
		return xssfWorkbook;
	}

	@Override
	public List<Terminal> readExcelFile(CommonsMultipartFile excelfil) throws Exception {
		int sheetNum = 0;// 第几个工作表
		List<Terminal> list = toListFromExcel(excelfil, sheetNum);
		return list;
	}

	/**
	 * 由Excel文件的Sheet导出至List
	 * 
	 * @param excelfil
	 * @param sheetNum
	 * @return
	 * @throws Exception
	 */
	public List<Terminal> toListFromExcel(CommonsMultipartFile excelfil, int sheetNum) throws Exception {
		InputStream is = excelfil.getInputStream();
		String name = excelfil.getOriginalFilename();
		Workbook workbook = null;
		String fileType = name.substring(name.lastIndexOf(".") + 1);// 文件类型
		try {
			if (fileType.toLowerCase().equals(XLS)) {
				workbook = new HSSFWorkbook(is);
			} else if (fileType.toLowerCase().equals(XLSX)) {
				workbook = new XSSFWorkbook(is); // is:java.io.ByteArrayInputStream@123ff2b
			} else {
				throw new CustomException("解析的文件格式有误！");
			}
		} catch (Exception e) {
			throw new CustomException("文件后缀与文件格式不匹配！");
		}
		return toListFromExcel(workbook, sheetNum);
	}

	/**
	 * 由指定的Sheet导出至List
	 * 
	 * @param workbook
	 * @param sheetNum
	 * @return
	 * @throws Exception
	 * @throws IOException
	 */
	private List<Terminal> toListFromExcel(Workbook workbook, int sheetNum) throws Exception {

		Sheet sheet = workbook.getSheetAt(sheetNum);
		List<Terminal> list = new ArrayList<Terminal>();

		int minRowIx = sheet.getFirstRowNum();
		int maxRowIx = sheet.getLastRowNum();

		// 导入excel的标题格式
		String[] cfiled = { "终端id", "终端名称", "终端地址", "安装位置", "所属集中器", "组织机构", "所属表箱", "生产厂家", "生产日期", "创建人", "创建日期",
				"终端型号", "软件版本号", "硬件版本号" };
		String[] colFiled = new String[0];

		int len = 0;
		int count = 0;

		for (int rowIx = minRowIx; rowIx <= maxRowIx; rowIx++) {
			Row row = sheet.getRow(rowIx);
			Terminal terminal = new Terminal();
			short minColIx = row.getFirstCellNum(); // 0
			short maxColIx = row.getLastCellNum(); // 13
			boolean isEmpty = true;// 判断是否可空

			for (short colIx = minColIx; colIx <= maxColIx && isEmpty; colIx++) {
				Cell cell = row.getCell(new Integer(colIx));
				if (cell == null) {
					continue;
				}

				// 检查是否合法
				if (rowIx == 0) {
					String titleName = cell.getStringCellValue();
					if (!ArrayUtils.contains(cfiled, titleName)) {
						System.out.println("The table format does not match the imported data format(表格格式不符合导入的数据格式)!");
						return null;
					} else {
						if (len == 0) {
							len = maxColIx - minColIx;
							colFiled = new String[len];
							count = 0;
						}
						colFiled[count] = titleName;
						count++;
					}
				} else {
					String cellText = colFiled[colIx].trim();
					String stringValue = ExcelUtil.getCellValue(cell);

					// 不可空
					if ((null == stringValue || "" == stringValue) && (cellText.equals("终端名称"))) {
						isEmpty = false;
						throw new CustomException(cellText + "不可空！");
						// continue;
					}

					switch (cellText) {
					case "终端id":
						if (null != stringValue && !stringValue.equals("")) {
							terminal.setTerminalId(Integer.parseInt(stringValue));
						} else {
							terminal.setTerminalId(0);
						}
						break;
					case "终端名称":
						if (stringValue.length() > 20) {
							throw new CustomException("表箱名称必须小于20位");
						}
						terminal.setTerminalName(stringValue);
						break;
					case "终端地址":
						if (stringValue.length() > 50) {
							throw new CustomException("表箱名字必须小于50位");
						}
						terminal.setAddress(stringValue);
						break;
					case "安装位置":
						if (stringValue.length() > 50) {
							throw new CustomException("表箱编号必须小于50位");
						}
						terminal.setInstallationLocation(stringValue);
						break;
					case "所属集中器":
						if (null != stringValue && !stringValue.equals("")) {
							terminal.setConcentratorName(stringValue);
						}
						break;
					case "组织机构":
						if (null != stringValue && !stringValue.equals("")) {
							terminal.setOrganizationName(stringValue);
						}
						break;
					case "所属表箱":
						if (null != stringValue && !stringValue.equals("")) {
							terminal.setMeasureName(stringValue);
						}
						break;
					case "生产厂家":
						if (null != stringValue && !stringValue.equals("")) {
							terminal.setManufacturer(stringValue);
						}
						break;
					case "生产日期":
						if (null != stringValue && !stringValue.equals("")) {
							terminal.setProduceDate(dateFmt.parse(stringValue));
						}
						break;
					case "创建人":
						if (null != stringValue && !stringValue.equals("")) {
							terminal.setCreater(stringValue);
						}
						break;
					case "创建日期":
						if (null != stringValue && !stringValue.equals("")) {
							terminal.setCreateDate(dateFmt.parse(stringValue));
						}
						break;
					case "终端型号":
						if (null != stringValue && !stringValue.equals("")) {
							terminal.setTerminalType(Integer.parseInt(stringValue));
						}
						break;
					case "软件版本号":
						if (null != stringValue && !stringValue.equals("")) {
							terminal.setSoftType(stringValue);
						}
						break;
					case "硬件版本号":
						if (null != stringValue && !stringValue.equals("")) {
							terminal.setHardType(stringValue);
						}
						break;
					}
				}
			}
			if (rowIx != 0 && isEmpty) {
				list.add(terminal);
			}
		}
		return list;
	}

	@Override
	public boolean dealList(List<Terminal> list) throws Exception {
		int temp = 1;
		if (null != list && list.size() > 0) {
			String content = "";
			for (int i = 0; i < list.size(); i++) {
				if (list.get(i).getTerminalId() == null) {
					list.get(i).setTerminalId(0);
				}
				int count = terminalMapper.selectCount(list.get(i).getTerminalId());
				// Exel中的组织结构名字转换成organizationId
				Integer organizationId = measureFileMapper.getOrganizationId(list.get(i).getOrganizationName());
				// Exel中的所属表箱转换成measureId
				Integer measureId = measureFileMapper.getMeasureId(list.get(i).getMeasureName());
				// Exel中的所属集中器转换成concentratorId
				Integer concentratorId = concentratorMapper.getConcentratorId(list.get(i).getConcentratorName());
				if (count > 0) {
					list.get(i).setOrganizationId(organizationId);
					list.get(i).setMeasureId(measureId);
					list.get(i).setConcentratorId(concentratorId);
					temp = temp & terminalMapper.update(list.get(i));
				} else {
					list.get(i).setOrganizationId(organizationId);
					list.get(i).setMeasureId(measureId);
					list.get(i).setConcentratorId(concentratorId);
					temp = temp & terminalMapper.insert(list.get(i));
				}
				content += "消防终端id：" + list.get(i).getTerminalId() + "消防终端名字：" + list.get(i).getTerminalName() + ",";
				if (temp < 0) {
					return false;
				}
			}

			if (content != "")
				content = content.substring(0, content.length() - 1);
			log.addLog("", "导入表箱档案信息", content, 0);
		}
		return true;
	}

	@Override
	public Terminal queryTerminalByAddress(String address) {
		Terminal queryTerminalByAddress = terminalMapper.queryTerminalByAddress(address);
		if (queryTerminalByAddress != null) {
			int measureId = queryTerminalByAddress.getMeasureId();
			MeasureFile measurefileByMeasureId = measureFileMapper.getMeasurefileByMeasureId(measureId);
			queryTerminalByAddress.setMeasureFile(measurefileByMeasureId);
			return queryTerminalByAddress;
		} else {
			return null;
		}
	}
}
