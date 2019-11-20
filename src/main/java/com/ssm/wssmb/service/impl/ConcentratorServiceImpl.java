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
import com.ssm.wssmb.model.Concentrator;
import com.ssm.wssmb.model.MeasureFile;
import com.ssm.wssmb.service.ConcentratorService;
import com.ssm.wssmb.service.UntilService;
import com.ssm.wssmb.util.CustomException;
import com.ssm.wssmb.util.EventLogAspect;
import com.ssm.wssmb.util.ExcelBean;
import com.ssm.wssmb.util.ExcelUtil;
import com.ssm.wssmb.util.ResponseResult;

@Service
public class ConcentratorServiceImpl implements ConcentratorService {

	/**
	 * Excel 2003
	 */
	private final static String XLS = "xls";
	/**
	 * Excel 2007
	 */
	private final static String XLSX = "xlsx";
	SimpleDateFormat time = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat dateFmt = new SimpleDateFormat("yyyy-MM-dd");

	@Autowired
	ConcentratorMapper concentratorMapper;

	@Autowired
	MeasureFileMapper measureFileMapper;

	@Resource
	private EventLogAspect log;

	@Autowired
	UntilService untilService;

	/**
	 * 将表中的OrganizationId转为OrganizationName在页面显示
	 */
	@Override
	public List<Concentrator> getList(Integer organizationId) {
		List<Concentrator> list = concentratorMapper.selectList(organizationId);
		for (Concentrator concentrator : list) {
			concentrator.setOrganizationName(concentrator.getOrganization().getOrganizationname());
			concentrator.setMeasureName(concentrator.getMeasureFile().getMeasureName());
		}
		return list;
	}

	/**
	 * 点击树查询
	 */
	@Override
	public List<Concentrator> cliekTreeList(Integer type, Integer id,String name,String address) {
		List<Concentrator> list = new ArrayList<Concentrator>();
		if (type == 1) {
			list = concentratorMapper.organizationClickTreeList(id,name,address);
			for (Concentrator concentrator : list) {
				concentrator.setOrganizationName(concentrator.getOrganization().getOrganizationname());
				concentrator.setMeasureName(concentrator.getMeasureFile().getMeasureName());
			}

		} else {
			if (type == 3) {
				list = concentratorMapper.getConcentratorAndNameByMeasureId(id.toString(),name,address);
			} else if (type == 4) {
				list = concentratorMapper.getByIdAndType(id,name,address);
			} else {
				list = concentratorMapper.regionClickTreeLists(id,name,address);
			}
			for (Concentrator concentrator : list) {
				concentrator.setOrganizationName(concentrator.getOrganization().getOrganizationname());
				concentrator.setMeasureName(concentrator.getMeasureFile().getMeasureName());
			}
		}
		return list;
	}

	@Override
	public String addOrUpdate(Concentrator concentrator) {
		String success = "success";
		String error = "error";
		int result = 0;
		// 判断地址是否重复
		boolean falg = true;
		String[] address = concentratorMapper.getAllAddress();
		int region = measureFileMapper.getRegionByMeasureId(concentrator.getMeasureId());
		concentrator.setRegion(region);
		// 保持设备的组织机构和表箱的一样，防止出现表箱为浙江总经销，设备为智慧消防安全系统这种情况
		Integer orgnazationId = measureFileMapper.getOrganizationIdByMeasureId(concentrator.getMeasureId());
		concentrator.setOrganizationId(orgnazationId);
		Integer num = concentratorMapper.getConcentratorCountByMeasureId(concentrator.getMeasureId());
		if (null == concentrator.getConcentratorId()) { // 添加
			// 根据表箱id查询集中器，唯一性判断

			if (num == 0) { // 该表箱下没有集中器
				for (int j = 0; j < address.length; j++) {
					if (address[j].equals(concentrator.getAddress())) {
						falg = false;
						error = "集中器地址重复";
					}
				}
				if (falg) {
					result = concentratorMapper.insert(concentrator);
				}
			} else {
				error = "该表箱已有集中器";
			}
		} else { // 修改
			// 判断表箱下是否有集中器
			if (num == 0) { // 该表箱下没有集中器
				String tsa = concentratorMapper.getConcentratorByid(concentrator.getConcentratorId()).getAddress();
				if (tsa.equals(concentrator.getAddress())) {
					falg = true;
				} else {
					for (int j = 0; j < address.length; j++) {
						if (address[j].equals(concentrator.getAddress())) {
							falg = false;
							error = "集中器地址重复";
						}
					}
				}
				if (falg) {
					result = concentratorMapper.update(concentrator);
				}
			} else {
				error = "该表箱已有集中器";
			}
		}
		String content = "集中器id：" + concentrator.getConcentratorId() + "集中器名字：" + concentrator.getConcentratorName();
		log.addLog("", "添加或修改集中器档案", content, 0);
		return result > 0 ? success : error;
	}

