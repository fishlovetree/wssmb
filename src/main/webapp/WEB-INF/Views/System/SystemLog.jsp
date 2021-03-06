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
<body>
<table id="dg" style="width: 100%;"
				toolbar="#toolbar" iconCls ="icon-save"
				rownumbers="true" pagination="true"
				fitColumns="true" singleSelect="true"
				 nowrap="true" fit="true">				
</table>	

		
<div id="toolbar">
	<div> 
	<form id ="exfm" class="easyui-form" method="post">
       <table>
       <tr>
	       <td>
	       		<label for="organization"><spring:message code="Organization"/>:</label>   
	       </td>
        <td>
				<select class="easyui-combotree"  style="width:310px"
									url="${pageContext.request.contextPath}/UnitFile/customerorganizationTreeGrid?Math.random()"
									name="organization" id="organization">
				</select>
				<input type="hidden" id="organizationcode" name="organizationcode"/>
			</td>
        	<td>
		        <label for="user">操作人:</label> 
		    </td>
        	<td>  
		        <input class="easyui-textbox" type="text" id="user"  name="user" />  
       		</td>
        	<td>
		        <label for="user">操作类型:</label>  
		    </td>
        	<td> 
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
        	</td>
        </tr>
        <tr>
        	<td>
		        <label for="time">时间:</label> 
		    </td>
        	<td>  
		        <input class="easyui-datetimebox" editable="fasle" style="width:150px" type="text" id="starttime"  name="starttime" /> 
		        <label for="time">-</label>
		        <input class="easyui-datetimebox" editable="fasle" style="width:150px" type="text" id="endtime"  name="endtime" /> 
		     </td>
        	<td> 
		        <label for="user">关键字:</label>
		    </td>
        	<td>   
		        <input class="easyui-textbox" type="text" id="keyword"  name="keyword" />  
		    </td>
		    <!-- <td> 
		    </td>
        	<td> 
		    </td> -->
        	<td>   
		       <a href="javascript:void(0)" class="easyui-linkbutton button-edit button-default" data-options="iconCls:'icon-search'" onclick="doSearch()" title="Search">检索</a>
			</td>
			<td>   
		       <a href="javascript:void(0)" id="os" class="easyui-linkbutton button-edit button-default" data-options="iconCls:'icon-export'"  onclick="exportSysLog()"></a>
			</td>
	</tr>
	</table>
	</form>	
	</div>  	
</div>	

	
<script type="text/javascript">
$('#dg').datagrid({
	url :'${pageContext.request.contextPath}/sysLog/logInf',
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
	columns: [[  
			{title: '操作人', field: 'username', width:'100px'},
			{title: '操作人IP地址', field: 'ip', width:'150px'},
			{title: '操作类型', field: 'operatename', width:'100px'},
			{title: '标题', field: 'title', width:'200px'},
	        {title: '操作时间', field: 'intime', width:'150px'}, 
	        {title: '操作', field: 'content', width:'150px',
	        	   formatter:function(value,rowData,rowIndex){
	        		   return "<a href='javascript:void(0)' class='button-edit button-default' onclick='mngRol(&apos;" + rowData.logid + "&apos;);'>详细信息</a> ";
	              }  
	           },
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

//导出时organizationcode传到后台
$("#organization").combotree({
	onSelect: function(node){
		$("#organizationcode").val(node.name);
	}
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
    var keyword = $.trim($("#keyword").val());
    var operatetype = $("#operatetype").combobox("getValue");


    $("#dg").datagrid('load', {
    	organization: organization,
    	user: user,
    	starttime: starttime,
    	endtime: endtime,
    	keyword: keyword,
    	operatetype: operatetype
    });
}

function isJSON(str) {
    if (typeof str == 'string') {
        try {
            var obj=JSON.parse(str);
            if(typeof obj == 'object' && obj ){
                return true;
            }else{
                return false;
            }

        } catch(e) {
            //console.log('error：'+str+'!!!'+e);
            return false;
        }
    }
}

function mngRol(logid){		
	$.ajax({
		type : 'POST',
		url : '${pageContext.request.contextPath}/sysLog/logDetails',
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
				$('#type').html(json.operatename);

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
			
		}

	});
	$('#inf').dialog('open').dialog('setTitle', '<spring:message code="Showthedetails"/>');
		 	
}

//导出
function exportSysLog(){
	$("#os").linkbutton('disable');
    setTimeout(function(){
    	$("#os").linkbutton('enable');
    },2000) //点击后相隔多长时间可执行	
    
	 $('#exfm').form('submit',{
		url: '${pageContext.request.contextPath}/sysLog/exportExcel', 
		onSubmit: function(){
			return $(this).form('validate');
		}
	});
}

</script>


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
				<td><label id="type"></label></td>
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

</body>
</html>