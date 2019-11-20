package com.ssm.wssmb.model;

public class OrgAndCustomer {
	private Integer id;
	
    private String code;

    private String name;

    private Integer parentid;

    private Integer type;
    
    private String unitnature;

    private String unitcategory;

    private String industry;
    
    private String parentcode;
    
    public Integer getId(){
    	return id;
    }
    
    public void setId(Integer id){
    	this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code == null ? null : code.trim();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public Integer getParentid() {
        return parentid;
    }

    public void setParentid(Integer parentid) {
        this.parentid = parentid;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

	public String getUnitnature() {
		return unitnature;
	}

	public void setUnitnature(String unitnature) {
		this.unitnature = unitnature;
	}

	public String getUnitcategory() {
		return unitcategory;
	}

	public void setUnitcategory(String unitcategory) {
		this.unitcategory = unitcategory;
	}

	public String getIndustry() {
		return industry;
	}

	public void setIndustry(String industry) {
		this.industry = industry;
	}

	public String getParentcode() {
		return parentcode;
	}

	public void setParentcode(String parentcode) {
		this.parentcode = parentcode;
	}

}