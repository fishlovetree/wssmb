package com.ssm.wssmb.model;

/**
 * 设备状态实体类
 * @author rcd
 *
 */
public class AmmeterStatus {
	
	private Integer id;
	
	//设备名称
	private String ammeterName;
	
	//表号,地址
	private String ammeterCode;
	
	//状态
	private Integer status;
	
	//最近冻结时间
	private String lastFreezeTime;
	
	//最近告警时间
	private String lastEarlyWarnTime;
	
	//最近故障时间
	private String lastFaultTime;
	
	//安装位置
	private String installAddress;
	
	//集中器名称
	private String concentratorName;
	
	//在线时间
	private String onlineTime;
	
	//离线时间
	private String offlineTime;
	
	//安装地址
	private  String address;
	
	//坐标
	private String location;
	
	//设备类型
	private String typename;
	
	//设备型号
	private Integer devicetype; 
	
	public String getTypename() {
		return typename;
	}

	public void setTypename(String typename) {
		this.typename = typename;
	}

	public Integer getDevicetype() {
		return devicetype;
	}

	public void setDevicetype(Integer devicetype) {
		this.devicetype = devicetype;
	}

	public String getOnlineTime() {
		return onlineTime;
	}

	public void setOnlineTime(String onlineTime) {
		this.onlineTime = onlineTime;
	}

	public String getOfflineTime() {
		return offlineTime;
	}

	public void setOfflineTime(String offlineTime) {
		this.offlineTime = offlineTime;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getAmmeterCode() {
		return ammeterCode;
	}

	public void setAmmeterCode(String ammeterCode) {
		this.ammeterCode = ammeterCode;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public String getLastFreezeTime() {
		return lastFreezeTime;
	}

	public void setLastFreezeTime(String lastFreezeTime) {
		this.lastFreezeTime = lastFreezeTime;
	}

	public String getLastEarlyWarnTime() {
		return lastEarlyWarnTime;
	}

	public void setLastEarlyWarnTime(String lastEarlyWarnTime) {
		this.lastEarlyWarnTime = lastEarlyWarnTime;
	}

	public String getLastFaultTime() {
		return lastFaultTime;
	}

	public void setLastFaultTime(String lastFaultTime) {
		this.lastFaultTime = lastFaultTime;
	}

	public String getInstallAddress() {
		return installAddress;
	}

	public void setInstallAddress(String installAddress) {
		this.installAddress = installAddress;
	}

	public String getConcentratorName() {
		return concentratorName;
	}

	public void setConcentratorName(String concentratorName) {
		this.concentratorName = concentratorName;
	}

	public String getAmmeterName() {
		return ammeterName;
	}

	public void setAmmeterName(String ammeterName) {
		this.ammeterName = ammeterName;
	}

	@Override
	public String toString() {
		return "AmmeterStatus [id=" + id + ", ammeterName=" + ammeterName + ", ammeterCode=" + ammeterCode + ", status="
				+ status + ", lastFreezeTime=" + lastFreezeTime + ", lastEarlyWarnTime=" + lastEarlyWarnTime
				+ ", lastFaultTime=" + lastFaultTime + ", installAddress=" + installAddress + ", concentratorName="
				+ concentratorName + "]";
	}

}
