<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
    <%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>综合查询页面-首页</title>
<%@include file="../Header.jsp" %>
<script operatename="text/javascript" src="${pageContext.request.contextPath}/js/inquire.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/echarts/echarts.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/echarts/DarkGray_Back.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/makeCurve.js"></script>	
<style type="text/css">
.layout-panel-west {
    border-right: 1px solid #ccc;
}
.layout-split-north{
	border-bottom: 1px solid #ccc;
}

.left-td{
    width: 75px;
}
.read-result-tbl{
    margin: 0px;
	padding: 0px;
	font-size: 12px;
	color: #335169;
	background: #fff;
	border-top: 1px solid #a8c7ce;
	border-right: 1px solid #a8c7ce;
}
.read-result-tbl th, .read-result-tbl td{
    padding: 2px 5px 2px 5px;
	border-bottom: 1px solid #a8c7ce;
	border-left: 1px solid #a8c7ce;
	vertical-align: middle;
}
.layout-split-west {
    border-right: 1px solid #ccc;
}
.layout-split-north{
    border-bottom: 1px solid #ccc;
}
.mTable{border-collapse:collapse;
    border:1px solid gray;
}
.mTable tr  td{ 
    border:1px solid gray;
}
.layout-split-west {
    border-right: 1px solid #ccc;
}
#result-head .panel .panel-header {
    border: 0px;
    background: whitesmoke;
}
#result-head .panel .panel-header .panel-title{
	color:#000;
}

.l-btn-plain {
	border: 1px solid #ccc;
}
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
.echarts-dataview{
	background-color: rgb(248, 248, 248) !important;
}
.cbktext{
	vertical-align: middle;
	margin:0 5px 0 5px;
}
#south .panel-body {
    background-color: #f3f3f3  !important;
}
#detailError {
	border-right: 1px solid #000;
	border-bottom: 1px solid #000;
}

#detailError td {
	border-left: 1px solid #000;
	border-top: 1px solid #000;
	padding: 5px;
}

.searchable-select {
  width: 190px;
}
.searchable-select-holder, .searchable-select-item, .searchable-select-item .selected{
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
}
</style>
</head>
<body>

<div class="easyui-layout" data-options="fit:true">
	<div id="west" region="west" iconCls="icon-organization" split="true" title="" style="width:280px;min-width:280px;" collapsible="true">
		<%@include file="../CommonTree/ammeterTree.jsp" %>
	</div>
    <div id="index_center" class="banner" data-options="region:'center',border:false,split:false" >
    </div>
</div>

<!-- 公用 -->
<input type="hidden" id="selectedID" /> 
<input type="hidden" id="selectedType" /> 
<input type="hidden" id="selectedAddress" />

<!-- 数据召测 -->
<input type="hidden" name="type" id="type" />
<input type="hidden" name="unitid" id="unitid" /> 
<input type="hidden" name="equipmentid" id="equipmentid" />
<input type="hidden" name="systemtype" id="systemtype" />
<input type="hidden" id="selectedParentid" />
	
<!-- 参数管理弹出框 -->
<div id="paramManagePage" class="easyui-dialog" style="width:560px;height:460px;" closed="true" 
	data-options="">
</div>

<!-- 事件阀值弹出框 -->
<div id="eventThresholdPage" class="easyui-dialog" style="width:700px;height:460px;" closed="true" 
	data-options="">
</div>

<!-- 冻结周期弹出框 -->
<div id="freezeCyclePage" class="easyui-dialog" style="width:500px;height:200px;" closed="true" 
	data-options="">
	<div id="freezeResult"></div>
</div>

