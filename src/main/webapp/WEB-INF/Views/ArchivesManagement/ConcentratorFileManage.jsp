<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
    <%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
<jsp:include page="../Header.jsp"/>
<style type="text/css">
#organizationtree, #regiontree {
    border-color: transparent;
}
#menuTab .tabs-panels{
	border-left:0px;
	border-right:0px;
}
.layout-split-west {
    border-right: 1px solid #ccc;
}
.table-data-table{
    border-collapse: collapse;
    width:100%;
    height: 170px;
} 
</style>
</head>
<body>
<!-- 布局 -->	
<div class="easyui-layout" style="width:100%;height:100%;">
	<div id="west" region="west" iconCls="icon-organization" split="true" title="" style="width:280px;min-width:280px;" collapsible="true">
		<jsp:include page="../CommonTree/concentratorTree.jsp"/>
	</div>
	
	<div data-options="region:'center',iconCls:'icon-ok'" title="">
		<!-- 列表 -->
	<table id="dg" style="width: 100%;" toolbar="#toolbar"
		iconCls="icon-save" rownumbers="true" pagination="true"
		fitColumns="true" singleSelect="true" nowrap="true" fit="true">
	</table>
		<!-- 列表-按钮 -->
		<!-- 列表-按钮 -->
	<div id="toolbar">
		<form id="imfm" class="easyui-form" method="post"
			enctype="multipart/form-data">
			<a href="#" class="easyui-linkbutton"
				data-options="iconCls:'icon-add'" onclick="add()"><spring:message
					code="Add" /></a> <a href="#" class="easyui-linkbutton"
				data-options="iconCls:'icon-edit'" onclick="edit()"><spring:message
					code="Edit" /></a> <a href="#" class="easyui-linkbutton"
				data-options="iconCls:'icon-remove'" onclick="deleteConcentrator()"><spring:message
					code="Delete" /></a>
					<input class="easyui-filebox"
				style="width: 180px" id="excelfile" name="excelfile"
				data-options="prompt:'选择一个文件...', buttonText: '选择文件',buttonAlign:'left'"></input>
			<a href="#" class="easyui-linkbutton"
				data-options="iconCls:'icon-import'" onclick="importConcentrator()"><spring:message
					code="Import"  /></a> <a href="#" class="easyui-linkbutton"
				data-options="iconCls:'icon-export'" onclick="exportConcentrator()"><spring:message
					code="Export" /></a>
		</form>
		<!-- 导出 -->
		<form id="exfm"
			action='${pageContext.request.contextPath}/concentratorFile/exportExcel'
			method="get">
			<input type="hidden" name="nodetype" id="nodetype" />
			 <input type="hidden" name="nodegid" id="nodegid" />
			  <input type="hidden" name="searchname" id="searchname" />
			   <input type="hidden" name="searchaddress" id="searchaddress" />
		</form>
		<div style="display: inline-block;">
        				<label style="font-size:14px">集中器名称:</label>
						<input id="ConcentratorName" class="easyui-textbox" style="width:160px;height:26px;" data-options="
		                   prompt: '请输入名称……'"/>
        			</div>      			
			<div style="display: inline-block;">
        				<label style="font-size:14px">集中器地址:</label>
						<input id="Address" class="easyui-textbox" style="width:160px;height:26px;" data-options="
		                   prompt: '请输入地址……'"/>
        			</div>
        				        <a href="javascript:void(0)" class="easyui-linkbutton button-edit button-default" data-options="iconCls:'icon-search'" onclick="doSearch()" title="Search">检索</a>
	</div>
	</div>
</div>

