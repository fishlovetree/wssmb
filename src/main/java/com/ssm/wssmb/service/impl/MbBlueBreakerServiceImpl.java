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
import com.ssm.wssmb.mapper.MbBlueBreakerMapper;
import com.ssm.wssmb.mapper.MeasureFileMapper;
import com.ssm.wssmb.mapper.OrganizationMapper;
import com.ssm.wssmb.model.Concentrator;
import com.ssm.wssmb.model.MbAmmeter;
import com.ssm.wssmb.model.MbBlueBreaker;
import com.ssm.wssmb.model.MeasureFile;
import com.ssm.wssmb.model.Organization;
import com.ssm.wssmb.service.MbBlueBreakerService;
import com.ssm.wssmb.util.CustomException;
import com.ssm.wssmb.util.EventLogAspect;
import com.ssm.wssmb.util.ExcelBean;
import com.ssm.wssmb.util.ExcelUtil;
import com.ssm.wssmb.util.ResponseResult;

@Service
public class MbBlueBreakerServiceImpl implements MbBlueBreakerService {

	@Autowired
	public MbBlueBreakerMapper mbBlueBreakerMapper;

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
		startindex = startindex - 1;
		List<Integer> queryTotal = mbBlueBreakerMapper.queryTotal(orgId);
		List<MbBlueBreaker> mbBlueBreaker = mbBlueBreakerMapper.selectAll(orgId, startindex, endindex);
		for (MbBlueBreaker mb : mbBlueBreaker) {
			int organizationId = mb.getOrganizationCode();
			Organization selectByPrimaryKey = organizationMapper.selectByPrimaryKey(organizationId);
			if (selectByPrimaryKey != null) {
				mb.setOrganizationName(selectByPrimaryKey.getOrganizationname());
			}
			int measureId = mb.getBoxCode();
			MeasureFile measurefileByMeasureId = measureFileMapper.getMeasurefileByMeasureId(measureId);
			if (measurefileByMeasureId != null) {
				mb.setBoxName(measurefileByMeasureId.getMeasureName());
			}
			int ammeterCode = mb.getAmmeterCode();
			MbAmmeter oneAmmeterByCode = mbAmmeterMapper.getOneAmmeterByCode(ammeterCode);
			if (oneAmmeterByCode != null) {
				mb.setAmmeterName(oneAmmeterByCode.getAmmeterName());
			}
		}
		ResponseResult responseResult = new ResponseResult();
		if (mbBlueBreaker.size() >= 0) {
			responseResult.setCode(200);
			responseResult.setRows(mbBlueBreaker);
			responseResult.setMessage("查询所有断路器成功");
			responseResult.setTotal(queryTotal.size());
		} else {
			responseResult.setCode(400);
			responseResult.setMessage("服务器出错");
		}
		return responseResult;
	}

	@Override
	public ResponseResult addBlueBreaker(MbBlueBreaker mbBlueBreaker) {
		// MD5Util.MD5(Math.random());
		int addBlueBreaker = mbBlueBreakerMapper.addBlueBreaker(mbBlueBreaker);
		ResponseResult responseResult = new ResponseResult();
		if (addBlueBreaker >= 0) {
			responseResult.setCode(200);
			responseResult.setMessage("添加蓝牙路断器成功");
			responseResult.setTotal(addBlueBreaker);
		} else {
			responseResult.setCode(400);
			responseResult.setMessage("服务器出错");
		}
		return responseResult;
	}

	@Override
	public ResponseResult editBlueBreaker(MbBlueBreaker mbBlueBreaker) {
		ResponseResult responseResult = new ResponseResult();
		boolean editAmmeter = mbBlueBreakerMapper.editBlueBreaker(mbBlueBreaker);
		if (editAmmeter) {
			responseResult.setCode(200);
			responseResult.setMessage("修改断路器成功！");
		} else {
			responseResult.setCode(400);
			responseResult.setMessage("修改断路器失败，服务器内部出错！");
		}
		return responseResult;

	}

	@Override
	public ResponseResult deleteBlueBreaker(int id) {
		ResponseResult responseResult = new ResponseResult();
		boolean deleteAieLock = mbBlueBreakerMapper.deleteBlueBreaker(id);
		if (deleteAieLock) {
			responseResult.setCode(200);
			responseResult.setMessage("删除断路器档案成功！");
		} else {
			responseResult.setCode(400);
			responseResult.setMessage("删除断路器档案失败，服务器内部出错！");
		}
		return responseResult;

	}

	/**
	 * 导出断路器信息
	 * 
	 * @param workbook
	 * @param sheetNum
	 * @return
	 * @author Eric
	 * @throws Exception
	 */
	@Override
	public XSSFWorkbook exportBlueBreakerToExcel(int orgId) throws Exception {
		List<MbBlueBreaker> list = mbBlueBreakerMapper.selectAll(orgId, 0, 99999);
		List<MbBlueBreaker> newList = new ArrayList<>();
		for (MbBlueBreaker mb : list) {
			int organizationId = mb.getOrganizationCode();
			Organization selectByPrimaryKey = organizationMapper.selectByPrimaryKey(organizationId);
			if (selectByPrimaryKey != null) {
				mb.setOrganizationName(selectByPrimaryKey.getOrganizationname());
			}
			int boxCode = mb.getBoxCode();
			MeasureFile measurefileByMeasureId = measureFileMapper.getMeasurefileByMeasureId(boxCode);
			if (measurefileByMeasureId != null) {
				mb.setBoxName(measurefileByMeasureId.getMeasureName());
			}
			int ammeterCode = mb.getAmmeterCode();
			MbAmmeter oneAmmeterByCode = mbAmmeterMapper.getOneAmmeterByCode(ammeterCode);
			if (oneAmmeterByCode != null) {
				mb.setAmmeterName(oneAmmeterByCode.getAmmeterName());
			}
			newList.add(mb);
		}
		List<ExcelBean> excel = new ArrayList<>();
		Map<Integer, List<ExcelBean>> map = new LinkedHashMap<>();
		XSSFWorkbook xssfWorkbook = null;
		// 设置标题栏
		excel.add(new ExcelBean("组织机构", "organizationName", 0));
		excel.add(new ExcelBean("所属表箱", "boxName", 0));
		excel.add(new ExcelBean("断路器名称", "breakerName", 0));
		excel.add(new ExcelBean("断路器编号", "breakerCode", 0));
		excel.add(new ExcelBean("生产厂家", "produce", 0));
		excel.add(new ExcelBean("生产日期", "produceTime", 0));
		excel.add(new ExcelBean("创建人", "createPerson", 0));
		excel.add(new ExcelBean("创建时间", "createTime", 0));
		excel.add(new ExcelBean("型号", "breakerType", 0));
		excel.add(new ExcelBean("关联电表", "ammeterName", 0));
		map.put(0, excel);
		String sheetName = "蓝牙断路器信息";
		// 调用ExcelUtil的方法
		xssfWorkbook = ExcelUtil.createExcelFile(MbBlueBreaker.class, newList, map, sheetName);
		return xssfWorkbook;
	}

	@Override
	public List<MbBlueBreaker> readExcelFile(CommonsMultipartFile excelfil) throws Exception {
		int sheetNum = 0;// 第几个工作表
		List<MbBlueBreaker> list = toListFromExcel(excelfil, sheetNum);
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
	public List<MbBlueBreaker> toListFromExcel(CommonsMultipartFile excelfil, int sheetNum) throws Exception {
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
	private List<MbBlueBreaker> toListFromExcel(Workbook workbook, int sheetNum) throws Exception {

		Sheet sheet = workbook.getSheetAt(sheetNum);
		List<MbBlueBreaker> list = new ArrayList<MbBlueBreaker>();

		int minRowIx = sheet.getFirstRowNum();
		int maxRowIx = sheet.getLastRowNum();

		// 导入excel的标题格式
		String[] cfiled = { "组织机构", "所属表箱", "断路器名称", "断路器编号", "生产厂家", "生产日期", "创建人", "创建时间", "型号", "关联电表" };
		String[] colFiled = new String[0];

		int len = 0;
		int count = 0;

		for (int rowIx = minRowIx; rowIx <= maxRowIx; rowIx++) {
			Row row = sheet.getRow(rowIx);
			MbBlueBreaker mbBlueBreaker = new MbBlueBreaker();

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
							&& (cellText.equals("断路器名称") || cellText.equals("断路器编号"))) {
						isEmpty = false;
						throw new CustomException(cellText + "不可空！");
						// continue;
					}

					switch (cellText) {
					case "组织机构":
						if (null != stringValue && !stringValue.equals("")) {
							int codeByName = organizationMapper.getCodeByName(stringValue);
							mbBlueBreaker.setOrganizationCode(codeByName);
						}
						break;
					case "所属表箱":
						if (null != stringValue && !stringValue.equals("")) {
							int codeByName = measureFileMapper.getCodeByName(stringValue);
							mbBlueBreaker.setBoxCode(codeByName);
						}
						break;
					case "断路器名称":
						if (null != stringValue && !stringValue.equals("")) {
							mbBlueBreaker.setBreakerName(stringValue);
						}
						break;
					case "断路器编号":
						if (null != stringValue && !stringValue.equals("")) {
							int parseInt = Integer.parseInt(stringValue);
							mbBlueBreaker.setBreakerCode(parseInt);
						}
						break;
					case "生产厂家":
						if (null != stringValue && !stringValue.equals("")) {
							mbBlueBreaker.setProduce(stringValue);
						}
						break;
					case "生产日期":
						if (null != stringValue && !stringValue.equals("")) {
							mbBlueBreaker.setProduceTime(stringValue);
						}
						break;
					case "创建人":
						if (null != stringValue && !stringValue.equals("")) {
							mbBlueBreaker.setCreatePerson(stringValue);
						}
						break;
					case "创建时间":
						if (null != stringValue && !stringValue.equals("")) {
							mbBlueBreaker.setCreateTime(stringValue);
						}
						break;
					case "型号":
						if (null != stringValue && !stringValue.equals("")) {
							mbBlueBreaker.setBreakerType(stringValue);
						}
						break;
					case "关联电表":
						if (null != stringValue && !stringValue.equals("")) {
							int codeByName = mbAmmeterMapper.getCodeByName(stringValue);
							mbBlueBreaker.setAmmeterCode(codeByName);
						}
						break;

					}
				}
			}
			if (rowIx != 0 && isEmpty) {
				list.add(mbBlueBreaker);
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
	public boolean dealList(List<MbBlueBreaker> list) throws Exception {
		if (null != list && list.size() > 0) {
			String content = "";
			for (int i = 0; i < list.size(); i++) {
				boolean addOneBlueBreaker = mbBlueBreakerMapper.addOneBluebreaker(list.get(i));
				content += "表号：" + list.get(i).getBreakerCode() + "序列号：" + ",";
				if (!addOneBlueBreaker) {
					return false;
				}
			}

			if (content != "")
				content = content.substring(0, content.length() - 1);
			log.addLog("", "导入路断器档案信息", content, 0);
		}
		return true;
	}

	@Override
	public ResponseResult queryBlueBreaker(int orgId, String selectValue, String inputValue, int startindex,
			int endindex) {
		startindex = startindex - 1;
		List<MbBlueBreaker> queryBlueBreaker = new ArrayList<>();
		ResponseResult responseResult = new ResponseResult();
		if (selectValue == "断路器名称" || selectValue.equals("断路器名称")) {
			inputValue = "%" + inputValue + "%";
			List<Integer> queryTotalByBox = mbBlueBreakerMapper.queryTotalByName(orgId, inputValue);
			responseResult.setTotal(queryTotalByBox.size());
			queryBlueBreaker = mbBlueBreakerMapper.queryBlueBreakerByName(orgId, inputValue, startindex, endindex);
			for (MbBlueBreaker mb : queryBlueBreaker) {
				int organizationId = mb.getOrganizationCode();
				Organization selectByPrimaryKey = organizationMapper.selectByPrimaryKey(organizationId);
				if (selectByPrimaryKey != null) {
					mb.setOrganizationName(selectByPrimaryKey.getOrganizationname());
				}
				int measureId = mb.getBoxCode();
				MeasureFile measurefileByMeasureId = measureFileMapper.getMeasurefileByMeasureId(measureId);
				if (measurefileByMeasureId != null) {
					mb.setBoxName(measurefileByMeasureId.getMeasureName());
				}
				int ammeterCode = mb.getAmmeterCode();
				MbAmmeter oneAmmeterByCode = mbAmmeterMapper.getOneAmmeterByCode(ammeterCode);
				if (oneAmmeterByCode != null) {
					mb.setAmmeterName(oneAmmeterByCode.getAmmeterName());
				}
			}
		}
		if (selectValue == "断路器编号" || selectValue.equals("断路器编号")) {
			inputValue = "%" + inputValue + "%";
			List<Integer> queryTotalByLock = mbBlueBreakerMapper.queryTotalByCode(orgId, inputValue);
			responseResult.setTotal(queryTotalByLock.size());
			queryBlueBreaker = mbBlueBreakerMapper.queryBlueBreakerByCode(orgId, inputValue, startindex, endindex);
			for (MbBlueBreaker mb : queryBlueBreaker) {
				int organizationId = mb.getOrganizationCode();
				Organization selectByPrimaryKey = organizationMapper.selectByPrimaryKey(organizationId);
				if (selectByPrimaryKey != null) {
					mb.setOrganizationName(selectByPrimaryKey.getOrganizationname());
				}
				int measureId = mb.getBoxCode();
				MeasureFile measurefileByMeasureId = measureFileMapper.getMeasurefileByMeasureId(measureId);
				if (measurefileByMeasureId != null) {
					mb.setBoxName(measurefileByMeasureId.getMeasureName());
				}
				int ammeterCode = mb.getAmmeterCode();
				MbAmmeter oneAmmeterByCode = mbAmmeterMapper.getOneAmmeterByCode(ammeterCode);
				if (oneAmmeterByCode != null) {
					mb.setAmmeterName(oneAmmeterByCode.getAmmeterName());
				}
			}
		}
		responseResult.setCode(200);
		responseResult.setRows(queryBlueBreaker);
		responseResult.setMessage("查询断路器成功");
		return responseResult;
	}

	@Override
	public List<MbBlueBreaker> queryBlueBreakerByTree(String treeType, int gid) {
		List<MbBlueBreaker> organizationTree = new ArrayList<>();
		if (treeType == "Organization") {
			organizationTree = organizationTree(gid);
		} else if (treeType == "MeasureFile") {
			// 根据表箱查询集中器 ，遍历集中器 ， 根据集中器查询电表， 根据电表关联断路器
			organizationTree = mbBlueBreakerMapper.getBlueBreakerByMeasureId(gid);
			for (MbBlueBreaker mb : organizationTree) {
				int organizationId = mb.getOrganizationCode();
				Organization selectByPrimaryKey = organizationMapper.selectByPrimaryKey(organizationId);
				if (selectByPrimaryKey != null) {
					mb.setOrganizationName(selectByPrimaryKey.getOrganizationname());
				}
				int measureId = mb.getBoxCode();
				MeasureFile measurefileByMeasureId = measureFileMapper.getMeasurefileByMeasureId(measureId);
				if (measurefileByMeasureId != null) {
					mb.setBoxName(measurefileByMeasureId.getMeasureName());
				}
				int ammeterCode = mb.getAmmeterCode();
				MbAmmeter oneAmmeterByCode = mbAmmeterMapper.getOneAmmeterByCode(ammeterCode);
				if (oneAmmeterByCode != null) {
					mb.setAmmeterName(oneAmmeterByCode.getAmmeterName());
				}
			}
		} else if (treeType == "Concentrator") {// 直接在电表里查集中器code=id有哪些
			organizationTree = mbBlueBreakerMapper.getBlueBreakerByConcentratorId(gid);
			for (MbBlueBreaker mb : organizationTree) {
				int organizationId = mb.getOrganizationCode();
				Organization selectByPrimaryKey = organizationMapper.selectByPrimaryKey(organizationId);
				if (selectByPrimaryKey != null) {
					mb.setOrganizationName(selectByPrimaryKey.getOrganizationname());
				}
				int measureId = mb.getBoxCode();
				MeasureFile measurefileByMeasureId = measureFileMapper.getMeasurefileByMeasureId(measureId);
				if (measurefileByMeasureId != null) {
					mb.setBoxName(measurefileByMeasureId.getMeasureName());
				}
				int ammeterCode = mb.getAmmeterCode();
				MbAmmeter oneAmmeterByCode = mbAmmeterMapper.getOneAmmeterByCode(ammeterCode);
				if (oneAmmeterByCode != null) {
					mb.setAmmeterName(oneAmmeterByCode.getAmmeterName());
				}
			}
		} else if (treeType == "Area") {
			List<Concentrator> regionClickTreeList = concentratorMapper.regionClickTreeList(gid);
			for (Concentrator concentrator : regionClickTreeList) {
				Integer concentratorId = concentrator.getConcentratorId();
				List<MbAmmeter> ammeterByConcentratorId = mbAmmeterMapper.getAmmeterByConcentratorId(concentratorId);
				for (MbAmmeter mbAmmeter : ammeterByConcentratorId) {
					Integer mbAmmeterId = mbAmmeter.getId();
					List<MbBlueBreaker> blueBreakerByAmmeterId = mbBlueBreakerMapper
							.getBlueBreakerByAmmeterId(mbAmmeterId);
					for (MbBlueBreaker mb : blueBreakerByAmmeterId) {
						int organizationId = mb.getOrganizationCode();
						Organization selectByPrimaryKey = organizationMapper.selectByPrimaryKey(organizationId);
						if (selectByPrimaryKey != null) {
							mb.setOrganizationName(selectByPrimaryKey.getOrganizationname());
						}
						int measureId = mb.getBoxCode();
						MeasureFile measurefileByMeasureId = measureFileMapper.getMeasurefileByMeasureId(measureId);
						if (measurefileByMeasureId != null) {
							mb.setBoxName(measurefileByMeasureId.getMeasureName());
						}
						int ammeterCode = mb.getAmmeterCode();
						MbAmmeter oneAmmeterByCode = mbAmmeterMapper.getOneAmmeterByCode(ammeterCode);
						if (oneAmmeterByCode != null) {
							mb.setAmmeterName(oneAmmeterByCode.getAmmeterName());
						}
						organizationTree.add(mb);
					}
				}
			}
		}
		return organizationTree;
	}

	// 点击的是组织机构
	public List<MbBlueBreaker> organizationTree(int orgId) {
		List<MbBlueBreaker> newList = new ArrayList<>();
		List<MbBlueBreaker> traverse1 = traverse(orgId);// 最高一级的组织机构，查询直属的所有电表
		for (MbBlueBreaker mb : traverse1) {// 遍历所有电表
			int organizationId = mb.getOrganizationCode();
			Organization selectByPrimaryKey = organizationMapper.selectByPrimaryKey(organizationId);
			if (selectByPrimaryKey != null) {
				mb.setOrganizationName(selectByPrimaryKey.getOrganizationname());
			}
			int measureId = mb.getBoxCode();
			MeasureFile measurefileByMeasureId = measureFileMapper.getMeasurefileByMeasureId(measureId);
			if (measurefileByMeasureId != null) {
				mb.setBoxName(measurefileByMeasureId.getMeasureName());
			}
			int ammeterCode = mb.getAmmeterCode();
			MbAmmeter oneAmmeterByCode = mbAmmeterMapper.getOneAmmeterByCode(ammeterCode);
			if (oneAmmeterByCode != null) {
				mb.setAmmeterName(oneAmmeterByCode.getAmmeterName());
			}
			newList.add(mb);// 加入到返回值里面
		}

		while (organizationMapper.selectListByParentId(orgId) != null) {// 如果有下级组织机构
			List<MbBlueBreaker> traverseOrg = traverseOrg(newList, orgId);
			return traverseOrg;
		}
		;
		return newList;

	}

	// 点击的是组织机构----根据最后一层组织机构id遍历所属的所有电表 traverse()
	public List<MbBlueBreaker> traverse(int orgId) {
		List<MbBlueBreaker> blueBreakerByAmmeterId = new ArrayList<>();
		List<MeasureFile> measurefileByOrganizationId = measureFileMapper.getMeasurefileByOrgId(orgId);
		for (MeasureFile measureFile : measurefileByOrganizationId) {
			int measureId = measureFile.getMeasureId();
			List<Concentrator> concentratorByMeasureId = concentratorMapper.getConcentratorByMeasureId(measureId);
			for (Concentrator concentrator : concentratorByMeasureId) {
				Integer concentratorId = concentrator.getConcentratorId();
				List<MbAmmeter> ammeterByConcentratorId = mbAmmeterMapper.getAmmeterByConcentratorId(concentratorId);
				for (MbAmmeter mbAmmeter : ammeterByConcentratorId) {
					int mbAmmeterId = mbAmmeter.getId();
					List<MbBlueBreaker> blueBreakerByAmmeterId2 = mbBlueBreakerMapper
							.getBlueBreakerByAmmeterId(mbAmmeterId);
					for (MbBlueBreaker mbBlueBreaker : blueBreakerByAmmeterId2) {
						blueBreakerByAmmeterId.add(mbBlueBreaker);
					}
				}
			}
		}
		return blueBreakerByAmmeterId;
	}

	// 点击的是组织机构---- 查询是否有下一级组织机构
	public List<MbBlueBreaker> traverseOrg(List<MbBlueBreaker> newList, int orgId) {
		List<Organization> selectListByParentId = organizationMapper.selectListByParentId(orgId);// 查询最高一级组织机构的下一级所有组织机构
		for (Organization organization : selectListByParentId) {// 遍历下级所有组织机构
			int id = organization.getOrganizationid();// 获取第二级组织机构id
			List<MbBlueBreaker> traverse = traverse(id);// 根据最后一层组织机构id遍历所属的所有电表,在通过断路器的关联点表字段获取断路器//
														// traverse()
			// 给断路器从code改为name
			for (MbBlueBreaker mb : traverse) {
				int organizationId = mb.getOrganizationCode();
				Organization selectByPrimaryKey = organizationMapper.selectByPrimaryKey(organizationId);
				if (selectByPrimaryKey != null) {
					mb.setOrganizationName(selectByPrimaryKey.getOrganizationname());
				}
				int measureId = mb.getBoxCode();
				MeasureFile measurefileByMeasureId = measureFileMapper.getMeasurefileByMeasureId(measureId);
				if (measurefileByMeasureId != null) {
					mb.setBoxName(measurefileByMeasureId.getMeasureName());
				}
				int ammeterCode = mb.getAmmeterCode();
				MbAmmeter oneAmmeterByCode = mbAmmeterMapper.getOneAmmeterByCode(ammeterCode);
				if (oneAmmeterByCode != null) {
					mb.setAmmeterName(oneAmmeterByCode.getAmmeterName());
				}
				newList.add(mb);
			}
			if (organizationMapper.selectListByParentId(id) != null) {
				traverseOrg(newList, id);
			}
		}
		return newList;
	}
	
	//更改蓝牙断路器开关状态
	@Override
    public String changeOpenStatus(Integer openStatus, Integer ammeterId) throws Exception{
    	int result = mbBlueBreakerMapper.changeOpenStatus(openStatus, ammeterId);
    	if (result > 0){
    		return "success";
    	}
    	else{
    		return "error";
    	}
    }
}
