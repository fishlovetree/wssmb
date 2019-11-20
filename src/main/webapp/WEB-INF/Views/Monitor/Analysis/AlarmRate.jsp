<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
    <%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>告警率</title>
<jsp:include page="../../Header.jsp"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/parseAlarm.js"></script>
<style type="text/css">
#organizationtree, #regiontree {
	border-color: transparent;
}
.tableTr{
    display:block; /*将tr设置为块体元素*/
    margin:10px 0;  /*设置tr间距为2px*/
}
.mydiv { 
	float : left;
}
.tabs-header{
	border:0;
}

.table-data-table{
	font-size: 13px;
    table-layout: fixed;
    empty-cells: show;
    border-collapse: collapse;
    margin: 0 auto;
    border: 1px solid #cad9ea;
    color: #666;
    width: 90%;
} 

.table-data-table th { 
	background-repeat:repeat-x; 
} 

.table-data-table td,.table-data-table th{ 
	border:1px solid #666; 
	padding:0 1em 0; 
} 
	.layout-split-west {
	    border-right: 1px solid #ccc;
	}
</style>
</head>
<body>
<input type="hidden" id="selectedID" /> 
<input type="hidden" id="selectedType" /> 
<input type="hidden" id="selectedName" /> 
<input type="hidden" id="selectedParentid" value="0" />
<div class="easyui-tabs " id="tab" style="width:100%;height:100%" data-options="tabPosition:'top'">
	<input type="hidden" id="selectedParentid" value="0" />
    <div title="告警统计" id="0">
      	<div id="p" class="easyui-panel" data-options="fit:true">
			<div class="easyui-layout" data-options="fit:true">
				<div id="wwn" data-options="region:'north',split:true" style="width:100%;height:44px">	
					<div style="margin-left: 5px;margin-top: 5px">
						<c:set var="now" value="<%=new java.util.Date()%>" />
						<fmt:formatDate pattern="yyyy" value="${now}" var="parsedEmpDate"/>
						<select class="easyui-combobox" id="yearChoose"  style="width:168px;height:30px;" data-options="label:'选择年份'">           		 			
			       			<c:forEach var="i" begin="1" end="8">
								<option value="${parsedEmpDate-6+i}">${parsedEmpDate-6+i}</option>
							</c:forEach>
			       		</select>
						<select class="easyui-combobox" id="monthChoose" style="width:180px;height:30px;" data-options="label:'选择月份'">
			       			<option value="">选择月份</option>
			       			<c:forEach var="i" begin="1" end="12">
								<option value="${i}">${i}</option>
						    </c:forEach>
			       		</select>
			       		<select class="easyui-combobox" id="dayChoose" style="width:180px;height:30px;" data-options="label:'选择日期'">
			       			<option value="">选择日期</option>
			       			<c:forEach var="i" begin="1" end="31">
								<option value="${i}">${i}</option>
						    </c:forEach>
			       		</select>
			       		<select class="easyui-combobox" id="hourChoose" style="width:180px;height:30px;" data-options="label:'选择时辰'">
			       			<option value="">选择时辰</option>
			       			<c:forEach var="i" begin="0" end="23">
								<option value="${i}">${i}</option>
						    </c:forEach>
			       		</select>
			       		<a href="javascript:void(0)" class="easyui-linkbutton button-default"  onclick="loadAlarmRate()" title="Search">确定</a>
			       		<a href="javascript:void(0)" class="easyui-linkbutton button-default"  onclick="reset()" title="Reset">重置</a>
					</div>
				</div>
				<!-- 告警统计饼图和柱形图-->
				<div id="www" data-options="region:'center'" style="width:100%;height: 100%" href="">
					<div id="statistics" style="height:300px;margin:auto;padding-top: 20px;padding-left: 10px;"></div>
				</div>
			</div>
		</div>      
    </div>
	<div title="告警同期对比" id="1"> 
      	<div id="p" class="easyui-panel" data-options="fit:true">
			<div class="easyui-layout" data-options="fit:true">
				<div id="wwn" data-options="region:'north',split:true" style="width:100%;height:44px">	
				  <div style="margin-left: 5px;margin-top: 5px">
					<select class="easyui-combobox" id="dateType" editable="false" style="width:180px;height:30px;" data-options="label:'选择对比类型'">
           				<option value="1" selected="selected">月份</option>
           				<option value="2">年份</option>
      		 			</select>
      		 			<select class="easyui-combobox" id="equalNumber" editable="false" style="width:150px;height:30px;" data-options="label:'选择对比数'">
			       		<option value="">选择</option>
			       			<c:forEach var="i" begin="1" end="4">
								<option value="${i}">${i}</option>
						    </c:forEach>
						<option value="5" selected="selected">5</option>
			       	</select>
      		 			<a href="javascript:void(0)" class="easyui-linkbutton button-default"  onclick="loadCompared()" title="Search">确定</a>
				  </div>
				</div>
				<!-- 柱形图 -->
				<div id="wwe" data-options="region:'center'" style="width:50%;height: 100%" href="">
					<div id="compared" style="height:300px;margin:auto;padding-top: 20px;padding-left: 10px;padding-left: 10px;"></div>
				</div>
			</div>
		</div>
	</div>
