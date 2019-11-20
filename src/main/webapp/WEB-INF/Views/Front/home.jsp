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
<title>实时监控</title>
<jsp:include page="../FrontHeader.jsp"/>
<link href="${pageContext.request.contextPath}/css/gis/threeCommon.css" rel="stylesheet" />
<link href="${pageContext.request.contextPath}/css/gis/amap.css" rel="stylesheet" />
<link href="${pageContext.request.contextPath}/css/gis/iconfont/iconfont.css" rel="stylesheet" />
<link type="text/css" href="${pageContext.request.contextPath}/css/Front/monitor.css" rel="stylesheet">

<script type="text/javascript" src="https://webapi.amap.com/maps?v=1.4.10&key=b2d0df047c4228dc9243e6fda961aeb0&plugin=AMap.Autocomplete,AMap.PlaceSearch"></script><!-- 二维地图 -->
<script src="${pageContext.request.contextPath}/js/gis/marker.js"></script>	<!-- 二维地图告警图标封装的方法 -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/gis/threeJs/three.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/gis/threeJs/libs/inflate.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/gis/threeJs/loaders/FBXLoader.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/gis/threeJs/extras/Earcut.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/gis/threeJs/controls/OrbitControls.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/gis/threeJs/ThreeBSP.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/gis/threeJs/extras/tween.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/gis/box.js"></script>
				
<!-- 内部js -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/monitor.js"></script>

<script type="text/javascript">
var basePath = '${pageContext.request.contextPath}';
var box; //表箱三位模型
var meterGroup = []; //表对象，用于更新表屏幕显示数据
var terminalGroup = []; //监测终端对象，用于更新监测终端屏幕显示数据

var alarmAnimateMarker;	//告警表箱动画对象
var alarmBoxObj = {}; //告警表箱ID集合
var troubleAnimateMarker;	//故障表箱动画对象
var troubleBoxObj = {}; //故障表箱ID集合
var offlineAnimateMarker;	//集中器离线表箱动画对象
var offlineBoxObj = {}; //集中器离线表箱ID集合

//二维地图相关参数
var map,tipOverlay,layers=[];
//默认的中间点
var initCenter = [116.3900580000,39.9999770000];

//浏览器大小改变时重置大小
window.onresize = function () {
	$("#wsContainer").css('height', $("#wsContainer").parent().height() - 40);
	resizeThreeWindow($("#wsContainer").parent().width(), $("#wsContainer").parent().height() - 40);
	$(".ListTbl_width").css('height', $("#wsContainer").parent().height() - 40);
};

//三维页面窗口改变处理
function resizeThreeWindow(width,height) {
	camera.aspect = width / height;
	camera.updateProjectionMatrix();
	renderer.setSize( width, height );
}

//回车检索用户（左侧区域用户树）
/*document.onkeydown = function(e){
	var ev = document.all ? window.event : e;
	if($("#searchType").combobox('getValue')=='name' && ev.keyCode==13) {
    	doSearch($("#nameKey").textbox('getValue'),'name');
	}
}*/

//页面加载完成后调用
$(function () {
	$("#wsContainer").css('height', $("#wsContainer").parent().height() - 40);
	$(".ListTbl_width").css('height', $("#wsContainer").parent().height() - 40);
	
	initMap(); //初始化二维地图
	$("#treeCloseBtn").click(function(){
		//$(".organizationBox").css('left','0px');
		$(".layout-panel-west").hide();
		$("#map").css("left","0px");
		$("#treeOpenBtn").show();
		
	});
	$("#treeOpenBtn").click(function(){
		//$(".organizationBox").css('left','0px');
		$(".layout-panel-west").show();
		$("#map").css("left","280px");
		$("#treeCloseBtn").show();
		$("#treeOpenBtn").hide();
	});
	
	$("#treeCloseBtn").mouseover(function(){
		//$(".organizationBox").css('left','-310px');
		$(".organizationBox").fadeOut(500);
	});
	
	$('#concentratorTbl').datagrid({
		cls:"theme-datagrid", 
	       singleSelect:true,
	       remoteSort:false,
	       nowrap: true,//数据长度超出列宽时将会自动截取。
	       fit: true,   //自适应大小
	       columns: [[  
	        {title: 'id', field: 'concentratorId', width: '0',hidden:true
//	            formatter: function(value,row,index){
//	          return "<a href='javascript:void(0)' onclick='showDeviceListByStatus(" + row.concentratorType + ",\"3\")'><span style='color:#FFFF00;font-weight:bolder'>" + value + "</span></a>";
//	         } 
	        },
	        {title: '集中器名称', field: 'concentratorName', width:'100'},
	        {title: '集中器型号', field: 'concentratorType', width: '100'},
	        {title: '集中器地址', field: 'address', width: '100'},
	        {title: 'sim卡号', field: 'simCard', width: '100'}
	       ]]
	});
	
	//初始化三位表箱容器及对象
	init();
	box = new loadBox();
	setInterval(function(){
	    updateMeterAlarm();
	    updateTransformerAlarm();
	    updateMeterError();
	    updateTerminalLineAlarm();
        updateMeterLineAlarm();
	},500);
	    
	//每过1分钟获取表数据
	setInterval(function(){
	    getMeterData();
	    getTerminalData();
	},60000);
	
	resizeDiv();
	$("#west").panel({
        onResize: function (w, h) {
        	resizeDiv();
        }
    });
	
	$(window).resize(function(){ //浏览器窗口变化 
		resizeDiv();
	});
	$("#treeCloseBtn").click();
});

