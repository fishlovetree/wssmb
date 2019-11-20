package com.ssm.wssmb.service.impl;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.DefaultResourceLoader;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Service;
import org.springframework.util.ResourceUtils;
import org.springframework.web.servlet.support.RequestContext;

import com.ssm.wssmb.mapper.MenuMapper;
import com.ssm.wssmb.model.Menu;
import com.ssm.wssmb.service.MenuService;
import com.ssm.wssmb.service.UntilService;
import com.ssm.wssmb.util.CustomException;
import com.ssm.wssmb.util.EventLogAspect;

/**
 * @Description:菜单业务接口实现类
 * @Author wys
 * @Time: 2018年1月11日
 */
@Service
public class MenuServiceImpl implements MenuService {
	@Resource
	private MenuMapper menuMapper;
	
	@Resource
	private UntilService untilService;
	
	@Resource
	private EventLogAspect log;
	
	/**
	 * @Description 获取菜单集合
	 * @return
	 * @Time 
	 * @Author wys
	 */
	@Override
	public List<Menu> getMenuList(Integer menutype) {
		List<Menu> menu=menuMapper.selectMenuList(menutype);
		return menu;
	}
	
	/**
	 * @Description 获取菜单树状列表集合
	 * @return
	 * @Time 2018年1月11日
	 * @Author wys
	 * @Update 2018-11-23 by hxl
	 */
	@Override
	public List<Map<String, Object>> getMenuTreeGrid(Integer menutype) {
		List<Menu> menus = getMenuList(menutype);
		List<Map<String, Object>> menuList=null;
		if(null!=menus && menus.size()>0){
			orderMenu(menus);
			menuList=createTreeGrid(menus,0);
		}
			
		return menuList;
	}
	
	/**
	 * @Description 获取除了该id菜单及其子菜单的所有菜单
	 * @param id
	 * @return
	 * @Time 2018年1月15日
	 * @Author wys
	 * @Update 2018-11-23 by hxl
	 */
	@Override
	public List<Map<String, Object>> getMenuTreeGrid(Integer id, Integer menutype) {
		List<Menu> menus = menuMapper.selectOtherMenuListById(id, menutype);
		List<Map<String, Object>> menuList=null;
		if(null!=menus && menus.size()>0){
			orderMenu(menus);
			menuList=createTreeGrid(menus,0);
		}
			
		return menuList;
	}
	
	/**
	 * @Description 获取菜单树以及勾选状态（用于角色管理配置菜单）
	 * @param list
	 * @return
	 * @Time 2018年1月9日
	 * @Author wys
	 * @Update 2018-11-23 by hxl
	 */
	@Override
	public List<Map<String, Object>> getMenuTreeGrid(Integer[] menuIds, Integer menutype) {
		List<Menu> menus = getMenuList(menutype);
		List<Map<String, Object>> menuList=null;
		if(null!=menus && menus.size()>0){
			orderMenu(menus);
			if(null!=menuIds && menuIds.length>0) menuList=createTreeGrid(menus,0,menuIds);
			else menuList=createTreeGrid(menus,0);			
		}			
		return menuList;
	}
	
	
	/**
	 * @Description 菜单排序
	 * @param list
	 * @Time 2018年1月11日
	 * @Author wys
	 */
	private void orderMenu(List<Menu> list){
		Collections.sort(list, new Comparator<Menu>() {
			@Override
			public int compare(Menu o1, Menu o2) {
				if (o1 == null && o2 == null) {
	                return 0;
	            }
	            if (o1 == null) {
	                return 1;
	            }
	            if (o2 == null) {
	                return -1;
	            }
	            if (o1.getMenuorder() == null && o2.getMenuorder() == null) {
	                return 0;
	            }
	            if (o1.getMenuorder() == null) {
	                return 1;
	            }
	            if (o2.getMenuorder() == null) {
	                return -1;
	            }
	            return o1.getMenuorder().compareTo(o2.getMenuorder());      
			}
		});
	}

	/**
	 * @Description 获取菜单树状列表集合
	 * @param list
	 * @param fid 顶级菜单父id默认为0
	 * @return
	 * @Time 2018年1月11日
	 * @Author wys
	 */
	private List<Map<String, Object>> createTreeGrid(List<?> list,int fid) {
		List<Map<String, Object>> treeGridList = createTreeGridChildren(list, 0);
		return treeGridList;
	}
	
