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
<title>代理告警方案</title>
<jsp:include page="../../Header.jsp"/>
<style type="text/css">
.tableTr td{
    padding:5px;  /*设置tr间距为2px*/
}
.ulEvent
{
    list-style-type: none;
    width: 95%;
    border: 1px solid #ddd;
    margin: 10px auto;
    padding: 5px;
}
.ulEvent li
{
    height: 25px;
    line-height: 25px;
    width: 150px;
    display: inline-block;
}
.switchbutton{
    margin:3px;
}
</style>
</head>
<body>	
<table id="dg" style="width: 100%;"></table>
<div id="toolbar">
	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" onclick="editScheme()"><spring:message code="Edit"/></a>
	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-redo'" onclick="entrust()">委托</a>
	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="unentrust()">取消委托</a>
	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-set'" onclick="setEvent()">配置事件</a>
</div>

<!-- 修改弹出框 -->
<div id="dlg" class="easyui-dialog" style="width:500px;height:350px;padding:10px 20px;" closed="true" buttons="#dlg-buttons">
    <form id="fm" class="easyui-form" method="post" enctype="multipart/form-data">
        <input type="hidden" id="proxyid" name="proxyid"> 
        <input type="hidden" id="mandatary" name="mandatary"> 
        <table cellspacing="8">   
            <tr class="tableTr">
                <td>
                    <input class="easyui-textbox" type="text"
					style="width: 280px;" id="organizationname" name="organizationname" readonly="readonly"
					data-options="label:'代理名称'"></input>
                </td>      
            </tr>          
            <tr class="tableTr">
                <td>
                    <input class="easyui-numberbox" type="text"
					style="width: 280px;" id="almenathreshold" name="almenathreshold"
					data-options="label:'告警通知响应处理超时时间',required:true"></input>
                </td>      
            </tr>
            <tr class="tableTr"> 
                <td>
                    <label class="textbox-label textbox-label-before" style="height:30px;line-height:30px;margin-right:-4px;">是否配备告警前置机</label>
                    <span class="textbox" style="height:30px;width:150px;">
                    <input class="easyui-switchbutton" type="text"
					id="fepconfig"
					data-options="onText:'配备',offText:'不配备'"></input>
					</span>
                </td>  
            </tr>
            <tr class="tableTr"> 
                <td>
                    <label class="textbox-label textbox-label-before" style="height:30px;line-height:30px;margin-right:-4px;">是否配备语音拨号器</label>
                    <span class="textbox" style="height:30px;width:150px;">
                    <input class="easyui-switchbutton" type="text"
					id="dialerconfig"
					data-options="onText:'配备',offText:'不配备'"></input>
					</span>
                </td>
            </tr>
            <tr class="tableTr">
                <td>
                    <input class="easyui-numberbox" type="text"
					style="width: 280px;" id="dialernum" name="dialernum"
					data-options="label:'语音拨号器个数',required:true"></input>
                </td>  
            </tr>
            <tr class="tableTr">
                <td>
                    <input class="easyui-textbox" type="text"
					style="width: 280px;" id="dialermodel" name="dialermodel"
					data-options="label:'语音拨号器型号',validType:'maxlength[30]'"></input>
                </td>  
            </tr>
            <tr class="tableTr">
                <td>
                    <input class="easyui-textbox" type="text" readonly="readonly"
					style="width: 280px;word-break: break-all;" id="soundcontent" name="soundcontent"
					data-options="label:'语音内容'"></input>
                </td>  
            </tr>
            <tr class="tableTr">
                <td>
                    <input class="easyui-numberbox" type="text"
					style="width: 280px;" id="soundplaytime" name="soundplaytime"
					data-options="label:'语音循环播放次数',required:true,min:2,max:99"></input>
                </td>  
            </tr>
            <tr class="tableTr"> 
                <td>
                    <select class="easyui-combobox" id="dialmode" name="dialmode" 
                    data-options="label:'拨号方式',required:true" style="width: 280px;">
                        <option value="0" selected="selected">自动拨号</option>
                        <option value="1">人工手动拨号</option>
                        <option value="2">人工自动拨号</option>
                    </select>
                </td>
            </tr>
            <tr class="tableTr">
                <td>
                    <label class="textbox-label textbox-label-before" style="height:30px;line-height:30px;margin-right:-4px;">是否配备短信猫</label>
                    <span class="textbox" style="height:30px;width:170px;">
                    <input class="easyui-switchbutton" type="text"
					id="smsconfig"
					data-options="onText:'配备',offText:'不配备'"></input>
					</span>
                </td>  
            </tr>
            <tr class="tableTr">
                <td>
                    <input class="easyui-numberbox" type="text"
					style="width: 280px;" id="smsnum" name="smsnum"
					data-options="label:'短信猫个数',required:true"></input>
                </td>  
            </tr>
            <tr class="tableTr">
                <td>
                    <input class="easyui-textbox" type="text"
					style="width: 280px;" id="smsmodel" name="smsmodel"
					data-options="label:'短信猫型号',validType:'maxlength[30]'"></input>
                </td>  
            </tr>
            <tr class="tableTr">
                <td>
                    <input class="easyui-textbox" type="text" readonly="readonly"
					style="width: 280px;word-break: break-all;" id="smscontent" name="smscontent"
					data-options="label:'短信内容'"></input>
                </td>  
            </tr>
            <tr class="tableTr">  
                <td>
                    <select class="easyui-combobox" id="smsmode" name="smsmode" 
                    data-options="label:'短信发送方式',required:true" style="width: 280px;">
                        <option value="0" selected="selected">无需告警</option>
                        <option value="1">自动发送</option>
                    </select>
                </td>
            </tr>
        </table>
    </form>