</div>	

<!-- 终端列表弹出框 -->
<div id="statisticsdlg" class="easyui-dialog" style="width:800px;height:480px;" closable="false" closed="true" buttons="#statisticsdlg-buttons"
    data-options="">
	<table id="statisticsdg" ></table>
</div>
<div id="statisticsdlg-buttons">
	<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#statisticsdg').datagrid('loadData', { total: 0, rows: [] }); $('#statisticsdlg').dialog('close');">关闭</a>
</div>
<div id="w" class="easyui-window" closed="true" style="width:380px;height:250px;padding:10px;" data-options="modal:true">
	<div id="dataDetail" align="center">
	</div>
</div>

</body>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/echarts/echarts.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/echarts/DarkGray_Back.js"></script>
<script type="text/javascript">
var statistics = document.getElementById('statistics');
var statisticsChart = echarts.init(statistics,'DarkGray_Back');

var compared = document.getElementById('compared');
var comparedChart = echarts.init(compared,'DarkGray_Back');
//用于使chart自适应高度和宽度,通过窗体高宽计算容器高宽
var resizeDiv = function () {
	var width=$('#tab').width()-22;
	var height=$('#tab').height()-150;
	if(width<845)
		width=845;
	
	statistics.style.width = width+'px';
	statistics.style.height = height+'px';
	$('#statisticsChart').width(width);
	$('#statisticsChart').height(height);
	
	compared.style.width = width+'px';
	compared.style.height = height+'px';
	$('#comparedChart').width(width);
	$('#comparedChart').height(height);
	
	$('.zr-element').width(width);
	
	statisticsChart.resize();
	comparedChart.resize();
};
var tabId=0;
var processmethod=[];
var node;
var pnode;
var ppnode;
var treeTab;
$(function(){
	node = parent.node;
	pnode = parent.p_node;
	ppnode = parent.pp_node;
	treeTab = parent.treeTab;
	
	//tab点击事件
	$('#tab').tabs({
	    border:false,
	    onSelect:function(title,index){
	    	tabId = index; // 相应的标签页id,对应控制类型
	    	switch(tabId){
   			case 0:
   				loadAlarmRate();
   				break;
   			case 1:
   				loadCompared();
   				break;
	   		}
	    }
	});

	$.ajax({   type : "POST",
		url : '${pageContext.request.contextPath}/constant/getDetailList?Math.random()&coding='+1141,
		data : {},
		async : true,
		error : function() {
			$.messager.alert("警告",  "error。", "error");
		}, //错误执行方法
		success : function(d) {
			processmethod=d;
		}
	}); //ajax

	resizeDiv();
	
	$("#west").panel({
        onResize: function (w, h) {
        	resizeDiv();
        }
    });
	
	$(window).resize(function(){ //浏览器窗口变化 
		resizeDiv();
	});
	
	reset();
	if(node != null)
		clickNode();
	else
		loadAlarmRate();
});  

