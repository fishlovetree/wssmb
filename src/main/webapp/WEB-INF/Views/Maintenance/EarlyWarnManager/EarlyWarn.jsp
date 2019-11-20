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
<title>Insert title here</title>
<jsp:include page="../../Header.jsp"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/parseAlarm.js"></script>
<style type="text/css">
.table-data-table{
	font-size:12px; 
	table-layout:fixed; 
	empty-cells:show; 
	border-collapse: collapse; 
	margin:0 auto; 
	border:1px solid #cad9ea; 
    color:#666; 
    width:80%;
} 
.table-data-table th { 
	background-repeat:repeat-x; 
} 
.table-data-table td,.table-data-table th{ 
	border:1px solid #fb9d48; 
	padding:0 1em 0; 
	height:30px; 
} 
.echarts-dataview{
	background-color: rgb(248, 248, 248) !important;
}
.echarts-dataview button{
    background: #fb9d48;
    color: #fff;
}
.echarts-dataview p{
	padding: 8px 0 8px 15px !important;
    color: #fb9d48;
}

.layout-split-west {
    border-right: 1px solid #ccc;
}
.layout-split-north{
	border-bottom: 1px solid #ccc;
}

</style>
</head>
<body>
<!-- 公用 -->
<input type="hidden" id="selectedID" /> 
<input type="hidden" id="selectedType" /> 
<input type="hidden" id="selectedAddress" />

