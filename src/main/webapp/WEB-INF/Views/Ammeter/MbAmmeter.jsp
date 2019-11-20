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
.tableTr{
    display:block; /*将tr设置为块体元素*/
    margin:5px 0;  /*设置tr间距为2px*/
}
</style>
</head>
<body>
<!-- 布局 -->	
<div class="easyui-layout" style="width:100%;height:100%;overflow: hidden">
	<div id="west" region="west" iconCls="icon-organization" split="true" title="" style="width:280px;min-width:280px;overflow: hidden" collapsible="true">
		<jsp:include page="../CommonTree/concentratorTree.jsp"/>
	</div>
	
	<div data-options="region:'center',iconCls:'icon-ok'" title="">
		<!-- 列表 -->
		<table id="dg"  style="width: 100%;"
				toolbar="#toolbar"
				rownumbers="true" pagination="true"
				fitColumns="true" singleSelect="true"
				nowrap="true" fit="true">				
		</table>
		<!-- 列表-按钮 -->
		<div id="toolbar">
			<form id="imfm" class="easyui-form" method="post" enctype="multipart/form-data">
				<a href="#" class="easyui-linkbutton"  data-options="iconCls:'icon-add'"   onclick="addProductModel()"><spring:message code="Add"/></a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" onclick="editProductModel()"><spring:message code="Edit"/></a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="deleteProductModel()"><spring:message code="Delete"/></a>
				<select class="textbox combo" id="querySelect">
				   <option>电表名称</option>
				   <option>表号</option>
				</select>
				<input class="easyui-textbox" type="text" value="" id="queryInput" />
				 <a href="javascript:void(0)" class="easyui-linkbutton button-edit button-default" data-options="iconCls:'icon-search'" onclick="doSearch()" title="Search">检索</a>
					<a href="#" class="easyui-linkbutton" data-options="" onclick="issued()">下发</a>
				 <input class="easyui-filebox" style="width: 180px" id="excelfile" name="excelfile"
				data-options="prompt:'选择一个文件...', buttonText: '选择文件',buttonAlign:'left'"></input>
			    <a href="#" class="easyui-linkbutton"
				data-options="iconCls:'icon-import'" onclick="importAmmeter()">导入</a>
				<a href="#" class="easyui-linkbutton"
				data-options="iconCls:'icon-import'" onclick="exportAmmeterToExcel()">导出</a>
			</form>
    	</div>
	
