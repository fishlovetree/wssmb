package com.ssm.wssmb.model;

/**
 * @author Eric
 * 
 * **/
import java.io.Serializable;

public class MbBlueBreaker implements Serializable {

	private static final long serialVersionUID = 1L;

	private Integer id;

	private int boxCode;

	private String boxName;

	private String breakerName;

	private int breakerCode;

	private String produce;

	private String produceTime;

	private String createPerson;

	private String createTime;

	private String breakerType;

	private int ammeterCode;

	private String ammeterName;

	private int organizationCode;

	private String organizationName;

	private int openStatus;
	
	private String ammeterAddress;
	
	private int installAddress;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
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

	public String getBreakerName() {
		return breakerName;
	}

	public void setBreakerName(String breakerName) {
		this.breakerName = breakerName;
	}

	public int getBreakerCode() {
		return breakerCode;
	}

	public void setBreakerCode(int breakerCode) {
		this.breakerCode = breakerCode;
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

	public String getBreakerType() {
		return breakerType;
	}

	public void setBreakerType(String breakerType) {
		this.breakerType = breakerType;
	}

	public int getAmmeterCode() {
		return ammeterCode;
	}

	public void setAmmeterCode(int ammeterCode) {
		this.ammeterCode = ammeterCode;
	}

	public String getAmmeterName() {
		return ammeterName;
	}

	public void setAmmeterName(String ammeterName) {
		this.ammeterName = ammeterName;
	}

	public int getOrganizationCode() {
		return organizationCode;
	}

	public void setOrganizationCode(int organizationCode) {
		this.organizationCode = organizationCode;
	}

	public String getOrganizationName() {
		return organizationName;
	}

	public void setOrganizationName(String organizationName) {
		this.organizationName = organizationName;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public int getOpenStatus() {
		return openStatus;
	}

	public void setOpenStatus(int openStatus) {
		this.openStatus = openStatus;
	}

	public String getAmmeterAddress() {
		return ammeterAddress;
	}

	public void setAmmeterAddress(String ammeterAddress) {
		this.ammeterAddress = ammeterAddress;
	}

	public int getInstallAddress() {
		return installAddress;
	}

	public void setInstallAddress(int installAddress) {
		this.installAddress = installAddress;
	}
}