<div class="easyui-layout" data-options="fit:true">
	<div id="west" region="west" iconCls="icon-organization" split="true" title="" style="width:280px;min-width:280px;" collapsible="true">
		<jsp:include page="../../CommonTree/deviceTree.jsp"/>
	</div>
    <div id="index_center" class="banner" data-options="region:'center',border:false,split:false" >
		<div class="easyui-tabs " id="tab" style="width:100%;height:100%" data-options="tabPosition:'top'">
			<input type="hidden" id="selectedParentid" value="0" />
			<input type="hidden" id="selectedUpType" value="" />
		    <input type="hidden" id="selectedCommType" value="" />
        	<div title="告警处理"  id="0">
       			<table id="dg"  style="width: 100%;"></table>
        		<div id="toolbar">
        			<div style="display: inline-block;">
        				<label style="font-size:14px">设备地址:</label>
						<input id="alarmaddress" class="easyui-textbox" style="width:160px;height:26px;" data-options="
		                   prompt: '请输入地址……'"/>
        			</div>
        			<div style="display: inline-block;">
        				<label style="font-size:14px">设备名称:</label>
						<input id="alarmname" class="easyui-textbox" style="width:160px;height:26px;" data-options="
		                   prompt: '请输入名称……'"/>
        			</div>
        			<div style="display: inline-block;">
        				<label style="font-size:14px">告警类型:</label>
        				<select id="alarmtype" name="alarmtype"  class="easyui-combobox"  style="width:160px;height:26px;" 					
							data-options="method: 'get',
							url: '${pageContext.request.contextPath}/constant/getDetailList?Math.random()&coding='+1011,
							valueField: 'detailvalue',
							textField:'detailname',
							editable:true,
					        onLoadSuccess: function (data) {
					        	var value=$(this).combobox('getValue');
					            if (null == value|| value=='') {
					                $(this).combobox('setValue','');
					            }
					        }">
						</select>
        			</div>
				    <div style="display: inline-block;">
				        <label for="time">插入时间:</label>   
				        <input class="easyui-datetimebox" editable="fasle" style="width:165px;" type="text" id="starttime"  name="starttime" /> 
				        <label for="time">-</label>   
				        <input class="easyui-datetimebox" editable="fasle" style="width:165px;" type="text" id="endtime"  name="endtime" data-options="validType:'equaldDate[\'#starttime\']'"/> 
				    </div>
				    <div style="display: inline-block;">
        				<label style="font-size:14px">处理状态:</label>
					  <select class="easyui-combobox" name="type" id="type" style="width:110px;height:26px;" data-options="">
				        <option value="0" selected="selected">待处理告警</option>
				        <option value="1">已处理告警</option>
				        <option value="2">所有告警</option>
				      </select>
				    </div>
				    <div style="display: inline-block;">
        				<label style="font-size:14px">结束状态:</label>
					  <select class="easyui-combobox" name="end" id="end" style="width:110px;height:26px;" data-options="">
				        <option value="0" selected="selected">未结束告警</option>
				        <option value="1">已结束告警</option>
				        <option value="2">所有告警</option>
				      </select>
				    </div>
				    <a href="javascript:void(0)" class="easyui-linkbutton button-default" onclick="loadDataGrid()" >确定</a>
				</div>
        	</div>
        	<div title="故障排除"  id="1">
       			<table id="dgFault"  style="width: 100%;"></table>
        		<div id="toolbarFault">
        			<div style="display: inline-block;">
        				<label style="font-size:14px">设备地址:</label>
						<input id="faultaddress" class="easyui-textbox" style="width:160px;height:26px;" data-options="
		                   prompt: '请输入地址……'"/>
        			</div>
        			<div style="display: inline-block;">
        				<label style="font-size:14px">设备名称:</label>
						<input id="faultname" class="easyui-textbox" style="width:160px;height:26px;" data-options="
		                   prompt: '请输入名称……'"/>
        			</div>
        			<div style="display: inline-block;">
        				<label style="font-size:14px">故障类型:</label>
        				<select id="faulttype" name="faulttype"  class="easyui-combobox"  style="width:160px;height:26px;" 					
							data-options="method: 'get',
							url: '${pageContext.request.contextPath}/constant/getDetailList?Math.random()&coding='+1084,
							valueField: 'detailvalue',
							textField:'detailname',
							editable:true,
					        onLoadSuccess: function (data) {
					        	var value=$(this).combobox('getValue');
					            if (null == value|| value=='') {
					                $(this).combobox('setValue','');
					            }
					        }">
						</select>
        			</div>
					<div style="display: inline-block;">
					 <label style="font-size:14px">处理状态:</label>
					 <select class="easyui-combobox" name="typeFault" id="typeFault" style="width:110px;height:26px;" data-options="">
				        <option value="0" selected="selected">待处理故障</option>
				        <option value="1">已处理故障</option>
				        <option value="2">所有故障</option>
				      </select>
				    </div>
				    <div style="display: inline-block;">
				      <label for="time">插入时间:</label>   
				        <input class="easyui-datetimebox" editable="fasle" style="width:155px;" type="text" id="starttimeFault"  name="starttimeFault" /> 
				        <label for="time">-</label>   
				        <input class="easyui-datetimebox" editable="fasle" style="width:155px;" type="text" id="endtimeFault"  name="endtimeFault" data-options="validType:'equaldDate[\'#starttimeFault\']'"/> 
				    </div>
					<a href="javascript:void(0)" class="easyui-linkbutton button-default" onclick="loadFaultDataGrid()" >确定</a>
				</div>
        	</div>
        	<div title="消息列表"  id="2">
       			<table id="dgMessage"  style="width: 100%;"></table>
        		<div id="toolbarMessage">
					<div style="display: inline-block;">
        				<label style="font-size:14px">设备地址:</label>
						<input id="msgaddress" class="easyui-textbox" style="width:160px;height:26px;" data-options="
		                   prompt: '请输入地址……'"/>
        			</div>
        			<div style="display: inline-block;">
        				<label style="font-size:14px">设备名称:</label>
						<input id="msgname" class="easyui-textbox" style="width:160px;height:26px;" data-options="
		                   prompt: '请输入名称……'"/>
        			</div>
					<div style="display: inline-block;">
					 <label style="font-size:14px">消息类型:</label>
				      <select id="msgtypecode" name="msgtypecode"  class="easyui-combobox"  style="width:160px;height:26px;" 					
							data-options="method: 'get',
							url: '${pageContext.request.contextPath}/constant/getDetailList?Math.random()&coding='+1120,
							valueField: 'detailvalue',
							textField:'detailname',
							editable:true,
					        onLoadSuccess: function (data) {
					        	var value=$(this).combobox('getValue');
					            if (null == value|| value=='') {
					                $(this).combobox('setValue','');
					            }
					        }">
					 </select>
				    </div>
				    <div style="display: inline-block;">
				      <label for="time">发生时间:</label>   
				        <input class="easyui-datetimebox" editable="fasle" style="width:155px;" type="text" id="starttimeMessage"  name="starttimeMessage" /> 
				        <label for="time">-</label>   
				        <input class="easyui-datetimebox" editable="fasle" style="width:155px;" type="text" id="endtimeMessage"  name="endtimeMessage" data-options="validType:'equaldDate[\'#starttimeMessage\']'"/> 
				    </div>
					  <a href="javascript:void(0)" class="easyui-linkbutton button-default" onclick="loadMessageDataGrid()" >确定</a>
				</div>
        	</div>
        	<div title="短信通知日志"  id="3">
       			<table id="dgSmsRecord"  style="width: 100%;"></table>
        		<div id="toolbarSmsRecord">
					<div style="display: inline-block;">
        				<label style="font-size:14px">设备地址:</label>
						<input id="smsaddress" class="easyui-textbox" style="width:160px;height:26px;" data-options="
		                   prompt: '请输入地址……'"/>
        			</div>
        			<div style="display: inline-block;">
        				<label style="font-size:14px">设备名称:</label>
						<input id="smsname" class="easyui-textbox" style="width:160px;height:26px;" data-options="
		                   prompt: '请输入名称……'"/>
        			</div>
					<div style="display: inline-block;">
					 <label style="font-size:14px">事件类型:</label>
				      <select id="smsEventtype" name="smsEventtype"  class="easyui-combobox"  style="width:160px;height:26px;" 					
							data-options="method: 'get',
							url: '${pageContext.request.contextPath}/constant/getDetailList?Math.random()&coding='+1011,
							valueField: 'detailvalue',
							textField:'detailname',
							editable:true,
					        onLoadSuccess: function (data) {
					        	var value=$(this).combobox('getValue');
					            if (null == value|| value=='') {
					                $(this).combobox('setValue','');
					            }
					        }">
					 </select>
				    </div>
				    <div style="display: inline-block;">
					 <select class="easyui-combobox" name="smsEventresult" id="smsEventresult" style="width:100%;height:26px;" data-options="label:'结果:'">
				        <option value="0">失败</option>
				        <option value="1">成功</option>
				        <option value="" selected="selected">所有日志</option>
				      </select>
				    </div>
				    <div style="display: inline-block;">
				      <label for="time">发生时间:</label>   
				        <input class="easyui-datetimebox" editable="fasle" style="width:155px;" type="text" id="starttimeSmsRecord"  name="starttimeSmsRecord" /> 
				        <label for="time">-</label>   
				        <input class="easyui-datetimebox" editable="fasle" style="width:155px;" type="text" id="endtimeSmsRecord"  name="endtimeSmsRecord" data-options="validType:'equaldDate[\'#starttimeSmsRecord\']'"/> 
				    </div>
					  <a href="javascript:void(0)" class="easyui-linkbutton button-default" onclick="loadSmsRecordDataGrid()" >确定</a>
				</div>
        	</div>
        	<div title="语音通知日志"  id="4">
       			<table id="dgSoundRecord"  style="width: 100%;"></table>
        			<div id="toolbarSoundRecord">
					<div style="display: inline-block;">
        				<label style="font-size:14px">设备地址:</label>
						<input id="soundaddress" class="easyui-textbox" style="width:160px;height:26px;" data-options="
		                   prompt: '请输入地址……'"/>
        			</div>
        			<div style="display: inline-block;">
        				<label style="font-size:14px">设备名称:</label>
						<input id="soundname" class="easyui-textbox" style="width:160px;height:26px;" data-options="
		                   prompt: '请输入名称……'"/>
        			</div>
					<div style="display: inline-block;">
					 <label style="font-size:14px">事件类型:</label>
				      <select id="soundEventtype" name="soundEventtype"  class="easyui-combobox"  style="width:160px;height:26px;" 					
							data-options="method: 'get',
							url: '${pageContext.request.contextPath}/constant/getDetailList?Math.random()&coding='+1011,
							valueField: 'detailvalue',
							textField:'detailname',
							editable:true,
					        onLoadSuccess: function (data) {
					        	var value=$(this).combobox('getValue');
					            if (null == value|| value=='') {
					                $(this).combobox('setValue','');
					            }
					        }">
					 </select>
				    </div>
				    <div style="display: inline-block;">
				    <label style="font-size:14px">结果:</label>
					 <select class="easyui-combobox" name="soundEventresult" id="soundEventresult" style="width:160px;height:26px;" data-options="">
				        <option value="0">异常</option>
				        <option value="1">正常接听</option>
				        <option value="2">未接</option>
				        <option value="3">拒接</option>
				        <option value="4">拒接或未接或接听时间太短</option>
				        <option value="5">忙音</option>
				        <option value="6">设备异常</option>
				        <option value="7">异常2</option>
				        <option value="" selected="selected">所有日志</option>
				      </select>
				    </div>
				    <div style="display: inline-block;">
				      <label for="time">发生时间:</label>   
				        <input class="easyui-datetimebox" editable="fasle" style="width:155px;" type="text" id="starttimeSoundRecord"  name="starttimeSoundRecord" /> 
				        <label for="time">-</label>   
				        <input class="easyui-datetimebox" editable="fasle" style="width:155px;" type="text" id="endtimeSoundRecord"  name="endtimeSoundRecord" data-options="validType:'equaldDate[\'#starttimeSoundRecord\']'"/> 
				    </div>
					  <a href="javascript:void(0)" class="easyui-linkbutton button-default" onclick="loadSoundRecordDataGrid()" >确定</a>
				</div>
        	</div>
		</div>	
    </div>    
