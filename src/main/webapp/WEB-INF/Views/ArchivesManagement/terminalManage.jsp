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
		<jsp:include page="../CommonTree/terminalTree.jsp"/>
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
				data-options="iconCls:'icon-remove'" onclick="deleteTerminal()"><spring:message
					code="Delete" /></a>
					<a href="#" class="easyui-linkbutton" data-options="" onclick="issued()">下发</a>
					<input class="easyui-filebox"
				style="width: 180px" id="excelfile" name="excelfile"
				data-options="prompt:'选择一个文件...', buttonText: '选择文件',buttonAlign:'left'"></input>
			<a href="#" class="easyui-linkbutton"
				data-options="iconCls:'icon-import'" onclick="importTerminal()"><spring:message
					code="Import"  /></a> <a href="#" class="easyui-linkbutton"
				data-options="iconCls:'icon-export'" onclick="exportTerminal()"><spring:message
					code="Export" /></a>
		</form>
		<!-- 导出 -->
		<form id="exfm"
			action='${pageContext.request.contextPath}/terminal/exportExcel'
			method="get">
			<input type="hidden" name="nodetype" id="nodetype"/> 
				<input type="hidden" name="nodegid" id="nodegid"/>      
				<input type="hidden" name="searchname" id="searchname"/>  
				<input type="hidden" name="searchnumber" id="searchnumber"/>  
				<input type="hidden" name="searchaddress" id="searchaddress"/>  		
		</form>
		<div style="display: inline-block;">
        				<label style="font-size:14px">终端名称:</label>
						<input id="terminalName" class="easyui-textbox" style="width:160px;height:26px;" data-options="
		                   prompt: '请输入名称……'"/>
        			</div>      			
			<div style="display: inline-block;">
        				<label style="font-size:14px">终端地址:</label>
						<input id="address" class="easyui-textbox" style="width:160px;height:26px;" data-options="
		                   prompt: '请输入地址……'"/>
        			</div>
        				        <a href="javascript:void(0)" class="easyui-linkbutton button-edit button-default" data-options="iconCls:'icon-search'" onclick="doSearch()" title="Search">检索</a>
	</div>
	</div>
</div>