	@Override
	public String delete(String concentratorId) {
		int result = concentratorMapper.delete(Integer.parseInt(concentratorId));
		String content = "集中器id：" + concentratorId + "集中器名字：";
		log.addLog("", "删除集中器档案", content, 1);
		return result > 0 ? "success" : "error";

	}

	/**
	 * 导出
	 */
	@Override
	public XSSFWorkbook exportExcelInfo(String nameDate, List<Concentrator> list) throws Exception {
		List<ExcelBean> excel = new ArrayList<>();
		Map<Integer, List<ExcelBean>> map = new LinkedHashMap<>();
		XSSFWorkbook xssfWorkbook = null;
		// 设置标题栏
		excel.add(new ExcelBean("集中器id", "concentratorId", 0));
		excel.add(new ExcelBean("集中器名称", "concentratorName", 0));
		excel.add(new ExcelBean("安装地址", "address", 0));
		excel.add(new ExcelBean("安装位置", "installationLocation", 0));
		excel.add(new ExcelBean("所属表箱", "measureName", 0));
		excel.add(new ExcelBean("组织机构", "organizationName", 0));
		excel.add(new ExcelBean("行政区域", "region", 0));
		excel.add(new ExcelBean("生产厂家", "manufacturer", 0));
		excel.add(new ExcelBean("生产日期", "produceDate", 0));
		excel.add(new ExcelBean("创建人", "creater", 0));
		excel.add(new ExcelBean("创建日期", "createDate", 0));
		excel.add(new ExcelBean("SIM卡", "simCard", 0));
		excel.add(new ExcelBean("软件版本号", "softType", 0));
		excel.add(new ExcelBean("硬件版本号", "hardType", 0));
		excel.add(new ExcelBean("集中器型号", "concentratorType", 0));
		excel.add(new ExcelBean("规约类型", "statuteType", 0));

		map.put(0, excel);
		String sheetName = nameDate + "集中器档案信息";
		// 调用ExcelUtil的方法
		xssfWorkbook = ExcelUtil.createExcelFile(Concentrator.class, list, map, sheetName);
		return xssfWorkbook;
	}

