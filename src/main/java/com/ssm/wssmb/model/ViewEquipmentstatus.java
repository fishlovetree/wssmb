package com.ssm.wssmb.model;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

public class ViewEquipmentstatus {
    private Integer equipmentid;

    private String equipmentname;

    private String equipmenttype;

    private String manufacturer;

    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date dateofproduction;

    private String specifications;

    private String equipmentaddress;

    private Integer buildingid;

    private String coordinate;

    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date installationtime;

    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date recorddate;

    private Integer operator;

    private String equipmentnote;

    private String installationsite;

    private Short communicationstatus;

    private Short downstatus;

    private String phonenum;

    private Short status;

    private String productmodel;

    private String systemtype;

    private String uptype;

    private Integer upid;

    private Integer customerid;

    private String commtype;

    private String protocol;

    private Integer keyversion;

    private String softwareversion;

    private String unitname;

    private String unitaddress;

    private Integer unitid;

    private String controlname;

    private Integer videlcount;

    private String systemaddress;

    private Integer freezingtype;

    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date alarmtime;

    private Integer alarmtype;

    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date faulttime;

    private Integer faulttype;

    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date freezetime;

    private Integer unitstatus;

    private Integer devicestatus;

    private String customername;

    private String equipmenttypename;

    private String systemtypename;

    private String buildingname;

    private Integer statustype;
    
    private Integer isalarm;
    
    private Integer isfault;
    
    private String alarmname;
    
    private String faultname;
    
    private String devicemodel;//设备型号名

    private Integer regionid;
    
    private String regionname;
    
    private String customeraddress;
    
    private String organizationname;
    
    private String protocolname;//通讯协议
    
    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date onlinetime;
    
    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date droppedtime;
    
    private Integer routes;//告警-多路-路数 

    private Integer channelno;//故障-多路-路数 

	public Integer getEquipmentid() {
		return equipmentid;
	}

	public void setEquipmentid(Integer equipmentid) {
		this.equipmentid = equipmentid;
	}

	public String getEquipmentname() {
		return equipmentname;
	}

	public void setEquipmentname(String equipmentname) {
		this.equipmentname = equipmentname;
	}

	public String getEquipmenttype() {
		return equipmenttype;
	}

	public void setEquipmenttype(String equipmenttype) {
		this.equipmenttype = equipmenttype;
	}

	public String getManufacturer() {
		return manufacturer;
	}

	public void setManufacturer(String manufacturer) {
		this.manufacturer = manufacturer;
	}

	public Date getDateofproduction() {
		return dateofproduction;
	}

	public void setDateofproduction(Date dateofproduction) {
		this.dateofproduction = dateofproduction;
	}

	public String getSpecifications() {
		return specifications;
	}

	public void setSpecifications(String specifications) {
		this.specifications = specifications;
	}

	public String getEquipmentaddress() {
		return equipmentaddress;
	}

	public void setEquipmentaddress(String equipmentaddress) {
		this.equipmentaddress = equipmentaddress;
	}

	public Integer getBuildingid() {
		return buildingid;
	}

	public void setBuildingid(Integer buildingid) {
		this.buildingid = buildingid;
	}

	public String getCoordinate() {
		return coordinate;
	}

	public void setCoordinate(String coordinate) {
		this.coordinate = coordinate;
	}

	public Date getInstallationtime() {
		return installationtime;
	}

	public void setInstallationtime(Date installationtime) {
		this.installationtime = installationtime;
	}

	public Date getRecorddate() {
		return recorddate;
	}

	public void setRecorddate(Date recorddate) {
		this.recorddate = recorddate;
	}

	public Integer getOperator() {
		return operator;
	}

	public void setOperator(Integer operator) {
		this.operator = operator;
	}

	public String getEquipmentnote() {
		return equipmentnote;
	}

	public void setEquipmentnote(String equipmentnote) {
		this.equipmentnote = equipmentnote;
	}

	public String getInstallationsite() {
		return installationsite;
	}

	public void setInstallationsite(String installationsite) {
		this.installationsite = installationsite;
	}

	public Short getCommunicationstatus() {
		return communicationstatus;
	}

	public void setCommunicationstatus(Short communicationstatus) {
		this.communicationstatus = communicationstatus;
	}

	public Short getDownstatus() {
		return downstatus;
	}

	public void setDownstatus(Short downstatus) {
		this.downstatus = downstatus;
	}

	public String getPhonenum() {
		return phonenum;
	}

	public void setPhonenum(String phonenum) {
		this.phonenum = phonenum;
	}

	public Short getStatus() {
		return status;
	}

	public void setStatus(Short status) {
		this.status = status;
	}

	public String getProductmodel() {
		return productmodel;
	}

	public void setProductmodel(String productmodel) {
		this.productmodel = productmodel;
	}

	public String getSystemtype() {
		return systemtype;
	}

	public void setSystemtype(String systemtype) {
		this.systemtype = systemtype;
	}

	public String getUptype() {
		return uptype;
	}

	public void setUptype(String uptype) {
		this.uptype = uptype;
	}

	public Integer getUpid() {
		return upid;
	}

	public void setUpid(Integer upid) {
		this.upid = upid;
	}

	public Integer getCustomerid() {
		return customerid;
	}

	public void setCustomerid(Integer customerid) {
		this.customerid = customerid;
	}

