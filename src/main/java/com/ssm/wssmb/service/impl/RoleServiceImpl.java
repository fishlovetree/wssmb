package com.ssm.wssmb.service.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.ssm.wssmb.mapper.RoleMapper;
import com.ssm.wssmb.mapper.RoleMenuMapper;
import com.ssm.wssmb.mapper.UserMapper;
import com.ssm.wssmb.model.Role;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.service.MenuService;
import com.ssm.wssmb.service.RoleService;
import com.ssm.wssmb.util.EventLogAspect;

/**
 * @Description:角色接口实现类
 * @Author wys
 * @Time: 2018年1月8日
 */
@Service
public class RoleServiceImpl implements RoleService {
	@Resource
	private RoleMapper roleMapper;
	
	@Resource
	private RoleMenuMapper roleMenuMapper;
	
	@Resource
	private MenuService menuService;
	
	@Resource
	private UserMapper userMapper; 
	
	@Resource
	private EventLogAspect log;


	@Override
	public List<Role> getRoleList(int roletype, String organizationcode) {
		List<Role> list=roleMapper.selectRoleList(roletype, organizationcode);
		return list;
	}

	@Override
	public boolean addRole(Role role) throws Exception {
		int result=roleMapper.insert(role);
		if(result==1) {
			//记录操作日志
	        String content = "角色名称：" + role.getRolename();
	        log.addLog("", "添加角色", content, 0);
			return true;
		}
		else return false;
	}

	@Override
	public boolean editRole(Role role) throws Exception {
		int result=roleMapper.updateByPrimaryKeySelective(role);
		if(result==1) {
			//记录操作日志
	        String content = "角色名称：" + role.getRolename();
	        log.addLog("", "修改角色", content, 2);
			return true;
		}
		else return false;
	}

	@Override
	public boolean deleteRole(Integer id) throws Exception {
		Role role = roleMapper.selectByPrimaryKey(id);
		int result=roleMapper.updateStatus(id, 0);
		if(result==1) {
			//记录操作日志
	        String content = "角色名称：" + role.getRolename();
	        log.addLog("", "删除角色", content, 1);
			return true;
		}
		else return false;
	}

	/**
	 * @Description 根据登录账号获取菜单树以及勾选状态（用于角色管理配置菜单）
	 * @param userid 账号ID，id 角色id，menuType 后台 0，前台1
	 * @param userlevel 0-超级账号,1-普通账号
	 * @return
	 * @throws Exception
	 * @Time 2019年3月29号
	 * @Author hxl
	 */
	@Override
	public List<Map<String, Object>> getRoleMenu(Integer userid, Integer userlevel, Integer id, Integer roletype) {
		Integer[] menuIds=roleMenuMapper.selectByRoleId(id);
		if (1 == roletype){ //前台角色，获取所有前台菜单
			return menuService.getMenuTreeGrid(menuIds, roletype);
		}
		else{ //后台角色，根据登录账号获取其有权限的菜单
			if (0 == userlevel){ //超级账号，获取所有菜单
				return menuService.getMenuTreeGrid(menuIds, roletype);
			}
			else{ //普通账号，获取账号有权限的菜单
				return menuService.getUserMenuJson(userid, menuIds, roletype.toString());
			}
		}
	}

	/**
	 * @Description 设置角色菜单
	 * @param id 角色id，menuIdArray 菜单id集合
	 * @return
	 * @throws Exception
	 * @Time 2019年3月29号
	 * @Author hxl
	 */
	@Override
	public boolean setRoleMenu(Integer id,Integer[] menuIdArray) throws Exception {
		//数据库原来的菜单id数组
		Integer[] oldMenuIds=roleMenuMapper.selectByRoleId(id);
		HashMap<String,List<Integer>> map=getAddAndDelete(menuIdArray, oldMenuIds);	
		//记录操作日志
		Role role = roleMapper.selectByPrimaryKey(id);
		if (null != role){
			//记录操作日志
	        String content = "角色名称：" + role.getRolename();
	        log.addLog("", "设置角色菜单", content, 7);
		}
		return deleteAndAddMenu(map,id);
	}
	
	/**
	 * @Description 获取添加和删除的菜单集合
	 * @param selectMenu
	 * @param oldMenu
	 * @return
	 * @Time 2018年1月10日
	 * @Author wys
	 */
	private HashMap<String,List<Integer>> getAddAndDelete(Integer[] selectMenu,Integer[] oldMenu){
		List<Integer> alist = Arrays.asList(selectMenu);
		List<Integer> dlist= Arrays.asList(oldMenu);
		List<Integer> addList=new LinkedList<Integer>(alist);//要添加的地区id集合
		List<Integer> deleteList=new LinkedList<Integer>(dlist);//要删除的地区id集合
		//去重
		if(null!=selectMenu){
			for(Integer share:selectMenu){
				if(deleteList.contains(share)){
					deleteList.remove(share);
					addList.remove(share);
				}
			}
		}
		HashMap<String,List<Integer>> map = new HashMap<String,List<Integer>>();
		map.put("deleteIdList", deleteList);
		map.put("addIdList",addList);
		return map;		
	}
	
	/**
	 * @Description 删除和添加菜单
	 * @param map
	 * @return
	 * @Time 2018年1月10日
	 * @Author wys
	 */
	private boolean deleteAndAddMenu(HashMap<String,List<Integer>> map,Integer id){
		boolean _Result=true;
		// 返回map, 然后取出list
		List<Integer> deleteList = (List<Integer>) map.get("deleteIdList");
		List<Integer> addList = (List<Integer>) map.get("addIdList");
		//删除菜单
		if(null!=deleteList && deleteList.size()>0) _Result=deleteRoleMenu(deleteList,id);			
		//添加菜单
		if(_Result && null!=addList && addList.size()>0) _Result=addRoleMenu(addList,id);
		return _Result;
		
	}
	