function reset(){
	var thisYear = new Date().getUTCFullYear();//今年
	var thisMonth = new Date().getUTCMonth()+1;//本月
	var thisDay = new Date().getDate();//今日
	var thisHour = new Date().getHours();//时辰
	
	$("#yearChoose").combobox('setValue',thisYear);
	$("#monthChoose").combobox('setValue',thisMonth);
	$("#dayChoose").combobox('setValue',"");
	$("#hourChoose").combobox('setValue',"");
	
	//loadAlarmRate();
}

function clickNode(){
	if(null==node || node=="")
		if(null!=treeTab.tree('getSelected'))
			node=treeTab.tree('getSelected');
		else{
			$.messager.alert('提示',"请选择树节点！",'info');
			return;
		}
	
	$("#selectedID").val(node.gid);
    $("#selectedType").val(node.type);
    $("#selectedName").val(node.name);
    $("#selectedParentid").val(0);
    switch (node.type){
    case commonTreeNodeType.gprsBigType:
    case commonTreeNodeType.terminalBigType:
    case commonTreeNodeType.transmissionController:
    case commonTreeNodeType.nbBigType:
        $("#selectedParentid").val(pnode.gid);
    	break;
    }
    
	switch(tabId){
		case 0:
			loadAlarmRate();
			break;
		case 1:
		    switch (node.type){
		    case commonTreeNodeType.gprsDevice:
		    case commonTreeNodeType.terminalDevice:
		    case commonTreeNodeType.transmissionDevice:
		    case commonTreeNodeType.nbDevice:
		        $("#selectedID").val(pnode.gid);
		        $("#selectedType").val(pnode.type);
		        $("#selectedParentid").val(ppnode.gid);
		    	break;
		    }
			loadCompared();
			break;
	}
}

