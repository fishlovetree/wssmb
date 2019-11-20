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
<title>事件阀值</title>
</head>
<body>

	<div id="result-head" class="easyui-layout" fit="true">
		<div region="north" style="height: 130px;" split="true">
			<table border="0" cellspacing="8" cellpadding="8">
				<tr>
					<td style="width:40px;">
						节点：
					</td>
					<td>
						<label id='eventnode'></label>
					</td>
                </tr>
			</table>
			<div id="electricButtonMeter" style="height:70px;display:none">
			    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="getThreshold(1)" title="查询"> </a>	
			    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="getThreshold(2)" title="查询">端子报警温度</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" onclick="getThreshold(3)" title="查询">端子恢复温度</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" onclick="getThreshold(4)" title="查询">跳闸温度</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" onclick="getThreshold(5)" title="查询">跳闸恢复温度</a>	
				<a href="javascript:void(0)" class="easyui-linkbutton" onclick="getThreshold(6)" title="查询">误差触发下限</a>
				
			</div>	
			<div id="electricButtonTeminal" style="height:70px;display:none">
				<a href="javascript:void(0)" class="easyui-linkbutton" onclick="getThreshold(2)" title="查询">端子报警温度</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" onclick="getThreshold(3)" title="查询">端子恢复温度</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" onclick="getThreshold(7)" title="查询">烟感浓度</a>	
			</div>			
		</div>
		<div region="center" title="结果<a href='javascript:void(0)' class='easyui-linkbutton' 
		style='float: right; width: 40px;' onclick='clearEventResult();'>清空</a>" split="true">
			<div id="eventResult" style="margin: 10px;"></div>
		</div>
	</div>
<script type="text/javascript">
    $(function(){
    	$("#eventnode").html(node.text);
    	switchButton(node.type);
    })
	
    //根据系统类型显示对应的div
	function switchButton(type){
    	$('#electricButtonMeter').css('display', 'none');
        $('#electricButtonTeminal').css('display', 'none');
    	if (type == 6){
            $('#electricButtonMeter').css('display', ''); 
    	}
    	if (type == 5){
    		 $('#electricButtonTeminal').css('display', ''); 
    	}    
	}
	
	//查询阀值-公共函数
	//eventtypecode:事件类型代码
	function getThreshold(eventtypecode){
		var selectedID = $.trim($("#selectedID").val()); //node.gid
    	var selectedType = $.trim($("#selectedType").val()); //node.type
        if (selectedID == "") {
        	$.messager.alert("提示", "请选择终端。", "warning");
            return;
        }
        $.ajax({
			type: 'POST',
			url: '${pageContext.request.contextPath}/eventThreshold/getThreshold',
			data: {
				"id": selectedID,
				"type": selectedType,
				"eventtypecode": eventtypecode
			},
			success: function(d) {
				sentMessage(d, "查询中，请稍候...");
			}
		});
	}

    //清空返回结果
    function clearEventResult(){
    	$("#eventResult").html("");
    }
</script>
</body>
</html>