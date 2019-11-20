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
<title>NB命令列表</title>
<jsp:include page="../../Header.jsp"/>
<script>
var basePath = '${pageContext.request.contextPath}';
</script>
</head>
<body>
<table id="dg"></table>
</body>
<script type="text/javascript">
$(function(){
	$('#dg').datagrid({
		singleSelect:true,
		cache:false,
		rownumbers:true,//显示序号
		pagination:true,
		nowrap: true,//数据长度超出列宽时将会自动截取。
		pageSize:50,
		fit: true,   //自适应大小
		url:'${pageContext.request.contextPath}/paramNbiot/nbCommandDataGrid',
		frozenColumns: [[
	        { field: 'id', title: '操作', width: 80, 
                formatter: function (value, row, index) {
	                return "<a href='#' class='button-tbl button-default' onclick='deleteCommand(" + value + ")'>删除</a>";
	            }
	        }
		]],
		columns: [[       
			{title: '状态', field: 'status', width: '80',
			    formatter: function(value, row, index){
			    	if (value == 1){
			    		return "<span style='color:red'>待执行</span>";
			    	}
			    	else if (value == 2){
			    		return "已执行";
			    	}
			    	else{
			    		return "";
			    	}
			    }	
			},
			{title: '执行结果', field: 'setresult', width: '80',
			    formatter: function(value, row, index){
			    	if (value == '0'){
			    		return "<span style='color:red'>执行失败</span>";
			    	}
			    	else if (value == '1'){
			    		return "执行成功";
			    	}
			    	else{
			    		return "";
			    	}
			    }	
			},
			{title: '执行时间', field: 'setdate', width: '120'},
			{title: '执行次数', field: 'settimes', width: '60'},
			{title: '设备地址', field: 'equipmentaddress', width: '150'},
			{title: '规约类型', field: 'protocolname', width: '100'},
			{title: '命令类型标志', field: 'typeflagcode', width: '100'},
			{title: '数据内容', field: 'paramdata', width: '200'},    
			{title: '操作人', field: 'username', width: '80'},
			{title: '生成时间', field: 'recorddate', width: '120'},
			{title: '备注', field: 'remark', width: '120'}
		]],
 		onLoadSuccess:function(){
			$('.button-tbl').linkbutton({ });
		}
	});	
});

//删除作命令
function deleteCommand(id){
	$.messager.confirm('删除命令','确定要删除该命令吗？',function(r){
		if (r){
		  $.ajax({
			   type:'POST', 
	           url:'${pageContext.request.contextPath}/paramNbiot/deleteCommand',           
	           data:{"id":id},        
		       success:function(data){ 				    	  
		    	   if(data=="success"){
		    		   $('#dg').datagrid('reload');
					}else{
						$.messager.alert('警告',"删除失败,请重试。",'error');
					}
		        },	        
		        error:function(data){
		        	$.messager.alert('警告',data,'error');		  
		        }
		   });
		}
	});
}

</script>
</html>