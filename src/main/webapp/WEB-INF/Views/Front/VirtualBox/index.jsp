<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>三维仿真</title>
<%@include file="../../FrontHeader.jsp"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/gis/threeJs/three.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/gis/threeJs/libs/inflate.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/gis/threeJs/loaders/FBXLoader.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/gis/threeJs/extras/Earcut.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/gis/threeJs/controls/OrbitControls.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/gis/threeJs/ThreeBSP.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/gis/threeJs/extras/tween.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/gis/box.js"></script>
<script>
	var basePath = '${pageContext.request.contextPath}';
</script>
</head>
<body>
	<div class="easyui-layout" fit="true">
		<div id="west" region="west" iconCls="icon-organization" split="true"
			title="表箱" style="width: 280px; min-width: 280px;"
			collapsible="true">
			<%@include file="../../CommonTree/f_MeterBoxTree.jsp" %>
		</div>
		<div id="mainPanel" region="center" style="overflow-y: hidden">
			<div id="wsContainer" class="fullSize" style="width:100%;height:100%;overflow-y: hidden">
			</div>
		</div>
	</div>
</body>
<script>
var box; //表箱对象
var meterGroup = []; //表对象，用于更新表屏幕显示数据
var terminalGroup = []; //监测终端对象，用于更新监测终端屏幕显示数据

//三维页面窗口改变处理
function resizeThreeWindow(width,height) {
	camera.aspect = width / height;
	camera.updateProjectionMatrix();
	renderer.setSize( width, height );
}

//公用树点击事件
var node;
function treeClick(n){
	if(typeof n!='undefined' ){
		node = n;
		var type = node.type;
		var id = node.gid;
		if(type == 3){
			box.clear();
			meterGroup = [];
			terminalGroup = [];
		    addBox(id, node.name, node.text);
		}
	}
}

