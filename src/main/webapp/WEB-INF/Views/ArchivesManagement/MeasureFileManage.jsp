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
<div class="easyui-layout" style="width:100%;height:100%;">
	<div id="west" region="west" iconCls="icon-organization" split="true" title="" style="width:280px;min-width:280px;" collapsible="true">
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
			action='${pageContext.request.contextPath}/measureFile/exportExcel'
			method="get">
			<input type="hidden" name="nodetype" id="nodetype"/> 
				<input type="hidden" name="nodegid" id="nodegid"/>      
				<input type="hidden" name="searchname" id="searchname"/>  
				<input type="hidden" name="searchnumber" id="searchnumber"/>  
				<input type="hidden" name="searchaddress" id="searchaddress"/>  
		</form>
		<div style="display: inline-block;">
        				<label style="font-size:14px">表箱名称:</label>
						<input id="MeasureName" class="easyui-textbox" style="width:160px;height:26px;" data-options="
		                   prompt: '请输入名称……'"/>
        			</div>
        			<div style="display: inline-block;">
        				<label style="font-size:14px">表箱编号:</label>
						<input id="MeasureNumber" class="easyui-textbox" style="width:160px;height:26px;" data-options="
		                   prompt: '请输入编号……'"/>
        			</div>
			<div style="display: inline-block;">
        				<label style="font-size:14px">安装地址:</label>
						<input id="Address" class="easyui-textbox" style="width:160px;height:26px;" data-options="
		                   prompt: '请输入地址……'"/>
        			</div>
        				        <a href="javascript:void(0)" class="easyui-linkbutton button-edit button-default" data-options="iconCls:'icon-search'" onclick="doSearch()" title="Search">检索</a>
	</div>
	</div>
</div>

<div id="dlg" class="easyui-dialog"
		style="width: 750px; height: 400px; padding: 10px 20px" closed="true"
		buttons="#dlg-buttons">
		<form id="fm" class="easyui-form" method="POST">
			<table cellspacing="8">
				<tr>
					<td>				
					<input type="hidden" id="measureId" name="measureId">				
					<input class="easyui-numberbox" type="text"
						style="width: 300px" name="measureNumber" id="fmeasureNumber"  value="wewe"
						data-options="label:'表箱编号',required:true,validType:'maxlength[20]'"></input></td>
						<td><input class="easyui-textbox" type="text"
						style="width: 300px" name="measureName"
						data-options="label:'表箱名称',required:true,validType:'maxlength[50]'"></input></td>
				</tr>
				<tr>
				    <td><input class="easyui-textbox" type="text"
						style="width: 300px" name="address"
						data-options="label:'安装地址',validType:'maxlength[20]'"></input></td>
						 <td><select class="easyui-combotree"
									url="${pageContext.request.contextPath}/organization/organizationTree?Math.random()"
									name="fatherOrgID" id="fatherOrgID" style="width: 300px;" data-options="label:'组织机构',required:true,
									onSelect: function(node) {
								    	$('#organizationId').val(node.gid);
								    }">
								</select>
								<input type="hidden" name="organizationId" id="organizationId"/></td>	
				</tr>
			<tr>
				  <tr>
							<td colspan="3"><input class="easyui-textbox" type="text"
						style="width:30px" 
						data-options="label:'行政区域',">			
								<select class="easyui-combobox" id="selProvince" style="width:150px"
								url="${pageContext.request.contextPath}/region/getProvince?Math.random()"
								data-options="valueField:'id',editable:false, textField:'name',
									onSelect: function(node) {
									    var url = '${pageContext.request.contextPath}/region/getCity?provinceid='+node.id
								    	$('#selCity').combobox('reload', url);
								    	$('#selCity').combobox('setValue','');
								    	$('#selCountry').combobox('setValue','');
								    	$('#selTown').combobox('setValue','');
								    }"></select>
								<select class="easyui-combobox" id="selCity" style="width:150px"
								url="${pageContext.request.contextPath}/region/getCity?provinceid=0"
								data-options="valueField:'id',editable:false, textField:'name',
									onSelect: function(node) {
								    	var url = '${pageContext.request.contextPath}/region/getCountry?cityid='+node.id
								    	$('#selCountry').combobox('reload', url);
								    	$('#selCountry').combobox('setValue','');
								    	$('#selTown').combobox('setValue','');
								    }"></select>
								<select class="easyui-combobox" id="selCountry" style="width:150px"
								url="${pageContext.request.contextPath}/region/getCountry?cityid=0"
								data-options="editable:false,valueField:'id', textField:'name',onSelect: function(node) {
								    	var url = '${pageContext.request.contextPath}/region/getStreet?countryid='+node.id
								    	$('#selTown').combobox('reload', url);
								    	$('#selTown').combobox('setValue','');
								    }"></select>
								<select class="easyui-combobox" id="selTown"  style="width:150px"
								url="${pageContext.request.contextPath}/region/getStreet?countryid=0"
								data-options="required:true,editable:false,valueField:'id', textField:'name',
								onSelect: function(node) {										
								    	$('#region').val(node.id);								    		                                  
								    }"></select>
								<input type="hidden" name="region" id="region"/>
							</td>
						</tr>									 						
				<tr>
				
						<td colspan="3"><input class="easyui-textbox" type="text"
						style="width: 10px" 
						data-options="label:'经纬度',validType:'maxlength[20]'"></input><input class="easyui-textbox shorttextbox" style="width:100px;" name="longitude" id="longitude" value="${requestScope.customerfile.longitude}"
								data-options="required:true,validType:'IntOrFloat'"></input>
								<input class="easyui-textbox shorttextbox" style="width:100px;" name="latitude" id="latitude" value="${requestScope.customerfile.latitude}"
								data-options="required:true,validType:'IntOrFloat'"></input>
								<a href="#" class="easyui-linkbutton" onclick="pickCoords()" id="">拾取</a>
							</td>
				   									 
				</tr>					
				<tr>			
				<td><input class="easyui-textbox" type="text"
						style="width: 300px" name="manufacturer"
						data-options="label:'生产厂家',validType:'maxlength[20]'"></input></td>		
				    <td><input class="easyui-datetimebox" editable="fasle" type="text" 
				    style="width:300px" name="produceDate" data-options="label:'生产日期',required:true"></input></td>
				     
				</tr>						
			</table>
		</form>
	</div>
	<div id="pickCoordsDlg" class="easyui-dialog" close="true" buttons="#pickCoordsDlg-buttons" style="width:650px;height:400px;position: relative;"></div>
