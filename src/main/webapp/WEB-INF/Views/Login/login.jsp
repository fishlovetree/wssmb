<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
       <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
    <%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@page import="org.apache.commons.lang.StringUtils"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title>登录</title>
<link rel="shortcut icon" href="${pageContext.request.contextPath}/images/Avatar.png" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/login.css" >
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/easyui/themes/insdep/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/easyui/themes/icon.css">

<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/login.js"></script>
<script type="text/javascript">
var flag='1';

$(function(){
	$("#reset").click(function () {
		$('#userlogin').textbox("setValue","");
	    $('#userpwd').textbox("setValue","");
	    $('#authcode').textbox("setValue","");
    })
    
	document.onkeydown = function(e){
		var ev = document.all ? window.event : e;
		if(ev.keyCode==13) {
			if(flag==""){
				flag='1'; 
				
				$(".messager-body").window('close'); 
			}
			else{
				flag='';
				return login();
			}
		}
	} 
});

function login(){
	 var username = $('#userlogin').val();
     var password = $('#userpwd').val();
     var authcode = $('#authcode').val();
     var rememberme = $('#RememberMe').is(":checked");

     var temp="";
     if(username == '') {
    	temp="请输入用户名。";
     }
     if(password == '') {
  		temp="请输入密码。";
     }
     if(authcode == '') {
    	 /* temp="请输入验证码";*/
     }
     
     if(temp==""){
		 var data={"username":username,"password":password,"authcode":authcode,"rememberme":rememberme};
	     $.ajax({
	    	url:"${pageContext.request.contextPath}/admin/userLogin",
	    	data:data,
	    	type:"post",
	    	dataType:"json",
	    	success:function(result){
	    		if(result=="1"){
	    			window.location.href= result.back_url || "${pageContext.request.contextPath}/admin/successLogin";
	    			/* setTimeout(function(){
	    				//登录返回
		    			
	    			},1000) */
	    			return true;
	    		}else{
	    			temp="用户名或密码错误。";
	    			switch(result){
		    			case -1:temp="验证码错误。";break;
		    			case -2:temp="非后台用户。";break;
	    			}
	    			
	    			$.messager.alert('<spring:message code="Prompt"/>',temp, 'warning',function(){ flag='1'; });
	    		}
	    	},
	    	error:function(e){
	    		$.messager.alert('<spring:message code="Warning"/>','连接服务器失败。', 'error',function(){ flag='1'; });
	    	}
	    });
     }
     else{
    	 //alert(temp);
    	 //flag='1';
    	$.messager.alert('<spring:message code="Warning"/>',temp, 'error',function(){ flag='1'; });
     }
     return false;
}

