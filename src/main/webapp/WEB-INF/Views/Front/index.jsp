<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
    <%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>万胜智慧表箱系统</title>
<style type="text/css">
.datagrid-mask-msg {
  color: #FFF;
}
</style>
<script>
var basePath = '${pageContext.request.contextPath}';
var alarmDataUrl = '${pageContext.request.contextPath}/visualization/getAlarmData?Math.random()';
var parseAlarmDataUrl = '${pageContext.request.contextPath}/visualization/parseAlarmData?Math.random()'; 
var getUserMessage = '${pageContext.request.contextPath}/getUserMessage?Math.random()'; 
var getOfflineCustomerlist = '${pageContext.request.contextPath}/getOfflineInfo?Math.random()'; 
var getLockByMacUrl = '${pageContext.request.contextPath}/getLockByMac?Math.random()'; 


</script>
<jsp:include page="../FrontHeader.jsp"/>
<link type="text/css" href="${pageContext.request.contextPath}/css/Front/index.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/gis/iconfont/iconfont.css" rel="stylesheet" />

<link rel="shortcut icon" href="${pageContext.request.contextPath}/images/Avatar.png" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.cookie.js"></script>

<!-- 拼图相关 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/img.css"> 
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.lgymove.js"></script> 
<script type="text/javascript" src="${pageContext.request.contextPath}/js/parseAlarm.js"></script>
</head>
<body>

<!--  消息框 -->
<div class="newsBox" style="display:none;">
    <!-- <audio id="happenAlarm" src="${pageContext.request.contextPath}/audios/happenAlarm.mp3" style="opacity:0;display:none;width: 0;height: 0" preload="auto" controls  hidden="true" /></audio> -->
	<a href="javascript:" class="controlBtn open">
		<span class='LR-arrow L-arrow'></span>
	</a>
	<a href="javascript:" class="alarmBar open">
		<div class="alarmBarTitle">告警框</div>
	</a>
	<a href="javascript:" class="faultBar close">
		<div class="faultBarTitle">设备故障框</div>
	</a>
	<a href="javascript:" class="messageBar close">
		<div class="messageBarTitle">消息框</div>
	</a>
	<!-- 告警框 -->
	<div class="alarmBox">
	    <div class="alarmContent">
	    	<!--<img src="${pageContext.request.contextPath}/images/nowarn.png" style="width: 220px;"/>-->
	    </div>
    </div>
    <!-- 故障框 -->
    <div class="faultContent" style="display:none;">
    </div>
        <!-- 消息框 -->
    <div class="messageContent" style="display:none;">
    </div>
</div>

<!-- 修改密码弹出框 -->
<form id="pwdDialog"></form>

<!-- 二维码弹出框 -->
<div id="QRCodedlg">
</div>

<!-- 弹出框：关于等 -->
<div id="setdlg">
</div>

<!-- 弹出框：帮助文档 -->
<div id="helpDocument" class="easyui-dialog" style="width:700px;height:500px;" closed="true" data-options="modal:true">
	<table id="fileList" style="width:100%;height:100%" ></table>
</div>
      
