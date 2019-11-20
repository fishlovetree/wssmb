package com.ssm.wssmb.service.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.subject.Subject;
//import org.apache.shiro.SecurityUtils;
//import org.apache.shiro.authc.AuthenticationException;
//import org.apache.shiro.authc.IncorrectCredentialsException;
//import org.apache.shiro.authc.UnknownAccountException;
//import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ssm.wssmb.util.UsernamePasswordUsertypeToken;
import com.ssm.wssmb.mapper.UserMapper;
import com.ssm.wssmb.model.Role;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.service.RoleService;
import com.ssm.wssmb.service.UserService;
import com.ssm.wssmb.util.EventLogAspect;
import com.ssm.wssmb.util.MD5Util;

@Service
public class UserServiceImpl implements UserService {

	@Resource
	private UserMapper userMapper;

	@Resource
	private RoleService roleService;
	
	@Resource
	private EventLogAspect log;

	@Override
	public boolean ValidateUser(String userlogin, String userpwd, String maxlogintimes)
			throws Exception {
		if (null != userlogin && null != userpwd
				&& !userlogin.trim().equals("") && !userpwd.trim().equals("")) {
			int userType = 1;
			User user = userMapper.selectByUserName(userlogin);
			if (null != user) userType = user.getUsertype();
 			Subject subject = SecurityUtils.getSubject();
			// 验证是否已经登录
			// if(!subject.isAuthenticated()){
			//UsernamePasswordToken token = new UsernamePasswordToken(userlogin,
					//userpwd);
 			UsernamePasswordUsertypeToken token = new UsernamePasswordUsertypeToken(userlogin, MD5Util.MD5(userpwd), 
 					userType == 0 ? "admin" : "front");
 			try {
				//token.setRememberMe(true);  //记住密码
				// 调用subject.login(token)进行登录，会自动委托给securityManager,调用之前
				subject.login(token);
				// 获取同一个账号的所有登录信息
	            //List<Session> loginedList = getLoginedSession(subject);
	            // 超过一定数量剔除其他登录
	            //System.out.println("loginedList:" + loginedList.size());
	            /*if (loginedList.size() >= Integer.parseInt(maxlogintimes)){
	            	loginedList.get(0).stop();
	            }*/
				// 会跳到我们自定义的realm中
			} catch (UnknownAccountException e) {
				//throw new CustomException("用户名错误");
				return false;
			} catch (IncorrectCredentialsException e) {
				//throw new CustomException("密码错误");
				return false;
			} catch (AuthenticationException e) {
				return false;
			}

			// }
			return true;
		} else {
			return false;
		}
	}
	
    //遍历同一个账户的session
    /*private List<Session> getLoginedSession(Subject currentUser) {
        Collection<Session> list = ((DefaultSessionManager) ((DefaultSecurityManager) SecurityUtils
                .getSecurityManager()).getSessionManager()).getSessionDAO()
                .getActiveSessions();
        List<Session> loginedList = new ArrayList<Session>();
        User loginUser = (User) currentUser.getPrincipal();
        //System.out.println("session数量：" + list.size());
        for (Session session : list) {
 
            Subject s = new Subject.Builder().session(session).buildSubject();
 
            if (s.isAuthenticated()) {
                User user = (User) s.getPrincipal();
 
                if (user.getUsername().equalsIgnoreCase(loginUser.getUsername())) {
                    if (!session.getId().equals(
                            currentUser.getSession().getId())) {
                        loginedList.add(session);
                    }
                }
            }
        }
        return loginedList;
    }*/


	@Override
	public User getUserByName(String username) {
		return userMapper.selectByUserName(username);
	}

	/**
	 * @Description 获取账号集合
	 * @return
	 * @Time 2018年1月10日
	 * @Author hxl
	 * @Update hxl 2019-6-25
	 */
	@Override
	public List<User> getUserList(Integer usertype, String organizationcode, String organizationname, String username) {
		return userMapper.selectUserList(usertype, organizationcode, organizationname, username);
	}

	/**
	 * @Description 添加账号
	 * @param organizaiton
	 * @return
	 * @Time 2018年1月10日
	 * @Author hxl
	 */
	@Override
	public String addUser(User user) throws Exception {
		int count = userMapper.selectCountByName(user.getUsername(), 0);
		if (count > 0)
			return "repeat"; // 账号已存在
		user.setPassword(MD5Util.MD5("123456")); // 默认密码是123456的MD5加密
		int result = userMapper.insertSelective(user);
		if (result > 0){
			//记录操作日志
	        String content = "账号：" + user.getUsername();
	        log.addLog("", "添加账号", content, 0);
			return "success";
		}
		else
			return "error";
	}