<!-- 数据召测弹出框 -->
<div id="dataQueryPage" class="easyui-dialog" style="width:800px;height:550px;" closed="true" buttons="" data-options="">
	<div id="result-head" class="easyui-layout" fit="true">
		<div region="north" style="height: 35px;" split="false">
			<table border="0" cellspacing="8" cellpadding="8">
				<tr>
					<td style="width:40px;">
						节点：
					</td>
					<td>
						<label id='datanode'></label>
					</td>
                </tr>
			</table>
		</div>
		<div data-options="region:'center'" width="100%" height="100%">	
			 <div id="dataTab" class="easyui-tabs" data-options="border:false" style="height:100%;width:99%;">
				<div title="报警数据" style="" id="0">
					<!-- 列表-按钮 -->
					<div id="unitalarmtoolbar">
						<input class="easyui-numberspinner" type="text" style="width:160px;" name="initialSequence" id="initialSequence" data-options="label:'起始序号',required:true,min:1,max:255,prompt:'1-255'" />
						<input class="easyui-numberspinner"  style="width:160px;" name="queryCount" id="queryCount" data-options="label:'查询点数',required:true,min:1,max:512,prompt:'1-512'" />
						<span>事件类型</span>
						<input class="easyui-combobox" style="width:160px" name = "eventtype" id="eventtype" data-options="valueField:'id', textField:'text',required:true"/>
						<a href="#" class="easyui-linkbutton button-edit button-default" data-options="iconCls:'icon-search'" onclick="QueryalarmData(1)">查询 </a>
					</div>
					<!-- 列表 -->
					<table id="unitalarmtb" toolbar="#unitalarmtoolbar"
						iconCls="icon-save" rownumbers="true" pagination="true"
						fitColumns="true" singleSelect="true" nowrap="true" fit="true">
					</table>
				</div>
				<div title="设备故障" style="" id="8">
					<!-- 列表-按钮 -->
					<div id="faulttoolbar">
						<input class="easyui-numberspinner" type="text" style="width:160px;" name="faultinitialSequence" id="faultinitialSequence" data-options="label:'起始序号',required:true,min:1,max:255,prompt:'1-255'" />
						<input class="easyui-numberspinner"  style="width:160px;" name="faultqueryCount" id="faultqueryCount" data-options="label:'查询点数',required:true,min:1,max:512,prompt:'1-512'" />
						<input class="easyui-combobox" style="width:230px" name="faulttype" id="faulttype" 
						data-options="method: 'get',required:true,
	                 	label:'故障类型',
						url:'${pageContext.request.contextPath}/dataQuery/getFaultType?Math.random()',
						valueField: 'detailvalue',
						textField:'detailname'"/>
						<a href="#" class="easyui-linkbutton button-edit button-default" data-options="iconCls:'icon-search'" onclick="QueryFault(1)">查询</a>
					</div>
					<!-- 列表 -->
					<table id="faulttb" toolbar="#faulttoolbar"
						iconCls="icon-save" rownumbers="true" pagination="true"
						fitColumns="true" singleSelect="true" nowrap="true" fit="true">
					</table>
				</div>
				<div title="消息推送" style="" id="9">
					<!-- 列表-按钮 -->
					<div id="messagetoolbar">
						<input class="easyui-numberspinner" type="text" style="width:160px;" name="messageinitialSequence" id="messageinitialSequence" data-options="label:'起始序号',required:true,min:1,max:255,prompt:'1-255'" />
						<input class="easyui-numberspinner"  style="width:160px;" name="messagequeryCount" id="messagequeryCount" data-options="label:'查询点数',required:true,min:1,max:512,prompt:'1-512'" />
						<input class="easyui-combobox" style="width:230px" name="messagetype" id="messagetype" 
						data-options="method: 'get',required:true,
	                 	label:'消息类型',
						url:'${pageContext.request.contextPath}/dataQuery/getMessageType?Math.random()',
						valueField: 'detailvalue',
						textField:'detailname'"/>
						<a href="#" class="easyui-linkbutton button-edit button-default" data-options="iconCls:'icon-search'" onclick="QueryMessage(1)">查询</a>
					</div>
					<!-- 列表 -->
					<table id="messagetb" toolbar="#messagetoolbar"
						iconCls="icon-save" rownumbers="true" pagination="true"
						fitColumns="true" singleSelect="true" nowrap="true" fit="true">
					</table>
				</div>
				<div title="用电系统当前数据" style="" id="1">
				<!-- 列表-按钮 -->
					<div id="elecurrenttoolbar">
						<a href="#" class="easyui-linkbutton button-edit button-default" data-options="iconCls:'icon-search'" onclick="QueryRealTimeData()">查询</a>
					</div>
					<!-- 列表 -->
					<table id="elecurrenttb"  toolbar="#elecurrenttoolbar"
						iconCls="icon-save" rownumbers="true"
						pagination="true" fitColumns="true" singleSelect="true"
						nowrap="true" fit="true">
					</table>
				</div>
				<div title="用电系统曲线数据" style="" id="2">
					<!-- 列表-按钮 -->
					<div id="elecurvetoolbar">
						<input type="text" class="easyui-datetimebox" editable="fasle" style="width:228px;" name="ecstarttime" id="ecstarttime" data-options="label:'起始时间',required:true " />
						<input type="text" class="easyui-numberspinner"  style="width:160px;" name="ecnum" id="ecnum" data-options="label:'查询点数',required:true,required:true,min:0,max:99,prompt:'0-99'" />
						<a href="#" class="easyui-linkbutton button-edit button-default" data-options="iconCls:'icon-search'" onclick="queryFreezeData(2)">查询</a>
					</div>
					<!-- 列表 -->
					<table id="elecurvetb" toolbar="#elecurvetoolbar"
						iconCls="icon-save" rownumbers="true" pagination="true"
						fitColumns="true" singleSelect="true" nowrap="true" fit="true">
					</table>
				</div>
				<div title="用电系统日冻结数据" style="" id="3">
					<!-- 列表-按钮 -->
					<div id="elefreezetoolbar">
						<input type="text" class="easyui-datetimebox" editable="fasle" style="width:228px;" name="efstarttime" id="efstarttime" data-options="label:'起始时间',required:true " /> 
							<input
							type="text" class="easyui-numberspinner"  style="width:160px;" name="efnum" id="efnum" data-options="label:'查询点数',required:true,min:0,max:99,prompt:'0-99'" />
							<a href="#"
							class="easyui-linkbutton button-edit button-default"
							data-options="iconCls:'icon-search'" onclick="queryFreezeData(1)">查询</a>
					</div>
					<!-- 列表 -->
					<table id="elefreezetb" toolbar="#elefreezetoolbar"
						iconCls="icon-save" rownumbers="true" pagination="true"
						fitColumns="true" singleSelect="true" nowrap="true" fit="true">
					</table>
				</div>
				<div title="水气烟感系统日冻结数据" style="" id="4">
					<!-- 列表-按钮 -->
					<div id="wgsbtoolbar">
						<input type="text" class="easyui-datetimebox" editable="fasle" style="width:228px;" name="wgsstarttime"
							id="wgsstarttime" data-options="label:'起始时间',required:true " /> <input
							type="text" class="easyui-numberspinner"  style="width:160px;" name="wgsnum" id="wgsnum"
							data-options="label:'查询点数',required:true,min:0,max:99,prompt:'0-99'" />
							 <a href="#"
							class="easyui-linkbutton button-edit button-default"
							data-options="iconCls:'icon-search'"
							onclick="queryFreezeData(99)">查询</a>
					</div>
					<!-- 列表 -->
					<table id="wgstb" toolbar="#wgsbtoolbar" iconCls="icon-save"
						rownumbers="true" pagination="true" fitColumns="true"
						singleSelect="true" nowrap="true" fit="true">
					</table>
				</div>
				<div title="报警按钮及声光报警器日冻结数据" style="" id="5">
					<!-- 列表-按钮 -->
					<div id="aavatoolbar">
						<input type="text" class="easyui-datetimebox" editable="fasle" style="width:228px;" name="aavastarttime"
							id="aavastarttime" data-options="label:'起始时间',required:true " /> <input
							type="text" class="easyui-numberspinner"  style="width:160px;" name="aavanum" id="aavanum"
							data-options="label:'查询点数',required:true,min:0,max:99,prompt:'0-99'" />
							 <a href="#"
							class="easyui-linkbutton button-edit button-default"
							data-options="iconCls:'icon-search'"
							onclick="queryFreezeData(6)">查询</a>
					</div>
					<!-- 列表 -->
					<table id="aavatb" toolbar="#aavatoolbar" iconCls="icon-save"
						rownumbers="true" pagination="true" fitColumns="true"
						singleSelect="true" nowrap="true" fit="true">
					</table>
				</div>
				<div title="消防水位监控系统日冻结数据" style="" id="6">
				<!-- 列表-按钮 -->
					<div id="flmstoolbar">
						<input type="text" class="easyui-datetimebox" editable="fasle" style="width:228px;" name="flmsstarttime"
							id="flmsstarttime" data-options="label:'起始时间',required:true " /> <input
							type="text" class="easyui-numberspinner"  style="width:160px;" name="flmsnum" id="flmsnum"
							data-options="label:'查询点数',required:true,min:0,max:99,prompt:'0-99'" />
							 <a href="#"
							class="easyui-linkbutton button-edit button-default"
							data-options="iconCls:'icon-search'"
							onclick="queryFreezeData(7)">查询</a>
					</div>
					<!-- 列表 -->
					<table id="flmstb" toolbar="#flmstoolbar" iconCls="icon-save"
						rownumbers="true" pagination="true" fitColumns="true"
						singleSelect="true" nowrap="true" fit="true">
					</table>
				</div>
				<div title="防火卷级防火门监控系统日冻结数据" style="" id="7">
					<!-- 列表-按钮 -->
					<div id="fdmstoolbar">
						<input type="text" class="easyui-datetimebox" editable="fasle" style="width:228px;" name="fdmsstarttime"
							id="fdmsstarttime" data-options="label:'起始时间',required:true " /> <input
							type="text" class="easyui-numberspinner"  style="width:160px;" name="fdmsnum" id="fdmsnum"
							data-options="label:'查询点数',required:true,min:0,max:99,prompt:'0-99'" />
							 <a href="#"
							class="easyui-linkbutton button-edit button-default"
							data-options="iconCls:'icon-search'"
							onclick="queryFreezeData(8)">查询</a>
					</div>
					<!-- 列表 -->
					<table id="fdmstb" toolbar="#fdmstoolbar" iconCls="icon-save"
						rownumbers="true" pagination="true" fitColumns="true"
						singleSelect="true" nowrap="true" fit="true">
					</table>
				</div>
			</div>
		</div>
	
		<!--查询/设置结果  -->
      	<div region="south" split="true" style="height:200px;" title="结果<a href='javascript:void(0)' class='easyui-linkbutton' style='float: right; width: 40px;' 
	        onclick='clearResult();'>清空</a>" split="true">
		        <div id="result" style="margin:10px 10px 50px 10px;"><!-- 上 右下左 -->
		        </div>
		</div>
	</div>
</div>

<div id="w" class="easyui-window" closed="true" data-options="cls:'theme-panel-orange'" style="width:380px;height:300px;padding:10px;">
	<div id="DataDetail" align="center">
	</div>