<div id="pickCoordsDlg-buttons">
		<a href="#" class="easyui-linkbutton" iconCls="icon-ok" id="getCoordsButton">确定</a>
		<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#pickCoordsDlg').dialog('close')"><spring:message code="Cancel"/></a>
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
		$('#pickCoordsDlg').dialog('close')
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
					url : '${pageContext.request.contextPath}/measureFile/getDataGrid?Math.random()',
					queryParams: { },
					pagination : true,//分页控件
					pageList : [ 10, 20, 30, 40, 50 ],
					fit : true, //自适应大小
					singleSelect : true,
					iconCls : 'icon-save',
					border : false,
					nowrap : true,//数据长度超出列宽时将会自动截取。
					rownumbers : true,//行号
					fitColumns : true,//自动使列适应表格宽度以防止出现水平滚动。
					columns : [ [{
						title : '表箱编号',
						field : 'measureNumber',
						width : '180px'
					}, {
						title : '表箱Id',
						field : 'measureId',
						width : '200px',
						hidden:true
					}, {
						title : '表箱名字',
						field : 'measureName',
						width : '200px'
					}, {
						title : '安装地址',
						field : 'address',
						width : '120px'
					}, {
						title : '经度',
						field : 'longitude',
						width : '100px'
					}, {
						title : '纬度',
						field : 'latitude',
						width : '100px'
					},{
						title : '组织机构',
						field : 'organizationname',
						width : '120px'
					}, {
						title : '行政区域',
						field : 'name',
						width : '120px'
					},{
						title : '生产厂家',
						field : 'manufacturer',
						width : '100px'
					}, {
						title : '生产日期',
						field : 'produceDate',
						width : '100px'
					}, {
						title : '创建人',
						field : 'creater',
						width : '100px'
					}, {
						title : '创建日期',
						field : 'createDate',
						width : '100px'
					}] ],
					onDblClickCell : function(index, field, value) {
						edit();
					}
	    }) 
	});
	</script>

