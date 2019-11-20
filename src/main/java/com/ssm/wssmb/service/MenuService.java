package com.ssm.wssmb.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.ssm.wssmb.model.Menu;


/**
 * @Description:菜单业务接口
 * @Author wys
 * @Time: 2018年1月11日
 */
public interface MenuService {

	/**
	 * @Description 获取菜单集合
	 * @return
	 * @Time 2018年1月11日
	 * @Author wys
	 * @Update 2018-11-23 by hxl
	 */
	public List<Menu> getMenuList(Integer menutype);
	
	/**
	 * @Description 获取菜单树状列表集合
	 * @return
	 * @Time 2018年1月11日
	 * @Author wys
	 * @Update 2018-11-23 by hxl
	 */
	public List<Map<String, Object>> getMenuTreeGrid(Integer menutype);
	
	/**
	 * @Description 获取除了该id菜单及其子菜单的所有菜单
	 * @param id
	 * @return
	 * @Time 2018年1月15日
	 * @Author wys
	 * @Update 2018-11-23 by hxl
	 */
	public List<Map<String, Object>> getMenuTreeGrid(Integer id, Integer menutype);
	
	/**
	 * @Description 获取菜单树以及勾选状态（用于角色管理配置菜单）
	 * @param list
	 * @return
	 * @Time 2018年1月9日
	 * @Author wys
	 * @Update 2018-11-23 by hxl
	 */
	public List<Map<String, Object>> getMenuTreeGrid(Integer[] menuIds, Integer menutype);
	
	/**
	 * @Description 添加菜单
	 * @param menu
	 * @return
	 * @throws Exception
	 * @Time 2018年1月11日
	 * @Author wys
	 */
	public boolean addMenu(Menu menu)throws Exception;
	
	/**
	 * @Description 验证菜单名字是否存在
	 * @param menuName 菜单名称
	 * @param id 菜单id
	 * @param menutype 菜单类型：1-前台菜单，0-后台菜单
	 * @return
	 * @throws Exception
	 * @Time 2018年1月11日
	 * @Author wys
	 */
	public boolean validateMenuName(String menuName, int id, int menutype)throws Exception;
	

	/**
	 * @Description 修改菜单
	 * @param menu
	 * @return
	 * @throws Exception
	 * @Time 2018年1月11日
	 * @Author wys
	 */
	public boolean editMenu(Menu menu)throws Exception;
	

	/**
	 * @Description 修改菜单图标
	 * @param id
	 * @param icon
	 * @return
	 * @throws Exception
	 * @Time 2018年1月11日
	 * @Author wys
	 */
	public boolean editMenuIcon(Integer id,String icon)throws Exception;
	
	/**
	 * @Description 通过id删除菜单
	 * @param id
	 * @return
	 * @throws Exception
	 * @Time 
	 * @Author wys
	 */
	public boolean deleteMenu(Integer id,HttpServletRequest request)throws Exception;
	
	/**
	 * @Description 根据登录账号获取菜单树（用于主页面加载菜单）
	 * @param userid 账号ID, menuType 后台 0，前台1
	 * @return
	 * @throws Exception
	 * @Time 2018年1月30号
	 * @Author hxl
	 */
	public List<Map<String, Object>> getUserMenuJson(Integer userid,String menutype)throws Exception;
	
	/**
	 * @Description 根据登录账号获取菜单树以及勾选状态（用于角色管理配置菜单）
	 * @param userid 账号ID，menuIds 已勾选的菜单id，menuType 后台 0，前台1
	 * @return
	 * @throws Exception
	 * @Time 2019年3月29号
	 * @Author hxl
	 */
	List<Map<String, Object>> getUserMenuJson(Integer userid, Integer[] menuIds, String menutype);
	
	/**
	 * @Description 根据账号获取菜单集合（用于权限判断）
	 * @param userid 账号ID
	 * @return
	 * @throws Exception
	 * @Time 2018年7月25号
	 * @Author hxl
	 */
	public List<Menu> getUserMenuList(Integer userid, String menutype)throws Exception;
	
	/**
	 * @Description 获取图标集合
	 * @param request
	 * @return
	 * @throws Exception
	 * @Time 2018年1月10日
	 * @Author wys
	 */
	public List<Map<String, String>> getIconList(HttpServletRequest request)throws Exception;
}
