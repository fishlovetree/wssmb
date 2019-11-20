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
<div class="easyui-layout" style="width:100%;height:100%;overflow: hidden">
	<div id="west" region="west" iconCls="icon-organization" split="true" title="" style="width:280px;min-width:280px;overflow: hidden" collapsible="true">
		<jsp:include page="../CommonTree/measureFileTree.jsp"/>
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
				data-options="iconCls:'icon-remove'" onclick="deleteMeasure()"><spring:message
					code="Delete" /></a>
					<select class="textbox combo" id="querySelect">
				   <option>所属表箱</option>
				   <option>锁编号</option>
				</select>
				<input class="easyui-textbox" type="text" value="" id="queryInput" />
				 <a href="javascript:void(0)" class="easyui-linkbutton button-edit button-default" data-options="iconCls:'icon-search'" onclick="doSearch()" title="Search">检索</a>
					<input class="easyui-filebox"
				style="width: 180px" id="excelfile" name="excelfile"
				data-options="prompt:'选择一个文件...', buttonText: '选择文件',buttonAlign:'left'"></input>
			<a href="#" class="easyui-linkbutton"
				data-options="iconCls:'icon-import'" onclick="importMeasurefile()"><spring:message
					code="Import"  /></a> <a href="#" class="easyui-linkbutton"
				data-options="iconCls:'icon-export'" onclick="exportMeasurefile()"><spring:message
					code="Export" /></a>
		</form>
		<!-- 导出 -->
		<form id="exfm"
			action='${pageContext.request.contextPath}/mbAieLock/exportAieLockToExcel'
			method="get">
			<input type="hidden" name="type" id="type" /> <input type="hidden"
				name="gid" id="gid" />
		</form>
	</div>
	</div>
</div>