</div>

<div id="dlgFreezeCurve" class="easyui-dialog" style="width:800px;height:460px;" closed="true" data-options="">
</div>

<div id="dlgRealtimeCurve" class="easyui-dialog" style="width:800px;height:460px;" closed="true" data-options="">
</div>

<!-- 告警列表弹出框 -->
<div id="alarmList" class="easyui-dialog" style="width:730px;height:460px;" closed="true" data-options="">
    <table id="alarmListTbl" style="width:100%;height:100%;"></table>
    <div id="alarmtoolbar">
	    <div style="display: inline-block;">
	    	<label style="font-size:14px">告警类型:</label>
	    	<select id="alarmtype" name="alarmtype"  class="easyui-combobox"  style="width:160px;height:26px;" 					
				data-options="method: 'get',
				url: '${pageContext.request.contextPath}/constant/getDetailList_All?Math.random()&coding='+1011,
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
	        <label for="time">上报时间:</label>   
	        <input class="easyui-datetimebox" editable="fasle" style="width:165px;" type="text" id="starttime"  name="starttime" /> 
	        <label for="time">-</label>   
	        <input class="easyui-datetimebox" editable="fasle" style="width:165px;" type="text" id="endtime"  name="endtime" data-options="validType:'equaldDate[\'#starttime\']'"/> 
	    </div>
	    <div style="display: inline-block;">
	    	<label style="font-size:14px">处理状态:</label>
		    <select class="easyui-combobox" name="dealtype" id="dealtype" style="width:110px;height:26px;" data-options="">
		        <option value="0">待处理告警</option>
		        <option value="1">已处理告警</option>
		        <option value="2">所有告警</option>
	        </select>
	    </div>
	    <div style="display: inline-block;">
	    	<label style="font-size:14px">结束状态:</label>
		    <select class="easyui-combobox" name="end" id="end" style="width:110px;height:26px;" data-options="">
		        <option value="0">未结束告警</option>
		        <option value="1">已结束告警</option>
		        <option value="2" selected="selected">所有告警</option>
	        </select>
	    </div>
	    <a href="javascript:void(0)" class="easyui-linkbutton button-default" onclick="getAlarmList()" >确定</a>
	</div>
</div> 

<!-- 故障列表弹出框 -->
<div id="faultList" class="easyui-dialog" style="width:800px;height:460px;" closed="true" data-options="">
    <table id="faultListTbl" style="width:100%;height:100%;"></table>
    <div id="toolbarfault">
    	<div style="display: inline-block;">
     		<label style="font-size:14px">故障类型:</label>
     		<select id="fault_type" name="fault_type"  class="easyui-combobox"  style="width:160px;height:26px;" 					
				data-options="method: 'get',
				url: '${pageContext.request.contextPath}/constant/getDetailList_All?Math.random()&coding='+1084,
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
		        <option value="0">待处理故障</option>
		        <option value="1">已处理故障</option>
		        <option value="2">所有故障</option>
	      	</select>
	    </div>
	    <div style="display: inline-block;">
     		<label style="font-size:14px">结束状态:</label>
		  	<select class="easyui-combobox" name="endFault" id="endFault" style="width:110px;height:26px;" data-options="">
	        	<option value="0" selected="selected">未结束故障</option>
	        	<option value="1">已结束故障</option>
	        	<option value="2">所有故障</option>
	      	</select>
	    </div>
	    <div style="display: inline-block;">
	      	<label for="time">上报时间:</label>   
	        <input class="easyui-datetimebox" editable="fasle" style="width:155px;" type="text" id="starttimeFault"  name="starttimeFault" /> 
	        <label for="time">-</label>   
	        <input class="easyui-datetimebox" editable="fasle" style="width:155px;" type="text" id="endtimeFault"  name="endtimeFault" data-options="validType:'equaldDate[\'#starttimeFault\']'"/> 
	    </div>
		<a href="javascript:void(0)" class="easyui-linkbutton button-default" onclick="getFaultList()" >确定</a>
	</div>
</div> 

<!-- 操作日志列表弹出框 -->
<div id="logList" class="easyui-dialog" style="width:800px;height:500px;" closed="true" data-options="">
    <table id="logListTbl" style="width:100%;height:100%;"></table>
    <div id="logtoolbar">
    	<div style="display: inline-block;">
			<label style="font-size:14px">操作人:</label>
			<input class="easyui-textbox" type="text" id="user"  name="user"/> 
	    </div>
	    <div style="display: inline-block;">
			<label style="font-size:14px">操作类型:</label>
			<select class="easyui-combobox" style="width:80px;" id="operatetype" name="operatetype">
        		<option value="">所有</option>
      			<option value="0">添加</option>
      			<option value="1">删除</option>
      			<option value="2">编辑</option>
      			<option value="3">启用</option>
      			<option value="4">禁用</option>
      			<option value="5">请求</option>
      			<option value="6">响应</option>
      			<option value="7">设置</option>
	        </select>  
	    </div>
	    <div style="display: inline-block;">
	      	<label for="time">时间:</label>   
	        <input class="easyui-datetimebox" editable="fasle" style="width:155px;" type="text" id="logstarttime"  name="logstarttime" /> 
	        <label for="time">-</label>   
	        <input class="easyui-datetimebox" editable="fasle" style="width:155px;" type="text" id="logendtime"  name="logendtime" data-options="validType:'equaldDate[\'#starttimeFault\']'"/> 
	    </div>
		<a href="javascript:void(0)" class="easyui-linkbutton button-default" onclick="getLogList()" >确定</a>  	
	</div>
</div> 

<div id="inf" class="easyui-dialog"
	style="width: 530px; height: 360px; padding: 10px" closed="true"
	buttons="#inf-buttons">
	<table id="detailError" cellspacing="0" class="detailTable">
		<tr>
			<td style="width: 100px">操作人</td>
			<td><label id=userid></label></td>
			<td style="width: 110px">操作人ip</td>
			<td><label id="ip"></label></td>
		</tr>
		<tr>
			<td style="width: 100px">操作类型</td>
			<td><label id="operatename"></label></td>
			<td style="width: 110px">操作时间</td>
			<td><label id="intime"></label></td>
		</tr>
		<tr>
			<td style="width: 100px">详细内容</td>
			<td colspan="3">
					<p id="mylabel" style="word-break: break-all;"></p>
					<p id="content" style="word-wrap: break-word; word-break: break-all; overflow: hidden;"></p>
			</td>
		</tr>
	</table>
</div>
<div id="inf-buttons">
	<a href="#" class="easyui-linkbutton" iconCls="icon-cancel"
		onclick="javascript:$('#inf').dialog('close')">关闭</a>
</div>

<script type="text/javascript">
//websocket相关
var ws;
var port = '0'; //前一次端口号，断线重连时用到
var frameNumber = 1; //帧序号

