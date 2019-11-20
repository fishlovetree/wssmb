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
				<input type="checkbox" value="2" id="elecr" name="daycbk" onclick="getCurveData()" /><span class="cbktext">反向电量&nbsp;</span>			
			<!-- <input type="checkbox" value="0" id="error" name="daycbk" onclick="getCurveData()"/><span class="cbktext">误差&nbsp;</span> -->	&nbsp;&nbsp;&nbsp;
				
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
			<!-- 	<div id="elecday10" style="height: 250px;margin:auto;display:none;"></div> -->
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

		var positiveelectricity = [], positiveelectricityfreezetime = [];//正向电量
		var reverseelectricity = [], reverseelectricityfreezetime = [];//反向电量
		var voltage = [],voltagefreezetime = [];	//电压   
	    var maxcueeent = [],electricityfreezetime = [];//电流
	    var powera = [], powertime = [], powerb = [];//功率
	    var pfa = [], pftime = [],pfb = [];//功率因数
	    var tempa = [], temptime = [], tempb = [], tempc = [], tempzero = [];//电表温度
	    var freezetime = [];	  	    
		var error = [];
		var elecday = document.getElementById('elecday');
		var elecday2 = document.getElementById('elecday2');
		var elecday3 = document.getElementById('elecday3');
		var elecday4 = document.getElementById('elecday4');
		var elecday5 = document.getElementById('elecday5');
		var elecday6 = document.getElementById('elecday6');
		var elecday7 = document.getElementById('elecday7');
	//	var elecday10 = document.getElementById('elecday10');
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
	//	var myChart10 = echarts.init(elecday10,'DarkGray'); // 初始化 
		var myChart11 = echarts.init(day8,'DarkGray'); // 初始化 
		var myChart12 = echarts.init(day9,'DarkGray'); // 初始化
		var myChart13 = echarts.init(day10,'DarkGray'); // 初始化
		var myChart14 = echarts.init(day11,'DarkGray'); // 初始化
		var myChart15 = echarts.init(day12,'DarkGray'); // 初始化 
		var myChart16 = echarts.init(day13,'DarkGray'); // 初始化

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
	//		elecday10.style.width = width+'px';
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
	//		$('#elecday10').width(width);
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
//			myChart10.resize();
			myChart11.resize();
			myChart12.resize();
			myChart13.resize();
			myChart14.resize();
			myChart15.resize();
			myChart16.resize();
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
			
			if (node.type == 5||node.type==6) {
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
				var type=node.type
				var dayurl = "${pageContext.request.contextPath}/sysMonitor/daydata?Math.random()";
				$ .ajax({   type : "POST",
							url : dayurl,
							data : {
								"equipmentid" : gid,
								"startdate" : startdate,
								"enddate" : enddate,
								"checkbox" : checkbox,
								"type" :type
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
					            
					            var threshold=1;
								var array = parseThreshold(1,threshold);

							//	subType = d.subType;
					           
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
	//		myChart10.clear();
			$("#elecday").hide();
			$("#elecday2").hide();
			$("#elecday3").hide();
			$("#elecday4").hide();
			$("#elecday5").hide();
			$("#elecday6").hide();
			$("#elecday7").hide();
			$("#elecday10").hide();
		}
		
		function makeElecCurve(checkbox,d,array){
			var a = JSON.parse(d);
			if (a !=null) {
				
				hideAllElec();
				
				positiveelectricity = [], positiveelectricityfreezetime = [];//正向电量
				reverseelectricity = [], reverseelectricityfreezetime = [];//反向电量
				voltage = [],voltagefreezetime = [];//电压
				maxcueeent = [],electricityfreezetime = [];//电流
				powera = [], powertime = [], powerb = [];//功率
				pfa = [], pftime = [],pfb = [];
			    tempa = [], temptime = [], tempb = [], tempc = [], tempzero = [];//电表温度
			    freezetime = [];
				error = [];
				for ( var p in a) {
					//alert(a[p].freezetime);
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
									voltage.push(FormatValue(a[p].data));//电压									
									voltagefreezetime.push(Format(d,"yyyy-MM-dd"));//冻结时间
								}							
							}
						}
						
						if(checkbox.indexOf("4")!=-1){
							$("#elecday4").show(); 
							if(a[p].oi=='2001'){ //电流	
								if(a[p].groupIndex=='1'){
									maxcueeent.push(FormatValue(a[p].data));//A相电流									
									electricityfreezetime.push(Format(d,"yyyy-MM-dd"));//冻结时间
								}							
							}
						}
						
						if(checkbox.indexOf("5")!=-1){
							$("#elecday5").show();
							//功率
							if(a[p].oi=='2004'){ 
								if(a[p].groupIndex=='1'){
									powera.push(FormatValue(a[p].data));							
									powertime.push(Format(d,"yyyy-MM-dd"));//冻结时间
								}
								if(a[p].groupIndex=='2'){
									powerb.push(FormatValue(a[p].data));
								}								
							}							
						}
						
						if(checkbox.indexOf("6")!=-1){
							$("#elecday6").show();
							//功率因数
							if(a[p].oi=='200A'){ 
								if(a[p].groupIndex=='1'){
									pfa.push(FormatValue(a[p].data));							
									pftime.push(Format(d,"yyyy-MM-dd"));//冻结时间
								}
								if(a[p].groupIndex=='2'){
									pfb.push(FormatValue(a[p].data));
								}								
							}							
						}
						
						if(checkbox.indexOf("7")!=-1){
							$("#elecday7").show();
							//温度
							if(a[p].oi=='2010'){ 
								if(a[p].groupIndex=='1'){
									tempa.push(FormatValue(a[p].data));//A相温度 									
									temptime.push(Format(d,"yyyy-MM-dd"));//冻结时间
								}
								if(a[p].groupIndex=='2'){
									tempb.push(FormatValue(a[p].data));//B相温度
								}
								if(a[p].groupIndex=='3'){
									tempc.push(FormatValue(a[p].data));//C相温度
								}
								if(a[p].groupIndex=='4'){
									tempzero.push(FormatValue(a[p].data));//零线温度
								}
							}				
						}										
						
					}
				}
		
				//if(powermode == 3)
					makeAmmeterDayCurveThree(array);
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

		$.fn.datebox.defaults.formatter = function(date){
			var y = date.getFullYear();
			var m = date.getMonth()+1;
			var d = date.getDate();
			return y+'-'+m+'-'+d;
		}
	</script>
</body>
</html>