</div>
<div id="dlg-buttons">
	<a href="#" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveScheme()"><spring:message code="Save"/></a>
	<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')"><spring:message code="Cancel"/></a>
</div>
<!-- 配置事件窗口 -->
<div id="eventWindow" class="easyui-dialog" style="width:550px;height:450px;" closed="true" buttons="#event-buttons">
    <div>
        <ul class="ulEvent" id="ulEvent">
            <li style="width:100%"><input type="checkbox" value="-1"/><label>全选</label></li>
			<c:forEach items="${requestScope.eventList}" var="item">
				<li><input type="checkbox" id="eventck${item.detailvalue}" value="${item.detailvalue}"/><label for="eventck${item.detailvalue}">${item.detailname}</label></li>
			</c:forEach> 
		</ul>
    </div>
</div>
<div id="event-buttons" region="south" border="false" style="text-align:right;height:30px;line-height:30px;">
	<a href="#" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveAlarmEvent()"><spring:message code="Save"/></a>
	<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#eventWindow').dialog('close')"><spring:message code="Cancel"/></a>
</div>
<script type="text/javascript">	

$(function(){

	$('#dg').datagrid({
		url:'${pageContext.request.contextPath}/proxyAlarmPlan/getDataGrid?plantype=1',
		singleSelect:true,
		remoteSort:false,
		nowrap: true,//数据长度超出列宽时将会自动截取。
		rownumbers:true,//显示序号
		toolbar:'#toolbar',
		pagination:true,
		pageSize:10,
		collapsible:true,
		fit: true,   //自适应大小
		columns: [[  
		    {title: '代理名称', field: 'organizationname', width: '150'},
			{title: '代理编号', field: 'organizationcode', width: '150'},
			{title: '是否委托', field: 'mandatary', width: '60', formatter: function(value, row, index){
				return value == 1 ? "是" : "否";
			}},
			{title: '告警通知响应处理超时时间', field: 'almenathreshold', width: '150'},
			{title: '是否配备告警前置机', field: 'fepconfig', width: '150', formatter: function(value, row, index){
				return value == 1 ? "配备" : "不配备";
			}},
			{title: '是否配备语音拨号器', field: 'dialerconfig', width: '150', formatter: function(value, row, index){
				return value == 1 ? "配备" : "不配备";
			}},
			{title: '语音拨号器个数', field: 'dialernum', width: '80'},
			{title: '语音拨号器型号', field: 'dialermodel', width: '120'},
			{title: '语音内容', field: 'soundcontent', width: '150', formatter: function(value, row, index){
				return "<span title='" + value + "'>" + value + "</span>";
			}}, 
			{title: '语音播放次数', field: 'soundplaytime', width: '80'}, 
			{title: '拨号方式', field: 'dialmode', width: '100', formatter: function(value, row, index){
				if (value == 0){
					return "自动拨号";
				}
				else if (value == 1){
					return "人工手动拨号";
				}
				else if (value == 2) {
					return "人工自动拨号";
				}
				else{
					return "";
				}
			}}, 
			{title: '是否配备短信猫', field: 'smsconfig', width: '150', formatter: function(value, row, index){
				return value == 1 ? "配备" : "不配备";
			}},
			{title: '短信猫个数', field: 'smsnum', width: '80'},
			{title: '短信猫型号', field: 'smsmodel', width: '120'},
			{title: '短信内容', field: 'smscontent', width: '150', formatter: function(value, row, index){
				return "<span title='" + value + "'>" + value + "</span>";
			}}, 
			{title: '短信告警方式', field: 'smsmode', width: '100', formatter: function(value, row, index){
				if (value == 0){
					return "无需告警";
				}
				else if (value == 1){
					return "自动发送";
				}
				else{
					return "";
				}
			}}
		]],
	 	onDblClickCell: function(index,field,value){
			editScheme();
		}
	});	
	
	//事件全选与反全选
	$("#ulEvent li:first").find("input:checkbox").click(function(){
		if ($(this).prop("checked")){
			$("#ulEvent li:first").siblings("li").find("input:checkbox").prop("checked", "checked");
		}
		else{
			$("#ulEvent li:first").siblings("li").find("input:checkbox").prop("checked", false);
		}
	});
})   

