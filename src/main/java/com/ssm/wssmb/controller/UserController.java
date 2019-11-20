package com.ssm.wssmb.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
//import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.ssm.wssmb.model.Role;
import com.ssm.wssmb.model.TreeNode;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.service.CommonTreeService;
import com.ssm.wssmb.service.UntilService;
import com.ssm.wssmb.service.UserService;
import com.ssm.wssmb.util.MD5Util;
import com.ssm.wssmb.util.TreeNodeLevel;

@Controller
@RequestMapping(value="/user")
public class UserController {
	
	@Resource
    private UserService userService;
	
	@Resource
	private UntilService untilService;
	
	@Resource
	private CommonTreeService commonTreeService;
	
	/**
	 * @Description 后台账号页面
	 * @return
	 * @throws Exception
	 * @Time 2018年1月11日
	 * @Author hxl
	 * @Update hxl 2018-11-27
	 */
	@RequestMapping(value="/index")
  	@RequiresPermissions("user:index")
	public ModelAndView index(HttpServletRequest req, HttpServletResponse response){
		ModelAndView mv = new ModelAndView();
		mv.setViewName("System/User");
		//根据登录账号获取本组织机构或下级组织机构的角色
		User user = (User) req.getSession(true).getAttribute("user");
		List<Role> roleList = userService.getRoles(0, user == null ? null : user.getOrganizationcode()); //后台账号类型为0
		mv.addObject("roleList", roleList);
		return  mv;
	}
	
	/**
	 * @Description 前台账号页面
	 * @return
	 * @throws Exception
	 * @Time 2018年11月27日
	 * @Author hxl
	 */
	@RequestMapping(value="/frontIndex")
 	@RequiresPermissions("user:frontIndex")
	public ModelAndView frontIndex(HttpServletRequest req, HttpServletResponse response){
		ModelAndView mv = new ModelAndView();
		mv.setViewName("System/FrontUser");
		//根据登录账号获取本组织机构或下级组织机构的角色
		User user = (User) req.getSession(true).getAttribute("user");
		List<Role> roleList = userService.getRoles(1, user == null ? null : user.getOrganizationcode()); //前台账号类型为1
		mv.addObject("roleList", roleList);
		return  mv;
	}
	
