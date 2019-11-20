<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
    <%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>综合查询页面-设备数据</title>
<%@include file="../Header.jsp" %>
<style type="text/css">
.cardBox {
    width: 99%;
    box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
    text-align: center;
    float: left;
    padding: 5px;
    padding-top: 10px;
    box-sizing: border-box;
    -moz-box-sizing: border-box;
    -webkit-box-sizing: border-box;
}
.headerBox {
    color: #fff;
    padding: 10px;
    font-size: 15px;
    background-color: #212d39;
    height: 25px;
}
.headerTitle{
    text-align: left;
    padding-bottom: 6px;
}
.bodyBox {
    padding: 10px;
    text-align: left;
    position: relative;
}
.bodyBox table tr {
    height: 22px;
}
.sys_name{
    left: 20px;
    position: absolute;
}
.sealDiv{
	position: absolute;
    top: 11px;
    right: 15px;
}
.sealDiv img{
	top: 1px;
    position: relative;
    height: 40px;
}
.datagrid-mask-msg{
	color: #fff;
}
#button{
    text-align: center;
    font-weight: 600;
}
#button div{
	display: inline-block;
	text-align: center;
	cursor: pointer;
    margin-left: 50px;
}
</style>
</head>
<body>

	<!-- 设备基础信息 -->
	<div class="cardBox">
		<div class="headerBox">
			<a title="查看详情" style="cursor: pointer; color:white; text-align: left; font-size: 18px;">
				<p id="equipmentname" style="padding-left: 5px;"></p>
			</a>
		</div>
		<div class="sealDiv" style="display:none;">
			<img id="unonlineSeal" src="${pageContext.request.contextPath}/images/Front/unonline.png" style="display:none;"/>
  			<img id="warnSeal" src="${pageContext.request.contextPath}/images/Front/warn.png" style="display:none;"/>
			<img id="faultSeal" src="${pageContext.request.contextPath}/images/Front/fault.png" style="display:none;"/>
  			<img id="nocommSeal" src="${pageContext.request.contextPath}/images/Front/nocomm.png" style="display:none;"/>
			<img id="nodownSeal" src="${pageContext.request.contextPath}/images/Front/nodown.png" style="display:none;"/> 
		</div>
		<div class="bodyBox">
			<table id="device" style="width:100%;display:none;">
				<tr>
					<td style="width: 70px;"></td>
					<td colspan="2"><div ></div></td>
					<td style="min-width: 290px;" rowspan="6">
	 					<div class="" style="width:280px;">
			    			<div class="headerTitle">
			    				<div style="font-size: x-large;width: 90px;display: inline-block;" id="freezingtype"></div>
			    			</div>
			 				<div class="bodyBox">
				     			<table style="width:100%;"><!-- border-collapse: collapse;border-spacing: 0;table-layout: fixed; -->
				     				<tr>
				     					<td style="width: 100px;">最新冻结时间：</td>
				     					<td style="width: 140px;"><div id="freezetime"></div></td>
				     				</tr>
				     				<tr>
				     					<td>最新告警时间：</td>
				     					<td><div id="alarmtime"></div></td>
				     				</tr>
				     			</table>
			     			</div>
    					</div>
					</td>
				</tr>
				<tr>
					<td style="width: 70px;">设备地址：</td>
					<td><div id="equipmentaddress"></div></td>
				</tr>
				<tr>	
					<td>设备类型：</td>
					<td><div id="equipmenttypename"></div></td>
				</tr>
				<tr>	
					<td>设备型号：</td>
					<td><div id="devicemodel"></div></td>
				</tr>
				<tr>
					<td>安装地址：</td>
					<td><div id="installationsite"></div></td>
				</tr>
				<tr>
					<td>终端状态：</td>
					<td><div id="unitstatus"></div></td>
				</tr>
			</table>
 			<table id="concentrator" style="width:100%;display:none;">
   				<tr>				
   					<td colspan="2"></td>
   					<td style="min-width: 290px;" rowspan="6">
    					<div class="" style="width:280px;">
		    				<div class="bodyBox">
			        			<table style="width:100%;"><!-- border-collapse: collapse;border-spacing: 0;table-layout: fixed; -->
			        				<tr>
			        					<td style="width: 100px;">上线时间：</td>
			        					<td style="width: 140px;"><div id="onlinetime"></div></td>
			        				</tr>
			        				<tr>
			        					<td>离线时间：</td>
			        					<td><div id="droppedtime"></div></td>
			        				</tr>
			        			</table>
			        		</div>
			       		</div>
   					</td>
   				</tr>
   				<tr>
   					<td style="width: 70px;">设备地址：</td>
   					<td><div id="unitaddress"></div></td>
   				</tr>
   				<tr>	
   					<td>设备类型：</td>
   					<td><div id="typename"></div></td>
   				</tr>
   				<tr>	
   					<td>终端型号：</td>
   					<td><div id="unitmodel"></div></td>
   				</tr>
   				<tr>	
   					<td>设备状态：</td>
   					<td><div id="typestatus"></div></td>
   				</tr>
        	</table>
        	<div id="button">
				<div id="page0" onclick="paramManagePage()">
					<img src="${pageContext.request.contextPath}/images/complex/casz.png" style="width: 53px;"/>
					<br/>
					参数管理
				</div>
				<div id="page1" onclick="freezeCyclePage()">
					<img src="${pageContext.request.contextPath}/images/complex/djsj.png" style="width: 50px;"/>
					<br/>
					冻结周期
				</div>
				<div id="page2" onclick="eventThresholdPage()">
					<img src="${pageContext.request.contextPath}/images/complex/sjfz.png" style="width: 50px;"/>
					<br/>
					事件阀值
				</div>
				<div id="page3" onclick="dataQueryPage()">
					<img src="${pageContext.request.contextPath}/images/complex/sjzc.png" style="width: 53px;"/>
					<br/>
					数据召测
				</div>	
				<div id="page6" onclick="freezeCurvePage()">
					<img src="${pageContext.request.contextPath}/images/complex/djqx.png" style="width: 60px;"/>
					<br/>
					冻结曲线
				</div>
				<div id="realtimecurve" onclick="realtimeCurveParam()">
					<img src="${pageContext.request.contextPath}/images/complex/ssqx.png" style="width: 60px;"/>
					<br/>
					实时曲线
				</div>
				<div id="page4" onclick="alarmListPage()">
					<img src="${pageContext.request.contextPath}/images/complex/gjlb.png" style="height: 53px;"/>
					<br/>
					告警列表
				</div>
				<div id="page5" onclick="faultListPage()">
					<img src="${pageContext.request.contextPath}/images/complex/gzlb.png" style="width: 51px;"/>
					<br/>
					故障列表
				</div>	
				<div id="" onclick="operationLogPage()">
					<img src="${pageContext.request.contextPath}/images/complex/czrz.png" style="width: 56px;"/>
					<br/>
					操作日志
				</div>
			</div>
		</div>
	</div>	

