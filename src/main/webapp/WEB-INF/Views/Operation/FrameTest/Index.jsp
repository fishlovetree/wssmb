<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>透明转发</title>
<jsp:include page="../../Header.jsp"/>
<style type="text/css">
	.layout-split-north{
	    border-bottom: 1px solid #ccc;
	}
</style>
</head>
<body>
	<div class="easyui-layout" fit="true">
		<div region="north" style="height: 115px;" split="true">
			<table style="padding: 10px;" border="0" cellspacing="8" cellpadding="8">
				<tr>
					<td><textarea rows="5" cols="100" id="frameTa"></textarea></td>
					<td><a href="javascript:void(0)" class="easyui-linkbutton" onclick="send()" title="发送">发送</a></td>
				</tr>
			</table>
		</div>
		<div region="center"
			title="结果<a href='javascript:void(0)' class='easyui-linkbutton' style='float: right; width: 40px;' 
        onclick='clearResult();'>清空</a>"
			split="true">
			<div id="resultPanel" style="margin: 10px;"></div>
		</div>
	</div>
<script type="text/javascript">
	//websocket相关
	var ws;
	var port = '0'; //前一次端口号，断线重连时用到
	var frameNumber = 1; //帧序号

    $(function(){
    	//websocket
    	connect();
    })
	
	//发送帧到前置机
	function send(){
        var frame = $.trim($("#frameTa").val().replace(/\s+/g,""));
        if (frame == ""){
            return;
        }
        if (ws) {
            if (ws.readyState == 1) {
            	if ($('#fpForm').form('validate')){
            		$.ajax({
    					type: 'POST',
    					url: "${pageContext.request.contextPath}/frameTest/packetRequest",
    					data: {
    						"frame": frame
    					},
    					success: function(d) {
    						if (d != "") {
    							if (d.indexOf("html") > 0) { //session超时
    	                            parent.window.location.reload();
    	                        }
    							else{
    								frameNumber++;
    			                    //组帧，Global.js中定义
    			                    var f = makeWSFrame(frameNumber, 0, 1, 1, d, '');
    			                    ws.send(f);
    			                    if ($("body").find(".datagrid-mask").length == 0) {
    	                                //添加等待提示
    	                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
    	                                $("<div class=\"datagrid-mask-msg\"></div>").html("透抄中，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
    	                            }
    							}
    						}
    						else{
    							$("#resultPanel").prepend("<div style='color:red;padding:5px'>帧格式不正确。</div>");
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
					url: '${pageContext.request.contextPath}/frameTest/parseResponse',
					data: {
						"strXML": frame.data
					},
					success: function(d) {
						if (d == ""){
							$("#resultPanel").prepend("<div style='color:red;padding:5px'>透明转发失败。</div>");
						}
						else{
					        $("#resultPanel").prepend("<div style='padding:5px'>返回帧:  "+d+"</div>");
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
</script>
</body>
</html>