<div id="dlg" class="easyui-dialog"
		style="width: 665px; height: 420px; padding: 10px 20px" closed="true"
		buttons="#dlg-buttons">
		<form id="fm" class="easyui-form" method="POST">
			<table cellspacing="8">
				<tr>
					<td>				
					<input type="hidden" id="concentratorId" name="concentratorId">		
					<input type="hidden" id="region" name="region">		
					<input class="easyui-textbox" type="text"
						style="width: 300px" name="concentratorName" id="fconcentratorName"  
						data-options="label:'集中器名称',required:true,validType:'maxlength[20]'"></input></td>
						<td><input class="easyui-textbox" type="text"
						style="width: 300px" name="address"
						data-options="label:'集中器地址',required:true,validType:'maxlength[50]'"></input></td>
				</tr>
				<tr>
				    <td><input class="easyui-textbox" type="text"
						style="width: 300px" name="installationLocation"
						data-options="label:'安装位置',validType:'maxlength[20]'"></input></td>
						<td>									
					<input class="easyui-textbox" type="text"
						style="width: 300px" name="simCard" id="simCard"  
						data-options="label:'SIM卡号',validType:'maxlength[20]'"></input></td>							
				</tr>
			<tr>
				  <tr>
					<td><select class="easyui-combotree"
									url="${pageContext.request.contextPath}/organization/organizationTree?Math.random()"
									name="fatherOrgID" id="fatherOrgID" style="width: 300px;" data-options="label:'组织机构',required:true,
									onSelect: function(node) {
									  var url = '${pageContext.request.contextPath}/measureFile/getMeasurefileByOrganizationId?OrganizationId='+node.gid
								    	$('#measureIds').combobox('reload', url);
								    	$('#organizationId').val(node.gid);
								    	$('#measureIds').combobox('setValue','');
								    }">
								</select>
								<input type="hidden" name="organizationId" id="organizationId"/></td>								 	
						<td><select class="easyui-combobox"
									url="${pageContext.request.contextPath}/measureFile/getMeasurefileByOrganizationId?OrganizationId=0"
									 id="measureIds" style="width: 300px;" data-options="label:'所属表箱',required:true,
									 editable:false,valueField:'MeasureId', textField:'MeasureName',
									onSelect: function(node) {
								    	$('#measureId').val(node.MeasureId);
								    	$('#region').val(node.Region);
								    }">
								</select>
								<input type="hidden" name="measureId" id="measureId"/>
							</td>									 	
						</tr>									 						
				
				<tr>
				<td><input class="easyui-textbox" type="text"
						style="width: 300px" name="manufacturer"
						data-options="label:'生产厂家',validType:'maxlength[20]'"></input></td>
				    <td><input class="easyui-datetimebox" editable="fasle" type="text" 
				    style="width:300px" name="produceDate" data-options="label:'生产日期'"></input></td>				      
				</tr>			
				<tr>					
					<td><input class="easyui-textbox" type="text"
						style="width: 300px" name="softType" id="softType"
						data-options="label:'软件版本号',validType:'maxlength[20]'"></input></td>						
						<td><input class="easyui-textbox" type="text"
						style="width: 300px" name="hardType"
						data-options="label:'硬件版本号',validType:'maxlength[50]'"></input></td>
				</tr>
				<tr>
					<td>							
					<input class="easyui-numberbox" type="text"
						style="width: 300px" name="concentratorType" id="concentratorType"  
						data-options="label:'集中器型号',validType:'maxlength[20]'"></input></td>
						<td><input class="easyui-numberbox" type="text"
						style="width: 300px" name="statuteType"
						data-options="label:'规约类型',validType:'maxlength[50]'"></input></td>
				</tr>		
			</table>
		</form>
	</div>
<div id="dlg-buttons">
		<a href="#" class="easyui-linkbutton" iconCls="icon-ok"
			onclick="save()"><spring:message code="Save" /></a> <a href="#"
			class="easyui-linkbutton" iconCls="icon-cancel"
			onclick="javascript:$('#dlg').dialog('close')"><spring:message
				code="Cancel" /></a>
	</div>