<div id="dlg" class="easyui-dialog" style="width:700px;height:360px;padding:10px 20px" closed="true" buttons="#dlg-buttons">
	 <form id="fm" class="easyui-form" method="post" enctype="multipart/form-data">
	 	<input type="hidden" name="id" id="id"/>
            <table cellpadding="5" align="center">
            	<tr class="tableTr"> 
                    <td><input class="easyui-textbox" type="text" style="width:300px" id="ammeterName" name="ammeterName" data-options="label:'名称',required:true"></input></td>
                    <td><input class="easyui-textbox" type="text" style="width:300px" id="ammeterCode" name="ammeterCode" data-options="label:'表号',required:true"></input></td>
                </tr>
                  <tr class="tableTr"> 
                <td >
					<select class="easyui-combotree"
									url="${pageContext.request.contextPath}/organization/organizationTree?Math.random()"
									name="fatherOrgID" id="fatherOrgID" style="width: 300px;" data-options="label:'组织机构',required:true,
									onSelect: function(node) {
									  var url = '${pageContext.request.contextPath}/measureFile/getMeasurefileByOrganizationId?OrganizationId='+node.gid
								    	$('#measureIds').combobox('reload', url);
								    	$('#organizationCode').val(node.gid);
								    	$('#measureIds').combobox('setValue','');
								    	$('#concentratorIds').combobox('setValue','');
								    }">
					</select>
					<input type="hidden" name="organizationCode" id="organizationCode"/>		
				</td>
                  <td><select class="easyui-combobox"
									url="${pageContext.request.contextPath}/measureFile/getMeasurefileByOrganizationId?OrganizationId=0"
									 id="measureIds" style="width: 300px;" data-options="label:'所属表箱',required:true,
									 editable:false,valueField:'MeasureId', textField:'MeasureName',
									onSelect: function(node) {
									  var url = '${pageContext.request.contextPath}/mbAmmeter/getConcentratorByMeasurefile?measureId='+node.MeasureId
								    	$('#concentratorIds').combobox('reload', url);
								    	$('#boxCode').val(node.MeasureId);
								    	$('#concentratorIds').combobox('setValue','');
								    }">
								</select>
								<input type="hidden" name="boxCode" id="boxCode"/>
				  </td>		
                </tr>
                <tr class="tableTr"> 
                <td>
								<select class="easyui-combobox"
									url="${pageContext.request.contextPath}/mbAmmeter/getConcentratorByMeasurefile?measureId=0"
									 id="concentratorIds" style="width: 300px;" data-options="label:'所属集中器',required:true,
									 editable:false,valueField:'concentratorId', textField:'concentratorName',
									onSelect: function(node) {
								    	$('#concentratorId').val(node.concentratorId);
								    	$('#region').val(node.Region);
								    }">
								</select>
								<input type="hidden" name="concentratorCode" id="concentratorId"/>
							</td>
							<td><input class="easyui-textbox" type="text" style="width:300px" id="ammeterType" name="ammeterType" data-options="label:'电表型号'"></input></td>
                </tr>
                <tr class="tableTr"> 
                    <td><input class="easyui-textbox" type="text" style="width:300px" id="produce" name="produce" data-options="label:'生产厂家',required:true"></input></td>
                     <td><input class="easyui-numberbox" type="text" style="width:300px" id="installAddress" name="installAddress" data-options="label:'安装位置',required:true"></input></td>
                </tr>
                <tr class="tableTr"> 
                    <td><input class="easyui-datebox" type="text" style="width:300px" id="produceTime" name="produceTime" data-options="label:'生产日期',required:true"></input></td>
                    <td  style="display:none"><input class="easyui-textbox" type="text" style="width:300px" id="createPerson" name="createPerson" data-options="label:'创建人'"></input></td>
                </tr>
               <tr class="tableTr"> 
                    <td style="display:none"><input class="easyui-datebox" type="text" style="width:300px;" id="createTime" name="createTime" data-options="label:'创建时间'"></input></td>
                      </tr>
                <tr class="tableTr"> 
                    <td><input class="easyui-textbox" type="text" style="width:300px" id="softType" name="softType" data-options="label:'软件版本号'"></input></td>
                    <td><input class="easyui-textbox" type="text" style="width:300px" id="hardType" name="hardType" data-options="label:'硬件版本号'"></input></td>
                </tr>
             
            </table>
        </form>
</div>
<div id="dlg-buttons">
	<a href="#" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveProductModel()"><spring:message code="Save"/></a>
	<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')"><spring:message code="Cancel"/></a>
