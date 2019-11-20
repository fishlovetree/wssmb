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
<title>非侵入式负荷分析</title>
<%@include file="../../FrontHeader.jsp" %>
<style type="text/css">
#organizationtree, #region_tree {
	border-color: transparent;
}

#dayPanel .panel-header {
	border-top: 2px solid #ccc;
}

.l-btn-plain {
	border: 1px solid #ccc;
}
.cbktext{
	vertical-align: middle;
	margin:0 5px 0 5px;
}
.layout-split-west {
    border-right: 10px solid #081a30;
}
#west, #subsystemPanel {
    border-image: url(${pageContext.request.contextPath}/js/easyui/themes/ui-dark-hive/images/body-border.png);
	border-image-slice: 6 5 6 5 fill;
    border-image-width: 2px;
}
#west.panel-body {
    background-color: #081a30;
}
.table-data-table {
    color: blue;
}
.icon-clear {
    background: url(${pageContext.request.contextPath}/js/easyui/themes/icons/clear.png) no-repeat center center !important;
}
</style>
</head>
<body>
<!-- 公用 -->
<input type="hidden" id="selectedID" /> 
<input type="hidden" id="selectedType" /> 
<input type="hidden" id="selectedAddress" />

<div class="easyui-layout" fit="true">
	<div id="west" region="west" iconCls="icon-organization" split="true" title="" style="width: 280px;min-width:280px;height: 100%;">
		<%@include file="../../CommonTree/f_OnlineTree.jsp" %>
	</div>
	<div id="subsystemPanel" region="center">
		<div id="menuTab" class="easyui-tabs" data-options="border:false" style="height:100%;">
			<div id="load" title="用电质量分析"></div>		
		</div>
	</div>
</div>

<script type="text/javascript">
var resizeDiv = function () {
 	width=$('#west').width();
 	height=$('#west').height();
	if(window.innerHeight<height)
		height=window.innerHeight;//当有title时，window.innerHeight-38；反之，则window.innerHeight
	$('#left-table').width(width);
	$('#left-table').height(height);
	$('#left-tree').width(width);
	$('#left-tree').height(height-33);
};

var tabId = "load";
$(function() {	
	resizeDiv();
	
	$("#west").panel({
        onResize: function (w, h) {
        	resizeDiv();
        }
    });
	
	$(window).resize(function(){ //浏览器窗口变化 
		resizeDiv();
	});

	//tab点击事件
	$('#menuTab').tabs({
	    border:false,
	    onSelect:function(title,index){
	    	if(node.type==6||node.type==5){
	    		openTab();
	    	}
	    	
	    }
	}); 

});


//公用树点击事件
var node;
var p_node;
var pp_node;
function treeClick(n){
	if(typeof n!='undefined' ){
		node=n;
		$("#selectedID").val(node.gid);
	    $("#selectedType").val(node.type);
	    $("#selectedAddress").val(node.name);
	    if(null!=node) p_node = $('#region_tree').tree('getParent', node.target);
		if(null!=p_node) pp_node = $('#region_tree').tree('getParent', p_node.target);
			
		var index = $('#menuTab').tabs('getTabIndex', $('#menuTab').tabs('getSelected'));		
		$('#menuTab').tabs('select',index);
		
		if(node.type==6||node.type==5){
			openTab();
		}
		
	}
}

function openTab(){
	var current_tab = $('#menuTab').tabs('getSelected');
   	var tableUrl="${pageContext.request.contextPath}/complex/load";
   	$('#menuTab').tabs('update',{
   		tab:current_tab,
   		options : {
   			content : '<iframe scrolling="auto" frameborder="0" id="curvetype'+tabId+'" src="'+tableUrl+'" style="width:100%;height:100%;"></iframe>',
   		}
   	});
}

</script>
</body>
</html>