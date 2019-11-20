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
<title>设备升级方案编制</title>
<jsp:include page="../../Header.jsp"/>
<script>
var basePath = '${pageContext.request.contextPath}';
</script>
</head>
<body>
    <div class="easyui-layout" fit="true">
        <div id="west" region="west" iconCls="icon-organization" split="true" title="客户信息" style="width:284px;min-width:284px;" collapsible="true">
			<jsp:include page="../../CommonTree/customerTree.jsp"/>
		</div>
		<div region="center" style="overflow-y:hidden">
		    <div class="easyui-layout" fit="true">
		        <div id="mainPanel" region="north" style="width:100%;height:90px;position:relative;overflow-y:hidden;">
		        	<table border="0" cellspacing="8" cellpadding="8">
                        <tr>
                            <td>
                                <input class="easyui-textbox" type="text" style="width:200px" id='deviceaddr' name="deviceaddr" data-options="label:'设备地址'"/>
                            </td>
                            <td>
                                <input class="easyui-textbox" type="text" style="width:200px" id='devicename' name="'devicename'" data-options="label:'设备名称'"/>
                            </td>
                            <td>
                                <input class="easyui-textbox" type="text" style="width:200px" id='oldver' name="oldver" data-options="label:'当前版本号'"/>
                            </td>
                            <td>
                                <a href="javascript:void(0)" class="easyui-linkbutton" onclick="searchDevice()" title="检索">检索</a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input class="easyui-textbox" type="text" style="width:200px" id='schemename' name="schemename" data-options="label:'方案名称'" />
                            </td>
                            <td>
                                <input class="easyui-textbox" type="text" style="width:200px" id='newver' name="newver" data-options="label:'新版本号'"/>
                            </td>
                            <td>
                                <a href="javascript:void(0)" class="easyui-linkbutton" onclick="saveScheme()" title="保存">保存</a>
                            </td>
                        </tr>
                    </table>
		        </div>
		        <div data-options="region:'center',split:true">
                  	<table id="deviceTbl"></table>
                  	<!-- <div id="tbltoolbar">
		                <form id="fm" class="easyui-form" method="post">
						<input class="easyui-textbox" type="text" style="width:200px" id='schemename' name="schemename" data-options="label:'方案名称'" />
						<input class="easyui-textbox" type="text" style="width:200px" id='newver' name="newver" data-options="label:'新版本号'"/>
						<a href="javascript:void(0)" class="easyui-linkbutton" onclick="saveScheme()" title="保存">保存</a>
						</form>
					</div>-->
                </div>
		    </div>
        </div>  	
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

$(function(){
	$('#deviceTbl').datagrid({
		url: '${pageContext.request.contextPath}/upgradeScheme/deviceDataGrid?Math.random()',
		singleSelect:false,
		rownumbers:true,//显示序号
		nowrap: true,//数据长度超出列宽时将会自动截取。
		fit: true,   //自适应大小
		idField: 'equipmentaddress',
		toolbar: "#tbltoolbar",
		columns: [[         	
            {field: 'ck', checkbox: true},
            {title: '设备名称', field: 'equipmentname', width:'180px'},
			{title: '设备地址', field: 'equipmentaddress',width:'180px'}, 
	        {title: '序列号', field: 'phonenum', width:'128px'},
	        {title: '软件版本号', field: 'softwareversion', width:'128px'},
	        {title: '所属用户', field: 'customername', width:'180px' }, 
	        {title: '所属楼层', field: 'buildingname', width:'100px' }, 
	        {title: '安装位置', field: 'installationsite', width:'128px'}
		]]
	});	
	
	resizeDiv();
	
	$("#west").panel({
        onResize: function (w, h) {
        	resizeDiv();
        }
    });
	
	$(window).resize(function(){ //浏览器窗口变化 
		resizeDiv();
	});
})

var treeTab = $('#region_tree');
//公用树点击事件
var node;
function treeClick(treeObj, n){
	if(typeof n!='undefined' ){
		node=n;
		treeTab = treeObj;
		searchDevice();
	}
}

//检索设备
function searchDevice(){
	if(null==node || node=="")
		if(null!=treeTab.tree('getSelected'))
			node=treeTab.tree('getSelected');

	if(node){
		var nodeid = node.gid;
		var nodetype = node.type;
	}
	var nodeid = node.gid;
	var nodetype = node.type;

	var deviceaddr = $('#deviceaddr').val();
	var devicename = $('#devicename').val();
	var oldver = $('#oldver').val();
	$('#deviceTbl').datagrid('load', {
		id: nodeid,
		type: nodetype,
		deviceaddr: deviceaddr,
		devicename: devicename,
		oldver: oldver
	})
}

//保存升级方案
function saveScheme(){
	var schemename = $('#schemename').val();
	if (schemename == ''){
		$.messager.alert('提示','请输入方案名称。','warning');
		return;
	}
	var newversion = $('#newver').val();
	if (newversion == ''){
		$.messager.alert('提示','请输入新版本号。','warning');
		return;
	}
	var nodes = $('#deviceTbl').datagrid('getSelections');
	if (nodes == null || nodes.length == 0){
		$.messager.alert('提示','请选择需要升级的设备。','warning');
		return;
	}
	var data=[];//JSON只能接受数组加对象的格式，例如[{},{}]
    for(var i=0;i<nodes.length;i++){
        data.push({'systemtype': nodes[i].systemtype, 'systemaddress': nodes[i].systemaddress, 
        	'equipmenttype': nodes[i].equipmenttype, 'equipmentaddress': nodes[i].equipmentaddress,
        	'beginswversion': nodes[i].softwareversion, 'endswversion': newversion})
    }
    $.ajax({
        url:'${pageContext.request.contextPath}/upgradeScheme/addDeviceScheme?Math.random()',
        type:'post',
        data:{
        	schemename: schemename,
            json:JSON.stringify(data)
        },
        cache:false,
        success:function(msg){
            if (msg == "success"){
            	$.messager.alert('提示', '升级方案保存成功。', 'info');
            }
            else if (msg == "repeat"){
            	$.messager.alert('提示','升级方案名称已存在。','warning');
            }
            else{
            	$.messager.alert('警告', '抱歉，出错了，请重试。', 'error');
            }
        }
    });
}

</script>
</html>