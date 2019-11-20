<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>电表状态</title>
<%@include file="../../Header.jsp" %>
<style type="text/css">
#organizationtree, #regiontree {
	border-color: transparent;
}


#monthPanel .panel-header {
	border-top: 2px solid #ccc;
}

.l-btn-plain {
	border: 0px solid #ccc; 
}
	.layout-split-west {
	    border-right: 1px solid #ccc;
	}
</style>
</head>
<body>
<!-- 公用 -->
<input type="hidden" id="selectedID" /> 
<input type="hidden" id="selectedType" /> 

<div class="easyui-layout" fit="true">
	<div id="west" region="west" iconCls="icon-organization" split="true" title="设备" style="width: 284px;min-width:284px;height: 100%;">
		<%@include file="../../CommonTree/ammeterTree.jsp" %>
	</div>
	<div id="online" region="center" style="width:900px; height: 100%;">
		<!-- 列表 -->
		<table id="dg" ></table>
		<!-- 列表-按钮 -->
		<div id="toolbar"> 
        	<label for="snode">节点:</label> 
	        <input type="text" id='snode' class="easyui-textbox" readonly="readonly" style="width: 180px;" />					
			<div style="display: inline-block;">
		        <label for="status">设备状态:</label>   
				<select class="easyui-combobox" style="width:80px;" id="status" name="status">
	        		<option value="">所有</option>
	      			<option value="0">离线</option>
	      			<option value="1" selected="selected">在线</option>      		
	        	</select>
        	</div>
	        <a href="javascript:void(0)" class="easyui-linkbutton button-edit button-default" data-options="iconCls:'icon-search'" onclick="doSearch()" title="Search">检索</a>	
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
		
		$('#dg').datagrid({
			url :'${pageContext.request.contextPath}/sysMonitor/ammeterStatus?Math.random()',
			queryParams: {
				id : 0,
				type : "",		
		    	status : "1"
			},
			pagination : true,//分页控件
			pageList: [10, 20, 30, 40, 50],
			fit: true,   //自适应大小
			singleSelect: true,
			border:false,
			nowrap: true,//数据长度超出列宽时将会自动截取。
			rownumbers:true,//行号
			fitColumns:true,//自动使列适应表格宽度以防止出现水平滚动。
			toolbar : "#toolbar",
			columns: [[ 
				{title: '表号', field: 'ammeterCode', width:'120px'},
				{title: '电表名称', field: 'ammeterName', width:'160px'},
				{title: '状态', field: 'status', width:'80px',
					formatter : function(value, rowData, rowIndex) {
						switch(value){
						case 0: return "<span style='color:#8a8a8a'>离线</span>"; break;
						case 1: return "<span style='color:#4caf50'>在线</span>"; break;			
						default: return ""; break;
						}
					}	
		        },
		        {title: '上次冻结时间', field: 'lastFreezeTime', width:'140px'}, 
		        {title: '上次告警时间', field: 'lastEarlyWarnTime', width:'140px'}, 
		        {title: '上次故障时间', field: 'lastFaultTime', width:'140px'}, 
		        {title: '安装位置', field: 'installAddress', width:'140px'},
		        {title: '所属集中器', field: 'concentratorName', width:'200px'},  		     
			]]
		});
	})
	
	var treeTab = $('#region_tree');
	//公用树点击事件
	var node;
	function treeClick(treeObj, n){
		if(typeof n!='undefined' ){
			node = n;
			treeTab = treeObj;
			$("#selectedID").val(node.gid);
		    $("#selectedType").val(node.type);
			searchFile(n);
		}
	}

	//导航树点击设备事件
	function searchFile(node) {			
		if(node.type!=5){
		  $("#snode").textbox('setValue', node.text);       
		  doSearch();
		}	
	}
	
	function doSearch() {
		$('#dg').datagrid('load',{
			id : $("#selectedID").val(),
			type : $("#selectedType").val(),
	    	status : $("#status").combobox("getValue"),
		});
	}
</script>
</body>
</html>