<script type="text/javascript">
var node;
var pnode;
var ppnode;
$(function(){	
	//隐藏所有按钮
	$("div[id^='page']").hide();
	$("#realtimecurve").hide();

	node = parent.node;
	pnode = parent.p_node;
	ppnode = parent.pp_node;
    
    //根据节点类型，控制按钮的显示
    var sign;  
    switch (node.type){
    case 4: //集中器
		sign = "1000000";
		break;	
    case 5: //终端
		sign = "0010011";
		$("#realtimecurve").show();
    	break;
	case 6: //电表
	    sign = "0010011";
		$("#realtimecurve").show(); //显示实时数据
	    break;	
	}
    for(var i=0;i<sign.length;i++){
    	if(sign[i]=="1")
    		$("#page"+i).show();
    }
    
    $('#device').hide();
    $('#concentrator').hide();
    switch (node.type){
		case 4: 
			$('#concentrator').show();
			unitClick(node.gid);
	    	break;
	    default:
	    	$('#device').show();
	    	deviceClick(node.gid);
	    	break;
	}
}); 


//点击终端、电表事件
function deviceClick(id){
	$('#equipmentname').html("");
	$('#equipmentaddress').html("");
	$('#equipmenttypename').html("");
	$('#devicemodel').html("");
	$('#installationsite').html("");
	$('#freezingtype').html("");
	$('#freezetime').html("");
	$('#alarmtime').html("");
	$('#faulttime').html("");
	$('.sealDiv').hide();$('#unonlineSeal').hide();$('#warnSeal').hide();$('#faultSeal').hide();
	$('#nocommSeal').hide();$('#nodownSeal').hide();
	$('#unitstatus').html("");
	
    $.ajax({
		type : 'POST',
		url : basePath + '/subsystem/getEquipmentData?Math.random()',
		data : {
			id : id,
			type : node.type
		},
		beforeSend:function(XMLHttpRequest){ 
			//打开loading效果
			if ($("body").find(".datagrid-mask").length == 0) {
                //添加等待提示
                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
                $("<div class=\"datagrid-mask-msg\"></div>").html("加载中，请稍候...").appendTo("body").css({ "display": "block", "text-align": "center", "border-radius": "5px", "position": "absolute", left: "50%", top: "50%", "transform": "translate(-50%,-50%)" }); //上同
            }
		}, 
		success : function(d) {
			//关闭loading效果
			$("body").find("div.datagrid-mask-msg").remove();
            $("body").find("div.datagrid-mask").remove();
            
			if(d!="error"){
				/* 设备基础信息 */
				var equipment = d;//设备列表

				var color='#4caf50',type="正常";
				switch(equipment.status){
			        case 0:color='#8a8a8a',type="离线";
			        $('.sealDiv').show();$('#unonlineSeal').show();
			        break;
			        case 2:color='#ca1d1d',type="告警";
			        $('.sealDiv').show();$('#warnSeal').show();
			        break;
			        case 3:color='#d4941f',type="故障";
			        $('.sealDiv').show();$('#faultSeal').show();
			        break;
			        case 4:color='#8a8a8a',type="不可通讯";
			        $('.sealDiv').show();$('#nocommSeal').show();
			        break;
			        case 5:color='#8a8a8a',type="未下发";
			        $('.sealDiv').show();$('#nodownSeal').show();
			        break;
			        default:color='#4caf50',type="正常";
			        break;
			    }
				$('.headerBox').css('background-color',color+"bb");

				$('#equipmentname').html(equipment.ammeterName);
				$('#equipmentaddress').html(equipment.ammeterCode);
				$('#equipmenttypename').html(equipment.typename);
				$('#devicemodel').html(equipment.devicetype);			
				$('#installationsite').html(equipment.installAddress);
             	$('#freezingtype').html("日冻结");
				

				if(equipment.statustype==0 && equipment.freezestatus==0 && typeof equipment.freezetime!="undefined")
					$('#freezetime').html("<span style='color:#ca1d1d'>"+equipment.freezetime+"<span>");
				else
					$('#freezetime').html(equipment.lastFreezeTime);
				
				$('#alarmtime').html(equipment.lastEarlyWarnTime);
				$('#faulttime').html(equipment.lastFaultTime);
 	
				if(equipment.status==1)
					$('#unitstatus').html("在线");
				else
					$('#unitstatus').html("<span style='color:#ca1d1d'>不在线<span>");	
			}
		},
		error : function(d) {

		}
	});

}

