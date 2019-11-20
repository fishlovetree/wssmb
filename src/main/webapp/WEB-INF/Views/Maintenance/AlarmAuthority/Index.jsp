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
<title>告警前置机</title>
<jsp:include page="../../Header.jsp"/>
<style type="text/css">
.tableTr td{
    padding:5px;  /*设置tr间距为2px*/
}
</style>
</head>
<body>	
<table id="dg" style="width: 100%;"></table>
<div id="toolbar">
	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="addAuthority()"><spring:message code="Add"/></a>
	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" onclick="editAuthority()"><spring:message code="Edit"/></a>
	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="destroyAuthority()"><spring:message code="Delete"/></a>
</div>

<!-- 添加修改弹出框 -->
<div id="dlg" class="easyui-dialog" style="width:460px;height:365px;padding:10px 20px;" closed="true" buttons="#dlg-buttons">
    <form id="fm" class="easyui-form" method="post" enctype="multipart/form-data">
         <table cellpadding="5" align="center"> 
            <tr class="tableTr">   
                <td>
                    <label>前置机类型</label>
                </td>    
                <td>
                    <select class="easyui-combobox" name="remotealarmtype" id="remotealarmtype" style="width:150px;"
                    data-options="required:true">
                        <option value="0" selected="selected">总公司告警前置机</option>
                        <option value="1">代理告警前置机</option>
                    </select>
                </td>
            </tr>     
            <tr class="tableTr">
                <td>
                    <label>组织机构</label>
                </td> 
				<td><select class="easyui-combotree" id="organizationid"
					url="${pageContext.request.contextPath}/organization/organizationTreeGrid?Math.random()"
					name="organizationid" style="width: 100%;" data-options="required:true">
				</select></td>
			</tr>    
            <tr class="tableTr">
                <td>
                    <label>语言告警</label>
                </td> 
                <td>
                    <input class="easyui-switchbutton" id="soundalarm"
                    data-options="onText:'支持',offText:'不支持'">
                </td>
            </tr>
            <tr class="tableTr">
                <td>
                    <label>拨号方式</label>
                </td> 
                <td>
                    <select class="easyui-combobox" name="dialmode" id="dialmode" data-options="required:true" style="width:150px;">
                        <option value="0" selected="selected">自动拨号</option>
                        <option value="1">人工手动拨号</option>
                        <option value="2">人工自动拨号</option>
                    </select>
                </td>
            </tr>
            <tr class="tableTr">
                <td>
                    <label>短信告警</label>
                </td> 
                <td>
                    <input class="easyui-switchbutton" id="smsalarm"
                    data-options="onText:'支持',offText:'不支持'">
                </td>
            </tr>
            <tr class="tableTr">
                <td>
                    <label>短信发送方式</label>
                </td> 
                <td>
                    <select class="easyui-combobox" name="smsalarmmode" id="smsalarmmode" data-options="required:true" style="width:150px;">
                        <option value="0" selected="selected">自动发送</option>
                        <option value="1">人工手动发送</option>
                    </select>
                </td>
            </tr>
        </table>
    </form>
</div>
<div id="dlg-buttons">
	<a href="#" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveAuthority()"><spring:message code="Save"/></a>
	<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')"><spring:message code="Cancel"/></a>
</div>
<script type="text/javascript">	

