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
import com.ssm.wssmb.mapper.MbAmmeterMapper;
import com.ssm.wssmb.mapper.MeasureFileMapper;
import com.ssm.wssmb.mapper.OrganizationMapper;
import com.ssm.wssmb.model.Concentrator;
import com.ssm.wssmb.model.MbAmmeter;
import com.ssm.wssmb.model.MeasureFile;
import com.ssm.wssmb.model.Organization;
import com.ssm.wssmb.service.MbAmmeterService;
import com.ssm.wssmb.util.CustomException;
import com.ssm.wssmb.util.EventLogAspect;
import com.ssm.wssmb.util.ExcelBean;
import com.ssm.wssmb.util.ExcelUtil;
import com.ssm.wssmb.util.ResponseResult;

@Service
public class MbAmmeterServiceImpl implements MbAmmeterService {

	@Autowired
	public MbAmmeterMapper mbAmmeterMapper;

	@Autowired
	public OrganizationMapper organizationMapper;

	@Autowired
	public ConcentratorMapper concentratorMapper;

	@Autowired
	public MeasureFileMapper measureFileMapper;

	/**
	 * Excel 2003
	 */
	private final static String XLS = "xls";
	/**
	 * Excel 2007
	 */
	private final static String XLSX = "xlsx";

	SimpleDateFormat dateFmt = new SimpleDateFormat("yyyy-MM-dd");

	@Resource
	private EventLogAspect log;

	@Override
	public ResponseResult selectAll(int orgId, int startindex, int endindex) {
		List<Integer> queryTotal = mbAmmeterMapper.queryTotal(orgId);
		startindex = startindex - 1;

		List<MbAmmeter> mbAmmeter = mbAmmeterMapper.selectAll(orgId, startindex, endindex);
		for (MbAmmeter ma : mbAmmeter) {
			int organizationId = ma.getOrganizationCode();
			Organization selectByPrimaryKey = organizationMapper.selectByPrimaryKey(organizationId);
			if (selectByPrimaryKey != null) {
				ma.setOrganizationName(selectByPrimaryKey.getOrganizationname());
			}
			int concentratorId = ma.getConcentratorCode();
			Concentrator concentratorByid = concentratorMapper.getConcentratorByid(concentratorId);
			if (concentratorByid != null) {
				ma.setConcentratorName(concentratorByid.getConcentratorName());
			}
			int measureId = ma.getBoxCode();
			MeasureFile measurefileByMeasureId = measureFileMapper.getMeasurefileByMeasureId(measureId);
			if (measurefileByMeasureId != null) {
				ma.setBoxName(measurefileByMeasureId.getMeasureName());
			}
		}
		ResponseResult responseResult = new ResponseResult();
		if (mbAmmeter.size() >= 0) {
			responseResult.setCode(200);
			responseResult.setRows(mbAmmeter);
			responseResult.setMessage("查询所有集中器成功");
			responseResult.setTotal(queryTotal.size());
		} else {
			responseResult.setCode(400);
			responseResult.setMessage("服务器出错");
		}
		return responseResult;
	}

	@Override
	public ResponseResult addAmmeter(String ammeterName, String ammeterCode, String installAddress,
			int concentratorCode, int organizationCode, String produce, String produceTime, String createPerson,
			String createTime, int boxCode, String ammeterType, String softType, String hardType) {
		// MD5Util.MD5(Math.random());
		int addAmmeter = mbAmmeterMapper.addAmmeter(ammeterName, ammeterCode, installAddress, concentratorCode,
				organizationCode, produce, produceTime, createPerson, createTime, boxCode, ammeterType, softType,
				hardType);
		ResponseResult responseResult = new ResponseResult();
		if (addAmmeter >= 0) {
			responseResult.setCode(200);
			responseResult.setMessage("添加电表档案成功");
			responseResult.setTotal(addAmmeter);
		} else {
			responseResult.setCode(400);
			responseResult.setMessage("服务器出错");
		}
		return responseResult;
	}

	@Override
	public ResponseResult editAmmeter(MbAmmeter mbAmmeter) {
		ResponseResult responseResult = new ResponseResult();
		boolean editAmmeter = mbAmmeterMapper.editAmmeter(mbAmmeter);
		if (editAmmeter) {
			responseResult.setCode(200);
			responseResult.setMessage("修改电表档案成功！");
		} else {
			responseResult.setCode(400);
			responseResult.setMessage("修改电表档案失败，服务器内部出错！");
		}
		return responseResult;

	}

