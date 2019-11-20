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
<title>管理员告警方案</title>
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
.tabs li.tabs-selected a.tabs-inner{
    color: red;
}
</style>
</head>
<body>	
<table id="dg" style="width: 100%;"></table>
<div id="toolbar">
	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="addScheme()"><spring:message code="Add"/></a>
	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" onclick="editScheme()"><spring:message code="Edit"/></a>
	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="destroyScheme()"><spring:message code="Delete"/></a>
</div>

<!-- 添加修改弹出框 -->
<div id="dlg" class="easyui-dialog" style="width:460px;height:350px;padding:10px 20px;" closed="true" buttons="#dlg-buttons">
    <form id="fm" class="easyui-form" method="post" enctype="multipart/form-data">
         <input type="hidden" name="customerid" id="customerid" value="0"/>
         <input type="hidden" name="alarmplantype" id="alarmplantype" value="0"/>
         <table cellpadding="5" align="center">          
            <tr class="tableTr">
                <td>
                    <label>语言告警</label>
                </td>      
                <td>
                    <input class="easyui-switchbutton" id="soundalarm" data-options="onText:'开启',offText:'关闭'">
                </td>
            </tr>
            <tr class="tableTr">
                <td>
                    <label>语音内容</label>
                </td>     
                <td>
                    <p id="soundcontent" style="word-break: break-all;"></p>
                </td>
            </tr>
            <tr class="tableTr">
                <td>
                    <label>语音播放次数</label>
                </td>    
                <td>
                    <input type="text" id="soundplaytime" class="easyui-numberbox" data-options="required:true,min:3,max:99"/>
                </td>
            </tr>
            <tr class="tableTr">
                <td>
                    <label>短信告警</label>
                </td>  
                <td>
                    <input class="easyui-switchbutton" id="smsalarm" data-options="onText:'开启',offText:'关闭'">
                </td>
            </tr>
            <tr class="tableTr">
                <td>
                    <label>短信内容</label>
                </td>
                <td>
                    <p id="smscontent" style="word-break: break-all;"></p>
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
    <div class="easyui-tabs" fit="true">
        <div title="语音告警">
            <ul class="ulEvent" id="soundUl">
            <li style="width:100%"><input type="checkbox" value="-1"/><label>全选</label></li>
			<c:forEach items="${requestScope.eventList}" var="item">
				<li><input type="checkbox" id="soundck${item.detailvalue}" value="${item.detailvalue}"/><label for="soundck${item.detailvalue}">${item.detailname}</label></li>
			</c:forEach> 
		    </ul>
        </div>
        <div title="短信告警">
            <ul class="ulEvent" id="smsUl">
            <li style="width:100%"><input type="checkbox" value="-1"/><label>全选</label></li>
			<c:forEach items="${requestScope.eventList}" var="item">
				<li><input type="checkbox" id="smsck${item.detailvalue}" value="${item.detailvalue}"/><label for="smsck${item.detailvalue}">${item.detailname}</label></li>
			</c:forEach> 
		    </ul>
        </div>
    </div>
</div>
<div id="event-buttons" region="south" border="false" style="text-align:right;height:30px;line-height:30px;">
	<a href="#" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveAlarmEvent()"><spring:message code="Save"/></a>
	<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#eventWindow').dialog('close')"><spring:message code="Cancel"/></a>
</div>

<!-- 配置人员窗口 -->
<div id="userWindow" class="easyui-dialog" style="width:640px;height:450px;" closed="true" buttons="#user-buttons">
    <table id="userTbl"></table>
    <div id="usertoolbar">
        <form id="userfm" class="easyui-form" method="post" >
            <table cellspacing="5">
                <tr>
                   <td><input class="easyui-textbox" type="text"
					style="width: 120px;" id="userName"
					data-options="label:'姓名',required:true,validType:'maxlength[25]'"></input></td>
				<td><input class="easyui-textbox" type="text"
					style="width: 160px;" id="phone"
					data-options="label:'电话',required:true,validType:'mobile'"></input></td>
				<td><select class="easyui-combobox"
					style="width: 140px;" id="alarmType" data-options="label:'类型',editable: false,required:true">
					<option value="1">语音告警</option>
                    <option value="2">短信告警</option>
					</select></td>
				<td><input class="easyui-numberbox" type="text"
					style="width: 90px;" id="groupindex"
					data-options="label:'排序',required:true"></input></td>
				<td><a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="addUser()"><spring:message code="Add"/></a></td>
                </tr> 
            </table>
        </form>
	</div>
</div>
<div id="user-buttons" region="south" border="false" style="text-align:right;height:30px;line-height:30px;">
	<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#userWindow').dialog('close')">关闭</a>
</div>
<script type="text/javascript">	

