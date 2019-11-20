<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
    <%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<jsp:include page="../../Header.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/waitstyle.css" media="screen" type="text/css" />
<style type="text/css">
	.mTable{border-collapse:collapse;
	border:1px solid gray;
}
.mTable tr  td{ border:1px solid gray;}
	.layout-split-west {
	    border-right: 1px solid #ccc;
	}
#mainPanle .panel-header {
    border-top: 1px solid #ccc;
}
</style>	
</head>
<body>
<div class="easyui-layout" fit="true">
    <div id="west" region="west" iconCls="icon-organization" split="true" title="终端/GPRS设备" style="width:284px;min-width:284px;" collapsible="true">
		<jsp:include page="../../CommonTree/termGprs_UnitTree.jsp"/>
	</div>
	<div id="mainPanle" region="center" style="overflow-y:hidden">
		<div class="easyui-tabs" id="tab" style="width:100%;height:30%" data-options="tabPosition:'top'">
       		<div title="声报警配置字" style="padding:10px" id="250"></div>
      		<div title="光报警配置字" style="padding:10px" id="251"></div>
       		<div title="继电器配置字"  style="padding:10px" id="252"></div>
     	</div>
     	<!-- 查询设置按钮 -->
     	<div style="margin:0 10px 10px 10px;" align="right">
     		<a href="#" class="easyui-linkbutton button-default" onclick="set()">设置</a>
     	    <a href="#" class="easyui-linkbutton button-success" onclick="read()">查询</a>
 	    </div>
     	<!--查询/设置结果  -->
     	<div id="p" class="easyui-panel" title="<b>控制字</b><span>查询/设置结果</span> <a href='javascript:void(0)' class='easyui-linkbutton' style='float: right; width: 40px;' 
        onclick='clearResult();'>清空</a>" style="width:100%;height:70%;" data-options="cls:'theme-title-block-blue'">
            <div class="easyui-layout" data-options="fit:true">
                <div id="www" data-options="region:'west',split:true" style="width:38%;padding:10px">
                   	<div id="txt"></div>
                </div>
                <div id="wwe" data-options="region:'center'" style="padding:10px"> </div>
            </div>
        </div>
	</div>	
</div>
<div class="l-wrapper" style="display: none">
    <!-- loading效果 -->
    <svg id="mysvg" viewBox="0 0 120 120" version="1.1" >
        <g id="circle" class="g-circles g-circles--v3">
            <circle id="12" transform="translate(35, 16.698730) rotate(-30) translate(-35, -16.698730) " cx="35" cy="16.6987298" r="10"></circle>
            <circle id="11" transform="translate(16.698730, 35) rotate(-60) translate(-16.698730, -35) " cx="16.6987298" cy="35" r="10"></circle>
            <circle id="10" transform="translate(10, 60) rotate(-90) translate(-10, -60) " cx="10" cy="60" r="10"></circle>
            <circle id="9" transform="translate(16.698730, 85) rotate(-120) translate(-16.698730, -85) " cx="16.6987298" cy="85" r="10"></circle>
            <circle id="8" transform="translate(35, 103.301270) rotate(-150) translate(-35, -103.301270) " cx="35" cy="103.30127" r="10"></circle>
            <circle id="7" cx="60" cy="110" r="10"></circle>
            <circle id="6" transform="translate(85, 103.301270) rotate(-30) translate(-85, -103.301270) " cx="85" cy="103.30127" r="10"></circle>
            <circle id="5" transform="translate(103.301270, 85) rotate(-60) translate(-103.301270, -85) " cx="103.30127" cy="85" r="10"></circle>
            <circle id="4" transform="translate(110, 60) rotate(-90) translate(-110, -60) " cx="110" cy="60" r="10"></circle>
            <circle id="3" transform="translate(103.301270, 35) rotate(-120) translate(-103.301270, -35) " cx="103.30127" cy="35" r="10"></circle>
            <circle id="2" transform="translate(85, 16.698730) rotate(-150) translate(-85, -16.698730) " cx="85" cy="16.6987298" r="10"></circle>
            <circle id="1" cx="60" cy="10" r="10"></circle>
        </g>
    </svg>
</div>
</body>
<script type="text/javascript">
//websocket相关
var ws;
var port = '0'; //前一次端口号，断线重连时用到
var frameNumber = 1; //帧序号
var start; //命令开始时间
var mResultType;

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
	//tab点击事件
	$('#tab').tabs({
	    border:false,
	    onSelect:function(title,index){
	    	showTab();
	    },
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
	
	connect(); //连接websocket
});