	@Override
	public ResponseResult deleteAmmeter(int id) {
		ResponseResult responseResult = new ResponseResult();
		boolean deleteAmmeter = mbAmmeterMapper.deleteAmmeter(id);
		if (deleteAmmeter) {
			responseResult.setCode(200);
			responseResult.setMessage("删除电表档案成功！");
		} else {
			responseResult.setCode(400);
			responseResult.setMessage("删除电表档案失败，服务器内部出错！");
		}
		return responseResult;

	}

	/**
	 * 导出电表档案信息
	 * 
	 * @param workbook
	 * @param sheetNum
	 * @return
	 * @author Eric
	 * @throws Exception
	 */
	@Override
	public XSSFWorkbook exportAmmeterToExcel(int orgId) throws Exception {
		List<MbAmmeter> list = mbAmmeterMapper.selectAll(orgId, 0, 99999);
		List<MbAmmeter> newList = new ArrayList<>();
		for (MbAmmeter ma : list) {
			int organizationId = ma.getOrganizationCode();
			Organization selectByPrimaryKey = organizationMapper.selectByPrimaryKey(organizationId);
			if (selectByPrimaryKey != null) {
				ma.setOrganizationName(selectByPrimaryKey.getOrganizationname());
			}
			int concentratorId = ma.getConcentratorCode();
			Concentrator concentratorByid = concentratorMapper.getConcentratorByid(concentratorId);
			if (concentratorByid != null) {
				ma.setConcentratorName(concentratorByid.getConcentratorName());
			}
			int boxCode = ma.getBoxCode();
			MeasureFile measurefileByMeasureId = measureFileMapper.getMeasurefileByMeasureId(boxCode);
			if (measurefileByMeasureId != null) {
				ma.setBoxName(measurefileByMeasureId.getMeasureName());
			}
			newList.add(ma);
		}
		List<ExcelBean> excel = new ArrayList<>();
		Map<Integer, List<ExcelBean>> map = new LinkedHashMap<>();
		XSSFWorkbook xssfWorkbook = null;
		// 设置标题栏
		excel.add(new ExcelBean("电表名称", "ammeterName", 0));
		excel.add(new ExcelBean("表号", "ammeterCode", 0));
		excel.add(new ExcelBean("安装位置", "installAddress", 0));
		excel.add(new ExcelBean("所属集中器", "concentratorName", 0));
		excel.add(new ExcelBean("组织机构", "organizationName", 0));
		excel.add(new ExcelBean("生产厂家", "produce", 0));
		excel.add(new ExcelBean("生产日期", "produceTime", 0));
		excel.add(new ExcelBean("创建人", "createPerson", 0));
		excel.add(new ExcelBean("创建时间", "createTime", 0));
		excel.add(new ExcelBean("所属表箱", "boxName", 0));
		excel.add(new ExcelBean("电表型号", "ammeterType", 0));
		excel.add(new ExcelBean("软件版本号", "softType", 0));
		excel.add(new ExcelBean("硬件版本号", "hardType", 0));

		map.put(0, excel);
		String sheetName = "电表档案信息";
		// 调用ExcelUtil的方法
		xssfWorkbook = ExcelUtil.createExcelFile(MbAmmeter.class, newList, map, sheetName);
		return xssfWorkbook;
	}

	@Override
	public List<MbAmmeter> readExcelFile(CommonsMultipartFile excelfil) throws Exception {
		int sheetNum = 0;// 第几个工作表
		List<MbAmmeter> list = toListFromExcel(excelfil, sheetNum);
		return list;
	}

