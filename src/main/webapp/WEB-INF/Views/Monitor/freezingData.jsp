<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>冻结数据列表</title>
<jsp:include page="../Header.jsp"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/datagrid-detailview.js"></script>
<style type="text/css">
.layout-split-west {
    border-right: 1px solid #ccc;
}

.datagrid-header-row td[field="_expander"] .datagrid-cell {
   padding: 2px 4px;
   width:15px;
}
</style>
</head>
<body>

<!-- 公用 -->
<input type="hidden" id="selectedID" /> 
<input type="hidden" id="selectedType" /> 
<input type="hidden" id="selectedName" />

<input type="hidden" id="selectedParentid" />
<input type="hidden" id="selectedUpType" value="" />
<input type="hidden" id="selectedCommType" value="" />

<div class="easyui-layout" fit="true">
	<div id="west" region="west" iconCls="icon-organization" split="true" title="设备" style="width: 284px;min-width:284px;height: 100%;">
		<jsp:include page="../CommonTree/deviceTree.jsp"/>
	</div>
	<div id="dayPanel" region="center">
	    <div id="toolbar">
			<div>   
		        <label for="user">节点:</label>   
		        <input type="text" id='snode' class="easyui-textbox" readonly="readonly" style="width:200px;" />
		        <label for="time">时间:</label>   
		        <input class="easyui-datebox" editable="fasle" type="text" id="starttime"  name="starttime" /> 
		        <label for="time">-</label>   
		        <input class="easyui-datebox" editable="fasle" type="text" id="endtime"  name="endtime" /> 
		        <a href="javascript:void(0)" class="easyui-linkbutton button-edit button-default" data-options="iconCls:'icon-search'" onclick="doSearch()" title="Search">检索</a>
			</div>  
		</div>	
		<table id="dg"></table>
		<div id="dataDlg" class="easyui-dialog" style="width:450px;height:300px;" closed="true" buttons="#data-dlg-buttons">
		    <div id="dataPanel" style="margin:10px;"></div>
		</div>
		<div id="data-dlg-buttons">
			<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dataDlg').dialog('close')">关闭</a>
		</div>
	</div>
</div>
<script type="text/javascript">
var node;
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

	var thisMonth = new Date().getUTCMonth()+1;//本月
	var thisYear = new Date().getUTCFullYear();//今年
	var thisDay = new Date().getDate()-1;//昨日
	var endDay = new Date().getDate();//今日
	var start = thisYear+'-'+thisMonth+'-'+thisDay;
	var end = thisYear+'-'+thisMonth+'-'+endDay;
	$('#starttime').datebox('setValue', start);//告警列表
	$('#endtime').datebox('setValue', end);	 
	
	doSearch();
}); 

var treeTab = $('#region_tree');
//公用树点击事件
function treeClick(treeObj, n){
	if(typeof n!='undefined' ){
		node = n;
		treeTab = treeObj;
		$("#selectedID").val(node.gid);
	    $("#selectedType").val(node.type);
	    $("#selectedName").val(node.name);
		clickNode();
	}
}

function clickNode(){
	if(null==node || node=="")
		if(null!=treeTab.tree('getSelected'))
			node=treeTab.tree('getSelected');
		else{
			$.messager.alert('提示',"请选择树节点！",'info');
			return;
		}
    $("#selectedParentid").val(0);
    $("#selectedUpType").val("");
    $("#selectedCommType").val("");
    
	switch (node.type){//消防监测终端
	case commonTreeNodeType.terminalBigType:
    	var pnode = treeTab.tree('getParent', node.target);
        $("#selectedParentid").val(pnode.gid);//customerid
        $("#selectedUpType").val("1");
    	break;
    case commonTreeNodeType.gprsBigType:
    	var pnode = treeTab.tree('getParent', node.target);
        $("#selectedParentid").val(pnode.gid);//customerid
        $("#selectedUpType").val("0");
	    $("#selectedCommType").val("3");
    	break;
    }
    
    doSearch();
}