/*连接websocket*/
function connect() {
	var WebSocketsExist = true;
	try {
		 ws = new ReconnectingWebSocket("ws://" + "${requestScope.websocketip}"+ ":" + "${requestScope.websocketport}"); 
	} catch (ex) {
		try {
			ws = new ReconnectingWebSocket("ws://" + "${requestScope.websocketip}"+ ":" + "${requestScope.websocketport}"); 
		} catch (ex) {
			WebSocketsExist = false;
		}
	}
	if (!WebSocketsExist) {
		$.messager.alert("警告", "您的浏览器不支持WebSocket。请选择其他的浏览器再尝试连接服务器。","error");
		return;
	}
	ws.onopen = WSonOpen;
	ws.onmessage = WSonMessage;
	ws.onclose = WSonClose;
	ws.onerror = WSonError;
}

function WSonOpen(e) {
	//客户端端口组帧,帧类型为3（握手）
	var curPort = makeWSFrame(1, 0, 3, 1, port, '');
	ws.send(curPort);
}

function WSonMessage(event) {
	//console.log(event.data);
	var msg = event.data;
	
	//解析帧，Global.js中定义
	var frame = parseWSFrame(msg);
	if (frame == ""){
		//删除等待提示
		disLoad(); 
		return;
	}		
	//帧类型为3（握手），表示端口号
	if (frame.type == '3') {
		port = frame.data;
		disLoad(); 
	} else if (frame.type == '2') { //帧类型为2（应答）
		if (frame.data.length.toString() == frame.len) { //判断是否接收到完整的数据帧		
			$.ajax({
				type : 'POST',
				url : '${pageContext.request.contextPath}/controlWord/parsePacketXMLControlParam',
				data : {
					"strXml" : frame.data
				},
				success : function(d) {
					var result=0;  //返回结果：0-失败；1-成功
					var resultType;//返回类型:0-查询；1-设置
					resultType=mResultType;
					var data;//返回的结果
        			if(d.result==1){//成功
        				result=1;
        				if(null!=d.data && d.data!="") data=d.data;
        				else data="0000000000000000";
        				if(d.typeFlagCode==210 && d.type==0){ //成功应答
        					resultType=0;
        					queryEqual(data,d.configurationCode,d.address);//查询比较
        				}else if((d.typeFlagCode==132 && d.type==1) || 
        						(d.typeFlagCode==139 && d.type==1)){
        					resultType=1;
       						//设置成功同时修改数据库参数
       						var myUrl="${pageContext.request.contextPath}/controlWord/editControlParam";
       						editContolParam(d.address,d.configurationCode,d.data,myUrl);
        				}
        			}else{
        				if (d.result==3 && d.typeFlagCode==139 && d.data != "") {
							var data = d.data;
	                        if (data.indexOf("html") <= 0) { //session超时
   								frameNumber++;
   	                            //组帧，Global.js中定义
   	                            var frame = makeWSFrame(frameNumber, 0, 1, 1, data, '');
   	                            ws.send(frame);
	                        }
						}
        				else
        					result=0;//失败
        			}
        			var end = new Date().getTime();//接受时间	
        			create((end - start)+"ms",resultType,result,d.errorCode);
        			//删除等待效果
        			disLoad();
				}
			});
		}
	}
}

function WSonClose(e) {
	try {
		disLoad();
		//$.messager.alert("警告", "远程服务器连接中断，请刷新页面后重试。", "error");
	} catch (ex) {

	}
}

function WSonError(e) {

}

var treeTab = $('#region_tree');
//公用树点击事件
var node;
function treeClick(treeObj, n){
	if(typeof n!='undefined' ){
		node=n;
		treeTab = treeObj;
		showTab();		
	}
}

//tab刷新事件
//node 选中的节点
function showTab(){
	if(null==node || node=="")
		if(null!=treeTab.tree('getSelected'))
			node=treeTab.tree('getSelected');
	
	var tableUrl="";
	var current_tab = $('#tab').tabs('getSelected');
	var tabId = current_tab.panel('options').id; // 相应的标签页id,对应控制类型
	if(node && (node.type == commonTreeNodeType.terminal || node.type == commonTreeNodeType.gprsDevice)) 
		tableUrl='${pageContext.request.contextPath}/controlWord/lastDataPage?type='+tabId+'&address='+node.name;
	else tableUrl='${pageContext.request.contextPath}/controlWord/lastDataPageNoUnit';
	$('#tableList').html("");
	$('#tab').tabs('update',{
		tab:current_tab,
		options : {
		//content : '<iframe scrolling="auto" frameborder="0" src="‘+URL+‘" style="width:100%;height:100%;"></iframe>',
		href:tableUrl,
		}
	});
	current_tab.panel('refresh');
	
	//清空表格
	$('#p #wwe #tableDiv').empty();
} 

//获取选中的tabid对应类型
function getTabId(){
	var tabId=$('#tab').tabs('getSelected').panel('options').id;
	return tabId;
}

