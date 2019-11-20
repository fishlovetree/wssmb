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
<title>实时曲线</title>
<%@include file="../../FrontHeader.jsp"%>
<style type="text/css">
#organizationtree, #regiontree {
	border-color: transparent;
}

#dayPanel .panel-header {
	border-top: 2px solid #ccc;
}

.l-btn-plain {
	border: 1px solid #ccc;
}

.cbktext {
	vertical-align: middle;
	margin: 0 5px 0 5px;
}

.layout-split-west {
	border-right: 10px solid #081a30;
}

#west, #realtimePanel {
	border-image:
		url(${pageContext.request.contextPath}/js/easyui/themes/ui-dark-hive/images/body-border.png);
	border-image-slice: 6 5 6 5 fill;
	border-image-width: 2px;
}

.table-data-table {
	color: blue;
}

.searchable-select {
	width: 171px;
}

.searchable-select-holder, .searchable-select-item,
	.searchable-select-item .selected {
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
}
</style>
<script>
	var basePath = '${pageContext.request.contextPath}';
	
	//websocket相关
	var ws;
	var port ="0"; //前一次端口号，断线重连时用到
</script>
</head>
<body>
	<div id="realtimePanel" class="easyui-layout"
		style="width: 100%; height: 100%;">
		<div data-options="region:'north'"
			style="padding: 1px 0 1px 10px; border: 0px;">
			<p style="height: 3px;"></p>
			<input type="hidden" id="selectedID" /><span>日期：</span> <input
				type="text" id='date' class="easyui-datebox" editable="fasle"
				style="width: 180px; height: 28px;" /> <a href="#"
				class="easyui-linkbutton linkbutton" id="search"
				onclick="searchdata()">搜索</a> <br />
			<p style="height: 3px;"></p>
			<span>曲线类型：</span> <input type="checkbox" value="4" id="cueeent"
				name="real" checked="checked" onclick="getData()" /><span
				class="cbktext">电流&nbsp;</span> <input type="checkbox" value="7"
				id="temperature" name="real" checked="checked" onclick="getData()" /><span
				class="cbktext">温度&nbsp;</span> <input type="checkbox" value="3"
				id="voltage" name="real" onclick="getData()" /><span
				class="cbktext">电压&nbsp;</span> <input
				type="hidden" value="6" id="pf" name="real"
				onclick="getData()" /><!-- <span class="cbktext">功率因数&nbsp;</span> -->
			<input type="checkbox" value="5" id="power" name="real"
				onclick="getData()" /><span class="cbktext">功率&nbsp;</span> <input
				type="checkbox" value="1" id="elecp" name="real" onclick="getData()" /><span
				class="cbktext">正向电量&nbsp;</span> <input type="checkbox" value="2"
				id="elecr" name="real" onclick="getData()" /><span class="cbktext">反向电量&nbsp;</span>
			<input type="checkbox" value="8" id="gasconcentration" name="real"
				onclick="getData()" /><span class="cbktext">烟感浓度&nbsp;</span> <input
				type="checkbox" value="9" id="humidness" name="real"
				onclick="getData()" /><span class="cbktext">湿度&nbsp;</span> <input
				type="checkbox" value="a" id="humidness" name="real"
				onclick="getData()" /><span class="cbktext">大气压&nbsp;</span>
			<!--  <input
				type="checkbox" value="10" id="error" name="real"
				onclick="getData()" /><span class="cbktext">误差&nbsp;</span> -->
			&nbsp;&nbsp;&nbsp; <a href="#" class="easyui-linkbutton linkbutton"
				id="checkall">全选</a> <a href="#"
				class="easyui-linkbutton linkbutton" id="uncheckall">全不选</a> <a
				href="#" class="easyui-linkbutton linkbutton" id="anti_check">反选</a>
			<p style="height: 3px;"></p>
		</div>
		<div id="south" data-options="region:'center',split:false"
			style="border-top: 2px solid #666666;">
			<div id="curve" class="easyui-panel"
				style="min-width: 850px; height: atuo; border: 0px;">
				<div id="time4" style="height: 250px; margin: auto; display: none;"></div>
				<div id="time7" style="height: 250px; margin: auto; display: none;"></div>
				<div id="time3" style="height: 250px; margin: auto; display: none;"></div>
				<div id="time6" style="height: 250px; margin: auto; display: none;"></div>
				<div id="time5" style="height: 250px; margin: auto; display: none;"></div>
				<div id="time" style="height: 250px; margin: auto; display: none;"></div>
				<div id="time2" style="height: 250px; margin: auto; display: none;"></div>
				<div id="time8" style="height: 250px; margin: auto; display: none;"></div>
				<div id="time9" style="height: 250px; margin: auto; display: none;"></div>
				<div id="timea" style="height: 250px; margin: auto; display: none;"></div>
				<!-- 	<div id="time10" style="height: 250px; margin: auto; display: none;"></div> -->
			</div>
		</div>
	</div>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/js/echarts/echarts.js"></script>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/js/echarts/DarkGray.js"></script>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/js/makeCurve.js"></script>
	<script type="text/javascript">
	var isEmpty=true;		
	  var jsonresult = {};//用来存储ws接收到的数据
	  var issearch = false;
	  var index=0;
	  var freezetime = [];//时间
	  var positiveelectricity = [];//正向电量
	  var reverseelectricity = [];//反向电量
	  var voltagea = [],voltageb = [],voltagec = [];//电压
	  var residualcueeenta = [],residualcueeentb = [],residualcueeentc = [];//电流
	  var power = [],powera = [],powerb = [],powerc = [];//功率
	  var ambienttemperature  = [];//温度
	  var gasconcentration = [];//烟感浓度
	  var humidness = [];//湿度
	  var barometricPressure = [];	//大气压	
			
	  var wsfreezetime = [];//时间
	  var wspositiveelectricity = [];//1正向电量
	  var wsreverseelectricity = [];//2反向电量
	  var wsvoltagea = [],wsvoltageb = [],wsvoltagec = [];//3电压
	  var wsresidualcueeenta  = [],wsresidualcueeentb = [],wsresidualcueeentc = [];//4电流
	  var wspower = [],wspowera = [],wspowerb = [],wspowerc = [];//5功率
	  var wsambienttemperature  = [];//7温度
	  var wsgasconcentration = [];//8烟感浓度
	  var wshumidness = [];//湿度
	  var wsbarometricPressure = [];//大气压
	  var name = "";
		
		var time4 = document.getElementById('time4');
		var time7 = document.getElementById('time7');
		var time3 = document.getElementById('time3');
		var time6 = document.getElementById('time6');
		var time5 = document.getElementById('time5');
		var time = document.getElementById('time');
		var time2 = document.getElementById('time2');
		var time8 = document.getElementById('time8');
		var time9 = document.getElementById('time9');
		var timea = document.getElementById('timea');
