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
<title>参数设置</title>
</head>
<body>

	<div id="result-head" class="easyui-layout" fit="true">
		<div region="north" style="height: 110px;" split="true">
			<table border="0" cellspacing="8" cellpadding="8">
				<tr>
					<td style="width:40px;">
						节点：
					</td>
					<td>
						<label id='paramsnode'></label>
					</td>
                </tr>
                <tr>
                   	<td colspan="2">
                   		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="getVersion()" title="读取终端版本号">读取集中器版本号</a>
                        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="getSim()" title="读取终端SIM卡序号">读取集中器SIM卡序号</a>
                    	<br/>
                    	<a href="javascript:void(0)" class="easyui-linkbutton" onclick="readIp()" title="查询">主站IP</a>
	            	    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="readWifi()" title="查询">WIFI</a>
	            	    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="readEthernet()" title="查询">以太网</a>
	            	    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="readSms()" title="查询">短信</a>
	            	    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="readRepeat()" title="查询">重发机制</a>
	            	    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="readTime()" title="查询">终端时间</a>
	            	    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="readCtr()" title="查询">互感器变比</a>
	            	    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="readPower()" title="查询">接线模式字</a> 
                	</td>
				</tr>
			</table>
		</div>
		<div region="center" title="结果<a href='javascript:void(0)' class='easyui-linkbutton' 
			style='float: right; width: 40px;' onclick='clearParamsResult();'>清空</a>" split="true">
			<div id="paramsResult" style="margin: 10px;"></div>
		</div>
	</div>