//点击集中器事件
function unitClick(id){
	$('#equipmentname').html("");
	$('#unitaddress').html("");
	$('#typename').html("");
	$('#typestatus').html("");
	$('#unitmodel').html("");
	$('#onlinetime').html("");
	$('#droppedtime').html("");
	$('.sealDiv').hide();$('#unonlineSeal').hide();$('#warnSeal').hide();$('#faultSeal').hide();
	$('#nocommSeal').hide();$('#nodownSeal').hide();

    $.ajax({
		type : 'POST',
		url : basePath + '/subsystem/getConcentratorData?Math.random()',
		data : {
			id : id,
			type : node.type
		},
		beforeSend:function(XMLHttpRequest){ 
			//打开loading效果
			if ($("body").find(".datagrid-mask").length == 0) {
                //添加等待提示
                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
                $("<div class=\"datagrid-mask-msg\"></div>").html("加载中，请稍候...").appendTo("body").css({ "display": "block", "text-align": "center", "border-radius": "5px", "position": "absolute", left: "50%", top: "50%", "transform": "translate(-50%,-50%)" }); //上同
            }
		}, 
		success : function(d) {
			//关闭loading效果
			$("body").find("div.datagrid-mask-msg").remove();
            $("body").find("div.datagrid-mask").remove();
            
			if(d!="error"){
				/* 设备基础信息 */
				var unit = d;//设备列表

				var color='#4caf50',type="正常";
				switch(unit.status){
			        case 0:color='#8a8a8a',type="离线";
			        $('.sealDiv').show();$('#unonlineSeal').show();
			        $('#typestatus').html("不在线");
			        break;
			        default:color='#4caf50',type="正常";
			    	$('#typestatus').html("在线");
			        break;
			    }

				$('.headerBox').css('background-color',color+"bb");

				$('#equipmentname').html(unit.equipname);
				$('#unitaddress').html(unit.address);
				$('#typename').html(unit.typename);			
				$('#unitmodel').html(unit.devicetype);							
				$('#onlinetime').html(unit.onlinetime);
				if(typeof unit.droppedtime!="undefined") 
					$('#droppedtime').html("<span style='color:#ca1d1d'>"+unit.droppedtime+"<span>");
			}
		},
		error : function(d) {
		}
	});

}

function paramManagePage(){//参数管理
	parent.$('#paramManagePage').dialog({    
		title: '参数管理',      
        collapsible: true,
	    href : basePath + '/complex/unitparams?Math.random()'
	}).dialog('open');
}

function freezeCyclePage(){//冻结周期
	parent.readFreezingPeriod();
}

function eventThresholdPage(){//事件阀值
	parent.$('#eventThresholdPage').dialog({    
		title: '事件阀值',      
        collapsible: true,     
	    href : basePath + '/complex/eventthreshold?Math.random()' 
	}).dialog('open');
}

function dataQueryPage(){//数据召测
	parent.dataQuery();
}

function freezeCurvePage(){//冻结曲线
	parent.$('#dlgFreezeCurve').dialog({    
		title: '冻结曲线',       
	    href : basePath + '/complex/freezeCurve?type='+node.type+'&text='+node.text+'&gid='+node.gid,     
	    collapsible: true 
	}).dialog('open');
}

function realtimeCurveParam(){//实时曲线
	parent.$('#dlgRealtimeCurve').dialog({    
		title: '实时曲线',       
		href : basePath + '/complex/realtimeCurve?Math.random()&id='+node.gid+'&nodetype='+node.type,     
	    collapsible: true  
	}).dialog('open');
}

function alarmListPage(){//告警列表
	parent.getAlarmList();
}

function faultListPage(){//故障列表
	parent.getFaultList();
}

function operationLogPage(){//操作日志
	parent.getLogList();
}


</script>

</body>
</html>