<script>
	var hometitle="<spring:message code='SystemHomePage'/>";
	//websocket相关
	var ws;
	var port = '0'; //前一次端口号，断线重连时用到
	var seq=0;//第几次请求握手
	var frameNumber = 1; //帧序号
	var userMessage={};
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
	
	//用于使chart自适应高度和宽度,通过父元素计算容器高宽
	var resizeDiv = function () {
		var width=window.innerWidth;
		var boxWidth=false;

		if(width<1111){
			$(".hide_img").hide();
			if(width<980){
				$(".hide_title").hide();
				if(width<345) boxWidth=true;
			}
			else
				$(".hide_title").show();
		}
		else{
			$(".hide_img").show();
			$(".hide_title").show();
		}
		
		var span=$('.newsBox .LR-arrow');
		var als=span.prop("class");
		
		if(boxWidth){
			$('.newsBox').width(width-40);
			$('.alarmBox').width(width-40);
			$('.faultContent').width(width-40);
			
			$('.alarmTitle').width(width-42);
			$('#alarmCount').width(width-68);
			$('.alarmContent').width(width-42);
			
			
			if (als=="LR-arrow L-arrow") 
				$('.newsBox').css('right','-'+(width-40+5)+'px');
			else 
				$('.newsBox').css('right','0px');
		}
		else{
			$('.newsBox').width(300);
			$('.alarmBox').width(300);
			$('.faultContent').width(300);
			
			$('.alarmTitle').width(298);
			$('#alarmCount').width(272);
			$('.alarmContent').width(298);
			
			if (als=="LR-arrow L-arrow") 
				$('.newsBox').css('right','-305px');
			else 
				$('.newsBox').css('right','0px');
		}
		
	};
	<!---->
	$(function () {	
		
		//获取当前用户名及id
		$.ajax({
            type: "post",
            url: getUserMessage,
            data: {},
            async : false,
		    success: function(d) {
		    	userMessage=d;
			}
		});
		//设置容器高宽
		resizeDiv();
		//浏览器大小改变时重置大小
		window.onresize = function () {
			//设置容器高宽
			resizeDiv();
		};
		
	   	initNewsBox(); //初始化告警框

	    //绑定默认导航栏
        getTopMenu();
	    
	    $('#ulMenu>li').hover(
            function () {
            	var temp=$(this);
            	var of = temp.offset();
                var m = temp.data('menu');
                if (!m) {
                    m = $(this).find('ul').clone();
                    m.appendTo(document.body);
                    $(this).data('menu', m);
                    m.css({left: of.left, top: 50});//ul下的sub显示位置
                    m.hover(function () {
                    	temp.find('h3').find('a').addClass("bannerbtn-hover");
                        
                        clearTimeout(m.timer);
                    }, function () {
                    	temp.find('h3').find('a').removeClass("bannerbtn-hover");
                    	
                        m.hide();
                    });
                }
                else
                	m.css({left: of.left, top: 50});//ul下的sub显示位置
                temp.find('h3').find('a').addClass("bannerbtn-hover");
                
                m.show();
            }, function () {
            	$(this).find('h3').find('a').removeClass("bannerbtn-hover");
            	
                var m = $(this).data('menu');
                if (m) {
                    m.timer = setTimeout(function () {
                    	m.hide();
                    }, 100);//延时隐藏，时间自定义，100ms
                }
            } 
        );
	    
	    $('#top_menu').on('click', 'li', function(e){
            $('#top_menu li').removeClass('front_head_select');
            $('#top_menu li').addClass('front_head');
            
            $(this).removeClass('front_head');
            $(this).addClass('front_head_select');

            //$(this).find('a')[0].click();
        });//导航class 点击切换
	
        $('.newsBox').show();
		
	   	//websocket
	   
		/*//延迟1秒发送*/
		setTimeout(function(){
			connect();
		},2000);

    	$("iframe[name='monitor']").attr('src', '${pageContext.request.contextPath}/home');
	});
	
	//生成顶部导航栏
    function getTopMenu(){
        var params={};
        $.ajax({
           	url:'${pageContext.request.contextPath}/getMenuJson',
           	data:params,
           	type:"post",
           	dataType:"json",
           	success:function(data){
           		if(data=="-1"){
           			$.messager.show({title: '<spring:message code="Prompt"/>', msg: '<spring:message code="GetMenuJsonFailed"/>'});
           			return;
           		}
           		else{
           			var top_html="";
           			for(var i=0;i<data.length;i++){
           				var e=data[i];
           				var pid = e.superid;
                        var isSelected = i == 0 ? true : false;
	                    if(null!=e.children && e.children!="undefined"){
		           			$.each(e.children, function(j, o) {
		            			 if(o.menuurl!=""){
		            				var url=o.menuurl;
		            				var icon='fa fa-file-text-o';
		            				if(null!=o.menuicon && o.menuicon!="")
		            					icon = 'fa ' +o.menuicon;
		            				
		            				var c="front_head";
		            				if(i==0 && j==0) c="front_head_select";
		            						            				
		            				top_html += '<li id="" title="'+ o.text+'" class="'+c+'" style="text-align:center;" onclick="openPage(\''+'${pageContext.request.contextPath}'+url+'\', \''+o.text+'\', \''+o.menuicon+'\', \''+o.menuenname+'\')">'
		            				+'<a ref="' + o.id + '" class="menucss" href="javascript:void(0)">'
		            				+'<p><lable class="'+icon+'"></lable></p><p class="m_title"><lable style="white-space:nowrap;">'+ o.text+'</lable></p></a></li>';
		            			}
		            			else{ 
		            				menulist += '<li><span>'+o.text+'</span></li>';
		            			}
		            		});
		            		
		           		}
           			}
	       			$('#top_menu').html(top_html);
           		}
           	},
           	error:function(e){
           		$.messager.alert('<spring:message code="Warning"/>','<spring:message code="ConnectionFailure"/>', 'error');
           	}
       });
    	
    }
	
	// 退出系统
	function logout() {
	    $.messager.confirm('<spring:message code="Prompt"/>', '<spring:message code="SureToExit"/>', function (r) {
	        if (r) {
	            $.messager.progress({
	                text: '<spring:message code="Exiting"/>'
	            });
	            window.location.href = '${pageContext.request.contextPath}/logout';
	        }
	    });
	}
	
	function modifyPwd() {
	    // 修改密码窗口
	    $('#pwdDialog').dialog({
		    width: 320,    
		    height: 280, 
		    modal: true,
		    iconCls:'fa fa-key',
		    href: '${pageContext.request.contextPath}/modifyPassword',
	    	title: '<spring:message code="ChangePassword"/>',
	        buttons: [{
	            text: '<spring:message code="Determine"/>',
	            iconCls: 'icon-ok',
	            btnCls: 'easyui-btn',
	            handler: function () {
	                if ($('#pwdDialog').form('validate')) {
	                    if ($("#password").val().length > 50) {
	                        $.messager.alert('<spring:message code="Prompt"/>', '<spring:message code="PasswordRules"/>', 'warning');
	                    } else {
	                        var formData = $("#pwdDialog").serialize();
	                        $.ajax({
	                            url: '${pageContext.request.contextPath}/changePassword',
	                            type: 'post',
	                            cache: false,
	                            data: formData,
	                            beforeSend: function () {
	                                $.messager.progress({
	                                    text: '<spring:message code="Operating"/>'
	                                });
	                            },
	                            success: function (data, response, status) {
	                                $.messager.progress('close');
	                                if (data == "success") {
	                                	$.messager.alert('<spring:message code="Prompt"/>', '<spring:message code="SuccessOperation"/>', 'info');
	                                    $("#pwdDialog").dialog('close').form('reset');
	            						
	            					} else {
	            						$.messager.alert('<spring:message code="Warning"/>', '<spring:message code="ChangePasswordFailed"/>', 'error');
	            					}
	                            }
	                        });
	                    }
	                }
	            }
	        },{
	            text: '<spring:message code="Cancel"/>',
	            iconCls: 'icon-cancel',
	            btnCls: 'easyui-btn',
	            handler: function () {
	            	$("#pwdDialog").dialog('close');
	            }
	        }],
	        onOpen: function () {
	            $(this).panel('refresh');
	        }
	    }).dialog('open');
	    $("#pwdDialog").window('center');//使Dialog居中显示
	};
	   
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
	    ws.onaction=WSonAction;
	}
	
	function WSonAction(data){
		if(ws.readyState==1){
			 ws.send(data);
		}else{
			$.messager.alert("警告", "操作失败，未连接前置机。", "error");
		}
	}
	
	function WSonOpen(e) {
		 //已经建立连接   
		//客户端端口组帧,帧类型为3（握手）
		//var curPort = makeWSFrame(1, 0, 3, 1, port, '');
		//ws.send(curPort);
		var json={};
		json.userid=userMessage.id;
		json.username=userMessage.username;
        json.type="FF";
        json.FSNo="01";
        json.svrtype="07";
        json.port=port;
        json.reportflag="1";
        json.format="0";
        json.seq=seq;
        seq++;
        var str = JSON.stringify(json);
        var length=str.length;
        var len=length.toString(16);
        len=len.padStart(4, "0"); 
        str=len+str;
		ws.send(str);
	}
	
	function WSonClose(e) {
		try {
			initProgress(); //初始化进度条
			//$.messager.alert("警告", "远程服务器连接中断，请刷新页面后重试。", "error");
		} catch (ex) {
	
		}
	}
	
	function WSonError(evt) {
		/* //产生异常  
		$.messager.alert("警告", evt.message, "error"); */
	}
	 
	//初始化告警框
	function initNewsBox(){
		var left=$('#index_layout').width()-40;
		if(left>305)
			left=300;
		$('.newsBox').css('right','-'+(left+5)+'px');
		$('.controlBtn').click(function(){	
			left=$('#index_layout').width()-40;
			if(left>305)
				left=300;
			
			var span=$('.newsBox .LR-arrow');
			var als=span.prop("class");
			
			if (als=="LR-arrow L-arrow") {
				span.prop("class","LR-arrow R-arrow");
				$('.newsBox').animate({right:'0'},500);
			}else {
				span.prop("class","LR-arrow L-arrow");
				$('.newsBox').animate({right:'-'+(left+5)+'px'},500);
			}
		});
		$('.alarmBar').click(function(){	
			var span=$('.newsBox .LR-arrow');
			var als=span.prop("class");
			
			$('.alarmBox').show();
			$('.alarmBar').removeClass("close");
			$('.alarmBar').addClass("open");
			
			$('.faultContent').hide();
			$('.faultBar').removeClass("open");
			$('.faultBar').addClass("close")
			
			$('.messageContent').hide();
			$('.messageBar').removeClass("open");
			$('.messageBar').addClass("close");;
		});
		
		$('.faultBar').click(function(){	
			var span=$('.newsBox .LR-arrow');
			var als=span.prop("class");
			
			$('.faultContent').show();
			$('.faultBar').removeClass("close");
			$('.faultBar').addClass("open");
			
			$('.alarmBox').hide();
			$('.alarmBar').removeClass("open");
			$('.alarmBar').addClass("close");
			
			$('.messageContent').hide();
			$('.messageBar').removeClass("open");
			$('.messageBar').addClass("close");
		});
		$('.messageBar').click(function(){	
			var span=$('.newsBox .LR-arrow');
			var als=span.prop("class");
			
			$('.messageContent').show();
			$('.messageBar').removeClass("close");
			$('.messageBar').addClass("open");
			
			$('.alarmBox').hide();
			$('.alarmBar').removeClass("open");
			$('.alarmBar').addClass("close");
			
			$('.faultContent').hide();
			$('.faultBar').removeClass("open");
			$('.faultBar').addClass("close");
		});
	}
	
	var alarmBoxIdObj = {}; //告警表箱ID集合
	
	function parseAlarm(d){
		var dataArray = d;
		if(!dataArray.endTime || dataArray.oadOI == "FF29"){
			if(dataArray.mbAmmeterList && dataArray.mbAmmeterList.measureFile){
				//$(".alarmContent").empty();
				var latstr=dataArray.mbAmmeterList.measureFile.latitude;
				var lonstr=dataArray.mbAmmeterList.measureFile.longitude;
				var alarmBarTitleStr="";
				alarmBarTitleStr +="<div class=\"alarmBarId\" name=\"" + dataArray.mbAmmeterList.ammeterCode + "alarm" + dataArray.oadOI + "\" style=\"min-height: 27px;border-bottom: 1px dashed white;\" onclick=\"latlon("+latstr+","+lonstr+")\"><i class=\"iconfont icon-position\"></i>"+
				"<input id=\"latlonId\" style=\"display:none\" value=\""+latstr+","+lonstr+"\">"
				+"<input name=\"boxId\" style=\"display:none\" value=\"" + dataArray.mbAmmeterList.measureFile.measureId + "\">"
				+"<input name=\"deviceType\" style=\"display:none\" value=\"meter\">"
				+"<input name=\"deviceAddress\" style=\"display:none\" value=\"" + dataArray.mbAmmeterList.ammeterCode + "\">"
				+"<input name=\"oadOI\" style=\"display:none\" value=\"" + dataArray.oadOI+ "\">"
				+"<input name=\"valueText\" style=\"display:none\" value=\"" + dataArray.valueText+ "\">"
				+"<input name=\"lineIndex\" style=\"display:none\" value=\"" + dataArray.lineIndex+ "\">" //过温线路编号
				+"<lable style=\"font-size: 14px;padding-left: 25px;color:white \">设备名称："
				+dataArray.mbAmmeterList.ammeterName+"</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">告警事件：" + dataArray.alarmMessage;
				if (dataArray.valueText){
					alarmBarTitleStr += "</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">告警数据：" +dataArray.valueText;
				}
				alarmBarTitleStr += "</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">告警时间："
				+dataArray.occurTime+"</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">表箱安装地址："
				+dataArray.mbAmmeterList.measureFile.address+"</lable></br><a href=\"#\" class=\"easyui-linkbutton button-default button-view l-btn l-btn-small\" group=\"\" id=\""+dataArray.mbAmmeterList.id+"\"></a>";
				if(dataArray.octet){
					alarmBarTitleStr +="<lable  style=\"font-size: 14px;padding-left: 25px; color:white \">电器种类："
						+dataArray.octet+"</lable>";
				}
				alarmBarTitleStr +="</div>";
				$(".alarmContent").prepend(alarmBarTitleStr);
				
				if(!alarmBoxIdObj[d.mbAmmeterList.measureFile.measureId]){
        			alarmBoxIdObj[d.mbAmmeterList.measureFile.measureId] = d.mbAmmeterList.measureFile.measureId;
    			}
			}
			if(dataArray.mbTerminalList && dataArray.mbTerminalList.measureFile){
				//$(".alarmContent").empty();
				var latstr=dataArray.mbTerminalList.measureFile.latitude;
				var lonstr=dataArray.mbTerminalList.measureFile.longitude;
				var alarmBarTitleStr="";
				alarmBarTitleStr +="<div class=\"alarmBarId\" name=\"" + dataArray.mbTerminalList.address + "alarm" + dataArray.oadOI + "\" style=\"min-height: 27px;border-bottom: 1px dashed white;\" onclick=\"latlon("+latstr+","+lonstr+")\"><i class=\"iconfont icon-position\"></i>"+
				"<input id=\"latlonId\" style=\"display:none\" value=\""+latstr+","+lonstr+"\">"
				+"<input name=\"boxId\" style=\"display:none\" value=\"" + dataArray.mbTerminalList.measureFile.measureId + "\">"
				+"<input name=\"deviceType\" style=\"display:none\" value=\"terminal\">"
				+"<input name=\"deviceAddress\" style=\"display:none\" value=\"" + dataArray.mbTerminalList.address + "\">"
				+"<input name=\"oadOI\" style=\"display:none\" value=\"" + dataArray.oadOI+ "\">"
				+"<input name=\"valueText\" style=\"display:none\" value=\"" + dataArray.valueText+ "\">"
				+"<input name=\"lineIndex\" style=\"display:none\" value=\"" + dataArray.lineIndex+ "\">" //过温线路编号
				+"<lable style=\"font-size: 14px;padding-left: 25px;color:white \">设备名称："
				+dataArray.mbTerminalList.terminalName+"</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">告警事件：" + dataArray.alarmMessage;
				if (dataArray.valueText){
					alarmBarTitleStr += "</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">告警数据：" +dataArray.valueText;
				}
				alarmBarTitleStr += "</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">告警时间："
				+dataArray.occurTime+"</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">表箱安装地址："
				+dataArray.mbTerminalList.measureFile.address+"</lable></br><a href=\"#\" class=\"easyui-linkbutton button-default button-view l-btn l-btn-small\" group=\"\" id=\""+dataArray.mbTerminalList.terminalId+"\"></a></div>";
				$(".alarmContent").prepend(alarmBarTitleStr);
				
				if(!alarmBoxIdObj[d.mbTerminalList.measureFile.measureId]){
        			alarmBoxIdObj[d.mbTerminalList.measureFile.measureId] = d.mbTerminalList.measureFile.measureId;
    			}
			}
			if(dataArray.mbAieLockList && dataArray.mbAieLockList.measureFile){
				//$(".alarmContent").empty();
				var latstr=dataArray.mbAieLockList.measureFile.latitude;
				var lonstr=dataArray.mbAieLockList.measureFile.longitude;
				var alarmBarTitleStr="";
				alarmBarTitleStr +="<div class=\"alarmBarId\" name=\"" + dataArray.mbAieLockList.lockCode + "alarm" + dataArray.oadOI + "\" style=\"min-height: 27px;border-bottom: 1px dashed white;\" onclick=\"latlon("+latstr+","+lonstr+")\"><i class=\"iconfont icon-position\"></i>"+
				"<input id=\"latlonId\" style=\"display:none\" value=\""+latstr+","+lonstr+"\">"
				+"<input name=\"boxId\" style=\"display:none\" value=\"" + dataArray.mbAieLockList.measureFile.measureId + "\">"
				+"<input name=\"deviceType\" style=\"display:none\" value=\"elock\">"
				+"<input name=\"deviceAddress\" style=\"display:none\" value=\"" + dataArray.mbAieLockList.mac + "\">"
				+"<input name=\"oadOI\" style=\"display:none\" value=\"" + dataArray.oadOI+ "\">"
				+"<input name=\"valueText\" style=\"display:none\" value=\"" + dataArray.valueText+ "\">"
				+"<lable style=\"font-size: 14px;padding-left: 25px;color:white \">设备名称："
				+dataArray.mbAieLockList.lockName+"</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">告警事件：" + dataArray.alarmMessage;
				if (dataArray.valueText){
					alarmBarTitleStr += "</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">告警数据：" +dataArray.valueText;
				}
				alarmBarTitleStr += "</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">告警时间："
				+dataArray.occurTime+"</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">表箱安装地址："
				+dataArray.mbAieLockList.measureFile.address+"</lable></br><a href=\"#\" class=\"easyui-linkbutton button-default button-view l-btn l-btn-small\" group=\"\" id=\""+dataArray.mbAieLockList.id+"\"></a></div>";
				$(".alarmContent").prepend(alarmBarTitleStr);
				
				if(!alarmBoxIdObj[d.mbAieLockList.measureFile.measureId]){
        			alarmBoxIdObj[d.mbAieLockList.measureFile.measureId] = d.mbAieLockList.measureFile.measureId;
    			}
			}
		}else{//当有结束时间  删除弹出框的告警消息
			var boxId; //表箱id
			if(dataArray.mbAmmeterList){
				boxId = dataArray.mbAmmeterList.measureFile.measureId;
				var items = $(".alarmContent").find("div[name='" + dataArray.mbAmmeterList.ammeterCode + "alarm" + dataArray.oadOI + "']");
				if (items){
					$.each(items, function(i, n){
						n.remove();
					})
				}
			}
			if(dataArray.mbTerminalList){
				boxId = dataArray.mbTerminalList.measureFile.measureId;
				if (dataArray.oadOI != "FF29"){
					var items = $(".alarmContent").find("div[name='" + dataArray.mbTerminalList.address + "alarm" + dataArray.oadOI + "']");
					if (items){
						$.each(items, function(i, n){
							n.remove();
						})
					}
				}
			}
			if(dataArray.mbAieLockList){
				boxId = dataArray.mbAieLockList.measureFile.measureId;
				var items = $(".alarmContent").find("div[name='" + dataArray.mbAieLockList.lockCode + "alarm" + dataArray.oadOI + "']");
				if (items){
					$.each(items, function(i, n){
						n.remove();
					})
				}
			}
			if (boxId){
				if ($(".alarmContent").find("input[name='boxId'][value='"+boxId+"']").length == 0){
					alarmBoxIdObj[boxId] = null;
				}
			}
		}
		if ($(".alarmContent").find("div").length != 0){
			//打开告警框
			$('.newsBox').animate({right:'0'},500);
			var span=$('.newsBox .LR-arrow');
			var als=span.prop("class");
			span.prop("class","LR-arrow R-arrow");
			$('.alarmBar').click();
		}
		else{
			var left=$('#index_layout').width()-40;
			if(left>305)
				left=300;
			$('.newsBox').animate({right:'-'+(left+5)+'px'},500);
			var span=$('.newsBox .LR-arrow');
			var als=span.prop("class");
			span.prop("class","LR-arrow L-arrow");
		}
		//地图告警动画
		if ($('iframe').attr('name') == "monitor"){
			monitor.window.addBoxAlarm(alarmBoxIdObj);
		}
	}
	
	//告警定位
	function latlon(latstr,lonstr){
		if ($('iframe').attr('name') == "monitor"){
			monitor.window.latlonStr(latstr,lonstr);
		}	 
	}
	
	function parseFault(d){
		var faultBarTitleStr="";
		$(".faultContent").empty();
		var dataArray = d.rows;
		for(var i=0;i<dataArray.length;i++){
			var latstr=dataArray[i].latitude;
			var lonstr=dataArray[i].longitude;
			for(var j=0;j<dataArray[i].mbAmmeterList.length;j++){
				var faultBarTitleStr="";
				faultBarTitleStr +="<div class=\"alarmBarId\" style=\"min-height: 27px;border-bottom: 1px dashed white;\" onclick=\"latlon("+latstr+","+lonstr+")\"><i class=\"iconfont icon-position\"></i>"+
				"<input id=\"latlonId\" style=\"display:none\" value=\""+dataArray[i].latitude+","+dataArray[i].longitude+"\">"
				+"<lable style=\"font-size: 14px;padding-left: 25px;color:white \">设备名称："
				+dataArray[i].mbAmmeterList[j].ammeterName+"</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">故障事件："
				+"电表故障"+"</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">故障时间："
				+dataArray[i].mbAmmeterList[j].earlyWarning.occurtime+"</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">表箱安装地址："
				+dataArray[i].address+"</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">设备安装位置："
				+dataArray[i].mbAmmeterList[j].installAddress+"</lable></br><a href=\"#\" class=\"easyui-linkbutton button-default button-view l-btn l-btn-small\" group=\"\" id=\"\" onclick=\"closeFault('"
				+dataArray[i].mbAmmeterList[j].earlyWarning.id+"')\"><span class=\"l-btn-left\"><span class=\"l-btn-text\">结束故障</span></span></a></div>";
				$(".faultContent").prepend(faultBarTitleStr);
			}
			if(dataArray[i].terminals!=null){
				for(var j=0;j<dataArray[i].terminals.length;j++){
					var faultBarTitleStr="";
					faultBarTitleStr +="<div class=\"alarmBarId\" style=\"min-height: 27px;border-bottom: 1px dashed white;\" onclick=\"latlon("+latstr+","+lonstr+")\"><i class=\"iconfont icon-position\"></i>"+
					"<input id=\"latlonId\" style=\"display:none\" value=\""+dataArray[i].latitude+","+dataArray[i].longitude+"\">"
					+"<lable style=\"font-size: 14px;padding-left: 25px;color:white \">设备名称："
					+dataArray[i].terminals[j].terminalName+"</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">告警事件："
					+"终端故障"+"</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">告警时间："
					+dataArray[i].terminals[j].earlyWarning.occurtime+"</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">表箱安装地址："
					+dataArray[i].address+"</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">设备安装位置："
					+dataArray[i].terminals[j].installationLocation+"</lable></br><a href=\"#\" class=\"easyui-linkbutton button-default button-view l-btn l-btn-small\" group=\"\" id=\"\" onclick=\"closeAlarm('"
					+dataArray[i].terminals[j].earlyWarning.id+"')\"><span class=\"l-btn-left\"><span class=\"l-btn-text\">结束告警</span></span></a></div>";
					$(".faultContent").prepend(faultBarTitleStr);
				}
			}
			
		}
	}

	function parseMessage(d){
		var messageBarTitleStr="";
		//$(".messageContent").empty();
		var dataArray = d;
		if (dataArray.loadData){
			if (dataArray.loadData.length == 0){
				return;
			}
			if(dataArray.mbAmmeterList && dataArray.mbAmmeterList.measureFile){
				var latstr=dataArray.mbAmmeterList.measureFile.latitude;
				var lonstr=dataArray.mbAmmeterList.measureFile.longitude;
				$.each(dataArray.loadData, function(i, n){
					var messageBarTitleStr="";
					messageBarTitleStr +="<div class=\"alarmBarId\" style=\"min-height: 27px;border-bottom: 1px dashed white;\" onclick=\"latlon("+latstr+","+lonstr+")\"><i class=\"iconfont icon-position\"></i>"+
					"<input id=\"latlonId\" style=\"display:none\" value=\""+latstr+","+lonstr+"\">"
					+"<lable style=\"font-size: 14px;padding-left: 25px;color:white \">电表名称："
					+dataArray.mbAmmeterList.ammeterName+"</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">电器种类："
					+n.devicetype + "</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">当前状态："
					+n.status + "</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">累计运行时间："
					+n.runtime + "</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">累积消耗电能："
					+n.powervalue + "</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">累计启停次数："
					+n.times + "</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">最近一次开启时间："
					+n.starttime + "</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">最近一次停止时间："
					+n.stoptime + "</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">推送时间："
					+dataArray.occurTime+"</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">表箱安装地址："
					+dataArray.mbAmmeterList.measureFile.address+"</lable></br></div>";
					$(".messageContent").prepend(messageBarTitleStr);
				})
			}
			else{
				return;
			}
		}
		else{
			if(dataArray.mbAmmeterList){
				var latstr=dataArray.mbAmmeterList.measureFile.latitude;
				var lonstr=dataArray.mbAmmeterList.measureFile.longitude;
				var messageBarTitleStr="";
				messageBarTitleStr +="<div class=\"alarmBarId\" style=\"min-height: 27px;border-bottom: 1px dashed white;\" onclick=\"latlon("+latstr+","+lonstr+")\"><i class=\"iconfont icon-position\"></i>"+
				"<input id=\"latlonId\" style=\"display:none\" value=\""+latstr+","+lonstr+"\">"
				+"<lable style=\"font-size: 14px;padding-left: 25px;color:white \">设备名称："
				+dataArray.mbAmmeterList.ammeterName+"</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">电表消息："
				+"电表消息" + "</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">推送时间："
				+dataArray.occurTime+"</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">表箱安装地址："
				+dataArray.mbAmmeterList.measureFile.address+"</lable></br></div>";
				$(".messageContent").prepend(messageBarTitleStr);
			}
			if(dataArray.mbTerminalList){
				var messageBarTitleStr="";
				messageBarTitleStr +="<div class=\"alarmBarId\" style=\"min-height: 27px;border-bottom: 1px dashed white;\" onclick=\"latlon("+dataArray.mbTerminalList.measureFile.latitude+","+dataArray.mbTerminalList.measureFile.longitude+")\"><i class=\"iconfont icon-position\"></i>"+
				"<input id=\"latlonId\" style=\"display:none\" value=\""+dataArray.mbTerminalList.measureFile.latitude+","+dataArray.mbTerminalList.measureFile.longitude+"\">"
				+"<lable style=\"font-size: 14px;padding-left: 25px;color:white \">设备名称："
				+dataArray.mbTerminalList.terminalName+"</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">消息内容："
				+"终端消息"+"</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">推送时间："
				+dataArray.occurTime+"</lable></br><lable  style=\"font-size: 14px;padding-left: 25px; color:white \">表箱安装地址："
				+dataArray.mbTerminalList.measureFile.address+"</lable></br></div>";
				$(".messageContent").prepend(messageBarTitleStr);
			}
		}
		//打开告警框
		$('.newsBox').animate({right:'0'},500);
		var span=$('.newsBox .LR-arrow');
		var als=span.prop("class");
		span.prop("class","LR-arrow R-arrow");
		$('.messageBar').click();
	}
	//接收到前置机端口确认帧后 发送请求上报命令
	function send() {
	    if (ws && ws.readyState == 1) {
	        $.ajax({
	            type: "post",
	            url: alarmDataUrl,
	            data: {},
	            async: false,
	            success: function (d) {
	                if (d != "") {
	                	var a = JSON.parse(d);
	                	for(var p=0;p<a.length;p++){
						//for(var p in a){
							frameNumber++;
	                        //组帧，Global.js中定义
	                        var frame = makeWSFrame(frameNumber, 0, 5, 1, a[p], '');
	                        ws.send(frame);
						}
	                }
	            }
	        });
	    }
	}
	/*
	*	websocket解帧
	*/
	/*
	 * 封装方法一     获取当前时间
	 * */
	function dateFtt() { //author: meizz   
		var date = new Date(); //获取系统当前时间
		var fmt="yyyy-MM-dd hh:mm:ss";
	    var o = {
	        "M+": date.getMonth() + 1, //月份   
	        "d+": date.getDate(), //日   
	        "h+": date.getHours(), //小时   
	        "m+": date.getMinutes(), //分   
	        "s+": date.getSeconds(), //秒   
	        "q+": Math.floor((date.getMonth() + 3) / 3), //季度   
	        "S": date.getMilliseconds() //毫秒   
	    };
	    if(/(y+)/.test(fmt))
	        fmt = fmt.replace(RegExp.$1, (date.getFullYear() + "").substr(4 - RegExp.$1.length));
	    for(var k in o)
	        if(new RegExp("(" + k + ")").test(fmt))
	            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
	    return fmt;
	}
	
	function WSonMessage(event) { 
		//event={"apduType":"136","subApduType":"2","piid_acd":"09","followReportOption":"0","followReport":"null","timeTagOption":"0","timeTag":"null","resultRecords":[{"oad":"60120300","rcsd":"04","listCSD":[{"csd":{"option":"00","oad":"202A0200"}},{"csd":{"option":"00","oad":"60400200"}},{"csd":{"option":"00","oad":"60420200"}},{"csd":{"option":"01","oad":"50020200","road":{"listOAD":[{"oad":"00100201"},{"oad":"00200201"},{"oad":"20000200"},{"oad":"20010200"},{"oad":"20040232"},{"oad":"05020032"},{"oad":"0A020001"}]}}}],"dar":"0"}]};
		if(!event){
			return;
		}
		console.log(event.data);
		var str = event.data;    //要截取的字符串
        var index = str.indexOf("{");
        var result = str.substr(index,str.length);
		event=eval('(' + result + ')');
		//是否需要判断nak？怎么处理？
		//event={"seq":8,"SA":"246123456789","type":136,"subType":2,"data":{"apduType":"136","subApduType":"2","piid_acd":"3d","followReportOption":"0","followReport":"\"null\"","timeTagOption":"0","timeTag":"\"null\"","resultRecords":[{"oad":"60120300","rcsd":"05","listCSD":[{"csd":{"option":"00","oad":"60400200"}},{"csd":{"option":"00","oad":"60410200"}},{"csd":{"option":"00","oad":"60420200"}},{"csd":{"option":"00","oad":"202A0200"}},{"csd":{"option":"01","oad":"30200200","road":{"listOAD":[{"oad":"201E0200"},{"oad":"20200200"},{"oad":"20220200"}]}}}],"recordRows":[[{"type":"date_time_s","value":"07E30A080F1400"},{"type":"date_time_s","value":"07E30A080F150F"},{"type":"date_time_s","value":"07E30A080F1500"},{"type":"TSA","value":"05000000000010"},{"type":"array","value":[{"type":"date_time_s","value":"07E30A080F111F"},{"type":"NULL","value":""},{"type":"double_long_unsigned","value":"00000002"}]}]]}]}};
		if(event.type && event.type == "FF"){//连接握手
			port=event.port;
			if(event.result=="nak"){				
				$.messager.alert("警告", "连接请求被拒绝。", "error");
			}
		}
		if(event.type && event.type == "FE"){//智能e锁
		    var mac=event.data.mac;
		    var d={};
	        $.ajax({
	            type: "post",
	            url: getLockByMacUrl,
	            data: {mac:mac},
	            async: false,
	            success: function (data) {
	            	d.mbAieLockList=data;
	            	d.occurTime=dateFtt();
	    		    d.endTime="";
	            }
	        });
		    var lockstatus=event.data.lockstatus;///* 0x01表示开锁，0x02表示关锁*/
		    var openStatus;///* 1表示开锁，0表示关锁(对应数据库中字段)*/
		    if(lockstatus=="01"){
		    	openStatus = 1;
		    	d.alarmMessage="E锁开锁事件"
			    parseAlarm(d);
			    //三维联动
			    if ($('iframe').attr('name') == "monitor" && monitor.window.isVirtualInfoVisible()){
				    monitor.window.openElock(mac);
			    } 
			    else if ($('iframe').attr('name') == "virtual"){
				    virtual.window.openElock(mac);
			    }
		    }else if(lockstatus=="02"){
		    	openStatus = 0;
		    	d.alarmMessage="E锁关锁事件";
			    parseAlarm(d);
			    //三维联动
			    if ($('iframe').attr('name') == "monitor" && monitor.window.isVirtualInfoVisible()){
				    monitor.window.closeElock(mac);
		        } 
		        else if ($('iframe').attr('name') == "virtual"){
			        virtual.window.closeElock(mac);
		        }
			
		    }
		    //更改数据库e锁开关状态
			if (openStatus != undefined && d.mbAieLockList){
				$.ajax({
		            type: "post",
		            url: '${pageContext.request.contextPath}/changeElockOpenStatus?Math.random()',
		            data: {openStatus: openStatus, id: d.mbAieLockList.id},
		            async: false,
		            success: function (d) {
		                
		            }
		        });
			}
	    }
		if(event.data){
			event=event.data;
			 if(event.apduType=="136"){
				 parseWSFrame(event);	//解析帧
			 }else if(event.apduType=="137"){
				 if(event.transResult.option=="01"){
					 $.messager.alert("提示", "拉合闸操作成功。", "info");
					 //alert("拉合闸操作成功！");
				 }else{
					 $.messager.alert("提示", "拉合闸操作失败。", "info");
				 }
			 }
		}
	}
        
    function parseWSFrame(event) {
        //遍历整个集合
	    for(var i = 0; i < event.resultRecords.length; i++){
			if(!event.resultRecords[i].recordRows || event.resultRecords[i].recordRows.length == 0){
				continue;
			}
			//遍历行
			for (var k = 0; k < event.resultRecords[i].recordRows.length; k++){
				var columnDatas = event.resultRecords[i].recordRows[k].columnDatas;
				if(!columnDatas){
					continue;
				}
				var alarmData = {};//用来装 每一条告警数据,一个columnDatas对应一个设备
				if(event.timeTag == ""){
					alarmData.occurTime = dateFtt();//获取当前时间
				}
				//遍历数据项
				for(var j= 0; j < columnDatas.length; j++){
					var type = event.resultRecords[i].recordRows[k].columnDatas[j].type; //数据项类型
					if(type == "TSA"){ //表地址或监测终端地址
						var TSAStr = event.resultRecords[i].recordRows[k].columnDatas[j].value;
						var TSAAddress = TSAStr.slice(2);
						//ajax请求 根据ammetercode查询哪个电表
						$.ajax({
					        type: "post",
					        url: "/mbAmmeter/queryAmmeterByAmmeterCode",
					        data: {ammeterCode: TSAAddress},
					        async : false,
							success: function(d) {
								if(d){
									alarmData.mbAmmeterList=d;
								}
							},
							error: function () {
									
							}
						});
							
						//ajax请求 根据address查询哪个电表
						$.ajax({
					        type: "post",
					        url: "/terminal/queryTerminalByAddress",
					        data: {address: TSAAddress},
					        async : false,
							success: function(d) {
								if(d){
									alarmData.mbTerminalList=d;
								}
							},
							error: function () {
									
							}
						});
					}
					if(type=="array" || type=="octet_string"){ //解析开始时间和结束时间
						var timeStatus = 1;
						var valueArr = event.resultRecords[i].recordRows[k].columnDatas[j].value;
						for(var n = 0; n < valueArr.length; n++){
							if(valueArr[n].type == "date_time_s"){//事件发生时间
								if(timeStatus == 1){ //事件发生时间
									timeStatus=2;
									timeStr=valueArr[n].value;
									yearStr=timeStr.slice(0,4);
									year=parseInt(yearStr,16);
									monthStr=timeStr.slice(4,6);
									month=parseInt(monthStr,16);
									dayStr=timeStr.slice(6,8);
									day=parseInt(dayStr,16);
									hourStr=timeStr.slice(8,10);
									hour=parseInt(hourStr,16);
									minStr=timeStr.slice(10,12);
									min=parseInt(minStr,16);
									secStr=timeStr.slice(12,14);
									sec=parseInt(secStr,16);
									alarmData.occurTime=year+"-"+padLeft(month,2)+"-"+padLeft(day,2)+" "+padLeft(hour,2)+":"+padLeft(min,2)+":"+padLeft(sec,2);
								}else if(timeStatus==2){ //事件结束时间
									timeStr=valueArr[n].value;
									if(timeStr == "" || timeStr == "00000000000000"){
										alarmData.endTime="";
									}
									else{
										yearStr=timeStr.slice(0,4);
										year=parseInt(yearStr,16);
										monthStr=timeStr.slice(4,6);
										month=parseInt(monthStr,16);
										dayStr=timeStr.slice(6,8);
										day=parseInt(dayStr,16);
										hourStr=timeStr.slice(8,10);
										hour=parseInt(hourStr,16);
										minStr=timeStr.slice(10,12);
										min=parseInt(minStr,16);
										secStr=timeStr.slice(12,14);
										sec=parseInt(secStr,16);
										alarmData.endTime=year+"-"+padLeft(month,2)+"-"+padLeft(day,2)+" "+padLeft(hour,2)+":"+padLeft(min,2)+":"+padLeft(sec,2);
									}
								}
							}		
						}
					}
					var oad = event.resultRecords[i].listCSD[j].csd.oad; //获取各个事件的OAD
					if(oad && oad.length == 8){//有可能oad长度不为八
						var oadOI = oad.slice(0,4);
						alarmData.oadOI = oadOI;
						//入口参数检查
						if(oadOI=='3000'){//电能表失压事件
						//模拟从表里查询的告警数据
					        alarmData.alarmMessage="电能表失压";
						    parseAlarm(alarmData);
						}
					    else if(oadOI=='3001'){//电能表欠压事件
							alarmData.alarmMessage="电能表欠压";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3002'){//电能表过压事件
							alarmData.alarmMessage="电能表过压";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3003'){//电能表断相事件
							alarmData.alarmMessage="电能表断相";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3004'){//电能表失流事件
							alarmData.alarmMessage="电能表失流";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3005'){//电能表过流事件
							alarmData.alarmMessage="电能表过流";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3006'){//电能表断流事件
							alarmData.alarmMessage="电能表断流";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3007'){//电能表功率反向事件
							alarmData.alarmMessage="电能表功率反向事件";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3008'){//电能表过载事件
							alarmData.alarmMessage="电能表过载";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3009'){//电能表正向有功需量超限事件
							alarmData.alarmMessage="电能表正向有功需量超限";
							parseAlarm(alarmData);
						}
						else if(oadOI=='300A'){//电能表反向有功需量超限事件
							alarmData.alarmMessage="电能表反向有功需量超限";
							parseAlarm(alarmData);
						}
						else if(oadOI=='300B'){//电能表无功需量超限事件
							alarmData.alarmMessage="电能表无功需量超限";
							parseAlarm(alarmData);
						}
						else if(oadOI=='300C'){//电能表功率因数超下限事件
							alarmData.alarmMessage="电能表功率因数超下限";
							parseAlarm(alarmData);
						}
						else if(oadOI=='300D'){//电能表全失压事件
							alarmData.alarmMessage="电能表全失压";
							parseAlarm(alarmData);
						}
						else if(oadOI=='300E'){//电能表辅助电源掉电事件
							alarmData.alarmMessage="电能表辅助电源掉电";
							parseAlarm(alarmData);
						}
						else if(oadOI=='300F'){//电能表电压逆相序事件
							alarmData.alarmMessage="电能表电压逆相序";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3010'){//电能表电流逆相序事件
							alarmData.alarmMessage="电能表电流逆相序";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3011'){//电能表掉电事件
							alarmData.alarmMessage="电能表掉电";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3012'){//电能表编程事件
							alarmData.alarmMessage="电能表编程";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3013'){//电能表清零事件
							alarmData.alarmMessage="电能表清零";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3014'){//电能表需量清零事件
							alarmData.alarmMessage="电能表需量清零";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3015'){//电能表事件清零事件
							alarmData.alarmMessage="电能表事件清零";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3016'){//电能表校时事件
							alarmData.alarmMessage="电能表校时事件";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3017'){//电能表时段表编程事件
							alarmData.alarmMessage="电能表时段表编程";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3018'){//电能表时区表编程事件
							alarmData.alarmMessage="电能表时区表编程";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3019'){//电能表周休日编程事件
							alarmData.alarmMessage="电能表周休日编程";
							parseAlarm(alarmData);
						}
						else if(oadOI=='301A'){//电能表结算日编程事件
							alarmData.alarmMessage="电能表结算日编程";
							parseAlarm(alarmData);
						}
						else if(oadOI=='301B'){//电能表开盖事件
							alarmData.alarmMessage="电能表开盖";
							parseAlarm(alarmData);
						}
						else if(oadOI=='301C'){//电能表开端钮盒事件 
							alarmData.alarmMessage="电能表开端钮盒";
							parseAlarm(alarmData);
						}
						else if(oadOI=='301D'){//电能表电压不平衡事件 
							alarmData.alarmMessage="电能表电压不平衡";
							parseAlarm(alarmData);
						}
						else if(oadOI=='301E'){//电能表电流不平衡事件 
							alarmData.alarmMessage="电能表电流不平衡";
							parseAlarm(alarmData);
						}
						else if(oadOI=='301F'){//电能表跳闸事件 
							alarmData.alarmMessage="电能表跳闸";
							//三维联动
							if ($('iframe').attr('name') == "monitor" && monitor.window.isVirtualInfoVisible()){
								if(alarmData.mbAmmeterList){
									monitor.window.changeMeterBreaker(alarmData.mbAmmeterList.ammeterCode,"off");
								}
							} 
							else if ($('iframe').attr('name') == "virtual"){
								if(alarmData.mbAmmeterList){
									virtual.window.changeMeterBreaker(alarmData.mbAmmeterList.ammeterCode,"off");
								}
							}
							parseAlarm(alarmData);
							//播放告警语音
							//openAlarmAudio(document.getElementById("happenAlarm"),5);
							
							//更改数据库蓝牙断路器开关状态
							if (alarmData.mbAmmeterList){
								$.ajax({
						            type: "post",
						            url: '${pageContext.request.contextPath}/changeMeterBreakerOpenStatus?Math.random()',
						            data: {openStatus: 0, ammeterId: alarmData.mbAmmeterList.id},
						            async: false,
						            success: function (d) {
						                
						            }
						        });
							}
						}
						else if(oadOI=='3020'){//电能表合闸事件 
							alarmData.alarmMessage="电能表合闸";
							//三维联动
							if ($('iframe').attr('name') == "monitor" && monitor.window.isVirtualInfoVisible()){
								if(alarmData.mbAmmeterList){
									monitor.window.changeMeterBreaker(alarmData.mbAmmeterList.ammeterCode,"on");
								}
							} 
							else if ($('iframe').attr('name') == "virtual"){
								if(alarmData.mbAmmeterList){
									virtual.window.changeMeterBreaker(alarmData.mbAmmeterList.ammeterCode,"on");
								}
							}
							parseAlarm(alarmData);
							
							//更改数据库蓝牙断路器开关状态
							if (alarmData.mbAmmeterList){
								$.ajax({
						            type: "post",
						            url: '${pageContext.request.contextPath}/changeMeterBreakerOpenStatus?Math.random()',
						            data: {openStatus: 1, ammeterId: alarmData.mbAmmeterList.id},
						            async: false,
						            success: function (d) {
						                
						            }
						        });
							}
						}
						else if(oadOI=='3021'){//电能表节假日编程事件 
							alarmData.alarmMessage="电能表节假日编程";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3022'){//电能表有功组合方式编程事件 
							alarmData.alarmMessage="电能表有功组合方式编程";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3023'){//电能表无功组合方式编程事件 
							alarmData.alarmMessage="电能表无功组合方式编程";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3024'){//电能表费率参数表编程事件 
							alarmData.alarmMessage="电能表费率参数表编程";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3025'){//电能表阶梯表编程事件 
							alarmData.alarmMessage="电能表阶梯表编程";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3026'){//电能表密钥更新事件 
							alarmData.alarmMessage="电能表密钥更新";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3027'){//电能表异常插卡事件 
							alarmData.alarmMessage="电能表异常插卡";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3028'){//电能表购电记录 
							alarmData.alarmMessage="电能表购电记录";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3029'){//电能表退费记录 
							alarmData.alarmMessage="电能表退费记录";
							parseAlarm(alarmData);
						}
						else if(oadOI=='302A'){//电能表恒定磁场干扰事件 
							alarmData.alarmMessage="电能表恒定磁场干扰";
							parseAlarm(alarmData);
						}
						else if(oadOI=='302B'){//电能表负荷开关误动作事件 
							alarmData.alarmMessage="电能表负荷开关误动作";
							parseAlarm(alarmData);
						}
						else if(oadOI=='302C'){//电能表电源异常事件 
							alarmData.alarmMessage="电能表电源异常";
							parseAlarm(alarmData);
						}
						else if(oadOI=='302D'){//电能表电流严重不平衡事 件 
							alarmData.alarmMessage="电能表电流严重不平衡";
							parseAlarm(alarmData);
						}
						else if(oadOI=='302E'){//电能表时钟故障事件 
							alarmData.alarmMessage="电能表时钟故障";
							parseAlarm(alarmData);
						}
						else if(oadOI=='302F'){//电能表计量芯片故障事件 
							alarmData.alarmMessage="电能表计量芯片故障";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3030'){//通信模块变更事件 
							alarmData.alarmMessage="通信模块变更";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3031'){//管理芯插拔事件记录 
							alarmData.alarmMessage="管理芯插拔事件记录";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3100'){//终端初始化事件 
							alarmData.alarmMessage="终端初始化";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3101'){//终端版本变更事件 
							alarmData.alarmMessage="终端版本变更";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3104'){//终端状态量变位事件 
							alarmData.alarmMessage="终端状态量变位";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3105'){//电能表时钟超差事件 
							alarmData.alarmMessage="电能表时钟超差";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3106'){//终端停/上电事件 
							alarmData.alarmMessage="终端停/上电";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3107'){//终端直流模拟量越上限事件 
							alarmData.alarmMessage="终端直流模拟量越上限";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3108'){//终端直流模拟量越下限事件 
							alarmData.alarmMessage="终端直流模拟量越下限";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3109'){//终端消息认证错误事件 
							alarmData.alarmMessage="终端消息认证错误";
							parseAlarm(alarmData);
						}
						else if(oadOI=='310A'){//设备故障记录 
							alarmData.alarmMessage="设备故障记录";
							parseAlarm(alarmData);
						}
						else if(oadOI=='310B'){//电能表示度下降事件 
							alarmData.alarmMessage="电能表示度下降";
							parseAlarm(alarmData);
						}
						else if(oadOI=='310C'){//电能量超差事件 
							alarmData.alarmMessage="电能量超差";
							parseAlarm(alarmData);
						}
						else if(oadOI=='310D'){//电能表飞走事件 
							alarmData.alarmMessage="电能表飞走";
							parseAlarm(alarmData);
						}
						else if(oadOI=='310E'){//电能表停走事件 
							alarmData.alarmMessage="电能表停走";
							parseAlarm(alarmData);
						}
						else if(oadOI=='310F'){//终端抄表失败事件 
							alarmData.alarmMessage="终端抄表失败";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3110'){//月通信流量超限事件 
							alarmData.alarmMessage="月通信流量超限";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3111'){//发现未知电能表事件 
							alarmData.alarmMessage="发现未知电能表";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3112'){//跨台区电能表事件 
							alarmData.alarmMessage="跨台区电能表";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3114'){//终端对时事件 
							alarmData.alarmMessage="终端对时事件";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3037'){//停电上报事件
							alarmData.alarmMessage="停电上报事件";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3038'){//上电上报事件
							alarmData.alarmMessage="上电上报事件";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3039'){//电压谐波总畸变率超限事件
							alarmData.alarmMessage="电压谐波总畸变率超限事件";
							parseAlarm(alarmData);
						}
						else if(oadOI=='303A'){//电流谐波总畸变率超限事件
							alarmData.alarmMessage="电流谐波总畸变率超限事件";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3032'){//端子座过热报警事件
							alarmData.alarmMessage="端子座过热报警事件";
						    //解析温度值
							var temp = parseTemperature(columnDatas);
						    //告警框中显示数据
							alarmData.valueText = "温度：" + temp.data + "℃";
							alarmData.lineIndex = temp.index;
							if (!alarmData.endTime){ //开始
								//三维联动
								if ($('iframe').attr('name') == "monitor" && monitor.window.isVirtualInfoVisible()){
									if(alarmData.mbAmmeterList){
										monitor.window.setMeterLineAlarm(alarmData.mbAmmeterList.ammeterCode, temp.index, alarmData.valueText, true);
									}else if(alarmData.mbTerminalList){
										monitor.window.setTerminalLineAlarm(alarmData.mbTerminalList.address, temp.index, alarmData.valueText, true);
									}
								} 
								else if ($('iframe').attr('name') == "virtual"){
									if(alarmData.mbAmmeterList){
										virtual.window.setMeterLineAlarm(alarmData.mbAmmeterList.ammeterCode, temp.index, alarmData.valueText, true);
									}else if(alarmData.mbTerminalList){
										virtual.window.setTerminalLineAlarm(alarmData.mbTerminalList.address, temp.index, alarmData.valueText, true);
									}
								}
								//播放告警语音
								//openAlarmAudio(document.getElementById("happenAlarm"),5);
							}
							else{
								//三维联动
								if ($('iframe').attr('name') == "monitor" && monitor.window.isVirtualInfoVisible()){
									if(alarmData.mbAmmeterList){
										monitor.window.setMeterLineAlarm(alarmData.mbAmmeterList.ammeterCode, temp.index, alarmData.valueText, false);
									}else if(alarmData.mbTerminalList){
										monitor.window.setTerminalLineAlarm(alarmData.mbTerminalList.address, temp.index, alarmData.valueText, false);
									}
								} 
								else if ($('iframe').attr('name') == "virtual"){
									if(alarmData.mbAmmeterList){
										virtual.window.setMeterLineAlarm(alarmData.mbAmmeterList.ammeterCode, temp.index, alarmData.valueText, false);
									}else if(alarmData.mbTerminalList){
										virtual.window.setTerminalLineAlarm(alarmData.mbTerminalList.address, temp.index, alarmData.valueText, false);
									}
								}
							}
							parseAlarm(alarmData);
						}else if(oadOI=='3033'){//端子座温度剧变事件
							alarmData.alarmMessage="端子座温度剧变事件";
							parseAlarm(alarmData);
						}
						else if(oadOI=='FF27'){//烟雾
							alarmData.alarmMessage="烟雾事件";
							if (!alarmData.endTime){ //开始
								//三维联动
								if ($('iframe').attr('name') == "monitor" && monitor.window.isVirtualInfoVisible()){
									if(alarmData.mbAmmeterList){
										monitor.window.addFire([0,0,5]);
									}else if(alarmData.mbTerminalList){
										monitor.window.addFire([0,0,5]);
									}
								} 
								else if ($('iframe').attr('name') == "virtual"){
									if(alarmData.mbAmmeterList){
										virtual.windowaddFire([0,0,5]);
									}else if(alarmData.mbTerminalList){
										virtual.windowaddFire([0,0,5]);
									}
								}
								//播放告警语音
								//openAlarmAudio(document.getElementById("happenAlarm"),5);
							}
							else{
								//三维联动
								if ($('iframe').attr('name') == "monitor" && monitor.window.isVirtualInfoVisible()){
									if(alarmData.mbAmmeterList){
										monitor.window.removeAllFire();
									}else if(alarmData.mbTerminalList){
										monitor.window.removeAllFire();
									}
								} 
								else if ($('iframe').attr('name') == "virtual"){
									if(alarmData.mbAmmeterList){
										virtual.windowremoveAllFire();
									}else if(alarmData.mbTerminalList){
										virtual.windowremoveAllFire();
									}
								}
							}
							parseAlarm(alarmData);
						}
						else if(oadOI=='3034'){//端子座温度不平衡事件
							alarmData.alarmMessage="端子座温度不平衡事件";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3035'){//误差自检测事件
							alarmData.alarmMessage="误差自检测事件";
							//解析误差值
							var meterError = parseMeterError(columnDatas);
						    //告警框中显示数据
							alarmData.valueText = "误差值：" + meterError;
							if (!alarmData.endTime){ //开始
								//三维联动
								if ($('iframe').attr('name') == "monitor" && monitor.window.isVirtualInfoVisible()){
									monitor.window.setMeterErrorAlarm(alarmData.mbAmmeterList.ammeterCode, "误差值：" + meterError, true);
								} 
								else if ($('iframe').attr('name') == "virtual"){
									virtual.window.setMeterErrorAlarm(alarmData.mbAmmeterList.ammeterCode, "误差值：" + meterError, true);
								}
								//播放告警语音
								//openAlarmAudio(document.getElementById("happenAlarm"),5);
							}
							else{ //结束
								//三维联动
								if ($('iframe').attr('name') == "monitor" && monitor.window.isVirtualInfoVisible()){
									monitor.window.setMeterErrorAlarm(alarmData.mbAmmeterList.ammeterCode, "误差值：" + meterError, false);
								} 
								else if ($('iframe').attr('name') == "virtual"){
									virtual.window.setMeterErrorAlarm(alarmData.mbAmmeterList.ammeterCode, "误差值：" + meterError, false);
								}
							}
							parseAlarm(alarmData);
						}else if(oadOI=='3036'){//升级事件
							alarmData.alarmMessage="升级事件";
							parseAlarm(alarmData);
						}else if(oadOI=='FF28'){//剩余电流超限
							alarmData.alarmMessage="剩余电流超限";
						    if (!alarmData.endTime){ //开始
						    	//三维联动
								if ($('iframe').attr('name') == "monitor" && monitor.window.isVirtualInfoVisible()){
									monitor.window.setTransformerAlarm(true);
								} 
								else if ($('iframe').attr('name') == "virtual"){
									virtual.window.setTransformerAlarm(true);
								}
								//播放告警语音
								//openAlarmAudio(document.getElementById("happenAlarm"),5);
						    }
						    else{ //结束
						    	//三维联动
								if ($('iframe').attr('name') == "monitor" && monitor.window.isVirtualInfoVisible()){
									monitor.window.setTransformerAlarm(false);
								} 
								else if ($('iframe').attr('name') == "virtual"){
									virtual.window.setTransformerAlarm(false);
								}
						    }
						    parseAlarm(alarmData);
						}else if(oadOI=='FF29'){//表箱开门事件
						    var openStatus;
							if (!alarmData.endTime){
						    	alarmData.alarmMessage="表箱开门事件";
						    	//三维联动
								if ($('iframe').attr('name') == "monitor" && monitor.window.isVirtualInfoVisible()){
									if(alarmData.mbAmmeterList){
										monitor.window.openDoor(alarmData.mbAmmeterList.measureFile.measureNumber);
									}else if(alarmData.mbTerminalList){
										monitor.window.openDoor(alarmData.mbTerminalList.measureFile.measureNumber);
									}
								} 
								else if ($('iframe').attr('name') == "virtual"){
									if(alarmData.mbAmmeterList){
										virtual.window.openDoor(alarmData.mbAmmeterList.measureFile.measureNumber);
									}else if(alarmData.mbTerminalList){
										virtual.window.openDoor(alarmData.mbTerminalList.measureFile.measureNumber);
									}
								}
								openStatus = 1;
						    }
						    else{
						    	alarmData.alarmMessage="表箱关门事件";
						    	//三维联动
								if ($('iframe').attr('name') == "monitor" && monitor.window.isVirtualInfoVisible()){
									if(alarmData.mbAmmeterList){
										monitor.window.closeDoor(alarmData.mbAmmeterList.measureFile.measureNumber);
									}else if(alarmData.mbTerminalList){
										monitor.window.closeDoor(alarmData.mbTerminalList.measureFile.measureNumber);
									}
								} 
								else if ($('iframe').attr('name') == "virtual"){
									if(alarmData.mbAmmeterList){
										virtual.window.closeDoor(alarmData.mbAmmeterList.measureFile.measureNumber);
									}else if(alarmData.mbTerminalList){
										virtual.window.closeDoor(alarmData.mbTerminalList.measureFile.measureNumber);
									}
								}
								openStatus = 0;
						    }
						    parseAlarm(alarmData);
						    
						    //更改数据库表箱门状态
					    	var mesuredId;
							if(alarmData.mbAmmeterList){
								mesuredId = alarmData.mbAmmeterList.measureFile.measureId;
							}else if(alarmData.mbTerminalList){
								mesuredId = alarmData.mbTerminalList.measureFile.measureId;
							}
							if (mesuredId){
								$.ajax({
						            type: "post",
						            url: '${pageContext.request.contextPath}/changeBoxOpenStatus?Math.random()',
						            data: {openStatus: openStatus, measureId: mesuredId},
						            async: false,
						            success: function (d) {
						                
						            }
						        });
							}
						}
						else if(oadOI=='3115'){//遥控跳闸记录
							alarmData.alarmMessage="遥控跳闸记录";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3116'){//有功总电能量差动越限事件记录
							alarmData.alarmMessage="有功总电能量差动越限事件记录";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3117'){//输出回路接入状态变位事件记录
							alarmData.alarmMessage="输出回路接入状态变位事件记录";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3118'){//终端编程记录
							alarmData.alarmMessage="终端编程记录";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3119'){//终端电流回路异常事件
							alarmData.alarmMessage="终端电流回路异常事件";
							parseAlarm(alarmData);
						}
						else if(oadOI=='311A'){//电能表在网状态切换事件
							alarmData.alarmMessage="电能表在网状态切换事件";
							parseAlarm(alarmData);
						}
						else if(oadOI=='311B'){//终端对电表校时记录
							alarmData.alarmMessage="终端对电表校时记录";
							parseAlarm(alarmData);
						}
						else if(oadOI=='311C'){//电能表数据变更监控记录
							alarmData.alarmMessage="电能表数据变更监控记录";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3200'){//功控跳闸记录
							alarmData.alarmMessage="功控跳闸记录";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3201'){//电控跳闸记录
							alarmData.alarmMessage="电控跳闸记录";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3202'){//购电参数设置记录
							alarmData.alarmMessage="购电参数设置记录";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3203'){//电控告警事件记录
							alarmData.alarmMessage="电控告警事件记录";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3300'){//事件上报状态
							alarmData.alarmMessage="事件上报状态";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3301'){//标准事件记录单元
							alarmData.alarmMessage="标准事件记录单元";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3302'){//编程记录事件单元
							alarmData.alarmMessage="编程记录事件单元";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3303'){//发现未知电能表事件单元
							alarmData.alarmMessage="发现未知电能表事件单元";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3304'){//跨台区电能表事件单元
							alarmData.alarmMessage="跨台区电能表事件单元";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3305'){//功控跳闸记录单元
							alarmData.alarmMessage="功控跳闸记录单元";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3306'){//电控跳闸记录单元
							alarmData.alarmMessage="电控跳闸记录单元";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3307'){//电控告警事件单元
							alarmData.alarmMessage="电控告警事件单元";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3308'){//电能表需量超限事件单元
							alarmData.alarmMessage="电能表需量超限事件单元";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3309'){//停/上电事件记录单元
							alarmData.alarmMessage="停/上电事件记录单元";
							parseAlarm(alarmData);
						}
						else if(oadOI=='330A'){//遥控事件记录单元
							alarmData.alarmMessage="遥控事件记录单元";
							parseAlarm(alarmData);
						}
						else if(oadOI=='330B'){//有功总电能量差动越限事件记录单元
							alarmData.alarmMessage="有功总电能量差动越限事件记录单元";
							parseAlarm(alarmData);
						}
						else if(oadOI=='330C'){//事件清零事件记录单元
							alarmData.alarmMessage="事件清零事件记录单元";
							parseAlarm(alarmData);
						}
						else if(oadOI=='330D'){//终端对电表校时记录单元
							alarmData.alarmMessage="终端对电表校时记录单元";
							parseAlarm(alarmData);
						}
						else if(oadOI=='330E'){//电能表在网状态切换事件单元
							alarmData.alarmMessage="电能表在网状态切换事件单元";
							parseAlarm(alarmData);
						}
						else if(oadOI=='330F'){//电能表数据变更监控记录单元
							alarmData.alarmMessage="电能表数据变更监控记录单元";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3310'){//异常插卡事件记录单元
							alarmData.alarmMessage="异常插卡事件记录单元";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3311'){//退费事件记录单元
							alarmData.alarmMessage="退费事件记录单元";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3312'){//通信模块变更事件单元
							alarmData.alarmMessage="通信模块变更事件单元";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3313'){//电能表时钟超差记录单元
							alarmData.alarmMessage="电能表时钟超差记录单元";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3314'){//电能表时段表编程事件记录单元
							alarmData.alarmMessage="电能表时段表编程事件记录单元";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3315'){//电能表节假日编程事件记录单元
							alarmData.alarmMessage="电能表节假日编程事件记录单元";
							parseAlarm(alarmData);
						}
						else if(oadOI=='3320'){//新增上报事件列表
							alarmData.alarmMessage="新增上报事件列表";
							parseAlarm(alarmData);
						}
						else if(oadOI=='FF25'){//分负荷运行数据集
							alarmData.alarmMessage="分负荷运行数据集";
						    alarmData.loadData = parseLoadData(event.resultRecords[i].recordRows[k].columnDatas[j]); //解析负荷数据
						    parseMessage(alarmData);
						}
						else if(oadOI=='3060'){//表计定位信息
							var afterdata=event.resultRecords[i].recordRows[k].columnDatas[4].value[4].value;
							var octInt = parseInt(afterdata,10);
							if(octInt != alarmData.mbAmmeterList.ammeterCode){
								alarmData.alarmMessage="表计错位事件";
								//三维联动
								if ($('iframe').attr('name') == "monitor" && monitor.window.isVirtualInfoVisible()){
									monitor.window.setMeterAlarm(alarmData.mbAmmeterList.ammeterCode, true);
								} 
								else if ($('iframe').attr('name') == "virtual"){
									virtual.window.setMeterAlarm(alarmData.mbAmmeterList.ammeterCode, true);
								}
								//播放告警语音
								//openAlarmAudio(document.getElementById("happenAlarm"),5);
							}else{
								alarmData.alarmMessage="表计错位恢复";
								//三维联动
								if ($('iframe').attr('name') == "monitor" && monitor.window.isVirtualInfoVisible()){
									monitor.window.setMeterAlarm(alarmData.mbAmmeterList.ammeterCode, false);
								} 
								else if ($('iframe').attr('name') == "virtual"){
									virtual.window.setMeterAlarm(alarmData.mbAmmeterList.ammeterCode, false);
								}
							}
							parseAlarm(alarmData);
						}
						else{
							continue;
						}
					}
				}
			}
		}
	}
	
	//解析负荷分析内容
	function parseLoadData(items){
		var data = [];
		if (items && items.value){
			$.each(items.value, function(i, n){
				var devicetype;
				if(n.value[0].value == "12"){//电水壶
					devicetype = "电水壶";
				}else if(n.value[0].value == "22"){
					devicetype = "电磁炉";
				}else{
					return true;
				}
				var status;
				if (n.value[2].value == 1) status = "运行中";
				else status = "已停止";
				data.push({"devicetype": devicetype, "num": n.value[1].value, "status": status,
					"runtime": parseInt(n.value[3].value ? n.value[3].value : 0, 16) + "分钟", "powervalue": (parseInt(n.value[4].value ? n.value[4].value : 0, 16) / 100).toFixed(2) + "kWh", 
					"times": parseInt(n.value[5].value ? n.value[5].value : 0, 16), 
					"starttime": parseTime(n.value[6].value), "stoptime": parseTime(n.value[7].value)});
			});
		}
		return data;
	}
	
	function parseTime(timeStr){
		if (!timeStr) return "";
		yearStr=timeStr.slice(0,4);
		year=parseInt(yearStr,16);
		monthStr=timeStr.slice(4,6);
		month=parseInt(monthStr,16);
		dayStr=timeStr.slice(6,8);
		day=parseInt(dayStr,16);
		hourStr=timeStr.slice(8,10);
		hour=parseInt(hourStr,16);
		minStr=timeStr.slice(10,12);
		min=parseInt(minStr,16);
		secStr=timeStr.slice(12,14);
		sec=parseInt(secStr,16);
		return year+"-"+padLeft(month.toString(),2)+"-"+padLeft(day.toString(),2)+" "+padLeft(hour.toString(),2)+":"+padLeft(min.toString(),2)+":"+padLeft(sec.toString(),2);
	}
	
	//解析误差值
	function parseMeterError(columnDatas){
		var data = '';
		if (columnDatas && columnDatas.length >= 5 && columnDatas[4].value 
				&& columnDatas[4].value.length >= 9 && columnDatas[4].value[9].value){
			data = parseInt(columnDatas[4].value[9].value, 16);
			var bin = data.toString(2); //转成二进制
			if (bin.length < 16){
				bin = padLeft(bin, 16);
			}
			var first = bin[0];
			if (first == 1){ //最高位为1，则减掉两个32768
				data = data - 32768 * 2;
			}
			data = (data / 100).toFixed(2);
		}
		return data + "%";
	}
	
	//解析端子温度值
	function parseTemperature(columnDatas){
		var index = 1;
		var data = '';
		if (columnDatas && columnDatas.length >= 5 && columnDatas[4].value 
				&& columnDatas[4].value.length >= 5 && columnDatas[4].value[5].value){
			$.each(columnDatas[4].value[5].value, function(i, n){
				var temp = parseInt(n.value, 16) / 10;
				temp = temp.toFixed(1);
				if (data < temp){
					data = temp;
					index = i + 1;
				}
			})
		}
		return {index: index, data: data};
	}
	
	//获取表箱当前所有告警信息，初次打开三维时调用，并生成相应的动画效果
	function getBoxCurrentAlarm(boxId){
		var divArr = [];
		var items = $(".alarmContent").find("input[name='boxId'][value='"+boxId+"']");
		if (items.length > 0){
			$.each(items, function(i, n){
				divArr.push($(n).parent());
			})
		}
		return divArr;
	}

	//打开二维码页面
	function getQRCode() {
		$('#QRCodedlg').dialog({    
		    title: "二维码",   
		    width: 280,    
		    height: 330,    
		    closed: true,
		    content: "<img src='${pageContext.request.contextPath}/images/Front/QRCode.png' height='280' width='280' alt=''>"
		}).dialog('open');    
	}
	
	//弹出框：个人信息、关于、帮助、联系我们等 
	function setDlg(title,src,icon) {
		$('#setdlg').dialog({    
			title: title,   
		    width: 700,    
		    height: 300, 
		    iconCls:icon,
		    closed: true,    
		    cache: false,    
		    href: src,    
		    modal: true   
		}).dialog('open');   
	}
	
	//弹出框：帮助文档
	function downloadFile(title,icon) {
		$('#helpDocument').dialog({title:title}).dialog('open'); 
		var url = '${pageContext.request.contextPath}/document/getFileList?Math.random()';
		$('#fileList').datagrid({
		    url:url,
			fit: true,   //自适应大小
			singleSelect: false,
			//iconCls : 'icon-save',
			border:false,
			nowrap: true,//数据长度超出列宽时将会自动截取。
			rownumbers:true,//行号
			fitColumns:true,//自动使列适应表格宽度以防止出现水平滚动。
		    columns:[[
		    	{field: 'ck', checkbox:true },
		        {title:'文件名称',field:'name',width:200},
		        {title:'大小',field:'size',width:100},
		        {title:'修改日期',field:'date',width:150},
		        {title:'操作',field:'id',width:100,
		        	formatter : function(value, rowData, rowIndex) {
	            		return "<a href=\"#\" style=\"color:#fff;\" class=\"easyui-linkbutton\" onclick=\"downloadfile('"+rowData.name+"')\" >下 载</a>";
					}
		        }
		    ]]
		});
	}

	function downloadfile(name) {
		var options = {
	            url : '${pageContext.request.contextPath}/document/download?Math.random()', 
	            data :{
	            	"name" : name
				},
	            method : 'post'
	        };
		var config = $.extend(true, {
            method : 'post'
        }, options);
        var $iframe = $('<iframe id="down-file-iframe" />');
        var $form = $('<form target="down-file-iframe" method="' + config.method + '" />');
        $form.attr('action', config.url);
        for ( var key in config.data) {
            $form
                .append('<input type="hidden" name="' + key + '" value="' + config.data[key] + '" />');
        }
        $iframe.append($form);
        $(document.body).append($iframe);
        $form[0].submit();
        $iframe.remove();
	}	
	
	//左侧补零
	function padLeft(str, len){
		while(str.length<len){
	        str = '0'+  str ;
		}
		return str;
	}
	
	//加载某个模块
	function openPage(src, title, iconCls,menuenname){
        $('#top_menu li').removeClass('front_head_select');
        $('#top_menu li').addClass('front_head');
        $('#top_menu li[title='+title+']').addClass('front_head_select');
		var iframe = '<iframe id="'+title+'" allowFullScreen="true" src="' + src + '" name="'+ menuenname+'" scrolling="auto" frameborder="0" style="width:100%;height:100%;"></iframe>';
        
		$("#index_center").html(iframe);
	}
	
	//打开告警声音
	function openAlarmAudio(element,times){
        var start=0;
        element.addEventListener("ended",function(){
        	start++;
            if (start>=times){
            	try{
            		element.pause();
            	}catch(e){}
            }
            else{
            	try{
                    element.play();
                }catch(e){}
            }
        }); 
       try{
            element.play();
       }catch(e){
       }
   }	

