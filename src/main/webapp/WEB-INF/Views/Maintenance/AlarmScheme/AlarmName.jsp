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
<title>告警事件名称管理</title>
<jsp:include page="../../Header.jsp"/>
<style type="text/css">
.tableTr td{
    padding:5px;  /*设置tr间距为2px*/
}
.ulEvent
{
    list-style-type: none;
    width: 95%;
    border: 1px solid #ddd;
    margin: 10px auto;
    padding: 5px;
}
.ulEvent li
{
    height: 25px;
    line-height: 25px;
    width: 150px;
    display: inline-block;
}
.tabs li.tabs-selected a.tabs-inner{
    color: red;
}
</style>
</head>
<body>	
<table id="dg" style="width: 100%;"></table>
<div id="toolbar">
	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" onclick="editScheme()"><spring:message code="Edit"/></a>
</div>

<!-- 添加修改弹出框 -->
<div id="dlg" class="easyui-dialog" style="width:450px;height:300px;padding:10px 20px" closed="true" buttons="#dlg-buttons">
    <form id="fm" class="easyui-form" method="POST" enctype=”multipart/form-data”>
         <table cellspacing="8">
                <tr class="tableTr">
                    <td ><input class="easyui-textbox" type="text"
						style="width: 100%" id="detailname" name="detailname" readonly="readonly"
						data-options="label:'事件名',required:true,validType:'maxlength[25]'"></input></td>
                </tr> 
                <tr class="tableTr">
                    <td ><input class="easyui-textbox" type="text"
						style="width: 100%" id="detailvalue" name="detailvalue" readonly="readonly"
						data-options="label:'事件值',required:true,validType:'maxlength[25]'"></input></td>
                </tr> 
                <tr class="tableTr">
                    <td><input class="easyui-textbox" type="text"
						style="width: 100%" id="anothername" name="anothername"
						data-options="label:'事件别名',validType:'maxlength[25]'"></input></td>
                </tr>            
            </table>
    </form>
</div>
<div id="dlg-buttons">
	<a href="#" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveScheme()"><spring:message code="Save"/></a>
	<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')"><spring:message code="Cancel"/></a>
</div>

<script type="text/javascript">	

$(function(){
	$('#dg').datagrid({
		url:'${pageContext.request.contextPath}/alarmscheme/getAlarmNameDataGrid',
		singleSelect:true,
		remoteSort:false,
		nowrap: true,//数据长度超出列宽时将会自动截取。
		rownumbers:true,//显示序号
		toolbar:'#toolbar',
		pagination:true,
		pageSize:20,
		collapsible:true,
		fit: true,   //自适应大小
		columns: [[  
			{title: '事件名', field: 'detailname', width: '150'}, 
			{title: '事件值', field: 'detailvalue', width: '150'}, 
			{title: '事件别名', field: 'anothername', width: '150'}
		]],
	 	onDblClickCell: function(index,field,value){
			editScheme();
		},
		onLoadSuccess:function(data){
			$('#dg').datagrid('selectRow',0);
		}
	});	
})
var url = "";

//编辑告警事件别名
function editScheme(){
	var row = $('#dg').datagrid('getSelected');
	if (row){
		$('#dlg').dialog('open').dialog('setTitle','编辑');
		$('#fm').form('load',row);
		url = '${pageContext.request.contextPath}/alarmscheme/editAlarmName';
	}
}	
	
//保存
function saveScheme(){
	$('#fm').form('submit',{
		url: url,
		onSubmit: function(){
			return $(this).form('validate');
		},
		success: function(result){	
			if(result=="success"){
				$('#dlg').dialog('close');	
				$('#dg').datagrid('reload');		
			}else if (result=="repeat"){
				$.messager.alert('<spring:message code="Warning"/>',"编辑失败，事件别名重复。",'info');
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

</script>
</body>
</html>