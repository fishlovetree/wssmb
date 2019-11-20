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
<title>故障率</title>
<jsp:include page="../../Header.jsp"/>
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
<input type="hidden" id="selectedParentid" value="0" />
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
	       		<a href="javascript:void(0)" class="easyui-linkbutton button-default"  onclick="loadFaultRate()" title="Search">确定</a>
	       		<a href="javascript:void(0)" class="easyui-linkbutton button-default"  onclick="reset()" title="Reset">重置</a>
			</div>
		</div>
		<!-- 故障统计饼图和柱形图-->
		<div id="www" data-options="region:'center'" style="width:100%;height: 100%" href="">
			<div id="statistics" style="height:300px;margin:auto;padding-top: 20px;padding-left: 10px;"></div>
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

</body>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/echarts/echarts.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/echarts/DarkGray_Back.js"></script>
<script type="text/javascript">
var statistics = document.getElementById('statistics');
var statisticsChart = echarts.init(statistics,'DarkGray_Back');

//用于使chart自适应高度和宽度,通过窗体高宽计算容器高宽
var resizeDiv = function () {
	var width=$('#p').width()-20;
	var height=$('#p').height()-150;
	if(width<845)
		width=845;
	
	statistics.style.width = width+'px';
	statistics.style.height = height+'px';
	$('#statisticsChart').width(width);
	$('#statisticsChart').height(height);

	$('.zr-element').width(width);
	
	statisticsChart.resize();
};

var node;
var pnode;
var ppnode;
var processmethod=[];
$(function(){
	node = parent.node;
	pnode = parent.p_node;
	ppnode = parent.pp_node;
	$.ajax({   type : "POST",
		url : '${pageContext.request.contextPath}/constant/getDetailList?Math.random()&coding='+1142,
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
		loadFaultRate();
	
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
}

function clickNode(){
	if(null==node || node=="")
		if(null!=$('#region_tree').tree('getSelected'))
			node=$('#region_tree').tree('getSelected');
		else{
			$.messager.alert('提示',"请选择树节点！",'info');
			return;
		}
    $("#selectedParentid").val(0);

    switch (node.type){
    case commonTreeNodeType.gprsBigType:
    case commonTreeNodeType.terminalBigType:
    case commonTreeNodeType.transmissionController:
    case commonTreeNodeType.nbBigType:
    	var pnode = $('#region_tree').tree('getParent', node.target);
        $("#selectedParentid").val(pnode.gid);
    	break;
    }
	
	loadFaultRate();
}

/* 故障统计 */
function loadFaultRate(){
	var faultrateurl = "${pageContext.request.contextPath}/frontFault/statisticsFaultRate?Math.random()";
	$.ajax({   type : "POST",
		url : faultrateurl,
		data : {
			id : $("#selectedID" , parent.document).val(),
			type : $("#selectedType" , parent.document).val(),
			nodeName : $("#selectedAddress" , parent.document).val(),
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
			$.messager.alert("警告",  "获取故障统计方法错误。", "error");
		}, //错误执行方法
		success : function(d) {
			$("body").find("div.datagrid-mask-msg").remove();
            $("body").find("div.datagrid-mask").remove();

            makeFaultRateCurve(d);//------后台获取数据成功，前台展示待续饼图
		}
	}); //ajax
}
var faulttype=[];	
function makeFaultRateCurve(d){
	statisticsChart.clear();
	statisticsChart.resize();
	
	//统计信息
	faulttype=[];
	var sum=0;
	var legendData=[];
	var seriesData=[],baseseriesData=[];

	for ( var t in d){
		if(typeof d[t]!='undefined'){ 
			var list=d[t];
			legendData.push(t);
			var num=0;
			for ( var p in list) {
				var temp=list[p];
				num=num+parseInt(temp[1]);
			}
			baseseriesData.push({value:num, name:t});
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
		
		for ( var t in d){
			if(typeof d[t]!='undefined'){ 
				var list=d[t];
				for ( var p in list) {
					var temp=list[p];
					var count=parseInt(temp[1]);
					legendData.push(temp[0]);
					faulttype.push({value:p, name:temp[0]});
					if(count>rate)
						seriesData.push({value:count, name:temp[0], label: label});
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
			            name:'故障统计',
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
			            name:'故障统计',
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
			        data:['故障统计']
			    },
			    series: [
			        {
			        	name:'故障统计',
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
			                {value:0, name:'故障统计'}
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
		faulttype.forEach(function(element, index) {
			if(name==element.name){
				type = element.value;
			}
		});

		$('#statisticsdlg').dialog('open').dialog('setTitle',name+"--故障列表");

		$('#statisticsdg').datagrid({
			url :'${pageContext.request.contextPath}/frontFault/statisticsFaultList?Math.random',
			queryParams : {
				id : $("#selectedID" , parent.document).val(),
				type : $("#selectedType" , parent.document).val(),
				nodeName : $("#selectedAddress" , parent.document).val(),
				parentid : $("#selectedParentid").val(),
				year : $("#yearChoose").combobox('getValue'),
				month : $("#monthChoose").combobox('getValue'),
				day : $("#dayChoose").combobox('getValue'),
				hour : $("#hourChoose").combobox('getValue'),
				faulttype : type
			},
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
				{title: '设备名称', field: 'equipmentname', width: '150px'},
				{title: '设备地址', field: 'equipmentaddress', width: '150px'},
				{title: '故障类型', field: 'faultname', width: '140px'}, 
				{title: '发生时间(设备)', field: 'occurtime', width: '180px',sortable:true}, 
				{title: '结束时间(设备)', field: 'endtime', width: '180px'}, 
	            {title: '用户名称', field: 'customername', width: '180px'},
				{title: '用户编号', field: 'customerCode', width: '120px'},  
				{title: '设备地址', field: 'equipmentaddress', width: '150px'},
	            {title: '系统地址', field: 'systemAddress', width: '80px'}, 
	            {title: '单元地址', field: 'unitaddress', width: '100px'}, 
				{title: '安装地址', field: 'installationsite', width: '150px'},        						 				
				{title: '累计次数', field: 'cumulativenum', width: '100px'}, 	
				{title: '备注', field: 'remarks', width: '150px'}, 
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
		        {title: '插入时间', field: 'inserttime', width: '180px'}, 
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
}
/* 故障统计 */
</script>
</html>