	/**
	 * 由Excel文件的Sheet导出至List
	 * 
	 * @param excelfil
	 * @param sheetNum
	 * @return
	 * @author Eric
	 * @throws Exception
	 */
	public List<MbAmmeter> toListFromExcel(CommonsMultipartFile excelfil, int sheetNum) throws Exception {
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
	 * @author Eric
	 * @throws Exception
	 * @throws IOException
	 */
	private List<MbAmmeter> toListFromExcel(Workbook workbook, int sheetNum) throws Exception {

		Sheet sheet = workbook.getSheetAt(sheetNum);
		List<MbAmmeter> list = new ArrayList<MbAmmeter>();

		int minRowIx = sheet.getFirstRowNum();
		int maxRowIx = sheet.getLastRowNum();

		// 导入excel的标题格式
		String[] cfiled = { "电表名称", "表号", "安装位置", "所属集中器", "组织机构", "生产厂家", "生产日期", "创建人", "创建时间", "所属表箱", "电表型号",
				"软件版本号", "硬件版本号" };
		String[] colFiled = new String[0];

		int len = 0;
		int count = 0;

		for (int rowIx = minRowIx; rowIx <= maxRowIx; rowIx++) {
			Row row = sheet.getRow(rowIx);
			MbAmmeter mbAmmeter = new MbAmmeter();

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
							&& (cellText.equals("电表名称") || cellText.equals("表号"))) {
						isEmpty = false;
						throw new CustomException(cellText + "不可空！");
						// continue;
					}

					switch (cellText) {
					case "电表名称":
						if (null != stringValue && !stringValue.equals("")) {
							boolean nameExisted = nameExisted(stringValue);
							if (nameExisted) {
								throw new Exception("电表名称已存在！");
							}
							mbAmmeter.setAmmeterName(stringValue);
						}
						break;
					case "表号":
						if (null != stringValue && !stringValue.equals("")) {
							mbAmmeter.setAmmeterCode(stringValue);
						}
						break;
					case "安装位置":
						if (null != stringValue && !stringValue.equals("")) {
							mbAmmeter.setInstallAddress(stringValue);
						}
						break;
					case "所属集中器":
						if (null != stringValue && !stringValue.equals("")) {
							int codeByName = concentratorMapper.getCodeByName(stringValue);
							mbAmmeter.setConcentratorCode(codeByName);
						}
						break;
					case "组织机构":
						if (null != stringValue && !stringValue.equals("")) {
							int codeByName = organizationMapper.getCodeByName(stringValue);
							mbAmmeter.setOrganizationCode(codeByName);
						}
						break;
					case "生产厂家":
						if (null != stringValue && !stringValue.equals("")) {
							mbAmmeter.setProduce(stringValue);
						}
						break;// "电表名称","表号","安装位置","所属集中器","组织机构","生产厂家","生产日期","创建人","创建时间","所属表箱","电表型号","软件版本号","硬件版本号"
					case "创建人":
						if (null != stringValue && !stringValue.equals("")) {
							mbAmmeter.setCreatePerson(stringValue);
						}
						break;
					case "所属表箱":
						if (null != stringValue && !stringValue.equals("")) {
							int codeByName = measureFileMapper.getCodeByName(stringValue);
							mbAmmeter.setBoxCode(codeByName);
						}
						break;
					case "电表型号":
						if (null != stringValue && !stringValue.equals("")) {
							mbAmmeter.setAmmeterType(stringValue);
						}
						break;
					case "软件版本号":
						if (null != stringValue && !stringValue.equals("")) {
							mbAmmeter.setSoftType(stringValue);
						}
						break;
					case "硬件版本号":
						if (null != stringValue && !stringValue.equals("")) {
							mbAmmeter.setHardType(stringValue);
						}
						break;
					case "生产日期":
						if (null != stringValue && !stringValue.equals("")) {
							mbAmmeter.setProduceTime(stringValue);
						}
						break;
					case "创建时间":
						if (null != stringValue && !stringValue.equals("")) {
							mbAmmeter.setCreateTime(stringValue);
						}
						break;
					}
				}
			}
			if (rowIx != 0 && isEmpty) {
				list.add(mbAmmeter);
			}
		}
		return list;
	}

	/**
	 * 导入SIM卡信息
	 * 
	 * @param workbook
	 * @param sheetNum
	 * @return
	 * @author Eric
	 * @throws Exception
	 * @throws IOException
	 */
	@Override
	public boolean dealList(List<MbAmmeter> list) throws Exception {
		if (null != list && list.size() > 0) {
			String content = "";
			for (int i = 0; i < list.size(); i++) {
				boolean addOneAmmeter = mbAmmeterMapper.addOneAmmeter(list.get(i));
				content += "表号：" + list.get(i).getAmmeterCode() + "序列号：" + ",";
				if (!addOneAmmeter) {
					return false;
				}
			}

			if (content != "")
				content = content.substring(0, content.length() - 1);
			log.addLog("", "导入电表档案信息", content, 0);
		}
		return true;
		// int temp=1;
		// if(null != list && list.size() > 0){
		// String content = "";
		// for(int i = 0; i < list.size(); i++){
		// int count = simCardMapper.selectCount(list.get(i).getSerialnumber());
		// if (count > 0){
		// temp = temp & simCardMapper.update(list.get(i));
		// }
		// else{
		// temp = temp & simCardMapper.insert(list.get(i));
		// }
		// content += "卡号：" + list.get(i).getCardnumber() + "序列号：" +
		// list.get(i).getSerialnumber() + ",";
		// if(temp<0){
		// return false;
		// }
		// }
		//
		// if(content != "") content = content.substring(0,content.length()-1);
		// log.addLog("", "导入SIM卡信息", content, 0);
		// }
		// return true;
	}

	@Override
	public ResponseResult queryAmmeter(int orgId, String selectValue, String inputValue, int startindex, int endindex) {
		startindex = startindex - 1;
		List<MbAmmeter> queryAmmeter = new ArrayList<>();
		ResponseResult responseResult = new ResponseResult();
		if (selectValue == "电表名称" || selectValue.equals("电表名称")) {
			inputValue = "%" + inputValue + "%";
			List<Integer> queryTotalByName = mbAmmeterMapper.queryTotalByName(orgId, inputValue);
			responseResult.setTotal(queryTotalByName.size());
			queryAmmeter = mbAmmeterMapper.queryAmmeterByName(orgId, inputValue, startindex, endindex);
			for (MbAmmeter ma : queryAmmeter) {
				int organizationId = ma.getOrganizationCode();
				Organization selectByPrimaryKey = organizationMapper.selectByPrimaryKey(organizationId);
				if (selectByPrimaryKey != null) {
					ma.setOrganizationName(selectByPrimaryKey.getOrganizationname());
				}
				int concentratorId = ma.getConcentratorCode();
				Concentrator concentratorByid = concentratorMapper.getConcentratorByid(concentratorId);
				if (concentratorByid != null) {
					ma.setConcentratorName(concentratorByid.getConcentratorName());
				}
				int boxCode = ma.getBoxCode();
				MeasureFile measurefileByMeasureId = measureFileMapper.getMeasurefileByMeasureId(boxCode);
				if (measurefileByMeasureId != null) {
					ma.setBoxName(measurefileByMeasureId.getMeasureName());
				}

			}
		}
		if (selectValue == "表号" || selectValue.equals("表号")) {
			inputValue = "%" + inputValue + "%";
			List<Integer> queryTotalByCode = mbAmmeterMapper.queryTotalByCode(orgId, inputValue);
			responseResult.setTotal(queryTotalByCode.size());
			queryAmmeter = mbAmmeterMapper.queryAmmeterByCode(orgId, inputValue, startindex, endindex);
			for (MbAmmeter ma : queryAmmeter) {
				int organizationId = ma.getOrganizationCode();
				Organization selectByPrimaryKey = organizationMapper.selectByPrimaryKey(organizationId);
				if (selectByPrimaryKey != null) {
					ma.setOrganizationName(selectByPrimaryKey.getOrganizationname());
				}
				int concentratorId = ma.getConcentratorCode();
				Concentrator concentratorByid = concentratorMapper.getConcentratorByid(concentratorId);
				if (concentratorByid != null) {
					ma.setConcentratorName(concentratorByid.getConcentratorName());
				}
				int boxCode = ma.getBoxCode();
				MeasureFile measurefileByMeasureId = measureFileMapper.getMeasurefileByMeasureId(boxCode);
				if (measurefileByMeasureId != null) {
					ma.setBoxName(measurefileByMeasureId.getMeasureName());
				}
			}
		}
		responseResult.setCode(200);
		responseResult.setRows(queryAmmeter);
		responseResult.setMessage("查询集中器成功");
		return responseResult;
	}

	@Override
	public List<MbAmmeter> getAmmeterByMeasurefile(String measureId) {
		return mbAmmeterMapper.getAmmeterByMeasurefile(measureId);
	}

	@Override
	public boolean nameExisted(String ammeterName) {
		MbAmmeter nameExisted = mbAmmeterMapper.nameExisted(ammeterName);
		if (nameExisted != null) {
			return true;
		} else {
			return false;
		}
	}

	@Override
	public boolean nameExistedAndId(String ammeterName, int id) {
		MbAmmeter nameExisted = mbAmmeterMapper.nameExistedAndId(ammeterName, id);
		if (nameExisted != null) {
			return true;
		} else {
			return false;
		}
	}

	@Override
	public List<MbAmmeter> queryAmmeterByTree(String treeType, int gid) {
		List<MbAmmeter> organizationTree = new ArrayList<>();
		if (treeType == "Organization") {
			organizationTree = organizationTree(gid);
		} else if (treeType == "MeasureFile") {
			// 根据表箱查询集中器 ，遍历集中器 ， 根据集中器查询电表
			organizationTree = mbAmmeterMapper.getAmmeterByMeasureId(gid);
			for (MbAmmeter ma : organizationTree) {
				int organizationId = ma.getOrganizationCode();
				Organization selectByPrimaryKey = organizationMapper.selectByPrimaryKey(organizationId);
				if (selectByPrimaryKey != null) {
					ma.setOrganizationName(selectByPrimaryKey.getOrganizationname());
				}
				int concentratorId = ma.getConcentratorCode();
				Concentrator concentratorByid = concentratorMapper.getConcentratorByid(concentratorId);
				if (concentratorByid != null) {
					ma.setConcentratorName(concentratorByid.getConcentratorName());
				}
				int boxCode = ma.getBoxCode();
				MeasureFile measurefileByMeasureId = measureFileMapper.getMeasurefileByMeasureId(boxCode);
				if (measurefileByMeasureId != null) {
					ma.setBoxName(measurefileByMeasureId.getMeasureName());
				}
			}
		} else if (treeType == "Concentrator") {// 直接在电表里查集中器code=id有哪些
			organizationTree = mbAmmeterMapper.getAmmeterByConcentratorId(gid);
			for (MbAmmeter ma : organizationTree) {
				int organizationId = ma.getOrganizationCode();
				Organization selectByPrimaryKey = organizationMapper.selectByPrimaryKey(organizationId);
				if (selectByPrimaryKey != null) {
					ma.setOrganizationName(selectByPrimaryKey.getOrganizationname());
				}
				int concentratorId = ma.getConcentratorCode();
				Concentrator concentratorByid = concentratorMapper.getConcentratorByid(concentratorId);
				if (concentratorByid != null) {
					ma.setConcentratorName(concentratorByid.getConcentratorName());
				}
				int boxCode = ma.getBoxCode();
				MeasureFile measurefileByMeasureId = measureFileMapper.getMeasurefileByMeasureId(boxCode);
				if (measurefileByMeasureId != null) {
					ma.setBoxName(measurefileByMeasureId.getMeasureName());
				}
			}
		} else if (treeType == "Area") {
			List<Concentrator> regionClickTreeList = concentratorMapper.regionClickTreeList(gid);
			for (Concentrator concentrator : regionClickTreeList) {
				Integer concentratorId = concentrator.getConcentratorId();
				List<MbAmmeter> ammeterByConcentratorId = mbAmmeterMapper.getAmmeterByConcentratorId(concentratorId);
				for (MbAmmeter ma : ammeterByConcentratorId) {
					int organizationId = ma.getOrganizationCode();
					Organization selectByPrimaryKey = organizationMapper.selectByPrimaryKey(organizationId);
					if (selectByPrimaryKey != null) {
						ma.setOrganizationName(selectByPrimaryKey.getOrganizationname());
					}
					int concentratorId2 = ma.getConcentratorCode();
					Concentrator concentratorByid = concentratorMapper.getConcentratorByid(concentratorId2);
					if (concentratorByid != null) {
						ma.setConcentratorName(concentratorByid.getConcentratorName());
					}
					int boxCode = ma.getBoxCode();
					MeasureFile measurefileByMeasureId = measureFileMapper.getMeasurefileByMeasureId(boxCode);
					if (measurefileByMeasureId != null) {
						ma.setBoxName(measurefileByMeasureId.getMeasureName());
					}
					organizationTree.add(ma);
				}
			}
		}
		return organizationTree;
	}

	// 点击的是组织机构
	public List<MbAmmeter> organizationTree(int orgId) {
		List<MbAmmeter> newList = new ArrayList<>();
		List<MbAmmeter> traverse1 = traverse(orgId);// 最高一级的组织机构，查询直属的所有电表
		for (MbAmmeter ma : traverse1) {// 遍历所有电表
			int organizationId = ma.getOrganizationCode();
			Organization selectByPrimaryKey = organizationMapper.selectByPrimaryKey(organizationId);
			if (selectByPrimaryKey != null) {
				ma.setOrganizationName(selectByPrimaryKey.getOrganizationname());
			}
			int concentratorId = ma.getConcentratorCode();
			Concentrator concentratorByid = concentratorMapper.getConcentratorByid(concentratorId);
			if (concentratorByid != null) {
				ma.setConcentratorName(concentratorByid.getConcentratorName());
			}
			int measureId = ma.getBoxCode();
			MeasureFile measurefileByMeasureId = measureFileMapper.getMeasurefileByMeasureId(measureId);
			if (measurefileByMeasureId != null) {
				ma.setBoxName(measurefileByMeasureId.getMeasureName());
			}
			newList.add(ma);// 加入到返回值里面
		}
		while (organizationMapper.selectListByParentId(orgId) != null) {// 如果有下级组织机构
			List<MbAmmeter> traverseOrg = traverseOrg(newList, orgId);
			return traverseOrg;
		}
		;
		return newList;

	}

	// 点击的是组织机构---- 查询是否有下一级组织机构
	public List<MbAmmeter> traverseOrg(List<MbAmmeter> newList, int orgId) {
		List<Organization> selectListByParentId = organizationMapper.selectListByParentId(orgId);// 查询最高一级组织机构的下一级所有组织机构
		for (Organization organization : selectListByParentId) {// 遍历下级所有组织机构
			int id = organization.getOrganizationid();// 获取第二级组织机构id
			List<MbAmmeter> traverse = traverse(id);// 根据最后一层组织机构id遍历所属的所有电表
			for (MbAmmeter ma : traverse) {// traverse()
				int organizationId = ma.getOrganizationCode();
				Organization selectByPrimaryKey = organizationMapper.selectByPrimaryKey(organizationId);
				if (selectByPrimaryKey != null) {
					ma.setOrganizationName(selectByPrimaryKey.getOrganizationname());
				}
				int concentratorId = ma.getConcentratorCode();
				Concentrator concentratorByid = concentratorMapper.getConcentratorByid(concentratorId);
				if (concentratorByid != null) {
					ma.setConcentratorName(concentratorByid.getConcentratorName());
				}
				int measureId = ma.getBoxCode();
				MeasureFile measurefileByMeasureId = measureFileMapper.getMeasurefileByMeasureId(measureId);
				if (measurefileByMeasureId != null) {
					ma.setBoxName(measurefileByMeasureId.getMeasureName());
				}
				newList.add(ma);
			}

			if (organizationMapper.selectListByParentId(id) != null) {
				traverseOrg(newList, id);
			}

		}
		return newList;
	}

	// 点击的是组织机构----根据最后一层组织机构id遍历所属的所有电表 traverse()
	public List<MbAmmeter> traverse(int orgId) {
		List<MbAmmeter> ammeterByConcentratorId = new ArrayList<>();
		List<MeasureFile> measurefileByOrganizationId = measureFileMapper.getMeasurefileByOrgId(orgId);
		for (MeasureFile measureFile : measurefileByOrganizationId) {
			int measureId = measureFile.getMeasureId();
			List<Concentrator> concentratorByMeasureId = concentratorMapper.getConcentratorByMeasureId(measureId);
			for (Concentrator concentrator : concentratorByMeasureId) {
				Integer concentratorId = concentrator.getConcentratorId();
				ammeterByConcentratorId = mbAmmeterMapper.getAmmeterByConcentratorId(concentratorId);
			}
		}
		return ammeterByConcentratorId;
	}// 点击的是表箱

	@Override
	public MbAmmeter queryAmmeterByAmmeterCode(String ammeterCode) {
		MbAmmeter ammeterByAmmeterCode = mbAmmeterMapper.getAmmeterByAmmeterCode(ammeterCode);
		if (ammeterByAmmeterCode != null) {
			int measureId = ammeterByAmmeterCode.getBoxCode();
			MeasureFile measurefileByMeasureId = measureFileMapper.getMeasurefileByMeasureId(measureId);
			ammeterByAmmeterCode.setMeasureFile(measurefileByMeasureId);
			return ammeterByAmmeterCode;
		} else {
			return null;
		}
	}

	@Override
	public MbAmmeter getAmmeterCodeByid(int id) {
		MbAmmeter ammeterCodeByid = mbAmmeterMapper.getAmmeterCodeByid(id);
		return ammeterCodeByid;
	}

}
