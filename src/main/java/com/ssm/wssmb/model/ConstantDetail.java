package com.ssm.wssmb.model;

public class ConstantDetail {
    private Integer detailid;

    private Integer coding;

    private String detailname;

    private String enname;

    private String detailvalue;

    private Short status;
    
    private Integer parentid;
    
    private Integer parentcoding;
    
    private String parentvalue;
    
    private String parentname;

    public Integer getDetailid() {
        return detailid;
    }

    public void setDetailid(Integer detailid) {
        this.detailid = detailid;
    }

    public Integer getCoding() {
        return coding;
    }

    public void setCoding(Integer coding) {
        this.coding = coding;
    }

    public String getDetailname() {
        return detailname;
    }

    public void setDetailname(String detailname) {
        this.detailname = detailname == null ? null : detailname.trim();
    }

    public String getEnname() {
        return enname;
    }

    public void setEnname(String enname) {
        this.enname = enname == null ? null : enname.trim();
    }

    public String getDetailvalue() {
        return detailvalue;
    }

    public void setDetailvalue(String detailvalue) {
        this.detailvalue = detailvalue == null ? null : detailvalue.trim();
    }

    public Short getStatus() {
        return status;
    }

    public void setStatus(Short status) {
        this.status = status;
    }

	public Integer getParentid() {
		return parentid;
	}

	public void setParentid(Integer parentid) {
		this.parentid = parentid;
	}

	public Integer getParentcoding() {
		return parentcoding;
	}

	public void setParentcoding(Integer parentcoding) {
		this.parentcoding = parentcoding;
	}

	public String getParentvalue() {
		return parentvalue;
	}

	public void setParentvalue(String parentvalue) {
		this.parentvalue = parentvalue;
	}

	public String getParentname() {
		return parentname;
	}

	public void setParentname(String parentname) {
		this.parentname = parentname;
	}

	@Override
	public String toString() {
		return "ConstantDetail [detailid=" + detailid + ", coding=" + coding + ", detailname=" + detailname
				+ ", enname=" + enname + ", detailvalue=" + detailvalue + ", status=" + status + ", parentid="
				+ parentid + ", parentcoding=" + parentcoding + ", parentvalue=" + parentvalue + ", parentname="
				+ parentname + "]";
	}
	
	
}