<div id="dlg" class="easyui-dialog"
		style="width: 600px; height: 400px; padding: 10px 20px" closed="true"
		buttons="#dlg-buttons">
		<form id="fm" class="easyui-form" method="POST">
			<table cellspacing="8">
				<tr>
				<td >
					<select class="easyui-combotree"
									url="${pageContext.request.contextPath}/organization/organizationTree?Math.random()"
									name="fatherOrgID" id="fatherOrgID" style="width: 300px;" data-options="label:'组织机构',required:true,
									onSelect: function(node) {
									  var url = '${pageContext.request.contextPath}/measureFile/getMeasurefileByOrganizationId?OrganizationId='+node.gid
								    	$('#measureIds').combobox('reload', url);
								    	$('#organizationId').val(node.gid);
								    	$('#measureIds').combobox('setValue','');
								    }">
					</select>
					<input type="hidden" name="organizationCode" id="organizationId"/>		
				</td>	
				  <td><select class="easyui-combobox"
									url="${pageContext.request.contextPath}/measureFile/getMeasurefileByOrganizationId?OrganizationId=0"
									 id="measureIds" style="width: 300px;" data-options="label:'所属表箱',required:true,
									 editable:false,valueField:'MeasureId', textField:'MeasureName',
									onSelect: function(node) {
								    	$('#boxCode').val(node.MeasureId);
								    }">
								</select>
								<input type="hidden" name="boxCode" id="boxCode"/>
				  </td>	
				</tr>
				<tr>
					<td><input class="easyui-textbox" type="text"
						style="width: 300px" name="lockCode"
						data-options="label:'锁编号',required:true,validType:'maxlength[50]'"></input></td>
						<td><input class="easyui-textbox" type="text"
						style="width: 300px" name="lockName"
						data-options="label:'锁名称',required:true,validType:'maxlength[20]'"></input></td>
				</tr>
					<tr>
				    <td><input class="easyui-datebox" type="text"
						style="width: 300px" name="produceTime"
						data-options="label:'生产日期',validType:'maxlength[20]'"></input></td>
						 <td><input class="easyui-textbox" type="text"
						style="width: 300px" name="lockType"
						data-options="label:'型号',validType:'maxlength[20]'"></input></input></td>
				</tr>
				<tr>
				    <td style="display:none"><input class="easyui-datebox" editable="fasle" type="text" 
				    style="width:300px" name="createTime" data-options="label:'创建时间'"></input></td>
				   <td style="display:none"><input class="easyui-textbox" type="text"
						style="width: 300px" name="createPerson"
						data-options="label:'创建人',validType:'maxlength[20]'"></input></td>
				</tr>
				<tr>	<td><input class="easyui-textbox" type="text"
						style="width: 300px" name="produce"
						data-options="label:'生产厂家',validType:'maxlength[20]'"></input></td>
				</tr>
				<tr>
				    <td><input class="easyui-textbox" type="text"
						style="width: 300px" name="apikey"
						data-options="label:'apikey',validType:'maxlength[20]'"></input></td>
				    <td><input class="easyui-textbox" type="text"
						style="width: 300px" name="imei"
						data-options="label:'IMEI',validType:'maxlength[20]'"></input></td>
				</tr>
				<tr>
				    <td><input class="easyui-textbox" type="text"
						style="width: 300px" name="imsi"
						data-options="label:'IMSI',validType:'maxlength[20]'"></input></td>
				    <td><input class="easyui-textbox" type="text"
						style="width: 300px" name="serialnumber"
						data-options="label:'序列号',validType:'maxlength[20]'"></input></td>
				</tr>
				<tr>
				    <td><input class="easyui-textbox" type="text"
						style="width: 300px" name="password"
						data-options="label:'密码',validType:'maxlength[20]'"></input></td>
				    <td><input class="easyui-textbox" type="text"
						style="width: 300px" name="mac"
						data-options="label:'mac',validType:'maxlength[20]',required:true"></input></td>
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
					url : '${pageContext.request.contextPath}/mbAieLock/getAllAieLock?Math.random()',
					pagination : true,//分页控件
					pageList : [ 10, 20, 30, 40, 50 ],
					fit : true, //自适应大小
					singleSelect : true,
					iconCls : 'icon-save',
					border : false,
					nowrap : true,//数据长度超出列宽时将会自动截取。
					rownumbers : true,//行号
					fitColumns : true,//自动使列适应表格宽度以防止出现水平滚动。
					columns : [ [
						{
						title : 'id',
						field : 'id',
						width : '200px',
						hidden:true
					}, {
						title : '锁名称',
						field : 'lockName',
						width : '180px'
					}, {
						title : '所属表箱',
						field : 'boxName',
						width : '180px'
					}, {
						title : '锁编号',
						field : 'lockCode',
						width : '200px'
					}, {
						title : '组织机构',
						field : 'organizationName',
						width : '120px'
					}, {
						title : '生产厂家',
						field : 'produce',
						width : '100px'
					}, {
						title : '生产日期',
						field : 'produceTime',
						width : '120px'
					},{
						title : '创建人',
						field : 'createPerson',
						width : '100px'
					}, {
						title : '创建时间',
						field : 'createTime',
						width : '100px'
					}, {
						title : '型号',
						field : 'lockType',
						width : '100px'
					}, {
						title : 'apikey',
						field : 'apikey',
						width : '100px'
					}, {
						title : 'IMEI',
						field : 'imei',
						width : '100px'
					}, {
						title : 'IMSI',
						field : 'imsi',
						width : '100px'
					}, {
						title : '序列号',
						field : 'serialnumber',
						width : '100px'
					}, {
						title : '密码',
						field : 'password',
						width : '100px'
					}, {
						title : 'mac',
						field : 'mac',
						width : '100px'
					}] ],
					onDblClickCell : function(index, field, value) {
						edit();
					}
	    }) 
	});

	var treeTab = $('#region_tree');
	//公用树点击事件
	var node;
	function treeClick(treeObj, n){
		if(typeof n!='undefined' ){
			node=n;
			treeTab = treeObj;
			searchCustomerFile();
		}
	}
	

	</script>

<script type="text/javascript">
window.top["reload_taskTab"] = function () {  
    $("#dg").datagrid('reload');//刷新  
    $("#region_tree").tree('reload');
    $("#org_tree").tree('reload');
};  

function doSearch() {
	var selectValue=$("#querySelect").val();
	var inputValue=$("#queryInput").val();
	var url="${pageContext.request.contextPath}/mbAieLock/queryAieLock";
	query(url,selectValue,inputValue);
}

