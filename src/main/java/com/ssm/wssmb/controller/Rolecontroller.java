package com.ssm.wssmb.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

//import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.ssm.wssmb.model.Role;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.service.RoleService;
import com.ssm.wssmb.service.UntilService;
import com.ssm.wssmb.util.CustomException;

/**
 * @Description:角色控制器
 * @Author wys
 * @Time: 2018年1月8日
 */
@Controller
@RequestMapping(value="/sysRole")
public class Rolecontroller {	
	@Resource
	private RoleService roleService;
	
	@Resource
	private UntilService untilService;
	
	/**
	 * @Description 后台角色页面
	 * @return
	 * @Time 2018年1月9日
	 * @Author wys
	 */
	@RequestMapping(value="/rolePage")
//	@RequiresPermissions("sysRole:rolePage")
	public ModelAndView rolePage(){
		ModelAndView mv = new ModelAndView();
		mv.setViewName("System/RolePage");
		return  mv;
	}
	
	/**
	 * @Description 前台角色页面
	 * @return
	 * @Time 2018年11月27日
	 * @Author hxl
	 */
	@RequestMapping(value="/frontRolePage")
//	@RequiresPermissions("sysRole:frontRolePage")
	public ModelAndView frontRolePage(){
		ModelAndView mv = new ModelAndView();
		mv.setViewName("System/FrontRolePage");
		return  mv;
	}
	