<div id="dlg" class="easyui-dialog"
		style="width: 665px; height: 420px; padding: 10px 20px" closed="true"
		buttons="#dlg-buttons">
		<form id="fm" class="easyui-form" method="POST">
			<table cellspacing="8">
				<tr>
					<td>				
					<input type="hidden" id="terminalId" name="terminalId">		
					<input type="hidden" id="region" name="region">		
					<input class="easyui-textbox" type="text"
						style="width: 300px" name="terminalName" 
						data-options="label:'终端名称',required:true,validType:'maxlength[20]'"></input></td>
						<td><input class="easyui-textbox" type="text"
						style="width: 300px" name="address"
						data-options="label:'终端地址',required:true,validType:'maxlength[50]'"></input></td>
				</tr>
				<tr>
				    <td><input class="easyui-textbox" type="text"
						style="width: 300px" name="installationLocation"
						data-options="label:'安装位置',validType:'maxlength[20]'"></input></td>	
						<td>							
					<input class="easyui-numberbox" type="text"
						style="width: 300px" name="terminalType"  
						data-options="label:'终端型号',validType:'maxlength[20]'"></input></td>										
				</tr>
			<tr>
				  <tr>
					<td><select class="easyui-combotree"
									url="${pageContext.request.contextPath}/organization/organizationTree?Math.random()"
									name="fatherOrgID" id="fatherOrgID" style="width: 300px;" data-options="label:'组织机构',required:true,
									onSelect: function(node) {
									  var url = '${pageContext.request.contextPath}/measureFile/getMeasurefileByOrganizationId?OrganizationId='+node.gid
								    	$('#measureIds').combobox('reload', url);
								    	$('#organizationId').val(node.gid);
								    	$('#measureIds').combobox('setValue','');
								    	$('#concentratorIds').combobox('setValue','');
								    }">
								</select>
								<input type="hidden" name="organizationId" id="organizationId"/></td>								 	
						<td><select class="easyui-combobox"
									url="${pageContext.request.contextPath}/measureFile/getMeasurefileByOrganizationId?OrganizationId=0"
									 id="measureIds" style="width: 300px;" data-options="label:'所属表箱',required:true,
									 editable:false,valueField:'MeasureId', textField:'MeasureName',
									onSelect: function(node) {
									var url='${pageContext.request.contextPath}/concentratorFile/getConcentratorByMeasureId?measureId='+node.MeasureId;
									$('#concentratorIds').combobox('reload', url);
								    	$('#measureId').val(node.MeasureId);
								    	$('#concentratorIds').combobox('setValue','');
								    }">
								</select>
								<input type="hidden" name="measureId" id="measureId"/>
							</td>																 						 	
						</tr>
				<tr>
				<td><select class="easyui-combobox"
									url="${pageContext.request.contextPath}/concentratorFile/getConcentratorByMeasureId?measureId=0"
									 id="concentratorIds" style="width: 300px;" data-options="label:'所属集中器',required:true,
									 editable:false,valueField:'concentratorId', textField:'concentratorName',
									onSelect: function(node) {
								    	$('#concentratorId').val(node.concentratorId);
								    	$('#region').val(node.Region);
								    }">
								</select>
								<input type="hidden" name="concentratorId" id="concentratorId"/>
							</td>	
									
				</tr>									 									
				<tr>
				<td><input class="easyui-textbox" type="text"
						style="width: 300px" name="manufacturer"
						data-options="label:'生产厂家',validType:'maxlength[20]'"></input></td>
				    <td><input class="easyui-datetimebox" editable="fasle" type="text" 
				    style="width:300px" name="produceDate" data-options="label:'生产日期'"></input></td>				      
				</tr>			
				<tr>				
				<tr>					
					<td><input class="easyui-textbox" type="text"
						style="width: 300px" name="softType" id="softType"
						data-options="label:'软件版本号',validType:'maxlength[20]'"></input></td>						
						<td><input class="easyui-textbox" type="text"
						style="width: 300px" name="hardType"
						data-options="label:'硬件版本号',validType:'maxlength[50]'"></input></td>
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
var ws;
var port = '0'; //前一次端口号，断线重连时用到
var frameNumber = 1; //帧序号

