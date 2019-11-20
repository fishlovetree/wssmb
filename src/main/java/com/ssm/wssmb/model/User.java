package com.ssm.wssmb.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

public class User implements Serializable {
	private static final long serialVersionUID = 1L;
	
    private Integer id;

    private String username;

    private String password;

    private String remark;

    private Integer status;
    
    private Integer theme;

    private String organizationcode;
    
    private String organizationname;

    private Integer userLevel;
    
    private String rolename;
    
    private List<Menu> menuList;
    
    private int organizationtype;
    
    private int organizationid;
    
    private String permissions;
    
    private Integer usertype;
    
    private Integer creator;
    
    private String creatorname;
    
    private Date intime;

    public List<Menu> getMenuList() {
		return menuList;
	}

	public void setMenuList(List<Menu> menuList) {
		this.menuList = menuList;
	}

	public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username == null ? null : username.trim();
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password == null ? null : password.trim();
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
    
    public Integer getTheme() {
		return theme;
	}

	public void setTheme(Integer theme) {
		this.theme = theme;
	}

	public String getOrganizationcode() {
        return organizationcode;
    }

    public void setOrganizationcode(String organizationcode) {
        this.organizationcode = organizationcode == null ? null : organizationcode.trim();
    }
    
    public String getOrganizationname() {
        return organizationname;
    }

    public void setOrganizationname(String organizationname) {
        this.organizationname = organizationname == null ? null : organizationname.trim();
    }

    public Integer getUserLevel() {
        return userLevel;
    }

    public void setUserLevel(Integer userLevel) {
        this.userLevel = userLevel;
    }
    
    public String getRolename() {
        return rolename;
    }

    public void setRolename(String rolename) {
        this.rolename = rolename == null ? null : rolename.trim();
    }

	public int getOrganizationtype() {
		return organizationtype;
	}

	public void setOrganizationtype(int organizationtype) {
		this.organizationtype = organizationtype;
	}

	public int getOrganizationid() {
		return organizationid;
	}

	public void setOrganizationid(int organizationid) {
		this.organizationid = organizationid;
	}
    
	public String getPermissions() {
        return permissions;
    }

    public void setPermissions(String permissions) {
        this.permissions = permissions == null ? null : permissions.trim();
    }

	public Integer getUsertype() {
		return usertype;
	}

	public void setUsertype(Integer usertype) {
		this.usertype = usertype;
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
		return "User [id=" + id + ", username=" + username + ", password=" + password + ", remark=" + remark
				+ ", status=" + status + ", theme=" + theme + ", organizationcode=" + organizationcode
				+ ", organizationname=" + organizationname + ", userLevel=" + userLevel + ", rolename=" + rolename
				+ ", menuList=" + menuList + ", organizationtype=" + organizationtype + ", organizationid="
				+ organizationid + ", permissions=" + permissions + ", usertype=" + usertype + ", creator=" + creator
				+ ", creatorname=" + creatorname + ", intime=" + intime + "]";
	}
	
	
}