/* 告警统计 */
function loadAlarmRate(){
	var alarmrateurl = "${pageContext.request.contextPath}/earlyWarn/statisticsAlarmRate?Math.random()";
	$.ajax({   type : "POST",
		url : alarmrateurl,
		data : {
			id : $("#selectedID").val(),
			type : $("#selectedType").val(),
			nodeName : $("#selectedName").val(),
			parentid : $("#selectedParentid").val(),
			year : $("#yearChoose").combobox('getValue'),
			month : $("#monthChoose").combobox('getValue'),
			day : $("#dayChoose").combobox('getValue'),
			hour : $("#hourChoose").combobox('getValue')
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
			$.messager.alert("警告",  "获取告警统计方法错误。", "error");
		}, //错误执行方法
		success : function(d) {
			$("body").find("div.datagrid-mask-msg").remove();
            $("body").find("div.datagrid-mask").remove();

            makeAlarmRateCurve(d);//------后台获取数据成功，前台展示待续饼图
		}
	}); //ajax
}
var alarmtype=[];	
function makeAlarmRateCurve(d){
	statisticsChart.clear();
	statisticsChart.resize();
	
	//统计信息
	alarmtype=[];
	var sum=0;
	var legendData=['第一类告警','第二类告警','第三类告警'];
	var seriesData=[],baseseriesData=[];

	for(var i=1;i<=3;i++){
		if(typeof d[i]!='undefined'){ 
			var list=d[i];
			var num=0;
			for ( var p in list) {
				var temp=list[p];
				num=num+parseInt(temp[1]);
			}
			
			switch(i){
			case 1:baseseriesData.push({value:num, name:'第一类告警'});break;
			case 2:baseseriesData.push({value:num, name:'第二类告警'});break;
			case 3:baseseriesData.push({value:num, name:'第三类告警'});break;
			}
			sum=sum+num;
		}
	}
	var option;
	if(sum>0){
		var rate = sum/10;	
		var label = {
	        normal: {
	            formatter: '{a|{a}}{abg|}\n{hr|}\n  {b|{b}：}{c}  {per|{d}%}  ',
	            backgroundColor: '#f0fbff',
	            borderColor: '#42a5d6',
	            borderWidth: 1,
	            borderRadius: 4,
	            rich: {
	                a: {
	                    color: '#212d39',
	                    lineHeight: 22,
	                    align: 'center'
	                },
	                hr: {
	                    borderColor: '#42a5d6',
	                    width: '100%',
	                    borderWidth: 0.5,
	                    height: 0
	                },
	                b: {
	                    fontSize: 16,
	                    lineHeight: 33
	                },
	                per: {
	                    color: '#fafafa',
	                    backgroundColor: '#212d39',
	                    padding: [2, 4],
	                    borderRadius: 2
	                }
	            }
	        }
	    };

		var otherlabel= {
               normal: {
                   show: false,
                   formatter: '{b}：{c}  {d}%'
               },
               emphasis: {
                   show: true
               }
           };
        var labelLine= {
            normal: {
                show: false
            },
            emphasis: {
                show: true
            }
        };
		
		for(var i=1;i<=3;i++){
			if(typeof d[i]!='undefined'){ 
				var list=d[i];
				for ( var p in list) {
					var temp=list[p];
					var count=parseInt(temp[1]);
					legendData.push(temp[0]);
					alarmtype.push({value:p, name:temp[0]});
					if(count>rate)
						seriesData.push({value:count, name:temp[0], label:label});
					else
						seriesData.push({value:count, name:temp[0], label: otherlabel, labelLine: labelLine});
				}
			}
		}
	
		option = {
			    tooltip: {
			        trigger: 'item',
			        formatter: "{a} <br/>{b}: {c} ({d}%)"
			    },
			    legend: {
			        orient: 'vertical',
			        x: 'left',
			        data:legendData,
			        type: 'scroll',
	   		        pageIconColor: '#55e0ed' ,
	   		        pageIconInactiveColor : '#aaa',
	   		        pageTextStyle : {
	   		            color:'#55e0ed'
	   		        }
			    },
			    series: [
			        {
			            name:'告警统计',
			            type:'pie',
			            selectedMode: 'single',
			            radius: [0, '45%'],
			            label: {
			                normal: {
			                    position: 'inner',
			                    color: '#000'
			                }
			            },
			            labelLine: {
			                normal: {
			                    show: false
			                }
			            },
			            data:baseseriesData
			        },
			        {
			            name:'告警统计',
			            type:'pie',
			            radius: ['55%', '70%'],
			            data:seriesData
			        }
			    ]
			};
	}
	else{
		option = {
			    tooltip: {
			    	show: false
			    },
			    legend: {
			    	orient: 'vertical',
			        x: 'left',
			        data:['告警统计']
			    },
			    series: [
			        {
			        	name:'告警统计',
			            type:'pie',
			            radius: ['50%', '65%'],
			            label: {
			                normal: {
			                    show: true,
			                    position: 'center',
			                    formatter: '{c}',
			                    textStyle: {
			                        fontSize: '50'
			                    }
			                }
			            },
			            labelLine: {
			                normal: {
			                    show: false
			                }
			            },
			            data:[
			                {value:0, name:'告警统计'}
			            ]
			        }
			    ]
			};
	}
	
	statisticsChart.setOption(option);
	statisticsChart.on("click", statisticsConsole);
}

//增加监听事件
function statisticsConsole(param) {
	if(param.seriesIndex==1){
		var name = param.name;
		var type;
		alarmtype.forEach(function(element, index) {
			if(name==element.name){
				type = element.value;
			}
		});

		$('#statisticsdlg').dialog('open').dialog('setTitle',name+"--告警列表");
 
		var queryParams = {
				id : $("#selectedID").val(),
				type : $("#selectedType").val(),
				nodeName : $("#selectedName").val(),
				parentid : $("#selectedParentid").val(),
				year : $("#yearChoose").combobox('getValue'),
				month : $("#monthChoose").combobox('getValue'),
				day : $("#dayChoose").combobox('getValue'),
				hour : $("#hourChoose").combobox('getValue'),
				alarmtype : type
			};
		makeDatagird(queryParams);
	}
}