$(function(){
	$('#dg').datagrid({
		url:'${pageContext.request.contextPath}/alarmAuthority/getDataGrid',
		singleSelect:true,
		remoteSort:false,
		nowrap: true,//数据长度超出列宽时将会自动截取。
		rownumbers:true,//显示序号
		toolbar:'#toolbar',
		pagination:true,
		pageSize:10,
		collapsible:true,
		fit: true,   //自适应大小
		columns: [[  
			{title: '告警前置机类型', field: 'remotealarmtype', width: '100', formatter: function(value, row, index){
				return value == 0 ? "总公司告警前置机" : "代理告警前置机";
			}}, 
			{title: '组织机构', field: 'organizationname', width: '100'}, 
			{title: '语音告警', field: 'soundalarm', width: '80', formatter: function(value, row, index){
				return value == 1 ? "<span style='color:green'>支持</span>" : "<span style='color:red'>不支持</span>";
			}}, 
			{title: '拨号方式', field: 'dialmode', width: '100', formatter: function(value, row, index){
				if (value == 0) return "自动拨号";
				else if (value == 1) return "人工手动拨号";
				else if (value == 2) return "人工自动拨号";
			}}, 
			{title: '短信告警', field: 'smsalarm', width: '80', formatter: function(value, row, index){
				return value == 1 ? "<span style='color:green'>支持</span>" : "<span style='color:red'>不支持</span>";
			}}, 
			{title: '短信发送方式', field: 'smsalarmmode', width: '100', formatter: function(value, row, index){
				if (value == 0) return "自动发送";
				else if (value == 1) return "人工手动发送";
			}}, 
			{title: '编制人', field: 'username', width: '100'}, 
			{title: '编制时间', field: 'compilationtime', width: '150'} 				
		]],
	 	onDblClickCell: function(index,field,value){
			editAuthority();
		}
	});	
	
})   

var url = ""
//添加告警前置机
function addAuthority(){
	$('#dlg').dialog('open').dialog('setTitle','添加');
	$('#fm').form('clear');
	url = '${pageContext.request.contextPath}/alarmAuthority/addAuthority?Math.random()';
}

//修改告警前置机
function editAuthority(){
	var row = $('#dg').datagrid('getSelected');
	if (row){
		$('#dlg').dialog('open').dialog('setTitle','编辑');
		$('#fm').form('load',row);
		row.soundalarm == 1 ? $("#soundalarm").switchbutton('check') : $("#soundalarm").switchbutton('uncheck');
		row.smsalarm == 1 ? $("#smsalarm").switchbutton('check') : $("#smsalarm").switchbutton('uncheck');
		url = '${pageContext.request.contextPath}/alarmAuthority/editAuthority?id='+row.id;
	}
}	
	
//保存
function saveAuthority(){
	$('#fm').form('submit',{
		url: url,
		queryParams: { remotealarmtype: $("#remotealarmtype").combobox('getValue'),
			organizationid: $("#organizationid").combotree('getValue'),
			soundalarm: document.getElementById("soundalarm").checked ? 1 : 0, 
			dialmode: $("#dialmode").combobox('getValue'),
			smsalarm: document.getElementById("smsalarm").checked ? 1 : 0,
			smsalarmmode: $("#smsalarmmode").combobox('getValue')},
		onSubmit: function(){
			return $(this).form('validate');
		},
		success: function(result){	
			if(result=="success"){
				$('#dlg').dialog('close');	
				$('#dg').datagrid('reload');		
			}else if (result=="repeat"){
				$.messager.alert('<spring:message code="Warning"/>',"添加失败，已存在该组织机构的告警前置机。",'info');
			}
			else{
				$.messager.alert('<spring:message code="Warning"/>',result,'error');
			}
		
		},
		error:function(data){
			$.messager.alert('<spring:message code="Warning"/>',data,'error');	        	
        }
	});
} 

function destroyAuthority(){
	var row = $('#dg').datagrid('getSelected');
	if (row){
		$.messager.confirm('删除告警前置机','确定要删除该告警前置机吗？',function(r){
			if (r){
			  $.ajax({
				   type:'POST', 
		           url:'${pageContext.request.contextPath}/alarmAuthority/deleteAuthority',           
		           data:{"id":row.id},        
			       success:function(d){ 
			    	   if(d  == "success"){
							$('#dg').datagrid('reload');	// reload the user data
						}else{
							$.messager.alert('警告', "删除告警前置机失败，请重试。",'error');
						}
			       
			        }
			  });
			}
		});
	}
}
</script>
</body>
</html>