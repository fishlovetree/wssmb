package com.ssm.wssmb.model;

/**
 * @Description:菜单角色关联表
 * @Author wys
 * @Time: 2018年1月11日
 */
public class RoleMenuKey {
    private Integer roleid;

    private Integer menuid;

    public Integer getRoleid() {
        return roleid;
    }

    public void setRoleid(Integer roleid) {
        this.roleid = roleid;
    }

    public Integer getMenuid() {
        return menuid;
    }

    public void setMenuid(Integer menuid) {
        this.menuid = menuid;
    }
}