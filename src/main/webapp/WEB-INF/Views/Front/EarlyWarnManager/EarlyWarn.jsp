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
<title>Insert title here</title>
<%@include file="../../FrontHeader.jsp"%>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/parseAlarm.js"></script>
<style type="text/css">
.layout-split-west {
    border-right: 10px solid #081a30;
}
.layout-split-north{
	border-bottom: 5px solid #212d39;
}
.tableTr{
    display:block; /*将tr设置为块体元素*/
    margin:5px 0;  /*设置tr间距为2px*/
}
.mydiv { 
	float : left;
}
.tabs-header{
	border:0;
}
#west, .datagrid-wrap, #p {
    border-image: url(${pageContext.request.contextPath}/js/easyui/themes/ui-dark-hive/images/body-border.png);
	border-image-slice: 6 5 6 5 fill;
    border-image-width: 2px;
}

.table-data-table{
	font-size: 13px;
    table-layout: fixed;
    empty-cells: show;
    border-collapse: collapse;
    margin: 0 auto;
    border: 1px solid #cad9ea;
    color: #2a8aba;
    width: 90%;
} 

.table-data-table th { 
	background-repeat:repeat-x; 
} 

.table-data-table td,.table-data-table th{ 
	border:1px solid #2a8aba; 
	padding:0 1em 0; 
} 