<script type="text/javascript">
window.top["reload_taskTab"] = function () {  
    $("#dg").datagrid('reload');//刷新  
    $("#region_tree").tree('reload');
    $("#org_tree").tree('reload');
};  
//添加
function add() {
	$('#dlg').dialog('open').dialog('setTitle', '添加');
	$('#fm').form('clear');
	url = '${pageContext.request.contextPath}/measureFile/addOrUpdate';
}

//修改
function edit() {

	var row = $('#dg').datagrid('getSelected');
	if (row) {	
		var leveltype=row.area.leveltype;
		var id=row.region;		
		$('#measureId').val(row.measureId);
		$('#fatherOrgID').combotree("setValue",{
			id:row.organizationname		
		});	
		
		$.ajax({
	    	type: 'POST',
	    	url:'${pageContext.request.contextPath}/region/getPar', 
	    	dataType:"json",
		    data: {		      
		        "id":id,
		        "leveltype":leveltype      		
		    },
		    success:function(data){ 
		    	var provinceid=data.province.id;
		    	var cityid=data.city.id;
		    	var countryid=data.country.id;
		    	var streeid=data.stree.id;
		    	$('#dlg').dialog('open').dialog('setTitle', '修改');		    	
		    	$('#selProvince').combobox("setValue",data.province.name);
		    	$('#selCity').combobox("setValue",data.city.name);
		    	$('#selCountry').combobox("setValue",data.country.name);
		    	$('#selTown').combobox("setValue",data.stree.name);		
		    	$('#region').val(data.stree.id);
		    	$('#selTown').combobox('reload', '${pageContext.request.contextPath}/region/getStreet?countryid='+countryid);
		    	$('#selCountry').combobox('reload', '${pageContext.request.contextPath}/region/getCountry?cityid='+cityid);
		    	$('#selCity').combobox('reload', '${pageContext.request.contextPath}/region/getCity?provinceid='+provinceid);
		    },
		    error:function(data){
		    	alert("发生了错误，请联系管理员");
		    }
		});
		
		$('#fm').form('load', row);
		
		url = '${pageContext.request.contextPath}/measureFile/addOrUpdate';
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
			if (result == "success") {
				$('#dlg').dialog('close'); // close the dialog
				$('#dg').datagrid('reload'); // reload the user data
			} else {
				$.messager.alert('警告', result, 'error');
			}
		},
		error : function(data) {
			$.messager.alert('警告', data, 'error');

		}
	});
}

//删除
function deleteMeasure() {
	var row = $('#dg').datagrid('getSelected');
	if (row) {
		$.messager.confirm('删除', '你确定要删除该表箱信息吗？', function(r) 
		{
			if (r) {
				var data = {
						"MeasureId" : row.measureId,
						"MeasureNumber" : row.measureNumber
				};
				$.ajax({
					type : 'POST',
					url : '${pageContext.request.contextPath}/measureFile/delete',
					data : data,
					success : function(data) {
						if (data == "success") {
							$('#dg').datagrid(
									'reload'); // reload the user data
							$.messager.alert(
									'提示',
									'删除成功。',
									'info');
						}  else {
							$.messager.alert(
									'警告', data,
									'error');
						}

					},
					error : function(data) {
						$.messager.alert('警告',
								data, 'error');

					}
				});
			}
		});
	}
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
		url : '${pageContext.request.contextPath}/measureFile/importExcel',
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
	$('#exfm').form('submit');
}

function doSearch() {
	var MeasureName=$('#MeasureName').val();
	var MeasureNumber=$('#MeasureNumber').val();	
	var Address=$('#Address').val();
	//导出execl用
	$("#searchname").val(MeasureName);
	$("#searchnumber").val(MeasureNumber);
	$("#searchaddress").val(Address);
	$('#dg').datagrid({
		url :'${pageContext.request.contextPath}/measureFile/MeasureFilInf?Math.random()',
		queryParams: {
			MeasureName :MeasureName,
			MeasureNumber : MeasureNumber,
			Address : Address	    	
		},
		pagination : true,//分页控件
		pageList: [10, 20, 30, 40, 50],
		fit: true,   //自适应大小
		singleSelect: true,
		border:false,
		nowrap: true,//数据长度超出列宽时将会自动截取。
		rownumbers:true,//行号
		fitColumns:true,//自动使列适应表格宽度以防止出现水平滚动。
		columns : [ [{
			title : '表箱编号',
			field : 'measureNumber',
			width : '180px'
		}, {
			title : '表箱Id',
			field : 'measureId',
			width : '200px',
			hidden:true
		}, {
			title : '表箱名字',
			field : 'measureName',
			width : '200px'
		}, {
			title : '安装地址',
			field : 'address',
			width : '120px'
		}, {
			title : '经度',
			field : 'longitude',
			width : '100px'
		}, {
			title : '纬度',
			field : 'latitude',
			width : '100px'
		}, {
			title : '组织机构',
			field : 'organizationname',
			width : '120px'
		}, {
			title : '行政区域',
			field : 'name',
			width : '120px'
		},{
			title : '生产厂家',
			field : 'manufacturer',
			width : '100px'
		}, {
			title : '生产日期',
			field : 'produceDate',
			width : '100px'
		}, {
			title : '创建人',
			field : 'creater',
			width : '100px'
		}, {
			title : '创建日期',
			field : 'createDate',
			width : '100px'
		}] ]
	   }) 
}

