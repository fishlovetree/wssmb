package com.ssm.wssmb.model;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

public class PowerQualityAnalysis {
	
	private Integer id;
	
	private String equipmentAddress;
	
	private String measureAddress;
	
	private String voltageHarmonic;
	
	private String currentHarmonics;
	
	private String incident;
	
	private Integer type;
	
	private Integer equipId;
	
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") // 前端时间字符串转java时间戳
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8") // 后台时间戳转前端时间字符串(json对象)
	private Date occurTime;
	
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") // 前端时间字符串转java时间戳
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8") // 后台时间戳转前端时间字符串(json对象)
	private Date insertionTime;
	
	private String equipmentName;

	public String getEquipmentName() {
		return equipmentName;
	}

	public void setEquipmentName(String equipmentName) {
		this.equipmentName = equipmentName;
	}

	public Date getOccurTime() {
		return occurTime;
	}

	public void setOccurTime(Date occurTime) {
		this.occurTime = occurTime;
	}

	public Date getInsertionTime() {
		return insertionTime;
	}

	public void setInsertionTime(Date insertionTime) {
		this.insertionTime = insertionTime;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getEquipmentAddress() {
		return equipmentAddress;
	}

	public void setEquipmentAddress(String equipmentAddress) {
		this.equipmentAddress = equipmentAddress;
	}

	public String getMeasureAddress() {
		return measureAddress;
	}

	public void setMeasureAddress(String measureAddress) {
		this.measureAddress = measureAddress;
	}

	public String getVoltageHarmonic() {
		return voltageHarmonic;
	}

	public void setVoltageHarmonic(String voltageHarmonic) {
		this.voltageHarmonic = voltageHarmonic;
	}

	public String getCurrentHarmonics() {
		return currentHarmonics;
	}

	public void setCurrentHarmonics(String currentHarmonics) {
		this.currentHarmonics = currentHarmonics;
	}

	public String getIncident() {
		return incident;
	}

	public void setIncident(String incident) {
		this.incident = incident;
	}

	public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
	}

	public Integer getEquipId() {
		return equipId;
	}

	public void setEquipId(Integer equipId) {
		this.equipId = equipId;
	}
	

}