//		var time10 = document.getElementById('time10');


		var myChart4 = echarts.init(time4,'DarkGray'); // 初始化
		var myChart7 = echarts.init(time7,'DarkGray'); // 初始化
		var myChart3 = echarts.init(time3,'DarkGray'); // 初始化
		var myChart6 = echarts.init(time6,'DarkGray'); // 初始化
		var myChart5 = echarts.init(time5,'DarkGray'); // 初始化
		var myChart = echarts.init(time,'DarkGray'); // 初始化
		var myChart2 = echarts.init(time2,'DarkGray'); // 初始化
		var myChart8 = echarts.init(time8,'DarkGray'); // 初始化
		var myChart9 = echarts.init(time9,'DarkGray'); // 初始化
		var myCharta = echarts.init(timea,'DarkGray'); // 初始化
//		var myChart10 = echarts.init(time10,'DarkGray'); // 初始化

		var now = new Date();
    	var cur=Format(now,"yyyy-MM-dd");
		var anchor = [];
		
		//用于使chart自适应高度和宽度,通过窗体高宽计算容器高宽
		var resizeDiv = function () {
			var width=window.innerWidth-$('#west').width()-30;
			if(width<845)
				width=845;
			
			time.style.width = width+'px';
			time2.style.width = width+'px';
			time3.style.width = width+'px';
			time4.style.width = width+'px';
			time5.style.width = width+'px';
			time6.style.width = width+'px';
			time7.style.width = width+'px';
			time8.style.width = width+'px';
			time9.style.width = width+'px';
			timea.style.width = width+'px';
//			time10.style.width = width+'px';
			
			$('#time').width(width);
			$('#time2').width(width);
			$('#time3').width(width);
			$('#time4').width(width);
			$('#time5').width(width);
			$('#time6').width(width);
			$('#time7').width(width);
			$('#time8').width(width);
			$('#time9').width(width);
			$('#timea').width(width);
//			$('#time10').width(width);
			
			$('#south .panel').width(width);
			
			$('.zr-element').width(width);
			
			$('#curve').width(width+5);
			
			myChart.resize();
		    myChart2.resize();
		    myChart3.resize();
		    myChart4.resize();
		    myChart5.resize();
		    myChart6.resize();
		    myChart7.resize();
		    myChart8.resize();
		    myChart9.resize();
		    myCharta.resize();
//		    myChart10.resize();
		};
		
		$(function() {
			setInterval(function(){
				if(isEmpty==false && $("#date").datebox('getValue') == Format(now,'yyyy-MM-dd')){

				}
			}, 30*10000);    // 如果有数据则5分钟刷新一次
			
			//全选 
			$("#checkall").click(function(){ 
				$("input[name='real']").prop("checked","checked"); 					
				getData();
			});
			//全不选 
			$("#uncheckall").click(function(){ 
				$("input[name='real']").removeProp("checked"); 
				hideAllElec()
			});
			//反选 
			$("#anti_check").click(function(){ 
				$("input[name='real']").each(function(){ 
					if($(this).prop("checked")) 
						$(this).removeProp("checked"); 
					else 
						$(this).prop("checked","checked");  
				}) 
				getData();
			}) 					
			resizeDiv();	
			$("#west").panel({
		        onResize: function (w, h) {
		        	resizeDiv();
		        }
		    });			
			$(window).resize(function(){ //浏览器窗口变化 
				resizeDiv();
			});		

		 //连接前置机
	     connect();
	   });					
		
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
		    var curPort = makeFrame();
		    if (ws.readyState===1) {
		    	  ws.send(curPort);
		    }	  
		}
		
		//组帧
		function makeFrame(){
			var l="";
			var userid=${requestScope.userid};
			var mf = '{"seq":"${requestScope.seq}","type":"FF","FSNo":"01","svrtype":"1","port":'+'"'+port+'"'+',"userid":"${requestScope.userid}","username":"${requestScope.username}"'+',"reportflag":"1","format":"0"}';		   
			var leng = mf.length;	
		  if(leng.toString(16).length==3){
			 l="0"+leng.toString(16);
		  }
		  if(leng.toString(16).length==2){
			  l="00"+leng.toString(16);
		  }
		  if(leng.toString(16).length==1){
			  l="000"+leng.toString(16);
		  }	
		    return l+mf;
		}
		
		//接收数据
		function WSonMessage(event) {
			var l = "";
			var data = event.data;    	       
	        var str = data.substr(4); //截取字符串
	        var d=eval('(' + str + ')');
	        var dd = d.data;
			if(d.result=="nak"){				
				$.messager.alert("警告", "连接请求被拒绝。", "error");
			}else{
				if(typeof(dd)!='undefined'){
					if(dd.apduType=="136"){
						//确认帧
						var seq=parseInt(d.seq)+1;
						//是否需要判断seq不同    待完成  还有端口是否一直在变  都需要用到redis
						var mf='{"SA":'+d.SA+'","type":'+d.type+'","subType:"'+d.subType+'","seq":'+d.seq+'","ack":"00"}';
						var leng = mf.length;				
						  if(leng.toString(16).length==3){
							 l="0"+leng.toString(16);
						  }
						  if(leng.toString(16).length==2){
							  l="00"+leng.toString(16);
						  }
						  if(leng.toString(16).length==1){
							  l="000"+leng.toString(16);
						  }	
						ws.send(l+mf);
						isEmpty=false;			
						console.log(dd);
	                    parseWSFrame(dd);
					    readytomake();				    
					}else if(d.type=="FF"){
						port=d.port;	
						isEmpty=true;	
					}
				}				
			}		
		}
		
