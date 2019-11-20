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
<title>冻结周期</title>
<jsp:include page="../../Header.jsp"/>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/waitstyle.css"
	media="screen" type="text/css" />
<style type="text/css">
.left-td {
	width: 85px;
}

.read-result-tbl {
	margin: 0px;
	padding: 0px;
	font-size: 12px;
	color: #335169;
	background: #fff;
	border-top: 1px solid #a8c7ce;
	border-right: 1px solid #a8c7ce;
}

.read-result-tbl th, .read-result-tbl td {
	padding: 2px 5px 2px 5px;
	border-bottom: 1px solid #a8c7ce;
	border-left: 1px solid #a8c7ce;
	vertical-align: middle;
}
.data-unit-cls{
    padding-left:5px;
}
    .layout-split-west {
	    border-right: 1px solid #ccc;
	}
	.layout-split-north{
	    border-bottom: 1px solid #ccc;
	}
</style>
</head>
<body>
	<div class="easyui-layout" fit="true">
		<div id="west" region="west" iconCls="icon-organization" split="true" title="设备" style="width:284px;min-width:284px;" collapsible="true">
			<jsp:include page="../../CommonTree/termGprs_DeviceTree.jsp"/>
		</div>
		<div id="mainPanel" region="center" style="overflow-y: hidden">
			<div class="easyui-layout" fit="true">
				<div region="north" style="height: 220px;" split="true">
					<table border="0" cellspacing="8" cellpadding="8">
						<tr>
							<td class="tableHead_right" align="right">节点：</td>
							<td><input type="text" id='snode' class="easyui-textbox"
								readonly="readonly" style="width: 200px;" /> <input
								type="hidden" id="selectedID" /> <input type="hidden"
								id="selectedType" /> <input type="hidden"
								id="unitid" /><input type="hidden"
								id="customerid" /></td>
						</tr>
					</table>
					<div class="easyui-tabs" id="electricTab" fit="true"
						data-options="tabPosition:'top'">
						<div title="冻结周期">
							<form id="fpForm" class="easyui-form" method="post">
								<table cellspacing="8" style="min-width: 500px;">
								    <tr id="realtimeTr">
			                            <td class="left-td">
			                                                                          实时冻结周期:
			                            </td>
			                            <td>
			                                <input type="text" class="easyui-numberbox" id="periodTxt" name="period" data-options="min:0,max:99"/>
			                            </td>
			                        </tr>
			                        <tr>
			                            <td class="left-td">
			                                                                          周期冻结周期:
			                            </td>
			                            <td>
			                                <select id="freezingTypeSel" name="freezingtype" class="easyui-combobox" style="width:100px;">
			                                    <option value="11">日冻结</option>
			                                    <option value="77">周冻结</option>
			                                    <option value="99">月冻结</option>
											 </select>
											 &nbsp;(注:设置操作有效)
			                            </td>
			                        </tr>
			                        <tr>
			                            <td class="left-td">
			                            </td>
			                            <td>
			                                <a href="javascript:void(0)" class="easyui-linkbutton" onclick="setFreezingPeriod()" title="设置">设置</a>
	                                        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="readFreezingPeriod()" title="查询">查询</a>
			                            </td>
			                        </tr>
			                    </table>
							</form>
						</div>
					</div>	
				</div>
				<div region="center"
					title="结果<a href='javascript:void(0)' class='easyui-linkbutton' style='float: right; width: 40px;' 
		        onclick='clearResult();'>清空</a>"
					split="true">
					<div id="resultPanel" style="margin: 10px;"></div>
				</div>
			</div>
		</div>
	</div>
