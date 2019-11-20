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
<title>本地预案</title>
<jsp:include page="../../Header.jsp"/>
<style type="text/css">
    .read-result-tbl{
        margin: 0px;
	    padding: 0px;
	    font-size: 12px;
	    color: #335169;
	    background: #fff;
	    border-top: 1px solid #a8c7ce;
	    border-right: 1px solid #a8c7ce;
    }
    .read-result-tbl th, .read-result-tbl td{
        padding: 2px 5px 2px 5px;
	    border-bottom: 1px solid #a8c7ce;
	    border-left: 1px solid #a8c7ce;
	    vertical-align: middle;
    }

	.layout-split-west {
	    border-right: 1px solid #ccc;
	}
	.layout-split-north{
	    border-bottom: 1px solid #ccc;
	}
</style>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/waitstyle.css"
	media="screen" type="text/css" />
</head>
<body>
	<div class="easyui-layout" fit="true">
		<div id="west" region="west" iconCls="icon-organization" split="true" title="消防监测终端" style="width:284px;min-width:284px;" collapsible="true">
			<jsp:include page="../../CommonTree/term_UnitTree.jsp"/>
		</div>
		<div id="mainPanel" region="center" style="overflow-y: hidden">
			<div class="easyui-layout" fit="true">
				<div region="north" style="height: 400px;" split="true">
					<table id="dg"></table>
					<div id="toolbar">
						<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="addPlan()">编制</a>
						<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" onclick="editPlan()">修改</a>
						<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="deletePlan()"><spring:message code="Delete"/></a>
		                <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-card'" onclick="showDetails()">明细</a>
						<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-set'" onclick="setPlan()">设置</a>
						<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="readPlan()">召测单个</a>
						<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="readPlanCount()">召测有效预案编号</a>
					</div>
					<div id="adddlg" class="easyui-dialog" style="width:650px;height:520px;padding:10px 20px" closed="true" buttons="#adddlg-buttons">
						<form id="fm" class="easyui-form" method="post" >
						    <input type="hidden" id="planid" name="planid"/>
						    <input type="hidden" id='snode' /> 
							<input type="hidden" id="selectedID" /> 
							<input type="hidden" id="selectedType" /> 
					        <table cellspacing="8">
				                <tr class="tableTr">
				                    <td ><input class="easyui-textbox" type="text"
										style="width:100%;" id="unitaddress" name="unitaddress"
										data-options="label:'消防监测终端',validType:'maxlength[25]'" readonly="readonly"></input></td>
				                </tr> 
				                <tr class="tableTr">
				                    <td ><input class="easyui-numberbox" type="text"
										style="width:100%;" id="plannumber" name="plannumber"
										data-options="label:'预案编号',required:true,min:1,max:63"></input></td>
				                </tr> 
				                <tr class="tableTr">
				                    <td style="height:32px;"><input class="easyui-combogrid" 
				                        data-options="label:'执行源设备',  
								            panelWidth:550,
								            editable:false,
								    	    idField:'equipmentid',    
								    	    textField:'equipmentname',  
								    	    fit: true,   //自适应大小
											singleSelect: false,
											rownumbers:true,//行号
											queryParams:{
												unitid: 0,
												filter: ''
											},
								    	    url:'${pageContext.request.contextPath}/localPlan/getEquipmentList?Math.random()',    
								    	    columns:[[    
												{title: '设备名称', field: 'equipmentname', width:'160px'},
												{title: '设备地址', field: 'equipmentaddress',width:'124px'},
												{title: '设备类型', field: 'equipmenttype', width:'120px',
													formatter : function(value, rowData, rowIndex) {
														return rowData.equipmenttypename;
													}
												}
								    	    ]]"
										id="srcdeviceid" name="srcdeviceid" style="width:100%;"/>
									</td>
				                </tr>         
				                <tr class="tableTr">
				                    <td><input id="srceventcode" name="srceventcode" class="easyui-combobox" data-options="label:'执行源事件',    
								        valueField: 'detailvalue',  
								        textField: 'detailname', 
								        editable:false,   
								        url: '${pageContext.request.contextPath}/localPlan/getEquipmentType?Math.random()'" style="width:100%;"/></td>
				                </tr>   
				                <tr class="tableTr">
				                    <td><select id="condition" name="condition" class="easyui-combobox" data-options="label:'执行条件',editable:false" style="width:100%;"><option value="1">开始</option><option value="2">结束</option></select></td>
				                </tr>
				                <tr class="tableTr">
				                    <td><table id="devices"></table></td>
				                </tr>
				            </table>
					    </form>
					</div>
					<div id="adddlg-buttons">
						<a href="#" class="easyui-linkbutton" iconCls="icon-ok" onclick="savePlan()"><spring:message code="Save"/></a>
						<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#adddlg').dialog('close')"><spring:message code="Cancel"/></a>
					</div>
					<div id="dlg" class="easyui-dialog" style="width:500px;height:300px;" closed="true" buttons="#dlg-buttons">
					    <table id="detailTbl"></table>
					</div>
					<div id="dlg-buttons">
						<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">关闭</a>
					</div>
				</div>
			    <div region="center" title="结果<a href='javascript:void(0)' class='easyui-linkbutton' style='float: right; width: 40px;' 
		            onclick='clearResult();'>清空</a>">
			        <div id="resultPanel" style="margin: 10px;">
			        </div>
			    </div>
			</div>
		</div>
	</div>