function query(url,selectValue,inputValue){
	$('#dg').datagrid(
			{
				url : url,
				pagination : true,//分页控件
				pageList : [ 10, 20, 30, 40, 50 ],
				queryParams: {selectValue:selectValue,inputValue:inputValue},
				fit : true, //自适应大小
				singleSelect : true,
				iconCls : 'icon-save',
				border : false,
				nowrap : true,//数据长度超出列宽时将会自动截取。
				rownumbers : true,//行号
				fitColumns : true,//自动使列适应表格宽度以防止出现水平滚动。
				columns : [ [
					{
					title : 'id',
					field : 'id',
					width : '200px',
					hidden:true
				}, {
					title : '锁名称',
					field : 'lockName',
					width : '180px'
				}, {
					title : '所属表箱',
					field : 'boxName',
					width : '180px'
				}, {
					title : '锁编号',
					field : 'lockCode',
					width : '200px'
				}, {
					title : '组织机构',
					field : 'organizationName',
					width : '120px'
				}, {
					title : '生产厂家',
					field : 'produce',
					width : '100px'
				}, {
					title : '生产日期',
					field : 'produceTime',
					width : '120px'
				},{
					title : '创建人',
					field : 'createPerson',
					width : '100px'
				}, {
					title : '创建时间',
					field : 'createTime',
					width : '100px'
				}, {
					title : '型号',
					field : 'lockType',
					width : '100px'
				}, {
					title : 'apikey',
					field : 'apikey',
					width : '100px'
				}, {
					title : 'IMEI',
					field : 'imei',
					width : '100px'
				}, {
					title : 'IMSI',
					field : 'imsi',
					width : '100px'
				}, {
					title : '序列号',
					field : 'serialnumber',
					width : '100px'
				}, {
					title : '密码',
					field : 'password',
					width : '100px'
				}, {
					title : 'mac',
					field : 'mac',
					width : '100px'
				}] ],
				onDblClickCell : function(index, field, value) {
					edit();
				}
    })
}

//添加
function add() {
	$('#dlg').dialog('open').dialog('setTitle', '添加');
	$('#fm').form('clear');
	url = '${pageContext.request.contextPath}/mbAieLock/addAieLock';
}

//编辑菜单
function edit(index){
	/* $("#name").textbox("readonly",true);
	$("#equipmenttype").combobox("readonly",true);
	$("#communicationstatus").combobox("readonly",true);
	$("#manufacturer").combobox("readonly",true);
	$("#unify").combobox("readonly",true); */
	var row;
	if(null!=index && typeof(index)!=undefined){
		//双击编辑
		 row = $('#dg').datagrid('getData').rows[index]; 
	}else{
		//按钮编辑
		var selRow = $("#dg").datagrid('getSelections');
	    if (selRow.length != 1) {
	   	 $.messager.alert('提示','请选择一行数据。','warning');
	        return false;
	    }else{
	    	row = $('#dg').datagrid('getSelected');
	    }
    }
     
	$('#fm').form('clear');
	if (row){
		$('#dlg').dialog('open').dialog('setTitle','编辑型号');
		$('#fatherOrgID').combotree("setValue",{
			id:row.organizationName		
		});
		var organizationId=row.organizationCode;
		$('#measureIds').combobox('reload','${pageContext.request.contextPath}/measureFile/getMeasurefileByOrganizationId?OrganizationId='+organizationId);
		$('#measureIds').combobox("setValue",row.boxName);
		$('#dlg').dialog('open').dialog('setTitle','编辑型号');
		$('#fm').form('load',row);
		url = '${pageContext.request.contextPath}/mbAieLock/editAieLock?id='+row.id;
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
			result=jQuery.parseJSON(result);
			if (result.code == 200) {
				$.messager.alert('提示', result.message, 'success');
				$('#dlg').dialog('close'); // close the dialog
				$('#dg').datagrid('reload'); // reload the user data
			}else if(result.code == 400){
				$.messager.alert('警告', result.message, 'error');
			} else {
				$.messager.alert('警告', result, 'error');
			}
		},
		error : function(data) {
			$.messager.alert('警告', data, 'error');

		}
	});
}

