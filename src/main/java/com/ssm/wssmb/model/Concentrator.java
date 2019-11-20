package com.ssm.wssmb.model;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

public class Concentrator {

	private Integer concentratorId;

	private String concentratorName;

	private String address;

	private String installationLocation;

	private MeasureFile measureFile;

	private Integer measureId;

	private String measureName;

	private Integer organizationId;

	private String manufacturer;

	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") // 前端时间字符串转java时间戳
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8") // 后台时间戳转前端时间字符串(json对象)
	private Date produceDate;

	private String creater;

	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") // 前端时间字符串转java时间戳
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8") // 后台时间戳转前端时间字符串(json对象)
	private Date createDate;

	private String simCard;

	private String softType;

	private String hardType;

	private int concentratorType;

	private int statuteType;

	private Organization organization;

	private String organizationName;

	private Integer Region;

	private String Name;

	public Integer getConcentratorId() {
		return concentratorId;
	}

	public void setConcentratorId(Integer concentratorId) {
		this.concentratorId = concentratorId;
	}

	public String getConcentratorName() {
		return concentratorName;
	}

	public void setConcentratorName(String concentratorName) {
		this.concentratorName = concentratorName;
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

	public Integer getMeasureId() {
		return measureId;
	}

	public void setMeasureId(Integer measureId) {
		this.measureId = measureId;
	}

	public Integer getOrganizationId() {
		return organizationId;
	}

	public void setOrganizationId(Integer organizationId) {
		this.organizationId = organizationId;
	}

	public String getManufacturer() {
		return manufacturer;
	}

	public void setManufacturer(String manufacturer) {
		this.manufacturer = manufacturer;
	}

	public String getCreater() {
		return creater;
	}

	public void setCreater(String creater) {
		this.creater = creater;
	}

	public Date getProduceDate() {
		return produceDate;
	}

	public void setProduceDate(Date produceDate) {
		this.produceDate = produceDate;
	}

	public Date getCreateDate() {
		return createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	public String getSimCard() {
		return simCard;
	}

	public void setSimCard(String simCard) {
		this.simCard = simCard;
	}

	public String getSoftType() {
		return softType;
	}

	public void setSoftType(String softType) {
		this.softType = softType;
	}

	public String getHardType() {
		return hardType;
	}

	public void setHardType(String hardType) {
		this.hardType = hardType;
	}

	public int getConcentratorType() {
		return concentratorType;
	}

	public void setConcentratorType(int concentratorType) {
		this.concentratorType = concentratorType;
	}

	public int getStatuteType() {
		return statuteType;
	}

	public void setStatuteType(int statuteType) {
		this.statuteType = statuteType;
	}

	public Organization getOrganization() {
		return organization;
	}

	public void setOrganization(Organization organization) {
		this.organization = organization;
	}

	public String getOrganizationName() {
		return organizationName;
	}

	public void setOrganizationName(String organizationName) {
		this.organizationName = organizationName;
	}

	public Integer getRegion() {
		return Region;
	}

	public void setRegion(Integer region) {
		Region = region;
	}

	public String getName() {
		return Name;
	}

	public void setName(String name) {
		Name = name;
	}

	public MeasureFile getMeasureFile() {
		return measureFile;
	}

	public void setMeasureFile(MeasureFile measureFile) {
		this.measureFile = measureFile;
	}

	public String getMeasureName() {
		return measureName;
	}

	public void setMeasureName(String measureName) {
		this.measureName = measureName;
	}

	@Override
	public String toString() {
		return "Concentrator [concentratorId=" + concentratorId + ", concentratorName=" + concentratorName
				+ ", address=" + address + ", installationLocation=" + installationLocation + ", measureFile="
				+ measureFile + ", measureId=" + measureId + ", measureName=" + measureName + ", organizationId="
				+ organizationId + ", manufacturer=" + manufacturer + ", produceDate=" + produceDate + ", creater="
				+ creater + ", createDate=" + createDate + ", simCard=" + simCard + ", softType=" + softType
				+ ", hardType=" + hardType + ", concentratorType=" + concentratorType + ", statuteType=" + statuteType
				+ ", organization=" + organization + ", organizationName=" + organizationName + ", Region=" + Region
				+ ", Name=" + Name + "]";
	}

}
