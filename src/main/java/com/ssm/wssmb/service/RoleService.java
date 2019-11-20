package com.ssm.wssmb.service;

import java.util.List;
import java.util.Map;

import com.ssm.wssmb.model.Role;
import com.ssm.wssmb.model.User;

/**
 * @Description:角色业务接口
 * @Author wys
 * @Time: 2018年1月8日
 */
public interface RoleService {
	/**
	 * @Description 获取角色集合
	 * @return
	 * @Time 2018年1月8日
	 * @Author wys
	 * @Update hxl 2018-11-27 增加角色类型参数
	 * @Update hxl 2018-12-05 增加组织机构代码参数
	 */
	public List<Role> getRoleList(int roletype, String organizationcode);
	
	/**
	 * @Description 添加角色
	 * @param role
	 * @return
	 * @throws Exception
	 * @Time 2018年1月8日
	 * @Author wys
	 */
	public boolean addRole(Role role)throws Exception;
	
	/**
	 * @Description 验证名字是否可用
	 * @param roleName
	 * @return
	 * @throws Exception
	 * @Time 2018年1月11日
	 * @Author wys
	 * @Update by hxl 2018-11-27
	 */
	public boolean validateRoleName(String roleName, int id, int roletype)throws Exception;
	
	/**
	 * @Description 编辑角色
	 * @param role
	 * @return
	 * @throws Exception
	 * @Time 2018年1月8日
	 * @Author wys
	 */
	public boolean editRole(Role role)throws Exception;
	
	/**
	 * @Description 删除密码
	 * @param id
	 * @return
	 * @throws Exception
	 * @Time 2018年1月8日
	 * @Author wys
	 */
	public boolean deleteRole(Integer id)throws Exception;
	
	/**
	 * @Description 根据登录账号获取菜单树以及勾选状态（用于角色管理配置菜单）
	 * @param userid 账号ID，id 角色id，roletype 后台 0，前台1
	 * @param userlevel 0-超级账号,1-普通账号
	 * @return
	 * @throws Exception
	 * @Time 2019年3月29号
	 * @Author hxl
	 */
	public List<Map<String, Object>> getRoleMenu(Integer userid, Integer userlevel, Integer id, Integer roletype);
	
	/**
	 * @Description 设置角色菜单
	 * @param id
	 * @param menuIdArray 选择的菜单
	 * @return
	 * @throws Exception
	 * @Time 2018年1月10日
	 * @Author wys
	 */
	public boolean setRoleMenu(Integer id,Integer[] menuIdArray)throws Exception;
	
	/**
	 * @Description 获取角色的未添加账户
	 * @param roleid
	 * @return
	 * @Time 2018年1月12日
	 * @Author wys
	 * @Update hxl 2018-11-27 增加角色类型参数
	 * @Update hxl 2018-12-05 增加组织机构代码参数
	 */
	public List<User> getUnUserAdded(int roleid, int roletype, String organizationcode);
	
	/**
	 * @Description 获取角色已添加账户
	 * @param roleid
	 * @return
	 * @Time 2018年1月12日
	 * @Author wys
	 */
	public List<User> getUserAdded(int roleid);
	
	/**
	 * @Description roleUser关联表批量插入
	 * @param roleid
	 * @param userIds
	 * @return
	 * @throws Exception
	 * @Time 2018年1月12日
	 * @Author wys
	 */
	public boolean addRoleUserByList(Integer roleid,Integer[] userIds)throws Exception;
	
	/**
	 * @Description 获取角色特殊权限
	 * 
	 * @param id
	 * @return
	 * @Time 2018年5月4日
	 * @Author hxl
	 */
	List<Integer> getRolePermissions(int id);
	
	/**
	 * @Description 设置角色特殊权限
	 * 
	 * @param id
	 * @return
	 * @Time 2018年5月4日
	 * @Author hxl
	 */
	String setRolePermissions(int roleid, String permissions) throws Exception;
}