//删除设备
function deleteMeasure(){
	 var selRow = $("#dg").datagrid('getSelections');
     if (selRow.length == 0) {
    	 $.messager.alert('提示','请至少选择一行数据。','warning');
         return false;
     }
     $.messager.confirm('提示', '确认删除?', function(r) {
         if (r) {
        	 var searchid={"id":selRow[0].id};
             $.ajax({
            	 type:'POST', 
		         url:'${pageContext.request.contextPath}/mbAieLock/deleteAieLock',  
                 //dataType : 'json',
                 data:searchid,
                 success:function(result){ 
			    	   if(result.code==200){
							$('#dg').datagrid('reload');	// reload the user data
							$.messager.alert('提示',result.message,'info');
							//parent.location.reload();
						}
			    	   else if(result.code==400){
			    		   $.messager.alert('警告',result.message,'error');
			    	   }else{
			    		   $.messager.alert('警告',result,'error');
						}
			       
			        },	        
			        error:function(data){
			        	$.messager.alert('警告',data,'error');
			        	
		          }
             });
         }
     });
}

//导入
function importMeasurefile() {
	var path = $("#excelfile").textbox("getValue");
	if (null == path || path == "") {
		$.messager.alert('<spring:message code="Prompt"/>',
				'<spring:message code="Choose_a_file"/>', 'warning');
		return false;
	}

	//根据文件导入
	$('#imfm').form('submit',
	{
		url : '${pageContext.request.contextPath}/mbAieLock/importExcel',
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
function exportMeasurefile() {
	window.open("${pageContext.request.contextPath}/mbAieLock/exportAieLockToExcel");
}
var node;
function treeClick(treeObj, n){
	console.log(n);
	var type=n.type;
	var gid=n.gid;
	$('#dg').datagrid({
		url: "${pageContext.request.contextPath}/mbAieLock/queryAielockByTree",
		queryParams: {type:type,gid:gid,page:1,rows:10},
		pagination : true,//分页控件
		pageList: [10, 20, 30, 40, 50],
		fit: true,   //自适应大小
		singleSelect: true,
		//iconCls : 'icon-save',
		border:false,
		nowrap: true,//数据长度超出列宽时将会自动截取。
		rownumbers:true,//行号
		fitColumns:true,//自动使列适应表格宽度以防止出现水平滚动。
		columns : [ [
			{
			title : 'id',
			field : 'id',
			width : '200px',
			hidden:true
		}, {
			title : '锁名称',
			field : 'lockName',
			width : '180px'
		}, {
			title : '所属表箱',
			field : 'boxName',
			width : '180px'
		}, {
			title : '锁编号',
			field : 'lockCode',
			width : '200px'
		}, {
			title : '组织机构',
			field : 'organizationName',
			width : '120px'
		}, {
			title : '生产厂家',
			field : 'produce',
			width : '100px'
		}, {
			title : '生产日期',
			field : 'produceTime',
			width : '120px'
		},{
			title : '创建人',
			field : 'createPerson',
			width : '100px'
		}, {
			title : '创建时间',
			field : 'createTime',
			width : '100px'
		}, {
			title : '型号',
			field : 'lockType',
			width : '100px'
		}, {
			title : 'apikey',
			field : 'apikey',
			width : '100px'
		}, {
			title : 'IMEI',
			field : 'imei',
			width : '100px'
		}, {
			title : 'IMSI',
			field : 'imsi',
			width : '100px'
		}, {
			title : '序列号',
			field : 'serialnumber',
			width : '100px'
		}, {
			title : '密码',
			field : 'password',
			width : '100px'
		}, {
			title : 'mac',
			field : 'mac',
			width : '100px'
		}] ],
		        onLoadSuccess:function(){
					$('.button-delete').linkbutton({ 
					});
					$('.button-edit').linkbutton({ 
					});
					
					$('.text').textbox({
						width:70,
						height:30
					})

				},
		        onDblClickCell: function(index,field,value){
		        	edit(index);
		 		}
	});	
}
</script>
</body>
</html>