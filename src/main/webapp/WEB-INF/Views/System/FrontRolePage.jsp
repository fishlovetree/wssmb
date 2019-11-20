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
<script type="text/javascript" src="${pageContext.request.contextPath}/js/Transfer.js"></script>
<link href="${pageContext.request.contextPath}/css/TransferStyle.css" rel="stylesheet" type="text/css">
<style type="text/css">
#divFm{
   position: absolute;
   top:50%;
   left:50%;
   margin-top: -55px;
   margin-left: -120px;
}
.tableTr{
    display:block; /*将tr设置为块体元素*/
    margin:10px 0;  /*设置tr间距为2px*/
}
.ulPermission
{
    list-style-type: none;
    width: 95%;
    border: 1px solid #ddd;
    margin: 10px auto;
    padding: 5px;
}
.ulPermission li
{
    height: 25px;
    line-height: 25px;
    width: 120px;
    display: inline-block;
}
</style>
</head>
<body>	
<table id="dg"  style="width: 100%;">
	</table>
	
<div id="toolbar">
	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="addRole()"><spring:message code="Add"/></a>
	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" onclick="editRole()"><spring:message code="Edit"/></a>
	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="destroyRole()"><spring:message code="Delete"/></a>
</div>

<div id="dlg" class="easyui-dialog" style="width:320px;height:250px;padding:10px 20px" closed="true" buttons="#dlg-buttons">
    <div id="divFm">
	    <form id="fm" class="easyui-form" method="post" >
	        <input type="hidden" id="roletype" name="roletype" value="1"/> 
            <table cellpadding="5" align="center">
                <tr class="tableTr">
                    <td ><input class="easyui-textbox" type="text" style="width:100%" name="rolename" data-options="label:'<spring:message code="RoleName"/>',required:true,validType:'nameValidate'"></input></td>
                </tr>             
                <tr class="tableTr">
                    <td><input class="easyui-textbox" type="text" style="width:100%" name="remark" data-options="label:'<spring:message code="RoleRemark"/>'"></input></td>
                </tr>
                
            </table>
        </form>
      </div>
</div>
<div id="dlg-buttons">
	<a href="#" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveRole()"><spring:message code="Save"/></a>
	<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">关闭</a>
</div>

<!-- 设置菜单窗口 -->
<div id="menuWindow" class="easyui-dialog" style="width:250px;height:400px;" closed="true" buttons="#user-buttons">
	<form id="setfm" method="post">	
	<table cellpadding="5" style="margin-left: 50px">
        <tr>
            <td ><ul id="tt" name="menuTree" class="easyui-tree" data-options="animate:true,checkbox:true,lines:true"></ul></td>
         </tr>             
     </table>
	</form>
</div>
 <div id="user-buttons" region="south" border="false" style="text-align:right;height:30px;line-height:30px;">
	<a href="#" class="easyui-linkbutton" iconCls="icon-ok" onclick="SetSubmit()"><spring:message code="Save"/></a>
	<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#menuWindow').dialog('close')">关闭</a>
</div>

<!--设置账户窗口 -->
<div id="w" class="easyui-window" title="<spring:message code="Set_Up_Account"/>"  closed="true" data-options="iconCls:'icon-save'" style="width:543px;height:500px;padding:5px;">
	<div class="easyui-layout" data-options="fit:true">
		<div data-options="region:'center'" style="padding:10px;">
	  		<div class="ty-transfer mt20 ml20" id="ued-transfer-1">
	    		<div class="fl ty-transfer-list transfer-list-left">
	        	    <div class="ty-transfer-list-head"><spring:message code="UnaddressedAccount"/></div>
		        	<div class="ty-transfer-list-body">
		           		 <ul class="ty-tree-select" id="left_ul">            
		            	</ul>
		        	</div>
				    <div class="ty-transfer-list-foot">
	                    <div class="ty-tree-div">
			                <div class="tyc-check-blue fl">
			                    <input type="checkbox" class="transfer-all-check" id="tyc-check-blue_left">
			                    <span>
			                    </span>
			                </div>
		                    <div class="ty-tree-text">全选</div>
	                    </div>
	                </div>
	    	    </div>
		    	<div class="fl ty-transfer-operation">
		       		<span class="ty-transfer-btn-toright to-switch">
		        	</span>
		        	<span class="ty-transfer-btn-toleft to-switch">
		       		</span>
		    	</div>
		    	<div class="fl ty-transfer-list transfer-list-right">
		        	<div class="ty-transfer-list-head"><spring:message code="AddedAccount"/></div>
		        	<div class="ty-transfer-list-body">
		            	<ul class="ty-tree-select" id="right_ul">
		
		            	</ul>
		        	</div>
		        	<div class="ty-transfer-list-foot">
			            <div class="ty-tree-div">
			                <div class="tyc-check-blue fl">
			                    <input type="checkbox" class="transfer-all-check" id="tyc-check-blue_right">
			                    <span>
			                    </span>
			                </div>
			                <div class="ty-tree-text">
			                 		   全选
			                </div>
			            </div>
		            </div>
		    	</div>
		    	<div class="clearboth">
		    	</div>      
			</div>
	    </div>			
		<div data-options="region:'south',border:false" style="text-align:right;padding:5px 0 0;">
			<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="SaveUser()" style="width:80px"><spring:message code="Save"/></a>
			<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="javascript:$('#w').window('close')" style="width:80px">关闭</a>
		</div>
	</div>
