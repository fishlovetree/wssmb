package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.Role;

/**
 * @Description:角色管理
 * @Author hxl
 * @Time: 2019年8月30日
 */
public interface RoleMapper {
	
    int deleteByPrimaryKey(Integer id);

    int insert(Role record);

    int insertSelective(Role record);

    Role selectByPrimaryKey(Integer id);
    
    /**
     * @Description 通过名字查询角色数量
     * @param rolename
     * @return
     * @Time 2018年1月11日
     * @Author wys
     * @Update by hxl 2018-11-27
     */
    public int selectCountByName(@Param(value="rolename")String rolename, @Param(value="id")Integer id, 
    		@Param(value="roletype")Integer roletype);
    
    /**
     * @Description 根据角色类型查询所有角色
     * @return
     * @Time 2018年1月8日
     * @Author wys
     * @Update hxl 2018-11-27 增加角色类型参数
	 * @Update hxl 2018-12-05 增加组织机构代码参数
     */
    public List<Role> selectRoleList(@Param(value="roletype")Integer roletype, @Param(value="organizationcode")String organizationcode);
    
    /**
     * @Description 通过roleid查询拥有该权限的userid数组
     * @param roleid
     * @return
     * @Time 2018年1月12日
     * @Author wys
     */
    public Integer[] selectUserIdArrayByRoleId(Integer roleid);
    
    /**
     * @Description 通过list数组批量插入
     * @param roleid
     * @param list
     * @return
     * @Time 2018年1月12日
     * @Author wys
     */
    public int insertRoleUser(@Param(value="roleid") Integer roleid,@Param(value="list") List<Integer> list);
    
    /**
     * @Description 批量删除
     * @param roleid
     * @param list
     * @return
     * @Time 2018年1月10日
     * @Author wys
     */
    public int deleteByList(@Param(value="roleid") Integer roleid,@Param(value="list") List<Integer> list);

    int updateByPrimaryKeySelective(Role record);

    int updateByPrimaryKey(Role record);
    
    /**
     * @Description 通过角色id修改角色状态
     * @param id
     * @param status
     * @return
     * @Time 2018年1月12日
     * @Author wys
     */
    int updateStatus(@Param(value="id") Integer id,@Param(value="status") Integer status);
    
    /**
     * @Description 获取角色特殊权限
     * @param id
     * @return
     * @Time 2018年5月4日
     * @Author hxl
     */
    List<Integer> selectRolePermissions(int id);
    
    int deleteRolePermissions(int id);
    
    int insertRolePermissions(@Param(value = "roleid")int roleid, @Param(value = "permissions")List<Integer> permissions);
}