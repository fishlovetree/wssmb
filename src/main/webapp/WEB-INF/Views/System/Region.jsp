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
<title>区域</title>
<jsp:include page="../Header.jsp"/>
</head>
<body>
	<table id="dg" toolbar="#toolbar" >
	</table>
	<div id="toolbar">
		<!--<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="addRegion()"><spring:message code="Add"/></a>-->
		<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" onclick="editRegion()"><spring:message code="Edit"/></a>
		<!--<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="destroyRegion()"><spring:message code="Delete"/></a>-->
		<input class="easyui-textbox" type="text" id="searchName"
						data-options="label:'区域名称:',validType:'maxlength[25]'"></input>
		<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="searchRegion()">检索</a>
	</div>
	<div id="dlg" class="easyui-dialog"
		style="width: 450px; height: 380px; padding: 10px 20px" closed="true"
		buttons="#dlg-buttons">
		<form id="fm" class="easyui-form" method="post">
			<table cellspacing="8">
			    <tr>
					<td colspan="2"><select class="easyui-combotree" id="parentid" style="width: 100%"
						url="${pageContext.request.contextPath}/region/regionTreeGrid"
						name="parentid" style="width: 100%;" data-options="label:'上级区域'">
					</select></td>
				</tr>
			    <tr>
					<td colspan="2"><input class="easyui-numberbox" type="text"
						style="width: 100%" name="id"
						data-options="label:'区域代码',required:true,max:999999"></input></td>
				</tr>
				<tr style="margin-bottom: 20px">
					<td colspan="2"><input class="easyui-textbox" type="text"
						style="width: 100%" name="name"
						data-options="label:'区域名称',required:true,validType:'maxlength[25]'"></input></td>
				</tr>
				<tr style="margin-bottom: 20px">
					<td colspan="2"><input class="easyui-textbox" type="text"
						style="width: 100%" name="shortname"
						data-options="label:'简写',validType:'maxlength[25]'"></input></td>
				</tr>
				<tr>
					<td colspan="2"><input class="easyui-numberbox" type="text"
						style="width: 100%" name="leveltype"
						data-options="label:'层级',required:true,max:10"></input></td>
				</tr>
				<tr style="margin-bottom: 20px">
					<td colspan="2"><input class="easyui-textbox" type="text"
						style="width: 100%" name="citycode"
						data-options="label:'区号',validType:'maxlength[10]'"></input></td>
				</tr>
				<tr style="margin-bottom: 20px">
					<td colspan="2"><input class="easyui-textbox" type="text"
						style="width: 100%" name="zipcode"
						data-options="label:'邮政编码',validType:'maxlength[10]'"></input></td>
				</tr>
				<tr style="margin-bottom: 20px">
					<td colspan="2"><input class="easyui-textbox" type="text"
						style="width: 100%" name="mergername"
						data-options="label:'全地址',validType:'maxlength[50]'"></input></td>
				</tr>
				<tr style="margin-bottom: 20px">
					<td colspan="2"><input class="easyui-textbox" type="text"
						style="width: 100%" name="pinyin"
						data-options="label:'拼音',validType:'maxlength[25]'"></input></td>
				</tr>
				<tr style="margin-bottom: 20px">
					<td colspan="2"><input class="easyui-textbox shorttextbox" style="width: 100%" name="lng" id="lng"
						data-options="label:'经度',required:true,validType:'IntOrFloat'"></input>
					</td>
				</tr>
				<tr style="margin-bottom: 20px">
					<td colspan="2"><input class="easyui-textbox shorttextbox" style="width: 100%" name="lat" id="lat"
						data-options="label:'纬度',required:true,validType:'IntOrFloat'"></input>
					</td>
					<td colspan="2">
						<a href="#" class="easyui-linkbutton" onclick="pickCoords()" id="">拾取</a>
					</td>
				</tr>
			</table>
		</form>
	</div>
	<div id="dlg-buttons">
		<a href="#" class="easyui-linkbutton" iconCls="icon-ok"
			onclick="saveRegion()"><spring:message code="Save" /></a> <a
			href="#" class="easyui-linkbutton" iconCls="icon-cancel"
			onclick="javascript:$('#dlg').dialog('close')"><spring:message
				code="Cancel" /></a>
	</div>
	<!-- 坐标拾取dialog -->
	<div id="pickCoordsDlg" class="easyui-dialog" close="true" buttons="#pickCoordsDlg-buttons" style="width:650px;height:400px;position: relative;"></div>
	<div id="pickCoordsDlg-buttons">
		<a href="#" class="easyui-linkbutton" iconCls="icon-ok" id="getCoordsButton">确定</a>
		<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#pickCoordsDlg').dialog('close')"><spring:message code="Cancel"/></a>
	</div>
	
	<script type="text/javascript">
		$(function() {
			$('#dg').datagrid({
				fit : true,
				url : "${pageContext.request.contextPath}/region/regionDataGrid",
				pagination : true,//分页控件
		    	pageList: [10, 20, 30, 40, 50],
		    	pageSize: 10,
				striped : true,
				showFooter : true,
				rownumbers: true,
				singleSelect : true,
				columns : [ [ {
					title : '区域代码',
					field : 'id',
					width : '80'
				},{
					title : '区域名称',
					field : 'name',
					width : '100',
					align: 'left'
				}, {
					title : '简写',
					field : 'shortname',
					width : '80'
				},{
					title : '层级',
					field : 'leveltype',
					width : '60'
				},{
					title : '区号',
					field : 'citycode',
					width : '80'
				},{
					title : '邮政编码',
					field : 'zipcode',
					width : '80'
				},{
					title : '全地址',
					field : 'mergername',
					width : '150'
				},{
					title : '经度',
					field : 'lng',
					width : '120'
				},{
					title : '纬度',
					field : 'lat',
					width : '120'
				},{
					title : '拼音',
					field : 'pinyin',
					width : '80'
				} ] ],
				onDblClickRow : function(row) {
					editRegion();
				}
			})
			
			$('#pickCoordsDlg').dialog('close');
		});
	</script>

	<script type="text/javascript">
		var url = "";
		
		//添加区域
		function addRegion() {
			$('#parentid').combotree('reload', '${pageContext.request.contextPath}/region/regionTreeGrid');
			$('#dlg').dialog('open').dialog('setTitle',
					'<spring:message code="添加"/>');
			$('#fm').form('clear');
			url = '${pageContext.request.contextPath}/region/addRegion';
		}

		//编辑区域
		function editRegion() {
			var row = $('#dg').datagrid('getSelected');
			if (row) {
				$('#parentid').combotree('reload', '${pageContext.request.contextPath}/region/regionTreeGrid?regionid=' + row.id);
				$('#dlg').dialog('open').dialog('setTitle',
						'<spring:message code="编辑"/>');
				$('#fm').form('load', row);
				url = '${pageContext.request.contextPath}/region/editRegion?regionid='
						+ row.id;
			}
			else {
				$.messager.alert('提示', '请选择需要编辑的区域。','warning');
			}
		}
		//保存
		function saveRegion() {
			$('#fm').form('submit', {
				url : url,
				onSubmit : function() {
					return $(this).form('validate');
				},
				success : function(result) {
					if (result == "success") {
						$('#dlg').dialog('close'); // close the dialog
						$('#dg').datagrid('reload'); // reload the user data
					} else if (result == "repeat") {
						$.messager.alert('提示', '区域代码已经存在。', 'warning');
					} else {
						$.messager.alert('警告', '操作失败，请重试。', 'error');
					}

				}
			});
		}

		//删除区域
		function destroyRegion() {
			var row = $('#dg').datagrid('getSelected');
			if (row) {
				$.messager.confirm('删除区域', '你确定要删除该区域吗？',
					function(r) {
						if (r) {
							$.ajax({
								type: 'POST',
								url: '${pageContext.request.contextPath}/region/deleteRegion',
								data: {
									"id" : row.id
								},
								success: function(data) {
									if (data  == 'success') {
										$('#dg').datagrid('reload');
									}
									else if(data == "children"){
										$.messager.alert('提示', '请先删除下级区域。','warning');
									}
									else {
										$.messager.alert('警告', '删除失败，请重试。','error');
									}
								}
							});
						}
					});
			}
			else {
				$.messager.alert('提示', '请选择需要删除的区域。','warning');
			}
		}
		
		//检索区域
		function searchRegion(){
			var searchName = $("#searchName").val();
			$('#dg').datagrid('load', {"regionName": searchName});
		}
		
		//拾取设备坐标
		function pickCoords(){				
			var longitude = $("#lng").val(),latitude = $("#lat").val();;
			var coordsStr = "";
			if(longitude != "" && latitude != ""){
				coordsStr = "[" + longitude + "," + latitude + "]";
			}
			var url = '${pageContext.request.contextPath}/region/coordsPick?coords='+window.encodeURI(coordsStr);
			var content = '<iframe src="' + url + '" width="100%" height="99%" frameborder="0" scrolling="no"></iframe>';
		    $('#pickCoordsDlg').dialog({
		    	title: '拾取区域中心点坐标',
		        content: content,
		        border: true,
		        width: 700,
			    height: 500,
			    cache: false,
		        resizable: false,//定义对话框是否可调整尺寸。
		        maximizable:true,	//可最大化
		        modal: true,
		        onResize:function(){
		        	$('#pickCoordsDlg').window('center');		//设置居中显示
		        }
			});    
		}
		
		//从iframe页面获取经纬度高度
		function getCoords(lonlat){
			$("#lng").textbox("setValue", lonlat[0]);
			$("#lat").textbox("setValue", lonlat[1]);	
			$('#pickCoordsDlg').dialog('close');
		}
	</script>
</body>
</html>