//拾取设备坐标
function pickCoords(){
	var regionid = $("#region").val();
	if(!regionid){
		$.messager.alert('<spring:message code="Warning"/>', "请先选择行政区域。", 'error');
		return;
	} 					
	var longitude = $("#longitude").val(),latitude = $("#latitude").val();;
	var coordsStr = "";
	if(longitude != "" && latitude != ""){
		coordsStr = "[" + longitude + "," + latitude + "]";
	}
	var cityname = $("#selCity").combobox('getText');
	var url = '${pageContext.request.contextPath}/sysCustomerFile/coordsPick?coords='+window.encodeURI(coordsStr)+'&regionid='+regionid+'&cityname='+window.encodeURI(cityname);
	var content = '<iframe src="' + url + '" width="100%" height="99%" frameborder="0" scrolling="no"></iframe>';
    $('#pickCoordsDlg').dialog({
    	title: '拾取用户坐标',
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
	$("#longitude").textbox("setValue", lonlat[0]);
	$("#latitude").textbox("setValue", lonlat[1]);	
	$('#pickCoordsDlg').dialog('close');
}

/*连接websocket
function connect() {
    var WebSocketsExist = true;
    try {
        ws = new ReconnectingWebSocket("ws://" + "${requestScope.websocketip}" + ":" + "${requestScope.websocketport}");
    }
    catch (ex) {
        try {
            ws = new ReconnectingWebSocket("ws://" + "${requestScope.websocketip}" + ":" + "${requestScope.websocketport}");
        }
        catch (ex) {
            WebSocketsExist = false;
        }
    }
    if (!WebSocketsExist) {
    	$.messager.alert("警告", "您的浏览器不支持WebSocket。请选择其他的浏览器再尝试连接服务器。", "error");
        return;
    }
    ws.onopen = WSonOpen;
    ws.onmessage = WSonMessage;
    ws.onclose = WSonClose;
    ws.onerror = WSonError;
}

function WSonOpen(e) {
    //客户端端口组帧,帧类型为3（握手）
    var curPort = makeWSFrame(1, 0, 3, 1, port, '');
    ws.send(curPort);
}

function WSonMessage(event) {
    //console.log(event.data);
    var msg = event.data;
    //解析帧，Global.js中定义
    var frame = parseWSFrame(msg);
    if (frame == "") return;
    //帧类型为3（握手），表示端口号
    if (frame.type == '3') {
        port = frame.data;
    }
    else if (frame.type == '2') {  //帧类型为2（应答）
    }
}

function WSonClose(e) {
    try {
    	initProgress(); //初始化进度条
        //$.messager.alert("警告", "远程服务器连接中断，请刷新页面后重试。", "error");
    }
    catch (ex) {

    }
}
*/
function WSonError(e) {
    
}

var treeTab = $('#region_tree');
//公用树点击事件
var node;
function treeClick(treeObj, n){
	if(typeof n!='undefined' ){		   	
		node=n;
		treeTab = treeObj;
		//导出execl用
		 $("#nodetype").val(node.type);
		 $("#nodegid").val(node.gid);	
		searchMeasureFile();
	}
}

function searchMeasureFile() {
	$("#dg").datagrid('load', {
		id : node.gid,
		type : node.type,
		name : $('#MeasureName').val(),
	    number : $('#MeasureNumber').val(),
	    address : $('#Address').val()
	});
}
</script>
</body>
</html>