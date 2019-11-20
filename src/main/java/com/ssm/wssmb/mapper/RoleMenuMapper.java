package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.RoleMenuKey;

public interface RoleMenuMapper {
    int deleteByPrimaryKey(RoleMenuKey key);

    int insert(RoleMenuKey record);

    int insertSelective(RoleMenuKey record);
    
    /**
     * @Description 通过角色id查询拥有的菜单id数组
     * @param roleid
     * @return
     * @Time 2018年1月9日
     * @Author wys
     */
    public Integer[] selectByRoleId(Integer roleid);
    
    /**
     * @Description 批量插入
     * @param roleid
     * @param list
     * @return
     * @Time 2018年1月10日
     * @Author wys
     */
    public int insertRolefuns(@Param(value="roleid") Integer roleid,@Param(value="list") List<Integer> list);
    
    /**
     * @Description 批量删除
     * @param roleid
     * @param list
     * @return
     * @Time 2018年1月10日
     * @Author wys
     */
    public int deleteByList(@Param(value="roleid") Integer roleid,@Param(value="list") List<Integer> list);
}