</div>

<div id="dlg" class="easyui-dialog" style="width:330px;height:370px;padding:10px 20px;" closed="true" buttons="#dlg-buttons" data-options="modal:true">
	 <form id="fm" class="easyui-form" method="post" enctype="multipart/form-data">
             <table cellpadding="5" align="center">
                <tr class="tableTr">                 
                    <td ><input class="easyui-datetimebox processtime1" editable="fasle" name="processtime" style="width:100%;" data-options="label:'处理时间',required:true,formatter:myformatter,parser:myparser"></td>
                </tr>             
                <tr class="tableTr">
                    <td>
                    	<select id="processmethod" name="processmethod"  class="easyui-combobox processmethod1" style="width:200px;" 					
							data-options="">
						 </select>
					</td>
                </tr>
                <tr class="tableTr">
                   <td>
                		 <input class="easyui-filebox"  style="width:100%" name="myAnnex" data-options="label:'上传附件',buttonText: '选择文件'," />
                	</td>
                </tr>
                <tr class="tableTr">
                   <td><input class="easyui-textbox" type="text" style="width:240px;height:100px;" name="processremarks" multiline="true" data-options="label:'备注'"></input></td>
                </tr>
            </table>
        </form>
</div>
<div id="dlg-buttons">
	<a href="#" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveEarly()"><spring:message code="Save"/></a>
	<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')"><spring:message code="Cancel"/></a>
</div>
<div id="w" class="easyui-window" closed="true" style="width:380px;height:250px;padding:10px;" data-options="modal:true">
	<div id="dataDetail" align="center">
	</div>
</div>

<div id="dlgFault" class="easyui-dialog" style="width:330px;height:320px;padding:10px 20px;" closed="true" buttons="#dlgFault-buttons" data-options="modal:true">
	 <form id="fmFault" class="easyui-form" method="post" enctype="multipart/form-data">
             <table cellpadding="5" align="center">
                <tr class="tableTr">                 
                    <td ><input class="easyui-datetimebox processtime2" editable="fasle" name="processtime" style="width:100%;" data-options="label:'处理时间',required:true,formatter:myformatter,parser:myparser"></td>
                </tr>             
                <tr class="tableTr">
                    <td>
                    	<select id="processmethod" name="processmethod"  class="easyui-combobox processmethod2" style="width:200px;" 					
							data-options="">
						 </select>
					</td>
                </tr>
                <tr class="tableTr">
                   <td><input class="easyui-textbox" type="text" style="width:240px;height:100px;" name="processremarks" multiline="true" data-options="label:'备注'"></input></td>
                </tr>
            </table>
        </form>
</div>
<div id="dlgFault-buttons">
	<a href="#" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveFault()"><spring:message code="Save"/></a>
	<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgFault').dialog('close')"><spring:message code="Cancel"/></a>
</div>

</body>
<script type="text/javascript">
var processmethod1,processmethod2;
var tabId=0;
var node;
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

	//tab点击事件
	$('#tab').tabs({
	    border:false,
	    onSelect:function(title,index){
	    	tabId = index; // 相应的标签页id,对应控制类型
	    	switch(tabId){
	    	case 0:
	    		loadDataGrid();
	    		break;
	    	case 1:
	    		loadFaultDataGrid();
	    		break;
	    	case 2:
	    		loadMessageDataGrid();
	    		break;
	    	case 3:
	    		loadSmsRecordDataGrid();
	    		break;
	    	case 4:
	    		loadSoundRecordDataGrid();
	    		break;
	    	}
	    },
	});

	$(".processmethod1").combobox({
		label:'处理方法',required:true,method: 'get',
		url: '${pageContext.request.contextPath}/constant/getDetailList?Math.random()&coding='+1141,
		valueField: 'detailvalue',
		textField:'detailname',
		editable:false,
		multiple:true,
        onLoadSuccess: function (data) {
        	var value=$(this).combobox('getValue');
            if (null == value|| value=='') {
                $(this).combobox('setValue','');
            }
            processmethod1=$(".processmethod1").combobox('getData');
        }
	});	

	$(".processmethod2").combobox({
		label:'处理方法',required:true,method: 'get',
		url: '${pageContext.request.contextPath}/constant/getDetailList?Math.random()&coding='+1142,
		valueField: 'detailvalue',
		textField:'detailname',
		editable:false,
		multiple:true,
	    onLoadSuccess: function (data) {
	    	var value=$(this).combobox('getValue');
	        if (null == value|| value=='') {
	            $(this).combobox('setValue','');
	        }
	        processmethod2=$(".processmethod2").combobox('getData');
	    }
	}); 
	 
	var thisMonth = new Date().getUTCMonth()+1;//本月
	var thisYear = new Date().getUTCFullYear();//今年
	var thisDay = new Date().getDate();//今日
	var endDay = new Date().getDate()+1;//明日
	var start = thisYear+'-'+thisMonth+'-'+thisDay+' 00:00:00';
	var end = thisYear+'-'+thisMonth+'-'+endDay+' 00:00:00';
	$('#starttime').datetimebox('setValue', start);//告警列表
	$('#endtime').datetimebox('setValue', end);	 
	$('#starttimeFault').datetimebox('setValue', start);//故障列表
	$('#endtimeFault').datetimebox('setValue', end);	 
	$('#starttimeMessage').datetimebox('setValue', start);//消息列表
	$('#endtimeMessage').datetimebox('setValue', end);	 
	$('#starttimeSmsRecord').datetimebox('setValue', start);//短信通知日志
	$('#endtimeSmsRecord').datetimebox('setValue', end);	
	$('#starttimeSoundRecord').datetimebox('setValue', start);//语音通知日志
	$('#endtimeSoundRecord').datetimebox('setValue', end);	

	loadDataGrid();
});

var treeTab = $('#region_tree');
//公用树点击事件
function treeClick(treeObj, n){
	if(typeof n!='undefined' ){
		node = n;
		treeTab = treeObj;
		$("#selectedID").val(node.gid);
	    $("#selectedType").val(node.type);
	    $("#selectedAddress").val(node.name);
		clickNode();
	}
}

