package com.ssm.wssmb.service.impl;

import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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

import com.ssm.wssmb.mapper.MeasureFileMapper;
import com.ssm.wssmb.model.MeasureFile;
import com.ssm.wssmb.service.MeasureFileService;
import com.ssm.wssmb.service.UntilService;
import com.ssm.wssmb.util.CustomException;
import com.ssm.wssmb.util.EventLogAspect;
import com.ssm.wssmb.util.ExcelBean;
import com.ssm.wssmb.util.ExcelUtil;

@Service
public class MeasureFileServiceImpl implements MeasureFileService {

	/**
	 * Excel 2003
	 */
	private final static String XLS = "xls";
	/**
	 * Excel 2007
	 */
	private final static String XLSX = "xlsx";
	SimpleDateFormat time = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//	SimpleDateFormat sdfEnd = new SimpleDateFormat("yyyy-MM-dd 23:59:59");
	SimpleDateFormat dateFmt = new SimpleDateFormat("yyyy-MM-dd");

	@Autowired
	MeasureFileMapper measureFileMapper;

	@Resource
	private EventLogAspect log;

	@Autowired
	UntilService untilService;

	/**
	 * 将表中的OrganizationId转为OrganizationName
	 */
	@Override
	public List<MeasureFile> getList(Integer organizationid) {
		List<MeasureFile> list = measureFileMapper.selectList(organizationid);
		for (MeasureFile measureFile : list) {
			measureFile.setOrganizationname(measureFile.getOrganization().getOrganizationname());
			measureFile.setName(measureFile.getArea().getName());
		}
		return list;
	}

	/**
	 * 点击树查询
	 */
	@Override
	public List<MeasureFile> cliekTreeList(Integer type, Integer id, String name, String number, String address) {
		List<MeasureFile> list = new ArrayList<MeasureFile>();
		if (type == 1) {
			list = measureFileMapper.organizationClickTreeList(id,name,number,address);
			for (MeasureFile measureFile : list) {
				measureFile.setOrganizationname(measureFile.getOrganization().getOrganizationname());
				measureFile.setName(measureFile.getArea().getName());
			}
		} else {
			if (type == 3) {
				list = measureFileMapper.getByIdAndType(id,name,number,address);
			} else {
				list = measureFileMapper.regionClickTreeLists(id,name,number,address);
			}
			for (MeasureFile measureFile : list) {
				measureFile.setOrganizationname(measureFile.getOrganization().getOrganizationname());
				measureFile.setName(measureFile.getArea().getName());
			}

		}
		return list;
	}

	@Override
	public String addOrUpdate(String measureId, String measureNumber, String measureName, String longitude,
			String latitude, String longlatitude, Integer organizationId, String manufacturer, String produceDate,
			String creater, Date createDate, String region) throws Exception {
		String success = "success";
		String error = "error";
		Date produceDates = time.parse(produceDate);
		// Date createDates = time.parse(createDate);
		MeasureFile record = new MeasureFile(measureName, measureNumber, longitude, latitude, longlatitude,
				organizationId, manufacturer, produceDates, creater, createDate, Integer.parseInt(region));
		int result = 0;
		// 判断地址是否重复
		boolean falg = true;
		String[] address = measureFileMapper.getAllMeasureNumber();
		if (measureId.equals("")) {
			for (int i = 0; i < address.length; i++) {
				if (address[i].equals(measureNumber)) {
					falg = false;
					error = "表箱地址重复";
				}
			}
			if (falg) {
				result = measureFileMapper.insert(record);
			}
		} else {
			String tsa = measureFileMapper.getMeasurefileByMeasureId(Integer.parseInt(measureId)).getMeasureNumber();
			if (measureNumber.equals(tsa)) {
				falg = true;
			} else {
				for (int i = 0; i < address.length; i++) {
					if (address[i].equals(measureNumber)) {
						falg = false;
						error = "表箱地址重复";
					}
				}
			}
			if (falg) {
				record.setMeasureId(Integer.parseInt(measureId));
				result = measureFileMapper.update(record);
			}
		}
		String content = "编写id：" + record.getMeasureId() + "表箱编号：" + record.getMeasureNumber();
		log.addLog("", "添加或修改表箱档案", content, 0);
		return result > 0 ? success : error;
	}