	/**
	 * @Description 获取账号列表
	 * @return
	 * @throws Exception
	 * @Time 2018年1月11日
	 * @Author hxl
	 */
	@RequestMapping(value="/userDataGrid", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String userDataGrid(HttpServletRequest req, int usertype, String organizationname, String username) throws Exception {	
		// 当前页
		String page = req.getParameter("page");
		// 每页的条数
		String rows = req.getParameter("rows");
		//根据登录账号获取同级或下级账号
		User user = (User) req.getSession(true).getAttribute("user");
		List<User> list = userService.getUserList(usertype, user == null ? null : user.getOrganizationcode(), organizationname, username);
		return untilService.getDataPager(list, Integer.parseInt(page),
				Integer.parseInt(rows));
	}
	
	/**
	 * @Description 添加账号
	 * @param organization
	 * @return
	 * @throws Exception
	 * @Time 2018年1月11日
	 * @Author hxl
	 */
	@RequestMapping(value="/addUser",method=RequestMethod.POST,produces = "text/html;charset=UTF-8;")
	public @ResponseBody String addUser(HttpServletRequest req, User user) throws Exception {
		User loginUser = (User) req.getSession(true).getAttribute("user");
		if (null != loginUser){
			user.setCreator(loginUser.getId());
		}
		return userService.addUser(user);		
	}
	
	/**
	 * @Description 编辑账号
	 * @param organization
	 * @return
	 * @throws Exception
	 * @Time 2018年1月11日
	 * @Author hxl
	 */
	@RequestMapping(value="/editUser",method=RequestMethod.POST,produces = "text/html;charset=UTF-8;")
	public @ResponseBody String editUser(User user) throws Exception{
		return userService.editUser(user);		
	}
	
	/**
	 * @Description 通过id删除账号
	 * @param id
	 * @return
	 * @throws Exception
	 * @Time 2018年1月11日
	 * @Author hxl
	 */
	@RequestMapping(value="/deleteUser",method=RequestMethod.POST,produces = "text/html;charset=UTF-8;")
	public @ResponseBody String deleteUser(int id) throws Exception{
		return userService.deleteUser(id);			
	}
	
	/**
	 * 重置密码
	 * @param id
	 * @param username
	 * @return
	 * @throws Exception
	 * * @Time 2018年1月11日
	 * @Author hxl
	 */
	@RequestMapping(value="/resetPassword",method=RequestMethod.POST,produces = "text/html;charset=UTF-8;")
	public @ResponseBody String resetPassword(int id, String username)throws Exception{
		return userService.resetPassword(id, username);
	}
	
	/**
	 * 修改密码
	 * @param id
	 * @param username
	 * @return
	 * @throws Exception
	 * * @Time 2018年1月16日
	 * @Author dj
	 * @type 后端方法
	 */
	@RequestMapping(value="/changePassword",method=RequestMethod.POST,produces = "text/html;charset=UTF-8;")
	public @ResponseBody String changePassword(HttpServletRequest req,String name,String oldpassword,String password)throws Exception{
		User user= (User) req.getSession().getAttribute("user");
		if(oldpassword.equals(password)){
			return "The new password cannot be equal to the old password!";
		}
		if(name.equals(user.getUsername()) && MD5Util.MD5(oldpassword).equals(user.getPassword())){
			return userService.changePassword(name, password);
		}
		else
			return "Old Password is wrong!";
	}
	
	/**
	 * @Description 获取账号角色
	 * @return
	 * @throws Exception
	 * @Time 2018年1月11日
	 * @Author hxl
	 */
	@RequestMapping(value="/getUserRoles",produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<Integer> getUserRoles(int id) throws Exception {	
		return userService.getUserRoles(id);	
	}
	
	/**
	 * @Description 保存账号角色
	 * @return
	 * @throws Exception
	 * @Time 2018年1月11日
	 * @Author hxl
	 */
	@RequestMapping(value="/saveUserRoles", produces = "text/html;charset=UTF-8;")
	public @ResponseBody String saveUserRoles(int id, String roles) throws Exception {	
		return userService.insertUserRoles(id, roles);	
	}
	
	/**
	 * 修改主题
	 * @param theme
	 * @return
	 * @throws Exception
	 * * @Time 2018年6月1日
	 * @Author dj
	 * @type 后端方法
	 */
	@RequestMapping(value="/changeTheme",method=RequestMethod.POST,produces = "text/html;charset=UTF-8;")
	public @ResponseBody String changeTheme(HttpServletRequest req,String theme)throws Exception{
		User user= (User) req.getSession().getAttribute("user");
		if(Integer.parseInt(theme)==user.getTheme()){
			return "1";
		}
		else{
			user.setTheme(Integer.parseInt(theme));
			req.getSession().setAttribute("user", user);//更新session
			
			return userService.changeTheme(user.getId(), theme);
		}
	}
	
	/**
	 * 获取主题
	 * @param theme
	 * @return
	 * @throws Exception
	 * * @Time 2018年6月1日
	 * @Author dj
	 * @type 后端方法
	 */
	@RequestMapping(value="/getTheme",method=RequestMethod.POST,produces = "text/html;charset=UTF-8;")
	public @ResponseBody String getTheme(HttpServletRequest req)throws Exception{
		User user= (User) req.getSession().getAttribute("user");
		String theme="1";
		if(user!=null)
			theme=user.getTheme().toString();
		return theme;
	}
	
	/**
	 * @Description 根据组织机构id获取账号列表
	 * @return
	 * @throws Exception
	 * @Time 2018年6月14日
	 * @Author lmn
	 */
	@RequestMapping(value="/getUserByOrg",produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<User> getUserByOrg(HttpServletRequest re,Integer orgid) throws Exception {	
		return userService.getUserByOrg(orgid);	
	}
}