</script>
<div id="index_layout" class="easyui-layout" data-options="fit:true">
    <div id="index_north" class="banner" data-options="region:'north',border:false,split:false"
         style="height: 70px; padding:0;margin:0; overflow: hidden;">
        <table style="float: left; border-spacing: 0px; height: 100%;">
            <tr>
                <td class="hide_img" style="cursor: pointer;height:50px;">
                	<img src="${pageContext.request.contextPath}/images/Login/Login-logo.png" height="45" alt="智慧表箱" style="padding-left: 20px;">
                </td>
                <td class="hide_title">
                	<span class="head-title"><spring:message code="Wisdom_fire_safety_system"/></span>
                </td>
                <td class="hide_img">
                	<img src="${pageContext.request.contextPath}/images/Front/wellsun_logo.png" height="45" alt="浙江万胜" style="padding-left: 5px;"> 
                </td>
                <td>
                	<ul id="top_menu"></ul>
                </td>
            </tr>
        </table>
        
		<div class="top_right f_r">
            <!-- menu -->
            <div class="nav_bar">
                <ul class="nav clearfix" id="ulMenu">

                    <li class="m">
                        <h3>
                            <a title="下载手机APP" id="QRCode" class="l-btn-text bannerbtn"
                               href="javascript:void(0)" onclick="getQRCode()"><i class="fa fa-qrcode"></i></a>
                        </h3>
                    </li>
                    <li class="s">|</li>
                    
                    <li class="m">
                        <h3>
                            <a id="showUserInfo" style="display:inline-block;" class="fa bannerbtn"
                               href="javascript:void(0)">
                                <img src="${pageContext.request.contextPath}/images/Avatar.png" class="user-image">
                                <span class="user-name" id="username">${requestScope.username}</span>
                            </a>
                        </h3>
                        <ul class="sub">
                            <li><a class="frontA" id="modifyPwd" href="javascript:modifyPwd()"><i class="fa fa-key"></i>&nbsp;<label for="modifyPwd"><spring:message code="ChangePassword"/></label></a></li>
                            <li><a class="frontA" id="about" href="javascript:setDlg('<spring:message code='AboutSystem'/>','${pageContext.request.contextPath}/about','fa fa-info-circle')" target=""><i class="fa fa-info-circle"></i>&nbsp;<label for="about"><spring:message code="AboutSystem"/></label></a></li>
                            <li><a class="frontA" id="about" href="javascript:downloadFile('帮助文档','fa fa-file-word-o')" target=""><i class="fa fa-info-circle"></i>&nbsp;<label for="helpdocument">帮助文档</a></li>
                            <li><a class="frontA" id="logout" href="javascript:logout()"> <i class="fa fa-power-off"></i>&nbsp;<label for="logout"><spring:message code="ExitSystem"/></label></a></li>
                        </ul>
                    </li>
                    <li class="block"></li><!-- 滑动块 -->

                </ul>
            </div>
            <!-- menu | end -->
        </div>
    </div>
    
    <div id="index_center" data-options="region:'center',border:false" style="overflow:hidden;">
    	<iframe id="实时监控" name="monitor" src="" scrolling="auto" frameborder="0" style="width:100%;height:100%;"></iframe>
    </div>
</div>
</body>
</html>