/*
*	根据表箱id添加表箱模型
*	@param {String} boxId 表箱id
*/
function addBox(boxId, boxNumber, boxName){	
	box.load(boxId, boxNumber, boxName);
	//获取e锁
	$.ajax({
	 	type:'POST', 
     	url:basePath + '/virtualBox/getElockByBoxId',           
     	data:{"id":boxId},
     	//async:false,
        success:function(data){
    	    if(data && data.id){
    	    	box.addLock([0.6, 0.3, 1], [0.65, 2.2, 0.5], [Math.PI/2, 0, 0], 'elock', 'close', data);
    	    	var elock = boxGroup.getObjectByName("elock");
    	    	if(data.openStatus > 0){ //打开状态
    	    		setTimeout(function(){
    	    			openElock(data.mac);
    	    			
    	    			//获取表箱门状态
        	    		$.ajax({
        	    		 	type:'POST', 
        	    	     	url:basePath + '/virtualBox/getBoxByBoxId',           
        	    	     	data:{"id":boxId},
        	    	     	//async:false,
        	    	        success:function(d){
        	    	    	    if(d && d.measureId){
        	    	    	    	if(d.openStatus > 0){ //表箱打开状态
        	    	    	    		setTimeout(function(){
        	    	    	    			openDoor(boxNumber);
        	    	    	    		}, 2000);
        	    	    	    	}
        	    	    	    }
        	    	        },	        
        	    	        error:function(data){
        	    	        }
        	    	    });
    	    		}, 2000);
    	    	}
    	    }
        },	        
        error:function(data){
        }
    });
	//获取集中器
	$.ajax({
	 	type:'POST', 
     	url:basePath + '/virtualBox/getConcentratorByBoxId',           
     	data:{"id":boxId},
     	//async:false,
        success:function(data){
    	    if(data && data.concentratorId){
    	    	box.addConcentrator([1.6,0.8,2.2], [3.3,0,-3.2], [0,0,0], "concentrator", data);
    	    }
        },	        
        error:function(data){
        }
    });
	//获取监测终端
	$.ajax({
	 	type:'POST', 
     	url:basePath + '/virtualBox/getTerminalByBoxId',           
     	data:{"id":boxId},
     	//async:false,
        success:function(data){
    	    if(data && data.terminalId){
    	    	terminalGroup.push(data.address);
    	    	box.addTerminal([2.5,0.8,1.5], [3.2,0,-0.7], [0,0,0], "terminal", data);
    	    	//接线
    	    	box.addWire([[3.8, 0.7, 0.75], [3.8, 0.7, 0]], 0.02, 0xBCAA39, data.address + 'line1');
    	    	box.addWire([[3.77, 0.7, 0.75], [3.77, 0.7, 0]], 0.02, 0xBCAA39, data.address + 'line2');
    	    	box.addWire([[3.785, 0.7, 1], [3.785, 0.7, 0.75]], 0.04, 0x000000, data.address + 'head1');
    	    	box.addWire([[3.25, 0.7, 0.75], [3.25, 0.7, 0]], 0.02, 0x568263, data.address + 'line3');
    	    	box.addWire([[3.22, 0.7, 0.75], [3.22, 0.7, 0]], 0.02, 0x568263, data.address + 'line4');
    	    	box.addWire([[3.235, 0.7, 1], [3.235, 0.7, 0.75]], 0.04, 0x000000, data.address + 'head2');
    	    	box.addWire([[2.7, 0.7, 0.75], [2.7, 0.7, 0]], 0.02, 0x862f32, data.address + 'line5');
    	    	box.addWire([[2.67, 0.7, 0.75], [2.67, 0.7, 0]], 0.02, 0x862f32, data.address + 'line6');
    	    	box.addWire([[2.685, 0.7, 1], [2.685, 0.7, 0.75]], 0.04, 0x000000, data.address + 'head3');
    	    	getTerminalData();
    	    }
        },	        
        error:function(data){
        }
    });
	//获取电表
	$.ajax({
	 	type:'POST', 
     	url:basePath + '/virtualBox/getAmmeterByBoxId',           
     	data:{"id":boxId},
     	//async:false,
        success:function(data){
    	    if(data){
    	    	$.each(data, function(i, n){
    	    		meterGroup.push(n.ammeterCode);
    	    		switch (n.installAddress.toString()){
    	    			case '1':
    	    				box.addMeter([1.5, 0.8, 2.5], [-1.2,0,4.2], [0,0,0], "meter" + n.ammeterCode, n);
    	    				//接线
    	    				box.addWire([[-0.75, 0, 2.9], [-0.75, 0.4, 2.9], [-0.75, 0.4, 3.4]], 0.04, 0x862f32, n.ammeterCode + 'line1');
    	    				box.addWire([[-1.05, 0, 2.9], [-1.05, 0.4, 2.9], [-1.05, 0.4, 3.4]], 0.04, 0x862f32, n.ammeterCode + 'line2');
    	    				box.addWire([[-1.35, 0, 2.9], [-1.35, 0.4, 2.9], [-1.35, 0.4, 3.4]], 0.04, 0x2357A0, n.ammeterCode + 'line3');
    	    				box.addWire([[-1.65, 0, 2.9], [-1.65, 0.4, 2.9], [-1.65, 0.4, 3.4]], 0.04, 0x2357A0, n.ammeterCode + 'line4');
    	    				break;
    	    			case '2':
    	    				box.addMeter([1.5, 0.8, 2.5], [-3.3,0,4.2], [0,0,0], "meter" + n.ammeterCode, n);
    	    				//接线
    	    				box.addWire([[-2.85, 0, 2.9], [-2.85, 0.4, 2.9], [-2.85, 0.4, 3.4]], 0.04, 0x862f32, n.ammeterCode + 'line1');
    	    				box.addWire([[-3.15, 0, 2.9], [-3.15, 0.4, 2.9], [-3.15, 0.4, 3.4]], 0.04, 0x862f32, n.ammeterCode + 'line2');
    	    				box.addWire([[-3.45, 0, 2.9], [-3.45, 0.4, 2.9], [-3.45, 0.4, 3.4]], 0.04, 0x2357A0, n.ammeterCode + 'line3');
    	    				box.addWire([[-3.75, 0, 2.9], [-3.75, 0.4, 2.9], [-3.75, 0.4, 3.4]], 0.04, 0x2357A0, n.ammeterCode + 'line4');
    	    				break;
    	    			case '3':
    	    				box.addMeter([1.5, 0.8, 2.5], [-1.2,0,0.9], [0,0,0], "meter" + n.ammeterCode, n);
    	    				//接线
    	    				box.addWire([[-0.75, 0, -0.4], [-0.75, 0.4, -0.4], [-0.75, 0.4, 0.1]], 0.04, 0x568263, n.ammeterCode + 'line1');
    	    				box.addWire([[-1.05, 0, -0.4], [-1.05, 0.4, -0.4], [-1.05, 0.4, 0.1]], 0.04, 0x568263, n.ammeterCode + 'line2');
    	    				box.addWire([[-1.35, 0, -0.4], [-1.35, 0.4, -0.4], [-1.35, 0.4, 0.1]], 0.04, 0x2357A0, n.ammeterCode + 'line3');
						    box.addWire([[-1.65, 0, -0.4], [-1.65, 0.4, -0.4], [-1.65, 0.4, 0.1]], 0.04, 0x2357A0, n.ammeterCode + 'line4');
    	    				break;
    	    			case '4':
    	    				box.addMeter([1.5, 0.8, 2.5], [-3.3,0,0.9], [0,0,0], "meter" + n.ammeterCode, n);
    	    				//接线
    	    				box.addWire([[-2.85, 0, -0.4], [-2.85, 0.4, -0.4], [-2.85, 0.4, 0.1]], 0.04, 0x568263, n.ammeterCode + 'line1');
    	    				box.addWire([[-3.15, 0, -0.4], [-3.15, 0.4, -0.4], [-3.15, 0.4, 0.1]], 0.04, 0x568263, n.ammeterCode + 'line2');
    	    				box.addWire([[-3.45, 0, -0.4], [-3.45, 0.4, -0.4], [-3.45, 0.4, 0.1]], 0.04, 0x2357A0, n.ammeterCode + 'line3');
    	    				box.addWire([[-3.75, 0, -0.4], [-3.75, 0.4, -0.4], [-3.75, 0.4, 0.1]], 0.04, 0x2357A0, n.ammeterCode + 'line4');
    	    				break;
    	    			case '5':
    	    				box.addMeter([1.5, 0.8, 2.5], [-1.2,0,-2.4], [0,0,0], "meter" + n.ammeterCode, n);
    	    				//接线
    	    				box.addWire([[-0.75, 0, -3.7], [-0.75, 0.4, -3.7], [-0.75, 0.4, -3.2]], 0.04, 0xBCAA39, n.ammeterCode + 'line1');
    	    				box.addWire([[-1.05, 0, -3.7], [-1.05, 0.4, -3.7], [-1.05, 0.4, -3.2]], 0.04, 0xBCAA39, n.ammeterCode + 'line2');
    	    				box.addWire([[-1.35, 0, -3.7], [-1.35, 0.4, -3.7], [-1.35, 0.4, -3.2]], 0.04, 0x2357A0, n.ammeterCode + 'line3');
    	    				box.addWire([[-1.65, 0, -3.7], [-1.65, 0.4, -3.7], [-1.65, 0.4, -3.2]], 0.04, 0x2357A0, n.ammeterCode + 'line4');
    	    				break;
    	    			case '6':
    	    				box.addMeter([1.5, 0.8, 2.5], [-3.3,0,-2.4], [0,0,0], "meter" + n.ammeterCode, n);
    	    				//接线
    	    				box.addWire([[-2.85, 0, -3.7], [-2.85, 0.4, -3.7], [-2.85, 0.4, -3.2]], 0.04, 0xBCAA39, n.ammeterCode + 'line1');
    	    				box.addWire([[-3.15, 0, -3.7], [-3.15, 0.4, -3.7], [-3.15, 0.4, -3.2]], 0.04, 0xBCAA39, n.ammeterCode + 'line2');
    	    				box.addWire([[-3.45, 0, -3.7], [-3.45, 0.4, -3.7], [-3.45, 0.4, -3.2]], 0.04, 0x2357A0, n.ammeterCode + 'line3');
    	    				box.addWire([[-3.75, 0, -3.7], [-3.75, 0.4, -3.7], [-3.75, 0.4, -3.2]], 0.04, 0x2357A0, n.ammeterCode + 'line4');
    	    				break;
    	    		}
    	    	})
    	    	//获取电表数据
	    		getMeterData();
    	    }
        },	        
        error:function(data){
        }
    });
	
	//获取蓝牙断路器
	$.ajax({
	 	type:'POST', 
     	url:basePath + '/virtualBox/getBreakerByBoxId',           
     	data:{"id":boxId},
     	//async:false,
        success:function(data){
    	    if(data){
    	    	$.each(data, function(i, n){
    	    		switch (n.installAddress.toString()){
    	    			case '1':
    	    				box.addMeterBreaker([1, 1, 1.2], [0,0,-4.8], [0,0,0], "meterbreaker" + n.ammeterAddress, 
    	    						n.openStatus == 0 ? "off" : "on", n);
    	    				break;
    	    			case '2':
    	    				box.addMeterBreaker([1, 1, 1.2], [-0.8,0,-4.8], [0,0,0], "meterbreaker" + n.ammeterAddress, 
    	    						n.openStatus == 0 ? "off" : "on", n);
    	    				break;
    	    			case '3':
    	    				box.addMeterBreaker([1, 1, 1.2], [-1.6,0,-4.8], [0,0,0], "meterbreaker" + n.ammeterAddress, 
    	    						n.openStatus == 0 ? "off" : "on", n);
    	    				break;
    	    			case '4':
    	    				box.addMeterBreaker([1, 1, 1.2], [-2.4,0,-4.8], [0,0,0], "meterbreaker" + n.ammeterAddress, 
    	    						n.openStatus == 0 ? "off" : "on", n);
    	    				break;
    	    			case '5':
    	    				box.addMeterBreaker([1, 1, 1.2], [-3.2,0,-4.8], [0,0,0], "meterbreaker" + n.ammeterAddress, 
    	    						n.openStatus == 0 ? "off" : "on", n);
    	    				break;
    	    			case '6':
    	    				box.addMeterBreaker([1, 1, 1.2], [-4,0,-4.8], [0,0,0], "meterbreaker" + n.ammeterAddress, 
    	    						n.openStatus == 0 ? "off" : "on", n);
    	    				break;
    	    		}
    	    	})
    	    }
        },	        
        error:function(data){
        }
    });
	
	//初始化告警动画
	var alarmDivArray = window.parent.getBoxCurrentAlarm(boxId);
	if (alarmDivArray && alarmDivArray.length > 0){
		$.each(alarmDivArray, function(i, item){
			var oadOI = item.find("input[name='oadOI']").val();
			switch (oadOI){
			case "FF28": //剩余电流超限
				//var deviceType = item.find("input[name='deviceType']").val();
				//var deviceAddress = item.find("input[name='deviceAddress']").val();
				setTransformerAlarm(true);
				break;
			case "FF27": //烟雾事件
				addFire([0,0,5]);
				break;
			case "3060": //表计错位
				var meterAddress = item.find("input[name='deviceAddress']").val();
				setTimeout(function(){
					setMeterAlarm(meterAddress, true);
				}, 1000);
				break;
			case "3035": //误差自检事件
				var meterAddress = item.find("input[name='deviceAddress']").val();
				var data = item.find("input[name='valueText']").val(); 
				setTimeout(function(){
					setMeterErrorAlarm(meterAddress, data, true);
				}, 1000);
				break;
			case "3032": //端子过温
				var deviceType = item.find("input[name='deviceType']").val();
				var deviceAddress = item.find("input[name='deviceAddress']").val();
				var data = item.find("input[name='valueText']").val(); 
				var lineIndex = item.find("input[name='lineIndex']").val(); 
				if (deviceType == "meter"){ //电表
					var data = item.find("input[name='valueText']").val(); 
					setTimeout(function(){
						setMeterLineAlarm(deviceAddress, lineIndex, data, true);
					}, 1000);
				}
				else if (deviceType == "terminal"){ //监测终端
					var data = item.find("input[name='valueText']").val(); 
					setTimeout(function(){
						setTerminalLineAlarm(deviceAddress, lineIndex, data, true);
					}, 1000);
				}
				break;
			}
		})
	}
}

