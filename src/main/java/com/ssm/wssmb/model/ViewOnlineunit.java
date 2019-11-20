package com.ssm.wssmb.model;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

public class ViewOnlineunit {
    private Integer id;

    private String address;

    private String clientLinke;

    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date onlinetime;

    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date droppedtime;

    private Integer status;
    
    private String fepNum;
    
    private String type;
    
    private String typename;
    
    private String equipname;
    
    //设备型号
    private Integer devicetype;

	
	public Integer getDevicetype() {
		return devicetype;
	}

	public void setDevicetype(Integer devicetype) {
		this.devicetype = devicetype;
	}

	public String getEquipname() {
		return equipname;
	}

	public void setEquipname(String equipname) {
		this.equipname = equipname;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getTypename() {
		return typename;
	}

	public void setTypename(String typename) {
		this.typename = typename;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getClientLinke() {
		return clientLinke;
	}

	public void setClientLinke(String clientLinke) {
		this.clientLinke = clientLinke;
	}

	public Date getOnlinetime() {
		return onlinetime;
	}

	public void setOnlinetime(Date onlinetime) {
		this.onlinetime = onlinetime;
	}

	public Date getDroppedtime() {
		return droppedtime;
	}

	public void setDroppedtime(Date droppedtime) {
		this.droppedtime = droppedtime;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public String getFepNum() {
		return fepNum;
	}

	public void setFepNum(String fepNum) {
		this.fepNum = fepNum;
	}

	@Override
	public String toString() {
		return "ViewOnlineunit [id=" + id + ", address=" + address + ", clientLinke=" + clientLinke + ", onlinetime="
				+ onlinetime + ", droppedtime=" + droppedtime + ", status=" + status + ", fepNum=" + fepNum + ", type="
				+ type + ", typename=" + typename + "]";
	}
    
  
    
}