	@Override
	public String delete(MeasureFile record) throws Exception {
		int result = measureFileMapper.delete(record);
		String content = "表箱id：" + record.getMeasureId() + "表箱编号：" + record.getMeasureNumber();
		log.addLog("", "删除卡号和序列号", content, 1);
		return result > 0 ? "success" : "error";
	}

	@Override
	public List<MeasureFile> readExcelFile(CommonsMultipartFile excelfil) throws Exception {
		int sheetNum = 0;// 第几个工作表
		List<MeasureFile> list = toListFromExcel(excelfil, sheetNum);
		return list;
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
	private List<MeasureFile> toListFromExcel(Workbook workbook, int sheetNum) throws Exception {

		Sheet sheet = workbook.getSheetAt(sheetNum);
		List<MeasureFile> list = new ArrayList<MeasureFile>();

		int minRowIx = sheet.getFirstRowNum();
		int maxRowIx = sheet.getLastRowNum();

		// 导入excel的标题格式
		String[] cfiled = { "表箱id", "表箱名字", "表箱编号", "安装地址", "经度", "纬度", "组织机构", "行政区域", "行政id", "生产厂家", "生产日期", "创建人",
				"创建日期" };
		String[] colFiled = new String[0];

		int len = 0;
		int count = 0;

		for (int rowIx = minRowIx; rowIx <= maxRowIx; rowIx++) {
			Row row = sheet.getRow(rowIx);
			MeasureFile measureFile = new MeasureFile();
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
					if ((null == stringValue || "" == stringValue)
							&& (cellText.equals("表箱id") || cellText.equals("表箱编号"))) {
						isEmpty = false;
						throw new CustomException(cellText + "不可空！");
						// continue;
					}

					switch (cellText) {
					case "表箱id":
						if (stringValue.length() > 20) {
							throw new CustomException("表箱id必须小于20位");
						}

						measureFile.setMeasureId(Integer.parseInt(stringValue));
						break;
					case "表箱名字":
						if (stringValue.length() > 50) {
							throw new CustomException("表箱名字必须小于50位");
						}
						measureFile.setMeasureName(stringValue);
						break;
					case "表箱编号":
						if (stringValue.length() > 50) {
							throw new CustomException("表箱编号必须小于50位");
						}
						measureFile.setMeasureNumber(stringValue);
						break;
					case "安装地址":
						if (null != stringValue && !stringValue.equals("")) {
							measureFile.setAddress(stringValue);
						}
						break;
					case "经度":
						if (null != stringValue && !stringValue.equals("")) {
							measureFile.setLongitude(stringValue);
						}
						break;
					case "纬度":
						if (null != stringValue && !stringValue.equals("")) {
							measureFile.setLatitude(stringValue);
						}
						break;
					case "组织机构":
						if (null != stringValue && !stringValue.equals("")) {
							measureFile.setOrganizationname(stringValue);
						}
						break;
					case "行政id":
						if (null != stringValue && !stringValue.equals("")) {
							measureFile.setRegion(Integer.parseInt(stringValue));
						}
						break;
					case "生产厂家":
						if (null != stringValue && !stringValue.equals("")) {
							measureFile.setManufacturer(stringValue);
						}
						break;
					case "生产日期":
						if (null != stringValue && !stringValue.equals("")) {
							measureFile.setProduceDate(dateFmt.parse(stringValue));
						}
						break;
					case "创建人":
						if (null != stringValue && !stringValue.equals("")) {
							measureFile.setCreater(stringValue);
						}
						break;
					case "创建日期":
						if (null != stringValue && !stringValue.equals("")) {
							measureFile.setCreateDate(dateFmt.parse(stringValue));
						}
						break;
					}
				}
			}
			if (rowIx != 0 && isEmpty) {
				list.add(measureFile);
			}
		}
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
	public List<MeasureFile> toListFromExcel(CommonsMultipartFile excelfil, int sheetNum) throws Exception {
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

	@Override
	public boolean dealList(List<MeasureFile> list) throws Exception {
		int temp = 1;
		if (null != list && list.size() > 0) {
			String content = "";
			for (int i = 0; i < list.size(); i++) {

				int count = measureFileMapper.selectCount(list.get(i).getMeasureId());
				// Exel中的组织结构名字转换成organizationId
				Integer organizationId = measureFileMapper.getOrganizationId(list.get(i).getOrganizationname());
				if (count > 0) {
					list.get(i).setOrganizationId(organizationId);
					temp = temp & measureFileMapper.update(list.get(i));
				} else {
					list.get(i).setOrganizationId(organizationId);
					temp = temp & measureFileMapper.insert(list.get(i));
				}
				content += "表箱id：" + list.get(i).getMeasureId() + "表箱编号：" + list.get(i).getMeasureNumber() + ",";
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
	public XSSFWorkbook exportExcelInfo(String nameDate, List<MeasureFile> list) throws Exception {
		List<ExcelBean> excel = new ArrayList<>();
		Map<Integer, List<ExcelBean>> map = new LinkedHashMap<>();
		XSSFWorkbook xssfWorkbook = null;
		// 设置标题栏
		excel.add(new ExcelBean("表箱id", "measureId", 0));
		excel.add(new ExcelBean("表箱名字", "measureName", 0));
		excel.add(new ExcelBean("表箱编号", "measureNumber", 0));
		excel.add(new ExcelBean("安装地址", "address", 0));
		excel.add(new ExcelBean("经度", "longitude", 0));
		excel.add(new ExcelBean("纬度", "latitude", 0));
		excel.add(new ExcelBean("组织机构", "organizationname", 0));
		excel.add(new ExcelBean("行政区域", "name", 0));
		excel.add(new ExcelBean("行政id", "region", 0));
		excel.add(new ExcelBean("生产厂家", "manufacturer", 0));
		excel.add(new ExcelBean("生产日期", "produceDate", 0));
		excel.add(new ExcelBean("创建人", "creater", 0));
		excel.add(new ExcelBean("创建日期", "createDate", 0));

		map.put(0, excel);
		String sheetName = nameDate + "表箱档案信息";
		// 调用ExcelUtil的方法
		xssfWorkbook = ExcelUtil.createExcelFile(MeasureFile.class, list, map, sheetName);
		return xssfWorkbook;
	}

	/**
	 * 搜索
	 */
	@Override
	public String searchInf(Integer organizationId, String MeasureName, String MeasureNumber, String Address,
			Integer startindex, int endindex) throws Exception {
		List<MeasureFile> list = new ArrayList<MeasureFile>();
		startindex = startindex - 1;
		list = measureFileMapper.searchInf(organizationId, MeasureName, MeasureNumber, Address, startindex, endindex);
		for (MeasureFile measureFile : list) {
			measureFile.setOrganizationname(measureFile.getOrganization().getOrganizationname());
			measureFile.setName(measureFile.getArea().getName());
		}
		int count = measureFileMapper.getMeasureFileCount(MeasureName, MeasureNumber, Address);
		String json = untilService.getDataPager(list, count);
		return json;
	}

	@Override
	public List<MeasureFile> getMeasurefileByOrganizationId(Integer OrganizationId) {
		return measureFileMapper.getMeasurefileByOrganizationId(OrganizationId);
	}

	// 更改表箱门节点状态
	@Override
	public String changeOpenStatus(Integer openStatus, Integer measureId) throws Exception {
		int result = measureFileMapper.changeOpenStatus(openStatus, measureId);
		if (result > 0) {
			return "success";
		} else {
			return "error";
		}
	}
}