	/**
	 * @Description 编辑账号
	 * @param organizaiton
	 * @return
	 * @throws Exception
	 * @Time 2018年1月10日
	 * @Author hxl
	 */
	@Override
	public String editUser(User user) throws Exception {
		int count = userMapper.selectCountByName(user.getUsername(),
				user.getId());
		if (count > 0)
			return "repeat"; // 账号已存在
		int result = userMapper.updateByPrimaryKeySelective(user);
		if (result > 0){
			//记录操作日志
	        String content = "账号：" + user.getUsername();
	        log.addLog("", "修改账号", content, 2);
			return "success";
		}
		else
			return "error";
	}

	/**
	 * @Description 通过id删除账号
	 * @param id
	 * @return
	 * @throws Exception
	 * @Time 2018年1月10日
	 * @Author hxl
	 */
	@Override
	public String deleteUser(int id) throws Exception {
		User user = userMapper.selectByPrimaryKey(id);
		int result = userMapper.deleteByPrimaryKey(id);
		if (result > 0){
			//记录操作日志
	        String content = "账号：" + user.getUsername();
	        log.addLog("", "删除账号", content, 1);
			return "success";
		}
		else
			return "error";
	}

	/**
	 * 重置密码
	 * 
	 * @param id
	 * @param username
	 * @return
	 * @throws Exception
	 *             * @Time 2018年1月11日
	 * @Author hxl
	 */
	@Override
	public String resetPassword(int id, String username) throws Exception {
		User user = userMapper.selectByPrimaryKey(id);
		int result = userMapper.resetPassword(MD5Util.MD5("123456"), id);
		if (result > 0){
			//记录操作日志
	        String content = "账号：" + user.getUsername();
	        log.addLog("", "重置密码", content, 2);
			return "success";
		}
		else
			return "error";
	}
	
	/**
	 * 修改密码
	 * @param id
	 * @param username
	 * @return
	 * @throws Exception
	 * * @Time 2018年1月16日
	 * @Author dj
	 */
	@Override
	public String changePassword(String username,String password)throws Exception{
		int result = userMapper.changePassword(MD5Util.MD5(password), username);
		if (result > 0){
			//记录操作日志
	        String content = "账号：" + username;
	        log.addLog("", "修改密码", content, 2);
			return "success";
		}
		else
			return "error";
	}

	/**
	 * 获取用户角色
	 * 
	 * @param id
	 * @return
	 * @Time 2018年1月11日
	 * @Author hxl
	 */
	@Override
	public List<Integer> getUserRoles(int id) {
		return userMapper.selectUserRoles(id);
	}

	/**
	 * 获取所有角色
	 * 
	 * @param id
	 * @return
	 * @Time 2018年1月11日
	 * @Author hxl
	 * @Update hxl 2018-11-27 增加账号类型参数
	 * @Update hxl 2018-12-05 增加组织机构代码参数
	 */
	@Override
	public List<Role> getRoles(int usertype, String organizationcode) {
		return roleService.getRoleList(usertype, organizationcode);
	}

	/**
	 * 添加账号角色
	 * 
	 * @param id
	 * @return
	 * @Time 2018年1月11日
	 * @Author hxl
	 */
	@Override
	public String insertUserRoles(int userid, String roleids) throws Exception {
		User user = userMapper.selectByPrimaryKey(userid);
		boolean _result = deleteUserRoles(userid);
		String reusltStr = "";
		if (_result) {
			if (roleids != "") {
				String[] ids = roleids.split(",");
				ArrayList<Integer> idList = new ArrayList<Integer>();
				for (int i = 0; i < ids.length; i++) {
					idList.add(Integer.valueOf(ids[i]));
				}
				int result = userMapper.insertUserRoles(userid, idList);
				if (result > 0){
					//记录操作日志
			        String content = "账号：" + user.getUsername() + ", 角色：" + roleids;
			        log.addLog("", "添加账号角色", content, 0);
					reusltStr = "success";
				}
				else
					reusltStr = "error";
			}
			else{
				reusltStr = "success";
			}
		} else {
			reusltStr = "error";
		}
		return reusltStr;
	}

	/**
	 * @Description 删除账号所有角色
	 * @param list
	 * @return
	 * @Time 2018年1月10日
	 * @Author wys
	 */
	private boolean deleteUserRoles(int id) {
		// 批量删除操作
		int result = userMapper.deleteUserRoles(id);
		if (result >= 0)
			return true;
		else
			return false;
	}

	@Override
	public String changeTheme(Integer id, String theme) throws Exception {
		User user = userMapper.selectByPrimaryKey(id);
		int result = userMapper.changeTheme(id, theme);
		if (result >= 0){
			//记录操作日志
	        String content = "账号：" + user.getUsername();
	        log.addLog("", "修改主题", content, 2);
			return "success";
		}
		else
			return "error";
	}

	@Override
	public List<User> getUserByOrg(Integer orgid) throws Exception {
		return userMapper.SelectUserByOrg(orgid);
	}
}
