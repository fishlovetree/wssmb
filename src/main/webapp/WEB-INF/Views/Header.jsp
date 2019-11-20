<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link href="${pageContext.request.contextPath}/js/easyui/themes/insdep-customize/easyui.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/js/easyui/themes/insdep-customize/customize.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/js/easyui/themes/insdep-customize/easyui_animation.css" rel="stylesheet" type="text/css">
<!--easyui_animation.css是EasyUI组件等支持动画效果。（可选）--> 
<link href="${pageContext.request.contextPath}/js/easyui/themes/insdep-customize/easyui_plus.css" rel="stylesheet" type="text/css">
<!--easyui_plus.css是EasyUI的增强样式表，使其支持更多的额外组件。（可选）--> 
<link href="${pageContext.request.contextPath}/js/easyui/themes/insdep-customize/insdep_theme_default.css" rel="stylesheet" type="text/css">
<!-- FontAwesome字体图标 -->
<link type="text/css" href="${pageContext.request.contextPath}/css/font-awesome/css/font-awesome.min.css" rel="stylesheet"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/easyui/themes/icon.css">
<%-- <link type="text/css" href="${pageContext.request.contextPath}/css/themes/${requestScope.theme}.css" rel="stylesheet"> --%>

<link href="${pageContext.request.contextPath}/css/jquery.searchableSelect.css" rel="stylesheet" type="text/css">

<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/themes/insdep-customize/jquery.insdep-extend.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/global.js"></script>
<!-- websocket断线重连 -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/reconnecting-websocket.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery.searchableSelect.js"></script>
<script>
	var basePath = '${pageContext.request.contextPath}';
	
	//获取主题
	var theme=1;
	
	$(function getTheme(){
	  $.ajax({
	     	url:'${pageContext.request.contextPath}/user/getTheme?Math.random()',  
	     	type:"post",
	     	success:function(data){
	     		theme=data;
	     		
	     		var href="";
	     		  if(theme==2)
	     		  	  href="/css/themes/Blue.css";
	     		  else
	     			  href="/css/themes/Yellow.css";
	     			  
	     		  var head = document.getElementsByTagName('head')[0];
	     	      var link = document.createElement('link');
	     	      link.type='text/css';
	     	      link.rel = 'stylesheet';
	     	      link.href = href;
	     	      head.appendChild(link);
	     		 
	     			//$('<LINK href='+href+' type=text/css rel=stylesheet>').appendTo("head");
	     	},
	     	error:function(e){
	     		$.messager.alert('<spring:message code="Warning"/>','获取主题失败！', 'error');
	     	}
	 });
 
	});
</script>