.tabs li.tabs-selected a.tabs-inner {
    color: #eeeeee;
    background-color: #212d39;
    background: -webkit-linear-gradient(top,#000000 0,#0972a5 100%);
    background: -moz-linear-gradient(top,#000000 0,#0972a5 100%);
    background: -o-linear-gradient(top,#000000 0,#0972a5 100%);
    background: linear-gradient(to bottom,#000000 0,#0972a5 100%);
    background-repeat: repeat-x;
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#004b6c,endColorstr=#212d39,GradientType=0);
    border: 1px solid #fff;
    border-bottom: 1px solid #0972a5;
}
</style>
</head>
<body>
	<!-- 公用 -->
	<input type="hidden" id="selectedID" />
	<input type="hidden" id="selectedType" />
	<input type="hidden" id="selectedAddress" />

	<div class="easyui-layout" data-options="fit:true">
		<div id="west" region="west" iconCls="icon-organization" split="true"
			title="设备/终端" style="width: 280px; min-width: 280px;"
			collapsible="true">
			<%@include file="../../CommonTree/f_MeterBoxTree.jsp" %>
		</div>
		<div id="index_center" class="banner"
			data-options="region:'center',border:false,split:false">
			<div class="easyui-tabs " id="tab" style="width: 100%; height: 100%"
				data-options="tabPosition:'top'">
				<input type="hidden" id="selectedParentid" value="0" /> <input
					type="hidden" id="selectedUpType" value="" /> <input type="hidden"
					id="selectedCommType" value="" />
				<div title="告警处理" id="0">
					<table id="dg" style="width: 100%;"></table>
					<div id="toolbar">
						<div style="display: inline-block;">
							<label style="font-size: 14px">表箱地址:</label> <input
								id="alarmaddress" class="easyui-textbox"
								style="width: 160px; height: 26px;"
								data-options="
		                   prompt: '请输入地址……'" />
						</div>
						<div style="display: inline-block;">
							<label style="font-size: 14px">表箱名称:</label> <input
								id="alarmname" class="easyui-textbox"
								style="width: 160px; height: 26px;"
								data-options="
		                   prompt: '请输入名称……'" />
						</div>					
						<div style="display: inline-block;">
							<label for="time">上报时间:</label> <input class="easyui-datetimebox"
								editable="fasle" style="width: 165px;" type="text"
								id="starttime" name="starttime" /> <label for="time">-</label>
							<input class="easyui-datetimebox" editable="fasle"
								style="width: 165px;" type="text" id="endtime" name="endtime"
								data-options="validType:'equaldDate[\'#starttime\']'" />
						</div>					
						<a href="javascript:void(0)"
							class="easyui-linkbutton button-default" onclick="loadDataGrid()">确定</a>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- 处理告警弹出框 -->
	<div id="dlg" class="easyui-dialog"
		style="width: 330px; height: 370px; padding: 10px 20px;" closed="true"
		buttons="#dlg-buttons" data-options="modal:true">
		<form id="fm" class="easyui-form" method="post"
			enctype="multipart/form-data">
			<table cellpadding="5" align="center">
				<tr class="tableTr">
					<td><input class="easyui-datetimebox processtime1"
						editable="fasle" name="processtime" style="width: 100%;"
						data-options="label:'处理时间',required:true,formatter:myformatter,parser:myparser"></td>
				</tr>
				<tr class="tableTr">
					<td><select id="processmethod" name="processmethod"
						class="easyui-combobox processmethod1" style="width: 200px;"
						data-options="">
					</select></td>
				</tr>
				<tr class="tableTr">
					<td><input class="easyui-filebox" style="width: 100%"
						name="myAnnex" data-options="label:'上传附件',buttonText: '选择文件'," />
					</td>
				</tr>
				<tr class="tableTr">
					<td><input class="easyui-textbox" type="text"
						style="width: 240px; height: 100px;" name="processremarks"
						multiline="true" data-options="label:'备注'"></input></td>
				</tr>
			</table>
		</form>
	</div>
	<div id="dlg-buttons">
		<a href="#" class="easyui-linkbutton" iconCls="icon-ok"
			onclick="saveEarly()"><spring:message code="Save" /></a> <a href="#"
			class="easyui-linkbutton" iconCls="icon-cancel"
			onclick="javascript:$('#dlg').dialog('close')"><spring:message
				code="Cancel" /></a>
	</div>
	<!-- 结束告警弹出框 -->
	<div id="end-early-dlg" class="easyui-dialog"
		style="width: 330px; height: 260px; padding: 10px 20px;" closed="true"
		data-options="modal:true">
		<form id="endform" class="easyui-form" method="post"
			enctype="multipart/form-data">
			<input type="hidden" id="endid" />
			<table cellpadding="5" align="center">
				<tr class="tableTr">
					<td><select id="endreason" name="endreason"
						class="easyui-combobox" style="width: 230px;" data-options="">
					</select></td>
				</tr>
				<tr class="tableTr" style="margin-top: 10px;">
					<td><input id="endremarks" name="endremarks"
						class="easyui-textbox" type="text"
						style="width: 260px; height: 100px; padding-top: 10px;"
						multiline="true" data-options="label:'备注',labelPosition:'center'"></input></td>
				</tr>
			</table>
		</form>
	</div>

	<div id="w" class="easyui-window" closed="true"
		style="width: 380px; height: 250px; padding: 10px;"
		data-options="modal:true">
		<div id="dataDetail" align="center"></div>
	</div>

	<div id="dlgFault" class="easyui-dialog"
		style="width: 330px; height: 320px; padding: 10px 20px;" closed="true"
		buttons="#dlgFault-buttons" data-options="modal:true">
		<form id="fmFault" class="easyui-form" method="post"
			enctype="multipart/form-data">
			<table cellpadding="5" align="center">
				<tr class="tableTr">
					<td><input class="easyui-datetimebox processtime2"
						editable="fasle" name="processtime" style="width: 100%;"
						data-options="label:'处理时间',required:true,formatter:myformatter,parser:myparser"></td>
				</tr>
				<tr class="tableTr">
					<td><select id="processmethod" name="processmethod"
						class="easyui-combobox processmethod2" style="width: 200px;"
						data-options="">
					</select></td>
				</tr>
				<tr class="tableTr">
					<td><input class="easyui-textbox" type="text"
						style="width: 240px; height: 100px;" name="processremarks"
						multiline="true" data-options="label:'备注'"></input></td>
				</tr>
			</table>
		</form>
	</div>
	<div id="dlgFault-buttons">
		<a href="#" class="easyui-linkbutton" iconCls="icon-ok"
			onclick="saveFault()"><spring:message code="Save" /></a> <a href="#"
			class="easyui-linkbutton" iconCls="icon-cancel"
			onclick="javascript:$('#dlgFault').dialog('close')"><spring:message
				code="Cancel" /></a>
	</div>

</body>
<script type="text/javascript">
var processmethod1,processmethod2;
var tabId=0;
var node;
//用于使chart自适应高度和宽度,通过窗体高宽计算容器高宽
var resizeDiv = function () {
	width=$('#west').width();
	height=$('#west').height();
	if(window.innerHeight<height)
		height=window.innerHeight-36;//当有title时，window.innerHeight-38；反之，则window.innerHeight
	$('#left-table').width(width);
	$('#left-table').height(height);
	$('#left-tree').width(width);
	$('#left-tree').height(height-33);
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
	    	}
	    },
	});
	
	
	// 结束窗口
    $('#end-early-dlg').dialog({
    	title: '结束',
        buttons: [{
            text: '结束',
            iconCls: 'icon-ok',
            btnCls: 'easyui-btn',
            handler: function () {;
            	var url = '${pageContext.request.contextPath}/endEarlyWarning?id='+$("#endid").val();
            	
        		$('#endform').form('submit',{
            		url: url,
            		onSubmit: function(){
            			var flag = $(this).form('validate');
            			if(false==flag) $.messager.alert('<spring:message code="Warning"/>',"请选择原因。",'error');
            			return flag;
            		},
            		success: function(result){	
            			if(result=="success"){
            				$('#end-early-dlg').dialog('close');		// close the dialog
            				$('#dg').datagrid('reload');
            				$.messager.alert('<spring:message code="Prompt"/>','结束告警成功。','info');
            			}else{
            				$.messager.alert("警告", "结束告警失败。", "error");
            			}
            		
            		},
            		  error:function(data){
            			  $.messager.alert('<spring:message code="Warning"/>',data,'error');	        	
            	    }
            	});

            }
        },{
            text: '<spring:message code="Cancel"/>',
            iconCls: 'icon-cancel',
            btnCls: 'easyui-btn',
            handler: function () {
            	$("#end-early-dlg").dialog('close');
            }
        }],
        onOpen: function () {
            $(this).panel('refresh');
        }
    }).dialog('close');//默认关闭
	 
	var thisMonth = new Date().getUTCMonth()+1;//本月
	var thisYear = new Date().getUTCFullYear();//今年
	var thisDay = new Date().getDate();//今日
	var endDay = new Date().getDate()+1;//明日
	var start = thisYear+'-'+thisMonth+'-'+thisDay+' 00:00:00';
	var end = thisYear+'-'+thisMonth+'-'+endDay+' 00:00:00';
	$('#starttime').datetimebox('setValue', start);//告警列表
	$('#endtime').datetimebox('setValue', end);	 
	
	$('#dg').datagrid({
		url:'',
		queryParams: { },
		singleSelect:true,
		remoteSort:false,
		nowrap: true,//数据长度超出列宽时将会自动截取。
		rownumbers:true,//显示序号
		pagination:true,//分页控件  
		pageSize:10,
		pageList: [10, 15, 50, 100],
		fit: true,   //自适应大小
		toolbar:'#toolbar',
		columns: [[  
			{title: '设备名称', field: 'equipName', width: '150px'},
			{title: '设备地址', field: 'equipmentAddress', width: '150px'},
			{title: '事件名称', field: 'eventName', width: '150px'},
			{title: '事件存储时间', field: 'collectStoreTime', width: '180px',sortable:true}, 				
            {title: '所属表箱', field: 'measureName', width: '180px'},
			{title: '表箱安装地址', field: 'address', width: '120px'},
            {title: '表箱地址', field: 'measureNumber', width: '120px'}, 
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
	$('#w').window({
       onBeforeClose:function(){ 
    	   isClick=false;
       }
    });
	
	loadDataGrid();
});

//公用树点击事件
var node;
function treeClick(n){
	if(typeof n!='undefined' ){
		node = n;
		$("#selectedID").val(node.gid);
	    $("#selectedType").val(node.type);
	    $("#selectedAddress").val(node.name);
		clickNode();
	}
}

function clickNode(){
	if(null==node || node=="")
		if(null!=$('#region_tree').tree('getSelected'))
			node=$('#region_tree').tree('getSelected');
		else{
			$.messager.alert('提示',"请选择树节点！",'info');
			return;
		}
    $("#selectedParentid").val(0);
    $("#selectedUpType").val("");
    $("#selectedCommType").val("");
    $('#alarmaddress').textbox("setValue","");
	$('#faultaddress').textbox("setValue","");
	$('#msgaddress').textbox("setValue","");
	$('#smsaddress').textbox("setValue","");
	$('#soundaddress').textbox("setValue","");
	$('#alarmname').textbox("setValue","");
	$('#faultname').textbox("setValue","");
	$('#msgname').textbox("setValue","");
	$('#smsname').textbox("setValue","");
	$('#soundname').textbox("setValue","");
    
	switch (node.type){
	case 3://表箱
	loadDataGrid();
    break;
	case 2://区域
	loadDataGrid();
	break;
    }
 
}

/* 告警列表 */
//提交按钮
function Button(value,row,index){
	var result = "";
	if(row.status==0) 
		result += "<a href='#' class='button-view  button-default' onclick='editEarly(&apos;" + index+ "&apos;);'><spring:message code='deal'/></a> ";  
	if(typeof row.endtime=='undefined' || null==row.endtime || row.endtime=="")
		result += "<a href='#' class='button-view  button-default' onclick='endEarly(&apos;" + row.id+ "&apos;);'>结束告警</a> ";  
	return result;
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
	var startTime = $("#starttime").datebox("getValue");  
	var endTime = $("#endtime").datebox("getValue"); 
	if(null!=startTime && startTime!="" && null!=endTime && endTime!=""){
		if(endTime<startTime) {
			$.messager.alert('提示', '发生结束日期应大于等于开始日期。', 'warning');
			return;
		}
	}	
	var alarmaddress =$('#alarmaddress').textbox("getValue");
	var alarmname =$('#alarmname').textbox("getValue");
	var queryParams = {};
	if (null!=node && typeof(node) != "undefined"){
		queryParams = {
			id : node.gid,
		 	startTime :startTime,
			endTime : endTime,
			address : alarmaddress,
			name : alarmname,
			type : node.type
		};
	}else
		queryParams = {
		 	startTime :startTime,
			endTime : endTime,
			address : alarmaddress,
			name : alarmname
		};

	var opts = $("#dg").datagrid("options");
    opts.url = basePath + '/earlyWarn/earlyDataGrid?Math.random';
    opts.queryParams = queryParams;
    $("#dg").datagrid("load");
}

//查询告警数据详情--实时监控页
//alarmId 告警表id
//dataType 数据类型：1-开始数据
//alarmType 事件类型id
var isClick=false;//防止重复点击
function queryData(obj,alarmId,dataType,alarmType){
	if(isClick==false){
		isClick=true;
		
		$(obj).linkbutton('disable');
	    setTimeout(function(){
	    	$(obj).linkbutton('enable');
	    },1000) //点击后相隔多长时间可执行  
		
		//清空表格
		$('#dataDetail').empty();
	    
	    var title;
		if(dataType == 1) title = "发生数据详情";
		else if(dataType == 2) title = "结束数据详情";
	    
		var mData={"alarmId":alarmId,"dataType":dataType,"alarmType":alarmType}; 
		$.ajax({
			type:'POST', 
	        url:'${pageContext.request.contextPath}/earlyWarn/earlyDataDetail',           
	        data:mData,        
	        success:function(data){ 
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
	        	$('#w').window('close');
	        	$.messager.alert('<spring:message code="Warning"/>',"获取失败。",'error');
	       	}
		});	
	}
}
/* 告警列表 */

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