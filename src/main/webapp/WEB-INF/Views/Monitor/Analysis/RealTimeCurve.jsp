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
<jsp:include page="../../Header.jsp"/>
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

.table-data-table{
	font-size:12px; 
	table-layout:fixed; 
	empty-cells:show; 
	border-collapse: collapse; 
	margin:0 auto; 
	border:1px solid #cad9ea; 
    color:#666; 
    width:80%;
} 
.table-data-table th { 
	background-repeat:repeat-x; 
} 
.echarts-dataview{
	background-color: rgb(248, 248, 248) !important;
}
.cbktext{
	vertical-align: middle;
	margin:0 5px 0 5px;
}
	.layout-split-west {
	    border-right: 1px solid #ccc;
	}
	
#south .panel-body {
    background-color: #f3f3f3 !important;
}

.searchable-select {
	width: 182px;
}
.searchable-select-holder, .searchable-select-item, .searchable-select-item .selected{
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
}
#left-table span.textbox.combo{
	height: 28px !important;
    border-right: 0px;
}
</style>
</head>
<body>
	<div id="realtimePanel" class="easyui-layout" style="width:100%;height: 100%;">
       	<div data-options="region:'north'" style="padding: 1px 0 1px 10px; border: 0px;">
			<p style="height:3px;"></p>
			<input type="hidden" id="selectedID" />  
       		<span>设备：</span>
       		<input type="text" id='snode' class="easyui-textbox" readonly="readonly" style="width: 180px;height: 28px;" />
			<span>日期：</span>
			<input type="text" id='date' class="easyui-datebox" editable="fasle" style="width: 180px;height: 28px;" />
			<a href="#" class="easyui-linkbutton linkbutton" id="search" onclick="searchdata()">搜索</a>
			<br/>
			<p style="height:3px;"></p>
			<span>曲线类型：</span>
			<input type="checkbox" value="4" id="cueeent" name="real" checked="checked" onclick="getCurveData()" /><span class="cbktext">电流&nbsp;</span>
			<input type="checkbox" value="7" id="temperature" name="real" checked="checked" onclick="getCurveData()" /><span class="cbktext">温度&nbsp;</span>
			<input type="checkbox" value="3" id="voltage" name="real" onclick="getCurveData()" /><span class="cbktext">电压&nbsp;</span>
			<input type="checkbox" value="6" id="pf" name="real" onclick="getCurveData()" /><span class="cbktext">功率因数&nbsp;</span>
			<input type="checkbox" value="5" id="power" name="real" onclick="getCurveData()" /><span class="cbktext">功率&nbsp;</span>
			<input type="checkbox" value="1" id="elecp" name="real" onclick="getCurveData()"/><span class="cbktext">正向电量&nbsp;</span>
			<input type="checkbox" value="2" id="elecr" name="real" onclick="getCurveData()" /><span class="cbktext">反向电量&nbsp;</span>
			<input type="checkbox" value="8" id="other" name="real" onclick="getCurveData()" /><span class="cbktext">频率&nbsp;</span>&nbsp;&nbsp;&nbsp;
			
			<a href="#" class="easyui-linkbutton linkbutton" id="checkall">全选</a>
			<a href="#" class="easyui-linkbutton linkbutton" id="uncheckall">全不选</a>
			<a href="#" class="easyui-linkbutton linkbutton" id="anti_check">反选</a>
			<p style="height:3px;"></p>
       	</div>
       	<div id="south" data-options="region:'center',split:false" style="border-top: 2px solid #666666;">
			<div id="curve" class="easyui-panel" style="min-width:850px;height:atuo;border:0px;">
				<div id="time4" style="height: 250px;margin:auto;display: none;"></div>
				<div id="time7" style="height: 250px;margin:auto;display: none;"></div>
				<div id="time3" style="height: 250px;margin:auto;display: none;"></div>
				<div id="time6" style="height: 250px;margin:auto;display: none;"></div>
				<div id="time5" style="height: 250px;margin:auto;display: none;"></div>
				<div id="time" style="height: 250px;margin:auto;display: none;"></div>
				<div id="time2" style="height: 250px;margin:auto;display: none;"></div>
				<div id="time8" style="height: 250px;margin:auto;display: none;"></div>
			</div>
       	</div>
    </div>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/js/echarts/echarts.js"></script>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/js/echarts/DarkGray_Back.js"></script>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/js/makeCurve.js"></script>
	<script type="text/javascript">
		var isEmpty=false;

		var time4 = document.getElementById('time4');
		var time7 = document.getElementById('time7');
		var time3 = document.getElementById('time3');
		var time6 = document.getElementById('time6');
		var time5 = document.getElementById('time5');
		var time = document.getElementById('time');
		var time2 = document.getElementById('time2');
		var time8 = document.getElementById('time8');

		var myChart4 = echarts.init(time4,'DarkGray_Back'); // 初始化
		var myChart7 = echarts.init(time7,'DarkGray_Back'); // 初始化
		var myChart3 = echarts.init(time3,'DarkGray_Back'); // 初始化
		var myChart6 = echarts.init(time6,'DarkGray_Back'); // 初始化
		var myChart5 = echarts.init(time5,'DarkGray_Back'); // 初始化
		var myChart = echarts.init(time,'DarkGray_Back'); // 初始化
		var myChart2 = echarts.init(time2,'DarkGray_Back'); // 初始化
		var myChart8 = echarts.init(time8,'DarkGray_Back'); // 初始化

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
			
			$('#time').width(width);
			$('#time2').width(width);
			$('#time3').width(width);
			$('#time4').width(width);
			$('#time5').width(width);
			$('#time6').width(width);
			$('#time7').width(width);
			$('#time8').width(width);
			
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
		};
		var node;
		var pnode;
		var ppnode;
		$(function() {
			node = parent.node;
			pnode = parent.p_node;
			ppnode = parent.pp_node;
			setInterval(function(){
				if(isEmpty==false && $("#date").datebox('getValue') == Format(now,'yyyy-MM-dd')){
					getCurveData();
				}
			}, 30*10000);    // 如果有数据则5分钟刷新一次
			
			//全选 
			$("#checkall").click(function(){ 
				$("input[name='real']").prop("checked","checked"); 
				getCurveData();
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
		});

		function hideAllElec(){
			myChart.clear();
			myChart2.clear();
			myChart3.clear();
			myChart4.clear();
			myChart5.clear();
			myChart6.clear();
			myChart7.clear();
			myChart8.clear();
			$("#time").hide();
			$("#time2").hide();
			$("#time3").hide();
			$("#time4").hide();
			$("#time5").hide();
			$("#time6").hide();
			$("#time7").hide();
			$("#time8").hide();
		}
		
		function searchFile() {
			if ((node.type == commonTreeNodeType.terminalDevice 
					|| node.type == commonTreeNodeType.gprsDevice)
					&& pnode.gid == "10") {

				$("#snode").textbox('setValue', node.text);
		        $("#selectedID").val(node.gid);
                
				getCurveData();
			} else {
				$("#snode").textbox('setValue', "");
		        $("#selectedID").val("");
			}
		}

		var freezetime = [], readtime = [], insertiontime = [];//时间
		var positiveelectricity = [], positiveelectricitya = [], positiveelectricityb = [], positiveelectricityc = [];//正向电量
		var reverseelectricity = [], reverseelectricitya = [], reverseelectricityb = [], reverseelectricityc = [];//反向电量
		var voltagea = [], voltageb = [], voltagec = [];//电压
		var cueeenta = [], cueeentb = [], cueeentc = [], residualcueeent = [];//电流
		var power = [], powera = [], powerb = [], powerc = [];//功率
		var pf = [], pfa = [], pfb = [], pfc = [];//功率因数
		var temperaturea = [], temperatureb = [], temperaturec = [], temperaturen = [];//温度
		var frequency = [], internalbatteryvoltage = [], externalbatteryvoltage = [];//其他
		
		function getCurveData() {
			var date = $("#date").datebox('getValue');
			var dateFormat = new Date(date);
			var strdate=dateFormat.toLocaleDateString();
			if(null==date || date==""){
				strdate=now.toLocaleDateString();
				$("#date").datebox('setValue',strdate);
			}
			
			var startdate="",enddate="";
			startdate=strdate+" 00:00:00";
			enddate=strdate+" 23:59:59";
			
			anchor = [
		  		{name : startdate, value:[startdate, '']},
		  		{name : enddate, value:[enddate, '']}
		  	];

			var name=$("#snode").textbox('getValue');
			var param="";
			var selectedID=$("#selectedID").val();
			if (selectedID != "") {
				
				var id_array=new Array();  
				$('input[name="real"]:checked').each(function(){  
				    id_array.push($(this).val());//向数组中添加元素  
				});  
				var checkbox=id_array.join(',');//将数组元素连接起来以构建一个字符串  
				if(checkbox==""){ hideAllElec(); return;}
				
				var realtimeurl = "${pageContext.request.contextPath}/frontSysMonitor/realtimedata?Math.random()";
				$ .ajax({   type : "POST",
							data : {
								"equipmentid" : selectedID,
								"startdate" : startdate,
								"enddate" : enddate,
								"checkbox" : checkbox
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
					            
								if(d.result!="error"){
									isEmpty=false;
									
									var threshold=d.threshold;
									//var powermode = d.powermode;

									var a = JSON.parse(d.result);;
									if (a.length > 0) {
										hideAllElec();
										
										freezetime = [], readtime = [], insertiontime = [];//时间
										positiveelectricity = [], positiveelectricitya = [], positiveelectricityb = [], positiveelectricityc = [];//正向电量
										reverseelectricity = [], reverseelectricitya = [], reverseelectricityb = [], reverseelectricityc = [];//反向电量
										voltagea = [], voltageb = [], voltagec = [];//电压
										cueeenta = [], cueeentb = [], cueeentc = [], residualcueeent = [];//电流
										power = [], powera = [], powerb = [], powerc = [];//功率
										pf = [], pfa = [], pfb = [], pfc = [];//功率因数
										temperaturea = [], temperatureb = [], temperaturec = [], temperaturen = [];//温度
										frequency = [], internalbatteryvoltage = [], externalbatteryvoltage = [];//其他

										for ( var p in a) {
											if (typeof a[p].freezetime!="undefined"){
												var d = new Date(a[p].freezetime);//实时冻结数据-时间只到分	
												var formatedate = Format(d,"yyyy-MM-dd HH:mm:ss");
												//freezetime.push(formatedate);//冻结时间
												if(checkbox.indexOf("4")!=-1){
													$("#time4").show();
													//电流
													cueeenta.push([formatedate,FormatValue(a[p].cueeenta)]);//A相电流
													cueeentb.push([formatedate,FormatValue(a[p].cueeentb)]);//B相电流
													cueeentc.push([formatedate,FormatValue(a[p].cueeentc)]);//C相电流
													residualcueeent.push([formatedate,FormatValue(a[p].residualcueeent)]);//剩余电流
												}
												
												if(checkbox.indexOf("7")!=-1){
													$("#time7").show();
													//温度
													temperaturea.push([formatedate,FormatValue(a[p].temperaturea)]);//A相温度
													temperatureb.push([formatedate,FormatValue(a[p].temperatureb)]);//B相温度
													temperaturec.push([formatedate,FormatValue(a[p].temperaturec)]);//C相温度
													temperaturen.push([formatedate,FormatValue(a[p].temperaturen)]);//N相温度
												}
												
												if(checkbox.indexOf("3")!=-1){
													$("#time3").show();
													//电压
													voltagea.push([formatedate,FormatValue(a[p].voltagea)]);//A相电压
													voltageb.push([formatedate,FormatValue(a[p].voltageb)]);//B相电压
													voltagec.push([formatedate,FormatValue(a[p].voltagec)]);//C相电压
												}
												
												if(checkbox.indexOf("6")!=-1){
													$("#time6").show();
													//功率因数
													pf.push([formatedate,FormatValue(a[p].pf)]);//总功率因数
													pfa.push([formatedate,FormatValue(a[p].pfa)]);//A相功率因数
													pfb.push([formatedate,FormatValue(a[p].pfb)]);//B相功率因数
													pfc.push([formatedate,FormatValue(a[p].pfc)]);//C相功率因数
												}
												
												if(checkbox.indexOf("5")!=-1){
													$("#time5").show();
													//功率
													power.push([formatedate,FormatValue(a[p].power)]);//总功率
													powera.push([formatedate,FormatValue(a[p].powera)]);//A相功率
													powerb.push([formatedate,FormatValue(a[p].powerb)]);//B相功率
													powerc.push([formatedate,FormatValue(a[p].powerc)]);//C相功率
												}
											
												if(checkbox.indexOf("1")!=-1){
													$("#time").show();
													//正向电量
													positiveelectricity.push([formatedate,FormatValue(a[p].positiveelectricity)]);//正向总电量
													positiveelectricitya.push([formatedate,FormatValue(a[p].positiveelectricitya)]);//正向A相电量
													positiveelectricityb.push([formatedate,FormatValue(a[p].positiveelectricityb)]);//正向B相电量
													positiveelectricityc.push([formatedate,FormatValue(a[p].positiveelectricityc)]);//正向C相电量
												}
												
												if(checkbox.indexOf("2")!=-1){
													$("#time2").show();
													//反向电量
													reverseelectricity.push([formatedate,FormatValue(a[p].reverseelectricity)]);//反向总电量
													reverseelectricitya.push([formatedate,FormatValue(a[p].reverseelectricitya)]);//反向A相电量
													reverseelectricityb.push([formatedate,FormatValue(a[p].reverseelectricityb)]);//反向B相电量
													reverseelectricityc.push([formatedate,FormatValue(a[p].reverseelectricityc)]);//反向C相电量
												}
												
												if(checkbox.indexOf("8")!=-1){
													$("#time8").show();
													//其他
													frequency.push([formatedate,FormatValue(a[p].frequency)]);//频率
													internalbatteryvoltage.push([formatedate,FormatValue(a[p].internalbatteryvoltage)]);//内部电池电压
													externalbatteryvoltage.push([formatedate,FormatValue(a[p].externalbatteryvoltage)]);//外部电池电压
												}
											}
										}
	
										var array = parseThreshold("10",threshold);
										//if(powermode == 3)
											makeRealCurveThree(array);
										//else
											//makeRealCurveSingle(array);
									}
									else{
										isEmpty=true;
										$.messager.alert("提示",  name+":未查询到该设备的实时冻结数据。", "warning");
										hideAllElec();
									} //if (a.length > 0)
								}
								else{
									$.messager.alert("提示",  "只能查看电气火灾监控系统的实时曲线。", "warning");
									$("#selectedID").val("");
									hideAllElec();
								}//if(d=="error1")
							}//success
						}); //ajax
			}
		} // getCurveData()

		function searchdata(){
			var selectedID=$("#selectedID").val();
			
			if(selectedID != ""){
				getCurveData();
			}
			else{
				$.messager.alert("提示",  "请选择设备。", "warning");
			}
		}
	</script>
</body>
</html>