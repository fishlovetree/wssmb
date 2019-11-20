package com.ssm.wssmb.service;

import java.util.List;

import com.ssm.wssmb.model.Role;
import com.ssm.wssmb.model.User;

public interface UserService {

	/**
	 * @Description 获取账号集合
	 * @return
	 * @Time 2018年1月10日
	 * @Author hxl
	 * @Update hxl 2019-6-25
	 */
	public List<User> getUserList(Integer usertype, String organizationcode, String organizationname, String username);

	/**
	 * @Description 添加账号
	 * @param organizaiton
	 * @return
	 * @Time 2018年1月10日
	 * @Author hxl
	 */
	public String addUser(User user) throws Exception;

	/**
	 * @Description 编辑账号
	 * @param organizaiton
	 * @return
	 * @throws Exception
	 * @Time 2018年1月10日
	 * @Author hxl
	 */
	public String editUser(User user) throws Exception;

	/**
	 * @Description 通过id删除账号
	 * @param id
	 * @return
	 * @throws Exception
	 * @Time 2018年1月10日
	 * @Author hxl
	 */
	public String deleteUser(int id) throws Exception;

	/**
	 * @Description 验证账号
	 * @param id
	 * @return
	 * @throws Exception
	 * @Time 2018年1月10日
	 * @Author hxl
	 */
	public boolean ValidateUser(String userlogin, String userpwd, String maxlogintimes)
			throws Exception;

	/**
	 * @Description 根据账号名获取账号信息
	 * @param id
	 * @return
	 * @throws Exception
	 * @Time 2018年1月10日
	 * @Author hxl
	 */
	public User getUserByName(String userlogin);
	
	/**
	 * 重置密码
	 * @param id
	 * @param username
	 * @return
	 * @throws Exception
	 * @Time 2018年1月11日
	 * @Author hxl
	 */
	public String resetPassword(int id, String username)throws Exception;
	
	/**
	 * 修改密码
	 * @param id
	 * @param username
	 * @return
	 * @throws Exception
	 * * @Time 2018年1月16日
	 * @Author dj
	 */
	public String changePassword(String username,String password)throws Exception;
	
	/**
	 * 获取账号角色
	 * @param id
	 * @return
	 * @Time 2018年1月11日
	 * @Author hxl
	 */
	public List<Integer> getUserRoles(int id);
	
	/**
	 * 获取所有角色
	 * @param id
	 * @return
	 * @Time 2018年1月11日
	 * @Author hxl
	 * @Update hxl 2018-11-27 增加账号类型参数
	 * @Update hxl 2018-12-05 增加组织机构代码参数
	 */
	public List<Role> getRoles(int usertype, String organizationcode);
	
	/**
	 * 添加账号角色
	 * @param id
	 * @return
	 * @Time 2018年1月11日
	 * @Author hxl
	 */
	public String insertUserRoles(int userid, String roleids)throws Exception;

	public String changeTheme(Integer id, String theme)throws Exception;
	
	/**
	 * @Description 根据组织机构id获取账号集合
	 * @return
	 * @Time 2018年6月14日
	 * @Author lmn
	 */
	public List<User> getUserByOrg(Integer orgid)throws Exception;
	
}
