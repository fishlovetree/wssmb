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
<title>升级方案</title>
<jsp:include page="../../Header.jsp"/>
</head>
<body>
    <table id="dg"></table>
	<div id="toolbar">
		<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="addScheme()">编制</a>
		<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="deleteScheme()">删除</a>
		<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-card'" onclick="showDetails()">明细</a>
		<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-export'" onclick="exportScheme()">导出</a>
	</div>
	<div id="dlg" class="easyui-dialog" style="width:600px;height:400px;" closed="true" buttons="#dlg-buttons">
	    <table id="detailTbl"></table>
	</div>
	<div id="dlg-buttons">
		<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">关闭</a>
	</div>
</body>
<script type="text/javascript">
$(function(){
	$('#dg').datagrid({
		singleSelect:true,
		cache:false,
		rownumbers:true,//显示序号
		pagination:true,
		nowrap: true,//数据长度超出列宽时将会自动截取。
		pageSize:10,
		fit: true,   //自适应大小
		url:'${pageContext.request.contextPath}/upgradeScheme/schemeDataGrid',
		toolbar: '#toolbar',
		columns: [[         	
			{title: '方案编号', field: 'schemenum', width: '100'},  
			{title: '方案名称', field: 'schemename', width: '150'},  
			{title: '预案编制人', field: 'username', width: '100'},    
			{title: '编制时间', field: 'intime', width: '250'}
		]]
	});	
});

//编制升级方案
function addScheme(){
	var href='${pageContext.request.contextPath}/upgradeScheme/preparation';
    parent.addTab(href, '终端升级方案编制', '');
}

//删除升级方案
function deleteScheme(){
	var row = $('#dg').datagrid('getSelected');
	if (row){
		$.messager.confirm('删除','确定要删除该终端升级方案吗？',function(r){
			if (r){
				$.ajax({
				    type:'POST', 
			        url:'${pageContext.request.contextPath}/upgradeScheme/deleteScheme',           
			        data:{"id": row.id},        
				    success:function(d){
					    if (d == "success") {
					    	$.messager.alert('提示','删除成功。','info');	
					    	$('#dg').datagrid('reload');
						}
					    else{
					    	$.messager.alert('警告','删除失败，请重试。','error');	
					    }
			        },	        
			        error:function(data){
			        	$.messager.alert('警告',data,'error');		  
			        }
			    });
			}
		});
	}
	else{
		$.messager.alert('提示','请选择升级方案。','warning');	
	}
}

//显示明细
function showDetails(){
	var row = $('#dg').datagrid('getSelected');
	if (row){
		$('#dlg').dialog('open').dialog('setTitle','升级方案明细');
		setFirstPage($("#detailTbl"));
		$('#detailTbl').datagrid({
			singleSelect:true,
			cache:false,
			rownumbers:true,//显示序号
			nowrap: true,//数据长度超出列宽时将会自动截取。
			fit: true,   //自适应大小
			pagination:true,
			pageSize:10,
			url:'${pageContext.request.contextPath}/upgradeScheme/schemeDetailsDataGrid?id='+row.id,
			columns: [[         	
			    {title: '终端地址', field: 'unitaddress',width:'100px'}, 
			    {title: '老软件版本号', field: 'oldver', width: '120'},
			    {title: '新软件版本号', field: 'newver', width: '120'},
				{title: '升级结果', field: 'upgradestatus', width: '60',
			        formatter: function(value, row, index){
			        	if (value == 1){
			        		return "成功";
			        	}
			        	else if (value == 6){
			        		return "<span style='color:red'>失败</span>"
			        	}
			        	else{
			        		return "";
			        	}
				    }	
				},    
				{title: '升级结束时间', field: 'endtime', width: '126'}
			]]
		});	
	}
	else{
		$.messager.alert('提示','请选择升级方案。','warning');	
	}
}

//导出
function exportScheme(){
	var row = $('#dg').datagrid('getSelected');
	if (row){
		var form = $("<form>");
	    form.attr('style', 'display:none');
	    form.attr('target', '');
	    form.attr('method', 'get');
	    form.attr('action', '${pageContext.request.contextPath}/upgradeScheme/exportExcel');

	    var idinput = $('<input>');
	    idinput.attr('type', 'hidden');
	    idinput.attr('name', 'schemeid');
	    idinput.attr('value', row.id);

	    var numinput = $('<input>');
	    numinput.attr('type', 'hidden');
	    numinput.attr('name', 'schemenum');
	    numinput.attr('value', row.schemenum);

	    $('body').append(form);
	    form.append(idinput);
	    form.append(numinput);
	    form.submit();
	}
	else{
		$.messager.alert('提示','请选择升级方案。','warning');	
	}
}
</script>
</html>