	/**
	 * @Description 获取菜单树集合(复选框选中)
	 * @param list
	 * @param fid
	 * @param menuIds
	 * @return
	 * @Time 2018年1月9日
	 * @Author wys
	 */
	private List<Map<String, Object>> createTreeGrid(List<?> list,int fid,Integer[] menuIds) {
		List<Map<String, Object>> treeGridList = createTreeGridChildren(list, 0,menuIds);
		return treeGridList;
	}
	/**
	 * @Description 获取菜单树状列表集合
	 * @param list
	 * @param fid
	 * @return
	 * @Time 2018年1月11日
	 * @Author wys
	 */
	private List<Map<String, Object>> createTreeGridChildren(List<?> list,int fid) {
		List<Map<String, Object>> childList = new ArrayList<Map<String, Object>>();
		for (int j = 0; j < list.size(); j++) {
			Map<String, Object> map = null;
			Menu menu = (Menu) list.get(j);
			if (menu.getSuperid() == fid && menu.getStatus()==1) {
				map = new HashMap<String, Object>();
				map = setMap(map, menu);
				List<Map<String, Object>> childrenList = createTreeGridChildren(list, menu.getId());
				if (null != childrenList && childrenList.size() > 0) {
					map.put("state", "open");//节点闭合
					map.put("children", childrenList);//添加子节点
				}

			}
			if (map != null)
				childList.add(map);
		}
		return childList;
	}
	
	/**
	 * @Description 获取菜单树状列表集合
	 * @Description 递归菜单(复选框选中)
	 * @param list
	 * @param fid
	 * @param menuIds
	 * @return
	 * @Time 2018年1月9日
	 * @Author wys
	 */
	private List<Map<String, Object>> createTreeGridChildren(List<?> list,int fid,Integer[] menuIds) {
		List<Map<String, Object>> childList = new ArrayList<Map<String, Object>>();
		List<Integer> menuIdList=Arrays.asList(menuIds);
		for (int j = 0; j < list.size(); j++) {
			boolean isCheck=false;
			Map<String, Object> map = null;
			Menu menu = (Menu) list.get(j);		
			if (menu.getSuperid() == fid && menu.getStatus()==1) {
				map = new HashMap<String, Object>();
				map = setMap(map, menu);
				//if(menuIdList.contains(menu.getId())) map.put("checked", true);
				if(menuIdList.contains(menu.getId())) isCheck=true;
				List<Map<String, Object>> childrenList = createTreeGridChildren(list, menu.getId(),menuIds);
				if (null != childrenList && childrenList.size() > 0) {
					map.put("state", "closed");//菜单闭合
					map.put("children", childrenList);//子菜单
					if(isCheck) map.put("unchecked", true);
				}else{
					if(isCheck) map.put("checked", true);
				}
				
			}
			if (map != null)
				childList.add(map);
		}
		return childList;
	}
	
	/**
	 * @Description 设置map集合
	 * @param map
	 * @param menu
	 * @return
	 * @Time 
	 * @Author wys
	 */
	private Map<String, Object> setMap(Map<String, Object> map, Menu menu) {
		map.put("id", menu.getId()); // id
		map.put("menuid", menu.getId()); // id
		map.put("superid", menu.getSuperid());//上级菜单id
		map.put("menuname", menu.getMenuname());//菜单名称
		map.put("text", menu.getMenuname());//菜单名称
		map.put("menuenname", menu.getMenuenname());//菜单英语名称
		map.put("menuurl", menu.getMenuurl());//菜单链接
		map.put("menuicon", menu.getMenuicon());//菜单图标
		map.put("menuorder", menu.getMenuorder());//菜单排序
		map.put("menutype", menu.getMenutype()); //菜单类型：1-前台菜单，0-后台菜单
		return map;
	}
	
	@Override
	public boolean addMenu(Menu menu) throws Exception {
		int result=menuMapper.insertSelective(menu);
		if(result==1) {
			//记录操作日志
	        String content = "菜单名称：" + menu.getMenuname();
	        log.addLog("", "添加菜单", content, 0);
			return true;
		}
		else return false;
	}

	@Override
	public boolean editMenu(Menu menu) throws Exception {
		int result=menuMapper.updateByPrimaryKeySelective(menu);
		if(result==1){
			//记录操作日志
	        String content = "菜单名称：" + menu.getMenuname();
	        log.addLog("", "修改菜单", content, 2);
			return true;
		}
		else return false;
	}

	@Override
	public boolean deleteMenu(Integer id,HttpServletRequest request) throws Exception  {
		Menu menu = menuMapper.selectByPrimaryKey(id);
		List<Menu> list=menuMapper.selectMenuListBySuperId(id);
		if(null!=list && list.size()>0){
			//spring翻译使用req.getmessage()方法
			RequestContext req = new RequestContext(request);
			throw new CustomException(req.getMessage("Delete_Submenu_First"));
		}else{
			int result=menuMapper.updateMenuStatus(id, 0);//删除菜单实现数据库不删除，改变状态为0，使页面不显示。
			if(result==1) {
				//记录操作日志
		        String content = "菜单名称：" + menu.getMenuname();
		        log.addLog("", "删除菜单", content, 1);
				return true;
			}
			else return false;
		}
		
	}
	