function clickNode(){
	if(null==node || node=="")
		if(null!=treeTab.tree('getSelected'))
			node=treeTab.tree('getSelected');
		else{
			$.messager.alert('提示',"请选择树节点！",'info');
			return;
		}

    $("#selectedParentid").val(0);
    $("#selectedUpType").val("");
    $("#selectedCommType").val("");
    
	switch (node.type){//消防监测终端
	case commonTreeNodeType.terminalBigType:
    	var pnode = treeTab.tree('getParent', node.target);
        $("#selectedParentid").val(pnode.gid);//customerid
        $("#selectedUpType").val("1");
    	break;
    case commonTreeNodeType.gprsBigType:
    	var pnode = treeTab.tree('getParent', node.target);
        $("#selectedParentid").val(pnode.gid);//customerid
        $("#selectedUpType").val("0");
	    $("#selectedCommType").val("3");
    	break;
    case commonTreeNodeType.nbBigType:
    	var pnode = treeTab.tree('getParent', node.target);
        $("#selectedParentid").val(pnode.gid);//customerid
        $("#selectedUpType").val("0");
	    $("#selectedCommType").val("4");
    	break;
    }

	switch(tabId){
	case 0:
		loadDataGrid();
		break;
	case 1:
		loadFaultDataGrid();
		break;
	case 2:
		loadMessageDataGrid();
		break;
	case 3:
		loadSmsRecordDataGrid();
		break;
	case 4:
		loadSoundRecordDataGrid();
		break;
	}

}

/* 告警列表 */
//提交按钮
//提交按钮
function Button(value,row,index){
	var result = "";
	if(row.status==0) 
		result += "<a href='#' class='button-view  button-default' onclick='editEarly(&apos;" + index+ "&apos;);'><spring:message code='deal'/></a> ";  
	if(typeof row.endtime=='undefined' || null==row.endtime || row.endtime=="")
		result += "<a href='#' class='button-view  button-default' onclick='endEarly(&apos;" + row.id+ "&apos;);'>结束告警</a> ";  
	return result;
}  

//编辑菜单
function editEarly(rowIndex){
	$('#fm').form('clear');
	var rows = $('#dg').datagrid('getRows');
	var row = rows[rowIndex];
	if (row){
		if(row.status==0){
			$('#dlg').dialog('open').dialog('setTitle','告警处理');
			//$('#fm').form('load',row);
			$('.processtime1').datetimebox('setValue', myformatter(new Date()));
			url = '${pageContext.request.contextPath}/frontEarlyWarn/processEarlyList?id='+row.id;
		}else{
			 $.messager.alert('<spring:message code="Prompt"/>',"该告警已经处理。",'warning')
		}	
	}
}	

//结束告警
function endEarly(id){
	$.messager.confirm('结束告警','确定要结束当前告警吗？',function(r){
		if (r){
			$.ajax({
	            type: "post",
	            url: '${pageContext.request.contextPath}/endEarlyWarning?Math.random()',
	            data: {id: id},
	            async : true,
				success: function(d) {
					if (d == "success"){
						$("#dg").data().datagrid.cache = null; 
						$('#dg').datagrid('reload');	// reload the user data		
						$.messager.alert("提示", "结束告警成功。", "info");
					}
					else{
						$.messager.alert("警告", "结束告警失败。", "error");
					}
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) {
					$.messager.alert("警告", "结束告警方法错误。("+XMLHttpRequest.status+","+XMLHttpRequest.readyState+","+textStatus+")", "error");
				}
			});
		}
	});
}

//保存
function saveEarly(){
$('#fm').form('submit',{
	url: url,
	onSubmit: function(){
		var flag = $(this).form('validate');
		if(false==flag) $.messager.alert('<spring:message code="Warning"/>',"处理方式必选！",'error');
		return flag;
	},
	success: function(result){	
		if(result=="success"){
			$('#dlg').dialog('close');		// close the dialog
			$("#dg").data().datagrid.cache = null; 
			$('#dg').datagrid('reload');	// reload the user data			
			$.messager.alert('<spring:message code="Prompt"/>','<spring:message code="SuccessOperation"/>','info');
		}else{
			$.messager.alert('<spring:message code="Warning"/>',result,'error');
		}
	
	},
	  error:function(data){
		  $.messager.alert('<spring:message code="Warning"/>',data,'error');	        	
    }
});
} 