	/**
	 * @Description 通过角色id获取功能菜单
	 * @param id
	 * @return
	 * @throws Exception
	 * @Time 2018年1月9日
	 * @Author wys
	 */
	@RequestMapping(value="/menuTreeGrid",produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<Map<String, Object>> menuTreeGrid(HttpServletRequest req, int id, Integer roletype) throws Exception {
		User user = (User) req.getSession(true).getAttribute("user");
		List<Map<String, Object>> menuMapList = roleService.getRoleMenu(user.getId(), user.getUserLevel(), id, roletype);
		return menuMapList;
		
	}
	/**
	 * @Description 获取角色管理列表
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time 2018年1月8日
	 * @Author wys
	 */
	@RequestMapping(value="/roleDataGrid",method=RequestMethod.POST,produces = "text/html;charset=UTF-8;")
	public  @ResponseBody String roleDataGrid(HttpServletRequest req, int roletype) throws Exception{
		// 当前页
		String page = req.getParameter("page");
		// 每页的条数
		String rows = req.getParameter("rows");
		//根据登录账号获取本组织机构或者下级组织机构的角色
		User user = (User) req.getSession(true).getAttribute("user");
		List<Role> list=roleService.getRoleList(roletype, user == null ? null : user.getOrganizationcode());
		return untilService.getDataPager(list, Integer.parseInt(page),
				Integer.parseInt(rows));	
	} 
	
	/**
	 * @Description 添加角色
	 * @param role
	 * @param bindingResult
	 * @return
	 * @throws Exception
	 * @Time 2018年1月8日
	 * @Author wys
	 */
	@RequestMapping(value="/addRole",method=RequestMethod.POST,produces = "text/html;charset=UTF-8;")
	public @ResponseBody String addRole(@Validated Role role,BindingResult bindingResult,HttpServletRequest request) throws Exception{
		//实体类效验
		if (bindingResult.hasErrors()) {
			List<ObjectError> list = bindingResult.getAllErrors();
			if(null!=list && list.size()>0)
				throw new CustomException(list.get(0).getDefaultMessage());
		}
		//判断角色名字唯一性
		/*boolean nameFalg=roleService.validateRoleName(role.getRolename(), 0, role.getRoletype());
		if(!nameFalg){
			return "repeat";
		} */
		if(role.getStatus()==null) role.setStatus(1);//默认状态为1
		//根据登录账号获取创建人
		User user = (User) request.getSession(true).getAttribute("user");
		if (null != user){
			role.setCreator(user.getId());
		}
		boolean falg=roleService.addRole(role);
		if(falg==true){
			return "success";
		}else{
			return "error";
		}				
	}
	
	/**
	 * @Description 编辑角色
	 * @param role
	 * @return
	 * @throws Exception
	 * @Time 2018年1月8日
	 * @Author wys
	 */
	@RequestMapping(value="/editRole",method=RequestMethod.POST,produces = "text/html;charset=UTF-8;")
	public @ResponseBody String editRole(Role role,HttpServletRequest request) throws Exception{
		/*boolean nameFalg = roleService.validateRoleName(role.getRolename(), role.getId(), role.getRoletype());
		if(!nameFalg){
			return "repeat";
		} */
		boolean falg=roleService.editRole(role);
		if(falg==true){
			return "success";
		}else{
			return "error";
		}				
	}
	/**
	 * @Description 删除角色
	 * @param id
	 * @return
	 * @throws Exception
	 * @Time 2018年1月8日
	 * @Author wys
	 */
	@RequestMapping(value="/deleteRole",method=RequestMethod.POST,produces = "text/html;charset=UTF-8;")
	public @ResponseBody String deleteRole(int id) throws Exception{
		boolean falg=roleService.deleteRole(id);
		if(falg==true){
			return "success";
		}else{
			return "error";
		}				
	}
	
	/**
	 * @Description 保存角色的菜单
	 * @param id
	 * @param menuIdStr 菜单id字符串，用逗号分割
	 * @return
	 * @throws Exception
	 * @Time 2018年1月10日
	 * @Author wys
	 */
	@RequestMapping(value="/saveMenu",method=RequestMethod.POST,produces = "text/html;charset=UTF-8;")
	public @ResponseBody String saveMenu(int id,Integer[] menuIdArray) throws Exception{
		boolean falg=roleService.setRoleMenu(id, menuIdArray);
		if(falg==true){
			return "success";
		}else{
			return "error";
		}	
	
	}
	
	/**
	 * @Description 获取角色未添加账户
	 * @param roleid
	 * @return
	 * @throws Exception
	 * @Time 2018年1月12日
	 * @Author wys
	 * @Update hxl 2018-11月-日 增加角色类型参数
	 */
	@RequestMapping(value="/getUnUserAdded",produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<User> getUnUserAdded(HttpServletRequest req, int roleid, int roletype) throws Exception {
		//根据登录账号获取本组织机构或者下级组织机构的未绑定角色的账号
		User user = (User) req.getSession(true).getAttribute("user");
		List<User> userList = roleService.getUnUserAdded(roleid, roletype, user == null ? null : user.getOrganizationcode());
		return userList;
		
	}
	
	/**
	 * @Description 获取角色已添加账户
	 * @param roleid
	 * @return
	 * @throws Exception
	 * @Time 2018年1月12日
	 * @Author wys
	 */
	@RequestMapping(value="/getUserAdded",produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<User> getUserAdded(int roleid) throws Exception {
		List<User> userList = roleService.getUserAdded(roleid);
		return userList;
	}
	
	/**
	 * @Description 设置角色的账户
	 * @param array
	 * @param roleid
	 * @return
	 * @throws Exception
	 * @Time 2018年1月12日
	 * @Author wys
	 */
	@RequestMapping(value="/setUser",produces = "text/html;charset=UTF-8;")
	public @ResponseBody String setUser(Integer[] array,int roleid) throws Exception {
		boolean falg = roleService.addRoleUserByList(roleid, array);
		if(falg) return "success";
		else return "error";
	}

	/**
	 * @Description 获取角色特殊权限
	 * 
	 * @param id
	 * @return
	 * @Time 2018年5月4日
	 * @Author hxl
	 */
	@RequestMapping(value="/getRolePermissions",produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<Integer> getRolePermissions(int id) throws Exception {	
		return roleService.getRolePermissions(id);
	}
	
	/**
	 * @Description 设置角色特殊权限
	 * 
	 * @param id
	 * @return
	 * @Time 2018年5月4日
	 * @Author hxl
	 */
	@RequestMapping(value="/setRolePermissions", produces = "text/html;charset=UTF-8;")
	public @ResponseBody String setRolePermissions(int id, String permissions) throws Exception {	
		return roleService.setRolePermissions(id, permissions);	
	}
}
