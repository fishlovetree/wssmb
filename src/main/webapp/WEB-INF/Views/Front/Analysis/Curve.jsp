<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
    <%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>曲线数据</title>
<%@include file="../../FrontHeader.jsp" %>
</head>
<body>
<div id="menuTab" class="easyui-tabs" data-options="border:false" style="height:100%;">
	<div id="online" title="在线率"></div>
	<div id="alarm" title="告警率"></div>
	<div id="fault" title="故障率"></div>
	<div id="realtime" title="实时曲线"></div>
	<div id="day" title="冻结曲线"></div>
</div>
<script type="text/javascript">
//tab点击事件
$('#menuTab').tabs({
    border:false,
    onSelect:function(title,index){
    	var current_tab = $('#menuTab').tabs('getSelected');
    	var tabId = current_tab.panel('options').id; // 相应的标签页id,对应控制类型
    	
    	if(current_tab.find('iframe').length == 0){
	    	var tableUrl="${pageContext.request.contextPath}/curvetype?type="+tabId;
	    	$('#menuTab').tabs('update',{
	    		tab:current_tab,
	    		options : {
	    			content : '<iframe scrolling="auto" frameborder="0" src="'+tableUrl+'" style="width:100%;height:100%;"></iframe>',
	    		}
	    	});
	    	
    	}
    	
    }
}); 
</script>
</body>
</html>