function WSonClose(e) {
		    try {		    	
		        //$.messager.alert("警告", "远程服务器连接中断，请刷新页面后重试。", "error");
		    }
		    catch (ex) {		
		    }
		}
		
function WSonError(e) {

		}
		
//解帧
function parseWSFrame(d){
    var ois = {};
	var address=${requestScope.address};
	var ismatch=0;//判断是否是当前的点击的实时数据
	//判断是否是实时数据的上报
	for(var i=0;i<d.resultRecords.length;i++){
		if(!d.resultRecords[i].recordRows){
			return null;
		}	
		//oad和value的条数
		var csdlength = d.resultRecords[i].listCSD.length;		
		//判断是否是点击的电表或终端			
		for(var m=0;m<csdlength;m++){
			var type=d.resultRecords[i].recordRows[0].columnDatas[m].type;
			if(type=="TSA"){
				var TSAStr=d.resultRecords[i].recordRows[0].columnDatas[m].value;
				var TSAAddress=TSAStr.slice(2);//去掉头2个字符，如果第3，4位是01或者10或者11就是代表终端，如果终端地址和电表不会重复就全部查一遍																	
				if(TSAAddress==address){
					ismatch = 1;						
				}
				break;
			}
		}
		//如果地址匹配
		if(ismatch==1){	
			issearch = false;
			//解析oad
			for(var k=0;k<csdlength;k++){			
				var oad = d.resultRecords[i].listCSD[k].csd.oad;
				if(oad.length==8){//有可能oad长度不为八
					var oadOI=oad.slice(0,4);				       		        
			        if(oadOI=='2000'){//电压
			        	ois[k]	= "voltagea"						
						isreal = 1;
			        	voltagea[index] = parseInt(d.resultRecords[i].recordRows[0].columnDatas[k].value[0].value,16)/10;
			        	voltageb[index] = parseInt(d.resultRecords[i].recordRows[0].columnDatas[k].value[1].value,16)/10;
			        	voltagec[index] = parseInt(d.resultRecords[i].recordRows[0].columnDatas[k].value[2].value,16)/10;    	
					}
			        else if(oadOI=='0010'){//正向有功电能
			        	ois[k]	= "positiveelectricity"	
						isreal = 1;
			        	positiveelectricity[index] = getValue(d.resultRecords[i].recordRows[0].columnDatas[k],100);
					}
			        else if(oadOI=='0020'){//反向有功电能
			        	ois[k]	= "reverseelectricity"
						isreal = 1;
			        	reverseelectricity[index] = getValue(d.resultRecords[i].recordRows[0].columnDatas[k],100);
					}			     
			        else if(oadOI=='2001'){//电流
			        	ois[k]	= "residualcueeent"
						isreal = 1;
			        	residualcueeenta[index] = parseInt(d.resultRecords[i].recordRows[0].columnDatas[k].value[0].value,32)/1000;
			        	residualcueeentb[index] = parseInt(d.resultRecords[i].recordRows[0].columnDatas[k].value[1].value,32)/1000;
			        	residualcueeentc[index] = parseInt(d.resultRecords[i].recordRows[0].columnDatas[k].value[2].value,32)/1000;
					}		       
			        else if(oadOI=='2004'){//有功功率
			        	ois[k]	= "power"
						isreal = 1;
			        	power[index] = parseInt(d.resultRecords[i].recordRows[0].columnDatas[k].value[0].value,32)/10;
			        	powera[index] = parseInt(d.resultRecords[i].recordRows[0].columnDatas[k].value[1].value,32)/10;
			        	powerb[index] = parseInt(d.resultRecords[i].recordRows[0].columnDatas[k].value[2].value,32)/10;
			        	powerc[index] = parseInt(d.resultRecords[i].recordRows[0].columnDatas[k].value[3].value,32)/10;
					}
			        else if(oadOI=='FF21'){//大气压力
			        	ois[k]	= "大气压力"
						isreal = 1;
			        	barometricPressure[index] = getValue(d.resultRecords[i].recordRows[0].columnDatas[k],1);
					}
			        else if(oadOI=='FF22'){//空气相对湿度
			        	ois[k]	= "空气相对湿度"
						isreal = 1;
			        	humidness[index] = getValue(d.resultRecords[i].recordRows[0].columnDatas[k],10);
					}
			        else if(oadOI=='FF23'){//烟感浓度
			        	ois[k]	= "烟感浓度"
						isreal = 1;
			        	gasconcentration[index] = getValue(d.resultRecords[i].recordRows[0].columnDatas[k],1);
					}			       
			        else if(oadOI=='FF20'){//环境温度
			        	ois[k]	= "ambienttemperature"
						isreal = 1;
			        	ambienttemperature[index] = parseInt(d.resultRecords[i].recordRows[0].columnDatas[k].value,16)/10;
					}
			        else if(oadOI=='202A'){	
			        	ois[k]	= "目标服务器地址"
			        	isreal = 1;
				    }
			        else if(oadOI=='4000'){
			        	ois[k]	= "日期时间"
						isreal = 1;
					}
			        else if(oadOI=='6040'){
			        	ois[k]	= "采集启动时标"
						isreal = 1;
					}
			        else if(oadOI=='6041'){
			        	ois[k]	= "采集成功时标"
						isreal = 1;
			        	freezetime[index] = getValue(d.resultRecords[i].recordRows[0].columnDatas[k]);
					}
			        else if(oadOI=='6042'){
			        	ois[k]	= "采集存储时标"
						isreal = 1;
					}										
				}
			}
		}				 			  
	}			
}

