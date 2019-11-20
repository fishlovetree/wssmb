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
<title>前台账号管理</title>
<style type="text/css">
    .ulRole
    {
        list-style-type: none;
        width: 95%;
        border: 1px solid #ddd;
        margin: 10px auto;
        padding: 5px;
    }
    .ulRole li
    {
        height: 25px;
        line-height: 25px;
        width: 120px;
        display: inline-block;
    }
</style>
<jsp:include page="../Header.jsp"/>
</head>
<body>	
<table id="dg" toolbar="#toolbar">
</table>
	<div id="toolbar">
		<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="addUser()"><spring:message code="Add"/></a>
		<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" onclick="editUser()"><spring:message code="Edit"/></a>
		<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="destroyUser()"><spring:message code="Delete"/></a>
		<label for="tblUserName">账号:</label>   
        <input class="easyui-textbox" type="text" id="tblUserName"  name="tblUserName" />  
        <label for="tblOrgName">组织机构名称:</label>   
        <input class="easyui-textbox" type="text" id="tblOrgName"  name="tblOrgName" />  
        <a href="javascript:void(0)" class="easyui-linkbutton button-edit button-default" data-options="iconCls:'icon-search'" onclick="doSearch()" title="Search">检索</a>
	</div>
		
<div id="dlg" class="easyui-dialog" style="width:450px;height:250px;padding:10px 20px" closed="true" buttons="#dlg-buttons">
	<form id="fm" class="easyui-form" method="post" >
	    <input type="hidden" id="usertype" name="usertype" value="1" />
        <table cellspacing="8">
            <tr class="tableTr">
                <td ><input class="easyui-textbox" type="text"
					style="width: 320px;" name="username"
					data-options="label:'账号',required:true,validType:['maxlength[25]', 'userlogin']"></input></td>
            </tr> 
            <tr class="tableTr">
                <td><select class="easyui-combotree" lines="true"
					url="${pageContext.request.contextPath}/organization/organizationTree?Math.random()"
					id="orgtree" style="width: 320px;" data-options="label:'组织机构',required:true,
					onSelect:function(node){
					    $('#organizationcode').val(node.name);
					}">
				</select><input type="hidden" id="organizationcode" name="organizationcode" /></td>
            </tr>      
            <tr class="tableTr">
                <td><input class="easyui-textbox" type="text" style="width: 320px;" name="remark" data-options="label:'备注',validType:'maxlength[100]'"></input></td>
            </tr>
        </table>
    </form>
</div>
<div id="dlg-buttons">
	<a href="#" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveUser()"><spring:message code="Save"/></a>
	<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">关闭</a>
</div>

<!-- 配置角色窗口 -->

<div id="roleWindow" class="easyui-dialog" style="width:550px;height:250px;" closed="true" buttons="#role-buttons">
	<ul class="ulRole">
	<c:forEach items="${requestScope.roleList}" var="item">
		<li><input type="checkbox" id="chk${item.id}" value="${item.id}"/><label for="chk${item.id}">${item.rolename}</label></li>
	</c:forEach> 
    </ul>
</div>
<div id="role-buttons" region="south" border="false" style="text-align:right;height:30px;line-height:30px;">
	<a href="#" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveUserRole()">设置</a>
	<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#roleWindow').dialog('close')">关闭</a>
</div>
<script type="text/javascript">	
	$(function(){  
	    $('#dg').datagrid({ 
	    	url :'${pageContext.request.contextPath}/user/userDataGrid?usertype=1',
	    	pagination : true,//分页控件
	    	pageList: [10, 20, 30, 40, 50],
	    	pageSize: 10,
	    	fit: true,   //自适应大小
	    	singleSelect: true,
	    	nowrap: true,//数据长度超出列宽时将会自动截取。
	    	multiSort:true,
	    	remoteSort:false,
	    	rownumbers:true,//行号
	        frozenColumns: [[
		        { field: 'id', title: '操作', width: 180, 
	                formatter: function (value, row, index) {
		                var r = "<a href='#' class='button-reset button-default' onclick='resetPwd(" + value + ",\"" + row.username + "\")'>重置密码 </a>";
		                var u = "<a href='#' class='button-setrole button-default' onclick='setRole(" + value + ")'>配置角色</a>";
		                return r + "&nbsp;" + u;
		            }
		        }
			]],
	        columns: [[  
	            { field: 'username', title: '账号', width: 100, sortable: true },
	            { field: 'organizationname', title: '组织机构', width: 150 },
	            { field: 'rolename', title: '角色', width: 150 },
	            { field: 'creatorname', title: '创建人', width: 100 },
	            { field: 'intime', title: '创建时间', width: 150 },
	            { field: 'remark', title: '备注', width: 200 }
	        ]],
	        onDblClickCell: function(index,field,value){
	      	   editUser();
	 		},
	 		onLoadSuccess:function(){
				$('.button-reset').linkbutton({ });
				$('.button-setrole').linkbutton({ });
			}
	    }) 	    	   
	}); 
	
	//根据条件检索
	function doSearch() {
		var organizationname = $.trim($("#tblOrgName").val());
	    var username = $.trim($("#tblUserName").val());

	    $("#dg").datagrid('load', {
	    	organizationname: organizationname,
	    	username: username,
	    	usertype: 0
	    });
	}
