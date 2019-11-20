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
<title>负荷分析</title>
<%@include file="../../FrontHeader.jsp"%>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/parseAlarm.js"></script>
<style type="text/css">
.layout-split-west {
	border-right: 10px solid #081a30;
}

.layout-split-north {
	border-bottom: 5px solid #212d39;
}

.tableTr {
	display: block; /*将tr设置为块体元素*/
	margin: 5px 0; /*设置tr间距为2px*/
}

.mydiv {
	float: left;
}

.tabs-header {
	border: 0;
}

#west, .datagrid-wrap, #p {
	border-image:
		url(${pageContext.request.contextPath}/js/easyui/themes/ui-dark-hive/images/body-border.png);
	border-image-slice: 6 5 6 5 fill;
	border-image-width: 2px;
}

.table-data-table {
	font-size: 13px;
	table-layout: fixed;
	empty-cells: show;
	border-collapse: collapse;
	margin: 0 auto;
	border: 1px solid #cad9ea;
	color: #2a8aba;
	width: 90%;
}

.table-data-table th {
	background-repeat: repeat-x;
}

.table-data-table td, .table-data-table th {
	border: 1px solid #2a8aba;
	padding: 0 1em 0;
}

</style>
</head>
<body>
	<!-- 公用 -->
	<input type="hidden" id="selectedID" />
	<input type="hidden" id="selectedType" />
	<input type="hidden" id="selectedAddress" />

	<div class="easyui-layout" data-options="fit:true">
		<div id="index_center" class="banner"
			data-options="region:'center',border:false,split:false">

		
			<table id="dg" style="width: 100%;"></table>
			<div id="toolbar">
				<div style="display: inline-block;">
					<label style="font-size: 14px">设备名称:</label> <input type="text"
						id='snode' class="easyui-textbox" readonly="readonly"
						style="width: 180px; height: 28px;" />
				</div>
				<div style="display: inline-block;">
					<label for="time">时间:</label> <input type="text" id='date'
						class="easyui-datebox" editable="fasle"
						style="width: 180px; height: 28px;" />
				</div>
				<a href="javascript:void(0)"
					class="easyui-linkbutton button-default" onclick="loadDataGrid()">确定</a>
			</div>
		</div>
	</div>

</body>
<script type="text/javascript">
	var node;
	var startdate="",enddate="";
	//用于使chart自适应高度和宽度,通过窗体高宽计算容器高宽
	var resizeDiv = function() {
		width = $('#west').width();
		height = $('#west').height();
		if (window.innerHeight < height)
			height = window.innerHeight - 36;//当有title时，window.innerHeight-38；反之，则window.innerHeight
		$('#left-table').width(width);
		$('#left-table').height(height);
		$('#left-tree').width(width);
		$('#left-tree').height(height - 33);
	};
	$(function() {
		node = parent.node;
		var time= new Date();
		var date=time.toLocaleTimeString();		
		$("#date").datebox('setValue', date);
		$("#snode").textbox('setValue', node.text);		
		var strdate=$("#date").val();
		startdate=strdate+" 00:00:00";
		enddate=strdate+" 23:59:59";
     
		resizeDiv();

		$("#west").panel({
			onResize : function(w, h) {
				resizeDiv();
			}
		});

		$(window).resize(function() { //浏览器窗口变化 
			resizeDiv();
		});

		var id = node.gid;
		var type = node.type;
		$('#dg')
				.datagrid(
						{
							url : '${pageContext.request.contextPath}/load/loaddata?Math.random',
							queryParams : {
								id : id,
								startdate : startdate,
								enddate : enddate
							},
							singleSelect : true,
							remoteSort : false,
							nowrap : true,//数据长度超出列宽时将会自动截取。
							rownumbers : true,//显示序号
							pagination : true,//分页控件  
							pageSize : 10,
							pageList : [ 10, 15, 50, 100 ],
							fit : true, //自适应大小
							toolbar : '#toolbar',
							columns : [ [ {
								title : '电器类型',
								field : 'type',
								width : '190px'
							}, {
								title : '累计运行时间',
								field : 'usedTime',
								width : '190px'
							}, {
								title : '累计消耗电能',
								field : 'elecUsed',
								width : '190px'
							}, {
								title : '状态',
								field : 'status',
								width : '190px',
								formatter:function(value){
										if(value==1){
											return "<span style='color:#4caf50'>开启</span>";
										}											
										else{											
												return "<span style='color:#8a8a8a'>关闭</span>"; 										
										}									
							}}] ],
							onLoadSuccess : function() {
								$('.button-view').linkbutton({});
								$('.text').textbox({
									width : 70,
									height : 30
								})
							},
						});
	});

	
	function loadDataGrid() {
		var strdate=$("#date").val();
		startdate=strdate+" 00:00:00";
		enddate=strdate+" 23:59:59";
		var queryParams = {};
			queryParams = {
				id : node.gid,				
				startdate : startdate,
				enddate : enddate,
			};
		var opts = $("#dg").datagrid("options");
		opts.url = '${pageContext.request.contextPath}/load/loaddata?Math.random';
		opts.queryParams = queryParams;
		$("#dg").datagrid("load");
	}
</script>
</html>