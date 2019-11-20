package com.ssm.wssmb.util;

import java.util.Collection;

import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.pam.ModularRealmAuthenticator;
import org.apache.shiro.realm.Realm;

public class UserModularRealmAuthenticator extends ModularRealmAuthenticator {
	
	@Override
    protected AuthenticationInfo doAuthenticate(AuthenticationToken authenticationToken)
            throws AuthenticationException {
        // 判断getRealms()是否返回为空
        assertRealmsConfigured();
        // 强制转换回自定义的UsernamePasswordUsertypeToken
        UsernamePasswordUsertypeToken token = (UsernamePasswordUsertypeToken) authenticationToken; 
        Realm realm = null; 
        //判断是否是后台用户
        String realmName = "";
        if (token.getUsertype().equals("admin")) {  
        	realmName = "AdminShiroRealm";  
        }  
        else{
        	realmName = "FrontShiroRealm";  
        }
        Collection<Realm> realms = getRealms();
        for (Realm item : realms) {
        	if (realmName.equals(item.getName())){
        		realm = item;
        	}
        }

        return this.doSingleRealmAuthentication(realm, authenticationToken);
    }
}
