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
<title>用户告警方案</title>
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
.layout-split-west {
    border-right: 1px solid #ccc;
}
</style>
</head>
<body>	
<!-- 布局 -->	
<div class="easyui-layout" style="width:100%;height:100%;">
	<div id="west" region="west" iconCls="icon-organization" split="true" title="" style="width:280px;min-width:280px;" collapsible="true">
		<jsp:include page="../../CommonTree/customerTree.jsp"/>
	</div>
	
	<div data-options="region:'center',iconCls:'icon-ok'" title="">
		<table id="dg" style="width: 100%;"></table>
		<div id="toolbar">
			<label style="font-size:14px">状态:</label>
			<select class="easyui-combobox" name="status" id="status" style="width:110px;height:26px;" data-options="">
		    	<option value="0">禁用</option>
		        <option value="1" selected="selected">启用</option>
		        <option value="2">所有</option>
		 	</select>
		 	<a href="javascript:void(0)" class="easyui-linkbutton button-default" onclick="searchScheme()" >搜索</a>
			<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="addEvent()"><spring:message code="Add"/></a>
			<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" onclick="editEvent()"><spring:message code="Edit"/></a>
			<a href="#" class="easyui-linkbutton" data-options="iconCls:''" onclick="enableScheme()">启用</a>
			<a href="#" class="easyui-linkbutton" data-options="iconCls:''" onclick="disableScheme()">禁用</a>
		</div>
	</div>
</div>

<!-- 配置事件窗口 -->
<div id="eventWindow" class="easyui-dialog" style="width:550px;height:450px;" closed="true" buttons="#event-buttons">
    <div id="result-head" class="easyui-layout" fit="true">
		<div region="north" style="height: 35px;" split="false">
			<table border="0" cellspacing="8" cellpadding="8">
				<tr>
					<td style="width:40px;">
						用户：
					</td>
					<td>
						<label id='snode'></label>
					</td>
                </tr>
			</table>
		</div>
		<div data-options="region:'center'" width="100%" height="100%">	
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
	</div>
</div>
<div id="event-buttons" region="south" border="false" style="text-align:right;height:30px;line-height:30px;">
	<a href="#" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveAlarmEvent()"><spring:message code="Save"/></a>
	<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#eventWindow').dialog('close')"><spring:message code="Cancel"/></a>
</div>

<script type="text/javascript">	
//用于使chart自适应高度和宽度,通过窗体高宽计算容器高宽
var resizeDiv = function () {
	width=$('#west').width();//当有title时，width:284px;min-width:284px;；反之，则width:280px;min-width:280px;
	height=$('#west').height();
	if(window.innerHeight<height)
		height=window.innerHeight-38;//当有title时，window.innerHeight-38；反之，则window.innerHeight
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
		url:'${pageContext.request.contextPath}/alarmscheme/getDataGrid?Math.random()',
		queryParams: {
			alarmplantype : 1,
		 	status : 1
		},
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
			{title: '用户名称', field: 'customername', width: '150'},
			{title: '用户编号', field: 'customercode', width: '150'},
			{title: '状态', field: 'status', width: '100px',
				formatter:function(value,rowData,rowIndex){
					if(value==1)
						return "启用";
					else
						return "<span style='color:red'>禁用<span>";
            	}
			},  
			{title: '编制人', field: 'username', width: '100'}, 
			{title: '编制时间', field: 'compilationtime', width: '150'} 				
		]],
	 	onDblClickCell: function(index,field,value){
	 		editEvent();
		}, 
		onLoadSuccess:function(){
			$('.button-editEvent').linkbutton({ });
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

var treeTab = $('#region_tree');
//公用树点击事件
var node;
function treeClick(treeObj, n){
	if(typeof n!='undefined' ){
		node=n;
		treeTab = treeObj;
		$("#snode").html(node.text);
		searchScheme();
	}
}

function searchScheme() {
	var status = $("#status").combobox("getValue");
	$("#dg").datagrid('load', {
		alarmplantype : 1,
	 	type : node.type,
	 	gid : node.gid,
	 	name : node.name,
	 	status : status
    });
}

function enableScheme(){
	var row = $('#dg').datagrid('getSelected');
	if (row){
		$.messager.confirm('启用告警方案','确定要启用该告警方案吗？',function(r){
			if (r){
			  $.ajax({
				   type:'POST', 
		           url:'${pageContext.request.contextPath}/alarmscheme/enableScheme',           
		           data:{"id":row.id},        
			       success:function(d){ 
			    	   if(d  == "success"){
							$('#dg').datagrid('reload');	// reload the user data
						}else{
							$.messager.alert('警告', "启用告警方案失败，请重试。",'error');
						}
			       
			        }
			  });
			}
		});
	}
}

function disableScheme(){
	var row = $('#dg').datagrid('getSelected');
	if (row){
		$.messager.confirm('禁用告警方案','确定要禁用该告警方案吗？',function(r){
			if (r){
			  $.ajax({
				   type:'POST', 
		           url:'${pageContext.request.contextPath}/alarmscheme/deleteScheme',           
		           data:{"id":row.id},        
			       success:function(d){ 
			    	   if(d  == "success"){
							$('#dg').datagrid('reload');	// reload the user data
						}else{
							$.messager.alert('警告', "禁用告警方案失败，请重试。",'error');
						}
			       
			        }
			  });
			}
		});
	}
}

var schemeid = 0; //所选方案id
var customerid = 0; //所选方案用户id
//添加用户告警方案事件
function addEvent(){
	schemeid = 0;
	customerid = 0;
	if (node.type == commonTreeNodeType.customer) {
		customerid = node.gid;
		$.ajax({
			type:'POST', 
	        url:'${pageContext.request.contextPath}/alarmscheme/selectCountByCustomer',           
	        data:{"customerid": customerid, "alarmplantype": 1},        
		    success:function(d){ 
		    	if (d == 0){
		        	$("#snode").html(node.text);
		        	$('#eventWindow').dialog('open').dialog('setTitle', '配置用户方案事件');
		        	//清空checkbox
		         	$("#eventWindow input:checkbox").prop("checked", false);
		   		}else          
		   			$.messager.alert('警告', '该用户已存在告警方案，不能再添加！', 'error');
			}
		});
	} else {
		$("#snode").html("");
		$.messager.alert('提示', '请选择用户！', 'info');
	}
}

//编辑用户告警方案事件
function editEvent() {
	var row = $('#dg').datagrid('getSelected');
	$("#snode").html(row.customername);
	schemeid = row.id;
	customerid = row.customerid;
	$('#eventWindow').dialog('open').dialog('setTitle', '配置用户方案事件');
	$.ajax({
      type: 'post',
      url: '${pageContext.request.contextPath}/alarmscheme/getAlarmEvent',
      data: { "id": schemeid },
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
        data:{"id": schemeid, "customerid": customerid, "soundevents": soundevents.join(','), "smsevents": smsevents.join(',')},        
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
</script>
</body>
</html>