<script type="text/javascript">
    //动作类型
    var actionType = eval('(' + '${requestScope.actions}' + ')');
  //设备过滤（查找有联动动作的设备）		        
    var deviceFilter = [];	
    if (actionType != ''){
    	for (var key in actionType){
    		deviceFilter.push(key);
    	}
    }
		        
	//websocket相关
	var ws;
	var port = '0'; //前一次端口号，断线重连时用到
	var frameNumber = 1; //帧序号
	
	var _planid = 0; //所选预案ID

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
    	
    	$('#dg').datagrid({
    		singleSelect:true,
    		cache:false,
    		rownumbers:true,//显示序号
    		pagination:true,
    		nowrap: true,//数据长度超出列宽时将会自动截取。
    		pageSize:20,
    		fit: true,   //自适应大小
    		url:'${pageContext.request.contextPath}/localPlan/planDataGrid',
    		toolbar: '#toolbar',
    		columns: [[    		           
				{title: '状态', field: 'result', width: '80',
				    formatter: function(value, row, index){
				    	if (value == -1){
				    		return "<span style='color:red'>设置失败</span>";
				    	}
				    	else if(value == 1){
				    		return "<span style='color:green'>设置成功</span>";
				    	}
				    	else{
				    		return "<span style='color:red'>未设置</span>";
				    	}
				    }	
				},
                {title: '消防监测终端', field: 'unitname', width: '150'}, 
    			{title: '预案编号', field: 'plannumber', width: '100'},  
    			{title: '执行源设备', field: 'srcequipmentname', width: '150'}, 
    			{title: '执行源设备地址', field: 'srcequipmentaddress', width: '150'},  
    			{title: '执行源事件', field: 'srceventname', width: '100'}, 
    			{title: '执行条件', field: 'condition', width: '80',
    				formatter: function(value, row, index){
    					if (value == 1) return "开始";
    					else return "结束";
    				}}, 
    			{title: '预案编制人', field: 'username', width: '100'},    
    			{title: '编制时间', field: 'intime', width: '250'}
    		]],
    		onDblClickRow: function(index,row){
    			editPlan();
    		}
    	});	
    	
    	$('#devices').datagrid({    
    	    width:600,
    	    height:200,
    	    idField:'equipmentid',    
    	    textField:'equipmentname',  
			singleSelect: false,
			rownumbers:true,//行号
			queryParams:{
				unitid: 0,
				filter: ""
			},
    	    url:'${pageContext.request.contextPath}/localPlan/getEquipmentList?Math.random()',    
    	    columns:[[    
				{field: 'ck', checkbox: true},
				{title: '设备名称', field: 'equipmentname', width: '150'},    	           	
				{title: '动作类型', field: 'actiontype', width: '250', editor:{
					type: 'combobox',  
				    options: {  
				       data: '',  
				       valueField: "detailvalue",  
				       textField: "detailname",  
				       editable: false,  
				       panelHeight:70,
				       required:true
				   }  
				},
				   formatter: function(value, row, index){
					   var r = "";
					   if (actionType != ''){
						   for (var key in actionType){
							   for (var i = 0; i < actionType[key].length; i++){
								   if (value && actionType[key][i].detailvalue == value.toString()){
									   r = actionType[key][i].detailname;
								   }
							   }
						   }
					   }
					   return r;
				   }
				},
				{title: '设备地址', field: 'equipmentaddress', width: '150'}
    	    ]],
    	    onSelectAll: function(rows){
    	    	if (rows != 0){
	    	    	$.each(rows, function(i, n){
	    	    		var index = $('#devices').datagrid('getRowIndex', n);
	    	    		$('#devices').datagrid('beginEdit', index);
	    	    	    var ed = $('#devices').datagrid('getEditor', {index:index,field:'actiontype'});
	    	    	    if ($(ed.target).combobox('getData') == '' && actionType[n.equipmenttype]){
	    	    	    	$(ed.target).combobox('loadData', actionType[n.equipmenttype]);
	    	    	    }
	    	    	})
    	    	}
    	    },
    		onUnselectAll: function(rows){
    			if (rows != 0){
	    			$.each(rows, function(i, n){
	    				var index = $('#devices').datagrid('getRowIndex', n);
	    				$('#devices').datagrid('cancelEdit', index);
	    			})
	    		}
    		},
    		onSelect: function(index, row){
    			$('#devices').datagrid('beginEdit', index);
    		    var ed = $('#devices').datagrid('getEditor', {index:index,field:'actiontype'});
    		    if ($(ed.target).combobox('getData') == '' && actionType[row.equipmenttype]){
    		    	$(ed.target).combobox('loadData', actionType[row.equipmenttype]);
    		    }
    		},
    		onUnselect: function(index, row){
    			$('#devices').datagrid('cancelEdit', index);
    		},
    		onLoadSuccess: function(data){
    			$.ajax({
    	            url:'${pageContext.request.contextPath}/localPlan/planDetailsDataGrid',
    	            type:'post',
    	            data:{
    	            	planid: _planid
    	            },
    	            cache:false,
    	            success:function(d){
    	                if (d){
    	                	$.each(d, function(i, n){
    	                		var index = $('#devices').datagrid('getRowIndex', n.equipmentid);
    	                		$('#devices').datagrid('selectRecord', n.equipmentid);
    	                		var actiontype = $('#devices').datagrid('getEditor', {index:index,field:'actiontype'});
    	                	    $(actiontype.target).combobox('setValue', n.actiontype);
    	                	})
    	                }
    	            }
    	        });
    		}
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
    	
    	//websocket
    	connect();
    })
    
    var treeTab = $('#region_tree');
	//公用树点击事件
	var node;
	function treeClick(treeObj, n){
		if(typeof n!='undefined' ){
			node=n;
			treeTab = treeObj;
			$("#dg").datagrid("load", {
				id: node.gid,
				type: node.type
			});
        	
        	if (node.type == commonTreeNodeType.terminal){ //消防监测终端
        		$("#snode").val(node.text);
                $("#selectedID").val(node.gid);
                $("#selectedType").val(node.type);
                $("#unitaddress").val(node.text);
                
                $("#srcSel").datagrid("load", {
					unitid: node.gid,
					filter: ""
				});
                
                $("#devices").datagrid("load", {
					unitid: node.gid,
					filter: deviceFilter.join()
				});
        	}		
		}
	}
	
	var _url = "";
    function addPlan(){
    	if (node && node.type == commonTreeNodeType.terminal){ //选择的节点是消防监测终端
    		
    		$("#srcdeviceid").combogrid({multiple: true});
    		$("#srceventcode").combobox({multiple: true});
    		
    		$('#adddlg').dialog('open').dialog('setTitle','编制');
        	$('#fm').form('clear');
        	$('#planid').val(0);
        	$('#unitaddress').textbox('setValue', node.text);
        	$("#selectedID").val(node.gid);
        	//获取消防监测终端下的最大预案编号
			$.ajax({
	            url:'${pageContext.request.contextPath}/localPlan/getMaxPlanNumber',
	            type:'post',
	            data:{
	            	unitaddress: node.gid
	            },
	            cache:false,
	            success:function(num){
	                $("#plannumber").numberbox('setValue', num);
	            }
	        });
        	$("#srcdeviceid").combogrid('grid').datagrid("load", {
				unitid: node.gid,
				filter: ""
			});
            
            $("#devices").datagrid("load", {
				unitid: node.gid,
				filter: deviceFilter.join()
			});
            _url = '${pageContext.request.contextPath}/localPlan/addPlan';
    	}
    	else{
    		$.messager.alert('提示','请先选择消防监测终端。','warning');
    	}
    }

    //修改预案
    function editPlan(){
    	var row = $('#dg').datagrid('getSelected');
    	if (row){
    		$("#srcdeviceid").combogrid({multiple: false});
    		$("#srceventcode").combobox({multiple: false});
    		
    		$('#adddlg').dialog('open').dialog('setTitle','编辑');
    		$('#fm').form('clear');
    		$('#planid').val(row.planid);
    		$('#unitaddress').textbox('setValue', row.unitname);
    		$("#selectedID").val(row.unitid);
    		$('#plannumber').numberbox('setValue', row.plannumber);
    		$("#srcdeviceid").combogrid('grid').datagrid("load", {
				unitid: row.unitid,
				filter: ""
			});
    		$("#srcdeviceid").combogrid('setValue', row.srcdeviceid);
    		$("#srceventcode").combobox('setValue', row.srceventcode);
    		$("#condition").combobox('setValue', row.condition);
    		_planid = row.planid;
    		$("#devices").datagrid("load", {
				unitid: row.unitid,
				filter: deviceFilter.join()
			});
    		_url = '${pageContext.request.contextPath}/localPlan/editPlan?id='+row.planid;
    	}
    	else{
    		$.messager.alert('提示','请选择预案。','warning');
    	}
    }	
    
  //保存预案
    function savePlan(){
    	var unitaddress = $("#unitaddress").val();
    	if (unitaddress == ""){
    		$.messager.alert("提示", "请选择消防监测终端。", "warning");
            return;
    	}
    	var plannumber = $("#plannumber").val();
    	if (plannumber == ""){
    		$.messager.alert("提示", "请输入预案编号。", "warning");
            return;
    	}
    	var srcdeviceid = $("#srcdeviceid").combogrid('getValues');
    	if (srcdeviceid == ""){
    		$.messager.alert("提示", "请选择执行源设备。", "warning");
            return;
    	}
    	var srceventcode = $("#srceventcode").combobox('getValues');
    	if (srceventcode == ""){
    		$.messager.alert("提示", "请选择执行源事件类型。", "warning");
            return;
    	}
    	
    	if(srcdeviceid.length*srceventcode.length+parseInt(plannumber)-1>63){
    		$.messager.alert("提示", "终端预案个数限制。", "warning");
            return;
    	}
    	
    	var condition = $("#condition").combobox('getValue');
    	if (condition == ""){
    		$.messager.alert("提示", "请选择执行条件。", "warning");
            return;
    	}
    	var selRows = $('#devices').datagrid('getSelections');
    	if (selRows.length == 0){
    		$.messager.alert("提示", "请选择联动设备。", "warning");
            return;
    	}
    	var data=[];//JSON只能接受数组加对象的格式，例如[{},{}]
	    for(var i=0;i<selRows.length;i++){
	        var index = $('#devices').datagrid('getRowIndex', selRows[i]);
	        if (!$('#devices').datagrid('validateRow', index)){
	        	$.messager.alert("提示", "请选择设备动作。", "warning");
	        	return false;
	        }
	        var actiontype = $('#devices').datagrid('getEditor', {index:index,field:'actiontype'});
	        data.push({'equipmentid': selRows[i].equipmentid, 'actiontype': $(actiontype.target).combobox('getValue')});
	    }
	    $.ajax({
            url:_url,
            type:'post',
            traditional: true,
            data:{
            	"planid": $("#planid").val(),
            	"plannumber": plannumber,
				"unitaddress": $("#selectedID").val(),
				"srcdeviceids": srcdeviceid,
				"srceventcodes": srceventcode,
				"condition": condition,
				"json":JSON.stringify(data)
            },
            cache:false,
            success:function(msg){
                if (msg == "success"){
                	$.messager.alert('提示', '预案保存成功。', 'info');
                	$('#adddlg').dialog('close');
                	$('#dg').datagrid('reload');
                }
                else if (msg == "repeat"){
                	$.messager.alert('提示','预案编号已存在。','warning');
                }
                else{
                	$.messager.alert('警告', '抱歉，出错了，请重试。', 'error');
                }
            }
        });
    }
  
    //显示明细
    function showDetails(){
    	var row = $('#dg').datagrid('getSelected');
    	if (row){
    		$('#dlg').dialog('open').dialog('setTitle','预案明细');
    		$('#detailTbl').datagrid({
    			singleSelect:true,
    			cache:false,
    			rownumbers:true,//显示序号
    			nowrap: true,//数据长度超出列宽时将会自动截取。
    			fit: true,   //自适应大小
    			url:'${pageContext.request.contextPath}/localPlan/planDetailsDataGrid?planid='+row.planid,
    			columns: [[         	
    				{title: '设备名称', field: 'equipmentname', width: '120'},  
    				{title: '设备地址', field: 'equipmentaddress', width: '120'},    
    				{title: '动作类型', field: 'actiontype', width: '250',
    			        formatter: function(value, row, index){
    			        	var r = "";
   						    if (actionType != ''){
   							    for (var key in actionType){
   								    for (var i = 0; i < actionType[key].length; i++){
   									    if (value && actionType[key][i].detailvalue == value.toString()){
   										    r = actionType[key][i].detailname;
   									    }
   								    }
   							    }
   						    }
   						    return r;
    				    }	
    				}
    			]]
    		});	
    	}
    }
	
	//查询预案
	function readPlan(){
        if (ws) {
            if (ws.readyState == 1) {
            	var row = $('#dg').datagrid('getSelected');
            	if (row){
	           		$.ajax({
	   					type: 'POST',
	   					url: "${pageContext.request.contextPath}/localPlan/readPlan",
	   					data: {
	   						"planid": row.planid
	   					},
	   					success: function(d) {
	   						if (d != "[]" && d != "") {
	   							if (d.indexOf("html") > 0) { //session超时
	   	                            parent.window.location.reload();
	   	                        }
	   							else{
	   								frameNumber++;
		                            //组帧，Global.js中定义
		                            var frame = makeWSFrame(frameNumber, 0, 1, 1, d, '');
		                            ws.send(frame);
		                            if ($("body").find(".datagrid-mask").length == 0) {
		                                //添加等待提示
		                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
		                                $("<div class=\"datagrid-mask-msg\"></div>").html("召测单个预案中，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
		                            }
	   							}
	   						}
							else
								$.messager.alert("警告", "未获取到帧信息。", "error");
	   					}
	   				});
            	}
            	else{
            		$.messager.alert('提示','请选择需要召测的预案。','warning');
            	}
            }
            else {
            	$.messager.alert("警告", "通信异常，请刷新页面后重试。", "error");
            }
        }
        else {
        	$.messager.alert("警告", "您的浏览器不支持WebSocket。请选择其他的浏览器再尝试连接服务器。", "error");
        }
	}
	
	//查询预案
	function readPlanCount(){
        if (ws) {
            if (ws.readyState == 1) {
            	if (node && node.type == commonTreeNodeType.terminal){ //选择的节点是消防监测终端
	           		$.ajax({
	   					type: 'POST',
	   					url: "${pageContext.request.contextPath}/localPlan/readPlanCount",
	   					data: {
	   						"unitaddress": node.name
	   					},
	   					success: function(d) {
	   						if (d != "[]" && d != "") {
	   							if (d.indexOf("html") > 0) { //session超时
	   	                            parent.window.location.reload();
	   	                        }
	   							else{
	   								frameNumber++;
		                            //组帧，Global.js中定义
		                            var frame = makeWSFrame(frameNumber, 0, 1, 1, d, '');
		                            ws.send(frame);
		                            if ($("body").find(".datagrid-mask").length == 0) {
		                                //添加等待提示
		                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
		                                $("<div class=\"datagrid-mask-msg\"></div>").html("召测有效预案编号中，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
		                            }
	   							}
	   						}
							else
								$.messager.alert("警告", "未获取到帧信息。", "error");
	   					}
	   				});
            	}
            	else{
            		$.messager.alert('提示','请选择消防监测终端。','warning');
            	}
            }
            else {
            	$.messager.alert("警告", "通信异常，请刷新页面后重试。", "error");
            }
        }
        else {
        	$.messager.alert("警告", "您的浏览器不支持WebSocket。请选择其他的浏览器再尝试连接服务器。", "error");
        }
	}
	
	//设置预案
	function setPlan(){
        if (ws) {
            if (ws.readyState == 1) {
            	var row = $('#dg').datagrid('getSelected');
            	if (row){
			        $.ajax({
						type: 'POST',
						url: '${pageContext.request.contextPath}/localPlan/setPlan',
						data: {
							"planid": row.planid
						},
						success: function(d) {
							if (d != "" && d.indexOf("未知错误") == -1) {
								frameNumber++;
					            //组帧，Global.js中定义
					            var frame = makeWSFrame(frameNumber, 0, 1, 1, d, '');
					            ws.send(frame);  

								if ($("body").find(".datagrid-mask").length == 0) {
	                                //添加等待提示
	                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
	                                $("<div class=\"datagrid-mask-msg\"></div>").html("设置中，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
	                            }
							}
							else
								$.messager.alert("警告", "未获取到帧信息。", "error"); 
							
						}
					});
            	}
	        }
	        else {
	        	$.messager.alert("警告", "通信异常，请刷新页面后重试。", "error");
	        }
	    }
	    else {
	    	$.messager.alert("警告", "您的浏览器不支持WebSocket。请选择其他的浏览器再尝试连接服务器。", "error");
	    }
	}
	
	//执行预案
	function exePlan(){
        if (ws) {
            if (ws.readyState == 1) {
            	var row = $('#dg').datagrid('getSelected');
            	if (row){
            		$.messager.confirm('执行预案','确定要执行该预案吗？',function(r){
        				if (r){
			           		$.ajax({
			   					type: 'POST',
			   					url: "${pageContext.request.contextPath}/localPlan/exePlan",
			   					data: {
			   						"planid": row.planid
			   					},
			   					success: function(d) {
			   						if (d != "[]" && d != "") {
			   							if (d.indexOf("html") > 0) { //session超时
			   	                            parent.window.location.reload();
			   	                        }
			   							else{
			   								frameNumber++;
				                            //组帧，Global.js中定义
				                            var frame = makeWSFrame(frameNumber, 0, 1, 1, d, '');
				                            ws.send(frame);
				                            if ($("body").find(".datagrid-mask").length == 0) {
				                                //添加等待提示
				                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
				                                $("<div class=\"datagrid-mask-msg\"></div>").html("正在执行预案，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
				                            }
			   							}
			   						}
									else
										$.messager.alert("警告", "未获取到帧信息。", "error");
			   					}
			   				});
        				}
        			});
            	}
            	else{
            		$.messager.alert('提示','请选择预案。','warning');
            	}
            }
            else {
            	$.messager.alert("警告", "通信异常，请刷新页面后重试。", "error");
            }
        }
        else {
        	$.messager.alert("警告", "您的浏览器不支持WebSocket。请选择其他的浏览器再尝试连接服务器。", "error");
        }
	}
	
	//删除预案
	function deletePlan(){
		if (!ws) {
			$.messager.alert("警告", "您的浏览器不支持WebSocket。请选择其他的浏览器再尝试连接服务器。", "error");
			return;
		}
	    if (ws.readyState != 1) {
	    	$.messager.alert("警告", "通信异常，请刷新页面后重试。", "error");
	    	return;
	    }
		var row = $('#dg').datagrid('getSelected');
		if (row){
			$.messager.confirm('删除预案','确定要删除该预案吗？',function(r){
				if (r){
					if (row.result == 1){ //发送到前置机
					    $.ajax({
						    type:'POST', 
					        url:'${pageContext.request.contextPath}/localPlan/makeDeleteFrame',           
					        data:{"planid": row.planid},        
						    success:function(d){
							    if (d != "") {
								    if (d.indexOf("html") > 0) { //session超时
				                        parent.window.location.reload();
				                    }
								    else{
								    	frameNumber++;
			                            //组帧，Global.js中定义
			                            var frame = makeWSFrame(frameNumber, 0, 1, 1, d, '');
			                            ws.send(frame);
			                            if ($("body").find(".datagrid-mask").length == 0) {
			                                //添加等待提示
			                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
			                                $("<div class=\"datagrid-mask-msg\"></div>").html("正在删除预案，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
			                            }
									}
								}
					        },	        
					        error:function(data){
					        	$.messager.alert('警告',data,'error');		  
					        }
					    });
					}
					else{
						$.ajax({
						    type:'POST', 
					        url:'${pageContext.request.contextPath}/localPlan/deletePlan',           
					        data:{"planid": row.planid},        
						    success:function(d){
							    if (d != "") {
							    	if(d=="success"){
							    		$("#resultPanel").prepend("<div style='color:green;padding:5px'>预案删除成功。</div>");
						    		    $('#dg').datagrid('reload');
									}else{
										$("#resultPanel").prepend("<div style='color:red;padding:5px'>预案删除失败,请重试。</div>");
									}
								}
					        },	        
					        error:function(data){
					        	$.messager.alert('警告',data,'error');		  
					        }
					    });
					}
				}
			});
		}
		else{
    		$.messager.alert('提示','请选择预案。','warning');
    	}
	}
    
    /*连接websocket*/
    function connect() {
        var WebSocketsExist = true;
        try {
            ws = new ReconnectingWebSocket("ws://" + "${requestScope.websocketip}" + ":" + "${requestScope.websocketport}");
        }
        catch (ex) {
            try {
                ws = new ReconnectingWebSocket("ws://" + "${requestScope.websocketip}" + ":" + "${requestScope.websocketport}");
            }
            catch (ex) {
                WebSocketsExist = false;
            }
        }
        if (!WebSocketsExist) {
        	$.messager.alert("警告", "您的浏览器不支持WebSocket。请选择其他的浏览器再尝试连接服务器。", "error");
            return;
        }
        ws.onopen = WSonOpen;
        ws.onmessage = WSonMessage;
        ws.onclose = WSonClose;
        ws.onerror = WSonError;
    }

    function WSonOpen(e) {
    	//删除等待提示
        $("body").find("div.datagrid-mask-msg").remove();
        $("body").find("div.datagrid-mask").remove();
        //客户端端口组帧,帧类型为3（握手）
        var curPort = makeWSFrame(1, 0, 3, 1, port, '');
        ws.send(curPort);
    }

    function WSonMessage(event) {
        var msg = event.data;
        //解析帧，Global.js中定义
        var frame = parseWSFrame(msg);
        if (frame == "") return;
        //删除等待提示
        $("body").find("div.datagrid-mask-msg").remove();
        $("body").find("div.datagrid-mask").remove();
        //帧类型为3（握手），表示端口号
        if (frame.type == '3') {
            port = frame.data;
        }
        else if (frame.type == '2') {  //帧类型为2（应答）
            if (frame.data.length.toString() == frame.len) { //判断是否接收到完整的数据帧
            	$.ajax({
					type: 'POST',
					url: '${pageContext.request.contextPath}/localPlan/parseResponse',
					data: {
						"strXML": frame.data
					},
					success: function(d) {
						switch(d.result){
						case 1:
							switch(d.action){
							case "set":
								$("#resultPanel").prepend("<div style='color:green;padding:5px'>消防监测终端" + d.userDeviceAddr + "，预案编号" + d.planid + "，设置成功。</div>");
								$('#dg').datagrid('reload');
								break;
							case "get":
									if (d.data.length == 0){
										if(d.type==1)
											$("#resultPanel").prepend("<div style='color:red;padding:5px'>消防监测终端" + d.userDeviceAddr + "，预案编号" + d.planid + "，预案不存在。</div>");
										else if(d.type==129)
											$("#resultPanel").prepend("<div style='color:red;padding:5px'>消防监测终端" + d.userDeviceAddr + "不存在有效预案。</div>");
									}
									else{
										$.each(d.data, function(i, n){
											$("#resultPanel").prepend(n);
										})
									}
								break;
							case "delete":
								$("#resultPanel").prepend("<div style='color:green;padding:5px'>消防监测终端" + d.userDeviceAddr + "，预案编号" + d.planid + "，删除成功。</div>");
								$('#dg').datagrid('reload');
								break;
							}
							break;
						case 2:
							$.messager.alert("警告", "终端连接超时。", "error");
							break;
						case 3:
							$.messager.alert("警告", "终端否认应答。", "error");
							break;
						case 4:
							$.messager.alert("警告", "终端不在线。", "error");
							break;
						case 8:
							switch(d.action){
							case "set":
								$("#resultPanel").prepend("<div style='color:red;padding:5px'>消防监测终端" + d.userDeviceAddr + "，预案编号" + d.planid + "，设置预案失败。</div>");
								break;
							case "get":
								$("#resultPanel").prepend("<div style='color:red;padding:5px'>预案编号" + d.planid + "，查询预案失败。</div>");
								break;
							case "delete":
								$("#resultPanel").prepend("<div style='color:red;padding:5px'>消防监测终端" + d.userDeviceAddr + "，预案编号" + d.planid + "，删除预案失败。</div>");
								break;
							}
							break;
						default:
							$.messager.alert("警告", "未知错误。", "error");
							break;
						}
					}
				});
            }
        }
    }

    function WSonClose(e) {
        try {
        	$("body").find("div.datagrid-mask-msg").remove();
            $("body").find("div.datagrid-mask").remove();
            //$.messager.alert("警告", "远程服务器连接中断，请刷新页面后重试。", "error");
        }
        catch (ex) {

        }
    }

    function WSonError(e) {
        
    }
    
  //清空返回结果
    function clearResult(){
    	$("#resultPanel").html("");
    }
</script>
</body>
</html>