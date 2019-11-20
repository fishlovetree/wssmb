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
<jsp:include page="../../Header.jsp"/>
<style type="text/css">

	#menuTab{
		border-right: 1px solid #cfcfd1;
	}

    .l-btn-plain {
	    border: 1px solid #ccc;
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
		<jsp:include page="../../CommonTree/deviceTree.jsp"/>
	</div>
	<div id="subsystemPanel" region="center">
		<div id="menuTab" class="easyui-tabs" data-options="border:false" style="height:100%;">
			<div id="online" title="在线率"></div>
			<div id="alarm" title="告警率"></div>
			<div id="fault" title="故障率"></div>
			<div id="realtime" title="实时曲线"></div>
			<div id="day" title="冻结曲线"></div>
		</div>
	</div>
</div>

<script type="text/javascript">
var resizeDiv = function () {
	width=$('#west').width();//当有title时，width:284px;min-width:284px;；反之，则width:280px;min-width:280px;
	height=$('#west').height();
	if(window.innerHeight<height)
		height=window.innerHeight-38;//当有title时，window.innerHeight-38；反之，则window.innerHeight
	$('#left-table').width(width);
	$('#left-table').height(height);
	$('#left-tree').width(width);
	$('#left-tree').height(height-33);
	
	$('#tree_tab').tabs({
        width : width,
        height : "auto"
    }).tabs('resize');
	$('#region_tab').height(height-62);
	$('#org_tab').height(height-62);
};

var tabId = "online";
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
	    	openTab();
	    }
	}); 
	initPage();
});

function initPage(){
	node = null;
	$("#selectedID").val("");
    $("#selectedType").val("");
    $("#selectedAddress").val("");
    $('#menuTab').tabs('getTab',"实时曲线").panel('options').tab.hide();
	$('#menuTab').tabs('getTab',"冻结曲线").panel('options').tab.hide();
	$('#menuTab').tabs('select',"在线率");
	openTab();
}

//公用树点击事件
var node;
var p_node;
var pp_node;
var treeTab = $('#region_tree');
function treeClick(treeObj, n){
	if(typeof n!='undefined' ){
		node=n;
		treeTab = treeObj;
		$("#selectedID").val(node.gid);
	    $("#selectedType").val(node.type);
	    $("#selectedAddress").val(node.name);
	    if(null!=node) p_node = treeObj.tree('getParent', node.target);
		if(null!=p_node) pp_node = treeObj.tree('getParent', p_node.target);

		$('#menuTab').tabs('getTab',"实时曲线").panel('options').tab.hide();
		$('#menuTab').tabs('getTab',"冻结曲线").panel('options').tab.hide();
		
		var real = 0,day = 0;
		if(null!=p_node && p_node.gid==10){
			$('#menuTab').tabs('getTab',"实时曲线").panel('options').tab.show();
			real = 1;
		}
		
		switch (node.type){
		    case commonTreeNodeType.terminalDevice: 
		    case commonTreeNodeType.nbDevice:
		    case commonTreeNodeType.gprsDevice: 
				$('#menuTab').tabs('getTab',"冻结曲线").panel('options').tab.show();
				day = 1;
		    	break;
	    }

		var index = $('#menuTab').tabs('getTabIndex', $('#menuTab').tabs('getSelected'));
		if(index > 1){
			if(real == 0 && day == 0)
				$('#menuTab').tabs('select',2);
			else if(real == 1 && day == 0)
				$('#menuTab').tabs('select',3);
			else if(real == 0 && day == 1)
				$('#menuTab').tabs('select',4);
		}
		
		openTab();
	}
}

function openTab(){
	var current_tab = $('#menuTab').tabs('getSelected');
	tabId = current_tab.panel('options').id; // 相应的标签页id,对应控制类型
   	var tableUrl="${pageContext.request.contextPath}/sysMonitor/curvetype?type="+tabId;
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