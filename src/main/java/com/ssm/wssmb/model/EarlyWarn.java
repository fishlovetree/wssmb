package com.ssm.wssmb.model;

public class EarlyWarn {
	
	private Integer id;
	
	private String equipName;
	
	private String equipmentAddress;
	
	//采集存储时间
	private String collectStoreTime;
	
	//事件名称
	private String eventName;
	
	//表箱名称
	private String MeasureName;
	
	//表箱安装地址
	private String Address;
	
	//表箱地址
	private String MeasureNumber;
	

	public String getMeasureNumber() {
		return MeasureNumber;
	}

	public void setMeasureNumber(String measureNumber) {
		MeasureNumber = measureNumber;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getEquipName() {
		return equipName;
	}

	public void setEquipName(String equipName) {
		this.equipName = equipName;
	}

	public String getEquipmentAddress() {
		return equipmentAddress;
	}

	public void setEquipmentAddress(String equipmentAddress) {
		this.equipmentAddress = equipmentAddress;
	}

	public String getCollectStoreTime() {
		return collectStoreTime;
	}

	public void setCollectStoreTime(String collectStoreTime) {
		this.collectStoreTime = collectStoreTime;
	}

	public String getEventName() {
		return eventName;
	}

	public void setEventName(String eventName) {
		this.eventName = eventName;
	}

	public String getMeasureName() {
		return MeasureName;
	}

	public void setMeasureName(String measureName) {
		MeasureName = measureName;
	}

	public String getAddress() {
		return Address;
	}

	public void setAddress(String address) {
		Address = address;
	}
	
	

}
