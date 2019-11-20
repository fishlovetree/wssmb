<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
    <%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=9" />
<meta http-equiv="Content-Type" content="multipart/form-data; charset=utf-8" />
<title>帮助文档</title>
<jsp:include page="../Header.jsp"/>
<style type="text/css">
a.l-btn.l-btn-small.l-btn-plain {
    margin-right: 5px;
} 
</style>
</head>
<body>
	<!-- 文件列表 -->
	<table id="fileList" style="width:100%;height:100%" 
		data-options="rownumbers:true" toolbar="#toolbar"></table>
	<!-- 列表-按钮 -->
	<div id="toolbar">
		<form id="filefm" style="width: 185px; display: inline-block;" class="easyui-form" method="post" enctype="multipart/form-data">
			<input class="easyui-filebox" multiple="true" style="width:180px" id="files" name="files" data-options="prompt:'选择一个文件...', buttonText: '选择文件',buttonAlign:'left'"></input>
		</form>
		<a href="#" id="ie" class="easyui-linkbutton"  data-options="iconCls:'icon-import'"  onclick="upload()">上传</a>
		<a href="#" id="ie" class="easyui-linkbutton"  data-options="iconCls:'icon-remove'"  onclick="deletefile()">删除</a>
		<!-- <a href="#" id="ie" class="easyui-linkbutton"  data-options="iconCls:'icon-export'"  onclick="downloadfiles()">下载</a> -->
   	</div>
	

<script type="text/javascript">

	$(function(){
		$('#fileList').datagrid({
		    url:'${pageContext.request.contextPath}/document/getFileList?Math.random()',
		    pagination : false,//分页控件
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
	            		return "<a href=\"#\" class=\"easyui-linkbutton\" onclick=\"downloadfile('"+rowData.name+"')\" >下 载</a>";
					}
		        }
		    ]]
		});
	});

	function upload() {
		var url = '${pageContext.request.contextPath}/document/upload?Math.random()';

		var type = $("#files").filebox("getValue");
		if(type==""){
			$.messager.alert('警告',"请先选择文件！",'error');
		}else{
	        var formdata = new FormData($("#filefm")[0]);
	        $.ajax({
	            url: url,
	            type: "POST",
	            data:formdata,
	            dataType: "json",
	            processData: false,  // 告诉jQuery不要去处理发送的数据
	            contentType: false,   // 告诉jQuery不要去设置Content-Type请求头
	            success: function (data) {
	            	if(data=="Success"){
	            		$.messager.alert('提示','上传文件成功。','info');
	            		$('#fileList').datagrid("reload");
		            }else{
						$.messager.alert('警告',data,'error');
					}
		        },	        
		        error:function(data){
		        	$.messager.alert('警告',data,'error');
	            }
	        })
		}
	} 
	
	function deletefile() {
		$.messager.confirm('删除文件','确定要删除文件吗？',function(r){
			if (r){
				var fileName = [];
				//勾选的数据
				var selRow = $("#fileList").datagrid('getSelections');
		        for (var i = 0; i < selRow.length; i++) 
		        	fileName.push(selRow[i].name); //把单个id循环放到ids的数组中  
		        if(fileName.length==0){
		       		$.messager.alert('提示','请选择需删除的文件','warning');
		       		return false;
		        }
		       	    	
				$.ajax({
		           	type:'POST', 
				    url:'${pageContext.request.contextPath}/document/delete?Math.random()',  
		            data : {
		                 "fileName[]" : fileName
		            },
		            success:function(data){ 
		            	if(data==fileName.length){
		            		$.messager.alert('警告',"删除失败。",'error');
			            }else if(data==0){
			            	$.messager.alert('提示','删除成功。','info');
						}else{
							$.messager.alert('提示',"有"+data+'个文件，删除失败。','info');
						}
		            	$('#fileList').datagrid("reload");
			        },	        
			        error:function(data){
			        	$.messager.alert('警告',data,'error');
			        }
		    	}); 
			}
		});
	} 
	
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