<script type="text/javascript">
	//websocket相关
	var ws;
	var port = '0'; //前一次端口号，断线重连时用到
	var frameNumber = 1; //帧序号
	
	var sendXmlCount = 0; //发送到前置机总数量
	var msgCount = 0; //接收到前置机消息数量
	var progressBar; //进度条
	//初始化进度条参数
	function initProgress() {
		sendXmlCount = 0;
		msgCount = 0;
	    progressBar = undefined;
	    $.messager.progress('close');
	}
	
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
			if (node.type >= commonTreeNodeType.terminal){ //消防监测终端及其子节点；智慧用电终端
        		$("#snode").textbox('setValue', node.text);
                $("#selectedID").val(node.gid);
                $("#selectedType").val(node.type);
                var sysType; //系统类型
                switch (node.type){
                    case commonTreeNodeType.gprsBigType: //gprs大类
                    	var pnode = treeTab.tree('getParent', node.target);
                    	$("#customerid").val(node.gid);
                    	sysType = node.gid;
                    	break;
                    case commonTreeNodeType.gprsDevice: //gprs设备
                        var pnode = treeTab.tree('getParent', node.target);
                        sysType = pnode.gid;
                    	break;
                    case commonTreeNodeType.terminalBigType: //消防监测终端大类
                        var pnode = treeTab.tree('getParent', node.target);
                        $("#unitID").val(pnode.gid);
                        sysType = node.gid;
                    	break;
                    case commonTreeNodeType.terminalDevice: //消防监测终端设备
                        var pnode = treeTab.tree('getParent', node.target);
                        sysType = pnode.gid;
                    	break;
                }
                if (sysType == 10){
                	$("#realtimeTr").css('display', '');
                	$("#periodTxt").val("");
                }
                else{
                	$("#realtimeTr").css('display', 'none');
                	$("#periodTxt").val(0);
                }
        	}
		}
	}
	
	//设置冻结周期
	function setFreezingPeriod(){
		var selectedID = $.trim($("#selectedID").val());
    	var selectedType = $.trim($("#selectedType").val());
        if (selectedID == "") {
        	$.messager.alert("提示", "请选择节点。", "warning");
            return;
        }
        var freezingtype = $.trim($("#freezingTypeSel").combobox('getValue'));
        if (ws) {
            if (ws.readyState == 1) {
            	if ($('#fpForm').form('validate')){
            		$.ajax({
    					type: 'POST',
    					url: "${pageContext.request.contextPath}/freezingPeriod/setFreezingPeriod",
    					data: {
    						"id": selectedID,
    						"type": selectedType,
    						"unitid": $("#unitid").val(),
    						"customerid": $("#customerid").val(),
    						"freezingtype": freezingtype,
    						"period": $("#periodTxt").val() == '' ? 0 : $("#periodTxt").val()
    					},
    					success: function(d) {
    						if (d != "") {
    							if (d.indexOf("html") > 0) { //session超时
    	                            parent.window.location.reload();
    	                        }
    							else{
	    							var a = JSON.parse(d);
	    							if (a.length > 0){
		    							$.messager.progress({
		                                    title: '设置中，请稍后...',
		                                    interval: 0
		                                });
		                                progressBar = $.messager.progress('bar');
		                                sendXmlCount = a.length;
		    							for(var p in a){
		    								frameNumber++;
		    	                            //组帧，Global.js中定义
		    	                            var frame = makeWSFrame(frameNumber, 0, 1, 1, a[p], '');
		    	                            ws.send(frame);
		    							}
    								}
    							}
    						}
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
	
	//查询冻结周期
	function readFreezingPeriod(){
		var selectedID = $.trim($("#selectedID").val());
    	var selectedType = $.trim($("#selectedType").val());
        if (selectedID == "") {
        	$.messager.alert("提示", "请选择终端。", "warning");
            return;
        }
        if (ws) {
            if (ws.readyState == 1) {
		        $.ajax({
					type: 'POST',
					url: '${pageContext.request.contextPath}/freezingPeriod/getFreezingPeriod',
					data: {
						"id": selectedID,
						"type": selectedType,
						"unitid": $("#unitid").val(),
						"customerid": $("#customerid").val()
					},
					success: function(d) {
						if (d != "") {
							if (d.indexOf("html") > 0) { //session超时
	                            parent.window.location.reload();
	                        }
							else{
								var a = JSON.parse(d);
								if (a.length > 0){
									$.messager.progress({
		                                title: '查询中，请稍候...',
		                                interval: 0
		                            });
		                            progressBar = $.messager.progress('bar');
		                            sendXmlCount = a.length;
									for(var p in a){
										frameNumber++;
			                            //组帧，Global.js中定义
			                            var frame = makeWSFrame(frameNumber, 0, 1, 1, a[p], '');
			                            ws.send(frame);
									}
								}
							}
						}
					}
				});
	        }
	        else {
	        	$.messager.alert("警告", "通信异常，请刷新页面后重试。", "error");
	        }
	    }
	    else {
	    	$.messager.alert("警告", "您的浏览器不支持WebSocket。请选择其他的浏览器再尝试连接服务器。", "error");
	    }
	}
    
    //清空返回结果
    function clearResult(){
    	$("#resultPanel").html("");
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
    	initProgress(); //初始化进度条
        //客户端端口组帧,帧类型为3（握手）
        var curPort = makeWSFrame(1, 0, 3, 1, port, '');
        ws.send(curPort);
    }

    function WSonMessage(event) {
        var msg = event.data;
        //解析帧，Global.js中定义
        var frame = parseWSFrame(msg);
        if (frame == "") return;
        //帧类型为3（握手），表示端口号
        if (frame.type == '3') {
            port = frame.data;
        }
        else if (frame.type == '2') {  //帧类型为2（应答）
        	if (progressBar) { //进度变更
                msgCount++;
                if (msgCount == sendXmlCount || frame.num.substr(1) == frameNumber) { //关闭进度条
                    progressBar.progressbar("setValue", 100);
                    setTimeout(function () {
                        $.messager.progress('close');
                    }, 800);
                    initProgress();
                }
                else {
                    var rate = 0;
                    if (sendXmlCount != 0) rate = Math.floor(msgCount / sendXmlCount * 100);
                    progressBar.progressbar("setValue", rate);
                }
            }
            if (frame.data.length.toString() == frame.len) { //判断是否接收到完整的数据帧
            	$.ajax({
					type: 'POST',
					url: '${pageContext.request.contextPath}/freezingPeriod/parseResponse',
					data: {
						"strXML": frame.data
					},
					success: function(d) {
						switch(d.result){
						case 1:
							switch (d.typeFlagCode){
							case 131:
								$("#resultPanel").prepend("<div style='color:green;padding:5px'>设置冻结周期成功。</div>");
								break;
							case 209:
								$("#resultPanel").prepend("<div style='color:green;padding:5px'>查询冻结周期成功。</div>");
								$.each(d.data, function(i, n){
									$("#resultPanel").prepend(n);
								});
								break;
							}
							break;
						case 2:
							$("#resultPanel").prepend("<div style='color:red;padding:5px'>终端连接超时。</div>");
							break;
						case 3:
							$("#resultPanel").prepend("<div style='color:red;padding:5px'>终端否认应答。</div>");
							break;
						case 4:
							$("#resultPanel").prepend("<div style='color:red;padding:5px'>终端不在线。</div>");
							break;
						case 8:
							switch (d.typeFlagCode){
							case 131:
								$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置冻结周期失败。</div>");
								break;
							case 209:
								$("#resultPanel").prepend("<div style='color:red;padding:5px'>查询冻结周期失败。</div>");
								break;
							}
							break;
						default:
							$("#resultPanel").prepend("<div style='color:red;padding:5px'>未知错误。</div>");
							break;
						}
					}
				});
            }
        }
    }

    function WSonClose(e) {
        try {
        	initProgress(); //初始化进度条
            //$.messager.alert("警告", "远程服务器连接中断，请刷新页面后重试。", "error");
        }
        catch (ex) {

        }
    }

    function WSonError(e) {
        
    }
</script>
</body>
</html>