//重载告警列表
function loadDataGrid(){	

	console.time('名称X');
	var startTime = $("#starttime").datebox("getValue");  
	var endTime = $("#endtime").datebox("getValue"); 
	if(null!=startTime && startTime!="" && null!=endTime && endTime!=""){
		if(endTime<startTime) {
			$.messager.alert('提示', '发生结束日期应大于等于开始日期。', 'warning');
			return;
		}
	}	
	var status=$('#type').combobox('getValue');
	var end =$('#end').combobox('getValue');
	var alarmaddress =$('#alarmaddress').val();
	var alarmname =$('#alarmname').val();
	var alarmtype =$('#alarmtype').combobox('getValue');
	var queryParams = {};
	if (null!=node && typeof(node) != "undefined"){
		queryParams = {
			id : node.gid,
			type : node.type,
			nodeName : node.name,
			parentid : $("#selectedParentid").val(),
	    	uptype : $("#selectedUpType").val(),
	    	commtype : $("#selectedCommType").val(),
		 	status:status,
		 	end:end,
		 	startTime :startTime,
			endTime : endTime,
			address : alarmaddress,
			name : alarmname,
			alarmtype : alarmtype
		};
	}else
		queryParams = {
		 	status:status,
		 	end:end,
		 	startTime :startTime,
			endTime : endTime,
			address : alarmaddress,
			name : alarmname,
			alarmtype : alarmtype
		};
	
	setFirstPage($("#dg"));
	$('#dg').datagrid({
		queryParams: queryParams,
		pagination : true,//分页控件
		pageList: [10, 20, 30, 40, 50],
		//title:"操作日志",
		fit: true,   //自适应大小
		singleSelect: true,
		border:false,
		nowrap: true,//数据长度超出列宽时将会自动截取。
		rownumbers:true,//行号
		fitColumns:true,//自动使列适应表格宽度以防止出现水平滚动。
		toolbar:'#toolbar',
		url:'${pageContext.request.contextPath}/earlyWarn/earlyList',
		columns: [[  
			{title: '操作', field: 'id', width:'160px',formatter:Button,},
			{title: '设备名称', field: 'equipmentname', width: '150px'},
			{title: '设备地址', field: 'equipmentaddress', width: '150px'},
			{title: '报警类型', field: 'alarmName', width: '110px'}, 
			{title: '发生时间(设备)', field: 'occurtime', width: '180px',sortable:true}, 
			{title: '设备数据', field: 'occurdata', width: '100px',
				formatter:function(value,rowData,rowIndex){
					if(null!=rowData.id && rowData.id!=""){
						var id=rowData.id;	//告警表id
						var dataType=1; //数据类型：1-开始数据
						return "<a href='#' class='easyui-linkbutton button-default button-view' onclick='queryData(&apos;" + id +"&apos;"+","+"&apos;"+dataType+"&apos;"+","+"&apos;"+rowData.alarmtype+"&apos;);'>查看详情</a>";
					}
            	}
			},
			{title: '结束时间(设备)', field: 'endtime', width: '180px'}, 
			{title: '结束数据', field: 'enddata', width: '100px',
				formatter:function(value,rowData,rowIndex){
					if(null!=rowData.id && rowData.id!=""){
						var id=rowData.id;	//告警表id
						var dataType=2; //数据类型：2-结束数据
						if(null!=rowData.endtime && rowData.endtime!="")
							return "<a href='#' class='easyui-linkbutton button-default button-view' onclick='queryData(&apos;" + id +"&apos;"+","+"&apos;"+dataType+"&apos;"+","+"&apos;"+rowData.alarmtype+"&apos;);'>查看详情</a>";
						else
							return "";
					}
				}
            }, 
            {title: '结束方式', field: 'endmethod', width: '100px',
				formatter:function(value,rowData,rowIndex){
					if(null!=rowData.endtime && rowData.endtime!=""){
						if(value==1)
							return "<span style='color:#8a8a8a'>自动结束</span>";
						else{
							if(null!=rowData.processtime && rowData.processtime!="")
								return "<span style='color:#4caf50'>手动结束</span>"; 
							else
								return "<span style='color:#d4941f'>手动结束</span>"; 
						}
					}
					else
						return "<span style='color:#ca1d1d'>未结束</span>"; 
            	}
			},
            {title: '用户名称', field: 'customername', width: '180px'},
			{title: '用户编号', field: 'customerCode', width: '120px'},  
            {title: '系统地址', field: 'systemAddress', width: '80px'}, 
            {title: '单元地址', field: 'unitaddress', width: '100px'}, 
			{title: '安装地址', field: 'installationsite', width: '150px'},        						 				
			{title: '累计次数', field: 'cumulativenum', width: '100px'}, 				
			{title: '处理人', field: 'handlepeople', width: '100px'}, 
			{title: '处理时间', field: 'processtime', width: '180px'}, 
			{title: '处理方法', field: 'processmethod', width: '100px',
	        	formatter:function(value, rowData, rowIndex){
	        		var method="";
	        		if(null!=value && value!=""){
	        			var temp=value.split(',');
	        			for(var i=0;i<temp.length;i++){
	        				for(var j=0;j<processmethod1.length;j++)
	        					if(temp[i]==processmethod1[j].detailvalue)
	        						method += processmethod1[j].detailname+",";
	        			}
	        		}
	        		return method=="" ? "" : method.substring(0,method.length-1);
	        	}
	        }, 
			{title: '附件', field: 'annex', width: '100px',
				formatter:function(value,rowData,rowIndex){
					if(rowData.status==1 && null!=rowData.annexname
							&& rowData.annexname!=""){
						var id=rowData.id;	
						var name=rowData.annexname;
						return "<a href='${pageContext.request.contextPath}/earlyWarn/downLoadAnnex?id=" + id+ "'>"+name+"</a>";
					}
            	}
			},  
	        {title: '处理备注', field: 'processremarks', width: '150px'},
	        {title: '插入时间', field: 'insertiontime', width: '180px'}, 
		]],
	 	onDblClickCell: function(index,field,value){
			editEarly(index);
		}, 
		onLoadSuccess:function(){

			$('.button-view').linkbutton({ 
			});
			
			$('.text').textbox({
				width:70,
				height:30
			})

		},		

	});
	

	console.timeEnd('名称x');
}

//查询告警数据详情--实时监控页
function queryData(alarmId,dataType,alarmType){
	//清空表格
	$('#dataDetail').empty();
	var mData={"alarmId":alarmId,"dataType":dataType,"alarmType":alarmType}; 
	$.ajax({
		type:'POST', 
        url:'${pageContext.request.contextPath}/earlyWarn/earlyDataDetail',           
        data:mData,        
	       success:function(data){ 
	    	   var title;
	    		if(dataType == 1) title = "发生数据详情";
	    		else if(dataType == 2) title = "结束数据详情";
	    		var eventArray = getEventName(alarmType);
	    		var html = '';
	    		var height = "60px";
	    		if(data.length > 0){
	    			html='<table cellpadding="5" align="center">';
	    		    if(data.length > 7)
	    			    height = "320px";
	    		    else
	    			    height = 53*data.length+"px";
	    		    var numberName="";
	    	  	    for (var i = 0; i < data.length; i++) {  
	    			    numberName = getNumberName(data[i].itemnumber,alarmType); 
	    			    var evenName="";//项名称
	    			    var mEventData="";//数据值和单位
	    			    if(alarmType >= 1 && alarmType < 60 ){
	    				    if(alarmType == 23 || alarmType == 24){
	    					    evenName = eventArray[0] + numberName;//项名称
		    				    mEventData = getEventData(alarmType,data[i].itemnumber,FormatValue(data[i].eventdata), eventArray); 
	    				    }else{
	    					    evenName = numberName + eventArray[0];//项名称
	    					    if(null != data[i].eventdata)
	    						    mEventData = data[i].eventdata + eventArray[1];
	    		  			    else
	    		  				    mEventData = "无数据";
	    				    }	
	    			    }
	    			    else if (alarmType >= 520 && alarmType <= 600){ //用传告警
	    			    	var evenName = getNumberName(data[i].itemnumber, alarmType);
   	  			    	if(null != data[i].eventdata)
   						    mEventData = data[i].eventdata;
   		  			    else
   		  				    mEventData = "无数据";
	    	  			}
	    			    else {
	    				    evenName = eventArray[0] + numberName;//项名称
	    				    mEventData = getEventData(alarmType,data[i].itemnumber,FormatValue(data[i].eventdata), eventArray); 
	    			    } 
		    			if(alarmType != 92 || data[i].itemnumber != 2){//屏蔽燃气告警的电池电压数据
		    		   		var trTd = '<tr class="tableTr"> '
		    			 	    +'<td ><input class="easyui-textbox" readonly="true" value="'+mEventData +'" style="width:240px;" data-options="label:\''+evenName+'\'" ></td>'
		    			 	    +'</tr>';
		    			 	html = html + trTd;
		    			}
	    			}  
	    	  	    html=html+'</table>';
	    		}
	    		if(null==html || html=="") html="<p style='color: gold;font-size: 16px;margin-top:10px'>暂无数据<p>";
	    	    $("#dataDetail").append(html);
	    	    $.parser.parse( $('#w')); 
	    	    document.getElementById("w").style.height= height;
	    	    $('#w').window('open').dialog('setTitle',title);

	        },	        
	        error:function(data){
	        	$.messager.alert('<spring:message code="Warning"/>',"获取失败。",'error');
       	}
	});	
}
/* 告警列表 */