/*
*	遍历加载的表，分别获取其屏幕示数
*	@param {String} boxId 表箱id
*/
function getMeterData(){
	$.each(meterGroup, function(i, n){
		$.ajax({
		 	type:'POST', 
	     	url:basePath + '/virtualBox/getMeterData',           
	     	data:{"meterAddr": n},
	        success:function(data){
	    	    if(data){
	    	    	setMeterValue(n, data);
	    	    }
	        },	        
	        error:function(data){
	        }
	    });
	})
}

/*
*	遍历加载的监测终端，分别获取其屏幕示数
*	@param {String} boxId 表箱id
*/
function getTerminalData(){
	$.each(terminalGroup, function(i, n){
		$.ajax({
		 	type:'POST', 
	     	url:basePath + '/virtualBox/getTerminalData',           
	     	data:{"terminalAddr": n},
	        success:function(data){
	    	    if(data){
	    	    	setTerminalValue(n, data.ambienttemperature, data.barometricPressure, data.humidness);
	    	    }
	        },	        
	        error:function(data){
	        }
	    });
	})
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

$(function (){
	init();
	box = new loadBox();
	
	$("#mainPanel").panel({			//面板改变大小，三维重新渲染
        onResize:function(width,height){
        	resizeThreeWindow(width,height);
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
})
</script>