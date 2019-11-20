package com.ssm.wssmb.controller;

import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSONObject;
import com.ssm.wssmb.mapper.OrgAndCustomerMapper;
import com.ssm.wssmb.model.Concentrator;
import com.ssm.wssmb.model.MbAmmeter;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.redis.RedisService;
import com.ssm.wssmb.service.ConcentratorService;
import com.ssm.wssmb.service.MbAmmeterService;
import com.ssm.wssmb.service.UntilService;
import com.ssm.wssmb.util.ResponseResult;
import com.ws.Util698.NormalData;
import com.ws.Util698.TimeTag;
import com.ws.apdu698.ActionRequest;
import com.ws.apdu698.ProxyGetRequestTransparentTransmission;
import com.ws.data698.COMDCB;
import com.ws.data698.COMDCB.UnitBaudrate;
import com.ws.data698.COMDCB.UnitDatabits;
import com.ws.data698.COMDCB.UnitFlowcontrol;
import com.ws.data698.COMDCB.UnitParitybit;
import com.ws.data698.COMDCB.UnitStopbit;
import com.ws.data698.Data;
import com.ws.data698.OAD;
import com.ws.data698.OMD;
import com.ws.data698.PIID;
import com.ws.data698.TI;
import com.ws.data698.TI.Unit;
import com.ws.data698.date_time_s;
import com.ws.hdlc698.ClsHDLC;

@RestController
@RequestMapping("/mbAmmeter")
public class MbAmmeterController {

	@Autowired
	MbAmmeterService mbAmmeterService;

	@Autowired
	ConcentratorService concentratorService;

	@Resource
	private UntilService untilService;

	OrgAndCustomerMapper orgAndCustomerMapper;

	@Autowired
	RedisService redisService;

	// 读取配置文件中的websocketip
	@Value("${websocketip}")
	private String websocketip;
	// 读取配置文件中的websocketport
	@Value("${websocketport}")
	private String websocketport;
	// 读取配置文件中的apiKey
	@Value("${apiKey}")
	private String apiKey;