//查询告警数据详情--实时监控页
//alarmId 告警表id
//dataType 数据类型：1-开始数据
//alarmType 事件类型id
function queryData(alarmId,dataType,alarmType){
	//清空表格
	$('#dataDetail').empty();
	var mData={"alarmId":alarmId,"dataType":dataType,"alarmType":alarmType}; 
	$.ajax({
		type:'POST', 
        url:'${pageContext.request.contextPath}/earlyWarn/earlyDataDetail?Math.random()',           
        data:mData,        
	       success:function(data){ 
	    	   var title;
	    		if(dataType == 1) title = "发生数据详情";
	    		else if(dataType == 2) title = "结束数据详情";
	    		var eventArray = getEventName(alarmType);
	    		var html = '';
	    		var height = "60px";
	    		if(data.length > 0){
	    			html='<table cellpadding="5" align="center">';
	    		    if(data.length > 7)
	    			    height = "320px";
	    		    else
	    			    height = 53*data.length+"px";
	    		    var numberName="";
	    	  	    for (var i = 0; i < data.length; i++) {  
	    			    numberName = getNumberName(data[i].itemnumber,alarmType); 
	    			    var evenName="";//项名称
	    			    var mEventData="";//数据值和单位
	    			    if(alarmType >= 1 && alarmType < 60 ){
	    				    if(alarmType == 23 || alarmType == 24){
	    					    evenName = eventArray[0] + numberName;//项名称
		    				    mEventData = getEventData(alarmType,data[i].itemnumber,FormatValue(data[i].eventdata), eventArray); 
	    				    }else{
	    					    evenName = numberName + eventArray[0];//项名称
	    					    if(null != data[i].eventdata)
	    						    mEventData = data[i].eventdata + eventArray[1];
	    		  			    else
	    		  				    mEventData = "无数据";
	    				    }	
	    			    }
	    			    else if (alarmType >= 520 && alarmType <= 600){ //用传告警
	    			    	var evenName = getNumberName(data[i].itemnumber, alarmType);
   	  			    	if(null != data[i].eventdata)
   						    mEventData = data[i].eventdata;
   		  			    else
   		  				    mEventData = "无数据";
	    	  			}
	    			    else {
	    				    evenName = eventArray[0] + numberName;//项名称
	    				    mEventData = getEventData(alarmType,data[i].itemnumber,FormatValue(data[i].eventdata), eventArray); 
	    			    } 
		    			if(alarmType != 92 || data[i].itemnumber != 2){//屏蔽燃气告警的电池电压数据
		    		   		var trTd = '<tr class="tableTr"> '
		    			 	    +'<td ><input class="easyui-textbox" readonly="true" value="'+mEventData +'" style="width:240px;" data-options="label:\''+evenName+'\'" ></td>'
		    			 	    +'</tr>';
		    			 	html = html + trTd;
		    			}
	    			}  
	    	  	    html=html+'</table>';
	    		}
	    		if(null==html || html=="") html="<p style='color: gold;font-size: 16px;margin-top:10px'>暂无数据<p>";
	    	    $("#dataDetail").append(html);
	    	    $.parser.parse( $('#w')); 
	    	    document.getElementById("w").style.height= height;
	    	    $('#w').window('open').dialog('setTitle',title);

	        },	        
	        error:function(data){
	        	$.messager.alert('<spring:message code="Warning"/>',"获取失败。",'error');
       	}
	});	
}
/* 告警统计 */