</div>
<!-- 特殊权限窗口 -->

<div id="permissionWindow" class="easyui-dialog" style="width:400px;height:200px;" closed="true" buttons="#permission-buttons">
	<ul class="ulPermission">
		<li><input type="checkbox" id="clinkage" value="1"/><label for="clinkage">设备联动</label></li>
    </ul>
</div>
<div id="permission-buttons" region="south" border="false" style="text-align:right;height:30px;line-height:30px;">
	<a href="#" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveRolePermissions()">保存</a>
	<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#permissionWindow').dialog('close')">关闭</a>
</div>
<script type="text/javascript">	
	$(function(){
	    $('#dg').datagrid({
			cls:"theme-datagrid", 
			singleSelect:true,
			//showFooter:true,
			cache:false,
			rownumbers:true,//显示序号
			pagination:true,
			nowrap: true,//数据长度超出列宽时将会自动截取。
			pageSize:10,
			loader: myLoader, //前端分页加载函数 
			toolbar:'#toolbar',
			collapsible:true,
			fit: true,   //自适应大小
			toolbar:'#toolbar',
			url:'${pageContext.request.contextPath}/sysRole/roleDataGrid?roletype=1',
			columns: [[  
				{title: '<spring:message code="RoleName"/>', field: 'rolename', width: '10%'},    	           	
				{title: '<spring:message code="RoleRemark"/>', field: 'remark', width: '10%'}, 
				{title: '创建人', field: 'creatorname', width: '10%'}, 
				{title: '创建时间', field: 'intime', width: '15%'}, 
				{title: '操作', field: 'id', width:'20%',formatter:Button},
				     ]],
			onDblClickCell: function(index,field,value){
				      	   editRole();
			},
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

		});	
		
		//刷新按钮点击事件
		var pager = $('#dg').datagrid('getPager');
		 pager.pagination({
		   // showRefresh:false,
		     onRefresh: function(index,field,value){
		    	 $("#dg").data().datagrid.cache = null; //清空缓存
		    	 $('#dg').datagrid('reload');	// reload the user data
			},
		});
	}) 
	
	function Button(value,row,index){
		return "<a href='#' class='button-edit button-default' onclick='SetMenu(\"" + row.id 
		  + "\",\"" + row.roletype + "\");'><spring:message code='SettingMenu'/></a> <a href='#' class='button-edit button-default' onclick='SetUser(&apos;" 
		  + row.id + "&apos;);'><spring:message code='SettingAccount'/></a>" + 
		  " <a href='#' class='button-edit button-default' onclick='setPermission(&apos;" + 
		  row.id + "&apos;);'>特殊权限</a>";  
	} 
	 
	//加载分页数据
	function myLoader(param, success, error) {  
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
	                success(bulidData(data));  
	            },  
	            error: function () {  
	                error.apply(this, arguments);  
	            	$.messager.alert('<spring:message code="Warning"/>',"获取失败。",'error');
	            }  
	        });  
	    } else {  
	        success(bulidData(cache));  
	    }  
	    
	    function bulidData(data) {  
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
</script>

<script type="text/javascript">
$("#ued-transfer-1").transferItem();
//添加角色
function addRole(){
	$('#dlg').dialog('open').dialog('setTitle','<spring:message code="AddRole"/>');
	$('#fm').form('clear');
	$('#roletype').val(1);
	url = '${pageContext.request.contextPath}/sysRole/addRole';
}

//编辑角色
function editRole(){
	var row = $('#dg').treegrid('getSelected');
	if (row){
		$('#dlg').dialog('open').dialog('setTitle','<spring:message code="EditRole"/>');
		$('#fm').form('load',row);
		//$('#xx').textbox('textbox').attr('readonly',true);  //设置输入框为禁用
		url = '${pageContext.request.contextPath}/sysRole/editRole?id='+row.id;
	}
}	
//保存
function saveRole(){
	$('#fm').form('submit',{
		url: url,
		onSubmit: function(){
			return $(this).form('validate');
		},
		success: function(result){		
			if(result=="success"){
				$('#dlg').dialog('close');		// close the dialog
				$("#dg").data().datagrid.cache = null; //清空缓存
				$('#dg').datagrid('reload');	// reload the user data
			}else{
				$.messager.alert('<spring:message code="Warning"/>',result,'error');
			}
		
		},
		  error:function(data){
			  $.messager.alert('<spring:message code="Warning"/>',result,'error');	        	
        }
	});
}

//删除角色
function destroyRole(){
	var row = $('#dg').datagrid('getSelected');
	if (row){
		$.messager.confirm('<spring:message code="DeleteCharacter"/>','<spring:message code="Delete_Character_Sure"/>',function(r){
			if (r){
				var data3={"id":row.id};   
				$.ajax({
					type:'POST', 
				    url:'${pageContext.request.contextPath}/sysRole/deleteRole',           
				    data:data3,        
					success:function(data){ 
			    	    if(data=="success"){
			    		    $("#dg").data().datagrid.cache = null; //清空缓存
							$('#dg').datagrid('reload');	// reload the user data
						}else{
							$.messager.alert('<spring:message code="Warning"/>',data,'error');
						}
					},	        
			        error:function(data){
			        	$.messager.alert('<spring:message code="Warning"/>',data,'error');
		            }
				});
			}
		});
	}
}
//弹出改角色的菜单树
function SetMenu(id, roletype){
	$('#menuWindow').dialog('open').dialog('setTitle','<spring:message code="FunctionMenu"/>');
	menuUrl = '${pageContext.request.contextPath}/sysRole/saveMenu?id='+id;
	$('#tt').tree({ 
		 cascadeCheck:true,
      	 url: '${pageContext.request.contextPath}/sysRole/menuTreeGrid?id='+id+'&roletype='+roletype+'&Math.random()',    
    });
}

//设置菜单
function SetSubmit(){
	//var nodes = $('#tt').tree('getChecked');	
	var nodes = $('#tt').tree('getChecked', ['checked','indeterminate']);
	var s =new Array();
	for(var i=0; i<nodes.length; i++){
		s[i]=nodes[i].id;
	}
	 $('#setfm').form('submit',{			
		 url:menuUrl+'&menuIdArray='+s,
		onSubmit: function(){
		return $(this).form('validate');
		},
		success: function(result){			
			if(result=="success"){
				$.messager.alert('<spring:message code="Prompt"/>','<spring:message code="SuccessOperation"/>','info');
				$('#menuWindow').dialog('close');
				//$('#dg').datagrid('reload');			
			}else{
				   $.messager.alert('<spring:message code="Warning"/>','<spring:message code="OperationFailed"/>','error');
			}
		
		},
		error:function(result){
			$.messager.alert('<spring:message code="Warning"/>',result,'error');
     } 
     
	}); 
}

//设置账户
function SetUser(id){
	var s=document.getElementById("tyc-check-blue_left");
	var s1=document.getElementById("tyc-check-blue_right");
	s.checked=false;
	s1.checked=false;
	leftUser(id);
	rightUser(id);
	 $('#w').window('open');
	 userUrl = '${pageContext.request.contextPath}/sysRole/setUser?roleid='+id;
}
//设置li元素
function setLi(userJson,ulid){
	for(var i in userJson){	
	var elem_li = document.createElement('li'); // 生成一个 li元素
	elem_li.setAttribute("id",userJson[i].id); 
	
    var elem_div = document.createElement('div'); // 生成一个div元素
    elem_div.className = 'ty-tree-div';  
    
    var elem_label = document.createElement('label'); // 生成一个label元素
    elem_label.className = 'tyue-checkbox-wrapper'; 
    
    var elem_span_01 = document.createElement('span'); // 生成一个span元素
    elem_span_01.className = "tyue-checkbox"; 
    
    var elem_span_02 = document.createElement('span'); // 生成一个span元素
    elem_span_02.className = "tyue-checkbox-txt"; 
    elem_span_02.innerHTML = userJson[i].username; 
    
    var elem_span_01_01 = document.createElement('span'); // 生成一个span元素
    elem_span_01_01.className = "tyue-checkbox-circle"; 
	
    var rinput = document.createElement("input"); // 生成一个input元素
    rinput.setAttribute("type","checkbox");
    rinput.setAttribute("id",'tyue-checkbox-blue'); 
    rinput.setAttribute("class",'tyue-checkbox-input'); 
	
    elem_span_01.appendChild(rinput);
    elem_span_01.appendChild(elem_span_01_01);
    elem_label.appendChild(elem_span_01);
    elem_label.appendChild(elem_span_02);	        
    elem_div.appendChild(elem_label); // 添加到UL中去
    elem_li.appendChild(elem_div); // 添加到UL中去
    document.getElementById(ulid).appendChild(elem_li); // 添加到UL中去   
	}
	
   // return elem_li;
}
//未添加的账户
function leftUser(id){ 
	$('#left_ul li').remove();
	var mData={"roleid":id, "roletype":1};
	 $.ajax({
          type : 'POST',
          url : '${pageContext.request.contextPath}/sysRole/getUnUserAdded',
          data :mData,
          success : function(data) {
        	  setLi(data,'left_ul');
          },
          error:function(data){
        	  $.messager.alert('<spring:message code="Warning"/>',data,'error');
      } 
      });
}

//已添加的账户
 function rightUser(id){ 
	 $('#right_ul li').remove();
	 var mData={"roleid":id};
	 $.ajax({
          type : 'POST',
          url : '${pageContext.request.contextPath}/sysRole/getUserAdded',
          data :mData,
          success : function(data) {
        	  setLi(data,'right_ul');
          },  
	  	  error:function(data){
	  		$.messager.alert('<spring:message code="Warning"/>',data,'error');
   		}
      });
} 
//保存账户
function SaveUser(){
	 var obj_lis = document.getElementById("right_ul").getElementsByTagName("li");
	 var s =new Array();
	  for(i=0;i<obj_lis.length;i++){
	    	s[i]=obj_lis[i].id;
	  }
		 $.ajax({
	          type : 'POST',
	          url : userUrl+'&array='+s,
	          data :'',
	          success : function(data) {
	        	  if(data=="success"){
	        			$.messager.alert('<spring:message code="Prompt"/>','<spring:message code="SuccessOperation"/>','info');
	  				 $('#w').window('close');		
	  			}else{
	  				 $.messager.alert('<spring:message code="Warning"/>','<spring:message code="OperationFailed"/>','error');
	  			}
	          },
	          error:function(data){
	        	  $.messager.alert('<spring:message code="Warning"/>',data,'error');
	      } 
	      });
	  
}

var _roleid;
//弹出设置角色特殊权限窗口
function setPermission(id){
	_roleid = id;
	$('#permissionWindow').dialog('open').dialog('setTitle','特殊权限');
	$.ajax({
        type: 'post',
        url: '${pageContext.request.contextPath}/sysRole/getRolePermissions',
        data: { "id": id },
        success: function (d) {
            if (d.length == 0){                                               
                $("#permissionWindow :checkbox").prop("checked", false);
            }
            else {          
                //清空checkbox
                $("#permissionWindow :checkbox").prop("checked", false);
                //绑定checkbox                 
                $.each(d, function(i, n) {
                    $("#permissionWindow :checkbox").each(function () {
                        if ($(this).val() == n) {
                            $(this).prop("checked", "checked");
                        }
                    });
                })
            }
        }
    });
}

//保存角色特殊权限
function saveRolePermissions(){
	var permissions = [];
    $("#permissionWindow :checkbox:checked").each(function () {
    	permissions.push($(this).val());
    });
    $.ajax({
		type:'POST', 
        url:'${pageContext.request.contextPath}/sysRole/setRolePermissions',           
        data:{"id": _roleid, "permissions": permissions.join(',')},        
	       success:function(d){ 
	    	   if(d == "success"){
	    		   $('#permissionWindow').dialog('close');		// close the dialog
	    		   $.messager.alert('提示', '特殊权限设置成功。', 'info');
			   }else{
			       $.messager.alert('警告', '出错了，请重试。', 'error');
			   }
	       }
	});
}
</script>
</body>
</html>