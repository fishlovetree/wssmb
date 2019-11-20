package com.ssm.wssmb.model;

import java.util.Date;

/**
 * @Description: 角色实体类
 * @Author wys
 * @Time: 2018年1月8日
 */
public class Role {
    private Integer id;

    private String rolename;

    private String remark;

    private Integer status;
    
    private Integer roletype;
    
    private Integer creator;
    
    private String creatorname;
    
    private Date intime;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getRolename() {
        return rolename;
    }

    public void setRolename(String rolename) {
        this.rolename = rolename == null ? null : rolename.trim();
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark == null ? null : remark.trim();
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

	public Integer getRoletype() {
		return roletype;
	}

	public void setRoletype(Integer roletype) {
		this.roletype = roletype;
	}

	public Integer getCreator() {
		return creator;
	}

	public void setCreator(Integer creator) {
		this.creator = creator;
	}

	public String getCreatorname() {
		return creatorname;
	}

	public void setCreatorname(String creatorname) {
		this.creatorname = creatorname;
	}

	public Date getIntime() {
		return intime;
	}

	public void setIntime(Date intime) {
		this.intime = intime;
	}

	@Override
	public String toString() {
		return "Role [id=" + id + ", rolename=" + rolename + ", remark=" + remark + ", status=" + status + ", roletype="
				+ roletype + ", creator=" + creator + ", creatorname=" + creatorname + ", intime=" + intime + "]";
	}
	
}