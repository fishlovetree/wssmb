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
<title>NB命令列表</title>
<jsp:include page="../../Header.jsp"/>
<script>
var basePath = '${pageContext.request.contextPath}';
</script>
</head>
<body>
<div class="easyui-layout" fit="true">
	<div id="west" region="west" iconCls="icon-organization" split="true" title="设备" style="width:284px;min-width:284px;" collapsible="true">
		<jsp:include page="../../CommonTree/nb_DeviceTree.jsp"/>
	</div>
	<div id="center" region="center" style="overflow-y: hidden">
		<table id="dg" toolbar="#toolbar"></table>
	</div>
</div>
	
<div id="toolbar">
	<input type="hidden" name="type" id="type"/> 
	<input type="hidden" name="gid" id="gid"/>    
	<input type="hidden" name="parentid" id="parentid"/> 
	<input class="easyui-textbox" type="text" style="width:300px" id="nodename" data-options="label:'当前节点：',readonly:'readonly'">
    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="cancelUUID()">取消</a>
    <input id="search" class="easyui-searchbox" style="width:240px" data-options="searcher:searchCommands,prompt:'请输入查询条件',menu:'#searchname'"></input>
    <div id="searchname">
	    <div data-options="name:'equipmentaddress'">设备地址</div>
	    <div data-options="name:'equipmentname'">设备名称</div>
	</div>
</div>  

<div id="w" class="easyui-window" closed="true" data-options="cls:'theme-panel-orange',footer:'#footer'" style="width:380px;height:300px;padding:10px;">
	<div id="DataDetail" align="center">
    </div>
</div>
<div id="footer" style="padding:5px;" align="center">
 	<a class="easyui-linkbutton"  href="javascript:void(0)" onclick="javascript:$('#w').window('close')" style="width:80px">确定</a>
</div>

</body>
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

$(function() {
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
		singleSelect:false,
		cache:false,
		rownumbers:true,//显示序号
		pagination:true,
		nowrap: true,//数据长度超出列宽时将会自动截取。
		pageSize:50,
		fit: true,   //自适应大小
		url:'${pageContext.request.contextPath}/oneNetParam/oneNetCommandDataGrid',
		frozenColumns: [[
			{ field: 'ck', checkbox:true },
	        { field: 'id', title: '明细', width: 110, 
                formatter: function (value, row, index) {
                	var result = "<a href='#' class='button-tbl button-default' onclick='getUUIDDetail(" + value + ")'>应答</a>"
                	if(row.commenttype=="2" && row.status=="2" && row.setresult=="1"){//查询 已应答 执行成功
                		result = result + "<span>&nbsp</span><a href='#' class='button-tbl button-default' onclick='getCommandDetail(" + value + ")'>结果</a>";
                	}
                	return result;
                }
	        }
		]],
		columns: [[  
			{title: 'UUID', field: 'uuid', width: '120'},
			{title: '命令类型', field: 'commenttype', width: '80',
			    formatter: function(value, row, index){
			    	if (value == 1){
			    		return "设置";
			    	}
			    	else if (value == 2){
			    		return "查询";
			    	}
			    	else{
			    		return "";
			    	}
			    }	
			},
			{title: '状态', field: 'status', width: '80',
			    formatter: function(value, row, index){
			    	if (value == 0){
			    		return "已取消";
			    	}
			    	else if (value == 1){
			    		return "<span style='color:red'>待应答</span>";
			    	}
			    	else if (value == 2){
			    		return "已应答";
			    	}
			    	else{
			    		return "";
			    	}
			    }	
			},
			{title: '执行结果', field: 'setresult', width: '80',
			    formatter: function(value, row, index){
			    	if (value == '0'){
			    		return "<span style='color:red'>执行失败</span>";
			    	}
			    	else if (value == '1'){
			    		return "执行成功";
			    	}
			    	else if (value == '2'){
			    		return "否认应答";
			    	}
			    	else{
			    		return "";
			    	}
			    }	
			},
			{title: '执行时间', field: 'setdate', width: '124'},
			{title: '设备名称', field: 'equipmentname', width: '150'},
			{title: '设备地址', field: 'equipmentaddress', width: '150'},
			{title: '帧序号', field: 'serialnum', width: '80'}, 
			{title: '命令类型标志', field: 'typeflagcode', width: '200',
				formatter:function(value,row,index){
					switch(value){
						case 128:
							return "设置系统通讯配置信息";
							break;
						case 130:
							return "同步系统终端时间";
							break;
						case 139:
							return "设置事件记录阀值";
							break;
						case 206:
							return "查询系统通讯配置信息";
							break;
						case 208:
							return "查询系统时间";
							break;	
						case 210:
							return "查询事件记录阀值";
							break;	
						default:
							return value;
							break;
					}
				}
			}, 
			{title: '备注', field: 'remark', width: '180'},
			{title: '数据内容', field: 'paramdata', width: '200'},
			{title: '应答命令项', field: 'responsetypecode', width: '200',
				formatter:function(value,row,index){
					switch(value){
						case 0:
							return "";
							break;
						case 156:
							return "上传系统通讯配置信息";
							break;
						case 158:
							return "上传系统时间";
							break;
						case 160:
							return "上传事件记录阀值";
							break;
						case 171:
							return "上传事件记录阀值";
							break;
						default:
							return value;
							break;
					}
				}
			}, 
			{title: '查询结果', field: 'queryresult', width: '200'},    
			{title: '操作人', field: 'username', width: '80'},
			{title: '生成时间', field: 'recorddate', width: '128'},
		]],
 		onLoadSuccess:function(){
			$('.button-tbl').linkbutton({ });
		}
	});	
});