<script type="text/javascript">	
	//用于使chart自适应高度和宽度,通过窗体高宽计算容器高宽
	var resizeDiv = function () {
		width=$('#west').width();//当有title时，width:284px;min-width:284px;；反之，则width:280px;min-width:280px;
		height=$('#west').height();
		if(window.innerHeight<height)
			height=window.innerHeight;//当有title时，window.innerHeight-38；反之，则window.innerHeight
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

	$(function(){  
		resizeDiv();
		
		$("#west").panel({
	        onResize: function (w, h) {
	        	resizeDiv();
	        }
	    });
		
		$(window).resize(function(){ //浏览器窗口变化 
			resizeDiv();
		});

		$('#dg').datagrid(
				{
					url : '${pageContext.request.contextPath}/concentratorFile/getDataGrid?Math.random()',
					pagination : true,//分页控件
					pageList : [ 10, 20, 30, 40, 50 ],
					fit : true, //自适应大小
					singleSelect : true,
					iconCls : 'icon-save',
					border : false,
					nowrap : true,//数据长度超出列宽时将会自动截取。
					rownumbers : true,//行号
					fitColumns : true,//自动使列适应表格宽度以防止出现水平滚动。
					columns : [ [{
						title : '集中器名称',
						field : 'concentratorName',
						width : '180px'
					}, {
						title : '集中器地址',
						field : 'address',
						width : '200px',						
					}, {
						title : '安装位置',
						field : 'installationLocation',
						width : '200px'
					}, {
						title : '所属表箱',
						field : 'measureName',
						width : '120px'
					}, {
						title : '组织机构',
						field : 'organizationName',
						width : '120px'
					}, {
						title : '生产厂家',
						field : 'manufacturer',
						width : '100px'
					}, {
						title : '生产日期',
						field : 'produceDate',
						width : '100px'
					}, {
						title : '创建人',
						field : 'creater',
						width : '100px'
					}, {
						title : '创建日期',
						field : 'createDate',
						width : '100px'
					}, {
						title : 'SIM卡',
						field : 'simCard',
						width : '100px'
					}, {
						title : '软件版本号',
						field : 'softType',
						width : '100px'
					}, {
						title : '硬件版本号',
						field : 'hardType',
						width : '100px'
					}, {
						title : '集中器型号',
						field : 'concentratorType',
						width : '100px'
					}, {
						title : '规约类型',
						field : 'statuteType',
						width : '100px'
					}] ],
					onDblClickCell : function(index, field, value) {
						edit();
					}
	    }) 
	});

	</script>

<script type="text/javascript">
window.top["reload_taskTab"] = function () {  
    $("#dg").datagrid('reload');//刷新  
    $("#region_tree").tree('reload');
    $("#org_tree").tree('reload');
};  
//添加
function add() {
	$('#dlg').dialog('open').dialog('setTitle', '添加');
	$('#fm').form('clear');
	url = '${pageContext.request.contextPath}/concentratorFile/addOrUpdate';
}

//修改
function edit() {
	var row = $('#dg').datagrid('getSelected');
	if (row) {	
		var organizationId=row.organizationId;		
		$('#fatherOrgID').combotree("setValue",{
			id:row.organizationName		
		});	
		
		//重载combo链接
	//	$('#measureIds').combobox('reload','${pageContext.request.contextPath}/measureFile/getMeasurefileByOrganizationId?OrganizationId='+organizationId);
		$('#dlg').dialog('open').dialog('setTitle', '修改');		    			
		$('#fm').form('load', row);
		$('#measureIds').combobox('setValue',row.measureId);
		url = '${pageContext.request.contextPath}/concentratorFile/addOrUpdate';
	}
}
//保存
function save() {
	$('#fm').form('submit', {
		url : url,
		onSubmit : function() {
			return $(this).form('validate');
		},
		success : function(result) {
			if (result == "success") {
				$('#dlg').dialog('close'); // close the dialog
				$('#dg').datagrid('reload'); // reload the user data
			} else {
				$.messager.alert('警告', result, 'error');
			}
		},
		error : function(data) {
			$.messager.alert('警告', data, 'error');

		}
	});
}

//删除
function deleteConcentrator() {
	var row = $('#dg').datagrid('getSelected');
	if (row) {
		$.messager.confirm('删除', '你确定要删除该集中器信息吗？', function(r) 
		{
			if (r) {
				var data = {
						"concentratorId" : row.concentratorId						
				};
				$.ajax({
					type : 'POST',
					url : '${pageContext.request.contextPath}/concentratorFile/delete',
					data : data,
					success : function(data) {
						if (data == "success") {
							$('#dg').datagrid(
									'reload'); // reload the user data
							$.messager.alert(
									'提示',
									'删除成功。',
									'info');
						}  else {
							$.messager.alert(
									'警告', data,
									'error');
						}

					},
					error : function(data) {
						$.messager.alert('警告',
								data, 'error');

					}
				});
			}
		});
	}
}

//导入
function importConcentrator() {
	var path = $("#excelfile").textbox("getValue");
	if (null == path || path == "") {
		$.messager.alert('<spring:message code="Prompt"/>',
				'<spring:message code="Choose_a_file"/>', 'warning');
		return false;
	}

	//根据文件导入
	$('#imfm').form('submit',
	{
		url : '${pageContext.request.contextPath}/concentratorFile/importExcel',
		onSubmit : function() {
			return $(this).form('validate');
		},
		success : function(data) {
			if (data == "success") {
				$.messager.alert('提示',
								'导入成功。',
								'info');
				$('#dg').datagrid('reload'); // reload the data									
			} else {
				$.messager.alert('警告', data, 'error');
			}
		},
		error : function(data) {
			$.messager.alert(
					'<spring:message code="Warning"/>',
					data, 'error');
		}
	});
}

//导出
function exportConcentrator() {
	$('#exfm').form('submit');
}

function doSearch() {
	var ConcentratorName=$('#ConcentratorName').val();	
	var Address=$('#Address').val();
	//导出execl用
	$("#searchname").val(ConcentratorName);
	$("#searchaddress").val(Address);
	$('#dg').datagrid({
		url :'${pageContext.request.contextPath}/concentratorFile/ConcentratorInf?Math.random()',
		queryParams: {
			ConcentratorName :ConcentratorName,
			Address : Address,		 	
		},
		pagination : true,//分页控件
		pageList: [10, 20, 30, 40, 50],
		fit: true,   //自适应大小
		singleSelect: true,
		border:false,
		nowrap: true,//数据长度超出列宽时将会自动截取。
		rownumbers:true,//行号
		fitColumns:true,//自动使列适应表格宽度以防止出现水平滚动。
		columns : [ [{
			title : '集中器名称',
			field : 'concentratorName',
			width : '180px'
		}, {
			title : '集中器地址',
			field : 'address',
			width : '200px',						
		}, {
			title : '安装位置',
			field : 'installationLocation',
			width : '200px'
		}, {
			title : '所属表箱',
			field : 'measureName',
			width : '120px'
		}, {
			title : '组织机构',
			field : 'organizationName',
			width : '120px'
		}, {
			title : '生产厂家',
			field : 'manufacturer',
			width : '100px'
		}, {
			title : '生产日期',
			field : 'produceDate',
			width : '100px'
		}, {
			title : '创建人',
			field : 'creater',
			width : '100px'
		}, {
			title : '创建日期',
			field : 'createDate',
			width : '100px'
		}, {
			title : 'SIM卡',
			field : 'simCard',
			width : '100px'
		}, {
			title : '软件版本号',
			field : 'softType',
			width : '100px'
		}, {
			title : '硬件版本号',
			field : 'hardType',
			width : '100px'
		}, {
			title : '集中器型号',
			field : 'concentratorType',
			width : '100px'
		}, {
			title : '规约类型',
			field : 'statuteType',
			width : '100px'
		}] ]
	   }) 
}

</script>

<script type="text/javascript">
var treeTab = $('#region_tree');
//公用树点击事件
var node;
function treeClick(treeObj, n){
	if(typeof n!='undefined' ){
		node=n;
		treeTab = treeObj;
		 $("#nodetype").val(node.type);
		 $("#nodegid").val(node.gid);	
		searchConcentrator();
	}
}

function searchConcentrator() {
	$("#dg").datagrid('load', {
		id : node.gid,
    	type : node.type,
    	name : $('#ConcentratorName').val(),
    	address : $('#Address').val()
	});
}
</script>
</body>
</html>