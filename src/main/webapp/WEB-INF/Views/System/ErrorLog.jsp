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
<jsp:include page="../Header.jsp"/>
<style type="text/css">
#detailError {
	border-right: 1px solid #000;
	border-bottom: 1px solid #000;
}

#detailError td {
	border-left: 1px solid #000;
	border-top: 1px solid #000;
	padding: 5px;
}
</style>
<table id="dg"  style="width: 100%;"
				toolbar="#toolbar" iconCls ="icon-save"
				rownumbers="true" pagination="true"
				fitColumns="true" singleSelect="true"
				 nowrap="true" fit="true">				
</table>	
		
<div id="toolbar">
	<div>   
		<select class="easyui-combotree"  style="width:300px"
							url="${pageContext.request.contextPath}/UnitFile/customerorganizationTreeGrid?Math.random()"
							name="organization" id="organization" style="width:100%;" data-options="label:'<spring:message code="Organization"/>'">
		</select>
        <label for="user">操作人:</label>   
        <input class="easyui-textbox" type="text" id="user"  name="user" />  
        
        <label for="time">时间:</label>   
        <input class="easyui-datetimebox" editable="fasle" type="text" style="width:150px" id="starttime"  name="starttime" /> 
        <label for="time">-</label>   
        <input class="easyui-datetimebox" editable="fasle" type="text" style="width:150px" id="endtime"  name="endtime" /> 
        

        <a href="javascript:void(0)" class="easyui-linkbutton button-edit button-default" data-options="iconCls:'icon-search'" onclick="doSearch()" title="Search">检索</a>
	</div>  	
</div>	
	
<script type="text/javascript">
$('#dg').datagrid({
	url :'${pageContext.request.contextPath}/errorLog/logInf',
	pagination : true,//分页控件
	pageList: [10, 20, 30, 40, 50],
	//title:"错误日志",
	fit: true,   //自适应大小
	singleSelect: true,
	iconCls : 'icon-save',
	border:false,
	nowrap: true,//数据长度超出列宽时将会自动截取。
	rownumbers:true,//行号
	fitColumns:true,//自动使列适应表格宽度以防止出现水平滚动。
	columns: [[
			{title: '操作', field: 'message', width:'100px',
				   formatter:function(value,rowData,rowIndex){
			        return "<a href='javascript:void(0)' class='easyui-linkbutton button-edit button-default' onclick='mngRol(&apos;" + rowData.logid + "&apos;);'>详细信息</a> ";
			
			   }  
			},	
			{title: '操作人', field: 'userid', width:'100px',
				formatter : function(value, rowData, rowIndex) {
            		if(rowData.user!=null){
						return rowData.user.username;
            		}else{
            			return value;
            		}
				}
			},
			{title: '异常时间', field: 'intime', width:'140px'},
			{title: '客户端IP地址', field: 'ip', width:'100px'},
			{title: '异常方法', field: 'action', width:'140px'},
			{title: '异常类', field: 'errorclass', width:'200px'},
			{title: '客户端浏览器', field: 'browser', width:'100px'},
			{title: '异常堆栈', field: 'stacktrace', width:'100px'},                       
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
});

function doSearch() {
	var organization="";
	var organizationnode= $('#organization').combotree('tree').tree('getSelected');
	if(null!=organizationnode){
		organization = organizationnode.name;
	}
    var user = $.trim($("#user").val());
    var starttime = $.trim($("#starttime").val());
    var endtime = $.trim($("#endtime").val());

    $("#dg").datagrid('load', {
    	organization: organization,
    	user: user,
    	starttime: starttime,
    	endtime: endtime
    });
}

function mngRol(logid){		
	$.ajax({
		type : 'POST',
		url : '${pageContext.request.contextPath}/errorLog/logDetails',
		//async : false,//同步方式
		data : {
			logid : logid
		},
		success : function(data) {
			if (data != "" || data != null) {
				var json = JSON.parse(data);
				//data就是你需要的数据
				$('#userid').text(json.user.username);
				$('#ip').text(json.ip);
				$('#errorclass').text(json.errorclass);
				$('#browser').text(json.browser);
				$('#stacktrace').text(json.stacktrace);
				$('#action').text(json.action);
				$('#intime').text(json.intime);
				$('#message').text(json.message);				
			}
		},
		error : function(data) {
			
		}

	});
	$('#inf').dialog('open').dialog('setTitle', '<spring:message code="Showthedetails"/>');
		 	
}

</script>

<div id="inf" class="easyui-dialog" style="width: 1030px; height: 500px; padding: 10px" closed="true" buttons="#inf-buttons">
		<table id="detailError" cellspacing="0" class="detailTable">
			<tr>
				<td style="width: 100px">异常时间</td>
				<td><label id="intime"></label></td>
			</tr>
			<tr>
				<td style="width: 100px">操作人</td>
				<td><label id=userid></label></td>
			</tr>
			<tr>
				<td style="width: 100px">客户端IP地址</td>
				<td><label id="ip"></label></td>
			</tr>
			<tr>
				<td style="width: 100px">客户端浏览器</td>
				<td><label id="browser"></label></td>
			</tr>
			<tr>
				<td style="width: 100px">异常方法</td>
				<td><p id="action" style="word-break: break-all;"></p></td>
			</tr>
			<tr>
				<td style="width: 100px">异常类</td>
				<td><p id="errorclass" style="word-break: break-all;"></p></td>
			</tr>
			<tr>
				<td style="width: 100px">异常消息</td>
				<td colspan="3">
						<p id="message" style="word-break: break-all;"></p>
				</td>
			</tr>
			<tr>
				<td style="width: 100px">异常堆栈</td>
				<td colspan="3">
						<p id="stacktrace" style="word-break: break-all;"></p>
				</td>
			</tr>
		</table>
	</div>
	<div id="inf-buttons">
		<a href="#" class="easyui-linkbutton button-edit button-default" iconCls="icon-cancel"
			onclick="javascript:$('#inf').dialog('close')">关闭</a>
	</div>
</body>
</html>