var url = ""
//修改告警方案
function editScheme(){
	var row = $('#dg').datagrid('getSelected');
	if (row){
		$('#dlg').dialog('open').dialog('setTitle','编辑');
		$('#fm').form('load',row);
		$('#organizationname').text(row.organizationname);
		row.fepconfig == 1 ? $("#fepconfig").switchbutton('check') : $("#fepconfig").switchbutton('uncheck');
		row.dialerconfig == 1 ? $("#dialerconfig").switchbutton('check') : $("#dialerconfig").switchbutton('uncheck');
		$('#dialernum').numberbox('setValue', row.dialernum);
		$('#soundplaytime').numberbox('setValue', row.soundplaytime);
		row.smsconfig == 1 ? $("#smsconfig").switchbutton('check') : $("#smsconfig").switchbutton('uncheck');
		$('#smsnum').numberbox('setValue', row.smsnum);
		url = '${pageContext.request.contextPath}/proxyAlarmPlan/editScheme?id='+row.id;
	}
	else{
		$.messager.alert('<spring:message code="Warning"/>',"请先选择告警方案。",'info');
	}
}	
	
//保存
function saveScheme(){
	$('#fm').form('submit',{
		url: url,
		queryParams: {proxyid: $("#proxyid").val(),
			    fepconfig: document.getElementById("fepconfig").checked ? 1 : 0, 
			    almenathreshold: $("#almenathreshold").numberbox('getValue'),
			    mandatary: $("#mandatary").val(),
				dialerconfig: document.getElementById("dialerconfig").checked ? 1 : 0,
				dialernum: $("#dialernum").numberbox('getValue'),
				soundplaytime: $("#soundplaytime").numberbox('getValue'),
				dialmode: $("#dialmode").combobox('getValue'),
				smsconfig: document.getElementById("smsconfig").checked ? 1 : 0,
				smsnum: $("#smsnum").val(),
				smsmode: $("#smsmode").combobox('getValue')},
		onSubmit: function(){
			return $(this).form('validate');
		},
		success: function(result){	
			if(result=="success"){
				$('#dlg').dialog('close');	
				$('#dg').datagrid('reload');		
			}else if (result=="repeat"){
				$.messager.alert('<spring:message code="Warning"/>',"该代理的告警方案已编制。",'info');
			}
			else{
				$.messager.alert('<spring:message code="Warning"/>',result,'error');
			}
		
		},
		error:function(data){
			$.messager.alert('<spring:message code="Warning"/>',data,'error');	        	
        }
	});
} 