</div>
</div>
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

	$('#dg').datagrid({
	url :'${pageContext.request.contextPath}/mbAmmeter/getAllAmmeter',
	pagination : true,//分页控件
	pageList: [10, 20, 30, 40, 50],
	fit: true,   //自适应大小
	singleSelect: false,
	//iconCls : 'icon-save',
	border:false,
	nowrap: true,//数据长度超出列宽时将会自动截取。
	rownumbers:true,//行号
	fitColumns:true,//自动使列适应表格宽度以防止出现水平滚动。
	columns: [[ 
		{ field: 'ck', checkbox:true },
		{title: '下发状态', field: 'downstatus', width:'60px',
        	formatter:function(value, rowData, rowIndex){
        		if(value==1){
					return "已下发";
        		}else if(value==0)
        			return "<span style='color:red'>未下发</span>";
        		}
        },
			{title: 'id', field: 'id', width:'100px',hidden:true},
			{title: '电表名称', field: 'ammeterName', width:'100px'},
			{title: '表号', field: 'ammeterCode', width:'50px'},
			{title: '安装位置', field: 'installAddress', width:'120px'},
			{title: '所属集中器', field: 'concentratorName', width:'120px'},
	        {title: '组织机构', field: 'organizationName', width:'100px'},
	        {title: '生产厂家', field: 'produce', width:'100px'},
	        {title: '生产日期', field: 'produceTime', width:'60px'},
	        {title: '创建人', field: 'createPerson', width:'100px'},
	        {title: '创建时间', field: 'createTime', width:'200px'},
	        {title: '所属表箱', field: 'boxName', width:'100px'},
	        {title: '电表型号', field: 'ammeterType', width:'200px'},
	        {title: '软件版本号', field: 'softType', width:'100px'},
	        {title: '硬件版本号', field: 'hardType', width:'200px'}
	        ]],
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
	        	editProductModel(index);
	 		}
}); 	

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
        	var type=2;
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
       	if(selRow[i].communicationstatus==1){
       		id.push(selRow[i].id); //把单个id循环放到ids的数组中  
       	}
    }
 
    if(id.length==0 ){
   		$.messager.alert('提示','选择的设备不可全为不支持下发的设备','warning');
   		return false;
    }
    

    //下发到终端
    if(id.length!=0){
    	//电表
    	var type=2
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

var relation_id_sign = 0;
//查询
function doSearch() {
	var selectValue=$("#querySelect").val();
	var inputValue=$("#queryInput").val();
	var url="${pageContext.request.contextPath}/mbAmmeter/queryAmmeter";
	query(url,selectValue,inputValue);
}
//根据组织机构查询集中器
function getConcentratorByOrganization(){
	organizationCode=$('#fatherorganizationid').val();
}

function query(url,selectValue,inputValue){
	$('#dg').datagrid({
		url :url,
		queryParams: {selectValue:selectValue,inputValue:inputValue},
		pagination : true,//分页控件
		pageList: [10, 20, 30, 40, 50],
		fit: true,   //自适应大小
		singleSelect: false,
		//iconCls : 'icon-save',
		border:false,
		nowrap: true,//数据长度超出列宽时将会自动截取。
		rownumbers:true,//行号
		fitColumns:true,//自动使列适应表格宽度以防止出现水平滚动。
		columns: [[ 	{ field: 'ck', checkbox:true },
		{title: '下发状态', field: 'downstatus', width:'60px',
        	formatter:function(value, rowData, rowIndex){
        		if(value==1){
					return "已下发";
        		}else if(value==0)
        			return "<span style='color:red'>未下发</span>";
        		}
        },
				{title: 'id', field: 'id', width:'100px',hidden:true},
				{title: '电表名称', field: 'ammeterName', width:'100px'},
				{title: '表号', field: 'ammeterCode', width:'50px'},
				{title: '安装位置', field: 'installAddress', width:'120px'},
				{title: '所属集中器', field: 'concentratorName', width:'120px'},
		        {title: '组织机构', field: 'organizationName', width:'100px'},
		        {title: '生产厂家', field: 'produce', width:'100px'},
		        {title: '生产日期', field: 'produceTime', width:'60px'},
		        {title: '创建人', field: 'createPerson', width:'100px'},
		        {title: '创建时间', field: 'createTime', width:'200px'},
		        {title: '所属表箱', field: 'boxName', width:'100px'},
		        {title: '电表型号', field: 'ammeterType', width:'200px'},
		        {title: '软件版本号', field: 'softType', width:'100px'},
		        {title: '硬件版本号', field: 'hardType', width:'200px'}
		        ]],
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
		        	editProductModel(index);
		 		}
	});	
};


//导入
function importAmmeter() {
	var path = $("#excelfile").textbox("getValue");
	if (null == path || path == "") {
		$.messager.alert('提示',
				'请选择一个文件。', 'warning');
		return false;
	}

	//根据文件导入
	$('#imfm').form('submit',
	{
		url : '${pageContext.request.contextPath}/mbAmmeter/importExcel',
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
					'警告',
					data, 'error');
		}
	});
}
//导出excle
function exportAmmeterToExcel(){
	window.open("${pageContext.request.contextPath}/mbAmmeter/exportAmmeterToExcel");
}

function addProductModel(){
	/* $("#name").textbox("readonly",false);
	$("#equipmenttype").combobox("readonly",false);
	$("#communicationstatus").combobox("readonly",false);
	$("#manufacturer").combobox("readonly",false);
	$("#unify").combobox("readonly",false); */
	$('#fm').form('clear');
	$('#dlg').dialog('open').dialog('setTitle','添加电表');
	url = '${pageContext.request.contextPath}/mbAmmeter/addAmmeter';
}

