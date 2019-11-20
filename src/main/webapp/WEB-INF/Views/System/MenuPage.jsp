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
<style type="text/css">
.tableTr{
    display:block; /*将tr设置为块体元素*/
    margin:5px 0;  /*设置tr间距为2px*/
}
 #ulImgList li
{
display: block;
width: 72px;
height: 72px;
line-height: 72px;
float: left;
text-align: center;
cursor: pointer;
margin: 6px;}
.liorg
{ border: 1px solid #ccc;}
.liBorder{border: 1px solid #f00;}
</style>
<jsp:include page="../Header.jsp"/>
</head>
<body>	
<table id="dg"  style="width: 100%;"
			url="${pageContext.request.contextPath}/sysMenu/menuTreeGrid"
			toolbar="#toolbar" 
			rownumbers="true" fit="true"
			idField="menuid" treeField="menuname">
	</table>
	
<div id="toolbar">
<%-- 	<a href="#" class="easyui-linkbutton button-olive" onclick="addMenu()"><i class="iconfont">&#xe6fa;</i> <spring:message code="Add"/></a>
	<a href="#" class="easyui-linkbutton button-yellow" onclick="editMenu()"><i class="iconfont">&#xe69e;</i><spring:message code="Edit"/></a>
	<a href="#" class="easyui-linkbutton button-red" onclick="destroyMenu()"><i class="iconfont">&#xe69d;</i><spring:message code="Delete"/></a> --%>
	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="addMenu()"><spring:message code="Add"/></a>
	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" onclick="editMenu()"><spring:message code="Edit"/></a>
	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="destroyMenu()"><spring:message code="Delete"/></a>
</div>


<div id="dlg" class="easyui-dialog" style="width:320px;height:360px;padding:10px 20px" closed="true" buttons="#dlg-buttons">
<div id="divFm">
	 <form id="fm" class="easyui-form" method="post" >
            <table cellpadding="5" align="center">
                <tr class="tableTr" style="width: 100%">
                    
                    <td ><input class="easyui-textbox" id="menuname" type="text" style="width:100%" name="menuname" data-options="label:'<spring:message code="MenuName"/>',required:true,validType:'nameValidate'"></input></td>
                </tr>
                <tr class="tableTr">
                    <td><input class="easyui-textbox" type="text" style="width:100%" name="menuenname" data-options="label:'<spring:message code="EnglishName"/>'"></input></td>
                </tr>
                <tr class="tableTr">
                    <td><input class="easyui-textbox" type="text" style="width:100%" name="menuurl" data-options="label:'<spring:message code="LinkAddress"/>'"></input></td>
                </tr>
                <tr class="tableTr">
                    <td><select class="easyui-combotree" 
					url="${pageContext.request.contextPath}/sysMenu/menuTreeGrid?Math.random()"
					name="superid" id="superid" style="width:100%;" data-options="label:'<spring:message code="SuperiorMenu"/>'">
				 </select></td>
                </tr>
                <tr class="tableTr">
                    <td><select class="easyui-combobox"
						id="menutype" name="menutype" style="width:100%;" data-options="label:'菜单类型',required:true">
						<option value="0">后台菜单</option>
						<option value="1">前台菜单</option>
					</select></td>
                </tr> 
                <tr class="tableTr">
                    <td><input class="easyui-textbox" type="text" style="width:100%" name="menuorder" data-options="label:'<spring:message code="MenuOrder"/>'"></input></td>
                </tr>
            </table>
        </form>
      </div>
</div>
<div id="dlg-buttons">
	<a href="#" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveMenu()"><spring:message code="Save"/></a>
	<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')"><spring:message code="Cancel"/></a>
</div>

<div id="mIcon" class="easyui-dialog" style="width:600px;height:400px;padding:10px 20px"  closed="true"  buttons="#mIcon-buttons">
	<form id="iconfm" method="post">
	<ul id="ulImgList">
	</ul>
	</form>
</div>
<div id="mIcon-buttons">
	<a href="#" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveIcon()"><spring:message code="Save"/></a>
	<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#mIcon').dialog('close')"><spring:message code="Cancel"/></a>
</div>


<script type="text/javascript">	
	$(function(){  
	    $('#dg').treegrid({      
	        columns: [[  
	            {title: '<spring:message code="MenuName"/>', field: 'menuname', width: '20%',align:'left'},  
	            {title: '<spring:message code="EnglishName"/>', field: 'menuenname', width:' 20%'},
	            {title: '<spring:message code="LinkAddress"/>', field: 'menuurl', width:'20%'}, 
	            {title: '菜单类型', field: 'menutype', width: '10%', formatter: function(value, row, index){
	            	if (value == 0)return "后台菜单";
	            	else if (value == 1)return "前台菜单";
	            	else return "";}
	            },
	            {title: '<spring:message code="MenuOrder"/>', field: 'menuorder', width: '20%'},    
	           	{title: '<spring:message code="SetIcon"/>', field: 'menuicon', width:'10%',formatter:button,}
	        ]],
	        onDblClickCell: function(index,field,value){
	      	   editMenu();
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
	    }) 
	    
	    GetIconJson();
	}); 
	//点击设置图标按钮
	function button(value,row,index){
		  return "<a href='#' class='button-edit button-default' onclick='SetIcon(&apos;" + row.menuid +"&apos;"+","+"&apos;"+row.menuicon+"&apos;);'><spring:message code="Set_Icon"/></a>";  
	}
	</script>

<script type="text/javascript">
function addMenu(){
	$('#superid')
	.combotree('reload','${pageContext.request.contextPath}/sysMenu/menuTreeGrid');
	$('#dlg').dialog('open').dialog('setTitle','<spring:message code="AddMenu"/>');
	$('#fm').form('clear');
	url = '${pageContext.request.contextPath}/sysMenu/addMenu';
}

//编辑菜单
function editMenu(){
	var row = $('#dg').treegrid('getSelected');
	if (row){
		$('#dlg').dialog('open').dialog('setTitle','<spring:message code="EditMenu"/>');
		$('#superid').combotree('reload', '${pageContext.request.contextPath}/sysMenu/otherMenuTreeGrid?id=' + row.id);
		$('#fm').form('load',row);
		url = '${pageContext.request.contextPath}/sysMenu/editMenu?id='+row.menuid;
	}
}	
//保存
function saveMenu(){
	$('#fm').form('submit',{
		url: url,
		onSubmit: function(){
			return $(this).form('validate');
		},
		success: function(result){		
			if(result=="success"){
				$('#dlg').dialog('close');		// close the dialog
				$('#dg').treegrid('reload');	// reload the user data
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

//删除菜单
function destroyMenu(){
	var row = $('#dg').treegrid('getSelected');
	if (row){
		$.messager.confirm('<spring:message code="DeleteMenu"/>','<spring:message code="Delete_Menu_Sure"/>',function(r){
			if (r){
				  var data3={"id":row.menuid};   
				  $.ajax({
					   type:'POST', 
			           url:'${pageContext.request.contextPath}/sysMenu/deleteMenu',           
			           data:data3,        
				       success:function(data){ 
				    	   if(data=="success"){
								$('#dg').treegrid('reload');	// reload the user data
								$.messager.alert('<spring:message code="Prompt"/>','<spring:message code="SuccessDeleted"/>','info');
								//parent.location.reload();
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

//获取图标json
function GetIconJson(){
	  $.ajax({
		   type:'POST', 
          url:'${pageContext.request.contextPath}/sysMenu/iconJson',           
          data:'',        
	       success:function(data){ 
	    	   icon(data);
	        },	        
	        error:function(data){
	        	$.messager.alert('<spring:message code="Warning"/>','<spring:message code="Failed_To_Get_Icon"/>','error');
	        	
         }
       
	   });
}
//拼凑图标显示的html
function icon(xqo){
	var html="";
	for(var i in xqo){							
		html+="<li class=\"liorg\" id="+xqo[i].iconName+"><a title="+xqo[i].iconName+"><img style=\"margin-top: 25px\" src=\""+xqo[i].iconPathe+"\"><i class="+xqo[i].iconName+"></i></a></li>";
	} 
	 $("#ulImgList").html(html);	
	 
	 $("#ulImgList > li").click(function () {
         $("#ulImgList > li").removeClass("liBorder");
         $(this).toggleClass("liBorder");
         var iPath = $(this).children("a").children("i").attr("class");
         icon=iPath;
         $("#hidIPath").val(iPath);
     }).hover(function () { $(this).toggleClass("liHov"); }); 
}

//设置菜单图标
function SetIcon(menuid,menuicon){
	ShowIcons(menuid,menuicon);
}
//设置菜单图标
function ShowIcons(menuid,menuicon){
		$('#mIcon').dialog('open').dialog('setTitle','<spring:message code="SetIcon"/>');
		//$('#iconfm').form('clear');
		$("#ulImgList > li").removeClass("liBorder");
		$("#ulImgList  #"+menuicon+"").toggleClass("liBorder");
		url = '${pageContext.request.contextPath}/sysMenu/saveIcon?id='+menuid;
		
}

//保存图标
function saveIcon() {
  if(null !=icon){
	url = url+'&icon='+icon;
	$('#iconfm').form('submit',{
	url: url,
	onSubmit: function(){
		return $(this).form('validate');
	},
	success: function(result){			
	  if(result=="success"){
		$('#mIcon').dialog('close');		// close the dialog
		$('#dg').treegrid('reload');	// reload the user data
		$.messager.alert('<spring:message code="Prompt"/>','<spring:message code="SuccessOperation"/>','info');
	   }else{
		   $.messager.alert('<spring:message code="Warning"/>','<spring:message code="OperationFailed"/>','error');
	   }
				
	}
   })
  }else{
	  $.messager.alert('<spring:message code="Warning"/>','<spring:message code="ChoseOne"/>','error');
  }	
}	
</script>
</body>
</html>