var sendXmlCount = 0; //发送到前置机总数量
var msgCount = 0; //接收到前置机消息数量
var progressBar; //进度条
function initProgress() {
	sendXmlCount = 0;
	msgCount = 0;
    progressBar = undefined;
    $.messager.progress('close');
}

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
					url : '${pageContext.request.contextPath}/terminal/getDataGrid?Math.random()',
					pagination : true,//分页控件
					pageList : [ 10, 20, 30, 40, 50 ],
					fit : true, //自适应大小
					singleSelect : false,
					iconCls : 'icon-save',
					border : false,
					nowrap : true,//数据长度超出列宽时将会自动截取。
					rownumbers : true,//行号
					fitColumns : true,//自动使列适应表格宽度以防止出现水平滚动。
					columns : [ [
						{ field: 'ck', checkbox:true },
				/*		{title: '下发状态', field: 'DOWNSTATUS', width:'60px',
				        	formatter:function(value, rowData, rowIndex){
				        		if(value==1){
									return "已下发";
			            		}else if(value==0)
			            			return "<span style='color:red'>未下发</span>";
			            		}
				        }, */
						{
						title : '终端名称',
						field : 'terminalName',
						width : '180px'
					},
					{
						title : '终端地址',
						field : 'address',
						width : '200px',						
					}, {
						title : '安装位置',
						field : 'installationLocation',
						width : '200px'
					}, {
						title : '所属集中器',
						field : 'concentratorName',
						width : '120px'
					}, {
						title : '组织机构',
						field : 'organizationName',
						width : '120px'
					}, {
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
					}, {
						title : '所属表箱',
						field : 'measureName',
						width : '100px'
					}, {
						title : '终端型号',
						field : 'terminalType',
						width : '100px'
					}, {
						title : '软件版本号',
						field : 'softType',
						width : '100px'
					}, {
						title : '硬件版本号',
						field : 'hardType',
						width : '100px'
					}] ],
					onDblClickCell : function(index, field, value) {			
						edit(index);
					}
	    })     
	 	//websocket
	   	connect();
	});
	/*连接websocket*/
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
	    	
	    	if (progressBar) { //进度变更
	            msgCount++;
	            if (msgCount == sendXmlCount || frame.num.substr(1) == frameNumber) { //关闭进度条
	                progressBar.progressbar("setValue", 100);
	                setTimeout(function () {
	                    $.messager.progress('close');
	                }, 800);
	                initProgress();
	            }
	            else {
	                var rate = 0;
	                if (sendXmlCount != 0) rate = Math.floor(msgCount / sendXmlCount * 100);
	                progressBar.progressbar("setValue", rate);
	            }
	        }
	    	
	        if (frame.data.length.toString() == frame.len) { //判断是否接收到完整的数据帧
	        	var type=1;
	        	$.ajax({
					type: 'POST',
					url: '${pageContext.request.contextPath}/fileManage/parseResponse',
					data: {
						"strXML": frame.data,
						"type": type
					},
					success: function(d) {
						if(d.typeFlagCode==151){
							$("body").find("div.datagrid-mask-msg").remove();
				            $("body").find("div.datagrid-mask").remove();
						}
						var date=(new Date()).toLocaleString( );//获取当前日期时间
						switch(d.result){
						case 1:
							switch (d.typeFlagCode){
								case 129:	
									$('#dg').datagrid('reload');	// reload the user data
									$.messager.alert('提示',date+"-下发档案成功。",'info');
									break;
							}
							break;
						case 2:
							$.messager.alert('<spring:message code="Warning"/>',date+"-终端连接超时。",'error');
							break;
						case 3:
							$.messager.alert('<spring:message code="Warning"/>',date+"-终端否认应答。",'error');
							break;
						case 4:
							$.messager.alert('<spring:message code="Warning"/>',date+"-终端不在线。",'error');
							break;
						case 8:
							switch (d.typeFlagCode){
								case 129:
									$.messager.alert('<spring:message code="Warning"/>',date+"-下发档案失败。",'error');
									break;
							}
							break;
						default:
							$.messager.alert('<spring:message code="Warning"/>',date+"-前置机未知错误。",'error');
							break;
						}
					}
				});
	        }
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
	
	function WSonError(e) {
	    
	}

	//下发档案
	function issued(){
	    //勾选的数据
		var selRow = $("#dg").datagrid('getSelections');
	    if (selRow.length == 0) {
	   		$.messager.alert('提示','请勾选设备档案！','warning');
	        return;
	    }

	    var id = [];
	    for (var i = 0; i < selRow.length; i++){
	       	if(selRow[i].COMMUNICATIONSTATUS==1){
	       		id.push(selRow[i].terminalId); //把单个id循环放到ids的数组中  
	       	}
	    }
	 
	    if(id.length==0 ){
	   		$.messager.alert('提示','选择的设备不可全为不支持下发的设备','warning');
	   		return false;
	    }
	    

	    //下发到终端
	    if(id.length!=0){
	    	//终端
	    	var type = 1
		    if (ws) {
		        if (ws.readyState == 1) { 
		            $.messager.confirm('提示', '确认下发到终端?', function(r) {
		                if (r) {
		                    $.ajax({
		                       	type:'POST', 
		           		        url:'${pageContext.request.contextPath}/fileManage/issued',  
		                        data : {
		                             "id[]" : id,
		                             "type" : type
		                         },
		                         success:function(d){ 
		                        	 dealSetXml(d)
		           		        },	        
		           		        error:function(d){
		           		        	$.messager.alert('警告',d,'error');
		           			        	
		           		        }
		                	});
		                }
		            });
		        }
		        else {
		        	$.messager.alert("警告", "通信异常，请刷新页面后重试。", "error");
		        }
		    }
		    else {
		    	$.messager.alert("警告", "您的浏览器不支持WebSocket。请选择其他的浏览器再尝试连接服务器。", "error");
		    }
	    }
	}
	
	//处理下发档案XML
	function dealSetXml(d){
		if (d != "" && d.indexOf("html") == -1) {
			//parent.window.location.reload();
			var a = JSON.parse(d);
			if(a.length>0){
				$.messager.progress({
	               title: '档案下发中，请稍候...',
	               interval: 0
	            });
	            progressBar = $.messager.progress('bar');
	            sendXmlCount = a.length;
	           
				for(var p in a){
					frameNumber++;
	                   //组帧，Global.js中定义
	                   var frame = makeWSFrame(frameNumber, 0, 1, 1, a[p], '');
	                   ws.send(frame);
				} 
			}else{
				$.messager.alert('提示',"返回的XML为空，没有未下发的档案！",'info');
			} 
		}else{
			$.messager.alert('警告',"获取下发所有档案的XML失败。",'error');
		}
	}

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
	url = '${pageContext.request.contextPath}/terminal/addOrUpdate';
}

