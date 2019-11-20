package com.ssm.wssmb.model;

import java.util.Date;

public class Organization {
    private Integer organizationid;

    private String organizationcode;

    private String organizationname;

    private Integer parentid;

    private Integer status;
    
    private Integer compactor;

    private Date compilationtime;

    public Integer getOrganizationid() {
        return organizationid;
    }

    public void setOrganizationid(Integer organizationid) {
        this.organizationid = organizationid;
    }

    public String getOrganizationcode() {
        return organizationcode;
    }

    public void setOrganizationcode(String organizationcode) {
        this.organizationcode = organizationcode;
    }

    public String getOrganizationname() {
        return organizationname;
    }

    public void setOrganizationname(String organizationname) {
        this.organizationname = organizationname == null ? null : organizationname.trim();
    }

    public Integer getParentid() {
        return parentid;
    }

    public void setParentid(Integer parentid) {
        this.parentid = parentid;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

	public Integer getCompactor() {
		return compactor;
	}

	public void setCompactor(Integer compactor) {
		this.compactor = compactor;
	}

	public Date getCompilationtime() {
		return compilationtime;
	}

	public void setCompilationtime(Date compilationtime) {
		this.compilationtime = compilationtime;
	}
}