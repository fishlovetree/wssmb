package com.ssm.wssmb.model;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

public class ViewEquipment {
    private Integer equipmentid;

    private String equipmentname;

    private String equipmenttype;

    private String manufacturer;

    @DateTimeFormat(pattern="yyyy-MM-dd")
    private Date dateofproduction;

    private String specifications;

    private String equipmentaddress;

    private Integer buildingid;

    private String coordinate;

    @DateTimeFormat(pattern="yyyy-MM-dd")
    private Date installationtime;

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

    private String systemaddress;

    private String uptype;

    private Integer upid;

    private Integer customerid;

    private String commtype;

    private String unitname;

    private String controlname;

    private String unitaddress;

    private Integer unitid;

    private Integer videlcount;
    
    private String protocol;
    
    private String softwareversion;
    
    private Integer freezingtype;
    
    /*系统自用的字段*/
    private String operatorname;
    
    private Integer pictureid;
    
    private String equipmenttypename;
    
    private String buildingname;
    
    private String systemtypename;
	
	private String manufacturername;
	
	private String upname;
	
	private String customercode;
	
	/*设备档案相关*/
	private String customername;

	private String communicationstatusname;

	private String uptypename;
	
	private String protocolname;

	private String productmodelname;
	
	private String onenetdeviceid;;

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
        this.equipmentname = equipmentname == null ? null : equipmentname.trim();
    }

    public String getEquipmenttype() {
        return equipmenttype;
    }

    public void setEquipmenttype(String equipmenttype) {
        this.equipmenttype = equipmenttype == null ? null : equipmenttype.trim();
    }

    public String getManufacturer() {
        return manufacturer;
    }

    public void setManufacturer(String manufacturer) {
        this.manufacturer = manufacturer == null ? null : manufacturer.trim();
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
        this.specifications = specifications == null ? null : specifications.trim();
    }

    public String getEquipmentaddress() {
        return equipmentaddress;
    }

    public void setEquipmentaddress(String equipmentaddress) {
        this.equipmentaddress = equipmentaddress == null ? null : equipmentaddress.trim();
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
        this.coordinate = coordinate == null ? null : coordinate.trim();
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
        this.equipmentnote = equipmentnote == null ? null : equipmentnote.trim();
    }

    public String getInstallationsite() {
        return installationsite;
    }

    public void setInstallationsite(String installationsite) {
        this.installationsite = installationsite == null ? null : installationsite.trim();
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
        this.phonenum = phonenum == null ? null : phonenum.trim();
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
        this.productmodel = productmodel == null ? null : productmodel.trim();
    }

    public String getSystemtype() {
		return systemtype;
	}

	public void setSystemtype(String systemtype) {
		this.systemtype = systemtype;
	}

    public String getSystemaddress() {
        return systemaddress;
    }

    public void setSystemaddress(String systemaddress) {
        this.systemaddress = systemaddress == null ? null : systemaddress.trim();
    }

    public String getUptype() {
        return uptype;
    }

    public void setUptype(String uptype) {
        this.uptype = uptype == null ? null : uptype.trim();
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
        this.commtype = commtype == null ? null : commtype.trim();
    }

    public String getUnitname() {
        return unitname;
    }

    public void setUnitname(String unitname) {
        this.unitname = unitname == null ? null : unitname.trim();
    }

    public String getControlname() {
        return controlname;
    }

    public void setControlname(String controlname) {
        this.controlname = controlname == null ? null : controlname.trim();
    }

    public String getUnitaddress() {
        return unitaddress;
    }

    public void setUnitaddress(String unitaddress) {
        this.unitaddress = unitaddress == null ? null : unitaddress.trim();
    }

    public Integer getUnitid() {
        return unitid;
    }

    public void setUnitid(Integer unitid) {
        this.unitid = unitid;
    }

    public Integer getVidelcount() {
        return videlcount;
    }

    public void setVidelcount(Integer videlcount) {
        this.videlcount = videlcount;
    }

	public Integer getFreezingtype() {
		return freezingtype;
	}

	public void setFreezingtype(Integer freezingtype) {
		this.freezingtype = freezingtype;
	}

	public String getOperatorname() {
		return operatorname;
	}

	public void setOperatorname(String operatorname) {
		this.operatorname = operatorname;
	}

	public Integer getPictureid() {
		return pictureid;
	}

	public void setPictureid(Integer pictureid) {
		this.pictureid = pictureid;
	}

	public String getEquipmenttypename() {
		return equipmenttypename;
	}

	public void setEquipmenttypename(String equipmenttypename) {
		this.equipmenttypename = equipmenttypename;
	}

	public String getBuildingname() {
		return buildingname;
	}

	public void setBuildingname(String buildingname) {
		this.buildingname = buildingname;
	}

	public String getSystemtypename() {
		return systemtypename;
	}

	public void setSystemtypename(String systemtypename) {
		this.systemtypename = systemtypename;
	}

	public String getManufacturername() {
		return manufacturername;
	}

	public void setManufacturername(String manufacturername) {
		this.manufacturername = manufacturername;
	}

	public String getUpname() {
		return upname;
	}

	public void setUpname(String upname) {
		this.upname = upname;
	}

	public String getCustomercode() {
		return customercode;
	}

	public void setCustomercode(String customercode) {
		this.customercode = customercode;
	}

	public String getProtocol() {
		return protocol;
	}

	public void setProtocol(String protocol) {
		this.protocol = protocol;
	}

	public String getSoftwareversion() {
		return softwareversion;
	}

	public void setSoftwareversion(String softwareversion) {
		this.softwareversion = softwareversion;
	}

	public String getCustomername() {
		return customername;
	}

	public void setCustomername(String customername) {
		this.customername = customername;
	}

	public String getCommunicationstatusname() {
		return communicationstatusname;
	}

	public void setCommunicationstatusname(String communicationstatusname) {
		this.communicationstatusname = communicationstatusname;
	}

	public String getUptypename() {
		return uptypename;
	}

	public void setUptypename(String uptypename) {
		this.uptypename = uptypename;
	}

	public String getOnenetdeviceid() {
		return onenetdeviceid;
	}

	public void setOnenetdeviceid(String onenetdeviceid) {
		this.onenetdeviceid = onenetdeviceid;
	}

	public String getProtocolname() {
		return protocolname;
	}

	public void setProtocolname(String protocolname) {
		this.protocolname = protocolname;
	}

	public String getProductmodelname() {
		return productmodelname;
	}

	public void setProductmodelname(String productmodelname) {
		this.productmodelname = productmodelname;
	}
	
}