<script type="text/javascript">	
    $(function(){
    	$("#paramsnode").html(node.text);
    })

    //读取终端版本号
    function getVersion(){
    	var selectedID = $.trim($("#selectedID").val());
    	var selectedType = $.trim($("#selectedType").val());
        if (selectedID == "") {
        	$.messager.alert("提示", "请选择节点。", "warning");
            return;
        }
        $.ajax({
			type: 'POST',
			url: '${pageContext.request.contextPath}/unitParams/getVersion',
			data: {
				"id": selectedID,
				"type": selectedType,
				"address": $("#selectedAddress").val()
			},
			success: function(d) {
				sentMessage(d, "读取中，请稍候...");
			}
		});
    }
    
    //读取终端SIM卡号
    function getSim(){
    	var selectedID = $.trim($("#selectedID").val());
    	var selectedType = $.trim($("#selectedType").val());
        if (selectedID == "") {
        	$.messager.alert("提示", "请选择节点。", "warning");
            return;
        }
        $.ajax({
			type: 'POST',
			url: '${pageContext.request.contextPath}/unitParams/getSim',
			data: {
				"id": selectedID,
				"type": selectedType,
				"address": $("#selectedAddress").val()
			},
			success: function(d) {
				sentMessage(d, "读取中，请稍候...");
			}
		});
    }
    
    //查询设备地址
    function readAddress(){
    	var selectedID = $.trim($("#selectedID").val());
    	var selectedType = $.trim($("#selectedType").val());
        if (selectedID == "") {
        	$.messager.alert("提示", "请选择节点。", "warning");
            return;
        }
        $.ajax({
			type: 'POST',
			url: '${pageContext.request.contextPath}/unitParams/getAddress',
			data: {
				"id": selectedID,
				"type": selectedType,
				"address": $("#selectedAddress").val()
			},
			success: function(d) {
				sentMessage(d, "查询中，请稍候...");
			}
		});
    }
 
    //查询主站IP
    function readIp(){
    	var selectedID = $.trim($("#selectedID").val());
    	var selectedType = $.trim($("#selectedType").val());
        if (selectedID == "") {
        	$.messager.alert("提示", "请选择节点。", "warning");
            return;
        }
        $.ajax({
			type: 'POST',
			url: '${pageContext.request.contextPath}/unitParams/getIp',
			data: {
				"id": selectedID,
				"type": selectedType,
				"address": $("#selectedAddress").val()
			},
			success: function(d) {
				sentMessage(d, "查询中，请稍候...");
			}
		});
    }
    
    //查询WIFI
    function readWifi(){
    	var selectedID = $.trim($("#selectedID").val());
    	var selectedType = $.trim($("#selectedType").val());
        if (selectedID == "") {
        	$.messager.alert("提示", "请选择节点。", "warning");
            return;
        }
        $.ajax({
			type: 'POST',
			url: '${pageContext.request.contextPath}/unitParams/getWifi',
			data: {
				"id": selectedID,
				"type": selectedType,
				"address": $("#selectedAddress").val()
			},
			success: function(d) {
				sentMessage(d, "查询中，请稍候...");
			}
		});
    }
 
    //查询以太网
    function readEthernet(){
    	var selectedID = $.trim($("#selectedID").val());
    	var selectedType = $.trim($("#selectedType").val());
        if (selectedID == "") {
        	$.messager.alert("提示", "请选择节点。", "warning");
            return;
        }
        $.ajax({
			type: 'POST',
			url: '${pageContext.request.contextPath}/unitParams/getEthernet',
			data: {
				"id": selectedID,
				"type": selectedType,
				"address": $("#selectedAddress").val()
			},
			success: function(d) {
				sentMessage(d, "查询中，请稍候...");
			}
		});
    }
    
    //查询短信
    function readSms(){
    	var selectedID = $.trim($("#selectedID").val());
    	var selectedType = $.trim($("#selectedType").val());
        if (selectedID == "") {
        	$.messager.alert("提示", "请选择节点。", "warning");
            return;
        }
        $.ajax({
			type: 'POST',
			url: '${pageContext.request.contextPath}/unitParams/getSms',
			data: {
				"id": selectedID,
				"type": selectedType,
				"address": $("#selectedAddress").val()
			},
			success: function(d) {
				sentMessage(d, "查询中，请稍候...");
			}
		});
    }
    
    //查询重发机制
    function readRepeat(){
    	var selectedID = $.trim($("#selectedID").val());
    	var selectedType = $.trim($("#selectedType").val());
        if (selectedID == "") {
        	$.messager.alert("提示", "请选择节点。", "warning");
            return;
        }
        $.ajax({
			type: 'POST',
			url: '${pageContext.request.contextPath}/unitParams/getRepeat',
			data: {
				"id": selectedID,
				"type": selectedType,
				"address": $("#selectedAddress").val()
			},
			success: function(d) {
				sentMessage(d, "查询中，请稍候...");
			}
		});
    }
   
    //查询终端时间
    function readTime(){
    	var selectedID = $.trim($("#selectedID").val());
    	var selectedType = $.trim($("#selectedType").val());
        if (selectedID == "") {
        	$.messager.alert("提示", "请选择节点。", "warning");
            return;
        }
        $.ajax({
			type: 'POST',
			url: '${pageContext.request.contextPath}/unitParams/getTime',
			data: {
				"id": selectedID,
				"type": selectedType,
				"address": $("#selectedAddress").val()
			},
			success: function(d) {
				sentMessage(d, "查询中，请稍候...");
			}
		});
    }

    //查询电流互感器变比
    function readCtr(){
    	var selectedID = $.trim($("#selectedID").val());
    	var selectedType = $.trim($("#selectedType").val());
        if (selectedID == "") {
        	$.messager.alert("提示", "请选择节点。", "warning");
            return;
        }
        $.ajax({
			type: 'POST',
			url: '${pageContext.request.contextPath}/unitParams/getCtr',
			data: {
				"id": selectedID,
				"type": selectedType,
				"address": $("#selectedAddress").val()
			},
			success: function(d) {
				sentMessage(d, "查询中，请稍候...");
			}
		});
    }

    //查询接线模式字
    function readPower(){
    	var selectedID = $.trim($("#selectedID").val());
    	var selectedType = $.trim($("#selectedType").val());
        if (selectedID == "") {
        	$.messager.alert("提示", "请选择节点。", "warning");
            return;
        }
        $.ajax({
			type: 'POST',
			url: '${pageContext.request.contextPath}/unitParams/getPower',
			data: {
				"id": selectedID,
				"type": selectedType,
				"address": $("#selectedAddress").val()
			},
			success: function(d) {
				sentMessage(d, "查询中，请稍候...");
			}
		});
    }
    
    //清空返回结果
    function clearParamsResult(){
    	$("#paramsResult").html("");
    }
</script>
</body>
</html>