/* 告警同期对比 */
function loadCompared(){
	var alarmrateurl = '${pageContext.request.contextPath}/earlyWarn/alarmCompared?Math.random()';
	$.ajax({   type : "POST",
		url : alarmrateurl,
		data : {
			id : $("#selectedID").val(),
			type : $("#selectedType").val(),
			nodeName : $("#selectedName").val(),
			parentid : $("#selectedParentid").val(),
			dateType : $('#dateType').combobox('getValue'),
			equalNumber : $('#equalNumber').combobox('getValue')
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
			$.messager.alert("警告",  "获取告警同期对比方法错误。", "error");
		}, //错误执行方法
		success : function(d) {
			$("body").find("div.datagrid-mask-msg").remove();
            $("body").find("div.datagrid-mask").remove();

            makeAlarmComparedCurve(d);//------后台获取数据成功，前台展示待续饼图
		}
	}); //ajax
}

function makeAlarmComparedCurve(d){
	comparedChart.clear();
	comparedChart.resize();

	var option = {
    	    tooltip : {
    	        trigger: 'axis'
    	    },
    	    legend: {
    	        data: d["legendData"]
    	    },
    	    grid: {show:'true',borderWidth:'0',
				y2: 70// y2可以控制 X轴跟Zoom控件之间的间隔，避免以为倾斜后造成 label重叠到zoom上
			},
    	    toolbox: {
    	        show : true,
    	        feature : {
    	            //mark : {show: true},
    	            dataView : {
    	            	show: true, 
    	            	title : '数据视图',
    	            	readOnly : true,
    	            	lang: ['告警同期对比', '关闭'],
    	            	optionToContent:function(opt) {
                        	return dataviewformate(opt);
                        }
    	            },
    	            magicType : {show: true, type: ['line', 'bar']},
    	            restore : {show: true}
    	        }
    	    },
    	    calculable : false,
    	    xAxis : [
    	    	{
    	            type : 'category',
    	            data : d["xNameJson"],
     	        	axisLabel:{
	 	                textStyle:{
	 	                   fontSize:11 //刻度大小
	 	                },
	                    interval:0,
	                    rotate:30,
	            	},
		            splitLine: {show: false}
    	        }
    	    ],
    	    yAxis : [
    	        {
    	            type : 'value',
		            splitLine: {show: false}
    	        }
    	    ],
    	    series : d["series"]

    	};  
	
	comparedChart.setOption(option);
	comparedChart.on("click", comparedConsole);
}

//增加监听事件
function comparedConsole(param) {
	var systemtype=0;
	var name = param.name;
	switch(name){
		case "防火卷级防火门监控系统":systemtype=18;break;
		case "消火栓系统":systemtype=20;break;
		case "报警按钮及声光报警器":systemtype=130;break;
		case "电气火灾监控系统":systemtype=10;break;
		case "可燃气体报警系统":systemtype=11;break;
		case "烟雾监控系统":systemtype=128;break;
		case "消防水压监控系统":systemtype=129;break;
		case "消防水位监控系统":systemtype=131;break;
	}
	var year="",month="";
	var time = (param.seriesName).split("-");
	year=time[0];
	if(time.length==2)
		month=time[1];

	$('#statisticsdlg').dialog('open').dialog('setTitle',name+"--告警列表");

	var queryParams = {
		id : $("#selectedID").val(),
		type : $("#selectedType").val(),
		nodeName : $("#selectedName").val(),
		parentid : $("#selectedParentid").val(),
		year : year,
		month : month,
		systemtype : systemtype
	};
	makeDatagird(queryParams);
}

