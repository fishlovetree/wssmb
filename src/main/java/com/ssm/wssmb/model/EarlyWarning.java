package com.ssm.wssmb.model;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

public class EarlyWarning {
	private Integer id;

	// 报警类型
	private Integer alarmtype;

	// 发生时间
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") // 前端时间字符串转java时间戳
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8") // 后台时间戳转前端时间字符串(json对象)
	private Date occurtime;

	// 结束时间
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
	private Date endtime;

	// 处理人
	private String handlepeople;

	// 处理时间
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
	private Date processtime;

	// 处理方法
	private String processmethod; 

	private Integer status;

	// 设备地址
	private String equipmentaddress;

	// 表箱安装地址
	private String address;

	// 系统类型
	private Integer systemtype;

	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") // 前端时间字符串转java时间戳
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8") // 后台时间戳转前端时间字符串(json对象)
	private Date insertiontime;

	// 累计次数
	private Integer cumulativenum;

	private Integer endmethod;

	// 事件告警时状态字
	private String currentState;

	private String processremarks;

	private String measureName;

	private String measureNumber;

	private String terminalName;

	private String terminalAddress;

	private String installationLocation;

	private String DETAILNAME;

	private Integer type;

	private String alarmName;
	
	private String equipname;
	
	private Integer equipId;
	
	private String measureAddress;
	
	private String annexname;
	
	private Integer equipType;

	public Integer getEquipType() {
		return equipType;
	}

	public void setEquipType(Integer equipType) {
		this.equipType = equipType;
	}

	public String getAnnexname() {
		return annexname;
	}

	public void setAnnexname(String annexname) {
		this.annexname = annexname;
	}

	public String getMeasureAddress() {
		return measureAddress;
	}

	public void setMeasureAddress(String measureAddress) {
		this.measureAddress = measureAddress;
	}

	public Integer getEquipId() {
		return equipId;
	}

	public void setEquipId(Integer equipId) {
		this.equipId = equipId;
	}

	public String getEquipname() {
		return equipname;
	}

	public void setEquipname(String equipname) {
		this.equipname = equipname;
	}

	public String getAlarmName() {
		return alarmName;
	}

	public void setAlarmName(String alarmName) {
		this.alarmName = alarmName;
	}

	public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
	}

	public String getDETAILNAME() {
		return DETAILNAME;
	}

	public void setDETAILNAME(String dETAILNAME) {
		DETAILNAME = dETAILNAME;
	}

	public String getInstallationLocation() {
		return installationLocation;
	}

	public void setInstallationLocation(String installationLocation) {
		this.installationLocation = installationLocation;
	}

	public String getMeasureName() {
		return measureName;
	}

	public void setMeasureName(String measureName) {
		this.measureName = measureName;
	}

	public String getMeasureNumber() {
		return measureNumber;
	}

	public void setMeasureNumber(String measureNumber) {
		this.measureNumber = measureNumber;
	}

	public String getTerminalName() {
		return terminalName;
	}

	public void setTerminalName(String terminalName) {
		this.terminalName = terminalName;
	}

	public String getTerminalAddress() {
		return terminalAddress;
	}

	public void setTerminalAddress(String terminalAddress) {
		this.terminalAddress = terminalAddress;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getEquipmentaddress() {
		return equipmentaddress;
	}

	public void setEquipmentaddress(String equipmentaddress) {
		this.equipmentaddress = equipmentaddress;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public Integer getSystemtype() {
		return systemtype;
	}

	public void setSystemtype(Integer systemtype) {
		this.systemtype = systemtype;
	}

	public Integer getAlarmtype() {
		return alarmtype;
	}

	public void setAlarmtype(Integer alarmtype) {
		this.alarmtype = alarmtype;
	}

	public Date getOccurtime() {
		return occurtime;
	}

	public void setOccurtime(Date occurtime) {
		this.occurtime = occurtime;
	}

	public Date getEndtime() {
		return endtime;
	}

	public void setEndtime(Date endtime) {
		this.endtime = endtime;
	}

	public Integer getEndmethod() {
		return endmethod;
	}

	public void setEndmethod(Integer endmethod) {
		this.endmethod = endmethod;
	}

	public String getHandlepeople() {
		return handlepeople;
	}

	public void setHandlepeople(String handlepeople) {
		this.handlepeople = handlepeople;
	}

	public Date getProcesstime() {
		return processtime;
	}

	public void setProcesstime(Date processtime) {
		this.processtime = processtime;
	}

	public String getProcessmethod() {
		return processmethod;
	}

	public void setProcessmethod(String processmethod) {
		this.processmethod = processmethod;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public Integer getCumulativenum() {
		return cumulativenum;
	}

	public void setCumulativenum(Integer cumulativenum) {
		this.cumulativenum = cumulativenum;
	}

	public Date getInsertiontime() {
		return insertiontime;
	}

	public void setInsertiontime(Date insertiontime) {
		this.insertiontime = insertiontime;
	}

	public String getProcessremarks() {
		return processremarks;
	}

	public void setProcessremarks(String processremarks) {
		this.processremarks = processremarks;
	}

	public String getCurrentState() {
		return currentState;
	}

	public void setCurrentState(String currentState) {
		this.currentState = currentState;
	}

	@Override
	public String toString() {
		return "EarlyWarning [id=" + id + ", alarmtype=" + alarmtype + ", occurtime=" + occurtime + ", endtime="
				+ endtime + ", handlepeople=" + handlepeople + ", processtime=" + processtime + ", processmethod="
				+ processmethod + ", status=" + status + ", equipmentaddress=" + equipmentaddress + ", address="
				+ address + ", systemtype=" + systemtype + ", insertiontime=" + insertiontime + ", cumulativenum="
				+ cumulativenum + ", endmethod=" + endmethod + ", currentState=" + currentState + ", processremarks="
				+ processremarks + ", measureName=" + measureName + ", measureNumber=" + measureNumber
				+ ", terminalName=" + terminalName + ", terminalAddress=" + terminalAddress + ", installationLocation="
				+ installationLocation + ", DETAILNAME=" + DETAILNAME + ", type=" + type + ", alarmName=" + alarmName
				+ ", equipname=" + equipname + ", equipId=" + equipId + ", measureAddress=" + measureAddress
				+ ", annexname=" + annexname + "]";
	}
	
	

}