	/**
	 * @Description 根据登录账号获取菜单树（用于主页面加载菜单）
	 * @param userid 账号ID menuType 后台 0，前台1
	 * @return
	 * @throws Exception
	 * @Time 2018年1月30号
	 * @Author hxl
	 */
	@Override
	public List<Map<String, Object>> getUserMenuJson(Integer userid,String menutype) throws Exception {
		List<Menu> list = menuMapper.getUserMenuList(userid, menutype);	
		List<Map<String, Object>> menuList=null;
		if(null!=list && list.size()>0){
			orderMenu(list);
			menuList=createTreeGrid(list,0);			
		}			
		return menuList;
	}
	
	/**
	 * @Description 根据登录账号获取菜单树以及勾选状态（用于角色管理配置菜单）
	 * @param userid 账号ID，menuIds 已勾选的菜单id，menuType 后台 0，前台1
	 * @return
	 * @throws Exception
	 * @Time 2019年3月29号
	 * @Author hxl
	 */
	@Override
	public List<Map<String, Object>> getUserMenuJson(Integer userid, Integer[] menuIds, String menutype) {
		List<Menu> list = menuMapper.getUserMenuList(userid, menutype);	
		List<Map<String, Object>> menuList=null;
		if(null!=list && list.size()>0){
			orderMenu(list);
			if(null!=menuIds && menuIds.length>0) menuList=createTreeGrid(list,0,menuIds);
			else menuList=createTreeGrid(list,0);			
		}			
		return menuList;
	}
	
	/**
	 * @Description 根据账号获取菜单集合（用于权限判断）
	 * @param userid 账号ID
	 * @return
	 * @throws Exception
	 * @Time 2018年7月25号
	 * @Author hxl
	 */
	public List<Menu> getUserMenuList(Integer userid,String menutype) throws Exception {
		return menuMapper.getUserMenuList(userid,menutype);	
	}

	@Override
	public List<Map<String, String>> getIconList(HttpServletRequest request) throws Exception {
		// 根据icon.css文件格式获取图标的名称和路径
		//ResourceLoader resourceLoader = new DefaultResourceLoader();
		//org.springframework.core.io.Resource resource = resourceLoader.getResource("classpath:static/js/easyui/themes/icon.css");
		//File file = ResourceUtils.getFile("classpath:static/js/easyui/themes/icon.css");
		// String CSS_PATH = "js/easyui/themes/icon.css";
		// String cssPath =
		// request.getSession().getServletContext().getRealPath(CSS_PATH);
		
		ClassPathResource resource = new ClassPathResource("static/js/easyui/themes/icon.css");
		//File sourceFile = resource.getFile();
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		BufferedReader reader = null;
		Map<String, String> map = null;
		try {
			reader = new BufferedReader(new InputStreamReader(resource.getInputStream()));
			String str = null;
			String iconName = null;
			String iconPathe = null;
			while ((str = reader.readLine()) != null) {
				map = new HashMap<String, String>();
				String cIconName = iconName;
				if (str.contains(".") && str.contains("{")) {
					int dotInd = str.indexOf(".");
					int kInd = str.indexOf("{");
					iconName = str.substring(dotInd + 1, kInd);
				}
				if (str.contains("'"))
					iconPathe = "../js/easyui/themes/" + str.substring(str.indexOf("'") + 1, str.lastIndexOf("'"));
				if (null != iconName && null != iconPathe && iconName != cIconName) {
					map.put("iconName", cIconName);
					map.put("iconPathe", iconPathe);
					list.add(map);
				}
			}
			reader.close();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (null != reader) {
				reader.close();
			}
		}
		return list;
	}

	@Override
	public boolean editMenuIcon(Integer id, String icon) throws Exception {
		Menu menu = menuMapper.selectByPrimaryKey(id);
		int result=menuMapper.updateIcon(id, icon);
		if(result==1){
			//记录操作日志
	        String content = "菜单名称：" + menu.getMenuname();
	        log.addLog("", "修改菜单图标", content, 2);
			return true;
		}
		else return false;
	}

	@Override
	public boolean validateMenuName(String menuName, int id, int menutype) throws Exception {
		int count = menuMapper.selectCountByName(menuName, id, menutype);
		if(count > 0) return false;
		else return true;
	}
}
