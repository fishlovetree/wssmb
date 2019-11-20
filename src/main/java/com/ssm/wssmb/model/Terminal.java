package com.ssm.wssmb.model;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

public class Terminal {

	private Integer terminalId;

	private String terminalName;

	private String address;

	private String installationLocation;

	private Integer concentratorId;

	private Concentrator concentrator;

	private String concentratorName;

	private Integer organizationId;

	private String organizationName;

	private Organization organization;

	private Integer region;

	private String manufacturer;

	private EarlyWarning earlyWarning;

	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") // 前端时间字符串转java时间戳
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8") // 后台时间戳转前端时间字符串(json对象)
	private Date ProduceDate;

	private String Creater;
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") // 前端时间字符串转java时间戳
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8") // 后台时间戳转前端时间字符串(json对象)

	private Date CreateDate;

	private Integer measureId;

	private MeasureFile measureFile;

	private String MeasureName;

	private Integer terminalType;

	private String softType;

	private String hardType;
	
	private Integer COMMUNICATIONSTATUS;
	
	private Integer DOWNSTATUS;
	
	private Integer freezingtype;
	
	public Integer getFreezingtype() {
		return freezingtype;
	}

	public void setFreezingtype(Integer freezingtype) {
		this.freezingtype = freezingtype;
	}

	public Integer getCOMMUNICATIONSTATUS() {
		return COMMUNICATIONSTATUS;
	}

	public void setCOMMUNICATIONSTATUS(Integer cOMMUNICATIONSTATUS) {
		COMMUNICATIONSTATUS = cOMMUNICATIONSTATUS;
	}

	public Integer getDOWNSTATUS() {
		return DOWNSTATUS;
	}

	public void setDOWNSTATUS(Integer dOWNSTATUS) {
		DOWNSTATUS = dOWNSTATUS;
	}

	public Integer getTerminalId() {
		return terminalId;
	}

	public void setTerminalId(Integer terminalId) {
		this.terminalId = terminalId;
	}

	public String getTerminalName() {
		return terminalName;
	}

	public void setTerminalName(String terminalName) {
		this.terminalName = terminalName;
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

	public Integer getConcentratorId() {
		return concentratorId;
	}

	public void setConcentratorId(Integer concentratorId) {
		this.concentratorId = concentratorId;
	}

	public Concentrator getConcentrator() {
		return concentrator;
	}

	public void setConcentrator(Concentrator concentrator) {
		this.concentrator = concentrator;
	}

	public Integer getOrganizationId() {
		return organizationId;
	}

	public void setOrganizationId(Integer organizationId) {
		this.organizationId = organizationId;
	}

	public String getOrganizationName() {
		return organizationName;
	}

	public void setOrganizationName(String organizationName) {
		this.organizationName = organizationName;
	}

	public Organization getOrganization() {
		return organization;
	}

	public void setOrganization(Organization organization) {
		this.organization = organization;
	}

	public Integer getRegion() {
		return region;
	}

	public void setRegion(Integer region) {
		this.region = region;
	}

	public String getManufacturer() {
		return manufacturer;
	}

	public void setManufacturer(String manufacturer) {
		this.manufacturer = manufacturer;
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

	public void setCreateDate(Date createDate) {
		CreateDate = createDate;
	}

	public Integer getMeasureId() {
		return measureId;
	}

	public void setMeasureId(Integer measureId) {
		this.measureId = measureId;
	}

	public MeasureFile getMeasureFile() {
		return measureFile;
	}

	public void setMeasureFile(MeasureFile measureFile) {
		this.measureFile = measureFile;
	}

	public String getMeasureName() {
		return MeasureName;
	}

	public void setMeasureName(String measureName) {
		MeasureName = measureName;
	}

	public Integer getTerminalType() {
		return terminalType;
	}

	public void setTerminalType(Integer terminalType) {
		this.terminalType = terminalType;
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

	@Override
	public String toString() {
		return "Terminal [terminalId=" + terminalId + ", terminalName=" + terminalName + ", address=" + address
				+ ", installationLocation=" + installationLocation + ", concentratorId=" + concentratorId
				+ ", concentrator=" + concentrator + ", concentratorName=" + concentratorName + ", organizationId="
				+ organizationId + ", organizationName=" + organizationName + ", organization=" + organization
				+ ", region=" + region + ", manufacturer=" + manufacturer + ", ProduceDate=" + ProduceDate
				+ ", Creater=" + Creater + ", CreateDate=" + CreateDate + ", measureId=" + measureId + ", measureFile="
				+ measureFile + ", MeasureName=" + MeasureName + ", terminalType=" + terminalType + ", softType="
				+ softType + ", hardType=" + hardType + "]";
	}

	public EarlyWarning getEarlyWarning() {
		return earlyWarning;
	}

	public void setEarlyWarning(EarlyWarning earlyWarning) {
		this.earlyWarning = earlyWarning;
	}

}