$(function(){
	$('#dg').datagrid({
		url:'${pageContext.request.contextPath}/alarmscheme/getDataGrid?alarmplantype=0',
		singleSelect:true,
		remoteSort:false,
		nowrap: true,//数据长度超出列宽时将会自动截取。
		rownumbers:true,//显示序号
		toolbar:'#toolbar',
		pagination:true,
		pageSize:10,
		collapsible:true,
		fit: true,   //自适应大小
		frozenColumns: [[
   			{title: '操作', field: 'id', width:'180',formatter: function(value, row, index){
   				var r = "<a href='#' class='button-setevent button-default' onclick='setEvent(" + value + ")'>配置事件 </a>";
   			    var u = "<a href='#' class='button-setuser button-default' onclick='setUser(" + value + ")'>配置人员</a>";
   			    return r + " " + u;
   			}}       
   		]],
		columns: [[  
			{title: '语音告警', field: 'soundalarm', width: '80', formatter: function(value, row, index){
				return value == 1 ? "<span style='color:green'>支持</span>" : "<span style='color:red'>不支持</span>";
			}}, 
			{title: '语音内容', field: 'soundcontent', width: '150', formatter: function(value, row, index){
				return "<span title='" + value + "'>" + value + "</span>";
			}}, 
			{title: '语音播放次数', field: 'soundplaytime', width: '80'}, 
			{title: '短信告警', field: 'smsalarm', width: '80', formatter: function(value, row, index){
				return value == 1 ? "<span style='color:green'>支持</span>" : "<span style='color:red'>不支持</span>";
			}}, 
			{title: '短信内容', field: 'smscontent', width: '150', formatter: function(value, row, index){
				return "<span title='" + value + "'>" + value + "</span>";
			}}, 
			{title: '编制人', field: 'username', width: '100'}, 
			{title: '编制时间', field: 'compilationtime', width: '150'} 				
		]],
	 	onDblClickCell: function(index,field,value){
			editScheme();
		}, 
		onLoadSuccess:function(){
			$('.button-setevent').linkbutton({ });
			$('.button-setuser').linkbutton({ });
		}	
	});	
	
	//事件全选与反全选
	$("#soundUl li:first").find("input:checkbox").click(function(){
		if ($(this).prop("checked")){
			$("#soundUl li:first").siblings("li").find("input:checkbox").prop("checked", "checked");
		}
		else{
			$("#soundUl li:first").siblings("li").find("input:checkbox").prop("checked", false);
		}
	});
	$("#smsUl li:first").find("input:checkbox").click(function(){
		if ($(this).prop("checked")){
			$("#smsUl li:first").siblings("li").find("input:checkbox").prop("checked", "checked");
		}
		else{
			$("#smsUl li:first").siblings("li").find("input:checkbox").prop("checked", false);
		}
	});
})   

var url = ""
function addScheme(){
	$('#dlg').dialog('open').dialog('setTitle','添加');
	$('#fm').form('clear');
	$('#customerid').val(0);
	$('#alarmplantype').val(0);
	$('#soundplaytime').numberbox('setValue', 3); //默认值
	url = '${pageContext.request.contextPath}/alarmscheme/addScheme';
}

//修改告警方案
function editScheme(){
	var row = $('#dg').datagrid('getSelected');
	if (row){
		$('#dlg').dialog('open').dialog('setTitle','编辑');
		$('#fm').form('load',row);
		$('#soundplaytime').numberbox('setValue', row.soundplaytime);
		row.soundalarm == 1 ? $("#soundalarm").switchbutton('check') : $("#soundalarm").switchbutton('uncheck');
		row.smsalarm == 1 ? $("#smsalarm").switchbutton('check') : $("#smsalarm").switchbutton('uncheck');
		$('#soundcontent').text(row.soundcontent);
		$('#smscontent').text(row.smscontent);
		url = '${pageContext.request.contextPath}/alarmscheme/editScheme?id='+row.id;
	}
}	
	
