package com.ssm.wssmb.model;

import java.io.Serializable;
import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

public class BusMessagepushrecord implements Serializable {

	private static final long serialVersionUID = 1L;

	private Integer id;

	private String measureaddress;

	private String equipmentaddress;

	private Integer systemtype;

	private Integer msgtypecode;

	private Integer cumulativenum;

	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") // 前端时间字符串转java时间戳
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8") // 后台时间戳转前端时间字符串(json对象)
	private Date occurtime;

	private String lowervalue;

	private Short delaytime;

	private String befupdatenum;

	private String aftupdatenum;

	private Date inserttime;

	private String terminalname;

	private String DETAILNAME;

	private String address;
	
	private String measurename;
	
	private String installationLocation;
	
	

	public String getTerminalname() {
		return terminalname;
	}

	public void setTerminalname(String terminalname) {
		this.terminalname = terminalname;
	}

	public String getDETAILNAME() {
		return DETAILNAME;
	}

	public void setDETAILNAME(String dETAILNAME) {
		DETAILNAME = dETAILNAME;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getMeasurename() {
		return measurename;
	}

	public void setMeasurename(String measurename) {
		this.measurename = measurename;
	}

	public String getInstallationLocation() {
		return installationLocation;
	}

	public void setInstallationLocation(String installationLocation) {
		this.installationLocation = installationLocation;
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

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getEquipmentaddress() {
		return equipmentaddress;
	}

	public void setEquipmentaddress(String equipmentaddress) {
		this.equipmentaddress = equipmentaddress == null ? null : equipmentaddress.trim();
	}

	public Integer getSystemtype() {
		return systemtype;
	}

	public void setSystemtype(Integer systemtype) {
		this.systemtype = systemtype;
	}

	public Integer getMsgtypecode() {
		return msgtypecode;
	}

	public void setMsgtypecode(Integer msgtypecode) {
		this.msgtypecode = msgtypecode;
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

	public String getLowervalue() {
		return lowervalue;
	}

	public void setLowervalue(String lowervalue) {
		this.lowervalue = lowervalue == null ? null : lowervalue.trim();
	}

	public Short getDelaytime() {
		return delaytime;
	}

	public void setDelaytime(Short delaytime) {
		this.delaytime = delaytime;
	}

	public String getBefupdatenum() {
		return befupdatenum;
	}

	public void setBefupdatenum(String befupdatenum) {
		this.befupdatenum = befupdatenum == null ? null : befupdatenum.trim();
	}

	public String getAftupdatenum() {
		return aftupdatenum;
	}

	public void setAftupdatenum(String aftupdatenum) {
		this.aftupdatenum = aftupdatenum == null ? null : aftupdatenum.trim();
	}

	public Date getInserttime() {
		return inserttime;
	}

	public void setInserttime(Date inserttime) {
		this.inserttime = inserttime;
	}

	private String messagename;

	private String customercode;

	private String systemtypename;

	private String systemaddress;

	private String equipmenttype;

	private String equipmentname;

	private String buildingname;

	private String buildingid;
	private String coordinate;
	private String customerid;
	private String customername;
	private String installationsite;

	public String getCustomercode() {
		return customercode;
	}

	public String getMessagename() {
		return messagename;
	}

	public void setMessagename(String messagename) {
		this.messagename = messagename;
	}

	public void setCustomercode(String customercode) {
		this.customercode = customercode;
	}

	public String getSystemtypename() {
		return systemtypename;
	}

	public void setSystemtypename(String systemtypename) {
		this.systemtypename = systemtypename;
	}

	public String getSystemaddress() {
		return systemaddress;
	}

	public void setSystemaddress(String systemaddress) {
		this.systemaddress = systemaddress;
	}

	public String getEquipmenttype() {
		return equipmenttype;
	}

	public void setEquipmenttype(String equipmenttype) {
		this.equipmenttype = equipmenttype;
	}

	public String getEquipmentname() {
		return equipmentname;
	}

	public void setEquipmentname(String equipmentname) {
		this.equipmentname = equipmentname;
	}

	public String getBuildingname() {
		return buildingname;
	}

	public void setBuildingname(String buildingname) {
		this.buildingname = buildingname;
	}

	public String getBuildingid() {
		return buildingid;
	}

	public void setBuildingid(String buildingid) {
		this.buildingid = buildingid;
	}

	public String getCoordinate() {
		return coordinate;
	}

	public void setCoordinate(String coordinate) {
		this.coordinate = coordinate;
	}

	public String getCustomerid() {
		return customerid;
	}

	public void setCustomerid(String customerid) {
		this.customerid = customerid;
	}

	public String getCustomername() {
		return customername;
	}

	public void setCustomername(String customername) {
		this.customername = customername;
	}

	public String getInstallationsite() {
		return installationsite;
	}

	public void setInstallationsite(String installationsite) {
		this.installationsite = installationsite;
	}
}