	public String getCommtype() {
		return commtype;
	}

	public void setCommtype(String commtype) {
		this.commtype = commtype;
	}

	public String getProtocol() {
		return protocol;
	}

	public void setProtocol(String protocol) {
		this.protocol = protocol;
	}

	public Integer getKeyversion() {
		return keyversion;
	}

	public void setKeyversion(Integer keyversion) {
		this.keyversion = keyversion;
	}

	public String getSoftwareversion() {
		return softwareversion;
	}

	public void setSoftwareversion(String softwareversion) {
		this.softwareversion = softwareversion;
	}

	public String getUnitname() {
		return unitname;
	}

	public void setUnitname(String unitname) {
		this.unitname = unitname;
	}

	public String getUnitaddress() {
		return unitaddress;
	}

	public void setUnitaddress(String unitaddress) {
		this.unitaddress = unitaddress;
	}

	public Integer getUnitid() {
		return unitid;
	}

	public void setUnitid(Integer unitid) {
		this.unitid = unitid;
	}

	public String getControlname() {
		return controlname;
	}

	public void setControlname(String controlname) {
		this.controlname = controlname;
	}

	public Integer getVidelcount() {
		return videlcount;
	}

	public void setVidelcount(Integer videlcount) {
		this.videlcount = videlcount;
	}

	public String getSystemaddress() {
		return systemaddress;
	}

	public void setSystemaddress(String systemaddress) {
		this.systemaddress = systemaddress;
	}

	public Integer getFreezingtype() {
		return freezingtype;
	}

	public void setFreezingtype(Integer freezingtype) {
		this.freezingtype = freezingtype;
	}

	public Date getAlarmtime() {
		return alarmtime;
	}

	public void setAlarmtime(Date alarmtime) {
		this.alarmtime = alarmtime;
	}

	public Integer getAlarmtype() {
		return alarmtype;
	}

	public void setAlarmtype(Integer alarmtype) {
		this.alarmtype = alarmtype;
	}

	public Date getFaulttime() {
		return faulttime;
	}

	public void setFaulttime(Date faulttime) {
		this.faulttime = faulttime;
	}

	public Integer getFaulttype() {
		return faulttype;
	}

	public void setFaulttype(Integer faulttype) {
		this.faulttype = faulttype;
	}

	public Date getFreezetime() {
		return freezetime;
	}

	public void setFreezetime(Date freezetime) {
		this.freezetime = freezetime;
	}

	public Integer getUnitstatus() {
		return unitstatus;
	}

	public void setUnitstatus(Integer unitstatus) {
		this.unitstatus = unitstatus;
	}

	public Integer getDevicestatus() {
		return devicestatus;
	}

	public void setDevicestatus(Integer devicestatus) {
		this.devicestatus = devicestatus;
	}

	public String getCustomername() {
		return customername;
	}

	public void setCustomername(String customername) {
		this.customername = customername;
	}

	public String getEquipmenttypename() {
		return equipmenttypename;
	}

	public void setEquipmenttypename(String equipmenttypename) {
		this.equipmenttypename = equipmenttypename;
	}

	public String getSystemtypename() {
		return systemtypename;
	}

	public void setSystemtypename(String systemtypename) {
		this.systemtypename = systemtypename;
	}

	public String getBuildingname() {
		return buildingname;
	}

	public void setBuildingname(String buildingname) {
		this.buildingname = buildingname;
	}

	public Integer getStatustype() {
		return statustype;
	}

	public void setStatustype(Integer statustype) {
		this.statustype = statustype;
	}

	public Integer getIsalarm() {
		return isalarm;
	}

	public void setIsalarm(Integer isalarm) {
		this.isalarm = isalarm;
	}

	public Integer getIsfault() {
		return isfault;
	}

	public void setIsfault(Integer isfault) {
		this.isfault = isfault;
	}

	public String getAlarmname() {
		return alarmname;
	}

	public void setAlarmname(String alarmname) {
		this.alarmname = alarmname;
	}

	public String getFaultname() {
		return faultname;
	}

	public void setFaultname(String faultname) {
		this.faultname = faultname;
	}

	public String getDevicemodel() {
		return devicemodel;
	}

	public void setDevicemodel(String devicemodel) {
		this.devicemodel = devicemodel;
	}

	public Integer getRegionid() {
		return regionid;
	}

	public void setRegionid(Integer regionid) {
		this.regionid = regionid;
	}

	public String getRegionname() {
		return regionname;
	}

	public void setRegionname(String regionname) {
		this.regionname = regionname;
	}

	public String getCustomeraddress() {
		return customeraddress;
	}

	public void setCustomeraddress(String customeraddress) {
		this.customeraddress = customeraddress;
	}

	public String getOrganizationname() {
		return organizationname;
	}

	public void setOrganizationname(String organizationname) {
		this.organizationname = organizationname;
	}

	public String getProtocolname() {
		return protocolname;
	}

	public void setProtocolname(String protocolname) {
		this.protocolname = protocolname;
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

	public Integer getRoutes() {
		return routes;
	}

	public void setRoutes(Integer routes) {
		this.routes = routes;
	}

	public Integer getChannelno() {
		return channelno;
	}

	public void setChannelno(Integer channelno) {
		this.channelno = channelno;
	}

}