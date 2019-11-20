package com.ssm.wssmb.model;

public class EventThreshold {
    private Integer equipmentid;

    private Integer eventtypecode;

    private Double lowervalue;

    private Short delaytime;

    private String unitaddress;
    
    private String systemtype;
    
    private String systemaddress;
    
    private String equipmenttype;
    
    private String equipmentaddress;
    
    private Integer unitid;
    
    private Integer customerid;
    
    //前台树节点id
    private Integer id;
    
    //前台树节点类型
    private Integer type;
    
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
		this.systemaddress = systemaddress;
	}

	public String getEquipmenttype() {
		return equipmenttype;
	}

	public void setEquipmenttype(String equipmenttype) {
		this.equipmenttype = equipmenttype;
	}

	public String getEquipmentaddress() {
		return equipmentaddress;
	}

	public void setEquipmentaddress(String equipmentaddress) {
		this.equipmentaddress = equipmentaddress;
	}

	public Integer getEquipmentid() {
        return equipmentid;
    }

    public void setEquipmentid(Integer equipmentid) {
        this.equipmentid = equipmentid;
    }

    public Integer getEventtypecode() {
        return eventtypecode;
    }

    public void setEventtypecode(Integer eventtypecode) {
        this.eventtypecode = eventtypecode;
    }

    public Double getLowervalue() {
        return lowervalue;
    }

    public void setLowervalue(Double lowervalue) {
        this.lowervalue = lowervalue;
    }

    public Short getDelaytime() {
        return delaytime;
    }

    public void setDelaytime(Short delaytime) {
        this.delaytime = delaytime;
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

	public Integer getCustomerid() {
		return customerid;
	}

	public void setCustomerid(Integer customerid) {
		this.customerid = customerid;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

    public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
	}
}