function makeDatagird(queryParams){
	$('#statisticsdg').datagrid({
		url :'${pageContext.request.contextPath}/earlyWarn/statisticsAlarmList?Math.random',
		queryParams : queryParams,
		pagination : true,//分页控件
		pageList: [10, 20, 30, 40, 50],
		fit: true,   //自适应大小
		singleSelect: true,
		iconCls : 'icon-save',
		border:false,
		nowrap: true,//数据长度超出列宽时将会自动截取。
		rownumbers:true,//行号
		fitColumns:true,//自动使列适应表格宽度以防止出现水平滚动。
		toolbar : "#statisticstoolbar",
		columns: [[ 
			{title: '用户名称', field: 'customername', width: '180px'},
			{title: '设备名称', field: 'equipmentname', width: '150px'},
			{title: '设备地址', field: 'equipmentaddress', width: '150px'},
			{title: '发生时间(设备)', field: 'occurtime', width: '180px',sortable:true}, 
			{title: '设备数据', field: 'occurdata', width: '100px',
				formatter:function(value,rowData,rowIndex){
					if(null!=rowData.id && rowData.id!=""){
						var id=rowData.id;	//告警表id
						var dataType=1; //数据类型：1-开始数据
						return "<a href='#' class='easyui-linkbutton button-default button-view' onclick='queryData(&apos;" + id +"&apos;"+","+"&apos;"+dataType+"&apos;"+","+"&apos;"+rowData.alarmtype+"&apos;);'>查看详情</a>";
					}
            	}
			},
			{title: '结束时间(设备)', field: 'endtime', width: '180px'}, 
			{title: '结束数据', field: 'enddata', width: '100px',
				formatter:function(value,rowData,rowIndex){
					if(null!=rowData.id && rowData.id!=""){
						var id=rowData.id; //告警表id
						var dataType=2; //数据类型：1-开始数据
						if(null!=rowData.endtime && rowData.endtime!="")
							return "<a href='#' class='easyui-linkbutton button-default button-view' onclick='queryData(&apos;" + id +"&apos;"+","+"&apos;"+dataType+"&apos;"+","+"&apos;"+rowData.alarmtype+"&apos;);'>查看详情</a>";
						else
							return "";
					}
				}
            },  
			{title: '安装地址', field: 'installationsite', width: '150px'},        						 				
			{title: '附件', field: 'annex', width: '100px',
				formatter:function(value,rowData,rowIndex){
					if(rowData.status==1 && null!=rowData.annexname
							&& rowData.annexname!=""){
						var id=rowData.id;	
						var name=rowData.annexname;
						return "<a href='${pageContext.request.contextPath}/earlyWarn/downLoadAnnex?id=" + id+ "'>"+name+"</a>";
					}
            	}
			}, 
	        {title: '插入时间', field: 'insertiontime', width: '180px'}, 
			{title: '处理人', field: 'handlepeople', width: '100px'}, 
			{title: '处理时间', field: 'processtime', width: '180px'}, 
			{title: '处理方法', field: 'processmethod', width: '100px',
	        	formatter:function(value, rowData, rowIndex){
	        		var method="";
	        		if(null!=value && value!=""){
	        			var temp=value.split(',');
	        			for(var i=0;i<temp.length;i++){
	        				for(var j=0;j<processmethod.length;j++)
	        					if(temp[i]==processmethod[j].detailvalue)
	        						method += processmethod[j].detailname+",";
	        			}
	        		}
	        		return method=="" ? "" : method.substring(0,method.length-1);
	        	}
	        }, 
	        {title: '处理备注', field: 'processremarks', width: '150px'},
		]], 
		onLoadSuccess:function(){

			$('.button-view').linkbutton({ 
			});
			
			$('.text').textbox({
				width:70,
				height:30
			})

		},
	});
}

function dataviewformate(opt){
    var axisData = opt.xAxis[0].data;
    var series = opt.series;

    var tableDom = document.createElement("table");
    tableDom.setAttribute("id","test");
    tableDom.setAttribute("class","table-data-table");
    // <table id="test" class="table-bordered table-striped" style="width:100%;text-align:center"
    
    var table = '<thead><tr>' + '<th>日期</th>';
    for(var j=0;j<series.length;j++){
    	table = table + '<th>' + series[j].name + '</th>'
    }
    table = table+ '</tr></thead><tbody>';
    
    for (var i = 0, l = axisData.length; i < l; i++) {
        table += '<tr>' + '<td>' + axisData[i] + '</td>'
        	for(var j=0;j<series.length;j++){
            	table = table + '<td>' + series[j].data[i] + '</td>';
            }
            table = table + '</tr>';
    }
    table += '</tbody>';
    tableDom.innerHTML = table;
    return tableDom.outerHTML;
}
/* 告警同期对比 */
</script>
</html>