function getCommandDetail(id){
	  $.ajax({
		   type:'POST', 
           url:'${pageContext.request.contextPath}/oneNetParam/getCommandDetail',           
           data:{"id":id},        
	       success:function(data){ 				    	  
	    	   if(data!=""){
	    		  	$("#DataDetail").html(data);
			    	$.parser.parse( $('#w')); 
			    	$("#w").window('resize',{width:310,height:"auto"});
			    	$('#w').window('open').dialog('setTitle',"查询结果明细");
				}
	        },	        
	        error:function(data){
	        	$.messager.alert('警告',data,'error');		  
	        }
	   });		
}

function getUUIDDetail(id){
	  $.ajax({
		   type:'POST', 
           url:'${pageContext.request.contextPath}/oneNetParam/getUUIDDetail',           
           data:{"id":id},        
	       success:function(data){ 				    	  
	    	   if(data!=""){
	    		  	$("#DataDetail").html(data);
			    	$.parser.parse( $('#w')); 
			    	$("#w").window('resize',{width:310,height:"auto"});
			    	$('#w').window('open').dialog('setTitle',"命令响应明细");
				}
	        },	        
	        error:function(data){
	        	$.messager.alert('警告',data,'error');		  
	        }
	   });		
}
function cancelUUID(){
	 var selRow = $("#dg").datagrid('getSelections');
     if (selRow.length == 0) {
    	 $.messager.alert('提示','请至少选择一行数据。','warning');
         return false;
     }
     var ids = [];//需要删除的所有id
     for (var i = 0; i < selRow.length; i++) {
	     ids.push(selRow[i].id); //把单个id循环放到ids的数组中 
     }
    
     $.messager.confirm('提示', '确认取消OneNet离线命令?', function(r) {
         if (r) {
             $.ajax({
            	 type:'POST', 
		         url:'${pageContext.request.contextPath}/oneNetParam/cancelUUID',  
                 //dataType : 'json',
                 data : {
                     "id[]" : ids
                 },
                 success:function(data){ 			    	  
	                	 if(data!=""){
	     	    		  	$("#DataDetail").html(data);
	     			    	$.parser.parse( $('#w')); 
	     			    	$("#w").window('resize',{width:600,height:"auto"});
	     			    	$('#w').window('open').dialog('setTitle',"取消明细结果");
	     			    	$('#dg').datagrid('reload');	// reload the user data
	     				}
			        },	        
			     error:function(data){
			        	$.messager.alert('警告',data,'error');   	
		          }
             });
         }
     });
}

var treeTab = $('#region_tree');
//公用树点击事件
var node;
function treeClick(treeObj, n){
	if(typeof n!='undefined' ){
		node=n;
		treeTab = treeObj;
		$("#nodename").textbox("setValue",n.text); 
		$("#type").val(node.type);
		$("#gid").val(node.gid);
		$("#parentid").val(node.parentid);
		searchCommandsByNode(); 
	}
}

//根据树节点搜索
function searchCommandsByNode(){	
	 $("#dg").datagrid('load', {
		 	type : node.type,
		 	gid : node.gid,
		 	parentid : node.parentid,
		 	searchname:$("#search").searchbox('getName'),
		 	searchvalue:$("#search").searchbox('getValue')
	  });
}

//根据查询条件搜索
function searchCommands(value,name){
    $("#dg").datagrid('load', {
    	type : $('#type').val(),
	 	gid : $('#gid').val(),
	 	parentid : $('#parentid').val(),
	 	searchname:name,
	 	searchvalue:value
  });  
}
</script>
</html>