//公用树点击事件
var node;
function treeClick(n){
	if(typeof n!='undefined' ){
		node = n;
		findBox(n);
	}
}
var resizeDiv = function () {
	width=$('#west').width();
	height=$('#west').height();
	if(window.innerHeight<height)
		height=window.innerHeight-36;//当有title时，window.innerHeight-38；反之，则window.innerHeight
	$('#left-table').width(width);
	$('#left-table').height(height);
	$('#left-tree').width(width);
	$('#left-tree').height(height-33);
};

function isVirtualInfoVisible(){
	return $(".virtualInfo").css("display") == "none" ? false : true;
}
</script>
</head>
<body>
	<div class="easyui-layout" fit="true">
  	<div id="west" region="west" iconCls="icon-organization" split="false"
			title="表箱" style="width: 280px;"
			collapsible="false">
				<a id="treeCloseBtn" style="position: relative; top: 330px; left: 223px; "> <!-- href="javascript:openTree()" -->
				<div class="organizationBar">
					<i class="fa fa-angle-double-left" style="font-size: 21px; color: #fff; position: absolute; top: 9px; left: 15px;"></i>
				</div>
	       </a>
			<%@include file="../CommonTree/f_monitorTree.jsp" %>
	</div>
	<div id="map" style="height: 100%;width:100%;position: relative;left:280px">
	<a id="treeOpenBtn" style="position: relative; top: 330px; left: 0px;"> <!-- href="javascript:openTree()" -->
				<div class="organizationBar">
					<i class="fa fa-angle-double-right" style="font-size: 21px; color: #fff; position: absolute; top: 9px; left: 15px;"></i>
				</div>
	       </a>
	   <label style="position: relative;z-index: 9999;float:right;width: 60px;height: 20px"><input id="heatMapId" type="checkbox" >热力图</label>	
	</div> 
    </div>	
	<!-- 表箱信息弹出框 -->
	<div class="userBox" style="display: none;"><!-- left:5%; -->
		<div class="userBoxTitle">
			<p style="position: absolute; left: 32px;">表箱信息</p>
			<button type="button" class="close pull-right" id="" onclick="closeBoxInfo()"
			style="color:#fff;opacity:1;line-height:40px;position:absolute;top:0px;left:103px;">×</button>
		</div>
	    <div class="userBoxContent" ><!-- style="left: 0px;" -->
	    	<!-- <div style="margin:0 auto;padding:10px;float:left;"> -->
	            <input type="hidden" id="boxid" />
	            <table cellpadding="8" cellspacing="8" align="center">	
	                <tr>  
	                    <td style="width:80px;">表箱名称：</td>           
		                <td><span id="boxname"></span></td>
	                </tr>
	                <tr> 
	                    <td style="width:80px;">表箱编号：</td>  
	                	<td><span id="measureNumber"></span></td>   
	                </tr> 
	                <tr>    
	                	<td style="width:80px;">表箱地址：</td>  
	                	<td><span id="address"></span></td>                  
	                </tr>
	                <tr>  
	                 	<td style="width:80px;">创建人：</td> 
	                 	<td><span id="legalrepresentative"></span></td>                     
	                </tr>
		            <tr>
		            	<td colspan="2">
		            	<button type="button" class="btn btn-primary" id="floorBtn" onclick="showVirtualInfo()" style="margin-right:5px;">三维图</button>
		            		<button type="button" class="btn btn-primary" onclick="showConcentratorInfo()" style="margin-right:5px;">集中器</button>
		            		<button type="button" class="btn btn-primary" onclick="showElockList()" style="margin-right:5px;">智能e锁</button>
		            	</td>
		            </tr>
		            <tr>
		            	<td colspan="2">
		            		<button type="button" class="btn btn-primary" onclick="showAmmeterList()" style="margin-right:5px;">电表</button>
		            		<button type="button" class="btn btn-primary" id="videoBtn" onclick="showTerminalList()" style="margin-right:5px;">终端</button>
		            		<button type="button" class="btn btn-primary" id="vrBtn" onclick="showBreaker()" style="margin-right:5px;">蓝牙断路器</button>
		            	</td>
		            </tr>
	            </table>
		  
	    </div>
	</div>
	<!-- 集中器弹出框 -->
	<div class="concentratorInfo" style="display: none;">
	    <div id="" style="background:#171e30;color:#fff;height:40px;line-height:40px;padding:0 15px;">
		    <button type="button" class="close pull-right" id="" onclick="closeConcentratorInfo()" style="color:#fff;opacity:1;line-height:40px;width:40px;">×</button>
		    <p>集中器</p>
	    </div>
	    <div class="Tbl_width">   
		    <div class="dataTbl">   
		    	<table id="concentratorTbl" style="width:100%;height:100%;"></table>
			</div>
		</div>
	</div>				
	<!-- 智能e锁弹出框 -->
	<div class="elockList" style="display: none;">
	    <div id="" style="background:#171e30;color:#fff;height:40px;line-height:40px;padding:0 15px;">
		    <button type="button" class="close pull-right" id="" onclick="closeElockList()" style="color:#fff;opacity:1;line-height:40px;width:40px;">×</button>
		    <p>智能e锁</p>
	    </div>
	    <div class="ListTbl_width">    
			<table id="elockListTbl" style="width:100%;height:100%;"></table>
			<!-- <div id="toolbar">
				<select id="device_list"></select>
			</div> -->
		</div>
	</div>
		<div class="ammeterList" style="display: none;">
	    <div id="" style="background:#171e30;color:#fff;height:40px;line-height:40px;padding:0 15px;">
		    <button type="button" class="close pull-right" id="" onclick="closeAmmeterList()" style="color:#fff;opacity:1;line-height:40px;width:40px;">×</button>
		    <p>电表</p>
	    </div>
	    <div class="ListTbl_width">    
			<table id="ammeterListTbl" style="width:100%;height:100%;"></table>
			<!-- <div id="toolbar">
				<select id="device_list"></select>
			</div> -->
		</div>
	</div>
	<!-- 终端列表弹出框 -->
	<div class="terminalList" style="display: none;">
	    <div id="" style="background:#171e30;color:#fff;height:40px;line-height:40px;padding:0 15px;">
		    <button type="button" class="close pull-right" id="" onclick="closeTerminalList()" style="color:#fff;opacity:1;line-height:40px;width:40px;">×</button>
		    <p>终端列表</p>
	    </div>
	    <div class="ListTbl_width">    
			<table id="terminalListTbl" style="width:100%;height:100%;"></table>
		</div>
	</div>
	<div class="breakerList" style="display: none;">
	    <div id="" style="background:#171e30;color:#fff;height:40px;line-height:40px;padding:0 15px;">
		    <button type="button" class="close pull-right" id="" onclick="closeBreakerList()" style="color:#fff;opacity:1;line-height:40px;width:40px;">×</button>
		    <p>蓝牙断路器</p>
	    </div>
	    <div class="ListTbl_width">    
			<table id="breakerListTbl" style="width:100%;height:100%;"></table>
			<!-- <div id="toolbar">
				<select id="device_list"></select>
			</div> -->
		</div>
	</div>
	
	<!-- 三维表箱弹出框 -->
	<div class="virtualInfo" style="display: none;">
	    <div id="" style="background:#171e30;color:#fff;height:40px;line-height:40px;padding:0 15px;">
		    <button type="button" class="close pull-right" id="" onclick="closeVirtualInfo()" style="color:#fff;opacity:1;line-height:40px;width:40px;">×</button>
		    <p>三维表箱</p>
	    </div>
	    <div id="wsContainer">
		</div>
	</div>		
</body>
</html>