function getValue(columnDatas,num){
	//定义返回的数据
	var result = {};
	var type = columnDatas.type;
	var value = columnDatas.value;
	if(type=='date_time_s'){
		if(value.length==14){  
			var year=parseInt(value.substring(0,4),16);   
			var mon=parseInt(value.substring(4,6),16);   
			var day=parseInt(value.substring(6,8),16);   
			var hour=parseInt(value.substring(8,10),16);  
			var min=parseInt(value.substring(10,12),16);   
			var sec=parseInt(value.substring(12,14),16);  
			result =  year+"-"+(mon>=10?mon:"0"+mon)+"-"+(day>=10?day:"0"+day)+" "+(hour>=10?hour:"0"+hour)  
			+":"+(min>=10?min:"0"+min)+":"+(sec>=10?sec:"0"+sec);   
			}				  
	}
	if(type=='long_unsigned'){
		result=parseInt(value,16)/num;
	}
	if(type=="double_long"){
		result=parseInt(value,32)/num;
	}
	if(type=="NULL"){
		result="null";
	}
	if(type=="Long"){
		result=parseInt(value,16)/num;
	}
	if(type=="double_long_unsigned"){
		result=parseInt(value,32)/num;
	}
	if(type=="array"){
		var arrtype=value[0].type;
		var tt =value[0].value;
			if(arrtype=='long_unsigned'){	
				result=parseInt(tt,16)/num;
			}
			if(arrtype=="double_long"){
				result=parseInt(tt,32)/num;
			}
			if(arrtype=="null"){
				result=0;
			}
			if(arrtype=="Long"){
				result=parseInt(tt,16)/num;
			}
			if(arrtype=="double_long_unsigned"){
				result=parseInt(tt,32)/num;
			}			
	}
	return result;		
}

