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
<title>帮助文档</title>
</head>
<body>
	<!-- 文件列表 -->
<div class="easyui-layout" data-options="fit:true" style="width:100%;height:100%">
	<table id="fileList" style="width:100%;height:100%" ></table>
</div>	
	

<script type="text/javascript">

	$(function(){
		$('#fileList').datagrid({
		    url:'',
			fit: true,   //自适应大小
			singleSelect: false,
			//iconCls : 'icon-save',
			border:false,
			nowrap: true,//数据长度超出列宽时将会自动截取。
			rownumbers:true,//行号
			fitColumns:true,//自动使列适应表格宽度以防止出现水平滚动。
		    columns:[[
		    	{field: 'ck', checkbox:true },
		        {title:'文件名称',field:'name',width:200},
		        {title:'大小',field:'size',width:100},
		        {title:'修改日期',field:'date',width:150},
		        {title:'操作',field:'id',width:100,
		        	formatter : function(value, rowData, rowIndex) {
	            		return "<a href=\"#\" style=\"color:#fff;\" class=\"easyui-linkbutton\" onclick=\"downloadfile('"+rowData.name+"')\" >下 载</a>";
					}
		        }
		    ]]
		});
		
		$.ajax({
	        method : 'GET',
	        url : '${pageContext.request.contextPath}/document/getFileList?Math.random()',
	        async : false,
	        dataType : 'json',
	        success : function(data) {
	        	$('#fileList').datagrid('loadData', data);
	        },
	        error : function() {
	            alert('error');
	        }
	    });
	});

	function downloadfile(name) {
		var options = {
	            url : '${pageContext.request.contextPath}/document/download?Math.random()', 
	            data :{
	            	"name" : name
				},
	            method : 'post'
	        };
		var config = $.extend(true, {
            method : 'post'
        }, options);
        var $iframe = $('<iframe id="down-file-iframe" />');
        var $form = $('<form target="down-file-iframe" method="' + config.method + '" />');
        $form.attr('action', config.url);
        for ( var key in config.data) {
            $form
                .append('<input type="hidden" name="' + key + '" value="' + config.data[key] + '" />');
        }
        $iframe.append($form);
        $(document.body).append($iframe);
        $form[0].submit();
        $iframe.remove();
	}	

</script>
</body>
</html>