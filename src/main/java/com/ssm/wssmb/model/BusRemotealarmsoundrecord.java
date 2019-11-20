package com.ssm.wssmb.model;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

public class BusRemotealarmsoundrecord {
    private Integer id;

    private String phone;

    private String content;

    private String dailinfo;

    private String measureaddress;

    private Integer systemtype;

    private String equipmentaddress;

    private Integer eventid;

    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")//前端时间字符串转java时间戳
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone = "GMT+8") //后台时间戳转前端时间字符串(json对象) 
    private Date happentime;

    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")//前端时间字符串转java时间戳
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone = "GMT+8") //后台时间戳转前端时间字符串(json对象) 
    private Date recordtime;

    private Integer result;
    
    private String user;
    
    private String equipmentname;
    
    private String measureName;
    
    private String installationLocation;
    
    private String address;
    
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

	public String getDailinfo() {
		return dailinfo;
	}

	public void setDailinfo(String dailinfo) {
		this.dailinfo = dailinfo;
	}

	public String getMeasureaddress() {
		return measureaddress;
	}

	public void setMeasureaddress(String measureaddress) {
		this.measureaddress = measureaddress;
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

	public String getUser() {
		return user;
	}

	public void setUser(String user) {
		this.user = user;
	}

	public String getEquipmentname() {
		return equipmentname;
	}

	public void setEquipmentname(String equipmentname) {
		this.equipmentname = equipmentname;
	}

	public String getMeasureName() {
		return measureName;
	}

	public void setMeasureName(String measureName) {
		this.measureName = measureName;
	}

	public String getInstallationLocation() {
		return installationLocation;
	}

	public void setInstallationLocation(String installationLocation) {
		this.installationLocation = installationLocation;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

   
    
}