function readytomake(){
	var array = parseThreshold("10",1);	
    var id_array=new Array();  
	$('input[name="real"]:checked').each(function(){  
	    id_array.push($(this).val());//向数组中添加元素  
	});  
	var checkbox=id_array.join(',');//将数组元素连接起来以构建一个字符串  
	if(voltagea[index]==""||voltagea[index]==null){
		voltagea[index]=0;
	}
	if(voltageb[index]==""||voltageb[index]==null){
		voltageb[index]=0;
	}
	if(voltagec[index]==""||voltagec[index]==null){
		voltagec[index]=0;
	}
	if(positiveelectricity[index]==""||positiveelectricity[index]==null){
		positiveelectricity[index]=0;
	}
	if(reverseelectricity[index]==""||reverseelectricity[index]==null){
		reverseelectricity[index]=0;
	}
	if(residualcueeenta[index]==""||residualcueeenta[index]==null){
		residualcueeenta[index]=0;
	}
	if(residualcueeentb[index]==""||residualcueeentb[index]==null){
		residualcueeentb[index]=0;
	}
	if(residualcueeentc[index]==""||residualcueeentc[index]==null){
		residualcueeentc[index]=0;
	}
	if(power[index]==""||power[index]==null){
		power[index]=0;
	}
	if(powera[index]==""||powera[index]==null){
		powera[index]=0;
	}
	if(powerb[index]==""||powerb[index]==null){
		powerb[index]=0;
	}
	if(powerc[index]==""||powerc[index]==null){
		powerc[index]=0;
	}
	if(ambienttemperature[index]==""||ambienttemperature[index]==null){
		ambienttemperature[index]=0;
	}
	if(gasconcentration[index]==""||gasconcentration[index]==null){
		gasconcentration[index]=0;
	}
	if(humidness[index]==""||humidness[index]==null){
		humidness[index]=0;
	}
	if(barometricPressure[index]==""||barometricPressure[index]==null){
		barometricPressure[index]=0;
	}
	//将数据组成json字符串
	 jsonresult='[{"freezeTime":'+'"'+freezetime[index]+'"'+',"voltagea":'+voltagea[index]+',"voltageb":'+voltageb[index]+',"voltagec":'+voltagec[index]+',"positiveelectricity":'+positiveelectricity[index]
		+',"reverseelectricity":'+reverseelectricity[index]
		+',"residualcueeenta":'+residualcueeenta[index]+',"residualcueeentb":'+residualcueeentb[index]+',"residualcueeentc":'
		+residualcueeentc[index]+',"power":'+power[index]+',"powera":'+powera[index]+',"powerb":'+powerb[index]+',"powerc":'+powerc[index]
		+',"ambienttemperature":'+ambienttemperature[index]+',"gasconcentration":'+gasconcentration[index]
		+',"humidness":'+humidness[index]+',"barometricPressure":'+barometricPressure[index]+'}]';
	if(issearch==false){
		index = index+1;
	}	
	makeElecCurve(checkbox,jsonresult,array);
}


		
function hideAllElec(){
	/*		myChart.clear();
			myChart2.clear();
			myChart3.clear();
			myChart4.clear();
			myChart5.clear();
			myChart6.clear();
			myChart7.clear();
			myChart8.clear();
			myChart9.clear();
			myCharta.clear();*/
//			myChart10.clear();
			$("#time").hide();
			$("#time2").hide();
			$("#time3").hide();
			$("#time4").hide();
			$("#time5").hide();
			$("#time6").hide();
			$("#time7").hide();
			$("#time8").hide();
			$("#time9").hide();
			$("#timea").hide();
//			$("#time10").hide();
		}		
		
		function getCurveData(realdata) {
			 var nowtime = new Date();//获取当前时间
			    var nowhour = nowtime.getHours()-2;
			    var passhour;
			    if (nowhour<10){
			    	passhour = "0"+nowhour.toString();
			    }else{
			    	passhour =nowhour.toString();
			    }
			    
			isws=false;
			var date = $("#date").datebox('getValue');
			var dateFormat = new Date(date);
			var strdate=dateFormat.toLocaleDateString();
			if(null==date || date==""){
				strdate=now.toLocaleDateString();
				$("#date").datebox('setValue',"wee");
			}
			
			var startdate="",enddate="";
			startdate=strdate+" "+passhour+":00:00";
			enddate=strdate+" 23:59:59";
			
			anchor = [
		  		{name : startdate, value:[startdate, '']},
		  		{name : enddate, value:[enddate, '']}
		  	];

			var param="";
			var selectedID=$("#selectedID").val();
			if (selectedID != "") {               
				var id_array=new Array();  
				$('input[name="real"]:checked').each(function(){  
				    id_array.push($(this).val());//向数组中添加元素  
				});  
				var checkbox=id_array.join(',');//将数组元素连接起来以构建一个字符串  
       if(checkbox==""){ 
					hideAllElec();
					return;
					}
				var realtimeurl = "${pageContext.request.contextPath}/sysMonitor/realtimedata?Math.random()";
				$ .ajax({   type : "POST",
							data : {
								"equipmentid" : selectedID,
								"startdate" : startdate,
								"enddate" : enddate,
								"checkbox" : checkbox,
								"type" : 5,
								"realdata" : realdata
							},
							url : realtimeurl,
							async : true,
							beforeSend : function() {
								//加载层
			                    if ($("body").find(".datagrid-mask").length == 0) {
		                            //添加等待提示
		                            $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
		                            $("<div class=\"datagrid-mask-msg\"></div>").html("加载中，请稍后...").appendTo("body").css({ color:'#fff', display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
		                        }
							}, //加载执行方法
							error : function() {
								$.messager.alert("警告",  "获取设备实时曲线数据方法错误。", "error");
							}, //错误执行方法
							success : function(d) {
								$("body").find("div.datagrid-mask-msg").remove();
					            $("body").find("div.datagrid-mask").remove();
					            
					            if(d.result==null&&issearch==true){
					            	$.messager.alert("警告",  "当天没有该设备的实时数据", "error");
					            }else{
					            	if(d.result!=null){
									var array = parseThreshold("10",1);					          
										$('input[name="real"]').css("display",'inline-block');
										$('input[name="real"]').next("span").css("display",'inline-block');										
										$("#electr").show();
						            	$("#eleccurve").show();
						            	var a = JSON.parse(d.result);
						            	for ( var p in a) {
						            		if(a[p].oi=='0010'){ 
												if(a[p].groupIndex=='1'){
													var d = new Date(a[p].freezeTime);//实时冻结数据-时间只到分	
													var formatedate = Format(d,"yyyy-MM-dd HH:mm:ss");
													freezetime[index]  = formatedate;
													positiveelectricity[index] = FormatValue(a[p].data);//正向电能									
												}						
											}
						            		if(a[p].oi=='0020'){ 
												if(a[p].groupIndex=='1'){
													reverseelectricity[index] = FormatValue(a[p].data);//反向电能																				
												}								
											}
						            		if(a[p].oi=='2000'){ 
												if(a[p].groupIndex=='1'){
													voltagea[index] = FormatValue(a[p].data);//A相电压									
												}
												if(a[p].groupIndex=='2'){
													voltageb[index] = FormatValue(a[p].data);//B相电压
												}
												if(a[p].groupIndex=='3'){
													voltagec[index] = FormatValue(a[p].data);//C相电压
												}
											}
						            		if(a[p].oi=='2001'){ //电流	
												if(a[p].groupIndex=='1'){
													residualcueeenta[index] = FormatValue(a[p].data);//A相电流		
												}
												if(a[p].groupIndex=='2'){
													residualcueeentb[index] = FormatValue(a[p].data);//B相电流
												}
												if(a[p].groupIndex=='3'){
													residualcueeentc[index] = FormatValue(a[p].data);//C相电流
												}
											}
											if(a[p].oi=='2004'){ 	
												if(a[p].groupIndex=='1'){
													power[index] = FormatValue(a[p].data);//总功率			
												}
												if(a[p].groupIndex=='2'){
													powera[index] = FormatValue(a[p].data);//A相功率
												}
												if(a[p].groupIndex=='3'){
													powerb[index] = FormatValue(a[p].data);//B相功率
												}
												if(a[p].groupIndex=='4'){
													powerc[index] = FormatValue(a[p].data);//C相功率
												}
											}
											if(a[p].oi=='FF20'){ 
												if(a[p].groupIndex=='1'){
													ambienttemperature[index] = FormatValue(a[p].data);//环境温度
												}
											}
											if(a[p].oi=='FF22'){ //湿度
												if(a[p].groupIndex=='1'){
													humidness[index] = FormatValue(a[p].data);//环境温度		
												}
											}
											if(a[p].oi=='FF21'){ 
												if(a[p].groupIndex=='1'){
													barometricPressure[index] = FormatValue(a[p].data);//大气压		
												}
											}
											if(a[p].oi=='FF23'){ //烟感
												if(a[p].groupIndex=='1'){
													gasconcentration[index] = FormatValue(a[p].data);//烟感			
												}
											}
						            	}
						            	readytomake();
					               }
					            }
							}
						}); 
			}
		} 
		
		function makeElecCurve(checkbox,result,array){
			var a = JSON.parse(result);
			if (a!=null) {
				hideAllElec();							
				for ( var p in a) {
					if (typeof a[p].freezeTime!="undefined"){
						var d = new Date(a[p].freezeTime);//实时冻结数据-时间只到分	
						var formatedate = Format(d,"yyyy-MM-dd HH:mm:ss");
						wsfreezetime.push(formatedate);//冻结时间				
							//电流
							wsresidualcueeenta[index] = [formatedate,FormatValue(a[p].residualcueeenta)];//电流
							wsresidualcueeentb[index] = [formatedate,FormatValue(a[p].residualcueeentb)];//电流
							wsresidualcueeentc[index] = [formatedate,FormatValue(a[p].residualcueeentc)];//电流							
							//温度
							wsambienttemperature.push([formatedate,FormatValue(a[p].ambienttemperature)]);//温度						
							//电压
							wsvoltagea[index] = [formatedate,FormatValue(a[p].voltagea)];//电压	
							wsvoltageb[index] = [formatedate,FormatValue(a[p].voltageb)];//电压
							wsvoltagec[index] = [formatedate,FormatValue(a[p].voltagec)];//电压
							//功率
							wspower[index] = [formatedate,FormatValue(a[p].power)];//总功率	
							wspowera[index] = [formatedate,FormatValue(a[p].powera)];			
							wspowerb[index] = [formatedate,FormatValue(a[p].powerb)];			
							wspowerc[index] = [formatedate,FormatValue(a[p].powerc)];			
							//正向电量
							wspositiveelectricity[index] = [formatedate,FormatValue(a[p].positiveelectricity)];//正向总电量						
							//反向电量
							wsreverseelectricity[index] = [formatedate,FormatValue(a[p].reverseelectricity)];//反向总电量						
						    //烟感
							wsgasconcentration[index] = [formatedate,FormatValue(a[p].gasconcentration)];//烟感							
							//湿度
							wshumidness[index] = [formatedate,FormatValue(a[p].humidness)];		
                            //气压
							wsbarometricPressure[index] = [formatedate,FormatValue(a[p].barometricPressure)];		
							getCheck(checkbox);
					}
				}		
					makeRealCurveThree(array);
			}			
		}	

		function getCheck(checkbox){
			hideAllElec();
			if(checkbox.indexOf("4")!=-1){
				$("#time4").show();
				//电流			
			}			
			if(checkbox.indexOf("7")!=-1){
				$("#time7").show();
				//温度					
			}			
			if(checkbox.indexOf("3")!=-1){
				$("#time3").show();
				//电压
			}																
			if(checkbox.indexOf("5")!=-1){
				$("#time5").show();
				//功率;			
			}		
			if(checkbox.indexOf("1")!=-1){
				$("#time").show();
				//正向电量						
			}			
			if(checkbox.indexOf("2")!=-1){
				$("#time2").show();
				//反向电量					
			}			
			if(checkbox.indexOf("8")!=-1){
				$("#time8").show();
				//烟感					
			}
			if(checkbox.indexOf("9")!=-1){
				$("#time9").show();
				//湿度		
			}
			if(checkbox.indexOf("a")!=-1){
				$("#timea").show();	
			}
		}

		function searchdata(){
			issearch = true;
			var selectedID=$("#selectedID").val();
			
			if(selectedID != ""){
				getCurveData();
			}
			else{
				$.messager.alert("提示",  "请选择设备。", "warning");
			}
		}
		
		function getAllCheck(){
			var array = parseThreshold("10",1);	
		    var id_array=new Array();  
			$('input[name="real"]:checked').each(function(){  
			    id_array.push($(this).val());//向数组中添加元素  
			});  
			var checkbox=id_array.join(',');//将数组元素连接起来以构建一个字符串  
			  getCheck(checkbox);
		}
		
		function getData(){
			getAllCheck();
		}
		
	</script>
</body>
</html>