</script>

<script type="text/javascript">
var url = ""
function addUser(){
	$('#dlg').dialog('open').dialog('setTitle','添加');
	$('#fm').form('clear');
	$('#usertype').val(1);
	url = '${pageContext.request.contextPath}/user/addUser';
}

//编辑账号
function editUser(){
	var row = $('#dg').datagrid('getSelected');
	if (row){
		$('#dlg').dialog('open').dialog('setTitle','编辑');
		$('#fm').form('load',row);
		$('#orgtree').combotree('setValue', row.organizationcode);
		$('#orgtree').combotree('setText', row.organizationname);
		url = '${pageContext.request.contextPath}/user/editUser?id='+row.id;
	}
}	
//保存
function saveUser(){
	$('#fm').form('submit',{
		url: url,
		onSubmit: function(){
			return $(this).form('validate');
		},
		success: function(result){		
			if(result  == "success"){
				$('#dlg').dialog('close');		// close the dialog
				$('#dg').datagrid('reload');	// reload the user data
			}else if (result == "repeat"){
				$.messager.alert('提示','账号已存在。','warning');
			}
			else{
				$.messager.alert('警告','抱歉，出错了，请重试。','error');
			}
		}
	});
}

//删除账号
function destroyUser(){
	var row = $('#dg').datagrid('getSelected');
	if (row){
		$.messager.confirm('删除账号','确定要删除该账号吗？',function(r){
			if (r){
			  $.ajax({
				   type:'POST', 
		           url:'${pageContext.request.contextPath}/user/deleteUser',           
		           data:{"id":row.id},        
			       success:function(d){ 
			    	   if(d  == "success"){
							$('#dg').datagrid('reload');	// reload the user data
						}else{
							$.messager.alert('警告', "删除账号失败，请重试。",'error');
						}
			       
			        }
			  });
			}
		});
	}
}

//重置密码
function resetPwd(id, username) {
    $.messager.confirm('重置密码', '确定要重置该账号的密码吗？', function (r) {
        if (r) {
            $.ajax({
                type: 'post',
                url: '${pageContext.request.contextPath}/user/resetPassword',
                data: { "id": id, "username": username },
                success: function (d) {
                    if (d == "success")
                    	$.messager.alert('提示', '密码重置成功。', 'info');
                    else
                    	$.messager.alert('警告', '密码重置失败，请重试。', 'error');
                }
            });
        }
    });
}

var userid = ""; //所选账号id
//设置角色
function setRole(id) {
	userid = id;
	$('#roleWindow').dialog('open').dialog('setTitle', '配置角色');
	$.ajax({
        type: 'post',
        url: '${pageContext.request.contextPath}/user/getUserRoles',
        data: { "id": id },
        success: function (d) {
            if (d.length == 0){
            	//一个角色也没有                                                
                $(":checkbox").prop("checked", false);
            }
            else {          
                //清空checkbox
                $(":checkbox").prop("checked", false);
                //绑定checkbox                 
                $.each(d, function(i, n) {
                    $(":checkbox").each(function () {
                        if ($(this).val() == n) {
                            $(this).prop("checked", "checked");
                        }
                    });
                })
            }
        }
    });
}

//保存设置的角色
function saveUserRole() {
	var roles = [];
    $(":checkbox:checked").each(function () {
        roles.push($(this).val());
    });
    $.ajax({
		type:'POST', 
        url:'${pageContext.request.contextPath}/user/saveUserRoles',           
        data:{"id": userid, "roles": roles.join(',')},        
	       success:function(d){ 
	    	   if(d == "success"){
	    		   $('#roleWindow').dialog('close');		// close the dialog
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