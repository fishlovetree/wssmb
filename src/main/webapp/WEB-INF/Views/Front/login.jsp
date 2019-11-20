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
<jsp:include page="../FrontHeader.jsp"/>
<link rel="shortcut icon" href="${pageContext.request.contextPath}/images/Avatar.png" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/Front/login.css" >
<script type="text/javascript" src="${pageContext.request.contextPath}/js/login.js"></script>
<script type="text/javascript">
var flag='1';

$(function(){
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
     var rememberme = $('#RememberMe').is(":checked");

     var temp="";
     if(username == '') {
    	temp="请输入用户名。";
     }
     if(password == '') {
  		temp="请输入密码。";
     }
     
     if(temp==""){
		 var data={"username":username,"password":password,"rememberme":rememberme};
	     $.ajax({
	    	url:"${pageContext.request.contextPath}/userLogin",
	    	data:data,
	    	type:"post",
	    	dataType:"json",
	    	success:function(result){
	    		if(result=="1"){
	    			//后面需要改回来
	    			if(username=="jiliangxiang")
	    				window.location.href= result.back_url || "${pageContext.request.contextPath}/meteringbox/successLogin";
	    			else
	    				window.location.href= result.back_url || "${pageContext.request.contextPath}/successLogin";
	    			/* setTimeout(function(){
	    				//登录返回
		    			
	    			},1000) */
	    			return true;
	    		}else{
	    			temp="用户名或密码错误。";
	    			switch(result){
		    			case -1:temp="非前端监控用户。";break;
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
	     if(cookies[i].getName().equals("wssmb_front_user")){ 
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
<!-- tiaozhuanhuidengluqian --><!-- 用于判断是前端登录页还是后端登录页，前面的注释不能删除 -->
		<div class="loginWraper">
			<div class="loginBoxbg">
				<form action="" method="post">
					<table style="width: 500px; height: 265px;" border="0" cellpadding="0" cellspacing="0">	
						<tr colspan="3" style="height: 42px;text-align:  center;vertical-align: top;">
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td colspan="3" style="height: 80px;text-align:  center;vertical-align: top;">
								<img src="${pageContext.request.contextPath}/images/Front/FrontLogin_title.png" height="40" alt="">
							</td>
						</tr>
						<tr style="vertical-align:  top; height:40px;">
							<td style="text-align: right; top: 5px; position: relative;">
								<span class="spanall">用户名：</span>
							</td>
							<td width="260">
								<input class="user" placeholder="用户名..." type="text" name="userlogin" id="userlogin" value="<%=name %>"/>
							</td>
							<td rowspan="2" style=" width: 100px;">
								<a style="position: relative; top: 11px; left: -29px; cursor: pointer; z-index:10;" onclick="login()">
									<img id="login-btn" src="${pageContext.request.contextPath}/images/Front/FrontLogin_botton.png" height="50" alt="">
								</a>
							</td>
						</tr>
						<tr style="vertical-align:  top; height:44px;">
							<td style="text-align: right; top: 5px; position: relative;">
								<span class="spanall">密&nbsp;&nbsp;&nbsp;&nbsp;码：</span>
							</td>
							<td>
								<input class="pwd" placeholder="密码..." type="password" name="userpwd" id="userpwd" value="<%=password %>"/>
							</td>
						</tr>
						<tr style="vertical-align:  top;">
							<td>&nbsp;</td>
							<td>
								<input type="checkbox" id="RememberMe" name="RememberMe" value="1">
			                    <label class="remeberText" for="RememberMe" style="font-size: 12px;color: rgba(255, 255, 255, 1);margin-left:3px;">记住密码</label>								
							</td>
							<td>&nbsp;</td>
						</tr>
					</table>
				</form>
			</div>
			
		</div>
    </body>
</html>