/* 设备故障列表 */
//提交按钮
 function faultButton(value,row,index){
	  if(row.status==0) return "<a href='#' class='button-view  button-default' onclick='editFault(&apos;" + index+ "&apos;);'><spring:message code='deal'/></a> ";  
	  else return "<p style='color:#4caf50'>已处理<p>";  
}  
//加载分页数据
 function faultLoader(param, success, error) {  
    var that = $(this);  
    var opts = that.datagrid("options");  
    if (!opts.url) {  
        return false;  
    }  
  
    var cache = that.data().datagrid.cache;  
    if (!cache) {  
        $.ajax({  
            type: opts.method,  
            url: opts.url,  
            data: param,  
            dataType: "json",  
            success: function (data) {  
                that.data().datagrid['cache'] = data;  
                success(bulidFaultData(data));  
            },  
            error: function () {  
                error.apply(this, arguments);  
            	$.messager.alert('<spring:message code="Warning"/>',"获取故障失败。",'error');
            }  
        });  
    } else {  
        success(bulidFaultData(cache));  
    }  
  
    function bulidFaultData(data) {  
       // debugger;  
        var temp = $.extend({}, data);  
        var tempRows = [];  
        var start = (param.page - 1) * parseInt(param.rows);  
        var end = start + parseInt(param.rows);  
        var rows = data.rows;  
        for (var i = start; i < end; i++) {  
            if (rows[i]) {  		            	
                tempRows.push(rows[i]);  
            } else {  
                break;  
            }  
        }  
  
        temp.rows = tempRows;  
        return temp;  
    }  
} 

//编辑菜单
function editFault(rowIndex){
	$('#fmFault').form('clear');
	var rows = $('#dgFault').datagrid('getRows');
	var row = rows[rowIndex];
	if (row){
		if(row.status==0){
			$('#dlgFault').dialog('open').dialog('setTitle','故障处理');
			//$('#fmFault').form('load',row);
			$('.processtime2').datetimebox('setValue', myformatter(new Date()));
			url = '${pageContext.request.contextPath}/frontFault/processFaultList?id='+row.id;
		}else{
			 $.messager.alert('<spring:message code="Prompt"/>',"该故障已经处理。",'warning')
		}	
	}
}	

//保存
function saveFault(){
$('#fmFault').form('submit',{
	url: url,
	onSubmit: function(){
		var flag = $(this).form('validate');
		if(false==flag) $.messager.alert('<spring:message code="Warning"/>',"处理方式必选！",'error');
		return flag;
	},
	success: function(result){	
		if(result=="success"){
			$('#dlgFault').dialog('close');		// close the dialog
			$("#dgFault").data().datagrid.cache = null; 
			$('#dgFault').datagrid('reload');	// reload the user data			
			$.messager.alert('<spring:message code="Prompt"/>','<spring:message code="SuccessOperation"/>','info');
		}else{
			$.messager.alert('<spring:message code="Warning"/>',result,'error');
		}
	
	},
	  error:function(data){
		  $.messager.alert('<spring:message code="Warning"/>',data,'error');	        	
    }
});
} 

//重载故障列表
function loadFaultDataGrid(){
	var startTime = $("#starttimeFault").datebox("getValue");  
	var endTime = $("#endtimeFault").datebox("getValue"); 
	if(null!=startTime && startTime!="" && null!=endTime && endTime!=""){
		if(endTime<startTime) {
			$.messager.alert('提示', '发生结束日期应大于等于开始日期。', 'warning');
			return;
		}
	}		
	var status=$('#typeFault').combobox('getValue');

	var faultaddress =$('#faultaddress').val();
	var faultname =$('#faultname').val();
	var faulttype =$('#faulttype').combobox('getValue'); 
	var queryParams = {};
	if (null!=node && typeof(node) != "undefined")
		queryParams = {
			id : node.gid,
			type : node.type,
			nodeName : node.name,
			parentid : $("#selectedParentid").val(),
	    	uptype : $("#selectedUpType").val(),
	    	commtype : $("#selectedCommType").val(),
		 	status:status,
		 	startTime :startTime,
			endTime : endTime,
			address : faultaddress,
			name : faultname,
			faulttype : faulttype
		};
	else 
		queryParams = {
		 	status:status,
		 	startTime :startTime,
			endTime : endTime,
			address : faultaddress,
			name : faultname,
			faulttype : faulttype
		};
	
	//故障排除
	setFirstPage($("#dgFault"));
	$('#dgFault').datagrid({
		queryParams: queryParams,
		pagination : true,//分页控件
		pageList: [10, 20, 30, 40, 50],
		//title:"操作日志",
		fit: true,   //自适应大小
		singleSelect: true,
		border:false,
		nowrap: true,//数据长度超出列宽时将会自动截取。
		rownumbers:true,//行号
		fitColumns:true,//自动使列适应表格宽度以防止出现水平滚动。
		toolbar:'#toolbarFault',
		url:'${pageContext.request.contextPath}/fault/faultList',
		columns: [[  
			{title: '操作', field: 'id', width:'100px',formatter:faultButton,},
			{title: '设备名称', field: 'equipmentname', width: '150px'},
			{title: '设备地址', field: 'equipmentaddress', width: '150px'},
			{title: '故障类型', field: 'faultname', width: '140px'}, 
			{title: '发生时间(设备)', field: 'occurtime', width: '180px',sortable:true}, 
			{title: '结束时间(设备)', field: 'endtime', width: '180px'}, 
            {title: '用户名称', field: 'customername', width: '180px'},
			{title: '用户编号', field: 'customerCode', width: '120px'},  
            {title: '系统地址', field: 'systemAddress', width: '80px'}, 
            {title: '单元地址', field: 'unitaddress', width: '100px'}, 
			{title: '安装地址', field: 'installationsite', width: '150px'},        						 				
			{title: '累计次数', field: 'cumulativenum', width: '100px'}, 	
			{title: '备注', field: 'remarks', width: '150px'}, 
			{title: '处理人', field: 'handlepeople', width: '100px'}, 
			{title: '处理时间', field: 'processtime', width: '180px'}, 
			{title: '处理方法', field: 'processmethod', width: '100px',
	        	formatter:function(value, rowData, rowIndex){
	        		var method="";
	        		if(null!=value && value!=""){
	        			var temp=value.split(',');
	        			for(var i=0;i<temp.length;i++){
	        				for(var j=0;j<processmethod2.length;j++)
	        					if(temp[i]==processmethod2[j].detailvalue)
	        						method += processmethod2[j].detailname+",";
	        			}
	        		}
	        		return method=="" ? "" : method.substring(0,method.length-1);
	        	}
	        }, 
	        {title: '处理备注', field: 'processremarks', width: '150px'},
	        {title: '插入时间', field: 'inserttime', width: '180px'}, 
		]],
	 	onDblClickCell: function(index,field,value){
			editFault(index);
		}, 
		onLoadSuccess:function(){

			$('.button-view').linkbutton({ 
			});
			
			$('.text').textbox({
				width:70,
				height:30
			})

		},		

	});	
}
/* 设备故障列表 */

