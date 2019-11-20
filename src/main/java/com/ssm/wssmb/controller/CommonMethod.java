package com.ssm.wssmb.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import javax.mail.internet.MimeUtility;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ssm.wssmb.model.User;

/**
 * @Description 公用方法
 * @Time 2019年7月18日
 * @Author dj
 */
public class CommonMethod {
	
	/**
	 * @Description 根据session获取登录账号
	 * @param req，nullable可空
	 * @return
	 * @throws Exception
	 * @Time 2019年7月18日
	 * @Author dj
	 */
	public static User getUserBySession(HttpServletRequest req, String sessionname, boolean nullable){
		User user = (User)req.getSession(true).getAttribute(sessionname);

		
		return user;
	}
	
	/**
	 * @Description 下载文档，文件编码格式
	 * @param fileName 文件名
	 * @return
	 * @throws Exception
	 * @Time 2019年7月24日
	 * @Author dj
	 */
	public static String getName(HttpServletRequest request, HttpServletResponse response,
    		String fileName){
    	String userAgent = request.getHeader("User-Agent");
		String newFileName = null;
		try {
			fileName = URLEncoder.encode(fileName, "UTF8");
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}
		if (userAgent != null) {
			userAgent = userAgent.toLowerCase();
			// IE浏览器，只能采用URLEncoder编码
			if (userAgent.indexOf("msie") != -1) {
				newFileName = "filename=\"" + fileName + "\"";
			}
			// Opera浏览器只能采用filename*
			else if (userAgent.indexOf("opera") != -1) {
				newFileName = "filename*=UTF-8''" + fileName;
			}
			// Safari浏览器，只能采用ISO编码的中文输出
			else if (userAgent.indexOf("safari") != -1) {
				try {
					newFileName = "filename=\""
							+ new String(fileName.getBytes("UTF-8"), "ISO8859-1")
							+ "\"";
				} catch (UnsupportedEncodingException e) {
					e.printStackTrace();
				}
			}
			// Chrome浏览器，只能采用MimeUtility编码或ISO编码的中文输出
			else if (userAgent.indexOf("applewebkit") != -1) {
				try {
					fileName = MimeUtility.encodeText(fileName, "UTF8", "B");
				} catch (UnsupportedEncodingException e) {
					e.printStackTrace();
				}
				newFileName = "filename=\"" + fileName + "\"";
			}
			// FireFox浏览器，可以使用MimeUtility或filename*或ISO编码的中文输出
			else if (userAgent.indexOf("mozilla") != -1) {
				newFileName = "filename*=UTF-8''" + fileName;
			}
		}
		//文件名编码结束。

		return newFileName;
    }
}
