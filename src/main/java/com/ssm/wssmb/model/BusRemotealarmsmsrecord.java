package com.ssm.wssmb.model;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

public class BusRemotealarmsmsrecord {
	private Integer id;

	private String phone;

	private String content;

	private Integer systemtype;

	private String equipmentaddress;
	
	private String measureAddress;

	private Integer eventid;

	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") // 前端时间字符串转java时间戳
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8") // 后台时间戳转前端时间字符串(json对象)
	private Date happentime;

	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") // 前端时间字符串转java时间戳
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8") // 后台时间戳转前端时间字符串(json对象)
	private Date recordtime;

	private Integer result;

    private String user;
    
    private Integer msgType;
    
    private Integer notifier;
    
    private Integer cumulativeNum;
    
	private String equipmentname;

	private String measurename;
	
	private String address;
	
	private String installationLocation;
	
	private String DETAILNAME;

	public String getDETAILNAME() {
		return DETAILNAME;
	}

	public void setDETAILNAME(String dETAILNAME) {
		DETAILNAME = dETAILNAME;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public Integer getSystemtype() {
		return systemtype;
	}

	public void setSystemtype(Integer systemtype) {
		this.systemtype = systemtype;
	}

	public String getEquipmentaddress() {
		return equipmentaddress;
	}

	public void setEquipmentaddress(String equipmentaddress) {
		this.equipmentaddress = equipmentaddress;
	}

	public String getMeasureAddress() {
		return measureAddress;
	}

	public void setMeasureAddress(String measureAddress) {
		this.measureAddress = measureAddress;
	}

	public Integer getEventid() {
		return eventid;
	}

	public void setEventid(Integer eventid) {
		this.eventid = eventid;
	}

	public Date getHappentime() {
		return happentime;
	}

	public void setHappentime(Date happentime) {
		this.happentime = happentime;
	}

	public Date getRecordtime() {
		return recordtime;
	}

	public void setRecordtime(Date recordtime) {
		this.recordtime = recordtime;
	}

	public Integer getResult() {
		return result;
	}

	public void setResult(Integer result) {
		this.result = result;
	}

	public String getEquipmentname() {
		return equipmentname;
	}

	public void setEquipmentname(String equipmentname) {
		this.equipmentname = equipmentname;
	}

	public String getMeasurename() {
		return measurename;
	}

	public void setMeasurename(String measurename) {
		this.measurename = measurename;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getInstallationLocation() {
		return installationLocation;
	}

	public void setInstallationLocation(String installationLocation) {
		this.installationLocation = installationLocation;
	}

	public String getUser() {
		return user;
	}

	public void setUser(String user) {
		this.user = user;
	}

	public Integer getMsgType() {
		return msgType;
	}

	public void setMsgType(Integer msgType) {
		this.msgType = msgType;
	}

	public Integer getNotifier() {
		return notifier;
	}

	public void setNotifier(Integer notifier) {
		this.notifier = notifier;
	}

	public Integer getCumulativeNum() {
		return cumulativeNum;
	}

	public void setCumulativeNum(Integer cumulativeNum) {
		this.cumulativeNum = cumulativeNum;
	}

	
}