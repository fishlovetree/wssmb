package com.ssm.wssmb.util;

import java.util.List;

import javax.annotation.Resource;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.subject.Subject;

import com.ssm.wssmb.model.Menu;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.service.UserService;

//后台realm
public class AdminShiroRealm extends AuthorizingRealm{
	@Resource
	private UserService userService;
	
	 @Override
	 public String getName() {
	        return "AdminShiroRealm";
	 }
	 
	//授权认证
	@Override
	protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection arg0) {
		  Subject currentUser =SecurityUtils.getSubject();  
	      Session session = currentUser.getSession();  
	      User user = (User) session.getAttribute("user"); 
	      if(!isEmptyUserAndMenu(user)){
	    	  SimpleAuthorizationInfo info = (SimpleAuthorizationInfo) session.getAttribute("info"); 
	    	  if(null!=info) return info;
	    	  return setAuthorizationInfo(user.getMenuList());
	      }else{
	    	  //AuthorizationException 全局处理器处理
	    	  return null;
	      }
	}
	
	/**
	 * @Description 判断该账户是否存在同时有菜单
	 * @param user
	 * @return
	 * @Time 2019年8月28日
	 * @Author hxl
	 */
	private boolean isEmptyUserAndMenu(User user){
		return null==user || null==user.getMenuList() || user.getMenuList().size()<=0;
	}
	
	/**
	 * @Description 设置账户权限
	 * @param list
	 * @return
	 * @Time 2019年8月28日
	 * @Author hxl
	 */
	public static AuthorizationInfo setAuthorizationInfo(List<Menu> list){
		SimpleAuthorizationInfo info = new SimpleAuthorizationInfo();
		for(Menu menu:list){
	        String menuUrl = menu.getMenuurl();
   		  	if(null != menuUrl && !"".equals(menuUrl.trim())){
   			    String[] s = menuUrl.split("/");
   			    if(null != s && s.length >= 1){
   				    StringBuilder mSrt = new StringBuilder();
   				    for(int i = 1; i < s.length; i++){
   				        mSrt.append(s[i] + ":");
   				    }
   				    mSrt.setLength(mSrt.length() - 1);//去掉最后一个“:”
   				    info.addStringPermission(mSrt.toString()); 
   			    }
   		    }
   	    }
		return info;
	}
	
	//登录认证
	@Override
	protected AuthenticationInfo doGetAuthenticationInfo(
			AuthenticationToken arg0) throws AuthenticationException,UnknownAccountException,IncorrectCredentialsException{
		UsernamePasswordUsertypeToken token = (UsernamePasswordUsertypeToken) arg0;
		String username = token.getUsername();
		User user = userService.getUserByName(username);
		if(null !=username && null!=user){
			if(!username.trim().equals("")){
				AuthenticationInfo authcInfo = new SimpleAuthenticationInfo(user,user.getPassword(),getName());  
	            return authcInfo;
			}else{
				throw new IncorrectCredentialsException(); 
			}			
		}else{
			throw new UnknownAccountException();  
		}
	}
}