/* 消息列表列表 */
function loadMessageDataGrid(){	
	var startTime = $("#starttimeMessage").datebox("getValue");  
	var endTime = $("#endtimeMessage").datebox("getValue"); 
	if(null!=startTime && startTime!="" && null!=endTime && endTime!=""){
		if(endTime<startTime) {
			$.messager.alert('提示', '发生结束日期应大于等于开始日期。', 'warning');
			return;
		}
	}	
	var msgtypecode=$('#msgtypecode').combobox('getValue');	
	
	var msgaddress =$('#msgaddress').val();
	var msgname =$('#msgname').val();
	var queryParams = {};
	
	if (null!=node && typeof(node) != "undefined")
		queryParams = {
			id : node.gid,
			type : node.type,
			nodeName : node.name,
			parentid : $("#selectedParentid").val(),
	    	uptype : $("#selectedUpType").val(),
	    	commtype : $("#selectedCommType").val(),
		 	msgtypecode:msgtypecode,
		 	startTime :startTime,
			endTime : endTime,
			address : msgaddress,
			name : msgname
		};
	else
		queryParams = {
		 	msgtypecode:msgtypecode,
		 	startTime :startTime,
			endTime : endTime,
			address : msgaddress,
			name : msgname
		};
	
	setFirstPage($("#dgMessage"));
	$('#dgMessage').datagrid({
		queryParams: queryParams,
		pagination : true,//分页控件
		pageList: [10, 20, 30, 40, 50],
		//title:"操作日志",
		fit: true,   //自适应大小
		singleSelect: true,
		border:false,
		nowrap: true,//数据长度超出列宽时将会自动截取。
		rownumbers:true,//行号
		fitColumns:true,//自动使列适应表格宽度以防止出现水平滚动。
		toolbar:'#toolbarMessage',
		url:'${pageContext.request.contextPath}/message/messageList',
		columns: [[  
			{title: '设备名称', field: 'equipmentname', width: '150px'},
			{title: '设备地址', field: 'equipmentaddress', width: '150px'},
			{title: '消息类型', field: 'messagename', width: '140px'}, 
			{title: '发生时间(设备)', field: 'occurtime', width: '180px',sortable:true}, 
			{title: '下限阀值', field: 'lowervalue', width: '100px'}, 
			{title: '延时时间', field: 'delaytime', width: '150px'}, 
			{title: '更新前参数', field: 'befupdatenum', width: '180px'}, 
			{title: '更新后参数', field: 'aftupdatenum', width: '180px'}, 
            {title: '用户名称', field: 'customername', width: '150px'},
			{title: '用户编号', field: 'customercode', width: '120px'},  
            {title: '系统地址', field: 'systemaddress', width: '80px'}, 
            {title: '单元地址', field: 'unitaddress', width: '100px'}, 
			{title: '安装地址', field: 'installationsite', width: '150px'},        						 				
			{title: '累计次数', field: 'cumulativenum', width: '100px'} 
		]],
		onLoadSuccess:function(){

			$('.button-view').linkbutton({ 
			});
			
			$('.text').textbox({
				width:70,
				height:30
			})

		},		

	});	
}
/* 消息列表列表 */

 /* 短信通知日志列表 */
function loadSmsRecordDataGrid(){	
	var startTime = $("#starttimeSmsRecord").datebox("getValue");  
	var endTime = $("#endtimeSmsRecord").datebox("getValue"); 
	if(null!=startTime && startTime!="" && null!=endTime && endTime!=""){
		if(endTime<startTime) {
			$.messager.alert('提示', '发生结束日期应大于等于开始日期。', 'warning');
			return;
		}
	}	
	var eventid=$('#smsEventtype').combobox('getValue');
	var result=$('#smsEventresult').combobox('getValue');
	
	var smsaddress =$('#smsaddress').val();
	var smsname =$('#smsname').val();
	var queryParams = {};
	
	if (null!=node && typeof(node) != "undefined")
		queryParams = {
			id : node.gid,
			type : node.type,
			nodeName : node.name,
			parentid : $("#selectedParentid").val(),
	    	uptype : $("#selectedUpType").val(),
	    	commtype : $("#selectedCommType").val(),
	    	eventid:eventid,
	    	result: result,
		 	startTime :startTime,
			endTime : endTime,
			address : smsaddress,
			name : smsname
		};
	else
		queryParams = {
			eventid:eventid,
		 	result: result,
		 	startTime :startTime,
			endTime : endTime,
			address : smsaddress,
			name : smsname
		};
	
	setFirstPage($("#dgSmsRecord"));
	$('#dgSmsRecord').datagrid({
		queryParams: queryParams,
		pagination : true,//分页控件
		pageList: [10, 20, 30, 40, 50],
		//title:"操作日志",
		fit: true,   //自适应大小
		singleSelect: true,
		border:false,
		nowrap: true,//数据长度超出列宽时将会自动截取。
		rownumbers:true,//行号
		fitColumns:true,//自动使列适应表格宽度以防止出现水平滚动。
		toolbar:'#toolbarSmsRecord',
		url:'${pageContext.request.contextPath}/eventrecord/smsRecordList',
		columns: [[  
			{title: '设备名称', field: 'equipmentname', width: '150px'},
			{title: '设备地址', field: 'equipmentaddr', width: '150px'},
			{title: '所属用户', field: 'customername', width: '180px'},
			{title: '告警类型', field: 'eventname', width: '140px',sortable:true}, 
			{title: '手机号码', field: 'phone', width: '140px'},
			{title: '内容', field: 'content', width: '830px'}, 
			{title: '发生时间', field: 'happentime', width: '180px'}, 
			{title: '结果', field: 'result', width: '150px',
				formatter : function(value, rowData, rowIndex) {
					if(value==1)
            			return "成功";
            		else
            			return "<span style='color:red'>失败<span>";
				}	
	        }, 
			{title: '插入时间', field: 'recordtime', width: '180px'}, 
		]],
		onLoadSuccess:function(){

			$('.button-view').linkbutton({ 
			});
			
			$('.text').textbox({
				width:70,
				height:30
			})

		},		

	});	
}
/* 短信通知日志列表 */

 /* 语音通知日志列表 */