var node;
var p_node;
var pp_node;
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
	
	$('#alarmList').dialog({
	    onClose:function(){
	    	$('#alarmListTbl').datagrid('loadData',{total:0,rows:[]});
	    }
	});
	
	$('#faultList').dialog({
	    onClose:function(){
	    	$('#faultListTbl').datagrid('loadData',{total:0,rows:[]});
	    }
	});
	
	$('#logList').dialog({
	    onClose:function(){
	    	$('#logListTbl').datagrid('loadData',{total:0,rows:[]});
	    }
	});
	
	$('#alarmListTbl').datagrid({
		url:'',
		queryParams: {},
		border:false,
		singleSelect:true,
		remoteSort:false,
		nowrap: true,//数据长度超出列宽时将会自动截取。
		rownumbers:true,//显示序号
		pagination:true,//分页控件  
		pageSize:10,
		pageList: [10, 15, 50, 100],
		collapsible:true,
		fit: true,   //自适应大小
		toolbar:'#alarmtoolbar',
		columns: [[ 
			{title: '告警类型', field: 'DETAILNAME', width: '110px',
				formatter:function(value,rowData,rowIndex){
					if(null!=rowData.routes && rowData.routes!=0){
						return rowData.routes + "路" + value;
					}
					return value;
            	}
			}, 
			{title: '发生时间(设备)', field: 'occurtime', width: '180px',sortable:true}, 
			{title: '结束时间(设备)', field: 'endtime', width: '180px'},  
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
			{title: '处理人', field: 'handlepeople', width: '100px'}, 
			{title: '处理时间', field: 'processtime', width: '180px'},  
	        {title: '处理备注', field: 'processremarks', width: '150px'},
	        {title: '上报时间', field: 'insertiontime', width: '180px'},     						 							
		]]
	});
	
	$('#faultListTbl').datagrid({
		url:'',
		queryParams: {},
		border:false,
		singleSelect:true,
		remoteSort:false,
		nowrap: true,//数据长度超出列宽时将会自动截取。
		rownumbers:true,//显示序号
		pagination:true,//分页控件  
		pageSize:10,
		pageList: [10, 15, 50, 100],
		collapsible:true,
		fit: true,   //自适应大小
		toolbar:'#toolbarfault',
		columns: [[ 
			{title: '故障类型', field: 'DETAILNAME', width: '140px',
				formatter:function(value,rowData,rowIndex){
					if(null!=rowData.channelno && rowData.channelno!=0){
						return rowData.channelno + "路" + value;
					}
					return value;
            	}
			}, 
			{title: '发生时间', field: 'occurtime', width: '180px',sortable:true}, 
			{title: '结束时间', field: 'endtime', width: '180px'}, 
			{title: '所属表箱', field: 'measureName', width: '180px'}, 
	        {title: '表箱安装地址', field: 'address', width: '180px'}, 
	        {title: '设备安装位置', field: 'installationLocation', width: '180px'},      						 										
		]]
	});

	$('#logListTbl').datagrid({
		url :'',
		pagination : true,//分页控件
		pageList: [10, 20, 30, 40, 50],
		//title:"操作日志",
		fit: true,   //自适应大小
		singleSelect: true,
		iconCls : 'icon-save',
		border:false,
		nowrap: true,//数据长度超出列宽时将会自动截取。
		rownumbers:true,//行号
		fitColumns:true,//自动使列适应表格宽度以防止出现水平滚动。
		toolbar:'#logtoolbar',
		columns: [[  
			{title: '操作人', field: 'username', width:'100px'},
			{title: '操作人IP地址', field: 'ip', width:'150px'},
			{title: '操作类型', field: 'operatename', width:'100px'},
			{title: '标题', field: 'title', width:'200px'},
	        {title: '操作时间', field: 'intime', width:'150px'},
	        {title: '操作', field: 'content', width:'150px',
	        	   formatter:function(value,rowData,rowIndex){
	        		   return "<a href='#' class='easyui-linkbutton linkbutton l-btn l-btn-small' id='search' onclick='mngRol(&apos;" + rowData.logid + "&apos;);' group=''><span class='l-btn-left'><span class='l-btn-text'>详细信息</span></span></a>";
	        	   }  
	        }
	    ]]
	});

	//websocket
//	connect();
	
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
	$('#logstarttime').datetimebox('setValue', start);//操作日志列表
	$('#logendtime').datetimebox('setValue', end);
	
	initPage();
});




function initPage(){
	initDialog();
	node = null;
	$("#selectedID").val("");
    $("#selectedType").val("");
    $("#selectedAddress").val("");
	var url = basePath + '/complex/online?Math.random()';
    var iframe = '<iframe allowFullScreen="true" src="' + url + '" scrolling="auto" frameborder="0" style="width:100%;height:100%;"></iframe>';
	$("#index_center").html(iframe);
}

var treeTab = $('#region_tree');
//公用树点击事件
function treeClick(treeObj, n){
	if(typeof n!='undefined' ){
		node = n;
		treeTab = treeObj;
		clickNode();
	}
}

function clickNode(){
	initDialog();
	
	if(null==node || node=="")
		if(null!=treeTab.tree('getSelected'))
			node=treeTab.tree('getSelected');
		else{
			$.messager.alert('提示',"请选择树节点！",'info');
			return;
		}

	if(null!=node) p_node = treeTab.tree('getParent', node.target);
	if(null!=p_node) pp_node = treeTab.tree('getParent', p_node.target);
	
	var url = "";
	if(node.type==4||node.type==5||node.type==6){
		url = basePath + '/complex/devicedata?Math.random()';
	}else{
		url = basePath + '/complex/online?Math.random()';
	}
    
    $("#selectedID").val(node.gid);
    $("#selectedType").val(node.type);
    $("#selectedAddress").val(node.name);

    var iframe = '<iframe allowFullScreen="true" src="' + url + '" scrolling="auto" frameborder="0" style="width:100%;height:100%;"></iframe>';
	$("#index_center").html(iframe);
}

function getAlarmList(){//告警列表
	var startTime = $("#starttime").datebox("getValue");  
	var endTime = $("#endtime").datebox("getValue"); 
	if(null!=startTime && startTime!="" && null!=endTime && endTime!=""){
		if(endTime<startTime) {
			$.messager.alert('提示', '发生结束日期应大于等于开始日期。', 'warning');
			return;
		}
	}	
	var alarmtype =$('#alarmtype').combobox('getValue'); //告警类型
	var status=$('#dealtype').combobox('getValue');  //处理状态
	var end =$('#end').combobox('getValue');  //结束状态
	
	var opts = $("#alarmListTbl").datagrid("options");
    opts.url = basePath + '/complex/alarmList?Math.random()';
    opts.queryParams = {
    		status:status,
		 	end:end,
			startTime :startTime,
			endTime : endTime,
			alarmtype : alarmtype,
			id : node.gid,
			type : node.type
    	};
    $("#alarmListTbl").datagrid("load");

	$('#alarmList').dialog({    
		title: '告警列表',    
	    collapsible: true
	}).dialog('open');
}

function getFaultList(){//故障列表
	var startTime = $("#starttimeFault").datebox("getValue");  
	var endTime = $("#endtimeFault").datebox("getValue"); 
	if(null!=startTime && startTime!="" && null!=endTime && endTime!=""){
		if(endTime<startTime) {
			$.messager.alert('提示', '发生结束日期应大于等于开始日期。', 'warning');
			return;
		}
	}	
	var status=$('#typeFault').combobox('getValue');
	var end =$('#endFault').combobox('getValue');
	var faulttype =$('#fault_type').combobox('getValue');
	
	var opts = $("#faultListTbl").datagrid("options");
    opts.url = basePath + '/complex/faultList?Math.random()';
    opts.queryParams = {
    		status:status,
		 	end:end,
			startTime :startTime,
			endTime : endTime,
			id: node.gid,
			faulttype : faulttype,
			type : node.type
    	};
    $("#faultListTbl").datagrid("load");

	$('#faultList').dialog({    
		title: '故障列表',     
	    collapsible: true
	}).dialog('open');
}

