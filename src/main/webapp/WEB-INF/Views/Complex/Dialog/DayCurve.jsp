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
<title>冻结曲线</title>
</head>
<body>

<input type="hidden" id="equipmentid" value=""/>
<div class="easyui-layout" style="width:100%;height: 100%;">
	<div data-options="region:'north'" style="padding: 1px 0 1px 10px; border: 0px;">
   		<p style="height:3px;"></p>
   		<span>开始日期：</span>
		<input type="text" id='startdate' class="easyui-datebox" editable="fasle" style="width: 180px;height: 28px;" />
		<span>结束日期：</span>
		<input type="text" id='enddate' class="easyui-datebox" editable="fasle" style="width: 180px;height: 28px;" />
		<a href="#" class="easyui-linkbutton linkbutton" id="search" onclick="getCurveData()">搜索</a>
		<br/>
		<p style="height:3px;"></p>
		<div id="electr">
			<span>曲线类型：</span>
			<input type="checkbox" value="4" id="cueeent" name="daycbk" checked="checked" onclick="getCurveData()" /><span class="cbktext">电流&nbsp;</span>
				<input type="checkbox" value="7" id="temperature" name="daycbk" checked="checked" onclick="getCurveData()" /><span class="cbktext">温度&nbsp;</span>
				<input type="checkbox" value="3" id="voltage" name="daycbk" onclick="getCurveData()" /><span class="cbktext">电压&nbsp;</span>
				<input type="hidden" value="6" id="pf" name="daycbk" onclick="getCurveData()" /><!--<span class="cbktext">功率因数&nbsp;</span>  -->
				<input type="checkbox" value="5" id="power" name="daycbk" onclick="getCurveData()" /><span class="cbktext">功率&nbsp;</span>
				<input type="checkbox" value="1" id="elecp" name="daycbk" onclick="getCurveData()"/><span class="cbktext">正向电量&nbsp;</span>
				<input type="checkbox" value="2" id="elecr" name="daycbk" onclick="getCurveData()" /><span class="cbktext">反向电量&nbsp;</span>
				<input type="checkbox" value="b" id="gas" name="daycbk" onclick="getCurveData()" /><span class="cbktext">烟感浓度&nbsp;</span>
				<input type="checkbox" value="9" id="humidness" name="daycbk" onclick="getCurveData()" /><span class="cbktext">湿度&nbsp;</span>
				<input type="checkbox" value="a" id="barometric" name="daycbk" onclick="getCurveData()" /><span class="cbktext">大气压&nbsp;</span>
			
			<a href="#" class="easyui-linkbutton linkbutton" id="eleccheckall">全选</a>
			<a href="#" class="easyui-linkbutton linkbutton" id="elecuncheckall">全不选</a>
			<a href="#" class="easyui-linkbutton linkbutton" id="elecanti_check">反选</a>
			<p style="height:3px;"></p>
		</div>
	</div>
	<div id="south" data-options="region:'center',split:false" style="border-top: 2px solid #666666;">
		<div id="eleccurve" class="easyui-panel" style="height:atuo;display:none;border:0px;">
			<div id="elecday4" style="height: 250px;margin:auto;display:none;"></div>
			<div id="elecday7" style="height: 250px;margin:auto;display:none;"></div>
			<div id="elecday3" style="height: 250px;margin:auto;display:none;"></div>
			<div id="elecday6" style="height: 250px;margin:auto;display:none;"></div>
			<div id="elecday5" style="height: 250px;margin:auto;display:none;"></div>
			<div id="elecday" style="height: 250px;margin:auto;display:none;"></div>
			<div id="elecday2" style="height: 250px;margin:auto;display:none;"></div>
			<div id="elecday9" style="height: 250px;margin:auto;display:none;"></div>
	<!-- 	<div id="elecday10" style="height: 250px;margin:auto;display:none;"></div> -->
			<div id="elecdaya" style="height: 250px;margin:auto;display:none;"></div>
			<div id="elecdayb" style="height: 250px;margin:auto;display:none;"></div>
		</div>
		<div id="gascurve" class="easyui-panel" style="height:atuo;display:none;border:0px;">
			<div id="day8" style="height: 250px;margin:auto;display:none;"></div>
		</div>
		<div id="smokecurve" class="easyui-panel" style="height:atuo;display:none;border:0px;">
			<div id="day9" style="height: 250px;margin:auto;display:none;"></div>
		</div>
		<div id="pressurecurve" class="easyui-panel" style="height:atuo;display:none;border:0px;">
			<div id="day10" style="height: 250px;margin:auto;display:none;"></div>
		</div>
		<div id="alarmcurve" class="easyui-panel" style="height:atuo;display:none;border:0px;">
			<div id="day11" style="height: 250px;margin:auto;display:none;"></div>
		</div>
		<div id="levelcurve" class="easyui-panel" style="height:atuo;display:none;border:0px;">
			<div id="day12" style="height: 250px;margin:auto;display:none;"></div>
		</div>
		<div id="firecurve" class="easyui-panel" style="height:atuo;display:none;border:0px;">
			<div id="day13" style="height: 250px;margin:auto;display:none;"></div>
		</div>
	</div>
