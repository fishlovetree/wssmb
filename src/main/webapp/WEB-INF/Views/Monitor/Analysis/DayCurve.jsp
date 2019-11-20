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
<%@include file="../../FrontHeader.jsp" %>
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
.cbktext{
	vertical-align: middle;
	margin:0 5px 0 5px;
}
.layout-split-west {
    border-right: 10px solid #081a30;
}
#west, #index_center {
    border-image: url(${pageContext.request.contextPath}/js/easyui/themes/ui-dark-hive/images/body-border.png);
	border-image-slice: 6 5 6 5 fill;
    border-image-width: 2px;
}

.table-data-table {
    color: blue;
}
</style>
</head>
<body>
	<div id="index_center" class="easyui-layout" style="width:100%;height: 100%;">
       	<div data-options="region:'north'" style="padding: 1px 0 1px 10px; border: 0px;">
       		<p style="height:3px;"></p>
       		<input type="hidden" id='gid' />
       		<span>设备：</span>
       		<input type="text" id='snode' class="easyui-textbox" readonly="readonly" style="width: 180px;height: 28px;" />
			<span>开始日期：</span>
			<input type="text" id='startdate' class="easyui-datebox" editable="fasle" style="width: 180px;height: 28px;" />
			<span>结束日期：</span>
			<input type="text" id='enddate' class="easyui-datebox" editable="fasle" style="width: 180px;height: 28px;" />
			<a href="#" class="easyui-linkbutton linkbutton" id="search" onclick="searchdata()">搜索</a>
			<br/>
			<p style="height:3px;"></p>
			<div id="electr">
				<span>曲线类型：</span>
				<input type="checkbox" value="4" id="cueeent" name="daycbk" checked="checked" onclick="getCurveData()" /><span class="cbktext">电流&nbsp;</span>
				<input type="checkbox" value="7" id="temperature" name="daycbk" checked="checked" onclick="getCurveData()" /><span class="cbktext">温度&nbsp;</span>
				<input type="checkbox" value="3" id="voltage" name="daycbk" onclick="getCurveData()" /><span class="cbktext">电压&nbsp;</span>
				<input type="checkbox" value="6" id="pf" name="daycbk" onclick="getCurveData()" /><span class="cbktext">功率因数&nbsp;</span>
				<input type="checkbox" value="5" id="power" name="daycbk" onclick="getCurveData()" /><span class="cbktext">功率&nbsp;</span>
				<input type="checkbox" value="1" id="elecp" name="daycbk" onclick="getCurveData()"/><span class="cbktext">正向电量&nbsp;</span>
				<input type="checkbox" value="2" id="elecr" name="daycbk" onclick="getCurveData()" /><span class="cbktext">反向电量&nbsp;</span>&nbsp;&nbsp;&nbsp;
				
				<a href="#" class="easyui-linkbutton linkbutton" id="eleccheckall">全选</a>
				<a href="#" class="easyui-linkbutton linkbutton" id="elecuncheckall">全不选</a>
				<a href="#" class="easyui-linkbutton linkbutton" id="elecanti_check">反选</a>
				<p style="height:3px;"></p>
			</div>
       	</div>
       	<div id="south" data-options="region:'center',split:false" style="border-top: 2px solid #666666;">
       		<label id="freezingtype" style="color: aqua;font-size: 14px;"></label>
			<div id="eleccurve" class="easyui-panel" style="min-width:850px;height:atuo;display:none;border:0px;">
				<div id="elecday4" style="height: 250px;margin:auto;display:none;"></div>
				<div id="elecday7" style="height: 250px;margin:auto;display:none;"></div>
				<div id="elecday3" style="height: 250px;margin:auto;display:none;"></div>
				<div id="elecday6" style="height: 250px;margin:auto;display:none;"></div>
				<div id="elecday5" style="height: 250px;margin:auto;display:none;"></div>
				<div id="elecday" style="height: 250px;margin:auto;display:none;"></div>
				<div id="elecday2" style="height: 250px;margin:auto;display:none;"></div>
			</div>
			<div id="gascurve" class="easyui-panel" style="min-width:850px;height:atuo;display:none;border:0px;">
				<div id="day8" style="height: 250px;margin:auto;display:none;"></div>
			</div>
			<div id="smokecurve" class="easyui-panel" style="min-width:850px;height:atuo;display:none;border:0px;">
				<div id="day9" style="height: 250px;margin:auto;display:none;"></div>
			</div>
			<div id="pressurecurve" class="easyui-panel" style="min-width:850px;height:atuo;display:none;border:0px;">
				<div id="day10" style="height: 250px;margin:auto;display:none;"></div>
			</div>
			<div id="alarmcurve" class="easyui-panel" style="min-width:850px;height:atuo;display:none;border:0px;">
				<div id="day11" style="height: 250px;margin:auto;display:none;"></div>
			</div>
			<div id="levelcurve" class="easyui-panel" style="min-width:850px;height:atuo;display:none;border:0px;">
				<div id="day12" style="height: 250px;margin:auto;display:none;"></div>
			</div>
			<div id="firecurve" class="easyui-panel" style="min-width:850px;height:atuo;display:none;border:0px;">
				<div id="day13" style="height: 250px;margin:auto;display:none;"></div>
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

		var positiveelectricity = [], positiveelectricitya = [], positiveelectricityb = [], positiveelectricityc = [];//正向电量
		var reverseelectricity = [], reverseelectricitya = [], reverseelectricityb = [], reverseelectricityc = [];//反向电量
		var maxvoltagea = [], maxvoltageatime = [], maxvoltageb = [], maxvoltagebtime = [], maxvoltagec = [], maxvoltagectime = [];
	    var minvoltagea = [], minvoltageatime = [], minvoltageb = [], minvoltagebtime = [], minvoltagec = [], minvoltagectime = [];
	    var maxcueeenta = [], maxcueeentatime = [], maxcueeentb = [], maxcueeentbtime = [], maxcueeentc = [], maxcueeentctime = [], maxresidualcurrent = [], maxresidualcurrenttime = [];
	    var mincueeenta = [], mincueeentatime = [], mincueeentb = [], mincueeentbtime = [], mincueeentc = [], mincueeentctime = [], minresidualcurrent = [], minresidualcurrenttime = [];
	    var maxpower = [], maxpowertime = [], maxpowera = [], maxpoweratime = [], maxpowerb = [], maxpowerbtime = [], maxpowerc = [], maxpowerctime = [];
	    var minpower = [], minpowertime = [], minpowera = [], minpoweratime = [], minpowerb = [], minpowerbtime = [], minpowerc = [], minpowerctime = [];
	    var maxpf = [], maxpftime = [], maxpfa = [], maxpfatime = [], maxpfb = [], maxpfbtime = [], maxpfc = [], maxpfctime = [];
	    var minpf = [], minpftime = [], minpfa = [], minpfatime = [], minpfb = [], minpfbtime = [], minpfc = [], minpfctime = [];
	    var maxtempa = [], maxtempatime = [], maxtempb = [], maxtempbtime = [], maxtempc = [], maxtempctime = [], maxtempn = [], maxtempntime = [], maxambienttemp = [], maxambienttemptime = [];
	    var mintempa = [], mintempatime = [], mintempb = [], mintempbtime = [], mintempc = [], mintempctime = [], mintempn = [], mintempntime = [], minambienttemp = [], minambienttemptime = [];
	    var freezetime = [];
	    
	    //多路设备
		var onemaxcue = [], onemaxcuetime = [], onemincue = [], onemincuetime = [];
		var twomaxcue = [], twomaxcuetime = [], twomincue = [], twomincuetime = [];
		var threemaxcue = [], threemaxcuetime = [], threemincue = [], threemincuetime = [];
		var fourmaxcue = [], fourmaxcuetime = [], fourmincue = [], fourmincuetime = [];
		var fivemaxcue = [], fivemaxcuetime = [], fivemincue = [], fivemincuetime = [];
		var sixmaxcue = [], sixmaxcuetime = [], sixmincue = [], sixmincuetime = [];
		var sevenmaxcue = [], sevenmaxcuetime = [], sevenmincue = [], sevenmincuetime = [];
		var eightmaxcue = [], eightmaxcuetime = [], eightmincue = [], eightmincuetime = [];
		var onemaxtemp = [], onemaxtemptime = [], onemintemp = [], onemintemptime = [];
		var twomaxtemp = [], twomaxtemptime = [], twomintemp = [], twomintemptime = [];
		var threemaxtemp = [], threemaxtemptime = [], threemintemp = [], threemintemptime = [];
		var fourmaxtemp = [], fourmaxtemptime = [], fourmintemp = [], fourmintemptime = [];
		var fivemaxtemp = [], fivemaxtemptime = [], fivemintemp = [], fivemintemptime = [];
		var sixmaxtemp = [], sixmaxtemptime = [], sixmintemp = [], sixmintemptime = [];
		var sevenmaxtemp = [], sevenmaxtemptime = [], sevenmintemp = [], sevenmintemptime = [];
		var eightmaxtemp = [], eightmaxtemptime = [], eightmintemp = [], eightmintemptime = [];
	    
		var elecday = document.getElementById('elecday');
		var elecday2 = document.getElementById('elecday2');
		var elecday3 = document.getElementById('elecday3');
		var elecday4 = document.getElementById('elecday4');
		var elecday5 = document.getElementById('elecday5');
		var elecday6 = document.getElementById('elecday6');
		var elecday7 = document.getElementById('elecday7');
		var day8 = document.getElementById('day8');
		var day9 = document.getElementById('day9');
		var day10 = document.getElementById('day10');
		var day11 = document.getElementById('day11');
		var day12 = document.getElementById('day12');
		var day13 = document.getElementById('day13');
		
		var myChart = echarts.init(elecday,'DarkGray'); // 初始化
		var myChart2 = echarts.init(elecday2,'DarkGray'); // 初始化
		var myChart3 = echarts.init(elecday3,'DarkGray'); // 初始化
		var myChart4 = echarts.init(elecday4,'DarkGray'); // 初始化
		var myChart5 = echarts.init(elecday5,'DarkGray'); // 初始化
		var myChart6 = echarts.init(elecday6,'DarkGray'); // 初始化
		var myChart7 = echarts.init(elecday7,'DarkGray'); // 初始化 
		var myChart8 = echarts.init(day8,'DarkGray'); // 初始化 
		var myChart9 = echarts.init(day9,'DarkGray'); // 初始化
		var myChart10 = echarts.init(day10,'DarkGray'); // 初始化
		var myChart11 = echarts.init(day11,'DarkGray'); // 初始化
		var myChart12 = echarts.init(day12,'DarkGray'); // 初始化 
		var myChart13 = echarts.init(day13,'DarkGray'); // 初始化

		//用于使chart自适应高度和宽度,通过窗体高宽计算容器高宽
		var resizeDiv = function () {
			
			var width=window.innerWidth-$('#west').width()-30;
			if(width<845)
				width=845;
			
			elecday.style.width = width+'px';
			elecday2.style.width = width+'px';
			elecday3.style.width = width+'px';
			elecday4.style.width = width+'px';
			elecday5.style.width = width+'px';
			elecday6.style.width = width+'px';
			elecday7.style.width = width+'px';
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
			
			myChart.resize();
		    myChart2.resize();
		    myChart3.resize();
		    myChart4.resize();
		    myChart5.resize();
		    myChart6.resize();
		    myChart7.resize();
		    myChart8.resize();
			myChart9.resize();
			myChart10.resize();
			myChart11.resize();
			myChart12.resize();
			myChart13.resize();
		};
		
		var node;
		var pnode;
		var ppnode;
		$(function() {
			node = parent.node;
			pnode = parent.p_node;
			ppnode = parent.pp_node;
			
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
			
			resizeDiv();
	
			$("#west").panel({
		        onResize: function (w, h) {
		        	resizeDiv();
		        }
		    });
			
			$(window).resize(function(){ //浏览器窗口变化 
				resizeDiv();
			});

			searchFile();
		})

		function searchFile() {
			$("#eleccurve").hide();
        	$("#gascurve").hide();
        	$("#smokecurve").hide();
        	$("#pressurecurve").hide();
        	$("#alarmcurve").hide();
        	$("#levelcurve").hide();
        	$("#firecurve").hide();
			
			if (node.type == commonTreeNodeType.gprsDevice 
					|| node.type == commonTreeNodeType.terminalDevice 
					|| node.type == commonTreeNodeType.transmissionDevice 
					|| node.type == commonTreeNodeType.nbDevice) {
				$("#snode").textbox('setValue', node.text);
				$("#gid").val(node.gid);
                
				getCurveData();
			} else {
				$("#snode").textbox('setValue', "");
				$("#gid").val("");
			}
		}
		
		function searchdata(){
			var gid=$("#gid").val();
			
			if(gid != ""){
				getCurveData();
			}
			else{
				$.messager.alert("提示",  "请选择设备。", "warning");
			}
		}
		
		var subType;
		function getCurveData() {
			$("#eleccurve").hide();
        	$("#gascurve").hide();        	
        	$("#smokecurve").hide();        	
        	$("#pressurecurve").hide();        	
        	$("#alarmcurve").hide();        	
        	$("#levelcurve").hide();        	
        	$("#firecurve").hide();
        	
        	var startdate = $("#startdate").datebox('getValue');
			var enddate = $("#enddate").datebox('getValue');
			var day1 = new Date(startdate);
			var day2 = new Date(enddate);
			
			if(day1>day2){
				$.messager.alert("提示",  "开始时间必须小于结束时间。", "warning");
				return ;
			}

			var param="";
			var gid=$("#gid").val();
			if (gid != "") {

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
								"equipmentid" : gid,
								"startdate" : startdate,
								"enddate" : enddate,
								"checkbox" : checkbox
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
					            
					            switch(d.freezingtype){
					            case 77:
									$("#freezingtype").text("冻结类型：周冻结");
									break;
								case 99:
									$("#freezingtype").text("冻结类型：月冻结");
									break;
								default:
									$("#freezingtype").text("冻结类型：日冻结");
									break;
								}
					            
					            var threshold=d.threshold;
								var array = parseThreshold(d.systemtype,threshold);

								subType = d.subType;
					            switch(subType){
					            case 1://电气火灾探测器
									$('input[name="daycbk"]').css("display",'inline-block');
									$('input[name="daycbk"]').next("span").css("display",'inline-block');
									
									$("#electr").show();
					            	$("#eleccurve").show();
					            	makeElecCurve(checkbox,d.result,array);
									break;
								case 2://多路温度监控、多路电流监控
									$('input[name="daycbk"]').css("display",'none');
									$('input[name="daycbk"]').next("span").css("display",'none');
									$('input[name="daycbk"]:lt(2)').css("display",'inline-block');
									$('input[name="daycbk"]:lt(2)').next("span").css("display",'inline-block');
									
									$("#electr").show();
					            	$("#eleccurve").show();
					            	makeMulCurve(checkbox,d.result);
									
									break;
								case 3://燃气探测器
									$("#electr").hide();
					            	$("#gascurve").show();
					            	$("#day8").show();
									makeGasCurve(d.result,array);
									break;
								case 4:case 5:case 6://LORA烟感、NB黑白烟感、百思威烟感
									$("#electr").hide();
					            	$("#smokecurve").show();
					            	$("#day9").show();
					            	
									if(subType==5)
										makeNbSmokeCurve(d.result,array);
									else
										makeSmokeCurve(d.result,array);
									break;
								case 7:case 8://LORA水压、NB水压
									$("#electr").hide();
					            	$("#pressurecurve").show();
					            	$("#day10").show();
					            	
					            	if(subType==7)
					            		makePressureCurve(d.result,array);
					            	else
					            		makeNbPressureCurve(d.result,array);
									break;
								case 9:case 10://报警按钮、声光报警器    ///////***********以后会分开************////////////
									$("#electr").hide();
					            	$("#alarmcurve").show();
					            	$("#day11").show();
					            	makeAlarmCurve(d.result,array,d.equipmenttype);
									break;
								/*case 10://声光报警器  
									break;*/
								case 11:case 12://LORA水位、NB水位
									$("#electr").hide();
					            	$("#levelcurve").show();
					            	$("#day12").show();
					            	
					            	if(subType==11)
					            		makeLevelCurve(d.result,array);
					            	else
					            		makeNbLevelCurve(d.result,array);
									break;
								}
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
			$("#elecday").hide();
			$("#elecday2").hide();
			$("#elecday3").hide();
			$("#elecday4").hide();
			$("#elecday5").hide();
			$("#elecday6").hide();
			$("#elecday7").hide();
		}
		
		function makeElecCurve(checkbox,d,array){
			var a = JSON.parse(d);
			if (a.length > 0) {
				
				hideAllElec();
				
				positiveelectricity = [], positiveelectricitya = [], positiveelectricityb = [], positiveelectricityc = [];//正向电量
				reverseelectricity = [], reverseelectricitya = [], reverseelectricityb = [], reverseelectricityc = [];//反向电量
				maxvoltagea = [], maxvoltageatime = [], maxvoltageb = [], maxvoltagebtime = [], maxvoltagec = [], maxvoltagectime = [];
			    minvoltagea = [], minvoltageatime = [], minvoltageb = [], minvoltagebtime = [], minvoltagec = [], minvoltagectime = [];
			    maxcueeenta = [], maxcueeentatime = [], maxcueeentb = [], maxcueeentbtime = [], maxcueeentc = [], maxcueeentctime = [], maxresidualcurrent = [], maxresidualcurrenttime = [];
			    mincueeenta = [], mincueeentatime = [], mincueeentb = [], mincueeentbtime = [], mincueeentc = [], mincueeentctime = [], minresidualcurrent = [], minresidualcurrenttime = [];
			    maxpower = [], maxpowertime = [], maxpowera = [], maxpoweratime = [], maxpowerb = [], maxpowerbtime = [], maxpowerc = [], maxpowerctime = [];
			    minpower = [], minpowertime = [], minpowera = [], minpoweratime = [], minpowerb = [], minpowerbtime = [], minpowerc = [], minpowerctime = [];
			    maxpf = [], maxpftime = [], maxpfa = [], maxpfatime = [], maxpfb = [], maxpfbtime = [], maxpfc = [], maxpfctime = [];
			    minpf = [], minpftime = [], minpfa = [], minpfatime = [], minpfb = [], minpfbtime = [], minpfc = [], minpfctime = [];
			    maxtempa = [], maxtempatime = [], maxtempb = [], maxtempbtime = [], maxtempc = [], maxtempctime = [], maxtempn = [], maxtempntime = [], maxambienttemp = [], maxambienttemptime = [];
			    mintempa = [], mintempatime = [], mintempb = [], mintempbtime = [], mintempc = [], mintempctime = [], mintempn = [], mintempntime = [], minambienttemp = [], minambienttemptime = [];
				freezetime = [];
				
				for ( var p in a) {
					if (typeof a[p].freezetime!="undefined"){
						var d = new Date(a[p].freezetime);//实时冻结数据-时间只到日
						freezetime.push(Format(d,"yyyy-MM-dd"));//冻结时间
						
						if(checkbox.indexOf("1")!=-1){
							$("#elecday").show();
							//正向电量
							positiveelectricity.push(FormatValue(a[p].positiveelectricity));//正向总电量
							positiveelectricitya.push(FormatValue(a[p].positiveelectricitya));//正向A相电量
							positiveelectricityb.push(FormatValue(a[p].positiveelectricityb));//正向B相电量
							positiveelectricityc.push(FormatValue(a[p].positiveelectricityc));//正向C相电量
						}
						
						if(checkbox.indexOf("2")!=-1){
							$("#elecday2").show();
							//反向电量
							reverseelectricity.push(FormatValue(a[p].reverseelectricity));//反向总电量
							reverseelectricitya.push(FormatValue(a[p].reverseelectricitya));//反向A相电量
							reverseelectricityb.push(FormatValue(a[p].reverseelectricityb));//反向B相电量
							reverseelectricityc.push(FormatValue(a[p].reverseelectricityc));//反向C相电量
						}
						
						if(checkbox.indexOf("3")!=-1){
							$("#elecday3").show();
							//电压
							maxvoltagea.push(FormatValue(a[p].maxvoltagea));//最大A相电压 
							maxvoltageatime.push(dateFormat(a[p].maxvoltageatime));//最大A相电压 发生时间
							maxvoltageb.push(FormatValue(a[p].maxvoltageb));//最大B相电压 
							maxvoltagebtime.push(dateFormat(a[p].maxvoltagebtime));//最大B相电压 发生时间
							maxvoltagec.push(FormatValue(a[p].maxvoltagec));//最大C相电压 
							maxvoltagectime.push(dateFormat(a[p].maxvoltagectime));//最大C相电压 发生时间
						    minvoltagea.push(FormatValue(a[p].minvoltagea));//最小A相电压 
						    minvoltageatime.push(dateFormat(a[p].minvoltageatime));//最小A相电压 发生时间
						    minvoltageb.push(FormatValue(a[p].minvoltageb));//最小B相电压  
						    minvoltagebtime.push(dateFormat(a[p].minvoltagebtime));//最小B相电压 发生时间
						    minvoltagec.push(FormatValue(a[p].minvoltagec));//最小C相电压 
						    minvoltagectime.push(dateFormat(a[p].minvoltagectime));//最小C相电压 发生时间
						}
						
						if(checkbox.indexOf("4")!=-1){
							$("#elecday4").show();
							//电流
							maxcueeenta.push(FormatValue(a[p].maxcueeenta));//最大A相电流
							maxcueeentatime.push(dateFormat(a[p].maxcueeentatime));//最大A相电流发生时间
							maxcueeentb.push(FormatValue(a[p].maxcueeentb));//最大B相电流
							maxcueeentbtime.push(dateFormat(a[p].maxcueeentbtime));//最大B相电流发生时间
							maxcueeentc.push(FormatValue(a[p].maxcueeentc));//最大C相电流
							maxcueeentctime.push(dateFormat(a[p].maxcueeentctime));//最大C相电流发生时间
							maxresidualcurrent.push(FormatValue(a[p].maxresidualcurrent));//最大剩余电流
							maxresidualcurrenttime.push(dateFormat(a[p].maxresidualcurrenttime));//最大剩余电流发生时间
						    mincueeenta.push(FormatValue(a[p].mincueeenta));//最小A相电流
						    mincueeentatime.push(dateFormat(a[p].mincueeentatime));//最小A相电流发生时间
						    mincueeentb.push(FormatValue(a[p].mincueeentb));//最小B相电流
						    mincueeentbtime.push(dateFormat(a[p].mincueeentbtime));//最小B相电流发生时间
						    mincueeentc.push(FormatValue(a[p].mincueeentc));//最小C相电流
						    mincueeentctime.push(dateFormat(a[p].mincueeentctime));//最小C相电流发生时间
						    minresidualcurrent.push(FormatValue(a[p].minresidualcurrent));//最小剩余电流
						    minresidualcurrenttime.push(dateFormat(a[p].minresidualcurrenttime));//最小剩余电流发生时间
						}
						
						if(checkbox.indexOf("5")!=-1){
							$("#elecday5").show();
							//功率
							maxpower.push(FormatValue(a[p].maxpower));//最大总功率
							maxpowertime.push(dateFormat(a[p].maxpowertime));//最大总功率发生时间
							maxpowera.push(FormatValue(a[p].maxpowera));//最大A相功率
							maxpoweratime.push(dateFormat(a[p].maxpoweratime));//最大A相功率发生时间
							maxpowerb.push(FormatValue(a[p].maxpowerb));//最大B相功率
							maxpowerbtime.push(dateFormat(a[p].maxpowerbtime));//最大B相功率发生时间
							maxpowerc.push(FormatValue(a[p].maxpowerc));//最大C相功率
							maxpowerctime.push(dateFormat(a[p].maxpowerctime));//最大C相功率发生时间
						    minpower.push(FormatValue(a[p].minpower));//最小总功率
						    minpowertime.push(dateFormat(a[p].minpowertime));//最小总功率发生时间
						    minpowera.push(FormatValue(a[p].minpowera));//最小A相功率
						    minpoweratime.push(dateFormat(a[p].minpoweratime));//最小A相功率发生时间
						    minpowerb.push(FormatValue(a[p].minpowerb));//最小B相功率
						    minpowerbtime.push(dateFormat(a[p].minpowerbtime));//最小B相功率发生时间
						    minpowerc.push(FormatValue(a[p].minpowerc));//最小C相功率 
						    minpowerctime.push(dateFormat(a[p].minpowerctime));//最小C相功率发生时间
						}
						
						if(checkbox.indexOf("6")!=-1){
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
						}
						
						if(checkbox.indexOf("7")!=-1){
							$("#elecday7").show();
							//温度
							maxtempa.push(FormatValue(a[p].maxtempa));//最大A相温度 
							maxtempatime.push(dateFormat(a[p].maxtempatime));//最大A相温度发生时间
							maxtempb.push(FormatValue(a[p].maxtempb));//最大B相温度
							maxtempbtime.push(dateFormat(a[p].maxtempbtime));//最大B相温度发生时间
							maxtempc.push(FormatValue(a[p].maxtempc));//最大C相温度
							maxtempctime.push(dateFormat(a[p].maxtempctime));//最大C相温度发生时间
							maxtempn.push(FormatValue(a[p].maxtempn));//最大N相温度
							maxtempntime.push(dateFormat(a[p].maxtempntime));//最大N相温度发生时间
						    mintempa.push(FormatValue(a[p].mintempa));//最小A相温度
						    mintempatime.push(dateFormat(a[p].mintempatime));//最小A相温度发生时间
						    mintempb.push(FormatValue(a[p].mintempb));//最小B相温度
						    mintempbtime.push(dateFormat(a[p].mintempbtime));//最小B相温度发生时间
						    mintempc.push(FormatValue(a[p].mintempc));//最小C相温度
						    mintempctime.push(dateFormat(a[p].mintempctime));//最小C相温度发生时间
						    mintempn.push(FormatValue(a[p].mintempn));//最小N相温度
						    mintempntime.push(dateFormat(a[p].mintempntime));//最小N相温度发生时间
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
				
			myChart8.clear();
			myChart9.clear();
			myChart10.clear();
			myChart11.clear();
			myChart12.clear();
			myChart13.clear();
		}
		
		//多路
		function makeMulCurve(checkbox,result){
			var a = JSON.parse(result);
			if (a.length > 0) {
				hideAllElec();
				
				freezetime = [];//时间
				//4电流
				onemaxcue = [], onemaxcuetime = [], onemincue = [], onemincuetime = [];
				twomaxcue = [], twomaxcuetime = [], twomincue = [], twomincuetime = [];
				threemaxcue = [], threemaxcuetime = [], threemincue = [], threemincuetime = [];
				fourmaxcue = [], fourmaxcuetime = [], fourmincue = [], fourmincuetime = [];
				fivemaxcue = [], fivemaxcuetime = [], fivemincue = [], fivemincuetime = [];
				sixmaxcue = [], sixmaxcuetime = [], sixmincue = [], sixmincuetime = [];
				sevenmaxcue = [], sevenmaxcuetime = [], sevenmincue = [], sevenmincuetime = [];
				eightmaxcue = [], eightmaxcuetime = [], eightmincue = [], eightmincuetime = [];
				//7温度
				onemaxtemp = [], onemaxtemptime = [], onemintemp = [], onemintemptime = [];
				twomaxtemp = [], twomaxtemptime = [], twomintemp = [], twomintemptime = [];
				threemaxtemp = [], threemaxtemptime = [], threemintemp = [], threemintemptime = [];
				fourmaxtemp = [], fourmaxtemptime = [], fourmintemp = [], fourmintemptime = [];
				fivemaxtemp = [], fivemaxtemptime = [], fivemintemp = [], fivemintemptime = [];
				sixmaxtemp = [], sixmaxtemptime = [], sixmintemp = [], sixmintemptime = [];
				sevenmaxtemp = [], sevenmaxtemptime = [], sevenmintemp = [], sevenmintemptime = [];
				eightmaxtemp = [], eightmaxtemptime = [], eightmintemp = [], eightmintemptime = [];

				for ( var p in a) {
					if (typeof a[p].freezetime!="undefined"){
						var d = new Date(a[p].freezetime);//实时冻结数据-时间只到日
						freezetime.push(Format(d,"yyyy-MM-dd"));//冻结时间
						
						var mul_value;
						if(checkbox.indexOf("4")!=-1){
							$("#elecday4").show();
							$("#elecday7").show();
							//电流
							mul_value = MulFormatValue(a[p].onecue);
							onemaxcue.push(MulValue(mul_value[0]));
							onemaxcuetime.push(dateFormat(mul_value[1])); 
							onemincue.push(MulValue(mul_value[2]));
							onemincuetime.push(dateFormat(mul_value[3]));
							
							mul_value = MulFormatValue(a[p].twocue);
							twomaxcue.push(MulValue(mul_value[0]));
							twomaxcuetime.push(dateFormat(mul_value[1])); 
							twomincue.push(MulValue(mul_value[2]));
							twomincuetime.push(dateFormat(mul_value[3]));
							
							mul_value = MulFormatValue(a[p].threecue);
							threemaxcue.push(MulValue(mul_value[0]));
							threemaxcuetime.push(dateFormat(mul_value[1])); 
							threemincue.push(MulValue(mul_value[2]));
							threemincuetime.push(dateFormat(mul_value[3]));
							
							mul_value = MulFormatValue(a[p].fourcue);
							fourmaxcue.push(MulValue(mul_value[0]));
							fourmaxcuetime.push(dateFormat(mul_value[1])); 
							fourmincue.push(MulValue(mul_value[2]));
							fourmincuetime.push(dateFormat(mul_value[3]));
							
							mul_value = MulFormatValue(a[p].fivecue);
							fivemaxcue.push(MulValue(mul_value[0]));
							fivemaxcuetime.push(dateFormat(mul_value[1])); 
							fivemincue.push(MulValue(mul_value[2]));
							fivemincuetime.push(dateFormat(mul_value[3]));
							
							mul_value = MulFormatValue(a[p].sixcue);
							sixmaxcue.push(MulValue(mul_value[0]));
							sixmaxcuetime.push(dateFormat(mul_value[1])); 
							sixmincue.push(MulValue(mul_value[2]));
							sixmincuetime.push(dateFormat(mul_value[3]));
							
							mul_value = MulFormatValue(a[p].sevencue);
							sevenmaxcue.push(MulValue(mul_value[0]));
							sevenmaxcuetime.push(dateFormat(mul_value[1])); 
							sevenmincue.push(MulValue(mul_value[2]));
							sevenmincuetime.push(dateFormat(mul_value[3]));
							
							mul_value = MulFormatValue(a[p].eightcue);
							eightmaxcue.push(MulValue(mul_value[0]));
							eightmaxcuetime.push(dateFormat(mul_value[1])); 
							eightmincue.push(MulValue(mul_value[2]));
							eightmincuetime.push(dateFormat(mul_value[3]));
						}
						
						if(checkbox.indexOf("7")!=-1){
							$("#elecday3").show();
							$("#elecday6").show();
							//温度
							mul_value = MulFormatValue(a[p].onetemp);
							onemaxtemp.push(MulValue(mul_value[0]));
							onemaxtemptime.push(dateFormat(mul_value[1])); 
							onemintemp.push(MulValue(mul_value[2]));
							onemintemptime.push(dateFormat(mul_value[3]));
							
							mul_value = MulFormatValue(a[p].twotemp);
							twomaxtemp.push(MulValue(mul_value[0]));
							twomaxtemptime.push(dateFormat(mul_value[1])); 
							twomintemp.push(MulValue(mul_value[2]));
							twomintemptime.push(dateFormat(mul_value[3]));
							
							mul_value = MulFormatValue(a[p].threetemp);
							threemaxtemp.push(MulValue(mul_value[0]));
							threemaxtemptime.push(dateFormat(mul_value[1])); 
							threemintemp.push(MulValue(mul_value[2]));
							threemintemptime.push(dateFormat(mul_value[3]));
							
							mul_value = MulFormatValue(a[p].fourtemp);
							fourmaxtemp.push(MulValue(mul_value[0]));
							fourmaxtemptime.push(dateFormat(mul_value[1])); 
							fourmintemp.push(MulValue(mul_value[2]));
							fourmintemptime.push(dateFormat(mul_value[3]));
							
							mul_value = MulFormatValue(a[p].fivetemp);
							fivemaxtemp.push(MulValue(mul_value[0]));
							fivemaxtemptime.push(dateFormat(mul_value[1])); 
							fivemintemp.push(MulValue(mul_value[2]));
							fivemintemptime.push(dateFormat(mul_value[3]));
							
							mul_value = MulFormatValue(a[p].sixtemp);
							sixmaxtemp.push(MulValue(mul_value[0]));
							sixmaxtemptime.push(dateFormat(mul_value[1])); 
							sixmintemp.push(MulValue(mul_value[2]));
							sixmintemptime.push(dateFormat(mul_value[3]));
							
							mul_value = MulFormatValue(a[p].seventemp);
							sevenmaxtemp.push(MulValue(mul_value[0]));
							sevenmaxtemptime.push(dateFormat(mul_value[1])); 
							sevenmintemp.push(MulValue(mul_value[2]));
							sevenmintemptime.push(dateFormat(mul_value[3]));
							
							mul_value = MulFormatValue(a[p].eighttemp);
							eightmaxtemp.push(MulValue(mul_value[0]));
							eightmaxtemptime.push(dateFormat(mul_value[1])); 
							eightmintemp.push(MulValue(mul_value[2]));
							eightmintemptime.push(dateFormat(mul_value[3]));
						}
					}
				}

				makeDayCurveMul();
			}
			else{
				$.messager.alert("提示",  "未查询到该电气设备的冻结数据。", "warning");
				hideAllElec();
			} //if (a.length > 0)
				
			myChart8.clear();
			myChart9.clear();
			myChart10.clear();
			myChart11.clear();
			myChart12.clear();
			myChart13.clear();
		}
		
		function dateFormat(data){
			if(null!=data && data!="undefined"){
				var d = new Date(data);//实时冻结数据-时间只到日
				time=Format(d,"yyyy-MM-dd HH:mm:ss");//冻结时间
				return time; 
			}
			return "";
		}

		$.fn.datebox.defaults.formatter = function(date){
			var y = date.getFullYear();
			var m = date.getMonth()+1;
			var d = date.getDate();
			return y+'-'+m+'-'+d;
		}
	</script>
</body>
</html>