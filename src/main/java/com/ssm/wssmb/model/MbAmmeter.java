package com.ssm.wssmb.model;

import java.io.Serializable;

public class MbAmmeter implements Serializable {
	private static final long serialVersionUID = 1L;

	private Integer id;

	private String ammeterName;

	private String ammeterCode;

	private String installAddress;

	private int concentratorCode;

	private int organizationCode;

	private String concentratorName;

	private String organizationName;

	private String produce;

	private String produceTime;

	private String createPerson;

	private String createTime;

	private int boxCode;

	private String boxName;

	private String MeasureName;

	private String ammeterType;

	private String softType;

	private String hardType;

	private Integer COMMUNICATIONSTATUS;

	private Integer DOWNSTATUS;

	private EarlyWarning earlyWarning;

	private Integer switchStatus;

	private Integer freezingtype;

	private MeasureFile measureFile;

	private MbConcentrator concentrator;

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

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getAmmeterName() {
		return ammeterName;
	}

	public void setAmmeterName(String ammeterName) {
		this.ammeterName = ammeterName;
	}

	public String getAmmeterCode() {
		return ammeterCode;
	}

	public void setAmmeterCode(String ammeterCode) {
		this.ammeterCode = ammeterCode;
	}

	public String getInstallAddress() {
		return installAddress;
	}

	public void setInstallAddress(String installAddress) {
		this.installAddress = installAddress;
	}

	public int getConcentratorCode() {
		return concentratorCode;
	}

	public void setConcentratorCode(int concentratorCode) {
		this.concentratorCode = concentratorCode;
	}

	public int getOrganizationCode() {
		return organizationCode;
	}

	public void setOrganizationCode(int organizationCode) {
		this.organizationCode = organizationCode;
	}

	public String getProduce() {
		return produce;
	}

	public void setProduce(String produce) {
		this.produce = produce;
	}

	public String getProduceTime() {
		return produceTime;
	}

	public void setProduceTime(String produceTime) {
		this.produceTime = produceTime;
	}

	public String getCreatePerson() {
		return createPerson;
	}

	public void setCreatePerson(String createPerson) {
		this.createPerson = createPerson;
	}

	public String getCreateTime() {
		return createTime;
	}

	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}

	public int getBoxCode() {
		return boxCode;
	}

	public void setBoxCode(int boxCode) {
		this.boxCode = boxCode;
	}

	public String getBoxName() {
		return boxName;
	}

	public void setBoxName(String boxName) {
		this.boxName = boxName;
	}

	public String getAmmeterType() {
		return ammeterType;
	}

	public void setAmmeterType(String ammeterType) {
		this.ammeterType = ammeterType;
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

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getConcentratorName() {
		return concentratorName;
	}

	public void setConcentratorName(String concentratorName) {
		this.concentratorName = concentratorName;
	}

	public String getOrganizationName() {
		return organizationName;
	}

	public void setOrganizationName(String organizationName) {
		this.organizationName = organizationName;
	}

	public String getMeasureName() {
		return MeasureName;
	}

	public void setMeasureName(String measureName) {
		MeasureName = measureName;
	}

	public EarlyWarning getEarlyWarning() {
		return earlyWarning;
	}

	public void setEarlyWarning(EarlyWarning earlyWarning) {
		this.earlyWarning = earlyWarning;
	}

	public Integer getSwitchStatus() {
		return switchStatus;
	}

	public void setSwitchStatus(Integer switchStatus) {
		this.switchStatus = switchStatus;
	}

	public MeasureFile getMeasureFile() {
		return measureFile;
	}

	public void setMeasureFile(MeasureFile measureFile) {
		this.measureFile = measureFile;
	}

	public MbConcentrator getConcentrator() {
		return concentrator;
	}

	public void setConcentrator(MbConcentrator concentrator) {
		this.concentrator = concentrator;
	}

	@Override
	public String toString() {
		return "MbAmmeter [id=" + id + ", ammeterName=" + ammeterName + ", ammeterCode=" + ammeterCode
				+ ", installAddress=" + installAddress + ", concentratorCode=" + concentratorCode
				+ ", organizationCode=" + organizationCode + ", concentratorName=" + concentratorName
				+ ", organizationName=" + organizationName + ", produce=" + produce + ", produceTime=" + produceTime
				+ ", createPerson=" + createPerson + ", createTime=" + createTime + ", boxCode=" + boxCode
				+ ", boxName=" + boxName + ", MeasureName=" + MeasureName + ", ammeterType=" + ammeterType
				+ ", softType=" + softType + ", hardType=" + hardType + ", COMMUNICATIONSTATUS=" + COMMUNICATIONSTATUS
				+ ", DOWNSTATUS=" + DOWNSTATUS + ", earlyWarning=" + earlyWarning + ", switchStatus=" + switchStatus
				+ ", freezingtype=" + freezingtype + ", measureFile=" + measureFile + ", concentrator=" + concentrator
				+ "]";
	}

	
}