</div>

<script type="text/javascript">
var freezetime = [];
var positiveelectricity = [], positiveelectricityfreezetime = [];//正向电量
var reverseelectricity = [], reverseelectricityfreezetime = [];//反向电量
var voltagea = [], voltageb = [], voltagec = [], voltagefreezetime = [];
var maxcueeenta = [], maxcueeentb = [], maxcueeentc = [], electricityfreezetime=[];//电流
var power = [], powera = [], powerb = [], powerc = [], powerfreezetime = [];//功率
var maxpf = [], maxpftime = [], maxpfa = [], maxpfatime = [], maxpfb = [], maxpfbtime = [], maxpfc = [], maxpfctime = [];
var minpf = [], minpftime = [], minpfa = [], minpfatime = [], minpfb = [], minpfbtime = [], minpfc = [], minpfctime = [];
var temp = [], temptime = []; //环境温度   
var humidness = [] ,humidnesstime = [];
var error = [],errortime = [];
var barometricPressure = [],barometricPressuretime = [];
var gasconcentration = [],gasconcentrationtime = [];
   
    
    var elecday = document.getElementById('elecday');
    var elecday2 = document.getElementById('elecday2');
    var elecday3 = document.getElementById('elecday3');
    var elecday4 = document.getElementById('elecday4');
    var elecday5 = document.getElementById('elecday5');
    var elecday6 = document.getElementById('elecday6');
    var elecday7 = document.getElementById('elecday7');		
    var elecday9 = document.getElementById('elecday9');
//    	var elecday10 = document.getElementById('elecday10');
    var elecdaya = document.getElementById('elecdaya');
    var elecdayb = document.getElementById('elecdayb');
    var day8 = document.getElementById('day8');
    var day9 = document.getElementById('day9');
    var day10 = document.getElementById('day10');
    var day11 = document.getElementById('day11');
    var day12 = document.getElementById('day12');
    var day13 = document.getElementById('day13');

	//用于使chart自适应高度和宽度,通过窗体高宽计算容器高宽
	var resizeDiv = function () {
		
		var width=780;

		elecday.style.width = width+'px';
		elecday2.style.width = width+'px';
		elecday3.style.width = width+'px';
		elecday4.style.width = width+'px';
		elecday5.style.width = width+'px';
		elecday6.style.width = width+'px';
		elecday7.style.width = width+'px';
		elecday9.style.width = width+'px';
//		elecday10.style.width = width+'px';
		elecdaya.style.width = width+'px';
		elecdayb.style.width = width+'px';
		day8.style.width = width+'px';
		day9.style.width = width+'px';
		day10.style.width = width+'px';
		day11.style.width = width+'px';
		day12.style.width = width+'px';
		day13.style.width = width+'px';
		
		$('#elecday').width(width);
		$('#elecday2').width(width);
		$('#elecday3').width(width);
		$('#elecday4').width(width);
		$('#elecday5').width(width);
		$('#elecday6').width(width);
		$('#elecday7').width(width);
		$('#elecday9').width(width);
//		$('#elecday10').width(width);
		$('#elecdaya').width(width);
		$('#elecdayb').width(width);
		$('#day8').width(width);
		$('#day9').width(width);
		$('#day10').width(width);
		$('#day11').width(width);
		$('#day12').width(width);
		$('#day13').width(width);
		
		$('#south .panel').width(width);
		
		$('.zr-element').width(width);
		
		$('#eleccurve').width(width+5);
		$('#gascurve').width(width+5);
		$('#smokecurve').width(width+5);
		$('#pressurecurve').width(width+5);
		$('#alarmcurve').width(width+5);
		$('#levelcurve').width(width+5);
		$('#firecurve').width(width+5);
	};
	//设置容器高宽
	resizeDiv();

	var myChart = echarts.init(elecday,'DarkGray'); // 初始化
	var myChart2 = echarts.init(elecday2,'DarkGray'); // 初始化
	var myChart3 = echarts.init(elecday3,'DarkGray'); // 初始化
	var myChart4 = echarts.init(elecday4,'DarkGray'); // 初始化
	var myChart5 = echarts.init(elecday5,'DarkGray'); // 初始化
	var myChart6 = echarts.init(elecday6,'DarkGray'); // 初始化
	var myChart7 = echarts.init(elecday7,'DarkGray'); // 初始化 
	var myChart9 = echarts.init(elecday9,'DarkGray'); // 初始化
