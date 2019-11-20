package com.ssm.wssmb.model;

import java.io.Serializable;

import org.hibernate.validator.constraints.NotEmpty;


/**
 * @Description:菜单实体类
 * @Author wys
 * @Time: 2018年1月11日
 */
public class Menu implements Serializable {
	private static final long serialVersionUID = 1L;
	
    private Integer id;
    
    @NotEmpty(message="Enter_Menu_Name")
    private String menuname;

    private String menuenname;

    /**
     * 菜单指向链接
     */
    private String menuurl;

    private Integer menuorder;

    /**
     * 菜单上级id
     */
    private Integer superid;

    private String menuicon;

    private Integer status;
    
    private Integer menutype;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getMenuname() {
        return menuname;
    }

    public void setMenuname(String menuname) {
        this.menuname = menuname == null ? null : menuname.trim();
    }

    public String getMenuenname() {
        return menuenname;
    }

    public void setMenuenname(String menuenname) {
        this.menuenname = menuenname == null ? null : menuenname.trim();
    }

    public String getMenuurl() {
        return menuurl;
    }

    public void setMenuurl(String menuurl) {
        this.menuurl = menuurl == null ? null : menuurl.trim();
    }

    public Integer getMenuorder() {
        return menuorder;
    }

    public void setMenuorder(Integer menuorder) {
        this.menuorder = menuorder;
    }

    public Integer getSuperid() {
        return superid;
    }

    public void setSuperid(Integer superid) {
        this.superid = superid;
    }

    public String getMenuicon() {
        return menuicon;
    }

    public void setMenuicon(String menuicon) {
        this.menuicon = menuicon == null ? null : menuicon.trim();
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

	public Integer getMenutype() {
		return menutype;
	}

	public void setMenutype(Integer menutype) {
		this.menutype = menutype;
	}
}