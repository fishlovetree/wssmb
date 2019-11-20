package com.ssm.wssmb.model;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

public class LoadAnalysis {

	private int id;

	private String elecType;

	private String type;

	private int status;

	// 最近一次开启时间
	private String startTime;

	// 最近一次关闭时间
	private String endTime;
	
	private String insertTime;
	
	// 累计消耗电能
	private String elecUsed;

	// 累计启停次数
	private int changeCount;
	
	private String usedTime;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
	public String getElecType() {
		return elecType;
	}

	public void setElecType(String elecType) {
		this.elecType = elecType;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public String getStartTime() {
		return startTime;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public String getInsertTime() {
		return insertTime;
	}

	public void setInsertTime(String insertTime) {
		this.insertTime = insertTime;
	}

	public String getElecUsed() {
		return elecUsed;
	}

	public void setElecUsed(String elecUsed) {
		this.elecUsed = elecUsed;
	}

	public int getChangeCount() {
		return changeCount;
	}

	public void setChangeCount(int changeCount) {
		this.changeCount = changeCount;
	}

	public String getUsedTime() {
		return usedTime;
	}

	public void setUsedTime(String usedTime) {
		this.usedTime = usedTime;
	}

	
}
