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
<title>组织机构</title>
<jsp:include page="../Header.jsp"/>
</head>
<body>
	<table id="dg" toolbar="#toolbar" >
	</table>
	
	<div id="toolbar">
		<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="addOrganization()"><spring:message code="Add"/></a>
		<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" onclick="editOrganization()"><spring:message code="Edit"/></a>
		<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="destroyOrganization()"><spring:message code="Delete"/></a>
	</div>

	<div id="dlg" class="easyui-dialog"
		style="width: 450px; height: 250px; padding: 10px 20px" closed="true"
		buttons="#dlg-buttons">
		<form id="fm" class="easyui-form" method="post">
			<table cellspacing="8">
				<tr>
					<td><select class="easyui-combotree" id="parentid" lines="true"
						url="${pageContext.request.contextPath}/organization/organizationTreeGrid?Math.random()"
						name="parentid" style="width: 320px;" data-options="label:'上级组织机构'">
					</select></td>
				</tr>
				<tr style="margin-bottom: 20px">
					<td><input class="easyui-textbox" type="text"
						style="width: 320px" name="organizationcode"
						data-options="label:'组织机构代码',required:true,validType:'maxlength[25]'"></input></td>
				</tr>
				<tr style="margin-bottom: 20px">
					<td><input class="easyui-textbox" type="text"
						style="width: 320px" name="organizationname"
						data-options="label:'组织机构名称',required:true,validType:'maxlength[25]'"></input></td>
				</tr>
			</table>
		</form>
	</div>
	<div id="dlg-buttons">
		<a href="#" class="easyui-linkbutton" iconCls="icon-ok"
			onclick="saveOrganization()"><spring:message code="Save" /></a> <a
			href="#" class="easyui-linkbutton" iconCls="icon-cancel"
			onclick="javascript:$('#dlg').dialog('close')"><spring:message
				code="Cancel" /></a>
	</div>
	<!-- 配置人员窗口 -->
	<div id="userWindow" class="easyui-dialog" style="width:550px;height:400px;" closed="true" buttons="#user-buttons">
	    <table id="userTbl"></table>
	    <div id="usertoolbar">
	        <form id="userfm" class="easyui-form" method="post" >
	            <table cellspacing="5">
	                <tr>
	                   <td><input class="easyui-textbox" type="text"
						style="width: 120px;" id="userName"
						data-options="label:'姓名',required:true,validType:'maxlength[25]'"></input></td>
					<td><input class="easyui-textbox" type="text"
						style="width: 160px;" id="phone"
						data-options="label:'电话',required:true,validType:'mobile'"></input></td>
					<td><select class="easyui-combobox"
						style="width: 140px;" id="userType" data-options="label:'职责',editable: false,required:true">
						<option value="0">管理人</option>
	                    <option value="1">责任人</option>
	                    <option value="1">法人</option>
						</select></td>
					<td><a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="addUser()"><spring:message code="Add"/></a></td>
	                </tr> 
	            </table>
	        </form>
		</div>
	</div>
	<div id="user-buttons" region="south" border="false" style="text-align:right;height:30px;line-height:30px;">
		<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#userWindow').dialog('close')">关闭</a>
	</div>
	<script type="text/javascript">
		$(function() {
			$('#dg').treegrid({
				fit : true,
				animate : true,
				collapsible : true,
				url : "${pageContext.request.contextPath}/organization/organizationTreeGrid",
				idField : 'organizationid',
				treeField : 'organizationname',
				striped : true,
				showFooter : true,
				rownumbers: true,
				singleSelect : true,
				frozenColumns: [[
					{title: '操作', field: 'organizationid', width:'110',formatter: function(value, row, index){
					    return "<a href='#' class='button-setuser button-default' onclick='setUser(" + value + ")'>配置告警人员</a>";
					}}       
				]],
				columns : [ [ {
					title : '组织机构名称',
					field : 'organizationname',
					width : '250',
					align : 'left'
				}, {
					title : '组织机构代码',
					field : 'organizationcode',
					width : '100'
				}  ] ],
				/* toolbar : [ {
					text : '添加',
					iconCls : 'icon-add',
					handler : function() {
						addOrganization();
					}
				}, '-', {
					text : '编辑',
					iconCls : 'icon-edit',
					handler : function() {
						editOrganization();
					}
				}, "-", {
					text : '删除',
					iconCls : 'icon-remove',
					handler : function() {
						destroyOrganization();
					}
				}, '-' ], */
				onDblClickRow : function(row) {
					editOrganization();
				},
		 		onLoadSuccess:function(){
					$('.button-tbl').linkbutton({ });
					$('.button-setuser').linkbutton({ });
				}
			})
		});
	</script>

	<script type="text/javascript">
		var url = "";
		//添加组织机构
		function addOrganization() {
			$('#parentid')
					.combotree('reload',
							'${pageContext.request.contextPath}/organization/organizationTreeGrid');
			$('#dlg').dialog('open').dialog('setTitle',
					'<spring:message code="Add"/>');
			$('#fm').form('clear');
			url = '${pageContext.request.contextPath}/organization/addOrganization';
		}

		//编辑组织机构
		function editOrganization() {
			var row = $('#dg').treegrid('getSelected');
			if (row) {
				$('#parentid').combotree(
						'reload',
						'${pageContext.request.contextPath}/organization/organizationTreeGrid?id='
								+ row.organizationid);
				$('#dlg').dialog('open').dialog('setTitle',
						'<spring:message code="Edit"/>');
				$('#fm').form('load', row);
				url = '${pageContext.request.contextPath}/organization/editOrganization?organizationid='
						+ row.organizationid;
			}
		}
		//保存
		function saveOrganization() {
			$('#fm').form('submit', {
				url : url,
				onSubmit : function() {
					return $(this).form('validate');
				},
				success : function(result) {
					if (result == "success") {
						$('#dlg').dialog('close'); // close the dialog
						$('#dg').treegrid('reload'); // reload the user data
					} else if (result == "repeat") {
						$.messager.alert('提示', '组织机构编码已经存在。', 'warning');
					} else {
						$.messager.alert('警告', '操作失败，请重试。', 'error');
					}

				}
			});
		}

		//删除组织机构
		function destroyOrganization() {
			var row = $('#dg').treegrid('getSelected');
			if (row) {
				$.messager.confirm('删除组织机构','你确定要删除该组织机构吗？',
					function(r) {
						if (r) {
							$.ajax({
								type : 'POST',
								url : '${pageContext.request.contextPath}/organization/deleteOrganization',
								data : {
									"id" : row.organizationid
								},
								success : function(data) {
									if (data == 'success') {
										$('#dg').treegrid(
												'reload');
									} else if (data == "chidren") {
										$.messager.alert(
														'提示',
														'请先删除下级组织机构。',
														'warning');
									} else {
										$.messager.alert(
														'警告',
														'删除失败，请重试。',
														'error');
									}
								}
							});
						}
					});
			}
		}
		
		var _orgid; //所选组织机构id
		//设置组织机构告警人员
		function setUser(organizationid) {
			_orgid = organizationid;
			$('#userfm').form('clear');
			$('#userWindow').dialog('open').dialog('setTitle', '配置告警人员');
			//初始化人员列表
			$('#userTbl').datagrid({
				url:'${pageContext.request.contextPath}/organization/getAlarmUser?organizationid=' + _orgid,
				remoteSort:false,
				nowrap: true,//数据长度超出列宽时将会自动截取。
				rownumbers:true,//显示序号
				collapsible:true,
				toolbar:'#usertoolbar',
				singleSelect:true,
				fit: true,   //自适应大小
				columns: [[  
		            {title: '操作', field: 'id', width:'60px',formatter: function(value, row, index){
		            	return "<a href='#' class='button-reset button-default' onclick='removeUser(" + value + ")'>删除 </a>";
					}},
					{title: '姓名', field: 'name', width: '120px'},
					{title: '电话', field: 'phone', width: '140px'},
					{title: '类型', field: 'type', width: '80px',formatter: function(value, row, index){
						if (value == 0) return "管理人";
						else if (value == 1) return "责任人";
						else if (value == 2) return "法人";
						else return value;
					}}
				]], 
				onLoadSuccess:function(){
					$('.button-default').linkbutton({ });
				}	
			});	
		}

		function addUser(){
			$('#userfm').form('submit',{
				url: '${pageContext.request.contextPath}/organization/addAlarmUser',
				queryParams: {organizationid: _orgid, type: $("#userType").combobox('getValue'), 
					name: $("#userName").val(), phone: $("#phone").val()},
				onSubmit: function(){
					return $(this).form('validate');
				},
				success: function(result){	
					if(result=="success"){
						$('#userTbl').datagrid('reload');		
					}else if (result=="repeat"){
						$.messager.alert('<spring:message code="Warning"/>',"电话号码重复。",'info');
					}else{
						$.messager.alert('<spring:message code="Warning"/>',result,'error');
					}
				
				},
				error:function(data){
					$.messager.alert('<spring:message code="Warning"/>',data,'error');	        	
		        }
			});
		}

		function removeUser(id){
			$.messager.confirm('删除告警人员','确定要删除该告警人员吗？',function(r){
				if (r){
				  $.ajax({
					   type:'POST', 
			           url:'${pageContext.request.contextPath}/organization/deleteAlarmUser',           
			           data:{"id":id},        
				       success:function(d){ 
				    	   if(d  == "success"){
								$('#userTbl').datagrid('reload');	// reload the user data
							}else{
								$.messager.alert('警告', "删除告警人员失败，请重试。",'error');
							}
				       
				        }
				  });
				}
			});
		}
	</script>
</body>
</html>