//修改
function edit(index) {
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
	if (row){
		var organizationId=row.organizationId;		
		//显示combo框的值
		$('#fatherOrgID').combotree("setValue",{
			id:row.organizationName		
		});	
		$('#measureIds').combobox('setValue',row.measureId);	
		//重载combo链接
	//	$('#measureIds').combobox('reload','${pageContext.request.contextPath}/measureFile/getMeasurefileByOrganizationId?OrganizationId='+organizationId);
		$('#concentratorIds').combobox('setValue',row.concentratorId);	
	//	$('#concentratorIds').combobox('reload','${pageContext.request.contextPath}/concentratorFile/getConcentratorByMeasureId?measureId='+row.measureId);
		$('#dlg').dialog('open').dialog('setTitle', '修改');		    			
		$('#fm').form('load', row);		
		url = '${pageContext.request.contextPath}/terminal/addOrUpdate';
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
function deleteTerminal() {
	var row = $('#dg').datagrid('getSelected');
	if (row) {
		$.messager.confirm('删除', '你确定要删除该终端信息吗？', function(r) 
		{
			if (r) {
				var data = {
						"terminalId" : row.terminalId						
				};
				$.ajax({
					type : 'POST',
					url : '${pageContext.request.contextPath}/terminal/delete',
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
function importTerminal() {
	var path = $("#excelfile").textbox("getValue");
	if (null == path || path == "") {
		$.messager.alert('<spring:message code="Prompt"/>',
				'<spring:message code="Choose_a_file"/>', 'warning');
		return false;
	}

	//根据文件导入
	$('#imfm').form('submit',
	{
		url : '${pageContext.request.contextPath}/terminal/importExcel',
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
function exportTerminal() {
	$('#exfm').form('submit');
}

function doSearch() {
	var terminalName=$('#terminalName').val();	
	var address=$('#address').val();
	//导出execl用
	$("#searchname").val(terminalName);
	$("#searchaddress").val(address);
	$('#dg').datagrid({
		url :'${pageContext.request.contextPath}/terminal/TerminalInf?Math.random()',
		queryParams: {
			terminalName :terminalName,
			address : address,		 	
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
			title : '终端名称',
			field : 'terminalName',
			width : '180px'
		}, {
			title : '终端地址',
			field : 'address',
			width : '200px',						
		}, {
			title : '安装位置',
			field : 'installationLocation',
			width : '200px'
		}, {
			title : '所属集中器',
			field : 'concentratorName',
			width : '120px'
		}, {
			title : '组织机构',
			field : 'organizationName',
			width : '120px'
		}, {
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
		}, {
			title : '所属表箱',
			field : 'measureName',
			width : '100px'
		}, {
			title : '终端型号',
			field : 'terminalType',
			width : '100px'
		}, {
			title : '软件版本号',
			field : 'softType',
			width : '100px'
		}, {
			title : '硬件版本号',
			field : 'hardType',
			width : '100px'
		}] ]
	   }) 
}



</script>
<script type="text/javascript">
var treeTab = $('#region_tree');
//公用树点击事件
var node;
function treeClick(treeObj, n){
	if(typeof n!='undefined' ){
		node=n;
		treeTab = treeObj;
		 $("#nodetype").val(node.type);
		 $("#nodegid").val(node.gid);
		searchCustomerFile();
	}
}

function searchCustomerFile() {
	$("#dg").datagrid('load', {
		id : node.gid,
    	type : node.type,
    	name : $('#terminalName').val(),
    	address : $('#address').val()
	});
}
</script>
</body>
</html>