	/**
	 * @Description 型号管理主页面
	 * @return
	 * @Time 2019年8月23日
	 * @Author Eric
	 */
	@RequestMapping(value = "/index")
	@RequiresPermissions("mbAmmeter:index")
	public ModelAndView EquipmentFilePage() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("Ammeter/MbAmmeter");
		mv.addObject("websocketip", websocketip);
		mv.addObject("websocketport", websocketport);
		return mv;
	}

	/**
	 * @Description 综合查询-数据分析-集中器在线率
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time 2019年8月23日
	 * @Author Eric
	 */
	// 所有集中器-获取数据
	@PostMapping("/getAllAmmeter")
	public ResponseResult getAllAmmeter(HttpServletRequest req, int page, int rows) {
		User user = CommonMethod.getUserBySession(req, "user", false);
		return mbAmmeterService.selectAll(user.getOrganizationid(), (page - 1) * rows + 1, rows);
	}

	/**
	 * @Description 综合查询-数据分析-集中器在线率
	 * @param re
	 * @return
	 * @throws ParseException
	 * @throws Exception
	 * @Time 2019年8月23日
	 * @Author Eric
	 */
	// 在线集中器-获取数据
	@PostMapping("/addAmmeter")
	public ResponseResult addAmmeter(HttpServletRequest req, String ammeterName, String ammeterCode,
			String installAddress, int concentratorCode, int organizationCode, String produce, String produceTime,
			String createPerson, String createTime, int boxCode, String ammeterType, String softType, String hardType)
			throws ParseException {
		// 判断电表名称是否存在，存在提示
		boolean nameExisted = mbAmmeterService.nameExisted(ammeterName);
		if (nameExisted) {
			ResponseResult responseResult = new ResponseResult();
			responseResult.setCode(400);
			responseResult.setMessage("电表名称已存在！");
			return responseResult;
		} else {
			User user = CommonMethod.getUserBySession(req, "user", false);
			createPerson = user.getUsername();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			createTime = sdf.format(new Date());
			return mbAmmeterService.addAmmeter(ammeterName, ammeterCode, installAddress, concentratorCode,
					organizationCode, produce, produceTime, createPerson, createTime, boxCode, ammeterType, softType,
					hardType);
		}
	}

	/**
	 * @Description 综合查询-数据分析-集中器在线率
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time 2019年8月23日
	 * @Author Eric
	 */
	// 在线集中器-获取数据
	@PostMapping("/editAmmeter")
	public ResponseResult editAmmeter(MbAmmeter mbAmmeter, HttpServletRequest request) {
		// 判断名称是否存在 需要id
		int id = mbAmmeter.getId();
		String ammeterName = mbAmmeter.getAmmeterName();
		boolean nameExistedAndId = mbAmmeterService.nameExistedAndId(ammeterName, id);
		if (nameExistedAndId) {
			ResponseResult responseResult = new ResponseResult();
			responseResult.setCode(400);
			responseResult.setMessage("电表名称已存在！");
			return responseResult;
		} else {
			return mbAmmeterService.editAmmeter(mbAmmeter);
		}

	}

	/**
	 * @Description 综合查询-数据分析-集中器在线率
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time 2019年8月23日
	 * @Author Eric
	 */
	// 在线集中器-获取数据
	@PostMapping("/deleteAmmeter")
	public ResponseResult deleteAmmeter(int id) {
		return mbAmmeterService.deleteAmmeter(id);
	}

	/**
	 * @Description 导出excel
	 * @param
	 * @return
	 * @throws Exception
	 * @Time 2019年8月23日
	 * @Author Eric
	 */
	@GetMapping("/exportAmmeterToExcel")
	public @ResponseBody void exportAmmeterToExcel(HttpServletRequest req, HttpServletResponse response)
			throws Exception {
		User user = CommonMethod.getUserBySession(req, "user", false);
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
		String nameDate = "电表档案信息" + formatter.format(new Date());// excel名称
		response.reset(); // 清除buffer缓存
		// 指定下载的文件名
		response.setHeader("Content-Disposition",
				"attachment;filename=" + new String(nameDate.getBytes("gbk"), "ISO-8859-1") + ".xlsx");
		response.setContentType("application/vnd.ms-excel;charset=UTF-8");
		response.setHeader("Pragma", "no-cache");
		response.setHeader("Cache-Control", "no-cache");
		response.setDateHeader("Expires", 0);
		XSSFWorkbook workbook = null;
		// 导出Excel对象
		workbook = mbAmmeterService.exportAmmeterToExcel(user.getOrganizationid());
		OutputStream output = null;
		BufferedOutputStream bufferedOutPut = null;
		try {
			output = response.getOutputStream();
			bufferedOutPut = new BufferedOutputStream(output);
			bufferedOutPut.flush();
			workbook.write(bufferedOutPut);
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (output != null) {
				output.close();
				output = null;
			}
			if (bufferedOutPut != null) {
				bufferedOutPut.close();
				bufferedOutPut = null;
			}
		}
		return;// Cannot forward after response has been committed
	}

	/**
	 * @Description 导入excel
	 * @param file
	 * @return
	 * @throws Exception
	 * @Time 2019年8月23日
	 * @Author Eric
	 */
	@PostMapping(value = "/importExcel", produces = "text/html;charset=UTF-8;")
	public @ResponseBody String importExcel(@RequestParam("excelfile") CommonsMultipartFile excelfile)
			throws Exception {
		try {
			List<MbAmmeter> list = mbAmmeterService.readExcelFile(excelfile);
			if (list.size() == 0) {
				return "success";
			}
			boolean flag = mbAmmeterService.dealList(list);
			if (flag == true) {
				return "success";
			} else {
				return "error";
			}
		} catch (Exception e) {
			return "导入失败，电表名称已存在！";
		}

	}

	/**
	 * @Description 综合查询-数据分析-集中器在线率
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time 2019年8月23日
	 * @Author Eric
	 */
	// 所有集中器-获取数据
	@PostMapping("/queryAmmeter")
	public ResponseResult queryAmmeter(HttpServletRequest request, String selectValue, String inputValue, int page,
			int rows) {
		User user = CommonMethod.getUserBySession(request, "user", false);
		return mbAmmeterService.queryAmmeter(user.getOrganizationid(), selectValue, inputValue, (page - 1) * rows + 1,
				rows);
	}

	//
	/**
	 * @Description 综合查询-数据分析-集中器在线率
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time 2019年8月23日
	 * @Author Eric
	 */
	// 所有集中器-获取数据
	@PostMapping("/getConcentratorByMeasurefile")
	public List<Concentrator> getConcentratorByMeasurefile(String measureId) {
		return concentratorService.getConcentratorByMeasurefile(measureId);
	}

	/**
	 * @Description 综合查询-数据分析-集中器在线率
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time 2019年8月23日
	 * @Author Eric
	 */
	// 所有集中器-获取数据
	@PostMapping("/getAmmeterByMeasurefile")
	public List<MbAmmeter> getAmmeterByMeasurefile(String measureId) {
		return mbAmmeterService.getAmmeterByMeasurefile(measureId);
	}

	/**
	 * @Description 综合查询-数据分析-集中器在线率
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time 2019年8月23日
	 * @Author Eric
	 */
	// 所有集中器-获取数据
	@PostMapping("/queryAmmeterByTree")
	public @ResponseBody String queryAmmeterByTree(HttpServletRequest request, int type, int gid, int page, int rows)
			throws Exception {
		User user = CommonMethod.getUserBySession(request, "user", false);
		if (type == 1) {// 公用树点击组织机构
			String treeType = "Organization";
			int orgId = gid;
			List<MbAmmeter> queryAmmeterByTree = mbAmmeterService.queryAmmeterByTree(treeType, orgId);
			return untilService.getDataPager(queryAmmeterByTree, page, rows);
		} else if (type == 3) {// 公用树点击表箱
			String treeType = "MeasureFile";
			int measureId = gid;
			List<MbAmmeter> queryAmmeterByTree = mbAmmeterService.queryAmmeterByTree(treeType, measureId);
			return untilService.getDataPager(queryAmmeterByTree, page, rows);
		} else if (type == 4) {// 公用树点击集中器
			String treeType = "Concentrator";
			int orgId = gid;
			List<MbAmmeter> queryAmmeterByTree = mbAmmeterService.queryAmmeterByTree(treeType, orgId);
			return untilService.getDataPager(queryAmmeterByTree, page, rows);
		} else if (type == 2) {
			String treeType = "Area";
			int orgId = gid;
			List<MbAmmeter> queryAmmeterByTree = mbAmmeterService.queryAmmeterByTree(treeType, orgId);
			return untilService.getDataPager(queryAmmeterByTree, page, rows);
		} else {
			return "";
			// return mbAmmeterService.queryAmmeter(user.getOrganizationid(),
			// "", "", (page - 1) * rows + 1, rows);
		}
	}

	/**
	 * @Description 综合查询-数据分析-集中器在线率
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time 2019年8月29日
	 * @Author Eric
	 */
	// 所有集中器-获取数据
	@PostMapping("/queryAmmeterByAmmeterCode")
	public MbAmmeter queryAmmeterByAmmeterCode(String ammeterCode) {
		return mbAmmeterService.queryAmmeterByAmmeterCode(ammeterCode);
	}

	/**
	 * @Description 拉闸
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time 2019年8月29日
	 * @Author Eric
	 */
	// 所有集中器-获取数据
	@PostMapping("/switchAmmeter")
	public String openSwitch(int id, int funFlag) {
		// 查找电表编号 所属集中器编号
		MbAmmeter ammeterCodeByid = mbAmmeterService.getAmmeterCodeByid(id);
		String sa = ammeterCodeByid.getAmmeterCode();
		if (sa.length() < 12) {
			DecimalFormat g1 = new DecimalFormat("000000000000");
			sa = g1.format(Integer.valueOf(sa));
		}
		String pro_sa = ammeterCodeByid.getConcentrator().getAddress();
		if (pro_sa.length() < 12) {
			DecimalFormat g1 = new DecimalFormat("000000000000");
			pro_sa = g1.format(Integer.valueOf(pro_sa));
		}
		Integer seq = (Integer) redisService.get("seq"); // int seq = 1 从redis取
		if (seq == null) {
			seq = 1;
			redisService.set("seq", 1);
		} else {
			Integer num1 = (Integer) redisService.get("seq") + 1;
			if (num1 > 63) {
				num1 = 1;
			}
			redisService.set("seq", num1);
		}
		Integer pro_seq = (Integer) redisService.get("pro_seq");// int pro_seq =
																// 2;从redis取
		if (pro_seq == null) {
			pro_seq = 1;
			redisService.set("pro_seq", 1);
		} else {
			Integer num2 = (Integer) redisService.get("pro_seq") + 1;
			if (num2 > 63) {
				num2 = 1;
			}
			redisService.set("pro_seq", num2);
		}
		String oi = "8000"; // 远程控制OI
		// int funFlag = 129; // 129-跳闸 130- 合闸
		String proxyAction = "";
		if (funFlag == 129) {
			proxyAction = proxyRelayTrip(funFlag, oi, seq, sa, pro_sa, pro_seq);
		} else if (funFlag == 130) {
			proxyAction = proxyRelayClosing(funFlag, oi, seq, sa, pro_sa, pro_seq);
		}
		// length{“SA”:”泛指集中器地址”，”type”:”数据帧类型”，‘subType’:”子类型”,
		// “seq”:”序号”,”data”:“完整的数据帧”}
		JSONObject json = new JSONObject(true);
		json.put("SA", pro_sa);
		json.put("type", "09");
		json.put("subType", "07");
		json.put("seq", seq);
		json.put("data", proxyAction);
		proxyAction = json.toString();
		String length = Integer.toHexString(proxyAction.length());
		while (length.length() < 4) {
			StringBuffer sb = new StringBuffer();
			StringBuffer append = sb.append("0").append(length);// 左补0
			length = append.toString();
		}
		proxyAction = length + proxyAction;
		System.out.print(proxyAction);
		return proxyAction;
	}

	public String proxyRelayTrip(int funFlag, String oi, int seq, String sa, String pro_sa, int pro_seq) {
		// 先组建远程控制帧，并要带时标和TI
		PIID piid = new PIID(seq, 1); // 高优先级
		OMD omd = new OMD(oi, funFlag);
		// data 数据结构
		/**
		 * 继电器 OAD， 告警延时 unsigned 单位分钟 00 限电时间 long-unsigned 单位分钟 0000 自动合闸 bool
		 */

		/** 组建data 对象 */
		ArrayList<NormalData> listData = new ArrayList<NormalData>();
		NormalData data1 = new NormalData(Data.OAD, 4, "F2050201");
		listData.add(data1);
		NormalData data2 = new NormalData(Data.unsigned, 1, "00");
		listData.add(data2);
		NormalData data3 = new NormalData(Data.long_unsigned, 2, "0000");
		listData.add(data3);
		NormalData data4 = new NormalData(Data.bool, 1, "00");
		listData.add(data4);

		NormalData structData = new NormalData(Data.structure, 4, listData);
		NormalData arrayData = new NormalData(Data.array, 1, structData.toString());

		// 时间标签及TI
		date_time_s dts = new date_time_s();
		TI ti = new TI(Unit.year, 10);
		TimeTag tg = new TimeTag(dts, ti);

		// APDU
		ActionRequest request = new ActionRequest(piid, omd, arrayData);
		request.setTimeTagOption(1);
		request.setTimeTag(tg);

		// Action HDLC
		String apduData = request.toString();
		// String sa = "000000000006"; //表地址，具体根据实际操作的表来取值
		String actionFrame = ClsHDLC.makeFrame(1, 0, 3, 0, "00", 6, sa, "02", apduData);

		// System.out.println(actionFrame);

		/* 组建外层的代理透明转发数据帧 */

		// 组建APDU
		// int pro_seq = 1; //集中器的seq
		PIID pro_piid = new PIID(pro_seq, 1); // 高优先级
		OAD pro_OAD = new OAD("F20B0201"); // 蓝牙通道，属性2 特征1
		COMDCB pro_comdcb = new COMDCB(UnitBaudrate.Threehundred, UnitParitybit.Parity, UnitDatabits.Eight,
				UnitStopbit.One, UnitFlowcontrol.No);

		ProxyGetRequestTransparentTransmission proxy = new ProxyGetRequestTransparentTransmission(pro_piid, pro_OAD,
				pro_comdcb, 120, 120, actionFrame);
		String pro_apdu = proxy.toString();

		// System.out.println(pro_apdu);

		// 组建HDLC
		// String pro_sa = "246163456789"; //集中器地址
		String pro_frame = ClsHDLC.makeFrame(1, 0, 3, 0, "00", 6, pro_sa, "30", pro_apdu);

		// System.out.println(pro_frame);
		return pro_frame;
	}

	// 代理合闸允许
	public String proxyRelayClosing(int funFlag, String oi, int seq, String sa, String pro_sa, int pro_seq) {
		// 先组建远程控制帧，并要带时标和TI
		PIID piid = new PIID(seq, 1); // 高优先级
		OMD omd = new OMD(oi, funFlag);

		// 组建data

		/**
		 * array Struct * 继电器 OAD， 命令 enum{合闸允许（ 0），直接合闸（ ），直接合闸（ 1）}
		 */
		ArrayList<NormalData> listData = new ArrayList<NormalData>();
		NormalData data1 = new NormalData(Data.OAD, 4, "F2050201"); // OAD
		listData.add(data1);
		NormalData data2 = new NormalData(Data.Enum, 1, "01"); // 00 允许合闸
		listData.add(data2);

		NormalData structData = new NormalData(Data.structure, 2, listData);
		NormalData arrayData = new NormalData(Data.array, 1, structData.toString());

		// 时间标签及TI
		date_time_s dts = new date_time_s();
		TI ti = new TI(Unit.year, 10);
		TimeTag tg = new TimeTag(dts, ti);

		// APDU
		ActionRequest request = new ActionRequest(piid, omd, arrayData);
		request.setTimeTagOption(1);
		request.setTimeTag(tg);

		// Action HDLC
		String apduData = request.toString();
		// String sa = "000000000006"; //表地址，具体根据实际操作的表来取值
		String actionFrame = ClsHDLC.makeFrame(1, 0, 3, 0, "00", 6, sa, "02", apduData);

		// System.out.println(actionFrame);

		// 组建 HDLC

		// int pro_seq = 2; //集中器的seq
		PIID pro_piid = new PIID(pro_seq, 1); // 高优先级
		OAD pro_OAD = new OAD("F20B0201"); // 蓝牙通道，属性2 特征1
		COMDCB pro_comdcb = new COMDCB(UnitBaudrate.Threehundred, UnitParitybit.Parity, UnitDatabits.Eight,
				UnitStopbit.One, UnitFlowcontrol.No);

		ProxyGetRequestTransparentTransmission proxy = new ProxyGetRequestTransparentTransmission(pro_piid, pro_OAD,
				pro_comdcb, 120, 120, actionFrame);
		String pro_apdu = proxy.toString();

		// System.out.println(pro_apdu);

		// 组建HDLC
		// String pro_sa = "246163456789"; //集中器地址
		String pro_frame = ClsHDLC.makeFrame(1, 0, 3, 0, "00", 6, pro_sa, "30", pro_apdu);

		// System.out.println(pro_frame);
		return pro_frame;
	}
}