	/**
	 * @Description 删除添加账户
	 * @param map
	 * @param id
	 * @return
	 * @Time 2018年1月12日
	 * @Author wys
	 */
	private boolean deleteAndAddUser(HashMap<String,List<Integer>> map,Integer id){
		boolean _Result=true;
		// 返回map, 然后取出list
		List<Integer> deleteList = (List<Integer>) map.get("deleteIdList");
		List<Integer> addList = (List<Integer>) map.get("addIdList");
		//删除菜单
		if(null!=deleteList && deleteList.size()>0) _Result=deleteRoleUser(deleteList,id);			
		//添加菜单
		if(_Result && null!=addList && addList.size()>0) _Result=addRoleUser(addList,id);
		return _Result;
		
	}
	
	/**
	 * @Description 批量删除角色菜单
	 * @param list
	 * @return
	 * @Time 2018年1月10日
	 * @Author wys
	 */
	private boolean deleteRoleMenu(List<Integer> list,Integer id){
		//批量删除操作
		int result=roleMenuMapper.deleteByList(id, list);
		if(result==list.size()) return true;
		else return false;
	}
	
	/**
	 * @Description 批量删除角色账户
	 * @param list
	 * @param id
	 * @return
	 * @Time 2018年1月12日
	 * @Author wys
	 */
	private boolean deleteRoleUser(List<Integer> list,Integer id){
		//批量删除操作
		int result=roleMapper.deleteByList(id, list);
		if(result==list.size()) return true;
		else return false;
	}
	
	/**
	 * @Description 批量添加角色菜单
	 * @param list
	 * @return
	 * @Time 2018年1月10日
	 * @Author wys
	 */
	private boolean addRoleMenu(List<Integer> list,Integer id){
		//批量插入操作
		int result=roleMenuMapper.insertRolefuns(id, list);
		if(result==list.size()) return true;
		else return false;
	}
	
	/**
	 * @Description 批量添加角色账户
	 * @param list
	 * @param id
	 * @return
	 * @Time 2018年1月12日
	 * @Author wys
	 */
	private boolean addRoleUser(List<Integer> list,Integer id){
		//批量插入操作
		int result=roleMapper.insertRoleUser(id, list);
		if(result==list.size()) return true;
		else return false;
	}

	@Override
	public boolean validateRoleName(String roleName, int id, int roletype) throws Exception {
		int count = roleMapper.selectCountByName(roleName, id, roletype);
		if(count > 0) return false; 
		else return true;
	}

	@Override
	public List<User> getUnUserAdded(int roleid, int roletype, String organizationcode) {
		Integer[] userid=roleMapper.selectUserIdArrayByRoleId(roleid);
		List<User> list=userMapper.selectUsersByArrayOutside(userid, roletype, organizationcode);
		return list;
	}

	@Override
	public List<User> getUserAdded(int roleid) {
		Integer[] userid=roleMapper.selectUserIdArrayByRoleId(roleid);
		if(null!=userid && userid.length>0) return userMapper.selectUsersByArray(userid);
		else return null;
	}

	@Override
	public boolean addRoleUserByList(Integer roleid, Integer[] userIds)
			throws Exception {
		Integer[] oldUserid=roleMapper.selectUserIdArrayByRoleId(roleid);
		HashMap<String,List<Integer>> map=getAddAndDelete(userIds, oldUserid);	
		//记录操作日志
		Role role = roleMapper.selectByPrimaryKey(roleid);
		if (null != role){
			//记录操作日志
	        String content = "角色名称：" + role.getRolename();
	        log.addLog("", "设置角色账号", content, 7);
		}
		return deleteAndAddUser(map, roleid);
	}

	/**
	 * @Description 获取角色特殊权限
	 * 
	 * @param id
	 * @return
	 * @Time 2018年5月4日
	 * @Author hxl
	 */
	@Override
	public List<Integer> getRolePermissions(int id) {
		return roleMapper.selectRolePermissions(id);
	}

	/**
	 * @Description 设置角色特殊权限
	 * 
	 * @param id
	 * @return
	 * @Time 2018年5月4日
	 * @Author hxl
	 */
	@Override
	public String setRolePermissions(int roleid, String permissions) throws Exception {
		boolean _result = deleteRolePermissions(roleid);
		String reusltStr = "";
		if (_result) {
			if (permissions != "") {
				String[] permissionArr = permissions.split(",");
				ArrayList<Integer> permissionList = new ArrayList<Integer>();
				for (int i = 0; i < permissionArr.length; i++) {
					permissionList.add(Integer.valueOf(permissionArr[i]));
				}
				int result = roleMapper.insertRolePermissions(roleid, permissionList);
				if (result > 0){
					//记录操作日志
					Role role = roleMapper.selectByPrimaryKey(roleid);
					if (null != role){
				        String content = "角色名称：" + role.getRolename() + ", 特殊权限：" + permissions;
				        log.addLog("", "设置角色特殊权限", content, 7);
					}
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
	 * @Description 删除角色所有特殊权限
	 * @param list
	 * @return
	 * @Time 2018年5月4日
	 * @Author hxl
	 */
	private boolean deleteRolePermissions(int id) {
		// 批量删除操作
		int result = roleMapper.deleteRolePermissions(id);
		if (result >= 0){
			return true;
		}
		else
			return false;
	}
}