//	var myChart10 = echarts.init(elecday10,'DarkGray'); // 初始化 
	var myCharta = echarts.init(elecdaya,'DarkGray'); // 初始化 
	var myChartb = echarts.init(elecdayb,'DarkGray'); // 初始化 
	var myChart11 = echarts.init(day8,'DarkGray'); // 初始化 
	var myChart12 = echarts.init(day9,'DarkGray'); // 初始化
	var myChart13 = echarts.init(day10,'DarkGray'); // 初始化
	var myChart14 = echarts.init(day11,'DarkGray'); // 初始化
	var myChart15 = echarts.init(day12,'DarkGray'); // 初始化 
	var myChart16 = echarts.init(day13,'DarkGray'); // 初始化

	$(function() {
		//全选 
		$("#eleccheckall").click(function(){ 
			$("input[name='daycbk']").prop("checked","checked"); 
			getCurveData();
		});
		//全不选 
		$("#elecuncheckall").click(function(){ 
			$("input[name='daycbk']").removeProp("checked"); 
			hideAllElec();
		});
		//反选 
		$("#elecanti_check").click(function(){ 
			$("input[name='daycbk']").each(function(){ 
				if($(this).prop("checked")) 
					$(this).removeProp("checked"); 
				else 
					$(this).prop("checked","checked"); 
			}) 
			getCurveData();
		}) 
		
		 //浏览器大小改变时重置大小
		 window.onresize = function () {
			resizeDiv();
			
			myChart.resize();
		    myChart2.resize();
		    myChart3.resize();
		    myChart4.resize();
		    myChart5.resize();
		    myChart6.resize();
		    myChart7.resize();
			myChart9.resize();
	//		myChart10.resize();
			myCharta.resize();
			myChartb.resize();
			myChart11.resize();
			myChart12.resize();
			myChart13.resize();
			myChart14.resize();
			myChart15.resize();
			myChart16.resize();
		};

		$("#equipmentid").val(node.gid);
		getCurveData();
	});
	
	var subType;
	function getCurveData() {
		$("#eleccurve").hide();
    	$("#gascurve").hide();        	
    	$("#smokecurve").hide();        	
    	$("#pressurecurve").hide();        	
    	$("#alarmcurve").hide();        	
    	$("#levelcurve").hide();        	
    	$("#firecurve").hide();
       	
       	var startdate = $("#startdate").val();
		var enddate = $("#enddate").val();
		var day1 = new Date(startdate);
		var day2 = new Date(enddate);
		if(day1>day2){
			$.messager.alert("提示",  "开始时间必须小于结束时间。", "warning");
			return ;
		}
		
		var param="";
		var equipmentid=$("#equipmentid").val();
		if (equipmentid != "") {

			var id_array=new Array();  
			$('input[name="daycbk"]:checked').each(function(){  
			    id_array.push($(this).val());//向数组中添加元素  
			});  
			var checkbox=id_array.join(',');//将数组元素连接起来以构建一个字符串  
			if(checkbox==""){ hideAllElec(); return;}
			
			var dayurl = "${pageContext.request.contextPath}/sysMonitor/daydata?Math.random()";
			$ .ajax({   type : "POST",
						url : dayurl,
						data : {
							"equipmentid" : equipmentid,
							"startdate" : startdate,
							"enddate" : enddate,
							"checkbox" : checkbox,
							"type" :node.type
						},
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
							$.messager.alert("警告",  "获取设备冻结曲线数据方法错误。", "error");
						}, //错误执行方法
						success : function(d) {
							$("body").find("div.datagrid-mask-msg").remove();
				            $("body").find("div.datagrid-mask").remove();

				            var threshold=d.threshold;
							var array = parseThreshold(d.systemtype,threshold);

							subType = d.subType;				           
								$('input[name="daycbk"]').css("display",'inline-block');
								$('input[name="daycbk"]').next("span").css("display",'inline-block');
								
								$("#electr").show();
				            	$("#eleccurve").show();
				            	makeElecCurve(checkbox,d.result,array);
							
						}
					}); //ajax
		}
	} // getCurveData()
	
	function hideAllElec(){
		myChart.clear();
		myChart2.clear();
		myChart3.clear();
		myChart4.clear();
		myChart5.clear();
		myChart6.clear();
		myChart7.clear();
		myChart9.clear();
	//	myChart10.clear();
		myCharta.clear();
		myChartb.clear();
		$("#elecday").hide();
		$("#elecday2").hide();
		$("#elecday3").hide();
		$("#elecday4").hide();
		$("#elecday5").hide();
		$("#elecday6").hide();
		$("#elecday7").hide();
		$("#elecday9").hide();
//		$("#elecday10").hide();
		$("#elecdaya").hide();
		$("#elecdayb").hide();
		}
	
	function makeElecCurve(checkbox,d,array){
		var a = JSON.parse(d);
		if (a !=null) {
			
			hideAllElec();
			
			positiveelectricity = [], positiveelectricityfreezetime = [];//正向电量
			reverseelectricity = [], reverseelectricityfreezetime = [];//反向电量
			voltagea = [], voltageb = [], voltagec = [], voltagefreezetime = [];//电压
		    maxcueeenta = [], maxcueeentb = [], maxcueeentc = [],electricityfreezetime = [];//电流
		    power = [], powera = [], powerb = [], powerc = [], powerfreezetime = [];//功率
		    maxpf = [], maxpftime = [], maxpfa = [], maxpfatime = [], maxpfb = [], maxpfbtime = [], maxpfc = [], maxpfctime = [];
		    minpf = [], minpftime = [], minpfa = [], minpfatime = [], minpfb = [], minpfbtime = [], minpfc = [], minpfctime = [];
		    temp = [], temptime = [];//环境温度
			freezetime = [];
			humidness = [] , humidnesstime = [];
			error = [],errortime = [];
			barometricPressure = [],barometricPressuretime = [];
			gasconcentration = [], gasconcentrationtime = [];
			
			for ( var p in a) {
				//	alert(a[p].freezeTime);				
				if (typeof a[p].freezeTime!="undefined"){
					var d = new Date(a[p].freezeTime);//实时冻结数据-时间只到日
					freezetime.push(Format(d,"yyyy-MM-dd"));//冻结时间
									
						if(checkbox.indexOf("1")!=-1){
							$("#elecday").show();
							if(checkbox=="10"&&checkbox!="1"){
								$("#elecday").hide();
							}
							if(a[p].oi=='0010'){ 
								if(a[p].groupIndex=='1'){
									positiveelectricity.push(FormatValue(a[p].data));//正向电能									
									positiveelectricityfreezetime.push(Format(d,"yyyy-MM-dd"));
								}
								
							} 
						}
						
						if(checkbox.indexOf("2")!=-1){
							$("#elecday2").show();
							//反向电量
							if(a[p].oi=='0020'){ 
								if(a[p].groupIndex=='1'){
									reverseelectricity.push(FormatValue(a[p].data));//反向电能									
									reverseelectricityfreezetime.push(Format(d,"yyyy-MM-dd"));
								}
								
							}				
						}
						
						if(checkbox.indexOf("3")!=-1){
							$("#elecday3").show();
							//电压					
							if(a[p].oi=='2000'){ 
								if(a[p].groupIndex=='1'){
									voltagea.push(FormatValue(a[p].data));//A相电压									
									voltagefreezetime.push(Format(d,"yyyy-MM-dd"));//冻结时间
								}
								if(a[p].groupIndex=='2'){
									voltageb.push(FormatValue(a[p].data));//B相电压
								}
								if(a[p].groupIndex=='3'){
									voltagec.push(FormatValue(a[p].data));//C相电压
								}
							}
						}						
						if(checkbox.indexOf("4")!=-1){						
							$("#elecday4").show(); 
							if(a[p].oi=='2001'){ //电流	
								if(a[p].groupIndex=='1'){
									maxcueeenta.push(FormatValue(a[p].data));//A相电流									
									electricityfreezetime.push(Format(d,"yyyy-MM-dd"));//冻结时间
								}
								if(a[p].groupIndex=='2'){
									maxcueeentb.push(FormatValue(a[p].data));//B相电流
								}
								if(a[p].groupIndex=='3'){
									maxcueeentc.push(FormatValue(a[p].data));//C相电流
								}
							}												
						}
						
						if(checkbox.indexOf("5")!=-1){
							$("#elecday5").show();
							//功率
							if(a[p].oi=='2004'){ 	
								if(a[p].groupIndex=='1'){
									power.push(FormatValue(a[p].data));//总功率									
									powerfreezetime.push(Format(d,"yyyy-MM-dd"));//冻结时间
								}
								if(a[p].groupIndex=='2'){
									powera.push(FormatValue(a[p].data));//A相功率
								}
								if(a[p].groupIndex=='3'){
									powerb.push(FormatValue(a[p].data));//B相功率
								}
								if(a[p].groupIndex=='4'){
									powerc.push(FormatValue(a[p].data));//C相功率
								}
							}						
						}
						
					/*	if(checkbox.indexOf("6")!=-1){
							$("#elecday6").show();
							//功率因数
							maxpf.push(FormatValue(a[p].maxpf));//最大总功率因数
							maxpftime.push(dateFormat(a[p].maxpftime));//最大总功率因数发生时间
							maxpfa.push(FormatValue(a[p].maxpfa));//最大A相功率因数
							maxpfatime.push(dateFormat(a[p].maxpfatime));//最大A相功率因数发生时间
							maxpfb.push(FormatValue(a[p].maxpfb));//最大B相功率因数
							maxpfbtime.push(dateFormat(a[p].maxpfbtime));//最大B相功率因数发生时间
							maxpfc.push(FormatValue(a[p].maxpfc));//最大C相功率因数
							maxpfctime.push(dateFormat(a[p].maxpfctime));//最大C相功率因数发生时间
						    minpf.push(FormatValue(a[p].minpf));//最小总功率因数
						    minpftime.push(dateFormat(a[p].minpftime));//最小总功率因数发生时间
						    minpfa.push(FormatValue(a[p].minpfa));//最小A相功率因数
						    minpfatime.push(dateFormat(a[p].minpfatime));//最小A相功率因数发生时间
						    minpfb.push(FormatValue(a[p].minpfb));//最小B相功率因数
						    minpfbtime.push(dateFormat(a[p].minpfbtime));//最小B相功率因数发生时间
						    minpfc.push(FormatValue(a[p].minpfc));//最小C相功率因数
						    minpfctime.push(dateFormat(a[p].minpfctime));//最小C相功率因数发生时间
						}*/
						
						if(checkbox.indexOf("7")!=-1){
							$("#elecday7").show();
							//温度
							if(a[p].oi=='FF20'){ 
								if(a[p].groupIndex=='1'){
									temp.push(FormatValue(a[p].data));//环境温度													
									temptime.push(Format(d,"yyyy-MM-dd"));//冻结时间
								}
							}
						}
						if(checkbox.indexOf("9")!=-1){
							$("#elecday9").show();
							if(a[p].oi=='FF22'){ //湿度
								if(a[p].groupIndex=='1'){
									humidness.push(FormatValue(a[p].data));//环境温度													
									humidnesstime.push(Format(d,"yyyy-MM-dd"));//冻结时间
								}
							}
						}
						if(checkbox.indexOf("a")!=-1){
							$("#elecdaya").show();
							if(a[p].oi=='FF21'){ 
								if(a[p].groupIndex=='1'){
									barometricPressure.push(FormatValue(a[p].data));//环境温度													
									barometricPressuretime.push(Format(d,"yyyy-MM-dd"));//冻结时间
								}
							}					
						}
						if(checkbox.indexOf("b")!=-1){
							$("#elecdayb").show();
							if(a[p].oi=='FF23'){ //烟感
								if(a[p].groupIndex=='1'){
									gasconcentration.push(FormatValue(a[p].data));//环境温度													
									gasconcentrationtime.push(Format(d,"yyyy-MM-dd"));//冻结时间
								}
							}							
						}
						
					}
				}
	
			//if(powermode == 3)
				makeDayCurveThree(array);
			//else
				//makeDayCurveSingle(array);
		}
		else{
			$.messager.alert("提示",  "未查询到该电气设备的冻结数据。", "warning");
			hideAllElec();
		} //if (a.length > 0)			
			
		myChart11.clear();
		myChart12.clear();
		myChart13.clear();
		myChart14.clear();
		myChart15.clear();
		myChart16.clear();
	}
	
	
	
	function dateFormat(data){
		if(null!=data && data!="undefined"){
			var d = new Date(data);//实时冻结数据-时间只到日
			time=Format(d,"yyyy-MM-dd HH:mm:ss");//冻结时间
			return time; 
		}
		return "";
	}
</script>
</body>
</html>