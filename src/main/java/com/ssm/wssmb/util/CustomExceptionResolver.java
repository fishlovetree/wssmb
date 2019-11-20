package com.ssm.wssmb.util;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.shiro.authz.AuthorizationException;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.ModelAndView;

import com.ssm.wssmb.controller.CommonMethod;
import com.ssm.wssmb.model.SysErrorlog;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.service.ErrorLogService;

@Configuration
public class CustomExceptionResolver implements HandlerExceptionResolver{
	
	@Resource
	private ErrorLogService errorLogService;

	// 日志管理类
	private Logger log = Logger.getLogger(this.getClass());

	@Override
	public ModelAndView resolveException(HttpServletRequest arg0,
			HttpServletResponse arg1, Object arg2, Exception arg3) {
		CustomException customException=null;
		if(arg3 instanceof CustomException){
			customException= (CustomException)arg3;
		}else if(arg3 instanceof AuthorizationException){
			customException=new CustomException("没有操作权限");
		}else {
			customException=new CustomException("未知错误");
			/*System.out.println("异常方法"+arg2.toString());
			System.out.println("异常消息"+arg3.getMessage());
			System.out.println("异常堆栈"+EventLogAspect.getStackTrace(arg3));
			System.out.println("异常类"+arg3.getClass());*/
			saveException(arg2,arg3);
		}
	
		String message=customException.getMessage();
		String viewName="Error/Error";
		ModelAndView modelAndView=new ModelAndView(viewName);
		modelAndView.addObject("message",message);
		return modelAndView;
	}
	
	/**
	 * @Description:存储异常信息
	 * @Author lmn
	 * @Time: 2018年1月10日
	 */
	public void saveException(Object oj, Exception ex) {
			try{
				// 创建日志对象
				SysErrorlog merrorlog = new SysErrorlog();
				// 获取系统时间
				@SuppressWarnings("unused")
				SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");// 设置日期格式
				// System.out.println(df.format(new Date()));// new Date()为获取当前系统时间
				// 从session获取用户
				HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder
						.getRequestAttributes()).getRequest();
				User user = CommonMethod.getUserBySession(request, "user", true);
				// 获取IP
				String ip = EventLogAspect.getIpAddr(request);

				if (null != user) {
					log.info(oj.toString() + "\n" + oj.toString());
					
					merrorlog.setUserid(user.getId().intValue());
					merrorlog.setIp(ip);

					String Agent = EventLogAspect.getRequestBrowserInfo(request);

					merrorlog.setBrowser(Agent);
					
					if(null!=ex.getMessage() && ex.getMessage().length()>1800){
						merrorlog.setMessage(ex.getMessage().substring(0, 1800));//异常消息
					}else{
						merrorlog.setMessage(ex.getMessage());//异常消息
					}
					
					merrorlog.setStacktrace(EventLogAspect.getStackTrace(ex));//异常堆栈
					
					if(null!=oj.toString() && oj.toString().length()>1800){
						merrorlog.setAction(oj.toString().substring(0, 1800));//异常方法(获取的是控制器方法)
					}else{
						merrorlog.setAction(oj.toString());//异常方法(获取的是控制器方法)
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
		
}