function getLogList(){//操作日志
    var starttime = $.trim($("#logstarttime").val());
    var endtime = $.trim($("#logendtime").val());
    var operatetype = $("#operatetype").combobox("getValue");
    
    var opts = $("#logListTbl").datagrid("options");
    opts.url = basePath + '/sysLog/logInfo?Math.random()';
    opts.queryParams = {
    	    id : node.gid,
    	    type : node.type,
	    	starttime: starttime,
	    	endtime: endtime,
	    	operatetype: operatetype
    	};
    $("#logListTbl").datagrid("load");
	
	$('#logList').dialog({    
		title: '操作日志',     
	    collapsible: true
	}).dialog('open');
}

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

//发送命令
function sentMessage(d,title){
	if (ws) {
        if (ws.readyState == 1) {
        	
        	if (d != "") {
        		if (d.indexOf("html") > 0) { //session超时
                    parent.window.location.reload();
                }
        		else{
                    var a=new Array();
                    if(isJSON(d)) a = JSON.parse(d);
                    else a.push(d);
        			
        			if (a.length > 0){
        				if ($("body").find(".datagrid-mask").length == 0) {
        	                //添加等待提示
        	                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 10000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
        	                $("<div class=\"datagrid-mask-msg\"></div>").html(title).appendTo("body").css({ display: "block", zIndex: 10001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
        	            }
        				
        				for(var i=0;i<a.length;i++){
        					frameNumber++;
                            //组帧，Global.js中定义
                            var frame = makeWSFrame(frameNumber, 0, 1, 1, a[i], '');
                            ws.send(frame);
        				}
        			}
        		}
        	}
        	
        }
        else {
        	$.messager.alert("警告", "通信异常，请刷新页面后重试。", "error");
        }
    }
    else {
    	$.messager.alert("警告", "您的浏览器不支持WebSocket。请选择其他的浏览器再尝试连接服务器。", "error");
    }
}

//判断字符串是否为json字符串
function isJSON(str) {
    if (typeof str == 'string') {
        try {
            var obj=JSON.parse(str);
            if(str.indexOf('{')>-1){
                return true;
            }else if(str.indexOf('[')>-1){
                return true;
            }else{
                return false;
            }
        } catch(e) {
            return false;
        }
    }
    return false;
}

function WSonOpen(e) {
	//删除等待提示
    $("body").find("div.datagrid-mask-msg").remove();
    $("body").find("div.datagrid-mask").remove();
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
    //删除等待提示
    $("body").find("div.datagrid-mask-msg").remove();
    $("body").find("div.datagrid-mask").remove();
    //帧类型为3（握手），表示端口号
    if (frame.type == '3') {
        port = frame.data;
    }
    else if (frame.type == '2') {  //帧类型为2（应答）
        if (frame.data.length.toString() == frame.len) { //判断是否接收到完整的数据帧
        	$.ajax({
				type: 'POST',
				url: basePath + '/complex/parseResponse',
				data: {
					"strXML": frame.data
				},
				success: function(d) {
					if(d.result==1 || d.result==8){
						switch (d.typeFlagCode){
							case 206:case 208:case 215: paramsParse(d); break;
							case 209: freezeParse(d); break;
							case 210: eventParse(d); break;
							default: dataParse(d); break;
						}
					}
					else{
						switch(d.result){
							case 2:
								$.messager.alert("提示", "<div style='color:red;padding:5px'>连接超时。</div>",'error');
								break;
							case 3:
								$.messager.alert("提示", "<div style='color:red;padding:5px'>终端否认应答。</div>",'error');
								break;
							case 4:
								$.messager.alert("提示", "<div style='color:red;padding:5px'>终端不在线。</div>",'error');
								break;
							default:
								$.messager.alert("提示", "<div style='color:red;padding:5px'>前置机未知错误。</div>",'error');
								break;
						}
					}
					
				}
			});
        }
    }
}

function paramsParse(d){
	switch(d.result){
	case 1:
		switch (d.typeFlagCode){
		case 206:
			switch(d.configurationCode){
			case 1:
				$("#paramsResult").prepend("<div style='color:green;padding:5px'>查询设备地址成功。</div>");
				break;
			case 2:
				$("#paramsResult").prepend("<div style='color:green;padding:5px'>查询主站IP成功。</div>");
				break;
			case 3:
				$("#paramsResult").prepend("<div style='color:green;padding:5px'>查询WIFI信息成功。</div>");
				break;
			case 4:
				$("#paramsResult").prepend("<div style='color:green;padding:5px'>查询以太网成功。</div>");
				break;
			case 5:
				$("#paramsResult").prepend("<div style='color:green;padding:5px'>查询短信信息成功。</div>");
				break;
			case 10:
				$("#paramsResult").prepend("<div style='color:green;padding:5px'>查询重发机制成功。</div>");
				break;
			case 12:
				$("#paramsResult").prepend("<div style='color:green;padding:5px'>读取SIM卡序号成功。</div>");
				break;
			case 13:
				$("#paramsResult").prepend("<div style='color:green;padding:5px'>查询电流互感器变比成功。</div>");
				break;
			case 14:
				$("#paramsResult").prepend("<div style='color:green;padding:5px'>查询接线模式字成功。</div>");
				break;
			}
			break;
		case 208:
			$("#paramsResult").prepend("<div style='color:green;padding:5px'>查询终端时间成功。</div>");
			break;
		case 215:
			$("#paramsResult").prepend("<div style='color:green;padding:5px'>查询终端版本号成功。</div>");
			break;
		}
		$("#paramsResult").prepend(d.data);
		break;
	case 8:
		switch (d.typeFlagCode){
		case 206:
			switch(d.configurationCode){
			case 1:
				$("#paramsResult").prepend("<div style='color:red;padding:5px'>查询设备地址失败。</div>");
				break;
			case 2:
				$("#paramsResult").prepend("<div style='color:red;padding:5px'>查询主站IP失败。</div>");
				break;
			case 3:
				$("#paramsResult").prepend("<div style='color:red;padding:5px'>查询WIFI信息失败。</div>");
				break;
			case 4:
				$("#paramsResult").prepend("<div style='color:red;padding:5px'>查询以太网失败。</div>");
				break;
			case 5:
				$("#paramsResult").prepend("<div style='color:red;padding:5px'>查询短信信息失败。</div>");
				break;
			case 10:
				$("#paramsResult").prepend("<div style='color:red;padding:5px'>查询重发机制失败。</div>");
				break;
			case 12:
				$("#paramsResult").prepend("<div style='color:red;padding:5px'>读取SIM卡序号失败。</div>");
				break;
			case 13:
				$("#paramsResult").prepend("<div style='color:red;padding:5px'>查询电流互感器变比失败。</div>");
				break;
			case 14:
				$("#paramsResult").prepend("<div style='color:red;padding:5px'>查询接线模式字失败。</div>");
				break;
			}
			break;
		case 208:
			$("#paramsResult").prepend("<div style='color:red;padding:5px'>查询终端时间失败。</div>");
			break;
		case 215:
			$("#paramsResult").prepend("<div style='color:red;padding:5px'>查询终端版本号失败。</div>");
			break;
		}
		break;
	}
}


//查询冻结周期
function readFreezingPeriod(){
	var selectedID = $.trim($("#selectedID").val());
	var selectedType = $.trim($("#selectedType").val());
  if (selectedID == "") {
  	  $.messager.alert("提示", "请选择节点。", "warning");
      return;
  }
  $("#freezeResult").html("");
  $.ajax({
		type: 'POST',
		url: basePath + '/freezingPeriod/getFreezingPeriod',
		data: {
			"id": selectedID,
			"type": selectedType
		},
		success: function(d) {
			sentMessage(d, "查询中，请稍候...");
		}
	});
}
function freezeParse(d){
	switch(d.result){
	case 1:
		$("#freezeResult").prepend("<div style='color:green;padding:5px'>查询冻结周期成功。</div>");
		$.each(d.data, function(i, n){
			$("#freezeResult").prepend(n);
		});
		break;
	case 8:
		$("#freezeResult").prepend("<div style='color:red;padding:5px'>查询冻结周期失败。</div>");
		break;
	}
	
	$('#freezeCyclePage').dialog({    
		title: '冻结周期',      
        collapsible: true
	}).dialog('open');
}

function eventParse(d){
	switch(d.result){
	case 1:
		switch(d.configurationCode){
		case 1:
			$("#eventResult").prepend("<div style='color:green;padding:5px'>查询电压过压阀值成功。</div>");
			break;
		case 2:
			$("#eventResult").prepend("<div style='color:green;padding:5px'>查询电压欠压阀值成功。</div>");
			break;
		case 3:
			$("#eventResult").prepend("<div style='color:green;padding:5px'>查询电流过流阀值成功。</div>");
			break;
		case 4:
			$("#eventResult").prepend("<div style='color:green;padding:5px'>查询功率过载阀值成功。</div>");
			break;
		case 5:
			$("#eventResult").prepend("<div style='color:green;padding:5px'>查询功率因素超限阀值成功。</div>");
			break;
		case 20:
			$("#eventResult").prepend("<div style='color:green;padding:5px'>查询过温阀值成功。</div>");
			break;
		case 21:
			$("#eventResult").prepend("<div style='color:green;padding:5px'>查询剩余电流超限阀值成功。</div>");
			break;
		case 22:
			$("#eventResult").prepend("<div style='color:green;padding:5px'>查询时钟电池欠压阀值成功。</div>");
			break;
		case 23:
			$("#eventResult").prepend("<div style='color:green;padding:5px'>查询抄表电池欠压阀值成功。</div>");
			break;
		case 24:
			$("#eventResult").prepend("<div style='color:green;padding:5px'>查询温升判断阀值成功。</div>");
			break;
		case 30:
			$("#eventResult").prepend("<div style='color:green;padding:5px'>查询水压过压阀值成功。</div>");
			break;
		case 31:
			$("#eventResult").prepend("<div style='color:green;padding:5px'>查询水压欠压阀值成功。</div>");
			break;
		case 32:
			$("#eventResult").prepend("<div style='color:green;padding:5px'>查询水压监测系统电池欠压阀值成功。</div>");
			break;
		case 40:
			$("#eventResult").prepend("<div style='color:green;padding:5px'>查询烟感浓度超限阀值成功。</div>");
			break;
		case 41:
			$("#eventResult").prepend("<div style='color:green;padding:5px'>查询烟感监测系统电池欠压阀值成功。</div>");
			break;
		case 50:
			$("#eventResult").prepend("<div style='color:green;padding:5px'>查询燃气浓度超限阀值成功。</div>");
			break;
		case 51:
			$("#eventResult").prepend("<div style='color:green;padding:5px'>查询燃气监测系统电池欠压阀值成功。</div>");
			break;
		case 60:
			$("#eventResult").prepend("<div style='color:green;padding:5px'>查询高水位预警阀值成功。</div>");
			break;
		case 61:
			$("#eventResult").prepend("<div style='color:green;padding:5px'>查询低水位预警阀值成功。</div>");
			break;
		case 62:
			$("#eventResult").prepend("<div style='color:green;padding:5px'>查询水位监测系统电池欠压阀值成功。</div>");
			break;
		case 70:
			$("#eventResult").prepend("<div style='color:green;padding:5px'>查询报警按钮电池欠压阀值成功。</div>");
			break;
		case 71:
			$("#eventResult").prepend("<div style='color:green;padding:5px'>查询声光报警电池欠压阀值成功。</div>");
			break;
		case 72:
			$("#eventResult").prepend("<div style='color:green;padding:5px'>查询消防栓电池欠压阀值成功。</div>");
			break;
		case 73:
			$("#eventResult").prepend("<div style='color:green;padding:5px'>查询防火门电池欠压阀值成功。</div>");
			break;
		}
		$.each(d.data, function(i, n){
			$("#eventResult").prepend(n);
		});

		break;
	case 8:
		switch(d.configurationCode){
		case 1:
			$("#eventResult").prepend("<div style='color:red;padding:5px'>查询电压过压阀值失败。</div>");
			break;
		case 2:
			$("#eventResult").prepend("<div style='color:red;padding:5px'>查询电压欠压阀值失败。</div>");
			break;
		case 3:
			$("#eventResult").prepend("<div style='color:red;padding:5px'>查询电流过流阀值失败。</div>");
			break;
		case 4:
			$("#eventResult").prepend("<div style='color:red;padding:5px'>查询功率过载阀值失败。</div>");
			break;
		case 5:
			$("#eventResult").prepend("<div style='color:red;padding:5px'>查询功率因素超限阀值失败。</div>");
			break;
		case 20:
			$("#eventResult").prepend("<div style='color:red;padding:5px'>查询过温阀值失败。</div>");
			break;
		case 21:
			$("#eventResult").prepend("<div style='color:red;padding:5px'>查询剩余电流超限阀值失败。</div>");
			break;
		case 22:
			$("#eventResult").prepend("<div style='color:red;padding:5px'>查询时钟电池欠压阀值失败。</div>");
			break;
		case 23:
			$("#eventResult").prepend("<div style='color:red;padding:5px'>查询抄表电池欠压阀值失败。</div>");
			break;
		case 24:
			$("#eventResult").prepend("<div style='color:red;padding:5px'>查询温升判断阀值失败。</div>");
			break;
		case 30:
			$("#eventResult").prepend("<div style='color:red;padding:5px'>查询水压过压阀值失败。</div>");
			break;
		case 31:
			$("#eventResult").prepend("<div style='color:red;padding:5px'>查询水压欠压阀值失败。</div>");
			break;
		case 32:
			$("#eventResult").prepend("<div style='color:red;padding:5px'>查询水压监测系统电池欠压阀值失败。</div>");
			break;
		case 40:
			$("#eventResult").prepend("<div style='color:red;padding:5px'>查询烟感浓度超限阀值失败。</div>");
			break;
		case 41:
			$("#eventResult").prepend("<div style='color:red;padding:5px'>查询烟感监测系统电池欠压阀值失败。</div>");
			break;
		case 50:
			$("#eventResult").prepend("<div style='color:red;padding:5px'>查询燃气浓度超限阀值失败。</div>");
			break;
		case 51:
			$("#eventResult").prepend("<div style='color:red;padding:5px'>查询燃气监测系统电池欠压阀值失败。</div>");
			break;
		case 60:
			$("#eventResult").prepend("<div style='color:red;padding:5px'>查询高水位预警阀值失败。</div>");
			break;
		case 61:
			$("#eventResult").prepend("<div style='color:red;padding:5px'>查询低水位预警阀值失败。</div>");
			break;
		case 62:
			$("#eventResult").prepend("<div style='color:red;padding:5px'>查询水位监测系统电池欠压阀值失败。</div>");
			break;
		case 70:
			$("#eventResult").prepend("<div style='color:red;padding:5px'>查询报警按钮电池欠压阀值失败。</div>");
			break;
		case 71:
			$("#eventResult").prepend("<div style='color:red;padding:5px'>查询声光报警电池欠压阀值失败。</div>");
			break;
		case 72:
			$("#eventResult").prepend("<div style='color:red;padding:5px'>查询消防栓电池欠压阀值失败。</div>");
			break;
		case 73:
			$("#eventResult").prepend("<div style='color:red;padding:5px'>查询防火门电池欠压阀值失败。</div>");
			break;
		}
		break;
	}
}

function dataParse(d){ 
	var date=(new Date()).toLocaleString( );//获取当前日期时间
	switch (d.result) {
	case 1:
	{
		switch (d.typeFlagCode) {
		case 213:
			$.ajax({
				type : 'POST',
				url : basePath + '/dataQuery/tempAlarmDataInf',
				data : {
					"num": totalalarmnum,
					"xmldata" : d.data
				},
				success : function(d) {
					if(d.indexOf("html")<0){
						$('#unitalarmtb').datagrid('load',{ 
							"clear" : 0//不清session(初始加载时会把session清掉)
						});
						if(d==0){
							$("#result").prepend("<div style='color:green;padding:5px'>"+date+"查询报警数据成功,无数据</div>");
						}else if(totalalarmnum==d){//查询之后数据个数未变，
							$("#result").prepend("<div style='color:green;padding:5px'>"+date+"查询报警数据成功</div>");
						}else{
							totalalarmnum = parseInt(d);
							if(totalalarmnum>=parseInt($("#queryCount").val())){
								$("#result").prepend("<div style='color:green;padding:5px'>"+date+"查询报警数据成功</div>");
							}else{
								$("iframe")[0].contentWindow.QueryalarmData(2);
							}
						}
					}else{
							$.messager.alert('警告',d,'error');
						}
					},
					error:function(error){
				        	$.messager.alert('警告',error,'error');
				        	
			        }
				});
			break;
		case 217://故障
			$.ajax({
				type : 'POST',
				url : basePath + '/dataQuery/tempFaultDataInf',
				data : {
					"num": totalfaultnum,
					"xmldata" : d.data
				},
				success : function(d) {
					if(d.indexOf("html")<0){
						$('#faulttb').datagrid('load',{ 
							"clear" : 0//不清session(初始加载时会把session清掉)
						});
						if(d==0){
							$("#result").prepend("<div style='color:green;padding:5px'>"+date+"查询故障数据成功,无数据</div>");
						}else if(totalfaultnum==d){//查询之后数据个数未变，
							$("#result").prepend("<div style='color:green;padding:5px'>"+date+"查询故障数据成功</div>");
						}else{
							totalfaultnum = parseInt(d);
							if(totalfaultnum>=parseInt($("#faultqueryCount").val())){
								$("#result").prepend("<div style='color:green;padding:5px'>"+date+"查询故障数据成功</div>");
							}else{
								$("iframe")[0].contentWindow.QueryFault(2);
							}
						}
					}else{
							$.messager.alert('警告',d,'error');
						}
					},
					error:function(error){
				        	$.messager.alert('警告',error,'error');
				        	
			        }
				});
			break;
		case 219://消息推送
			$.ajax({
				type : 'POST',
				url : basePath + '/dataQuery/tempMessageDataInf',
				data : {
					"num": totalmessagenum,
					"xmldata" : d.data
				},
				success : function(d) {
					if(d.indexOf("html")<0){
						$('#messagetb').datagrid('load',{ 
							"clear" : 0//不清session(初始加载时会把session清掉)
						});
						if(d==0){
							$("#result").prepend("<div style='color:green;padding:5px'>"+date+"查询消息推送成功,无数据</div>");
						}else if(totalmessagenum==d){//查询之后数据个数未变，
							$("#result").prepend("<div style='color:green;padding:5px'>"+date+"查询消息推送成功</div>");
						}else{
							totalmessagenum = parseInt(d);
							if(totalmessagenum>=parseInt($("#messagequeryCount").val())){
								$("#result").prepend("<div style='color:green;padding:5px'>"+date+"查询消息推送成功</div>");
							}else{
								$("iframe")[0].contentWindow.QueryMessage(2);
							}
						}
					}else{
							$.messager.alert('警告',d,'error');
						}
					},
					error:function(error){
				        	$.messager.alert('警告',error,'error');
				        	
			        }
				});
			break;
		case 211://电系统当前数据
			$('#elecurrenttb').datagrid('load',
					{
						xmldata : d.data
					});
				$("#result").prepend("<div style='color:green;padding:5px'>"+date+"查询用电系统当前数据成功</div>");
			break;
		case 212://冻结数据
			if (d.freezeTypeCode == 1) {
			$.ajax({
				type : 'POST',
				url : basePath + '/dataQuery/tempfreezeDataInf',
				data : {
					"num": totalfreezenum,
					"xmldata" : d.data
				},
				success : function(d) { 
					$('#elefreezetb').datagrid(
							'load', {
								"clear" : 0//不清session
							});
					var dataaArr = d.split(",");
					if(dataaArr[0]==0){
						$("#result").prepend("<div style='color:green;padding:5px'>"+date+",查询用电系统日冻结数据成功,无数据</div>");
					}else if(totalfreezenum==dataaArr[0]){//数据个数未变，
						$("#result").prepend("<div style='color:green;padding:5px'>"+date+","+dataaArr[2]+",查询用电系统日冻结数据成功</div>");
					}else{
						totalfreezenum = parseInt(dataaArr[0]);
						freezeStartTime= dataaArr[1];
						if(totalfreezenum>=parseInt($("#efnum").val())){
						$("#result").prepend("<div style='color:green;padding:5px'>"+date+","+dataaArr[2]+",查询用电系统日冻结数据成功</div>");
						}else{
							$("iframe")[0].contentWindow.queryNextFreezeData(1,dataaArr[3]);
						}
					}
				}
				});
			} else if (d.freezeTypeCode == 2) {
				$.ajax({
					type : 'POST',
					url : basePath + '/dataQuery/tempfreezeDataInf',
					data : {
						"num": totalfreezenum,
						"xmldata" : d.data
					},
					success : function(d) { 
						var dataaArr = d.split(","); 
						$('#elecurvetb').datagrid(
								'load', {
									"clear" : 0//不清session
								});
						if(dataaArr[0]==0){
							$("#result").prepend("<div style='color:green;padding:5px'>"+date+",查询用电系统曲线数据成功,无数据</div>");
						}else if(totalfreezenum==dataaArr[0]){//数据个数未变，
							$("#result").prepend("<div style='color:green;padding:5px'>"+date+","+dataaArr[2]+",查询用电系统曲线数据成功</div>");
						}else{
							totalfreezenum = parseInt(dataaArr[0]);
							freezeStartTime = dataaArr[1];
							if(totalfreezenum>=parseInt($("#ecnum").val())){
							$("#result").prepend("<div style='color:green;padding:5px'>"+date+","+dataaArr[2]+",查询用电系统曲线数据成功</div>");
							}else{
								$("iframe")[0].contentWindow.queryNextFreezeData(2,dataaArr[3]);
							}
						}
					}
					});
			} else if (d.freezeTypeCode == 3
					|| d.freezeTypeCode == 4
					|| d.freezeTypeCode == 5) {
				$.ajax({
					type : 'POST',
					url : basePath + '/dataQuery/tempfreezeDataInf',
					data : {
						"num": totalfreezenum,
						"xmldata" : d.data
					},
					success : function(d) {
						var dataaArr = d.split(",");
						$('#wgstb').datagrid(
								'load', {
									"clear" : 0//不清session
								});
						if(dataaArr[0]==0){
							$("#result").prepend("<div style='color:green;padding:5px'>"+date+",查询水气烟感系统日冻结数据成功,无数据</div>");
						}else if(totalfreezenum==dataaArr[0]){//数据个数未变，
							$("#result").prepend("<div style='color:green;padding:5px'>"+date+","+dataaArr[2]+",查询水气烟感系统日冻结数据数据成功</div>");
						}else{
							totalfreezenum = parseInt(dataaArr[0]);
							freezeStartTime= dataaArr[1];
							if(totalfreezenum>=parseInt($("#wgsnum").val())){
								$("#result").prepend("<div style='color:green;padding:5px'>"+date+","+dataaArr[2]+",查询水气烟感系统日冻结数据日冻结数据成功</div>");
							}else{
								$("iframe")[0].contentWindow.queryNextFreezeData(99,dataaArr[3]);
							}
						}
					}
					});
			}
			else if (d.freezeTypeCode==6){
				$.ajax({
					type : 'POST',
					url : basePath + '/dataQuery/tempfreezeDataInf',
					data : {
						"num": totalfreezenum,
						"xmldata" : d.data
					},
					success : function(d) { 
						var dataaArr = d.split(",");
						$('#aavatb').datagrid(
								'load', {
									"clear" : 0//不清session
								});
						if(dataaArr[0]==0){
							$("#result").prepend("<div style='color:green;padding:5px'>"+date+",查询报报警按钮及声光报警器日冻结成功,无数据</div>");
						}else if(totalfreezenum==dataaArr[0]){//数据个数未变，
							$("#result").prepend("<div style='color:green;padding:5px'>"+date+","+dataaArr[2]+"查询报报警按钮及声光报警器日冻结数据成功</div>");
						}else{
							totalfreezenum = parseInt(dataaArr[0]);
							freezeStartTime= dataaArr[1];
							if(totalfreezenum>=parseInt($("#aavanum").val())){
								$("#result").prepend("<div style='color:green;padding:5px'>"+date+","+dataaArr[2]+"查询报报警按钮及声光报警器日冻结数据成功</div>");
							}else{
								$("iframe")[0].contentWindow.queryNextFreezeData(6,dataaArr[3]);
							}
						}
					}
					});
			}
			else if (d.freezeTypeCode==7){
				$.ajax({
					type : 'POST',
					url : basePath + '/dataQuery/tempfreezeDataInf',
					data : {
						"num": totalfreezenum,
						"xmldata" : d.data
					},
					success : function(d) { 
						var dataaArr = d.split(",");
						$('#flmstb').datagrid(
								'load', {
									"clear" : 0//不清session
								});
						if(dataaArr[0]==0){
							$("#result").prepend("<div style='color:green;padding:5px'>"+date+",查询消防水位及监控系统日冻结成功,无数据</div>");
						}else if(totalfreezenum==dataaArr[0]){//数据个数未变，
							$("#result").prepend("<div style='color:green;padding:5px'>"+date+","+dataaArr[2]+"查询消防水位及监控系统日冻结数据成功</div>");
						}else{
							totalfreezenum = parseInt(dataaArr[0]);
							freezeStartTime= dataaArr[1];
							if(totalfreezenum>=parseInt($("#flmsnum").val())){
								$("#result").prepend("<div style='color:green;padding:5px'>"+date+","+dataaArr[2]+"查询消防水位及监控系统日冻结数据成功</div>");
							}else{
								$("iframe")[0].contentWindow.queryNextFreezeData(7,dataaArr[3]);
							}
						}
					}
					});

			} else if (d.freezeTypeCode==8){
				$.ajax({
					type : 'POST',
					url : basePath + '/dataQuery/tempfreezeDataInf',
					data : {
						"num": totalfreezenum,
						"xmldata" : d.data
					},
					success : function(d) { 
						var dataaArr = d.split(",");
						$('#fdmstb').datagrid(
								'load', {
									"clear" : 0//不清session
								});
						if(dataaArr[0]==0){
							$("#result").prepend("<div style='color:green;padding:5px'>"+date+",查询防火卷及防火门监控系统日冻结数据成功,无数据</div>");
						}else if(totalfreezenum==dataaArr[0]){//数据个数未变，
							$("#result").prepend("<div style='color:green;padding:5px'>"+date+","+dataaArr[2]+"查询防火卷及防火门监控系统日冻结数据成功</div>");
						}else{
							totalfreezenum = parseInt(dataaArr[0]);
							freezeStartTime= dataaArr[1];
							if(totalfreezenum>=parseInt($("#fdmsnum").val())){
								$("#result").prepend("<div style='color:green;padding:5px'>"+date+","+dataaArr[2]+"查询防火卷及防火门监控系统日冻结数据成功</div>");
							}else{
								$("iframe")[0].contentWindow.queryNextFreezeData(8,dataaArr[3]);
							}
						}
					}
					});
				
			} 
			break;
		}
		break;
	}
	case 8:
		$("#result").prepend("<div style='color:red;padding:5px'>"+date+"失败。</div>");
		break;
	}
}
		
function WSonClose(e) {
    try {
    	$("body").find("div.datagrid-mask-msg").remove();
        $("body").find("div.datagrid-mask").remove();
        //$.messager.alert("警告", "远程服务器连接中断，请刷新页面后重试。", "error");
    }
    catch (ex) { }
}

function WSonError(e) { }

function initDialog(){
	$('#paramManagePage').dialog('close');
	$('#eventThresholdPage').dialog('close');
	$("#freezeCyclePage").dialog("close");
	$("#dataQueryPage").dialog("close");
	$('#alarmList').dialog('close');
	$('#faultList').dialog('close');
	$('#dlgFreezeCurve').dialog('close');
	$('#dlgRealtimeCurve').dialog('close');
	$('#logList').dialog('close');
}

function mngRol(logid){	
	$('#userid').text("");
	$('#ip').html("");
	$('#intime').html("");
	$('#operatename').html("");
	$('#mylabel').html("");
	$('#content').html("");

	$.ajax({
		type : 'POST',
		url : basePath + '/sysLog/logDetails',
		//async : false,//同步方式
		data : {
			logid : logid
		},
		success : function(data) {
			if (data != "" || data != null) {
				var json = JSON.parse(data);
				//data就是你需要的数据
				$('#userid').text(json.username);
				$('#ip').html(json.ip);
				$('#intime').html(json.intime);
				$('#operatename').html(json.operatename);

				if(null !=json.content){
					$('#mylabel').html(json.title+":");
					if(json.content.indexOf("xml")>=0){
						$('#content').text(json.content);
					}else {
						if(isJSON(json.content)){
							var content=JSON.parse(json.content);
							var info="<ul>";
							  for(var item in content){
								  info=info+"<li>"+item+":"+content[item]+"</li>"					 
								 } 
							  info=info+"</ul>" 
						 	$('#content').html(info);
						}else{
							$('#content').text(json.content);
						}
					}
				}else {
					$('#mylabel').html("");
					$('#content').html("");
				}
				
			}
		},
		error : function(data) {
			$.messager.alert('<spring:message code="Warning"/>','连接失败','error');
		}

	});
	$('#inf').dialog('open').dialog('setTitle', '<spring:message code="Showthedetails"/>');
		 	
}

</script>

</body>
</html>