function doSearch() {
	setFirstPage($("#dg"));
	$('#dg').datagrid({
		view: detailview,//注意1
		url :'${pageContext.request.contextPath}/sysMonitor/freezingDataJson',
		queryParams: {
			id : $("#selectedID").val(),
			type : $("#selectedType").val(),
			nodeName : $("#selectedName").val(),
	    	parentid: $("#selectedParentid").val(),
	    	uptype : $("#selectedUpType").val(),
	    	commtype : $("#selectedCommType").val(),
	    	starttime: $("#starttime").datebox('getValue'),
	    	endtime: $("#endtime").datebox('getValue')
		},
		pagination : true,//分页控件
		pageList: [10, 20, 30, 40, 50],
		//title:"错误日志",
		fit: true,   //自适应大小
		singleSelect: true,
		nowrap: true,//数据长度超出列宽时将会自动截取。
		striped: true,
		rownumbers:true,//行号
		fitColumns:true,//自动使列适应表格宽度以防止出现水平滚动。
		toolbar:'#toolbar',
		columns: [[  
			{title: '设备名称', field: 'equipmentname', width:'250px'},
			{title: '设备地址', field: 'equipmentaddress', width:'250px'},
			{title: '冻结时间', field: 'freezetime', width:'250px'}
			//{title: '冻结数据', field: 'freezingdata', width:'350px', align: 'left'}                         
	    ]],
	    onLoadSuccess:function(){
			$('.button-tbl').linkbutton({ });
		},  
	    detailFormatter:function(index,row){//注意2
	        return '<div style="padding:2px"><table id="'+ row.equipmentaddress + index + '" style="width: 100%;border-collapse: collapse; border:1px solid #cad9ea;"></table></div>';  
	    },  
	    onExpandRow:function(index,row){//注意3
	    	var rows = $('#dg').datagrid('getRows');
	        $.each(rows,function(i,k){
	            //获取当前所有展开的子网格
	            var expander = $('#dg').datagrid('getExpander',i);
	            if(expander.length && expander.hasClass('datagrid-row-collapse')){
	                if(k.systemtype != row.systemtype || k.equipmentaddress != row.equipmentaddress 
	                		|| k.freezetime != row.freezetime){
	                    //折叠上一次展开的子网格
	                    $('#'+ k.equipmentaddress + i).html("");
	                    $('#dg').datagrid('collapseRow',i);
	                }
	            }
	        });
	        
	        var html="";
	        $('#'+ row.equipmentaddress + index).html(html);
	        
	        $.ajax({
				type: 'POST',
				url: '${pageContext.request.contextPath}/sysMonitor/getFreezingDataDetails',
				data: {
					"id" : row.id,
					"systemType": row.systemtype,
					"productmodel": row.productmodel,
					"commtype": row.commtype,
					"equipmentaddress": row.equipmentaddress 
				},
				success: function(data) {
					if (data != '') {
						var freezingdata = data;
						var items = freezingdata.split(',');
						var len = items.length;
				        
				        switch(row.systemtype){
							case "10"://电气火灾监控系统
							//case "20"://消火栓系统-目前为做
								html += makedetailtable(len,items,2);
								break;
							case "11"://可燃气体报警系统
							case "128"://火灾烟感检测系统
							case "129"://消防水压监控系统
							case "130"://报警按钮及声光报警器
							case "131"://消防水位监控系统
							case "18"://防火卷级防火门监控系统
								html += makedetailtable(len,items,1);
								break;
							default:
								html += makedetailtable(len,items,1);
								break;
						}
				        
				        $('#'+ row.equipmentaddress + index).html(html);
				        
				        $('#dg').datagrid('fixDetailRowHeight',index);  
					}
				}
			});  
	    } 
	});
}

function makedetailtable(len,items,index){
	var html="";
	
	html += "<tr style='height: 25px; text-align: center; background: #e7e7e7; color: #654b24; font-size: 14px;'>";
	for(var j=0;j<index;j++){ 
		html += "<th class='detailviewborder'>名称</th><th class='detailviewborder' colspan='2'>值(发生时间)</th>";
	}
	html += "</tr>";
	
	for(var i=0;i<len;i=i+index){ 
		html += "<tr style='height: 22px;'>";
		
		for(var j=0;j<index;j++){
			var name=items[i+j].slice(0,items[i+j].indexOf(':'));
			var vlue=items[i+j].substring(items[i+j].indexOf(':')+1); 
			
			var value,time="";
			if(vlue.indexOf('(')!=-1){
				value=vlue.substring(0,vlue.indexOf('('));
				time=vlue.substring(vlue.indexOf('('));
			}
			else{
				value=vlue;
			}
			var color = "#2a8aba";
			if(theme==1)
				color = "#fb9d48 ";
			html += "<td class='detailviewborder' style='padding-left: 5px;'>" + name + 
			" </td><td class='' style='padding-left: 5px;border-top: 1px solid "+color+" !important;border-right: 0px !important;border-bottom: 1px solid "+color+" !important;'>" + value + 
			"</td><td class='' style='padding-left: 5px;border-top: 1px solid "+color+" !important;border-right: 1px solid "+color+" !important;border-bottom: 1px solid "+color+" !important;'>" + time + "</td>";
		}
		
		html += "</tr>";
    }
	return html;
}

//查看数据明细
function showData(data){
	$('#dataDlg').dialog('open').dialog('setTitle','数据明细');
	$("#dataPanel").html(data);
}
</script>
</body>
</html>