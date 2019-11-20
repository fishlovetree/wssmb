package com.ssm.wssmb.util;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;

import org.apache.log4j.Logger;
//import org.apache.shiro.web.servlet.ShiroHttpServletRequest;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.ssm.wssmb.model.SysErrorlog;
import com.ssm.wssmb.model.SysLog;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.service.ErrorLogService;
import com.ssm.wssmb.service.LogService;

/**
 * @Description:spring AOP切面类，主要将系统的操作记录日志写入数据库
 * @Author lmn
 * @Time: 2018年1月5日
 */
@Configuration
public class EventLogAspect {

	@Resource
	private LogService logService;

	@Resource
	private ErrorLogService errorLogService;

	// 日志管理类
	private Logger log = Logger.getLogger(this.getClass());

	public void doAfterReturning(JoinPoint jp) {
		/*
		 * System.out.println( "log Ending method: " +
		 * jp.getTarget().getClass().getName() + "." +
		 * jp.getSignature().getName());
		 */	
		Method proxyMethod = ((MethodSignature) jp.getSignature()).getMethod();
		Method soruceMethod;
		try {
			soruceMethod =  jp
					.getTarget()
					.getClass()
					.getMethod(proxyMethod.getName(),
							proxyMethod.getParameterTypes());
			Operation oper = soruceMethod.getAnnotation(Operation.class);

			//获取参数列表
	
			// 创建日志对象
			SysLog mLog = new SysLog();
			// 获取系统时间
			@SuppressWarnings("unused")
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");// 设置日期格式
			// System.out.println(df.format(new Date()));// new Date()为获取当前系统时间
			// 从session获取用户
			HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder
					.getRequestAttributes()).getRequest();
			User user = (User) request.getSession().getAttribute("user");
			// 获取IP
			String ip = getIpAddr(request);

			if (oper != null && null != user) {
				 Object[] args = jp.getArgs();
	 
				 if(null!=args){
					 JSONArray jsonarray =null;
					 if(args[0].getClass()!=Integer.class && args[0].getClass()!=String.class){
						 jsonarray = JSONArray.fromObject(args[0]);
					 }else{
						List<Object> list=new ArrayList<Object>();
						 for(Object data:args){
//							 if(!(data instanceof ShiroHttpServletRequest))
								 list.add(data);
						 }
						 jsonarray = JSONArray.fromObject(list);

					 }
					 String info=jsonarray.toString().substring(1,jsonarray.toString().length()-1); 
					 if(info.length()>2000){//一个汉字，lenth=1，oracle varchar2为2； 
						 info = info.substring(0, 1800);
					 }
					 mLog.setContent(info);
				 }
					 			 
				log.info(oper.desc());
				
				mLog.setUserid(user.getId().intValue());
				mLog.setIp(ip);
				mLog.setTitle(oper.desc());
				mLog.setOpertype(new BigDecimal(oper.type()).intValue());
				mLog.setIntime(new Date());
				// mLog.setOperateinfo(jsonarray.toString());
				
				// 将日志存入数据库
				logService.insert(mLog);
			}

		} catch (NoSuchMethodException e) {
			e.printStackTrace();
		} catch (SecurityException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 配置抛出异常后通知,使用在方法aspect()上注册的切入点
	public void doAfterThrow(JoinPoint jp, Throwable ex) {
		Method proxyMethod = ((MethodSignature) jp.getSignature()).getMethod();
		Method soruceMethod;
		try {
			soruceMethod = jp
					.getTarget()
					.getClass()
					.getMethod(proxyMethod.getName(),
							proxyMethod.getParameterTypes());
			Operation oper = soruceMethod.getAnnotation(Operation.class);

			// 创建日志对象
			SysErrorlog merrorlog = new SysErrorlog();
			// 获取系统时间
			@SuppressWarnings("unused")
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");// 设置日期格式
			// System.out.println(df.format(new Date()));// new Date()为获取当前系统时间
			// 从session获取用户
			HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder
					.getRequestAttributes()).getRequest();
			User user = (User) request.getSession().getAttribute("user");
			// 获取IP
			String ip = getIpAddr(request);

			if (oper != null && null != user) {
				log.info(oper.desc() + "\n" + jp + " , " + ex.toString());
				
				merrorlog.setUserid(user.getId().intValue());
				merrorlog.setIp(ip);

				String Agent = getRequestBrowserInfo(request);

				merrorlog.setBrowser(Agent);

				if(null!=ex.getMessage() && ex.getMessage().length()>1800){
					merrorlog.setMessage(ex.getMessage().substring(0, 1800));//异常消息
				}else{
					merrorlog.setMessage(ex.getMessage());//异常消息
				}
				
				merrorlog.setStacktrace(getStackTrace(ex));//异常堆栈
				
				if(null!=jp.toString() && jp.toString().length()>1800){
					merrorlog.setAction(jp.toString().substring(0, 1800));//异常方法(获取的是控制器方法)
				}else{
					merrorlog.setAction(jp.toString());//异常方法(获取的是控制器方法)
				}
				
				merrorlog.setErrorclass(ex.getClass().toString());//异常类
				merrorlog.setIntime(new Date());
				
				// 将日志存入数据库
				errorLogService.insert(merrorlog);
			}

		} catch (NoSuchMethodException e) {
			e.printStackTrace();
		} catch (SecurityException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 获取当前网络ip(可以获取通过了Apache，Squid等反向代理软件的客户端的真实IP地址)
	 * 
	 * @param request
	 * @return
	 */
	public static String getIpAddr(HttpServletRequest request) {
		String ipAddress = request.getHeader("x-forwarded-for");
		if (ipAddress == null || ipAddress.length() == 0
				|| "unknown".equalsIgnoreCase(ipAddress)) {
			ipAddress = request.getHeader("Proxy-Client-IP");
		}
		if (ipAddress == null || ipAddress.length() == 0
				|| "unknown".equalsIgnoreCase(ipAddress)) {
			ipAddress = request.getHeader("WL-Proxy-Client-IP");
		}
		if (ipAddress == null || ipAddress.length() == 0
				|| "unknown".equalsIgnoreCase(ipAddress)) {
			ipAddress = request.getRemoteAddr();
			if (ipAddress.equals("127.0.0.1")
					|| ipAddress.equals("0:0:0:0:0:0:0:1")) {
				// 根据网卡取本机配置的IP
				InetAddress inet = null;
				try {
					inet = InetAddress.getLocalHost();
				} catch (UnknownHostException e) {
					e.printStackTrace();
				}
				ipAddress = inet.getHostAddress();
			}
		}
		// 对于通过多个代理的情况，第一个IP为客户端真实IP,多个IP按照','分割
		if (ipAddress != null && ipAddress.length() > 15) { // "***.***.***.***".length()
															// = 15
			if (ipAddress.indexOf(",") > 0) {
				ipAddress = ipAddress.substring(0, ipAddress.indexOf(","));
			}
		}
		return ipAddress;
	}
	
	
	/** 
     * 获取来访者的浏览器版本 
     * @param request 
     * @return 
     */  
    public static String getRequestBrowserInfo(HttpServletRequest request){  
        String browserVersion = null;  
        String agent=request.getHeader("User-Agent").toLowerCase(); 
        if(agent == null || agent.equals("")){  
           return "";  
        }  
       // System.out.print(agent);
        if(agent.indexOf("msie 7")>0){
        	browserVersion ="IE7";
        }else if(agent.indexOf("msie 8")>0){
        	browserVersion= "IE8";
        }else if(agent.indexOf("msie 9")>0){
        	browserVersion= "IE9";
        }else if(agent.indexOf("msie 10")>0){
        	browserVersion= "IE10";
        }else if(agent.indexOf("gecko")>0 && agent.indexOf("rv:11")>0){
        	browserVersion= "IE11";
        }else if(agent.indexOf("opera")>0){
        	browserVersion= "Opera";
        }else if(agent.indexOf("firefox")>0){  
            browserVersion = "Firefox";  
        }else if(agent.indexOf("chrome")>0){  
            browserVersion = "Chrome";  
        }else if(agent.indexOf("webkit")>0){
        	browserVersion= "Webkit";
        }else if(agent.indexOf("safari")>0){  
            browserVersion = "Safari";  
        }else if(agent.indexOf("camino")>0){  
            browserVersion = "Camino";  
        }else if(agent.indexOf("konqueror")>0){  
            browserVersion = "Konqueror";  
        }
        else{
        	browserVersion= "Others";
	  }
	    return browserVersion;  
    }  
  
    public static String getStackTrace(Throwable throwable)
    {
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);

        try
        {
            throwable.printStackTrace(pw);
            return sw.toString();
        } finally
        {
            pw.close();
        }
    }
    
    //自定义操作日志
    public void addLog(String sessionname,String title,String content,Integer type) {
		try {
			// 创建日志对象
			SysLog mLog = new SysLog();
			// 从session获取用户
			HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder
					.getRequestAttributes()).getRequest();
			User user = null;
			if(null!=sessionname && sessionname!="")
				user = (User) request.getSession().getAttribute(sessionname);
			else
				user = (User) request.getSession().getAttribute("user");
			// 获取IP
			String ip = getIpAddr(request);

			mLog.setUserid(user.getId().intValue());
			mLog.setIp(ip);
			mLog.setTitle(title);
			mLog.setContent(content);
			mLog.setOpertype(type);
			mLog.setIntime(new Date());
			
			// 将日志存入数据库
			logService.insert(mLog);

		} catch (NoSuchMethodException e) {
			e.printStackTrace();
		} catch (SecurityException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 自定义异常日志
	public void addErrorLog(String sessionname,String action, Throwable ex) {
		try {
			// 创建日志对象
			SysErrorlog merrorlog = new SysErrorlog();
			// 从session获取用户
			HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder
					.getRequestAttributes()).getRequest();
			User user = null;
			if(null!=sessionname && sessionname!="")
				user = (User) request.getSession().getAttribute(sessionname);
			else
				user = (User) request.getSession().getAttribute("user");
			// 获取IP
			String ip = getIpAddr(request);

			merrorlog.setUserid(user.getId().intValue());
			merrorlog.setIp(ip);

			String Agent = getRequestBrowserInfo(request);

			merrorlog.setBrowser(Agent);

			if(null!=ex.getMessage() && ex.getMessage().length()>1800){
				merrorlog.setMessage(ex.getMessage().substring(0, 1800));//异常消息
			}else{
				merrorlog.setMessage(ex.getMessage());//异常消息
			}
			
			merrorlog.setStacktrace(getStackTrace(ex));//异常堆栈
			merrorlog.setAction(action);//异常方法(获取的是控制器方法)
			merrorlog.setErrorclass(ex.getClass().toString());//异常类
			merrorlog.setIntime(new Date());
			
			// 将日志存入数据库
			errorLogService.insert(merrorlog);

		} catch (NoSuchMethodException e) {
			e.printStackTrace();
		} catch (SecurityException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