//保存
function saveScheme(){
	$('#fm').form('submit',{
		url: url,
		queryParams: {soundalarm: document.getElementById("soundalarm").checked ? 1 : 0, 
				soundplaytime: $("#soundplaytime").numberbox('getValue'),
				smsalarm: document.getElementById("smsalarm").checked ? 1 : 0},
		onSubmit: function(){
			return $(this).form('validate');
		},
		success: function(result){	
			if(result=="success"){
				$('#dlg').dialog('close');	
				$('#dg').datagrid('reload');		
			}else if (result=="repeat"){
				$.messager.alert('<spring:message code="Warning"/>',"添加失败，管理员的告警方案已编制。",'info');
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

function destroyScheme(){
	var row = $('#dg').datagrid('getSelected');
	if (row){
		$.messager.confirm('删除告警方案','确定要删除该告警方案吗？',function(r){
			if (r){
			  $.ajax({
				   type:'POST', 
		           url:'${pageContext.request.contextPath}/alarmscheme/deleteScheme',           
		           data:{"id":row.id},        
			       success:function(d){ 
			    	   if(d  == "success"){
							$('#dg').datagrid('reload');	// reload the user data
						}else{
							$.messager.alert('警告', "删除告警方案失败，请重试。",'error');
						}
			       
			        }
			  });
			}
		});
	}
}

var schemeid = ""; //所选方案id
//设置告警方案事件
function setEvent(id) {
	schemeid = id;
	$('#eventWindow').dialog('open').dialog('setTitle', '配置事件');
	$.ajax({
      type: 'post',
      url: '${pageContext.request.contextPath}/alarmscheme/getAlarmEvent',
      data: { "id": id },
      success: function (d) {
          if (d.length == 0){
          	//一个角色也没有                                                
              $("#eventWindow input:checkbox").prop("checked", false);
          }
          else {          
              //清空checkbox
              $("#eventWindow input:checkbox").prop("checked", false);
              //绑定checkbox                 
              $.each(d, function(i, n) {
            	  if (n.alarmtype == 1){ //语音
            		  $("#soundck" + n.eventid).prop("checked", "checked");
            	  }
            	  else if (n.alarmtype == 2){ //短信
            		  $("#smsck" + n.eventid).prop("checked", "checked");
            	  }
              })
          }
      }
  });
}

//保存设置的事件
function saveAlarmEvent() {
	var soundevents = [], smsevents = [];
    $("#soundUl input:checkbox:checked").each(function () {
    	if ($(this).val() != -1){
    		soundevents.push($(this).val());
    	}
    });
    $("#smsUl input:checkbox:checked").each(function () {
    	if ($(this).val() != -1){
    		smsevents.push($(this).val());
    	}
    });
    $.ajax({
		type:'POST', 
        url:'${pageContext.request.contextPath}/alarmscheme/saveAlarmEvent',           
        data:{"id": schemeid, "soundevents": soundevents.join(','), "smsevents": smsevents.join(',')},        
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

//设置告警方案用户
function setUser(id) {
	schemeid = id;
	$('#userfm').form('clear');
	$('#userWindow').dialog('open').dialog('setTitle', '配置人员');
	//初始化人员列表
	$('#userTbl').datagrid({
		url:'${pageContext.request.contextPath}/alarmscheme/getAlarmUser?id=' + id,
		remoteSort:false,
		nowrap: true,//数据长度超出列宽时将会自动截取。
		rownumbers:true,//显示序号
		collapsible:true,
		toolbar:'#usertoolbar',
		fit: true,   //自适应大小
		columns: [[  
            {title: '操作', field: 'id', width:'60px',formatter: function(value, row, index){
				return "<a href='#' class='button-reset button-default' onclick='removeUser(" + value + ")'>删除 </a>";
			}},
			{title: '告警类型', field: 'alarmtype', width: '80px',formatter: function(value, row, index){
				if (value == 1) return "语音告警";
				else if (value == 2) return "短信告警";
				else return value;
			}},
			{title: '姓名', field: 'username', width: '120px'},
			{title: '电话', field: 'phone', width: '140px'},
			{title: '排序', field: 'groupindex', width: '80px'}				
		]], 
		onLoadSuccess:function(){
			$('.button-default').linkbutton({ });
		}	
	});	
}

function addUser(){
	$('#userfm').form('submit',{
		url: '${pageContext.request.contextPath}/alarmscheme/addAlarmUser',
		queryParams: {planid: schemeid, alarmtype: $("#alarmType").combobox('getValue'), 
			username: $("#userName").val(), phone: $("#phone").val(), groupindex: $("#groupindex").numberbox('getValue')},
		onSubmit: function(){
			return $(this).form('validate');
		},
		success: function(result){	
			if(result=="success"){
				$('#userTbl').datagrid('reload');		
			}else if (result=="repeat"){
				$.messager.alert('<spring:message code="Warning"/>',"该告警方案中已存在该电话。",'info');
			}else{
				$.messager.alert('<spring:message code="Warning"/>',result,'error');
			}
		
		},
		error:function(data){
			$.messager.alert('<spring:message code="Warning"/>',data,'error');	        	
        }
	});
}

function removeUser(id){
	$.messager.confirm('删除告警人员','确定要删除该告警人员吗？',function(r){
		if (r){
		  $.ajax({
			   type:'POST', 
	           url:'${pageContext.request.contextPath}/alarmscheme/deleteAlarmUser',           
	           data:{"id":id},        
		       success:function(d){ 
		    	   if(d  == "success"){
						$('#userTbl').datagrid('reload');	// reload the user data
					}else{
						$.messager.alert('警告', "删除告警人员失败，请重试。",'error');
					}
		       
		        }
		  });
		}
	});
}
</script>
</body>
</html>