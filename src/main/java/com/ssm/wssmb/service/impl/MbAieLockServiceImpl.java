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

import com.ssm.wssmb.mapper.MbAieLockMapper;
import com.ssm.wssmb.mapper.MeasureFileMapper;
import com.ssm.wssmb.mapper.OrganizationMapper;
import com.ssm.wssmb.model.MbAieLock;
import com.ssm.wssmb.model.MeasureFile;
import com.ssm.wssmb.model.Organization;
import com.ssm.wssmb.service.MbAieLockService;
import com.ssm.wssmb.util.CustomException;
import com.ssm.wssmb.util.EventLogAspect;
import com.ssm.wssmb.util.ExcelBean;
import com.ssm.wssmb.util.ExcelUtil;
import com.ssm.wssmb.util.ResponseResult;

@Service
public class MbAieLockServiceImpl implements MbAieLockService {

	@Autowired
	public MbAieLockMapper mbAieLockMapper;

	@Autowired
	public OrganizationMapper organizationMapper;

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
		List<Integer> queryTotal = mbAieLockMapper.queryTotal(orgId);
		List<MbAieLock> mbAieLock = mbAieLockMapper.selectAll(orgId, startindex, endindex);
		for (MbAieLock ma : mbAieLock) {
			int organizationId = ma.getOrganizationCode();
			Organization selectByPrimaryKey = organizationMapper.selectByPrimaryKey(organizationId);
			if (selectByPrimaryKey != null) {
				ma.setOrganizationName(selectByPrimaryKey.getOrganizationname());
			}
			int measureId = ma.getBoxCode();
			MeasureFile measurefileByMeasureId = measureFileMapper.getMeasurefileByMeasureId(measureId);
			if (measurefileByMeasureId != null) {
				ma.setBoxName(measurefileByMeasureId.getMeasureName());
			}
		}
		ResponseResult responseResult = new ResponseResult();
		if (mbAieLock.size() >= 0) {
			responseResult.setCode(200);
			responseResult.setRows(mbAieLock);
			responseResult.setMessage("查询所有智能e锁成功");
			responseResult.setTotal(queryTotal.size());
		} else {
			responseResult.setCode(400);
			responseResult.setMessage("服务器出错");
		}
		return responseResult;
	}

	@Override
	public ResponseResult addAieLock(MbAieLock mbAieLock) {
		// MD5Util.MD5(Math.random());
		ResponseResult responseResult = new ResponseResult();
		String macStr = mbAieLock.getMac();
		MbAieLock lockByMac = mbAieLockMapper.getLockByMac(macStr);
		if (lockByMac != null) {
			responseResult.setCode(200);
			responseResult.setMessage("mac地址已存在！");
		} else {
			String lockName = mbAieLock.getLockName();
			MbAieLock lockByName = mbAieLockMapper.getLockByName(lockName);
			if (lockByName != null) {
				responseResult.setCode(200);
				responseResult.setMessage("锁名称已存在！");
			} else {
				int addAieLock = mbAieLockMapper.addAieLock(mbAieLock);
				if (addAieLock >= 0) {
					responseResult.setCode(200);
					responseResult.setMessage("添加智能E锁成功");
					responseResult.setTotal(addAieLock);
				} else {
					responseResult.setCode(400);
					responseResult.setMessage("服务器出错");
				}
			}
		}
		return responseResult;
	}

	@Override
	public ResponseResult editAieLock(MbAieLock mbAieLock) {
		ResponseResult responseResult = new ResponseResult();
		int id = mbAieLock.getId();
		MbAieLock lockByMac = mbAieLockMapper.getLockByMac(mbAieLock.getMac());
		if (lockByMac != null && id != lockByMac.getId()) {
			responseResult.setCode(200);
			responseResult.setMessage("mac地址已存在!");
		} else {
			String lockName = mbAieLock.getLockName();
			MbAieLock lockByNameAndId = mbAieLockMapper.getLockByNameAndId(lockName, id);
			if (lockByNameAndId != null) {
				responseResult.setCode(200);
				responseResult.setMessage("锁名称已存在!");
			} else {
				boolean editAmmeter = mbAieLockMapper.editAieLock(mbAieLock);
				if (editAmmeter) {
					responseResult.setCode(200);
					responseResult.setMessage("修改智能e锁成功！");
				} else {
					responseResult.setCode(400);
					responseResult.setMessage("修改智能e锁失败，服务器内部出错！");
				}
			}
		}
		return responseResult;

	}

	@Override
	public ResponseResult deleteAieLock(int id) {
		ResponseResult responseResult = new ResponseResult();
		boolean deleteAieLock = mbAieLockMapper.deleteAieLock(id);
		if (deleteAieLock) {
			responseResult.setCode(200);
			responseResult.setMessage("删除电表档案成功！");
		} else {
			responseResult.setCode(400);
			responseResult.setMessage("删除电表档案失败，服务器内部出错！");
		}
		return responseResult;

	}

	/**
	 * 导出智能e表信息
	 * 
	 * @param workbook
	 * @param sheetNum
	 * @return
	 * @author Eric
	 * @throws Exception
	 */
	@Override
	public XSSFWorkbook exportAieLockToExcel(int orgId) throws Exception {
		List<MbAieLock> list = mbAieLockMapper.selectAll(orgId, 0, 99999);
		List<MbAieLock> newList = new ArrayList<>();
		for (MbAieLock ma : list) {
			int organizationId = ma.getOrganizationCode();
			Organization selectByPrimaryKey = organizationMapper.selectByPrimaryKey(organizationId);
			if (selectByPrimaryKey != null) {
				ma.setOrganizationName(selectByPrimaryKey.getOrganizationname());
			}
			int measureId = ma.getBoxCode();
			MeasureFile measurefileByMeasureId = measureFileMapper.getMeasurefileByMeasureId(measureId);
			if (measurefileByMeasureId != null) {
				ma.setBoxName(measurefileByMeasureId.getMeasureName());
			}
			newList.add(ma);
		}
		List<ExcelBean> excel = new ArrayList<>();
		Map<Integer, List<ExcelBean>> map = new LinkedHashMap<>();
		XSSFWorkbook xssfWorkbook = null;
		// 设置标题栏
		excel.add(new ExcelBean("锁名称", "lockName", 0));
		excel.add(new ExcelBean("所属表箱", "boxName", 0));
		excel.add(new ExcelBean("锁编号", "lockCode", 0));
		excel.add(new ExcelBean("组织机构", "organizationName", 0));
		excel.add(new ExcelBean("生产厂家", "produce", 0));
		excel.add(new ExcelBean("生产日期", "produceTime", 0));
		excel.add(new ExcelBean("创建人", "createPerson", 0));
		excel.add(new ExcelBean("创建时间", "createTime", 0));
		excel.add(new ExcelBean("型号", "lockType", 0));
		excel.add(new ExcelBean("apikey", "apikey", 0));
		excel.add(new ExcelBean("IMEI", "imei", 0));
		excel.add(new ExcelBean("IMSI", "imsi", 0));
		excel.add(new ExcelBean("序列号", "serialnumber", 0));
		excel.add(new ExcelBean("密码", "password", 0));
		excel.add(new ExcelBean("mac", "mac", 0));
		map.put(0, excel);
		String sheetName = "智能e表信息";
		// 调用ExcelUtil的方法
		xssfWorkbook = ExcelUtil.createExcelFile(MbAieLock.class, list, map, sheetName);
		return xssfWorkbook;
	}

	@Override
	public List<MbAieLock> readExcelFile(CommonsMultipartFile excelfil) throws Exception {
		int sheetNum = 0;// 第几个工作表
		List<MbAieLock> list = toListFromExcel(excelfil, sheetNum);
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
	public List<MbAieLock> toListFromExcel(CommonsMultipartFile excelfil, int sheetNum) throws Exception {
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
	private List<MbAieLock> toListFromExcel(Workbook workbook, int sheetNum) throws Exception {

		Sheet sheet = workbook.getSheetAt(sheetNum);
		List<MbAieLock> list = new ArrayList<MbAieLock>();

		int minRowIx = sheet.getFirstRowNum();
		int maxRowIx = sheet.getLastRowNum();

		// 导入excel的标题格式
		String[] cfiled = { "锁名称", "所属表箱", "锁编号", "组织机构", "生产厂家", "生产日期", "创建人", "创建时间", "型号", "apikey", "IMEI", "IMSI",
				"序列号", "密码", "mac" };
		String[] colFiled = new String[0];

		int len = 0;
		int count = 0;

		for (int rowIx = minRowIx; rowIx <= maxRowIx; rowIx++) {
			Row row = sheet.getRow(rowIx);
			MbAieLock mbAieLock = new MbAieLock();
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
							&& (cellText.equals("锁编号") || cellText.equals("所属表箱"))) {
						isEmpty = false;
						throw new CustomException(cellText + "不可空！");
						// continue;
					}

					switch (cellText) {
					case "锁名称":
						if (null != stringValue && !stringValue.equals("")) {
							MbAieLock lockByName = mbAieLockMapper.getLockByName(stringValue);
							if (lockByName != null) {
								throw new Exception("锁名称已存在！");
							}
							mbAieLock.setLockName(stringValue);
						}
						break;
					case "所属表箱":
						if (null != stringValue && !stringValue.equals("")) {
							int codeByName = measureFileMapper.getCodeByName(stringValue);
							mbAieLock.setBoxCode(codeByName);
						}
						break;
					case "锁编号":
						if (null != stringValue && !stringValue.equals("")) {
							mbAieLock.setLockCode(stringValue);
						}
						break;
					case "组织机构":
						if (null != stringValue && !stringValue.equals("")) {
							int codeByName = organizationMapper.getCodeByName(stringValue);
							mbAieLock.setOrganizationCode(codeByName);
						}
						break;
					case "生产厂家":
						if (null != stringValue && !stringValue.equals("")) {
							mbAieLock.setProduce(stringValue);
						}
						break;
					case "生产日期":
						if (null != stringValue && !stringValue.equals("")) {
							mbAieLock.setProduceTime(stringValue);
						}
						break;
					case "创建人":
						if (null != stringValue && !stringValue.equals("")) {
							mbAieLock.setCreatePerson(stringValue);
						}
						break;
					case "创建时间":
						if (null != stringValue && !stringValue.equals("")) {
							mbAieLock.setCreateTime(stringValue);
						}
						break;
					case "型号":
						if (null != stringValue && !stringValue.equals("")) {
							mbAieLock.setLockType(stringValue);
						}
						break;
					case "apikey":
						if (null != stringValue && !stringValue.equals("")) {
							mbAieLock.setApikey(stringValue);
						}
						break;
					case "IMEI":
						if (null != stringValue && !stringValue.equals("")) {
							mbAieLock.setImei(stringValue);
						}
						break;
					case "IMSI":
						if (null != stringValue && !stringValue.equals("")) {
							mbAieLock.setImsi(stringValue);
						}
						break;
					case "序列号":
						if (null != stringValue && !stringValue.equals("")) {
							mbAieLock.setSerialnumber(stringValue);
						}
						break;
					case "密码":
						if (null != stringValue && !stringValue.equals("")) {
							mbAieLock.setPassword(stringValue);
						}
						break;
					case "mac":
						if (null != stringValue && !stringValue.equals("")) {
							MbAieLock lockByMac = mbAieLockMapper.getLockByMac(stringValue);
							if (lockByMac != null) {
								throw new Exception("mac地址已存在！");
							}
							mbAieLock.setMac(stringValue);
						}
						break;
					}
				}
			}
			if (rowIx != 0 && isEmpty) {
				list.add(mbAieLock);
			}
		}
		return list;
	}

	/**
	 * 导入信息
	 * 
	 * @param workbook
	 * @param sheetNum
	 * @return
	 * @author Eric
	 * @throws Exception
	 * @throws IOException
	 */
	@Override
	public boolean dealList(List<MbAieLock> list) throws Exception {
		if (null != list && list.size() > 0) {
			String content = "";
			for (int i = 0; i < list.size(); i++) {
				boolean addOneAmmeter = mbAieLockMapper.addOneAieLock(list.get(i));
				content += "表号：" + list.get(i).getLockCode() + "序列号：" + ",";
				if (!addOneAmmeter) {
					return false;
				}
			}

			if (content != "")
				content = content.substring(0, content.length() - 1);
			log.addLog("", "导入电表档案信息", content, 0);
		}
		return true;
	}

	@Override
	public ResponseResult queryAieLock(int orgId, String selectValue, String inputValue, int startindex, int endindex) {
		startindex = startindex - 1;
		List<MbAieLock> queryAieLock = new ArrayList<>();
		ResponseResult responseResult = new ResponseResult();
		if (selectValue == "所属表箱" || selectValue.equals("所属表箱")) {
			inputValue = "%" + inputValue + "%";
			List<Integer> queryTotalByBox = mbAieLockMapper.queryTotalByBox(orgId, inputValue);

			responseResult.setTotal(queryTotalByBox.size());
			queryAieLock = mbAieLockMapper.queryAieLockByBoxCode(orgId, inputValue, startindex, endindex);
			for (MbAieLock ma : queryAieLock) {
				int organizationId = ma.getOrganizationCode();
				Organization selectByPrimaryKey = organizationMapper.selectByPrimaryKey(organizationId);
				if (selectByPrimaryKey != null) {
					ma.setOrganizationName(selectByPrimaryKey.getOrganizationname());
				}
				int measureId = ma.getBoxCode();
				MeasureFile measurefileByMeasureId = measureFileMapper.getMeasurefileByMeasureId(measureId);
				if (measurefileByMeasureId != null) {
					ma.setBoxName(measurefileByMeasureId.getMeasureName());
				}
			}
		}
		if (selectValue == "锁编号" || selectValue.equals("锁编号")) {
			inputValue = "%" + inputValue + "%";
			List<Integer> queryTotalByLock = mbAieLockMapper.queryTotalByLock(orgId, inputValue);
			responseResult.setTotal(queryTotalByLock.size());
			queryAieLock = mbAieLockMapper.queryAieLockByLockCode(orgId, inputValue, startindex, endindex);
			for (MbAieLock ma : queryAieLock) {
				int organizationId = ma.getOrganizationCode();
				Organization selectByPrimaryKey = organizationMapper.selectByPrimaryKey(organizationId);
				if (selectByPrimaryKey != null) {
					ma.setOrganizationName(selectByPrimaryKey.getOrganizationname());
				}
				int measureId = ma.getBoxCode();
				MeasureFile measurefileByMeasureId = measureFileMapper.getMeasurefileByMeasureId(measureId);
				if (measurefileByMeasureId != null) {
					ma.setBoxName(measurefileByMeasureId.getMeasureName());
				}
			}
		}
		responseResult.setCode(200);
		responseResult.setRows(queryAieLock);
		responseResult.setMessage("查询智能e锁成功");
		return responseResult;
	}

	@Override
	public List<MbAieLock> queryAieLockByTree(String treeType, int gid) {
		List<MbAieLock> organizationTree = new ArrayList<>();
		if (treeType == "Organization") {
			organizationTree = organizationTree(gid);
		} else if (treeType == "MeasureFile") {// gid为表箱id
			// 根据表箱查询e
			organizationTree = mbAieLockMapper.getAieLockByBoxCode(gid);
			for (MbAieLock ma : organizationTree) {
				int organizationId = ma.getOrganizationCode();
				Organization selectByPrimaryKey = organizationMapper.selectByPrimaryKey(organizationId);
				if (selectByPrimaryKey != null) {
					ma.setOrganizationName(selectByPrimaryKey.getOrganizationname());
				}
				int measureId = ma.getBoxCode();
				MeasureFile measurefileByMeasureId = measureFileMapper.getMeasurefileByMeasureId(measureId);
				if (measurefileByMeasureId != null) {
					ma.setBoxName(measurefileByMeasureId.getMeasureName());
				}
			}
		} else if (treeType == "Area") {
			List<MeasureFile> regionClickTreeList = measureFileMapper.regionClickTreeList(gid);
			for (MeasureFile measureFile : regionClickTreeList) {
				int measureId = measureFile.getMeasureId();
				List<MbAieLock> aieLockByBoxCode = mbAieLockMapper.getAieLockByBoxCode(measureId);
				for (MbAieLock ma : aieLockByBoxCode) {
					int organizationId = ma.getOrganizationCode();
					Organization selectByPrimaryKey = organizationMapper.selectByPrimaryKey(organizationId);
					if (selectByPrimaryKey != null) {
						ma.setOrganizationName(selectByPrimaryKey.getOrganizationname());
					}
					int measureId2 = ma.getBoxCode();
					MeasureFile measurefileByMeasureId = measureFileMapper.getMeasurefileByMeasureId(measureId2);
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
	public List<MbAieLock> organizationTree(int orgId) {
		List<MbAieLock> newList = new ArrayList<>();
		List<MbAieLock> traverse1 = traverse(orgId);// 最高一级的组织机构，查询直属的所有表箱
													// 再查询表箱的e锁
		for (MbAieLock ma : traverse1) {// 遍历所有e
			int organizationId = ma.getOrganizationCode();
			Organization selectByPrimaryKey = organizationMapper.selectByPrimaryKey(organizationId);
			if (selectByPrimaryKey != null) {
				ma.setOrganizationName(selectByPrimaryKey.getOrganizationname());
			}
			int measureId = ma.getBoxCode();
			MeasureFile measurefileByMeasureId = measureFileMapper.getMeasurefileByMeasureId(measureId);
			if (measurefileByMeasureId != null) {
				ma.setBoxName(measurefileByMeasureId.getMeasureName());
			}
			newList.add(ma);// 加入到返回值里面
		}

		while (organizationMapper.selectListByParentId(orgId) != null) {// 如果有下级组织机构
			List<MbAieLock> traverseOrg = traverseOrg(newList, orgId);
			return traverseOrg;
		}
		return newList;

	}

	// 点击的是组织机构---- 查询是否有下一级组织机构
	public List<MbAieLock> traverseOrg(List<MbAieLock> newList, int orgId) {
		List<Organization> selectListByParentId = organizationMapper.selectListByParentId(orgId);// 查询最高一级组织机构的下一级所有组织机构
		for (Organization organization : selectListByParentId) {// 遍历下级所有组织机构
			int id = organization.getOrganizationid();// 获取第二级组织机构id
			List<MbAieLock> traverse = traverse(id);// 根据最后一层组织机构id遍历所属的所有电表
													// traverse()
			for (MbAieLock ma : traverse) {
				int organizationId = ma.getOrganizationCode();
				Organization selectByPrimaryKey = organizationMapper.selectByPrimaryKey(organizationId);
				if (selectByPrimaryKey != null) {
					ma.setOrganizationName(selectByPrimaryKey.getOrganizationname());
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

	// 点击的是组织机构----根据最后一层组织机构id遍历所属的所有e锁 traverse()
	public List<MbAieLock> traverse(int orgId) {
		List<MbAieLock> aieLockByBoxCode = new ArrayList<>();
		List<MeasureFile> measurefileByOrganizationId = measureFileMapper.getMeasurefileByOrgId(orgId);
		for (MeasureFile measureFile : measurefileByOrganizationId) {
			int measureId = measureFile.getMeasureId();
			aieLockByBoxCode = mbAieLockMapper.getAieLockByBoxCode(measureId);

		}
		return aieLockByBoxCode;
	}

	@Override
	public MbAieLock getLockByMac(String mac) {
		MbAieLock lockByMac = mbAieLockMapper.getLockByMac(mac);
		int measureId = lockByMac.getBoxCode();
		MeasureFile measurefileByMeasureId = measureFileMapper.getMeasurefileByMeasureId(measureId);
		lockByMac.setMeasureFile(measurefileByMeasureId);
		return lockByMac;
	}

	// @Override
	// public String oneNetCreateDevice(String apiKey, MbAieLock mbAieLock)
	// throws Exception {
	// CreateDeviceOpe deviceOpe = new CreateDeviceOpe(apiKey);
	// Device device = new Device(mbAieLock.getLockCode(), mbAieLock.getImei(),
	// mbAieLock.getImsi());
	// // 设备私密性赋值
	// device.setIsprivate(mbAieLock.isIsprivate());
	// // 是否订阅资源
	// device.setObsv(mbAieLock.isObsv());
	// // 坐标赋值"location": {"lon": 106, "lat": 29, "ele": 370}, //设备位置{"纬度",
	// // "精度", "高度"}（可选）
	//// String coordinate = equipemntfile.getCoordinate();
	//// JSONObject location = new JSONObject();
	//// if (null != coordinate && coordinate != "") {
	//// location = GetLocation(coordinate);
	//// device.setLocation(location);
	//// }
	// // System.out.println(device.toJsonObject().toString());
	// JSONObject jsonobject = deviceOpe.operation(device,
	// device.toJsonObject());
	// String errno = jsonobject.get("errno").toString();
	// if (errno.equals("0")) {
	// String data = jsonobject.get("data").toString();
	// org.json.JSONObject obj = new org.json.JSONObject(data);
	// String devid = obj.get("device_id").toString();
	// String psk = obj.get("psk").toString();
	// // BusEquipmentfile equipmentfile =
	// // equipmentfileMapper.validateName(null,
	// // equipemntfile.getEquipmentname());
	// BusEquipmentfile equipmentfile = equipmentfileMapper.selectUniqueEq(null,
	// equipemntfile.getEquipmentaddress());
	// /*
	// * equipmentfile.setOnenetdeviceid(devid);
	// * equipmentfile.setPsk(psk);
	// */
	// equipmentfile.setDownstatus((short) 1);// 状态改为已下发
	// int result = equipmentfileMapper.updateByPrimaryKey(equipmentfile);
	// if (result == 1) {
	// // 修改NB设备明细
	// BusEquipmentdetail detail =
	// equipmentdetailmapper.selectByEquipmentid(equipmentfile.getEquipmentid());
	// detail.setEquipmentid(equipmentfile.getEquipmentid());
	// detail.setOnenetdeviceid(devid);
	// detail.setPsk(psk);
	// detail.setApikey(apiKey);
	// equipmentdetailmapper.updateByPrimaryKey(detail);
	// // 记录操作日志
	// String content = "设备ID：" + equipmentfile.getEquipmentid() + ", 设备名称：" +
	// equipmentfile.getEquipmentname()
	// + ", 设备地址：" + equipmentfile.getEquipmentaddress() + ", IMEI：" +
	// equipmentfile.getImei()
	// + ", IMSI：" + equipmentfile.getImsi();
	// log.addLog("", "创建设备到OneNet平台", content, 5);
	// }
	// }
	// return jsonobject.toString();
	// }

	// 更改e锁开关状态
	@Override
	public String changeOpenStatus(Integer openStatus, Integer id) throws Exception {
		int result = mbAieLockMapper.changeOpenStatus(openStatus, id);
		if (result > 0) {
			return "success";
		} else {
			return "error";
		}
	}
}
