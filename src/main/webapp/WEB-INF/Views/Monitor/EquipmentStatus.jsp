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
<title>设备在线率</title>
<jsp:include page="../Header.jsp" />
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
<input type="hidden" id="selectedName" />

<input type="hidden" id="selectedParentid" value="0" />
<input type="hidden" id="selectedUpType" value="" />
<input type="hidden" id="selectedCommType" value="" />

<div class="easyui-layout" fit="true">
	<div id="west" region="west" iconCls="icon-organization" split="true" title="设备" style="width: 284px;min-width:284px;height: 100%;">
		<jsp:include page="../CommonTree/deviceTree.jsp"/>
	</div>
	<div id="online" region="center" style="width:900px; height: 100%;">
		<!-- 列表 -->
		<table id="dg" ></table>
		<!-- 列表-按钮 -->
		<div id="toolbar"> 
        	<label for="snode">节点:</label> 
	        <input type="text" id='snode' class="easyui-textbox" readonly="readonly" style="width: 180px;" />
			
	        <label for="status">状态:</label>   
			<select class="easyui-combobox" style="width:80px;" id="status" name="status">
        		<option value="">所有</option>
      			<option value="0" selected="selected">离线</option>
      			<option value="1">正常</option>
      			<option value="2">告警</option>
      			<option value="3">故障</option>
      			<option value="4">不可通讯</option>
      			<option value="5">未下发</option>
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
			url :'${pageContext.request.contextPath}/sysMonitor/deviceFileInf?Math.random()',
			queryParams: {
				id : 0,
				type : "",
				nodeName : "",
		    	parentid : "",
		    	uptype : "",
		    	commtype : "",
		    	status : "0"
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
				{title: '设备类型', field: 'equipmenttypename', width:'120px'},
				{title: '设备名称', field: 'equipmentname', width:'160px'},
				{title: '设备地址', field: 'equipmentaddress',width:'124px'},
				{title: '设备状态', field: 'statustype', width:'80px',
					formatter : function(value, rowData, rowIndex) {
						switch(value){
						case 0: return "<span style='color:#8a8a8a'>离线</span>"; break;
						case 1: return "<span style='color:#4caf50'>正常</span>"; break;
						case 2: return "<span style='color:#ca1d1d'>告警</span>"; break;
						case 3: return "<span style='color:#d4941f'>故障</span>"; break;
						case 4: return "<span style='color:#8a8a8a'>不可通讯</span>"; break;
						case 5: return "<span style='color:#8a8a8a'>未下发</span>"; break;
						default: return ""; break;
						}
					}	
		        },
		        {title: '所属终端状态', field: 'unitstatus', width:'80px',
					formatter : function(value, rowData, rowIndex) {
						switch(value){
						case 0: return "<span style='color:#8a8a8a'>离线</span>"; break;
						case 1: return "<span style='color:#4caf50'>在线</span>"; break;
						default: return ""; break;
						}
					}	
		        },
		        {title: '冻结类型', field: 'freezingtype', width:'80px',
					formatter : function(value, rowData, rowIndex) {
						switch(value){
						case 11: return "日冻结"; break;
						case 77: return "周冻结"; break;
						case 99: return "月冻结"; break;
						default: return ""; break;
						}
					}	
		        },
		        {title: '上次冻结时间', field: 'freezetime', width:'140px'}, 
		        {title: '上次告警时间', field: 'alarmtime', width:'140px'}, 
		        {title: '上次故障时间', field: 'faulttime', width:'140px'}, 
		        {title: '用户', field: 'customername', width:'140px'},
		        {title: '系统类型', field: 'systemtypename', width:'200px'},  
		        {title: '所属楼层', field: 'buildingname', width:'100px'}, 
		        {title: '安装位置', field: 'installationsite', width:'150px'}
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
	    $("#selectedUpType").val("");
	    $("#selectedCommType").val("");
        
		switch (node.type){//消防监测终端
		case commonTreeNodeType.terminalBigType:
	    	var pnode = treeTab.tree('getParent', node.target);
	        $("#selectedParentid").val(pnode.gid);//customerid
	        $("#selectedUpType").val("1");
	    	break;
	    case commonTreeNodeType.transmissionController:
	    	var pnode = treeTab.tree('getParent', node.target);
	        $("#selectedParentid").val(pnode.gid);//customerid
	        $("#selectedUpType").val("2");
	    	break;
	    case commonTreeNodeType.gprsBigType:
	    	var pnode = treeTab.tree('getParent', node.target);
	        $("#selectedParentid").val(pnode.gid);//customerid
	        $("#selectedUpType").val("0");
		    $("#selectedCommType").val("3");
	    	break;
	    case commonTreeNodeType.nbBigType:
	    	var pnode = treeTab.tree('getParent', node.target);
	        $("#selectedParentid").val(pnode.gid);//customerid
	        $("#selectedUpType").val("0");
		    $("#selectedCommType").val("4");
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
	    	uptype : $("#selectedUpType").val(),
	    	commtype : $("#selectedCommType").val(),
	    	status : $("#status").val()
		});
	}
</script>
</body>
</html>