var schemeid = ""; //所选方案id
//设置告警方案事件
function setEvent() {
	var row = $('#dg').datagrid('getSelected');
	if (row){
		schemeid = row.id;
		$('#eventWindow').dialog('open').dialog('setTitle', '配置事件');
		$.ajax({
	      type: 'post',
	      url: '${pageContext.request.contextPath}/proxyAlarmPlan/getAlarmEvent',
	      data: { "id": schemeid },
	      success: function (d) {
	          if (d.length == 0){
	          	//一个事件也没有                                                
	              $("#eventWindow input:checkbox").prop("checked", false);
	          }
	          else {          
	              //清空checkbox
	              $("#eventWindow input:checkbox").prop("checked", false);
	              //绑定checkbox                 
	              $.each(d, function(i, n) {
	            	  $("#eventck" + n.eventid).prop("checked", "checked");
	              })
	          }
	      }
	    });
	}
	else{
		$.messager.alert('<spring:message code="Warning"/>',"请选择告警方案。",'info');
	}
}

//保存设置的事件
function saveAlarmEvent() {
	var events = []
    $("#ulEvent input:checkbox:checked").each(function () {
    	if ($(this).val() != -1){
    		events.push($(this).val());
    	}
    });
    $.ajax({
		type:'POST', 
        url:'${pageContext.request.contextPath}/proxyAlarmPlan/saveAlarmEvent',           
        data:{"id": schemeid, "events": events.join(',')},        
	       success:function(d){ 
	    	   if(d == "success"){
	    		   $('#eventWindow').dialog('close');		// close the dialog
				   $('#dg').datagrid('reload');	    // reload the user data
			   }else{
			       $.messager.alert('警告', '出错了，请重试。', 'error');
			   }
	       }
	});
}

//设置告警委托
function entrust() {
	var row = $('#dg').datagrid('getSelected');
	if (row){
		if (row.mandatary > 0) {
			$.messager.alert('<spring:message code="Warning"/>',"已委托，无需再次委托。",'info');
			return false;
		}
	    $.messager.confirm('确认','委托后告警将上报到更高一级代理，确定进行委托吗？',function(r){
			if (r){
			  $.ajax({
				   type:'POST', 
		           url:'${pageContext.request.contextPath}/proxyAlarmPlan/entrust',           
		           data:{"id":row.id},        
			       success:function(d){ 
			    	   if(d  == "success"){
			    		   $.messager.alert('提示', "委托成功。",'info');
			    		   $('#dg').datagrid('reload');	// reload the user data
						}else{
							$.messager.alert('警告', "委托失败，请重试。",'error');
						}
			       
			        }
			  });
			}
		});
	}
    else{
		$.messager.alert('<spring:message code="Warning"/>',"请选择告警方案。",'info');
	}
}


//取消告警委托
function unentrust() {
	var row = $('#dg').datagrid('getSelected');
	if (row){
		if (row.mandatary == 0) {
			$.messager.alert('<spring:message code="Warning"/>',"没有进行委托，无需取消委托。",'info');
			return false;
		}
	    $.messager.confirm('确认','取消委托后告警将不再上报到更高一级代理，确定取消委托吗？',function(r){
			if (r){
			  $.ajax({
				   type:'POST', 
		           url:'${pageContext.request.contextPath}/proxyAlarmPlan/unentrust',           
		           data:{"id":row.id},        
			       success:function(d){ 
			    	   if(d  == "success"){
			    		   $.messager.alert('提示', "取消委托成功。",'info');
			    		   $('#dg').datagrid('reload');	// reload the user data
						}else{
							$.messager.alert('警告', "取消委托失败，请重试。",'error');
						}
			       
			        }
			  });
			}
		});
	}
    else{
		$.messager.alert('<spring:message code="Warning"/>',"请选择告警方案。",'info');
	}
}
</script>
</body>
</html>