//查询参数
function read(){		
	var type = getTabId();
	mResultType = 0;
	//判断是否是终端
	if(node && (node.type == commonTreeNodeType.terminal || node.type == commonTreeNodeType.gprsDevice)){
		load();
		start = new Date().getTime();//起始时间
		var mData={"address": node.name, "evenType": type};
		//ajax掉后台xml接口
		$.ajax({
	        type : 'POST',
	        url : '${pageContext.request.contextPath}/controlWord/queryPacketXMLControlParam',
	        data :mData,
	        success : function(data) {
			var frame = makeWSFrame(frameNumber, 0, 1, 1, data, '');				
			    ws.send(frame);//发送数据
	        },
	        error:function(data){
				 $.messager.alert('警告',data,'error');
	     	} 
	    });
	 }else{
		$.messager.alert('<spring:message code="Prompt"/>',"请选择终端。",'warning');
	} 
	
 }
 //查询成功后的参数和数据的比较并显示
 function queryEqual(param,type,address){	
	$('#p #wwe').panel({
		href:'${pageContext.request.contextPath}/controlWord/query?param='+param+'&type='+type+'&address='+address,
	}); 
 }

//设置参数
function set(){	
	var type = getTabId();
	mResultType = 1;
	//判断是否是终端
	if(node && (node.type == commonTreeNodeType.terminal || node.type == commonTreeNodeType.gprsDevice)){	
		var current_tab = $('#tab').tabs('getSelected');
		var tabId = current_tab.panel('options').id; // 相应的标签页id,对应控制类型
		//7-0bit位
		var param_01 = getParam(tabId+"_01");
		//15-8bit位
		var param_02 = getParam(tabId+"_02");
		var param = param_02+param_01;
		var s = "0";
		//要设置的参数
		var myParam = s+param.substring(1,param.length);
		load();
		start = new Date().getTime();//起始时间		
		var mData={"address": node.name, type: type, "parameter": myParam}
		//ajax进行后台组帧
		$.ajax({
	        type : 'POST',
	        url : '${pageContext.request.contextPath}/controlWord/setPacketXMLControlParam',
	        data :mData,
	        success : function(data) {
	        	//调用websocket设置，成功后更改数据库，并刷新表格	        		
	        	var frame = makeWSFrame(frameNumber,0, 1,1,data, '');
				ws.send(frame);//发送数据
	        },
	        error:function(data){
				$.messager.alert('警告',data,'error');
	     	} 
	    }); 
		//清空表格
		$('#p #wwe #tableDiv').empty();		
	}else{
		$.messager.alert('<spring:message code="Prompt"/>',"请选择终端。",'warning');
	}

}
//获取状态拼凑字符串
function getParam(trId){
	var objInput = document.getElementById(trId).getElementsByTagName("input");
	var s="";
	for (i = 0; i < objInput.length; i++) {
		 var name=objInput[i].name;
		var id=objInput[i].id; 
		if(name=="" && null!=id && id!=""){
			//var status= $("#"+id).switchbutton("options").checked;
			var status= objInput[i].checked;
			if(status) s+="1";
			else s+="0";
		}
	}
	return s;
}

//修改数据库数据
function editContolParam(address,type,myParam,url){
	var mData={"address":address,"type":type,"parameter":myParam}
	$.ajax({
        type : 'POST',
        url : url,
        data :mData,
        success : function(data) {

        },
        error:function(data){
			$.messager.alert('警告',data,'error');
        } 
    });
}


//弹出加载层
function load() {  
    $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: $(window).scrollTop() + $(window).height()}).appendTo("body"); 
   // $("<div class=\"datagrid-mask-msg\"></div>").html("Processing,please wait.....").appendTo("body").css({ display: "block", left: ($(document.body).outerWidth(true) - 190) / 2, top:$(document).scrollTop() + ($(window).height()-300) * 0.5 });  
 	$(".l-wrapper").css("display","block");//show的display属性设置为block（显示）
}  
  
//取消加载层  
function disLoad() {  
    $(".datagrid-mask").remove();  
   // $(".datagrid-mask-msg").remove();  
    $(".l-wrapper").css("display","none");//show的display属性设置为none（隐藏）
}
//查询/设置成功,type:查询:0,设置:1;result:失败:0,成功:1
function create(time,type,result,errorCode){
	var name="";
	if(type==0) name="查询";
	else name="设置";
	var date=(new Date()).toLocaleString( );//获取当前日期时间
    var txt = document.getElementById("txt");
    var div = document.createElement("div");
    if(result==0) {
    	var error="";
    	if(errorCode==2){error="终端连接超时,"}
    	else if(errorCode==3){error="终端否认应答,"}
    	else if(errorCode==4){error="终端不在线,"}
    	///else if(errorCode==8){error="失败。"}
    	else {error="未知错误,"}
    	div.innerHTML = "<p style='color:red;font-size:12px;'>"+date+ name+"失败,"+error+"耗时"+time+"</p>";
    }
  	else div.innerHTML = "<p style='color:green;font-size:12px;'>"+date+ name+"成功,耗时"+time+"</p>";
    txt.appendChild(div);
}
//清空记录
function clearResult(){
	$('#p #wwe #tableDiv').empty();
	$('#txt').empty();
}

</script>
</html>