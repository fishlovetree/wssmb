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
import org.springframework.web.servlet.support.RequestContext;

import com.google.gson.Gson;
import com.ssm.wssmb.model.Menu;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.service.MenuService;
import com.ssm.wssmb.util.CustomException;
//import com.ssm.wssmb.util.MyRealm;

/**
 * @Description: 菜单控制器
 * @Author wys
 * @Time: 2018年1月11日
 */
@Controller
@RequestMapping(value="/sysMenu")
public class MenuController {
	@Resource
	private MenuService menuService;
	
	
	@RequestMapping(value="/menuPage")
//	@RequiresPermissions("sysMenu:menuPage")
	public ModelAndView menuPage(){
		ModelAndView mv = new ModelAndView();
		mv.setViewName("System/MenuPage");
		return  mv;
	}
	

	/**
	 * @Description 获取菜单树状列表
	 * @return
	 * @throws Exception
	 * @Time 2018年1月11日
	 * @Author wys
	 */
	@RequestMapping(value="/menuTreeGrid",produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<Map<String, Object>> menuTreeGrid(Integer menutype) throws Exception {	
		List<Map<String, Object>> menuMapList = menuService.getMenuTreeGrid(menutype);
		return menuMapList;
	}
	
	/**
	 * @Description 通过菜单id查询不是该菜单和该菜单下级菜单的集合 
	 * @param id
	 * @return
	 * @throws Exception
	 * @Time 2018年1月15日
	 * @Author wys
	 */
	@RequestMapping(value="/otherMenuTreeGrid",produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<Map<String, Object>> otherMenuTreeGrid(int id) throws Exception {	
		List<Map<String, Object>> menuMapList = menuService.getMenuTreeGrid(id);
		return menuMapList;
	}
	
	/**
	 * @Description 添加菜单
	 * @param menu
	 * @param bindingResult
	 * @return
	 * @throws Exception
	 * @Time 2018年1月11日
	 * @Author wys
	 */
	@RequestMapping(value="/addMenu",method=RequestMethod.POST,produces = "text/html;charset=UTF-8;")
	public @ResponseBody String addMenu(@Validated Menu menu,BindingResult bindingResult,HttpServletRequest request) throws Exception{
		//spring翻译使用req.getmessage()方法
		RequestContext req = new RequestContext(request);
		//实体类效验
		if (bindingResult.hasErrors()) {
			List<ObjectError> list = bindingResult.getAllErrors();
			if(null!=list && list.size()>0)
				throw new CustomException(req.getMessage(list.get(0).getDefaultMessage()));
		}
		//名称唯一性判断
		boolean nameFalg=menuService.validateMenuName(menu.getMenuname(), 0, menu.getMenutype());
		if(!nameFalg) throw new CustomException(req.getMessage("Menu_Name_Repeated"));
		if(menu.getSuperid()==null) menu.setSuperid(0);
		boolean falg=menuService.addMenu(menu);
		if(falg==true){
			return "success";
		}else{
			return "error";
		}				
	}
	
	/**
	 * @Description 修改菜单
	 * @param menu
	 * @return
	 * @throws Exception
	 * @Time 2018年1月11日
	 * @Author wys
	 */
	@RequestMapping(value="/editMenu",method=RequestMethod.POST,produces = "text/html;charset=UTF-8;")
	public @ResponseBody String editMenu(Menu menu,HttpServletRequest request) throws Exception{
		//名称判断
		boolean validateFalg=menuService.validateMenuName(menu.getMenuname(), menu.getId(), menu.getMenutype());
		//spring翻译使用req.getmessage()方法
		RequestContext req = new RequestContext(request);
		if(!validateFalg) throw new CustomException(req.getMessage("Menu_Name_Repeated"));
		boolean falg=menuService.editMenu(menu);
		if(falg==true){
			return "success";
		}else{
			return "error";
		}				
	}
	

	/**
	 * @Description 删除菜单
	 * @param id
	 * @return
	 * @throws Exception
	 * @Time 2018年1月11日
	 * @Author wys
	 */
	@RequestMapping(value="/deleteMenu",method=RequestMethod.POST,produces = "text/html;charset=UTF-8;")
	public @ResponseBody String deleteMenu(int id,HttpServletRequest request) throws Exception{
		boolean falg=menuService.deleteMenu(id,request);
		if(falg==true){
			return "success";
		}else{
			//spring翻译使用req.getmessage()方法
			RequestContext req = new RequestContext(request);
			throw new CustomException(req.getMessage("SuccessDeleted"));
		}				
	}
	
	/**
	 * @Description 获取后台菜单Json
	 * @param name,value
	 * @return
	 * @throws Exception
	 * @Time 2018年1月5号
	 * @Author dj
	 * @type 后端方法
	 */
	@RequestMapping(value="/getMenuJson",method=RequestMethod.POST,produces = "text/html;charset=UTF-8;")
	public @ResponseBody String getMenuJson(HttpServletRequest req) throws Exception{
		User user= (User) req.getSession().getAttribute("user");
		List<Map<String, Object>> menuList;
		if (user.getUserLevel() == 0 && user.getUsertype() == 0){
			menuList = menuService.getMenuTreeGrid(user.getUsertype());
			//回写用户菜单权限
			List<Menu> m = menuService.getMenuList(user.getUsertype());
			user.setMenuList(m);
			req.getSession().setAttribute("user", user);
//			req.getSession().setAttribute("info", MyRealm.setAuthorizationInfo(m));
		}
		else{
			menuList = menuService.getUserMenuJson(user.getId(),"");
			//回写用户菜单权限
			List<Menu> m = menuService.getUserMenuList(user.getId(),"");
			user.setMenuList(m);
			req.getSession().setAttribute("user", user);
//			req.getSession().setAttribute("info", MyRealm.setAuthorizationInfo(m));
		}
		//将集合转换为json输出到页面  
	    Gson gson = new Gson();  
	    String json = gson.toJson(menuList);
	    return json; 
			
	}

	/**
	 * @Description 获取图标json数据
	 * @return
	 * @throws Exception
	 * @Time 2018年1月10日
	 * @Author wys
	 */
	@RequestMapping(value="/iconJson",produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<Map<String, String>> iconJson(HttpServletRequest request) throws Exception{	
		List<Map<String, String>> menuMapList = menuService.getIconList(request);
		if(null!=menuMapList && menuMapList.size()>0) return menuMapList;
		else {
			//spring翻译使用req.getmessage()方法
			RequestContext req = new RequestContext(request);
			throw new CustomException(req.getMessage("Failed_To_Get_Icon")); 
		}
		
			
	}
	
	/**
	 * @Description 设置菜单图标
	 * @param id
	 * @param icon
	 * @return
	 * @throws Exception
	 * @Time 2018年1月10日
	 * @Author wys
	 */
	@RequestMapping(value="/saveIcon",method=RequestMethod.POST,produces = "text/html;charset=UTF-8;")
	public @ResponseBody String saveIcon(int id,String icon,HttpServletRequest request) throws Exception{
		boolean falg=menuService.editMenuIcon(id, icon);
		if(falg==true){
			return "success";
		}else{
			//spring翻译使用req.getmessage()方法
			RequestContext req = new RequestContext(request);
			throw new CustomException(req.getMessage("Edit_Fail"));
		}				
	}
}
