package com.ssm.wssmb.model;

import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

public class MeasureFile {

	private int MeasureId;

	private String MeasureName;

	private String MeasureNumber;

	private String Address;

	private String longitude;

	private String latitude;

	private Integer OrganizationId;

	private String Manufacturer;

	private int alarmType;
	
	private int openStatus;

	private List<MbAmmeter> mbAmmeterList;

	private List<Terminal> terminals;

	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") // 前端时间字符串转java时间戳
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8") // 后台时间戳转前端时间字符串(json对象)
	private Date ProduceDate;

	private String Creater;

	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") // 前端时间字符串转java时间戳
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8") // 后台时间戳转前端时间字符串(json对象)
	private Date CreateDate;

	private Organization organization;

	private String organizationname;

	private sysarea area;

	private Integer Region;

	private String Name;

	public String getLongitude() {
		return longitude;
	}

	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}

	public String getLatitude() {
		return latitude;
	}

	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}

	public String getName() {
		return Name;
	}

	public void setName(String name) {
		Name = name;
	}

	public sysarea getArea() {
		return area;
	}

	public void setArea(sysarea area) {
		this.area = area;
	}

	public Integer getRegion() {
		return Region;
	}

	public void setRegion(Integer region) {
		Region = region;
	}

	public String getOrganizationname() {
		return organizationname;
	}

	public void setOrganizationname(String organizationname) {
		this.organizationname = organizationname;
	}

	public Organization getOrganization() {
		return organization;
	}

	public void setOrganization(Organization organization) {
		this.organization = organization;
	}

	public int getMeasureId() {
		return MeasureId;
	}

	public void setMeasureId(int measureId) {
		MeasureId = measureId;
	}

	public String getMeasureName() {
		return MeasureName;
	}

	public void setMeasureName(String measureName) {
		MeasureName = measureName;
	}

	public String getMeasureNumber() {
		return MeasureNumber;
	}

	public void setMeasureNumber(String measureNumber) {
		MeasureNumber = measureNumber;
	}

	public String getAddress() {
		return Address;
	}

	public void setAddress(String address) {
		Address = address;
	}

	public Integer getOrganizationId() {
		return OrganizationId;
	}

	public void setOrganizationId(Integer organizationId) {
		OrganizationId = organizationId;
	}

	public String getManufacturer() {
		return Manufacturer;
	}

	public void setManufacturer(String manufacturer) {
		Manufacturer = manufacturer;
	}

	public Date getProduceDate() {
		return ProduceDate;
	}

	public void setProduceDate(Date produceDate) {
		ProduceDate = produceDate;
	}

	public String getCreater() {
		return Creater;
	}

	public void setCreater(String creater) {
		Creater = creater;
	}

	public Date getCreateDate() {
		return CreateDate;
	}

	public void setCreateDate(Date string) {
		CreateDate = string;
	}

	public MeasureFile() {
		super();
	}

	public MeasureFile(String measureName, String measureNumber, String address, String longitude, String latitude,
			Integer organizationId, String manufacturer, Date produceDate, String creater, Date createDate,
			Integer region) {
		super();
		MeasureName = measureName;
		MeasureNumber = measureNumber;
		Address = address;
		this.longitude = longitude;
		this.latitude = latitude;
		OrganizationId = organizationId;
		Manufacturer = manufacturer;
		ProduceDate = produceDate;
		Creater = creater;
		CreateDate = createDate;
		Region = region;
	}

	public int getAlarmType() {
		return alarmType;
	}

	public void setAlarmType(int alarmType) {
		this.alarmType = alarmType;
	}

	public List<MbAmmeter> getMbAmmeterList() {
		return mbAmmeterList;
	}

	public void setMbAmmeterList(List<MbAmmeter> mbAmmeterList) {
		this.mbAmmeterList = mbAmmeterList;
	}

	public List<Terminal> getTerminals() {
		return terminals;
	}

	public void setTerminals(List<Terminal> terminals) {
		this.terminals = terminals;
	}

	public int getOpenStatus() {
		return openStatus;
	}

	public void setOpenStatus(int openStatus) {
		this.openStatus = openStatus;
	}

}
