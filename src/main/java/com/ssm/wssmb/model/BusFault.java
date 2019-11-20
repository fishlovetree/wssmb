package com.ssm.wssmb.model;

import java.io.Serializable;
import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

public class BusFault implements Serializable {

	private static final long serialVersionUID = 1L;

	private Integer id;

	private String measureaddress;

	private String equipmentaddress;

	private Integer systemtype;

	private Integer faulttype;

	// 累计次数
	private Integer cumulativenum;

	// 发生时间
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") // 前端时间字符串转java时间戳
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8") // 后台时间戳转前端时间字符串(json对象)
	private Date occurtime;

	// 结束时间
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
	private Date endtime;

	private String handlepeople;

	// 处理时间
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
	private Date processtime;

	private String processmethod;

	private Integer status;

	private String remarks;

	private String processremarks;

	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") // 前端时间字符串转java时间戳
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8") // 后台时间戳转前端时间字符串(json对象)
	private Date insertionTime;

	private Integer channelNo;

	private Integer endMethod;

	private Integer endPeople;

	private String note;

	private String measureName;

	private String measureAddress;

	private String terminalName;

	private String terminalAddress;

	private String installationLocation;

	private String DETAILNAME;

	private String address;

	private String faultname;

	private String equipmenttypename;

	private String equipname;

	private Integer type;

	private Integer equipId;

	public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
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

	public String getEquipmenttypename() {
		return equipmenttypename;
	}

	public void setEquipmenttypename(String equipmenttypename) {
		this.equipmenttypename = equipmenttypename;
	}

	public String getFaultname() {
		return faultname;
	}

	public void setFaultname(String faultname) {
		this.faultname = faultname;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getMeasureaddress() {
		return measureaddress;
	}

	public void setMeasureaddress(String measureaddress) {
		this.measureaddress = measureaddress;
	}

	public String getEquipmentaddress() {
		return equipmentaddress;
	}

	public void setEquipmentaddress(String equipmentaddress) {
		this.equipmentaddress = equipmentaddress;
	}

	public Integer getSystemtype() {
		return systemtype;
	}

	public void setSystemtype(Integer systemtype) {
		this.systemtype = systemtype;
	}

	public Integer getFaulttype() {
		return faulttype;
	}

	public void setFaulttype(Integer faulttype) {
		this.faulttype = faulttype;
	}

	public Integer getCumulativenum() {
		return cumulativenum;
	}

	public void setCumulativenum(Integer cumulativenum) {
		this.cumulativenum = cumulativenum;
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

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getProcessremarks() {
		return processremarks;
	}

	public void setProcessremarks(String processremarks) {
		this.processremarks = processremarks;
	}

	public Date getInsertionTime() {
		return insertionTime;
	}

	public void setInsertionTime(Date insertionTime) {
		this.insertionTime = insertionTime;
	}

	public Integer getChannelNo() {
		return channelNo;
	}

	public void setChannelNo(Integer channelNo) {
		this.channelNo = channelNo;
	}

	public Integer getEndMethod() {
		return endMethod;
	}

	public void setEndMethod(Integer endMethod) {
		this.endMethod = endMethod;
	}

	public Integer getEndPeople() {
		return endPeople;
	}

	public void setEndPeople(Integer endPeople) {
		this.endPeople = endPeople;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	public String getMeasureName() {
		return measureName;
	}

	public void setMeasureName(String measureName) {
		this.measureName = measureName;
	}

	public String getMeasureAddress() {
		return measureAddress;
	}

	public void setMeasureAddress(String measureAddress) {
		this.measureAddress = measureAddress;
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

	public String getInstallationLocation() {
		return installationLocation;
	}

	public void setInstallationLocation(String installationLocation) {
		this.installationLocation = installationLocation;
	}

	public String getDETAILNAME() {
		return DETAILNAME;
	}

	public void setDETAILNAME(String dETAILNAME) {
		DETAILNAME = dETAILNAME;
	}

}