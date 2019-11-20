package com.ssm.wssmb.model;

import java.io.Serializable;

public class MbAieLock implements Serializable {
	private static final long serialVersionUID = 1L;

	private int id;

	private String lockName;

	private int boxCode;

	private String boxName;

	private String lockCode;

	private int organizationCode;

	private String organizationName;

	private String produce;

	private String produceTime;

	private String createPerson;

	private String createTime;

	private String lockType;

	private String apikey;

	private String imei;

	private String imsi;

	private String serialnumber;

	private String password;

	private String mac;

	private int openStatus;

	private boolean obsv;

	private boolean isprivate;

	private MeasureFile measureFile;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getBoxCode() {
		return boxCode;
	}

	public void setBoxCode(int boxCode) {
		this.boxCode = boxCode;
	}

	public String getLockCode() {
		return lockCode;
	}

	public void setLockCode(String lockCode) {
		this.lockCode = lockCode;
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

	public String getLockType() {
		return lockType;
	}

	public void setLockType(String lockType) {
		this.lockType = lockType;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getBoxName() {
		return boxName;
	}

	public void setBoxName(String boxName) {
		this.boxName = boxName;
	}

	public String getOrganizationName() {
		return organizationName;
	}

	public void setOrganizationName(String organizationName) {
		this.organizationName = organizationName;
	}

	public String getApikey() {
		return apikey;
	}

	public void setApikey(String apikey) {
		this.apikey = apikey;
	}

	public String getImei() {
		return imei;
	}

	public void setImei(String imei) {
		this.imei = imei;
	}

	public String getImsi() {
		return imsi;
	}

	public void setImsi(String imsi) {
		this.imsi = imsi;
	}

	public String getSerialnumber() {
		return serialnumber;
	}

	public void setSerialnumber(String serialnumber) {
		this.serialnumber = serialnumber;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getMac() {
		return mac;
	}

	public void setMac(String mac) {
		this.mac = mac;
	}

	public int getOpenStatus() {
		return openStatus;
	}

	public void setOpenStatus(int openStatus) {
		this.openStatus = openStatus;
	}

	public boolean isObsv() {
		return obsv;
	}

	public void setObsv(boolean obsv) {
		this.obsv = obsv;
	}

	public boolean isIsprivate() {
		return isprivate;
	}

	public void setIsprivate(boolean isprivate) {
		this.isprivate = isprivate;
	}

	public String getLockName() {
		return lockName;
	}

	public void setLockName(String lockName) {
		this.lockName = lockName;
	}

	public MeasureFile getMeasureFile() {
		return measureFile;
	}

	public void setMeasureFile(MeasureFile measureFile) {
		this.measureFile = measureFile;
	}

}