//编辑菜单
function editProductModel(index){
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
		$('#fatherOrgID').combotree("setValue",{
			id:row.organizationName		
		});
		var organizationId=row.organizationCode;
		$('#measureIds').combobox('reload','${pageContext.request.contextPath}/measureFile/getMeasurefileByOrganizationId?OrganizationId='+organizationId);
		$('#measureIds').combobox("setValue",row.boxName);
		$('#concentratorIds').combobox("setValue",row.concentratorName);
		$('#dlg').dialog('open').dialog('setTitle','编辑型号');
		$('#fm').form('load',row);
		url = '${pageContext.request.contextPath}/mbAmmeter/editAmmeter?id='+row.id;
	}
}	
	
function saveProductModel(){
	$("#se").linkbutton('disable'); 
    setTimeout(function(){
    	$("#se").linkbutton('enable');
    },1000) //点击后相隔多长时间可执行
	$('#fm').form('submit',{
		url: url,
		onSubmit: function(){
			return $(this).form('validate');
		},
		success: function(result){		
			result=jQuery.parseJSON(result);
			   if(result.code==200){
					$('#dg').datagrid('reload');	// reload the user data
					$.messager.alert('提示',result.message,'info');
					$('#dlg').dialog('close')
					//parent.location.reload();
				}else if(result.code==400){
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

//删除设备
function deleteProductModel(){
	 var selRow = $("#dg").datagrid('getSelected');
     if (selRow.length == 0) {
    	 $.messager.alert('提示','请至少选择一行数据。','warning');
         return false;
     }
     $.messager.confirm('提示', '确认删除?', function(r) {
         if (r) {
        	 var searchid={"id":selRow.id};
             $.ajax({
            	 type:'POST', 
		         url:'${pageContext.request.contextPath}/mbAmmeter/deleteAmmeter',  
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
//删除设备
    var node;
	function treeClick(treeObj, n){
		console.log(n);
		var type=n.type;
		var gid=n.gid;
		$('#dg').datagrid({
			url: "${pageContext.request.contextPath}/mbAmmeter/queryAmmeterByTree",
			queryParams: {type:type,gid:gid,page:1,rows:10},
			pagination : true,//分页控件
			pageList: [10, 20, 30, 40, 50],
			fit: true,   //自适应大小
			singleSelect: false,
			//iconCls : 'icon-save',
			border:false,
			nowrap: true,//数据长度超出列宽时将会自动截取。
			rownumbers:true,//行号
			fitColumns:true,//自动使列适应表格宽度以防止出现水平滚动。
			columns: [[ 
				{ field: 'ck', checkbox:true },
				{title: '下发状态', field: 'DOWNSTATUS', width:'60px',
		        	formatter:function(value, rowData, rowIndex){
		        		if(value==1){
							return "已下发";
		        		}else if(value==0)
		        			return "<span style='color:red'>未下发</span>";
		        		}
		        },
					{title: 'id', field: 'id', width:'100px',hidden:true},
					{title: '电表名称', field: 'ammeterName', width:'100px'},
					{title: '表号', field: 'ammeterCode', width:'50px'},
					{title: '安装位置', field: 'installAddress', width:'120px'},
					{title: '所属集中器', field: 'concentratorName', width:'120px'},
			        {title: '组织机构', field: 'organizationName', width:'100px'},
			        {title: '生产厂家', field: 'produce', width:'100px'},
			        {title: '生产日期', field: 'produceTime', width:'60px'},
			        {title: '创建人', field: 'createPerson', width:'100px'},
			        {title: '创建时间', field: 'createTime', width:'200px'},
			        {title: '所属表箱', field: 'boxName', width:'100px'},
			        {title: '电表型号', field: 'ammeterType', width:'200px'},
			        {title: '软件版本号', field: 'softType', width:'100px'},
			        {title: '硬件版本号', field: 'hardType', width:'200px'}
			        ]],
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
			        	editProductModel(index);
			 		}
		});	
	}
</script>
</body>
</html>