	@Override
	public List<Concentrator> readExcelFile(CommonsMultipartFile excelfil) throws Exception {
		int sheetNum = 0;// 第几个工作表
		List<Concentrator> list = toListFromExcel(excelfil, sheetNum);
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
	private List<Concentrator> toListFromExcel(Workbook workbook, int sheetNum) throws Exception {
		Sheet sheet = workbook.getSheetAt(sheetNum);
		List<Concentrator> list = new ArrayList<Concentrator>();

		int minRowIx = sheet.getFirstRowNum();
		int maxRowIx = sheet.getLastRowNum();

		// 导入excel的标题格式
		String[] cfiled = { "集中器id", "集中器名称", "安装地址", "安装位置", "所属表箱", "组织机构", "行政区域", "生产厂家", "生产日期", "创建人", "创建日期",
				"SIM卡", "软件版本号", "硬件版本号", "集中器型号", "规约类型" };
		String[] colFiled = new String[0];

		int len = 0;
		int count = 0;

		for (int rowIx = minRowIx; rowIx <= maxRowIx; rowIx++) {
			Row row = sheet.getRow(rowIx);
			Concentrator concentrator = new Concentrator();
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
					case "集中器id":
						if (stringValue.length() > 20) {
							throw new CustomException("表箱id必须小于20位");
						}
						concentrator.setConcentratorId(Integer.parseInt(stringValue));
						break;
					case "集中器名称":
						if (stringValue.length() > 50) {
							throw new CustomException("表箱名字必须小于50位");
						}
						concentrator.setConcentratorName(stringValue);
						break;
					case "安装地址":
						if (stringValue.length() > 50) {
							throw new CustomException("表箱编号必须小于50位");
						}
						concentrator.setAddress(stringValue);
						break;
					case "安装位置":
						if (null != stringValue && !stringValue.equals("")) {
							concentrator.setInstallationLocation(stringValue);
						}
						break;
					case "所属表箱":
						if (null != stringValue && !stringValue.equals("")) {
							concentrator.setMeasureName(stringValue);
						}
						break;
					case "组织机构":
						if (null != stringValue && !stringValue.equals("")) {
							concentrator.setOrganizationName(stringValue);
						}
						break;
					case "行政区域":
						if (null != stringValue && !stringValue.equals("")) {
							concentrator.setRegion(Integer.parseInt(stringValue));
						}
						break;
					case "生产厂家":
						if (null != stringValue && !stringValue.equals("")) {
							concentrator.setManufacturer(stringValue);
						}
						break;
					case "生产日期":
						if (null != stringValue && !stringValue.equals("")) {
							concentrator.setCreateDate(dateFmt.parse(stringValue));
						}
						break;
					case "创建人":
						if (null != stringValue && !stringValue.equals("")) {
							concentrator.setCreater(stringValue);
						}
						break;
					case "创建日期":
						if (null != stringValue && !stringValue.equals("")) {
							concentrator.setCreateDate(dateFmt.parse(stringValue));
						}
						break;
					case "SIM卡":
						if (null != stringValue && !stringValue.equals("")) {
							concentrator.setSimCard(stringValue);
						}
						break;
					case "软件版本号":
						if (null != stringValue && !stringValue.equals("")) {
							concentrator.setSoftType(stringValue);
						}
						break;
					case "硬件版本号":
						if (null != stringValue && !stringValue.equals("")) {
							concentrator.setHardType(stringValue);
						}
						break;
					case "集中器型号":
						if (null != stringValue && !stringValue.equals("")) {
							concentrator.setConcentratorType(Integer.parseInt(stringValue));
						}
						break;
					case "规约类型":
						if (null != stringValue && !stringValue.equals("")) {
							concentrator.setStatuteType(Integer.parseInt(stringValue));
						}
						break;

					}
				}
			}
			if (rowIx != 0 && isEmpty) {
				list.add(concentrator);
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
	public List<Concentrator> toListFromExcel(CommonsMultipartFile excelfil, int sheetNum) throws Exception {
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
	public boolean dealList(List<Concentrator> list) throws Exception {
		int temp = 1;
		if (null != list && list.size() > 0) {
			String content = "";
			for (int i = 0; i < list.size(); i++) {
				if (list.get(i).getConcentratorId() == null) {
					list.get(i).setConcentratorId(0);
				}
				int count = concentratorMapper.selectCount(list.get(i).getConcentratorId());
				// Exel中的组织结构名字转换成organizationId
				Integer organizationId = measureFileMapper.getOrganizationId(list.get(i).getOrganizationName());
				// 根据表箱名字获取表箱id
				Integer measureId = measureFileMapper.getMeasureId(list.get(i).getMeasureName());
				if (count > 0) {
					list.get(i).setOrganizationId(organizationId);
					list.get(i).setMeasureId(measureId);
					temp = temp & concentratorMapper.update(list.get(i));
				} else {
					list.get(i).setOrganizationId(organizationId);
					list.get(i).setMeasureId(measureId);
					temp = temp & concentratorMapper.insert(list.get(i));
				}
				content += "集中器id：" + list.get(i).getConcentratorId() + "集中器名字：" + list.get(i).getConcentratorName()
						+ ",";
				if (temp < 0) {
					return false;
				}
			}

			if (content != "")
				content = content.substring(0, content.length() - 1);
			log.addLog("", "导入集中器档案信息", content, 0);
		}
		return true;
	}

	/**
	 * 搜索
	 */
	@Override
	public String searchInf(Integer organizationId, String ConcentratorName, String Address, Integer startindex,
			int endindex) throws Exception {
		List<Concentrator> list = new ArrayList<Concentrator>();
		startindex = startindex - 1;
		list = concentratorMapper.searchInf(organizationId, ConcentratorName, Address, startindex, endindex);
		for (Concentrator concentrator : list) {
			concentrator.setMeasureName(concentrator.getMeasureFile().getMeasureName());
			concentrator.setOrganizationName(concentrator.getOrganization().getOrganizationname());
		}
		int count = concentratorMapper.getConcentratorCount(ConcentratorName, Address);
		String json = untilService.getDataPager(list, count);
		return json;
	}

	/**
	 * 查询表箱下的集中器
	 */
	@Override
	public List<Concentrator> getConcentratorByMeasureId(Integer measureId) {

		return concentratorMapper.getConcentratorByMeasureId(measureId);
	}

	@Override
	public List<Concentrator> getConcentratorByMeasurefile(String measureId) {
		List<Concentrator> concentratorByMeasurefile = concentratorMapper.getConcentratorByMeasurefile(measureId);
		return concentratorByMeasurefile;
	}

}
