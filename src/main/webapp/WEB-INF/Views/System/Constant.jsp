<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
    <%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>数据字典</title>
<jsp:include page="../Header.jsp"/>
<style type="text/css">
	.layout-split-west {
	    border-right: 1px solid #ccc;
	}
</style>
</head>
<body>
    <div class="easyui-layout" fit="true">
        <div region="west" style="width: 250px; overflow: auto;"
        iconCls="icon-constant" split="true" title="常量树" collapsible="true">
            <ul id="constantTree" style="">
            </ul>
        </div>
        <div region="center">
            <table id="constantTbl" ></table>
             <div id="toolbar">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="addConstant()"><spring:message code="Add"/></a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" onclick="editConstant()"><spring:message code="Edit"/></a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="destroyConstant()"><spring:message code="Delete"/></a>
			</div> 
			<div id="detailtoolbar">
				<input type="hidden" id="coding"> 
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="addDetail()"><spring:message code="Add"/></a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" onclick="editDetail()"><spring:message code="Edit"/></a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="destroyDetail()"><spring:message code="Delete"/></a>
			</div> 
        </div>
    </div>
    <div id="constantDlg" class="easyui-dialog" style="width:450px;height:250px;padding:10px 20px" closed="true" buttons="#constant-dlg-buttons">
	 <form id="constantFm" class="easyui-form" method="post" >
            <table cellspacing="8">
                <tr class="tableTr">
                    <td ><input class="easyui-textbox" type="text"
						style="width: 100%" name="name"
						data-options="label:'常量名',required:true,validType:'maxlength[25]'"></input></td>
                </tr> 
                <tr class="tableTr">
                    <td><input class="easyui-textbox" type="text"
						style="width: 100%" name="enname"
						data-options="label:'英文名',validType:'maxlength[50]'"></input></td>
                </tr>            
            </table>
        </form>
	</div>
	<div id="constant-dlg-buttons">
		<a href="#" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveConstant()"><spring:message code="Save"/></a>
		<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#constantDlg').dialog('close')"><spring:message code="Cancel"/></a>
	</div>
	<div id="detailDlg" class="easyui-dialog" style="width:480px;height:320px;padding:10px 10px" closed="true" buttons="#detail-dlg-buttons">
	 <form id="detailFm" class="easyui-form" method="post" >
			 <input type="hidden" name="coding"> 
            <table cellspacing="8">
                <tr class="tableTr">               
                    <td ><input class="easyui-textbox" type="text"
						style="width: 100%" name="detailname"
						data-options="label:'子项名',required:true,validType:'maxlength[25]'"></input></td>
                </tr> 
                <tr class="tableTr">
                    <td ><input class="easyui-textbox" type="text"
						style="width: 100%" name="detailvalue"
						data-options="label:'子项值',required:true,validType:'maxlength[25]'"></input></td>
                </tr> 
                <tr class="tableTr">
                    <td ><select id="parentcoding" name="parentcoding"  class="easyui-combobox" style="width: 100%"					
							data-options="label:'上级常量', method: 'get',
							url: '${pageContext.request.contextPath}/constant/getConstantList?Math.random()',
							valueField:'coding',
							textField:'name',
							editable:false,
					        onSelect: function (record) {
					        	var code = record.coding;
					            $('#parentid').combobox('reload', '${pageContext.request.contextPath}/constant/getDetailList?Math.random()&coding='+code);
					        }">
						 </select></td>
                </tr> 
                <tr class="tableTr">
                    <td ><select id="parentid" name="parentid"  class="easyui-combobox" style="width: 100%"					
							data-options="label:'上级常量子项',method: 'get',
							url: '${pageContext.request.contextPath}/constant/getDetailList?Math.random()&coding=0',
							valueField:'detailid',
							textField:'detailname',
							editable:false">
						 </select></td>
                </tr> 
                <tr class="tableTr">
                    <td><input class="easyui-textbox" type="text"
						style="width: 100%" name="enname"
						data-options="label:'英文名',validType:'maxlength[50]'"></input></td>
                </tr>            
            </table>
        </form>
	</div>
	<div id="detail-dlg-buttons">
		<a href="#" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveDetail()"><spring:message code="Save"/></a>
		<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#detailDlg').dialog('close')"><spring:message code="Cancel"/></a>
	</div>
    <script type="text/javascript">	
    var url = "";
	$(function(){  
		initConstantTable();
	    
	    //树
		$('#constantTree').tree({
	        url: '${pageContext.request.contextPath}/constant/getTreeData',
	        lines: true,
	        onClick: function (node) {
	            if (node.level == 1){
	            	initConstantTable();
	            }
	            else if (node.level == 2){
	            	initDetailTable(node.id);
	            }
	        }
	    });
	}); 
	
	//常量列表
	function initConstantTable(){
		$('#detailtoolbar').hide();
		$('#constantTbl').datagrid({ 
	    	url:'${pageContext.request.contextPath}/constant/getConstantList',
	    	fit: true,   //自适应大小
	    	singleSelect: true,
	    	nowrap: true,//数据长度超出列宽时将会自动截取。
	    	rownumbers:true,//行号
	    	multiSort:true,
	    	remoteSort:false,
	    	toolbar:'#toolbar',
	        columns: [[  
	            { field: 'coding', title: '编码', width: 100, sortable: true },
	            { field: 'name', title: '常量名', width: 150 },
	            { field: 'enname', title: '英文名', width: 150 }
	        ]],
	        onDblClickCell: function(index,field,value){
	      	   editConstant();
	 		}
	    }) 	   
	}
	
	//常量明细列表
	function initDetailTable(coding){
		$('#toolbar').hide();
		$('#coding').val(coding);
		$('#constantTbl').datagrid({ 
	    	url:'${pageContext.request.contextPath}/constant/getDetailList?coding=' + coding,
	    	fit: true,   //自适应大小
	    	singleSelect: true,
	    	nowrap: true,//数据长度超出列宽时将会自动截取。
	    	rownumbers:true,//行号
	    	multiSort:true,
	    	remoteSort:false,
	    	toolbar:'#detailtoolbar',
	        columns: [[  
	            { field: 'coding', title: '编码', width: 100 },
	            { field: 'detailname', title: '子项名', width: 120 },
	            { field: 'detailvalue', title: '子项值', width: 80, sortable: true },
	            { field: 'parentcoding', title: '上级常量', width: 80 },
	            { field: 'parentname', title: '上级常量子项', width: 120 },
	            { field: 'enname', title: '英文名', width: 100 },
	        ]],
	        onDblClickCell: function(index,field,value){
	      	   editDetail();
	 		}
	    }) 	   
	}
	
	//添加常量
	function addConstant(){
		$('#constantDlg').dialog('open').dialog('setTitle','添加常量');
		$('#constantFm').form('clear');
		url = '${pageContext.request.contextPath}/constant/addConstant';
	}

	//编辑常量
	function editConstant(){
		var row = $('#constantTbl').datagrid('getSelected');
		if (row){
			$('#constantDlg').dialog('open').dialog('setTitle','编辑常量');
			$('#constantFm').form('load',row);
			url = '${pageContext.request.contextPath}/constant/editConstant?coding='+row.coding;
		}
	}	
	//保存常量
	function saveConstant(){
		$('#constantFm').form('submit',{
			url: url,
			onSubmit: function(){
				return $(this).form('validate');
			},
			success: function(result){		
				if(result  == "success"){
					$('#constantDlg').dialog('close');		// close the dialog
					$('#constantTbl').datagrid('reload');	// reload the user data
					$('#constantTree').tree('reload');	
				}
				else{
					$.messager.alert('警告','抱歉，出错了，请重试。','error');
				}
			}
		});
	}

	//删除常量
	function destroyConstant(){
		var row = $('#constantTbl').datagrid('getSelected');
		if (row){
			$.messager.confirm('删除常量','确定要删除该常量吗？',function(r){
				if (r){
				  $.ajax({
					   type:'POST', 
			           url:'${pageContext.request.contextPath}/constant/deleteConstant',           
			           data:{"coding":row.coding},        
				       success:function(d){ 
				    	   if(d  == "success"){
								$('#constantTbl').datagrid('reload');	// reload the user data
								$('#constantTree').tree('reload');
							}else{
								$.messager.alert('警告', "删除常量失败，请重试。",'error');
							}
				       
				        }
				  });
				}
			});
		}
	}
	
	//添加常量子项
	function addDetail(){
		var coding = $('#coding').val();
		$('#detailDlg').dialog('open').dialog('setTitle','添加常量子项');
		$('#detailFm').form('clear');
		url = '${pageContext.request.contextPath}/constant/addDetail?coding=' + coding;
	}

	//编辑常量子项
	function editDetail(){
		var row = $('#constantTbl').datagrid('getSelected');
		if (row){
			$('#detailDlg').dialog('open').dialog('setTitle','编辑常量子项');
			$('#detailFm').form('load',row);
			url = '${pageContext.request.contextPath}/constant/editDetail?detailid='+row.detailid;
		}
	}	
	//保存常量子项
	function saveDetail(){
		$('#detailFm').form('submit',{
			url: url,
			onSubmit: function(){
				return $(this).form('validate');
			},
			success: function(result){		
				if(result  == "success"){
					$('#detailDlg').dialog('close');		// close the dialog
					$('#constantTbl').datagrid('reload');	// reload the user data
					$('#constantTree').tree('reload');	
				}
				else{
					$.messager.alert('警告','抱歉，出错了，请重试。','error');
				}
			}
		});
	}

	//删除常量子项
	function destroyDetail(){
		var row = $('#constantTbl').datagrid('getSelected');
		if (row){
			$.messager.confirm('删除常量子项','确定要删除该常量子项吗？',function(r){
				if (r){
				  $.ajax({
					   type:'POST', 
			           url:'${pageContext.request.contextPath}/constant/deleteDetail',           
			           data:{"id":row.detailid},        
				       success:function(d){ 
				    	   if(d  == "success"){
								$('#constantTbl').datagrid('reload');	// reload the user data
								$('#constantTree').tree('reload');
							}else{
								$.messager.alert('警告', "删除常量失败子项，请重试。",'error');
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