</script>
</head>
	<body class="loginColor">
	 <%-- 读取cookie --%> 
	 <% 
	  String name = ""; 
	  String password = ""; 
	  try{ 
	   Cookie[] cookies = request.getCookies(); 
	   if(cookies!=null){ 
	    for(int i = 0;i<cookies.length;i++){ 
	     if(cookies[i].getName().equals("user")){ 
	      String values = cookies[i].getValue(); 
	      // 如果value字段不为空 
	      if(StringUtils.isNotBlank(values)){ 
	       String[] elements = values.split("-"); 
	       // 获取账户名或者密码 
	       if(StringUtils.isNotBlank(elements[0])){ 
	        name = elements[0]; 
	       } 
	       if(StringUtils.isNotBlank(elements[1])){ 
	        password = elements[1]; 
	       } 
	      } 
	     } 
	    } 
	   } 
	  }catch(Exception e){ 
	  } 
	 %> 
 <!-- tiaozhuanhuidengluhou --><!-- 用于判断是前端登录页还是后端登录页，前面的注释不能删除 -->
		<div class="loginWraper">
			<table id="loginTitle" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="130px">
						<img src="${pageContext.request.contextPath}/images/Login/Login-logo.png" height="130" alt="中国消防"/></td>
					<td width="10px">
						<span style="color: rgba(61, 58, 56, 1); font-family: '黑体'; font-size: 40px;">|</span>
					</td>
					<td style="padding-left: 12px;">
						<span class="loginname"><spring:message code="Wisdom_fire_safety_system"/></span>
					</td>
				</tr>
			</table>
			
			<div class="loginBoxbg">
				<form action="" method="post" >
					<table border="0" cellpadding="0" cellspacing="0" style="width:500px;">
						<tr>
							<td>
								<table style="width:100%;height:300px;background:url(${pageContext.request.contextPath}/images/Login/login-bg-TL.png) no-repeat;" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td colspan="3" height="15"></td>
									</tr>
									<tr>
										<td colspan="3" style="width:100%;height:34px;">
											<table style="left: 15px; position: relative;" border="0" cellspacing="0" cellpadding="0">
												<tr>								
													<td><img src="${pageContext.request.contextPath}/images/Login/login-user2.png" height="30" alt=""></td>
													<td><img src="${pageContext.request.contextPath}/images/Login/Login-l.png" height="30" alt=""></td>
													<td><span style="color: rgba(61, 58, 56, 1); font-family: '黑体'; font-size: 21px; font-weight: bold;">用户登录</span></td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td colspan="3" height="5"></td>
									</tr>
									<tr height="12">
										<td colspan="3">
											<img src="${pageContext.request.contextPath}/images/Login/login_blue.png" style="width:100%;height:12px;" alt=""></td>
									</tr>
									<tr>
										<td colspan="3" height="10"></td>
									</tr>
									<tr>
										<td width="38"></td>
										<td>
											<table id="Table_box" width="100%" border="0" cellpadding="0" cellspacing="0">
												<tr>
													<td>
														<img src="${pageContext.request.contextPath}/images/Login/Login-user.png" width="32" alt=""></td>
													<td><span style="color: rgba(82, 78, 76, 1); font-family: '黑体'; font-size: 16px; font-weight: bold;">用户名：</span></td>
													<td colspan="3">
														<input class="easyui-textbox" data-options="prompt:'输入用户名...'" style="width: 230px;height: 30px;" type="text" name="userlogin" id="userlogin" value="<%=name %>"/>
													</td>
												</tr>
												<tr>
													<td colspan="5" height="10"></td>
												</tr>
												<tr>
													<td>
														<img src="${pageContext.request.contextPath}/images/Login/Login-pwd.png" width="32" alt=""></td>
													<td><span style="color: rgba(82, 78, 76, 1); font-family: '黑体'; font-size: 16px; font-weight: bold;">密码：</span></td>
													<td colspan="3"><input class="easyui-textbox" data-options="prompt:'输入密码...'" style="width: 230px;height:30px;" type="password" name="userpwd" id="userpwd" value="<%=password %>"/></td>
												</tr>
												<tr>
													<td colspan="5" height="10"></td>
												</tr>
												<tr>
													<td>
														<img src="${pageContext.request.contextPath}/images/Login/login-code.png" width="32"alt=""></td>
													<td><span style="color: rgba(82, 78, 76, 1); font-family: '黑体'; font-size: 16px; font-weight: bold;">验证码：</span></td>
													<td style="width: 150px;"><input class="easyui-textbox" data-options="prompt:'输入验证码...'" style="width: 140px;height:30px;" type="text" name="authcode" id="authcode"/></td>
													<td>
														<img src="/WSSF/admin/Kaptcha.jpg" class="authcode"/></td>
													<td>
														<img src="${pageContext.request.contextPath}/images/Login/Login-reload.png" width="17" height="17" onclick="changecode()"/></td>
												</tr>
												<tr>
													<td colspan="5" height="8"></td>
												</tr>
												<tr>
													<td colspan="2" width="121" height="17"></td>
													<td>
														<input type="checkbox" id="RememberMe" name="RememberMe" value="1"/>
			                    						<label class="remeberText" for="RememberMe" style="font-size: 12px;color:#7d7d7d;margin-left:3px;">记住密码</label>								
													</td>
													<td colspan="2" width="102" height="17"></td>
												</tr>
											</table>
										</td>
										<td width="35"></td>
									</tr>
									<tr>
										<td colspan="3" height="40">
											<table style="width:314px;height:34px;margin: auto;" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td>
														<input id="submit" type="button" value="登 录" onclick="login()"/>
													</td>
													<td width="94"></td>
													<td>
														<input id="reset" type="button" value="重 置" />
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td colspan="3" height="23"></td>
									</tr>
								</table>
							</td>
							<td>
								<img src="${pageContext.request.contextPath}/images/Login/login-bg-TR.png" width="67" height="300" alt=""></td>
						</tr>
						<tr>
							<td>
								<table style="width:100%;background:url(${pageContext.request.contextPath}/images/Login/login-bg-BL.png) no-repeat;" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td colspan="3" height="23"></td>
									</tr>
									<tr>
										<td colspan="3">
											<table style="width:314px;height:34px;margin: auto;" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td>
														<img src="${pageContext.request.contextPath}/images/Login/login-botton-RL.png" width="110" height="34" alt=""></td>
													<td width="94"></td>
													<td>
														<img src="${pageContext.request.contextPath}/images/Login/login-botton-RR.png" width="109" height="34" alt=""></td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td colspan="3" height="30"></td>
									</tr>
								</table>
							</td>
							<td>
								<img src="${pageContext.request.contextPath}/images/Login/login-bg-BR.png" width="67" height="87" alt=""></td>
						</tr>
					</table>
				</form>
			</div>
			
		</div>
    </body>
</html>