function loadSoundRecordDataGrid(){	
	var startTime = $("#starttimeSoundRecord").datebox("getValue");  
	var endTime = $("#endtimeSoundRecord").datebox("getValue"); 
	if(null!=startTime && startTime!="" && null!=endTime && endTime!=""){
		if(endTime<startTime) {
			$.messager.alert('提示', '发生结束日期应大于等于开始日期。', 'warning');
			return;
		}
	}	
	var eventid=$('#soundEventtype').combobox('getValue');
	var result=$('#soundEventresult').combobox('getValue');
	
	var soundaddress =$('#soundaddress').val();
	var soundname =$('#soundname').val();
	var queryParams = {};
	
	if (null!=node && typeof(node) != "undefined")
		queryParams = {
			id : node.gid,
			type : node.type,
			nodeName : node.name,
			parentid : $("#selectedParentid").val(),
	    	uptype : $("#selectedUpType").val(),
	    	commtype : $("#selectedCommType").val(),
		 	eventid:eventid,
		 	result: result,
		 	startTime :startTime,
			endTime : endTime,
			address : soundaddress,
			name : soundname
		};
	else
		queryParams = {
		 	eventid:eventid,
		 	result: result,
		 	startTime :startTime,
			endTime : endTime,
			address : soundaddress,
			name : soundname
		};
	
	setFirstPage($("#dgSoundRecord"));
	$('#dgSoundRecord').datagrid({
		queryParams: queryParams,
		pagination : true,//分页控件
		pageList: [10, 20, 30, 40, 50],
		//title:"操作日志",
		fit: true,   //自适应大小
		singleSelect: true,
		border:false,
		nowrap: true,//数据长度超出列宽时将会自动截取。
		rownumbers:true,//行号
		fitColumns:true,//自动使列适应表格宽度以防止出现水平滚动。
		toolbar:'#toolbarSoundRecord',
		url:'${pageContext.request.contextPath}/eventrecord/soundRecordList',
		columns: [[  
			{title: '设备名称', field: 'equipmentname', width: '150px'},
			{title: '设备地址', field: 'equipmentaddr', width: '150px'},
			{title: '所属用户', field: 'customername', width: '180px'},
			{title: '告警类型', field: 'eventname', width: '140px',sortable:true}, 
			{title: '手机号码', field: 'phone', width: '140px'},
			{title: '内容', field: 'content', width: '830px'}, 
			{title: '详细内容', field: 'dailinfo', width: '500px'},
			{title: '发生时间', field: 'happentime', width: '180px'}, 
			{title: '结果', field: 'result', width: '150px',
				formatter : function(value, rowData, rowIndex) {
					switch(value){//结果仅供参考，具体看内容。
					case 0:return "<span style='color:red'>异常<span>";break;
					case 1:return "正常接听";break;
					case 2:return "<span style='color:red'>未接<span>";break;
					case 3:return "<span style='color:red'>拒接<span>";break;
					case 4:return "<span style='color:red'>拒接或未接或接听时间太短<span>";break;
					case 5:return "<span style='color:red'>忙音<span>";break;
					case 6:return "<span style='color:red'>设备异常<span>";break;
					case 7:return "<span style='color:red'>异常<span>";break;
					}
				}	
	        }, 
			{title: '插入时间', field: 'recordtime', width: '180px'}, 
		]],
		onLoadSuccess:function(){

			$('.button-view').linkbutton({ 
			});
			
			$('.text').textbox({
				width:70,
				height:30
			})

		},		

	});	
}
/* 语音通知日志列表 */

//对Date的扩展，将 Date 转化为指定格式的String
//月(M)、日(d)、小时(h)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符， 
//年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字) 
//例子： 
//(new Date()).Format("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423 
//(new Date()).Format("yyyy-M-d h:m:s.S")      ==> 2006-7-2 8:9:4.18 
Date.prototype.Format = function(fmt) { //author: meizz 
	var o = {
		"M+" : this.getMonth() + 1, //月份 
		"d+" : this.getDate(), //日 
		"h+" : this.getHours(), //小时 
		"m+" : this.getMinutes(), //分 
		"s+" : this.getSeconds(), //秒 
		"q+" : Math.floor((this.getMonth()+3)/3),//季度
		"S" : this.getMilliseconds()
	//毫秒 
	};
	if (/(y+)/.test(fmt)) {
		fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "")
				.substr(4 - RegExp.$1.length));
	}
	for ( var k in o)
		if (new RegExp("(" + k + ")").test(fmt))
			fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k])
					: (("00" + o[k]).substr(("" + o[k]).length)));
	return fmt;

}

function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	var h = date.getHours();  
	var min = date.getMinutes();  
	var sec = date.getSeconds();
	return  y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d)+' '+(h<10?('0'+h):h)+':'+(min<10?('0'+min):min)+':'+(sec<10?('0'+sec):sec);
}
function myparser(s){
	if (!s) return new Date();
		var y = s.substring(0,4);  
		var m =s.substring(5,7);  
		var d = s.substring(8,10);
		var h = s.substring(11,13);  
		var min = s.substring(14,16);  
		var sec = s.substring(17,19);
	if (!isNaN(y) && !isNaN(m) && !isNaN(d) && !isNaN(h) && !isNaN(min) && !isNaN(sec)){
		return new Date(y,m-1,d,h,min,sec);
	} else {
		return new Date();
	}
}

//时间段判断
$.extend($.fn.validatebox.defaults.rules, {  
	equaldDate: {  
	    validator: function (value, param) { 
	        var start = $(param[0]).datetimebox('getValue');  //获取开始时间    
	        return value >= start;                             //有效范围为当前时间大于开始时间    
	    },  
	    message: '发生结束日期应大于开始日期!'  //匹配失败消息  
	}  
});  
</script>
</html>