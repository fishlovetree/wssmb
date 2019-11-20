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
<title>终端状态</title>
<jsp:include page="../Header.jsp" />
<style type="text/css">
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
<input type="hidden" id="selectedName" />

<input type="hidden" id="selectedParentid" value="0" />
<input type="hidden" id="selectedUnitid" value="0" />
<input type="hidden" id="selectedUnitType" value="0" />
<div class="easyui-layout" fit="true">
	<div id="west" region="west" iconCls="icon-organization" split="true" title="终端" style="width: 280px;min-width:280px;height: 100%;">
		<jsp:include page="../CommonTree/unitTree.jsp"/>
	</div>
	<div id="monthPanel" region="center" style="width:900px; height: 100%;">
		<!-- 列表 -->
		<table id="dg" ></table>
		<!-- 列表-按钮 -->
		<div id="toolbar"> 
        	<label for="snode">节点:</label> 
	        <input type="text" id='snode' class="easyui-textbox" readonly="readonly" style="width: 180px;" />
	        <label for="status">状态:</label>   
			<select class="easyui-combobox" style="width:80px;" id="status" name="status">
        		<option value="">所有</option>
      			<option value="1">在线</option>
      			<option value="0">离线</option>
        	</select>
        	
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
			url :'${pageContext.request.contextPath}/sysMonitor/UnitFileInf?Math.random()',
			queryParams : {
				id : 0,
				type : "",
				nodeName : "",
	   			parentid : 0,
	   			unitid : 0,
		    	status : "",
	   			unittype : 0
		    },
			pagination : true,//分页控件
			pageList: [10, 20, 30, 40, 50],
			fit: true,   //自适应大小
			singleSelect: true,
			iconCls : 'icon-save',
			border:false,
			nowrap: true,//数据长度超出列宽时将会自动截取。
			rownumbers:true,//行号
			fitColumns:true,//自动使列适应表格宽度以防止出现水平滚动。
			toolbar : "#toolbar",
			columns: [[ 
				{title: '终端类型', field: 'typename', width:'100px'}, 
				{title: '终端地址', field: 'unitaddress', width:'125px'}, 
				{title: '终端名称', field: 'unitname', width:'200px',
					formatter : function(value, rowData, rowIndex) {
	            		if(rowData.unitflie!=null){
							return rowData.unitflie.unitname;
	            		}else{
	            			return value;
	            		}
					}	
		        },
		        {title: '状态', field: 'status',width:'80px',
					formatter : function(value, rowData, rowIndex) {
						if(value==0){
	            			return "<span style='color:red'>离线<span>";
	            		}else{
	            			return "在线";
	            		}
					}	
		        }, 
				{title: '在线时间', field: 'onlinetime', width:'140px'},
				{title: '离线时间', field: 'droppedtime', width:'140px'},
				{title: '用户名', field: 'customername', width:'180px',
					formatter : function(value, rowData, rowIndex) {
	            		if(rowData.unitflie!=null){
							return rowData.unitflie.customername;
	            		}else{
	            			return value;
	            		}
					}	
		        },
		        {title: '坐标', field: 'coordinate', width:'120px',
					formatter : function(value, rowData, rowIndex) {
	            		if(rowData.unitflie!=null){
							return rowData.unitflie.coordinate;
	            		}else{
	            			return value;
	            		}
					}	
		        }, 
		        {title: '所属楼层', field: 'buildingname', width:'100px',
					formatter : function(value, rowData, rowIndex) {
	            		if(rowData.unitflie!=null){
							return rowData.unitflie.buildingname;
	            		}else{
	            			return value;
	            		}
					}	
		        }
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
		    $("#selectedName").val(node.name);
			searchFile(n);
		}
	}

	//导航树点击设备事件
	function searchFile(node) {	
		$("#snode").textbox('setValue', node.text);

	    $("#selectedParentid").val(0);
	    $("#selectedUnitid").val(0);
	    $("#selectedUnitType").val(0);
	    
	    switch (node.type){//消防监测终端
	    case commonTreeNodeType.terminal:
	    	$("#selectedUnitType").val(1);
	    	break;
	    case commonTreeNodeType.transmission:
	    	$("#selectedUnitType").val(2);
	    	break;
	    case commonTreeNodeType.gprsBigType:
	    	var pnode = treeTab.tree('getParent', node.target);
	        $("#selectedParentid").val(pnode.gid);//customerid
	        $("#selectedUnitType").val(3);
	    	break;
	    case commonTreeNodeType.terminalBigType:
	    	var pnode = treeTab.tree('getParent', node.target);
	        $("#selectedUnitid").val(pnode.gid);//unitid
	        $("#selectedUnitType").val(1);
	    	break; 
	    case commonTreeNodeType.transmissionController:
	    	var pnode = treeTab.tree('getParent', node.target);
	        $("#selectedUnitid").val(pnode.gid);//unitid
	        $("#selectedUnitType").val(2);
	    	break;
	    case commonTreeNodeType.terminalDevice:case commonTreeNodeType.transmissionDevice:
	    	var pnode = treeTab.tree('getParent', node.target);
	        var ppnode = treeTab.tree('getParent', pnode.target);
	        $("#selectedUnitid").val(ppnode.gid);//unitid
	    	break; 
	    case commonTreeNodeType.gprsDevice:
	    	$("#selectedUnitType").val(3);
	    	break;
	    }

		doSearch();
	}
	
	function doSearch() {
		$('#dg').datagrid('load',{
			id : $("#selectedID").val(),
			type : $("#selectedType").val(),
			nodeName : $("#selectedName").val(),
   			parentid : $("#selectedParentid").val(),
   			unitid : $("#selectedUnitid").val(),
	    	status : $("#status").val(),
   			unittype : $("#selectedUnitType").val()
		});
	}
</script>
</body>
</html>