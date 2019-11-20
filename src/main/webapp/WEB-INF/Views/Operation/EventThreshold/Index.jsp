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
<jsp:include page="../../Header.jsp"/>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/waitstyle.css"
	media="screen" type="text/css" />
<style type="text/css">
.left-td {
	width: 75px;
}

.read-result-tbl {
	margin: 0px;
	padding: 0px;
	font-size: 12px;
	color: #335169;
	background: #fff;
	border-top: 1px solid #a8c7ce;
	border-right: 1px solid #a8c7ce;
}

.read-result-tbl th, .read-result-tbl td {
	padding: 2px 5px 2px 5px;
	border-bottom: 1px solid #a8c7ce;
	border-left: 1px solid #a8c7ce;
	vertical-align: middle;
}
.data-unit-cls{
    padding-left:5px;
}
    .layout-split-west {
	    border-right: 1px solid #ccc;
	}
	.layout-split-north{
	    border-bottom: 1px solid #ccc;
	}
</style>
</head>
<body>
	<div class="easyui-layout" fit="true">
		<div id="west" region="west" iconCls="icon-organization" split="true" title="设备" style="width:284px;min-width:284px;" collapsible="true">
			<jsp:include page="../../CommonTree/termGprs_DeviceTree.jsp"/>
		</div>
		<div id="mainPanel" region="center" style="overflow-y: hidden">
			<div class="easyui-layout" fit="true">
				<div region="north" style="height: 220px;" split="true">
					<table border="0" cellspacing="8" cellpadding="8">
						<tr>
							<td class="tableHead_right" align="right">节点：</td>
							<td><input type="text" id='snode' class="easyui-textbox"
								readonly="readonly" style="width: 200px;" /> <input
								type="hidden" id="selectedID" /> <input type="hidden"
								id="selectedType" /> <input type="hidden"
								id="unitid" /><input type="hidden"
								id="customerid" />(注：请在左侧设备树上选择系统类型或者设备)</td>
						</tr>
					</table>
					<div id="electricDiv" style="width:100%;height:168px;display:none">
						<div class="easyui-tabs" id="electricTab" fit="true"
							data-options="tabPosition:'top'">
							<div title="电压过压">
								<form id="overVoltageForm" class="easyui-form" method="post">
									<table cellspacing="8" style="min-width: 450px;">
										<tr>
											<td class="left-td">触发下限:</td>
											<td><input type="text" class="easyui-numberbox"
												name="lowervalue"
												data-options="required:true,precision:1,min:0,max:999.9" />
												<span class="data-unit-cls">V</span>
											</td>
										</tr>
										<tr>
											<td class="left-td">延时时间:</td>
											<td><input type="text" class="easyui-numberbox"
												name="delaytime"
												data-options="required:true,min:0,max:99" />
												<span class="data-unit-cls">秒</span>
											</td>
										</tr>
										<tr>
											<td class="left-td"></td>
											<td><a href="javascript:void(0)"
												class="easyui-linkbutton" onclick="setOverVoltage()" title="设置">设置</a>
												<a href="javascript:void(0)" class="easyui-linkbutton"
												onclick="readOverVoltage()" title="查询">查询</a></td>
										</tr>
									</table>
								</form>
							</div>
							<div title="电压欠压">
								<form id="underVoltageForm" class="easyui-form" method="post">
									<table cellspacing="8" style="min-width: 500px;">
										<tr>
											<td class="left-td">触发下限:</td>
											<td><input type="text" class="easyui-numberbox"
												name="lowervalue"
												data-options="required:true,precision:1,min:0,max:999.9" />
												<span class="data-unit-cls">V</span>
											</td>
										</tr>
										<tr>
											<td class="left-td">延时时间:</td>
											<td><input type="text" class="easyui-numberbox"
												name="delaytime"
												data-options="required:true,min:0,max:99" />
												<span class="data-unit-cls">秒</span>
											</td>
										</tr>
										<tr>
											<td class="left-td"></td>
											<td><a href="javascript:void(0)"
												class="easyui-linkbutton" onclick="setUnderVoltage()" title="设置">设置</a>
												<a href="javascript:void(0)" class="easyui-linkbutton"
												onclick="readUnderVoltage()" title="查询">查询</a></td>
										</tr>
									</table>
								</form>
							</div>
							<div title="电流过流">
								<form id="overCurrentForm" class="easyui-form" method="post">
									<table cellspacing="8" style="min-width: 500px;">
										<tr>
											<td class="left-td">触发下限:</td>
											<td><input type="text" class="easyui-numberbox"
												name="lowervalue"
												data-options="required:true,precision:1,min:0,max:999.9" />
												<span class="data-unit-cls">A</span>
											</td>
										</tr>
										<tr>
											<td class="left-td">延时时间:</td>
											<td><input type="text" class="easyui-numberbox"
												name="delaytime"
												data-options="required:true,min:0,max:99" />
												<span class="data-unit-cls">秒</span>
											</td>
										</tr>
										<tr>
											<td class="left-td"></td>
											<td><a href="javascript:void(0)"
												class="easyui-linkbutton" onclick="setOverCurrent()" title="设置">设置</a>
												<a href="javascript:void(0)" class="easyui-linkbutton"
												onclick="readOverCurrent()" title="查询">查询</a></td>
										</tr>
									</table>
								</form>
							</div>
							<div title="功率过载">
								<form id="overPowerForm" class="easyui-form" method="post">
									<table cellspacing="8" style="min-width: 500px;">
										<tr>
											<td class="left-td">触发下限:</td>
											<td><input type="text" class="easyui-numberbox"
												name="lowervalue"
												data-options="required:true,precision:4,min:0,max:99.9999" />
												<span class="data-unit-cls">kW</span>
											</td>
										</tr>
										<tr>
											<td class="left-td">延时时间:</td>
											<td><input type="text" class="easyui-numberbox"
												name="delaytime"
												data-options="required:true,min:0,max:99" />
												<span class="data-unit-cls">秒</span>
											</td>
										</tr>
										<tr>
											<td class="left-td"></td>
											<td><a href="javascript:void(0)"
												class="easyui-linkbutton" onclick="setOverPower()" title="设置">设置</a>
												<a href="javascript:void(0)" class="easyui-linkbutton"
												onclick="readOverPower()" title="查询">查询</a></td>
										</tr>
									</table>
								</form>
							</div>
							<div title="功率因素超限">
								<form id="overPowerFactorForm" class="easyui-form" method="post">
									<table cellspacing="8" style="min-width: 500px;">
										<tr>
											<td class="left-td">触发下限:</td>
											<td><input type="text" class="easyui-numberbox"
												name="lowervalue"
												data-options="required:true,precision:3,min:0,max:9.999" />
											</td>
										</tr>
										<tr>
											<td class="left-td">延时时间:</td>
											<td><input type="text" class="easyui-numberbox"
												name="delaytime"
												data-options="required:true,min:0,max:99" />
												<span class="data-unit-cls">秒</span>
											</td>
										</tr>
										<tr>
											<td class="left-td"></td>
											<td><a href="javascript:void(0)"
												class="easyui-linkbutton" onclick="setOverPowerFactor()" title="设置">设置</a>
												<a href="javascript:void(0)" class="easyui-linkbutton"
												onclick="readOverPowerFactor()" title="查询">查询</a></td>
										</tr>
									</table>
								</form>
							</div>
							<div title="过温">
								<form id="overTemperatureForm" class="easyui-form" method="post">
									<table cellspacing="8" style="min-width: 500px;">
										<tr>
											<td class="left-td">触发下限1:</td>
											<td><input type="text" class="easyui-numberbox"
												name="lowervalue"
												data-options="required:true,precision:1,min:0,max:999.9" />
												<span class="data-unit-cls">℃</span>
											</td>
										</tr>
										<tr>
											<td class="left-td">触发下限2:</td>
											<td><input type="text" class="easyui-numberbox"
												name="lowervalue2"
												data-options="required:true,precision:1,min:0,max:999.9" />
												<span class="data-unit-cls">℃</span>
											</td>
										</tr>
										<tr>
											<td class="left-td">触发下限3:</td>
											<td><input type="text" class="easyui-numberbox"
												name="lowervalue3"
												data-options="required:true,precision:1,min:0,max:999.9" />
												<span class="data-unit-cls">℃</span>
											</td>
										</tr>
										<tr>
											<td class="left-td">延时时间:</td>
											<td><input type="text" class="easyui-numberbox"
												name="delaytime"
												data-options="required:true,min:0,max:99" />
												<span class="data-unit-cls">秒</span>
											</td>
										</tr>
										<tr>
											<td class="left-td"></td>
											<td><a href="javascript:void(0)"
												class="easyui-linkbutton" onclick="setOverTemperature()" title="设置">设置</a>
												<a href="javascript:void(0)" class="easyui-linkbutton"
												onclick="readOverTemperature()" title="查询">查询</a></td>
										</tr>
									</table>
								</form>
							</div>
							<div title="剩余电流超限">
								<form id="overResidualCurrentForm" class="easyui-form" method="post">
									<table cellspacing="8" style="min-width: 500px;">
										<tr>
											<td class="left-td">触发下限:</td>
											<td><input type="text" class="easyui-numberbox"
												name="lowervalue"
												data-options="required:true,precision:3,min:0,max:9.999" />
												<span class="data-unit-cls">A</span>
											</td>
										</tr>
										<tr>
											<td class="left-td">延时时间:</td>
											<td><input type="text" class="easyui-numberbox"
												name="delaytime"
												data-options="required:true,min:0,max:99" />
												<span class="data-unit-cls">秒</span>
											</td>
										</tr>
										<tr>
											<td class="left-td"></td>
											<td><a href="javascript:void(0)"
												class="easyui-linkbutton" onclick="setOverResidualCurrent()" title="设置">设置</a>
												<a href="javascript:void(0)" class="easyui-linkbutton"
												onclick="readOverResidualCurrent()" title="查询">查询</a></td>
										</tr>
									</table>
								</form>
							</div>
							<div title="时钟电池欠压">
								<form id="clockBatteryForm" class="easyui-form" method="post">
									<table cellspacing="8" style="min-width: 500px;">
										<tr>
											<td class="left-td">触发下限:</td>
											<td><input type="text" class="easyui-numberbox"
												name="lowervalue"
												data-options="required:true,precision:2,min:0,max:99.99" />
												<span class="data-unit-cls">V</span>
											</td>
										</tr>
										<tr>
											<td class="left-td">延时时间:</td>
											<td><input type="text" class="easyui-numberbox"
												name="delaytime"
												data-options="required:true,min:0,max:99" />
												<span class="data-unit-cls">秒</span>
											</td>
										</tr>
										<tr>
											<td class="left-td"></td>
											<td><a href="javascript:void(0)"
												class="easyui-linkbutton" onclick="setClockBattery()" title="设置">设置</a>
												<a href="javascript:void(0)" class="easyui-linkbutton"
												onclick="readClockBattery()" title="查询">查询</a></td>
										</tr>
									</table>
								</form>
							</div>
							<div title="抄表电池欠压">
								<form id="meterReadingBatteryForm" class="easyui-form" method="post">
									<table cellspacing="8" style="min-width: 500px;">
										<tr>
											<td class="left-td">触发下限:</td>
											<td><input type="text" class="easyui-numberbox"
												name="lowervalue"
												data-options="required:true,precision:2,min:0,max:99.99" />
												<span class="data-unit-cls">V</span>
											</td>
										</tr>
										<tr>
											<td class="left-td">延时时间:</td>
											<td><input type="text" class="easyui-numberbox"
												name="delaytime"
												data-options="required:true,min:0,max:99" />
												<span class="data-unit-cls">秒</span>
											</td>
										</tr>
										<tr>
											<td class="left-td"></td>
											<td><a href="javascript:void(0)"
												class="easyui-linkbutton" onclick="setMeterReadingBattery()" title="设置">设置</a>
												<a href="javascript:void(0)" class="easyui-linkbutton"
												onclick="readMeterReadingBattery()" title="查询">查询</a></td>
										</tr>
									</table>
								</form>
							</div>
							<div title="温升">
								<form id="temperatureUpForm" class="easyui-form" method="post">
									<table cellspacing="8" style="min-width: 500px;">
										<tr>
											<td class="left-td">基准温度值:</td>
											<td><input type="text" class="easyui-numberbox"
												name="lowervalue2"
												data-options="required:true,min:0,max:99" />
												<span class="data-unit-cls">℃</span>
											</td>
										</tr>										
										<tr>
											<td class="left-td">触发下限:</td>
											<td><input type="text" class="easyui-numberbox"
												name="lowervalue"
												data-options="required:true,min:0,max:99" />
												<span class="data-unit-cls">℃</span>
											</td>
										</tr>
										<tr>
											<td class="left-td">延时时间:</td>
											<td><input type="text" class="easyui-numberbox"
												name="delaytime"
												data-options="required:true,min:0,max:99" />
												<span class="data-unit-cls">秒</span>
											</td>
										</tr>
										<tr>
											<td class="left-td"></td>
											<td><a href="javascript:void(0)"
												class="easyui-linkbutton" onclick="setTemperatureUp()" title="设置">设置</a>
												<a href="javascript:void(0)" class="easyui-linkbutton"
												onclick="readTemperatureUp()" title="查询">查询</a></td>
										</tr>
									</table>
								</form>
							</div>
						</div>
					</div>
					<div id="gasDiv" style="width:100%;height:168px;display:none">
						<div class="easyui-tabs" id="gasTab" fit="true"
							data-options="tabPosition:'top'">
							<div title="燃气浓度超限">
								<form id="overGasForm" class="easyui-form" method="post">
									<table cellspacing="8" style="min-width: 500px;">
										<tr>
											<td class="left-td">触发下限:</td>
											<td><input type="text" class="easyui-numberbox"
												name="lowervalue"
												data-options="required:true,precision:2,min:0,max:99.99" />
												<span class="data-unit-cls">%</span>
											</td>
										</tr>
										<tr>
											<td class="left-td">延时时间:</td>
											<td><input type="text" class="easyui-numberbox"
												name="delaytime"
												data-options="required:true,min:0,max:99" />
												<span class="data-unit-cls">秒</span>
											</td>
										</tr>
										<tr>
											<td class="left-td"></td>
											<td><a href="javascript:void(0)"
												class="easyui-linkbutton" onclick="setOverGas()" title="设置">设置</a>
												<a href="javascript:void(0)" class="easyui-linkbutton"
												onclick="readOverGas()" title="查询">查询</a></td>
										</tr>
									</table>
								</form>
							</div>
							<div title="燃气监测系统电池欠压">
								<form id="gasBatteryForm" class="easyui-form" method="post">
									<table cellspacing="8" style="min-width: 500px;">
										<tr>
											<td class="left-td">触发下限:</td>
											<td><input type="text" class="easyui-numberbox"
												name="lowervalue"
												data-options="required:true,precision:1,min:0,max:999.9" />
												<span class="data-unit-cls">V</span>
											</td>
										</tr>
										<tr>
											<td class="left-td">延时时间:</td>
											<td><input type="text" class="easyui-numberbox"
												name="delaytime"
												data-options="required:true,min:0,max:99" />
												<span class="data-unit-cls">秒</span>
											</td>
										</tr>
										<tr>
											<td class="left-td"></td>
											<td><a href="javascript:void(0)"
												class="easyui-linkbutton" onclick="setGasBattery()" title="设置">设置</a>
												<a href="javascript:void(0)" class="easyui-linkbutton"
												onclick="readGasBattery()" title="查询">查询</a></td>
										</tr>
									</table>
								</form>
							</div>
						</div>
					</div>
					<div id="smokeDiv" style="width:100%;height:168px;display:none">
						<div class="easyui-tabs" id="smokeTab" fit="true"
							data-options="tabPosition:'top'">
							<div title="烟感浓度超限">
								<form id="overSmokeForm" class="easyui-form" method="post">
									<table cellspacing="8" style="min-width: 500px;">
										<tr>
											<td class="left-td">触发下限:</td>
											<td><input type="text" class="easyui-numberbox"
												name="lowervalue"
												data-options="required:true,precision:1,min:0,max:999.9" />
												<span class="data-unit-cls">%</span>
											</td>
										</tr>
										<tr>
											<td class="left-td">延时时间:</td>
											<td><input type="text" class="easyui-numberbox"
												name="delaytime"
												data-options="required:true,min:0,max:99" />
												<span class="data-unit-cls">秒</span>
											</td>
										</tr>
										<tr>
											<td class="left-td"></td>
											<td><a href="javascript:void(0)"
												class="easyui-linkbutton" onclick="setOverSmoke()" title="设置">设置</a>
												<a href="javascript:void(0)" class="easyui-linkbutton"
												onclick="readOverSmoke()" title="查询">查询</a></td>
										</tr>
									</table>
								</form>
							</div>
							<div title="烟感监测系统电池欠压">
								<form id="smokeBatteryForm" class="easyui-form" method="post">
									<table cellspacing="8" style="min-width: 500px;">
										<tr>
											<td class="left-td">触发下限:</td>
											<td><input type="text" class="easyui-numberbox"
												name="lowervalue"
												data-options="required:true,precision:2,min:0,max:99.99" />
												<span class="data-unit-cls">V</span>
											</td>
										</tr>
										<tr>
											<td class="left-td">延时时间:</td>
											<td><input type="text" class="easyui-numberbox"
												name="delaytime"
												data-options="required:true,min:0,max:99" />
												<span class="data-unit-cls">秒</span>
											</td>
										</tr>
										<tr>
											<td class="left-td"></td>
											<td><a href="javascript:void(0)"
												class="easyui-linkbutton" onclick="setSmokeBattery()" title="设置">设置</a>
												<a href="javascript:void(0)" class="easyui-linkbutton"
												onclick="readSmokeBattery()" title="查询">查询</a></td>
										</tr>
									</table>
								</form>
							</div>
						</div>
					</div>
					<div id="waterPressureDiv" style="width:100%;height:168px;display:none">
						<div class="easyui-tabs" id="waterPressureTab" fit="true"
							data-options="tabPosition:'top'">
							<div title="水压过压">
								<form id="overWaterPressureForm" class="easyui-form" method="post">
									<table cellspacing="8" style="min-width: 500px;">
										<tr>
											<td class="left-td">触发下限:</td>
											<td><input type="text" class="easyui-numberbox"
												name="lowervalue"
												data-options="required:true,precision:3,min:0,max:9.999" />
												<span class="data-unit-cls">MPa</span>
											</td>
										</tr>
										<tr>
											<td class="left-td">延时时间:</td>
											<td><input type="text" class="easyui-numberbox"
												name="delaytime"
												data-options="required:true,min:0,max:99" />
												<span class="data-unit-cls">秒</span>
											</td>
										</tr>
										<tr>
											<td class="left-td"></td>
											<td><a href="javascript:void(0)"
												class="easyui-linkbutton" onclick="setOverWaterPressure()" title="设置">设置</a>
												<a href="javascript:void(0)" class="easyui-linkbutton"
												onclick="readOverWaterPressure()" title="查询">查询</a></td>
										</tr>
									</table>
								</form>
							</div>
							<div title="水压欠压">
								<form id="underWaterPressureForm" class="easyui-form" method="post">
									<table cellspacing="8" style="min-width: 500px;">
										<tr>
											<td class="left-td">触发下限:</td>
											<td><input type="text" class="easyui-numberbox"
												name="lowervalue"
												data-options="required:true,precision:3,min:0,max:9.999" />
												<span class="data-unit-cls">MPa</span>
											</td>
										</tr>
										<tr>
											<td class="left-td">延时时间:</td>
											<td><input type="text" class="easyui-numberbox"
												name="delaytime"
												data-options="required:true,min:0,max:99" />
												<span class="data-unit-cls">秒</span>
											</td>
										</tr>
										<tr>
											<td class="left-td"></td>
											<td><a href="javascript:void(0)"
												class="easyui-linkbutton" onclick="setUnderWaterPressure()" title="设置">设置</a>
												<a href="javascript:void(0)" class="easyui-linkbutton"
												onclick="readUnderWaterPressure()" title="查询">查询</a></td>
										</tr>
									</table>
								</form>
							</div>
							<div title="水压监测系统电池欠压">
								<form id="waterPressureBatteryForm" class="easyui-form" method="post">
									<table cellspacing="8" style="min-width: 500px;">
										<tr>
											<td class="left-td">触发下限:</td>
											<td><input type="text" class="easyui-numberbox"
												name="lowervalue"
												data-options="required:true,precision:2,min:0,max:99.99" />
												<span class="data-unit-cls">V</span>
											</td>
										</tr>
										<tr>
											<td class="left-td">延时时间:</td>
											<td><input type="text" class="easyui-numberbox"
												name="delaytime"
												data-options="required:true,min:0,max:99" />
												<span class="data-unit-cls">秒</span>
											</td>
										</tr>
										<tr>
											<td class="left-td"></td>
											<td><a href="javascript:void(0)"
												class="easyui-linkbutton" onclick="setWaterPressureBattery()" title="设置">设置</a>
												<a href="javascript:void(0)" class="easyui-linkbutton"
												onclick="readWaterPressureBattery()" title="查询">查询</a></td>
										</tr>
									</table>
								</form>
							</div>
						</div>
					</div>
					<div id="waterLineDiv" style="width:100%;height:168px;display:none">
						<div class="easyui-tabs" id="waterLineTab" fit="true"
							data-options="tabPosition:'top'">
							<div title="超水位预警">
								<form id="highWaterLineForm" class="easyui-form" method="post">
									<table cellspacing="8" style="min-width: 500px;">
										<tr>
											<td class="left-td">触发下限:</td>
											<td><input type="text" class="easyui-numberbox"
												name="lowervalue"
												data-options="required:true,precision:2,min:0,max:99.99" />
												<span class="data-unit-cls">米</span>
											</td>
										</tr>
										<tr>
											<td class="left-td">延时时间:</td>
											<td><input type="text" class="easyui-numberbox"
												name="delaytime"
												data-options="required:true,min:0,max:99" />
												<span class="data-unit-cls">秒</span>
											</td>
										</tr>
										<tr>
											<td class="left-td"></td>
											<td><a href="javascript:void(0)"
												class="easyui-linkbutton" onclick="setHighWaterLine()" title="设置">设置</a>
												<a href="javascript:void(0)" class="easyui-linkbutton"
												onclick="readHighWaterLine()" title="查询">查询</a></td>
										</tr>
									</table>
								</form>
							</div>
							<div title="低水位预警">
								<form id="lowWaterLineForm" class="easyui-form" method="post">
									<table cellspacing="8" style="min-width: 500px;">
										<tr>
											<td class="left-td">触发下限:</td>
											<td><input type="text" class="easyui-numberbox"
												name="lowervalue"
												data-options="required:true,precision:2,min:0,max:99.99" />
												<span class="data-unit-cls">米</span>
											</td>
										</tr>
										<tr>
											<td class="left-td">延时时间:</td>
											<td><input type="text" class="easyui-numberbox"
												name="delaytime"
												data-options="required:true,min:0,max:99" />
												<span class="data-unit-cls">秒</span>
											</td>
										</tr>
										<tr>
											<td class="left-td"></td>
											<td><a href="javascript:void(0)"
												class="easyui-linkbutton" onclick="setLowWaterLine()" title="设置">设置</a>
												<a href="javascript:void(0)" class="easyui-linkbutton"
												onclick="readLowWaterLine()" title="查询">查询</a></td>
										</tr>
									</table>
								</form>
							</div>
							<div title="水位监测系统电池欠压">
								<form id="waterLineBatteryForm" class="easyui-form" method="post">
									<table cellspacing="8" style="min-width: 500px;">
										<tr>
											<td class="left-td">触发下限:</td>
											<td><input type="text" class="easyui-numberbox"
												name="lowervalue"
												data-options="required:true,precision:2,min:0,max:99.99" />
												<span class="data-unit-cls">V</span>
											</td>
										</tr>
										<tr>
											<td class="left-td">延时时间:</td>
											<td><input type="text" class="easyui-numberbox"
												name="delaytime"
												data-options="required:true,min:0,max:99" />
												<span class="data-unit-cls">秒</span>
											</td>
										</tr>
										<tr>
											<td class="left-td"></td>
											<td><a href="javascript:void(0)"
												class="easyui-linkbutton" onclick="setWaterLineBattery()" title="设置">设置</a>
												<a href="javascript:void(0)" class="easyui-linkbutton"
												onclick="readWaterLineBattery()" title="查询">查询</a></td>
										</tr>
									</table>
								</form>
							</div>
						</div>
					</div>
					<div id="alarmSystemDiv" style="width:100%;height:168px;display:none">
						<div class="easyui-tabs" id="alarmSystemTab" fit="true"
							data-options="tabPosition:'top'">
							<div title="报警按钮电池欠压">
								<form id="alarmButtonBatteryForm" class="easyui-form" method="post">
									<table cellspacing="8" style="min-width: 500px;">
										<tr>
											<td class="left-td">触发下限:</td>
											<td><input type="text" class="easyui-numberbox"
												name="lowervalue"
												data-options="required:true,precision:2,min:0,max:99.99" />
												<span class="data-unit-cls">V</span>
											</td>
										</tr>
										<tr>
											<td class="left-td">延时时间:</td>
											<td><input type="text" class="easyui-numberbox"
												name="delaytime"
												data-options="required:true,min:0,max:99" />
												<span class="data-unit-cls">秒</span>
											</td>
										</tr>
										<tr>
											<td class="left-td"></td>
											<td><a href="javascript:void(0)"
												class="easyui-linkbutton" onclick="setAlarmButtonBattery()" title="设置">设置</a>
												<a href="javascript:void(0)" class="easyui-linkbutton"
												onclick="readAlarmButtonBattery()" title="查询">查询</a></td>
										</tr>
									</table>
								</form>
							</div>
							<div title="声光报警电池欠压">
								<form id="alarmDeviceBatteryForm" class="easyui-form" method="post">
									<table cellspacing="8" style="min-width: 500px;">
										<tr>
											<td class="left-td">触发下限:</td>
											<td><input type="text" class="easyui-numberbox"
												name="lowervalue"
												data-options="required:true,precision:2,min:0,max:99.99" />
												<span class="data-unit-cls">V</span>
											</td>
										</tr>
										<tr>
											<td class="left-td">延时时间:</td>
											<td><input type="text" class="easyui-numberbox"
												name="delaytime"
												data-options="required:true,min:0,max:99" />
												<span class="data-unit-cls">秒</span>
											</td>
										</tr>
										<tr>
											<td class="left-td"></td>
											<td><a href="javascript:void(0)"
												class="easyui-linkbutton" onclick="setAlarmDeviceBattery()" title="设置">设置</a>
												<a href="javascript:void(0)" class="easyui-linkbutton"
												onclick="readAlarmDeviceBattery()" title="查询">查询</a></td>
										</tr>
									</table>
								</form>
							</div>
						</div>
					</div>
					<div id="fireplugDiv" style="width:100%;height:168px;display:none">
						<div class="easyui-tabs" id="fireplugTab" fit="true"
							data-options="tabPosition:'top'">
							<div title="消防栓电池欠压">
								<form id="fireplugBatteryForm" class="easyui-form" method="post">
									<table cellspacing="8" style="min-width: 500px;">
										<tr>
											<td class="left-td">触发下限:</td>
											<td><input type="text" class="easyui-numberbox"
												name="lowervalue"
												data-options="required:true,precision:2,min:0,max:99.99" />
												<span class="data-unit-cls">V</span>
											</td>
										</tr>
										<tr>
											<td class="left-td">延时时间:</td>
											<td><input type="text" class="easyui-numberbox"
												name="delaytime"
												data-options="required:true,min:0,max:99" />
												<span class="data-unit-cls">秒</span>
											</td>
										</tr>
										<tr>
											<td class="left-td"></td>
											<td><a href="javascript:void(0)"
												class="easyui-linkbutton" onclick="setFireplugBattery()" title="设置">设置</a>
												<a href="javascript:void(0)" class="easyui-linkbutton"
												onclick="readFireplugBattery()" title="查询">查询</a></td>
										</tr>
									</table>
								</form>
							</div>
						</div>
					</div>
					<div id="fireDoorDiv" style="width:100%;height:168px;display:none">
						<div class="easyui-tabs" id="fireDoorTab" fit="true"
							data-options="tabPosition:'top'">
							<div title="防火门电池欠压">
								<form id="fireDoorBatteryForm" class="easyui-form" method="post">
									<table cellspacing="8" style="min-width: 500px;">
										<tr>
											<td class="left-td">触发下限:</td>
											<td><input type="text" class="easyui-numberbox"
												name="lowervalue"
												data-options="required:true,precision:2,min:0,max:99.99" />
												<span class="data-unit-cls">V</span>
											</td>
										</tr>
										<tr>
											<td class="left-td">延时时间:</td>
											<td><input type="text" class="easyui-numberbox"
												name="delaytime"
												data-options="required:true,min:0,max:99" />
												<span class="data-unit-cls">秒</span>
											</td>
										</tr>
										<tr>
											<td class="left-td"></td>
											<td><a href="javascript:void(0)"
												class="easyui-linkbutton" onclick="setFireDoorBattery()" title="设置">设置</a>
												<a href="javascript:void(0)" class="easyui-linkbutton"
												onclick="readFireDoorBattery()" title="查询">查询</a></td>
										</tr>
									</table>
								</form>
							</div>
						</div>
					</div>
				</div>
				<div region="center"
					title="结果<a href='javascript:void(0)' class='easyui-linkbutton' style='float: right; width: 40px;' 
		        onclick='clearResult();'>清空</a>"
					split="true">
					<div id="resultPanel" style="margin: 10px;"></div>
				</div>
			</div>
		</div>
	</div>
	<div id="p" style="width:400px;"></div>
<script type="text/javascript">
	//websocket相关
	var ws;
	var port = '0'; //前一次端口号，断线重连时用到
	var frameNumber = 1; //帧序号
	
	var sendXmlCount = 0; //发送到前置机总数量
	var msgCount = 0; //接收到前置机消息数量
	var progressBar; //进度条
	var setAgain = 0;
	//初始化进度条参数
	function initProgress() {
		sendXmlCount = 0;
		msgCount = 0;
	    progressBar = undefined;
	    $.messager.progress('close');
	}
	
	//用于使chart自适应高度和宽度,通过窗体高宽计算容器高宽
	var resizeDiv = function () {
		width=$('#west').width();//当有title时，width:284px;min-width:284px;；反之，则width:280px;min-width:280px;
		height=$('#west').height();
		if(window.innerHeight<height)
			height=window.innerHeight-38;//当有title时，window.innerHeight-38；反之，则window.innerHeight
		$('#left-table').width(width);
		$('#left-table').height(height);
		$('#left-tree').width(width);
		$('#left-tree').height(height-33);
		
		$('#tree_tab').tabs({
	        width : width,
	        height : height-58
	    }).tabs('resize');
		$('#region_tab').height(height-62);
		$('#org_tab').height(height-62);
	};

    $(function(){
    	resizeDiv();
    	
    	$("#west").panel({
            onResize: function (w, h) {
            	resizeDiv();
            }
        });
    	
    	$(window).resize(function(){ //浏览器窗口变化 
    		resizeDiv();
    	});
    	
    	//websocket
    	connect();
    })
    
    var treeTab = $('#region_tree');
	//公用树点击事件
	var node;
	function treeClick(treeObj, n){
		if(typeof n!='undefined' ){
			node=n;
			treeTab = treeObj;
			if (node.type >= commonTreeNodeType.gprsBigType){ //消防监测终端大类及设备；智慧用电终端大类及设备
        		$("#snode").textbox('setValue', node.text);
                $("#selectedID").val(node.gid);
                $("#selectedType").val(node.type);
                var sysType; //系统类型
                switch (node.type){
                    case commonTreeNodeType.gprsBigType: //gprs大类
                    	var pnode = treeTab.tree('getParent', node.target);
                    	$("#customerid").val(pnode.gid);
                    	sysType = node.gid;
                    	break;
                    case commonTreeNodeType.gprsDevice: //gprs设备
                        var pnode = treeTab.tree('getParent', node.target);
                        sysType = pnode.gid;
                    	break;
                    case commonTreeNodeType.terminalBigType: //消防监测终端大类
                        var pnode = treeTab.tree('getParent', node.target);
                        $("#unitid").val(pnode.gid);
                        sysType = node.gid;
                    	break;
                    case commonTreeNodeType.terminalDevice: //消防监测终端设备
                        var pnode = treeTab.tree('getParent', node.target);
                        sysType = pnode.gid;
                    	break;
                }
                //根据系统类型控制显示
                switchDiv(sysType);
        	}	
		}
	}

    //根据系统类型显示对应的div
	function switchDiv(sysType){
        switch(sysType){
        case 10: //电气火灾监控系统
            $('#electricDiv').css('display', '');
            $('#gasDiv').css('display', 'none');
            $('#smokeDiv').css('display', 'none');
            $('#waterPressureDiv').css('display', 'none');
            $('#waterLineDiv').css('display', 'none');
            $('#alarmSystemDiv').css('display', 'none');
            $('#fireplugDiv').css('display', 'none');
            $('#fireDoorDiv').css('display', 'none');
        	break;
        case 11: //可燃气体报警系统
        	$('#electricDiv').css('display', 'none');
            $('#gasDiv').css('display', '');
            $('#smokeDiv').css('display', 'none');
            $('#waterPressureDiv').css('display', 'none');
            $('#waterLineDiv').css('display', 'none');
            $('#alarmSystemDiv').css('display', 'none');
            $('#fireplugDiv').css('display', 'none');
            $('#fireDoorDiv').css('display', 'none');
        	break;
        case 18: //防火门及防火卷帘系统
        	$('#electricDiv').css('display', 'none');
            $('#gasDiv').css('display', 'none');
            $('#smokeDiv').css('display', 'none');
            $('#waterPressureDiv').css('display', 'none');
            $('#waterLineDiv').css('display', 'none');
            $('#alarmSystemDiv').css('display', 'none');
            $('#fireplugDiv').css('display', 'none');
            $('#fireDoorDiv').css('display', '');
        	break;
        case 20: //消火栓系统
        	$('#electricDiv').css('display', 'none');
            $('#gasDiv').css('display', 'none');
            $('#smokeDiv').css('display', 'none');
            $('#waterPressureDiv').css('display', 'none');
            $('#waterLineDiv').css('display', 'none');
            $('#alarmSystemDiv').css('display', 'none');
            $('#fireplugDiv').css('display', '');
            $('#fireDoorDiv').css('display', 'none');
        	break;
        case 128: //烟雾监控系统
        	$('#electricDiv').css('display', 'none');
            $('#gasDiv').css('display', 'none');
            $('#smokeDiv').css('display', '');
            $('#waterPressureDiv').css('display', 'none');
            $('#waterLineDiv').css('display', 'none');
            $('#alarmSystemDiv').css('display', 'none');
            $('#fireplugDiv').css('display', 'none');
            $('#fireDoorDiv').css('display', 'none');
        	break;
        case 129: //消防水压监控系统
        	$('#electricDiv').css('display', 'none');
            $('#gasDiv').css('display', 'none');
            $('#smokeDiv').css('display', 'none');
            $('#waterPressureDiv').css('display', '');
            $('#waterLineDiv').css('display', 'none');
            $('#alarmSystemDiv').css('display', 'none');
            $('#fireplugDiv').css('display', 'none');
            $('#fireDoorDiv').css('display', 'none');
        	break;
        case 130: //报警按钮及声光报警器系统
        	$('#electricDiv').css('display', 'none');
            $('#gasDiv').css('display', 'none');
            $('#smokeDiv').css('display', 'none');
            $('#waterPressureDiv').css('display', 'none');
            $('#waterLineDiv').css('display', 'none');
            $('#alarmSystemDiv').css('display', '');
            $('#fireplugDiv').css('display', 'none');
            $('#fireDoorDiv').css('display', 'none');
        	break;
        case 131: //消防水位监控系统
        	$('#electricDiv').css('display', 'none');
            $('#gasDiv').css('display', 'none');
            $('#smokeDiv').css('display', 'none');
            $('#waterPressureDiv').css('display', 'none');
            $('#waterLineDiv').css('display', '');
            $('#alarmSystemDiv').css('display', 'none');
            $('#fireplugDiv').css('display', 'none');
            $('#fireDoorDiv').css('display', 'none');
        	break;
        default:
        	$('#electricDiv').css('display', 'none');
	        $('#gasDiv').css('display', 'none');
	        $('#smokeDiv').css('display', 'none');
	        $('#waterPressureDiv').css('display', 'none');
            $('#waterLineDiv').css('display', 'none');
            $('#alarmSystemDiv').css('display', 'none');
            $('#fireplugDiv').css('display', 'none');
            $('#fireDoorDiv').css('display', 'none');
        	break;
        }
	}
	
	//设置阀值-公共函数
	//formname:表单名
	//eventtypecode:事件类型代码
	function setThreshold(formname, eventtypecode){
		var selectedID = $.trim($("#selectedID").val());
    	var selectedType = $.trim($("#selectedType").val());
        if (selectedID == "") {
        	$.messager.alert("提示", "请选择节点。", "warning");
            return;
        }
        if (ws) {
            if (ws.readyState == 1) {
            	if ($('#' + formname).form('validate')){
            		var data = {};
            		if(eventtypecode==20){//过温
            			data = {
        						"id": selectedID,
        						"type": selectedType,
        						"eventtypecode": eventtypecode,
        						"unitid": $("#unitid").val(),
        						"customerid": $("#customerid").val(),
        						"lowervalue1": $('#' + formname + " input[name='lowervalue']").val(),
        						"lowervalue2": $('#' + formname + " input[name='lowervalue2']").val(),
        						"lowervalue3": $('#' + formname + " input[name='lowervalue3']").val(),
        						"delaytime": $('#' + formname + " input[name='delaytime']").val()
        					};
            		}else if(eventtypecode==24){//温升
            			data = {
        						"id": selectedID,
        						"type": selectedType,
        						"eventtypecode": eventtypecode,
        						"unitid": $("#unitid").val(),
        						"customerid": $("#customerid").val(),
        						"lowervalue1": $('#' + formname + " input[name='lowervalue']").val(),
        						"lowervalue2": $('#' + formname + " input[name='lowervalue2']").val(),
        						"delaytime": $('#' + formname + " input[name='delaytime']").val()
        					};
            		}else{
            			data = {
        						"id": selectedID,
        						"type": selectedType,
        						"eventtypecode": eventtypecode,
        						"unitid": $("#unitid").val(),
        						"customerid": $("#customerid").val(),
        						"lowervalue1": $('#' + formname + " input[name='lowervalue']").val(),
        						"delaytime": $('#' + formname + " input[name='delaytime']").val()
        					};
            		}
            		
            		$.ajax({
    					type: 'POST',
    					url: "${pageContext.request.contextPath}/eventThreshold/setThreshold",
    					data: data,
    					success: function(d) {
    						if (d != "") {
    	                        if (d.indexOf("html") > 0) { //session超时
    	                            parent.window.location.reload();
    	                        }
    	                        else {
    	                        	var a = JSON.parse(d);
	    							if (a.length > 0){
	    								setAgain = 0;
	    								initProgress();
		    							$.messager.progress({
		                                    title: '设置中，请稍后...',
		                                    interval: 0
		                                });
		                                progressBar = $.messager.progress('bar');
		                                sendXmlCount = a.length;
		    							for(var p in a){
		    								frameNumber++;
		    	                            //组帧，Global.js中定义
		    	                            var frame = makeWSFrame(frameNumber, 0, 1, 1, a[p], '');
		    	                            ws.send(frame);
		    							}
    								}
    	                        }
    						}
    					}
    				});
            	}
            }
            else {
            	$.messager.alert("警告", "通信异常，请刷新页面后重试。", "error");
            }
        }
        else {
        	$.messager.alert("警告", "您的浏览器不支持WebSocket。请选择其他的浏览器再尝试连接服务器。", "error");
        }
	}
	
	//查询阀值-公共函数
	//eventtypecode:事件类型代码
	function getThreshold(eventtypecode){
		var selectedID = $.trim($("#selectedID").val());
    	var selectedType = $.trim($("#selectedType").val());
        if (selectedID == "") {
        	$.messager.alert("提示", "请选择终端。", "warning");
            return;
        }
        if (ws) {
            if (ws.readyState == 1) {
		        $.ajax({
					type: 'POST',
					url: '${pageContext.request.contextPath}/eventThreshold/getThreshold',
					data: {
						"id": selectedID,
						"type": selectedType,
						"eventtypecode": eventtypecode,
						"unitid": $("#unitid").val(),
						"customerid": $("#customerid").val()
					},
					success: function(d) {
						if (d != "") {
			                if (d.indexOf("html") > 0) { //session超时
			                    parent.window.location.reload();
			                }
			                else {
			                	var a = JSON.parse(d);
								if (a.length > 0){
									setAgain = 50;
									$.messager.progress({
		                                title: '查询中，请稍候...',
		                                interval: 0
		                            });
		                            progressBar = $.messager.progress('bar');
		                            sendXmlCount = a.length;
									for(var p in a){
										frameNumber++;
			                            //组帧，Global.js中定义
			                            var frame = makeWSFrame(frameNumber, 0, 1, 1, a[p], '');
			                            ws.send(frame);
									}
								}
			                }
			            }
					}
				});
	        }
	        else {
	        	$.messager.alert("警告", "通信异常，请刷新页面后重试。", "error");
	        }
	    }
	    else {
	    	$.messager.alert("警告", "您的浏览器不支持WebSocket。请选择其他的浏览器再尝试连接服务器。", "error");
	    } 
	}

    //设置电压过压阀值
    function setOverVoltage(){
    	setThreshold("overVoltageForm", 1);
    }
    
    //查询电压过压阀值
    function readOverVoltage(){
    	getThreshold(1);
    }
    
    //设置电压欠压阀值
    function setUnderVoltage(){
    	setThreshold("underVoltageForm", 2);
    }
    
    //查询电压欠压阀值
    function readUnderVoltage(){
    	getThreshold(2);
    }
    
    //设置电流过流阀值
    function setOverCurrent(){
    	setThreshold("overCurrentForm", 3);
    }
    
    //查询电流过流阀值
    function readOverCurrent(){
    	getThreshold(3);
    }
    
    //设置功率过载阀值
    function setOverPower(){
    	setThreshold("overPowerForm", 4);
    }
    
    //查询功率过载阀值
    function readOverPower(){
    	getThreshold(4);
    }
    
    //设置功率因素超限阀值
    function setOverPowerFactor(){
    	setThreshold("overPowerFactorForm", 5);
    }
    
    //查询功率因素超限阀值
    function readOverPowerFactor(){
    	getThreshold(5);
    }
    
    //设置过温阀值
    function setOverTemperature(){
    	setThreshold("overTemperatureForm", 20);
    }
    
    //查询过温阀值
    function readOverTemperature(){
    	getThreshold(20);
    }
    
    //设置剩余电流超限阀值
    function setOverResidualCurrent(){
    	setThreshold("overResidualCurrentForm", 21);
    }
    
    //查询剩余电流超限阀值
    function readOverResidualCurrent(){
    	getThreshold(21);
    }
    
    //设置时钟电池欠压阀值
    function setClockBattery(){
    	setThreshold("clockBatteryForm", 22);
    }
    
    //查询时钟电池欠压阀值
    function readClockBattery(){
    	getThreshold(22);
    }
    
    //设置抄表电池欠压阀值
    function setMeterReadingBattery(){
    	setThreshold("meterReadingBatteryForm", 23);
    }
    
    //查询抄表电池欠压阀值
    function readMeterReadingBattery(){
    	getThreshold(23);
    }
    
    //设置温升判断阀值
    function setTemperatureUp(){
    	setThreshold("temperatureUpForm", 24);
    }
    
    //查询温升判断阀值
    function readTemperatureUp(){
    	getThreshold(24);
    }
    
    //设置水压过压阀值
    function setOverWaterPressure(){
    	setThreshold("overWaterPressureForm", 30);
    }
    
    //查询水压过压阀值
    function readOverWaterPressure(){
    	getThreshold(30);
    }
    
    //设置水压欠压阀值
    function setUnderWaterPressure(){
    	setThreshold("underWaterPressureForm", 31);
    }
    
    //查询水压欠压阀值
    function readUnderWaterPressure(){
    	getThreshold(31);
    }
    
    //设置水压监测系统电池欠压阀值
    function setWaterPressureBattery(){
    	setThreshold("waterPressureBatteryForm", 32);
    }
    
    //查询水压监测系统电池欠压阀值
    function readWaterPressureBattery(){
    	getThreshold(32);
    }
    
    //设置烟感浓度超限阀值
    function setOverSmoke(){
    	setThreshold("overSmokeForm", 40);
    }
    
    //查询烟感浓度超限阀值
    function readOverSmoke(){
    	getThreshold(40);
    }
    
    //设置烟感监测系统电池欠压阀值
    function setSmokeBattery(){
    	setThreshold("smokeBatteryForm", 41);
    }
    
    //查询烟感监测系统电池欠压阀值
    function readSmokeBattery(){
    	getThreshold(41);
    }
    
    //设置燃气浓度超限阀值
    function setOverGas(){
    	setThreshold("overGasForm", 50);
    }
    
    //查询燃气浓度超限阀值
    function readOverGas(){
    	getThreshold(50);
    }
    
    //设置燃气系统电池欠压阀值
    function setGasBattery(){
    	setThreshold("gasBatteryForm", 51);
    }
    
    //查询燃气系统电池欠压阀值
    function readGasBattery(){
    	getThreshold(51);
    }
    
    //设置高水位预警阀值
    function setHighWaterLine(){
    	setThreshold("highWaterLineForm", 60);
    }
    
    //查询高水位预警阀值
    function readHighWaterLine(){
    	getThreshold(60);
    }
    
    //设置低水位预警阀值
    function setLowWaterLine(){
    	setThreshold("lowWaterLineForm", 61);
    }
    
    //查询低水位预警阀值
    function readLowWaterLine(){
    	getThreshold(61);
    }
    
    //设置水位监测系统电池欠压阀值
    function setWaterLineBattery(){
    	setThreshold("waterLineBatteryForm", 62);
    }
    
    //查询水位监测系统电池欠压阀值
    function readWaterLineBattery(){
    	getThreshold(62);
    }
    
    //设置报警按钮电池欠压阀值
    function setAlarmButtonBattery(){
    	setThreshold("alarmButtonBatteryForm", 70);
    }
    
    //查询报警按钮电池欠压阀值
    function readAlarmButtonBattery(){
    	getThreshold(70);
    }
    
    //设置声光报警电池欠压阀值
    function setAlarmDeviceBattery(){
    	setThreshold("alarmDeviceBatteryForm", 71);
    }
    
    //查询声光报警电池欠压阀值
    function readAlarmDeviceBattery(){
    	getThreshold(71);
    }
    
    //设置消防栓电池欠压阀值
    function setFireplugBattery(){
    	setThreshold("fireplugBatteryForm", 72);
    }
    
    //查询消防栓电池欠压阀值
    function readFireplugBattery(){
    	getThreshold(72);
    }
    
    //设置防火门电池欠压阀值
    function setFireDoorBattery(){
    	setThreshold("fireDoorBatteryForm", 73);
    }
    
    //查询防火门电池欠压阀值
    function readFireDoorBattery(){
    	getThreshold(73);
    }
    
    //清空返回结果
    function clearResult(){
    	$("#resultPanel").html("");
    }
    
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
    	initProgress(); //初始化进度条
        //客户端端口组帧,帧类型为3（握手）
        var curPort = makeWSFrame(1, 0, 3, 1, port, '');
        ws.send(curPort);
    }

    function WSonMessage(event) {
        //console.log(event.data);
        var msg = event.data;
        //解析帧，Global.js中定义
        var frame = parseWSFrame(msg);
        if (frame == "") return;
        //帧类型为3（握手），表示端口号
        if (frame.type == '3') {
            port = frame.data;
        }
        else if (frame.type == '2') {  //帧类型为2（应答）
            if (frame.data.length.toString() == frame.len) { //判断是否接收到完整的数据帧
            	$.ajax({
					type: 'POST',
					url: '${pageContext.request.contextPath}/eventThreshold/parseResponse',
					data: {
						"strXML": frame.data
					},
					success: function(d) {
						
						if (progressBar && (d.result!=3 || (d.result==3 && setAgain == 50))) { //进度变更
			                msgCount++;
			                if (msgCount == sendXmlCount || frame.num.substr(1) == frameNumber) { //关闭进度条
			                    progressBar.progressbar("setValue", 100);
			                    setTimeout(function () {
			                        $.messager.progress('close');
			                    }, 800);
			                    initProgress();
			                }
			                else {
			                    var rate = 0;
			                    if (sendXmlCount != 0) rate = Math.floor(msgCount / sendXmlCount * 100);
			                    progressBar.progressbar("setValue", rate);
			                }
			            }
						
						switch(d.result){
						case 1:
							switch (d.typeFlagCode){
							case 132:case 139:
								switch(d.configurationCode){
								case 1:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>设置电压过压阀值成功。</div>");
									break;
								case 2:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>设置电压欠压阀值成功。</div>");
									break;
								case 3:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>设置电流过流阀值成功。</div>");
									break;
								case 4:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>设置功率过载阀值成功。</div>");
									break;
								case 5:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>设置功率因素超限阀值成功。</div>");
									break;
								case 20:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>设置过温阀值成功。</div>");
									break;
								case 21:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>设置剩余电流超限阀值成功。</div>");
									break;
								case 22:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>设置时钟电池欠压阀值成功。</div>");
									break;
								case 23:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>设置抄表电池欠压阀值成功。</div>");
									break;
								case 23:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>设置抄表电池欠压阀值成功。</div>");
									break;
								case 24:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>设置温升判断阀值成功。</div>");
									break;
								case 30:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>设置水压过压阀值成功。</div>");
									break;
								case 31:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>设置水压欠压阀值成功。</div>");
									break;
								case 32:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>设置水压监测系统电池欠压阀值成功。</div>");
									break;
								case 40:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>设置烟感浓度超限阀值成功。</div>");
									break;
								case 41:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>设置烟感监测系统电池欠压阀值成功。</div>");
									break;
								case 50:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>设置燃气浓度超限阀值成功。</div>");
									break;
								case 51:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>设置燃气监测系统电池欠压阀值成功。</div>");
									break;
								case 60:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>设置高水位预警阀值成功。</div>");
									break;
								case 61:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>设置低水位预警阀值成功。</div>");
									break;
								case 62:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>设置水位监测系统电池欠压阀值成功。</div>");
									break;
								case 70:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>设置报警按钮电池欠压阀值成功。</div>");
									break;
								case 71:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>设置声光报警电池欠压阀值成功。</div>");
									break;
								case 72:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>设置消防栓电池欠压阀值成功。</div>");
									break;
								case 73:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>设置防火门电池欠压阀值成功。</div>");
									break;
								}
								break;
							case 210:
								switch(d.configurationCode){
								case 1:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>查询电压过压阀值成功。</div>");
									break;
								case 2:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>查询电压欠压阀值成功。</div>");
									break;
								case 3:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>查询电流过流阀值成功。</div>");
									break;
								case 4:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>查询功率过载阀值成功。</div>");
									break;
								case 5:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>查询功率因素超限阀值成功。</div>");
									break;
								case 20:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>查询过温阀值成功。</div>");
									break;
								case 21:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>查询剩余电流超限阀值成功。</div>");
									break;
								case 22:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>查询时钟电池欠压阀值成功。</div>");
									break;
								case 23:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>查询抄表电池欠压阀值成功。</div>");
									break;
								case 24:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>查询温升判断阀值成功。</div>");
									break;
								case 30:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>查询水压过压阀值成功。</div>");
									break;
								case 31:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>查询水压欠压阀值成功。</div>");
									break;
								case 32:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>查询水压监测系统电池欠压阀值成功。</div>");
									break;
								case 40:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>查询烟感浓度超限阀值成功。</div>");
									break;
								case 41:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>查询烟感监测系统电池欠压阀值成功。</div>");
									break;
								case 50:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>查询燃气浓度超限阀值成功。</div>");
									break;
								case 51:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>查询燃气监测系统电池欠压阀值成功。</div>");
									break;
								case 60:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>查询高水位预警阀值成功。</div>");
									break;
								case 61:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>查询低水位预警阀值成功。</div>");
									break;
								case 62:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>查询水位监测系统电池欠压阀值成功。</div>");
									break;
								case 70:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>查询报警按钮电池欠压阀值成功。</div>");
									break;
								case 71:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>查询声光报警电池欠压阀值成功。</div>");
									break;
								case 72:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>查询消防栓电池欠压阀值成功。</div>");
									break;
								case 73:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>查询防火门电池欠压阀值成功。</div>");
									break;
								}
								$.each(d.data, function(i, n){
									$("#resultPanel").prepend(n);
								});
								break;
							}
							break;
						case 2:
							$("#resultPanel").prepend("<div style='color:red;padding:5px'>终端连接超时。</div>");
							break;
						case 3:
							if (d.typeFlagCode==139 && d.data != "") {
								var data = d.data;
    	                        if (data.indexOf("html") <= 0) { //session超时
	    							if (data.length > 0){
	    								setAgain = 50;
		    							for(var p in data){
		    								frameNumber++;
		    	                            //组帧，Global.js中定义
		    	                            var frame = makeWSFrame(frameNumber, 0, 1, 1, data[p], '');
		    	                            ws.send(frame);
		    							}
    								}
    	                        }
    						}
							else
								$("#resultPanel").prepend("<div style='color:red;padding:5px'>终端否认应答。</div>");
							break;
						case 4:
							$("#resultPanel").prepend("<div style='color:red;padding:5px'>终端不在线。</div>");
							break;
						case 8:
							switch (d.typeFlagCode){
							case 132:case 139:
								switch(d.configurationCode){
								case 1:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置电压过压阀值失败。</div>");
									break;
								case 2:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置电压欠压阀值失败。</div>");
									break;
								case 3:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置电流过流阀值失败。</div>");
									break;
								case 4:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置功率过载阀值失败。</div>");
									break;
								case 5:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置功率因素超限阀值失败。</div>");
									break;
								case 20:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置过温阀值失败。</div>");
									break;
								case 21:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置剩余电流超限阀值失败。</div>");
									break;
								case 22:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置时钟电池欠压阀值失败。</div>");
									break;
								case 23:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置抄表电池欠压阀值失败。</div>");
									break;
								case 24:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置温升判断阀值失败。</div>");
									break;
								case 30:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置水压过压阀值失败。</div>");
									break;
								case 31:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置水压欠压阀值失败。</div>");
									break;
								case 32:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置水压监测系统电池欠压阀值失败。</div>");
									break;
								case 40:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置烟感浓度超限阀值失败。</div>");
									break;
								case 41:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置烟感监测系统电池欠压阀值失败。</div>");
									break;
								case 50:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置燃气浓度超限阀值失败。</div>");
									break;
								case 51:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置燃气监测系统电池欠压阀值失败。</div>");
									break;
								case 60:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置高水位预警阀值失败。</div>");
									break;
								case 61:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置低水位预警阀值失败。</div>");
									break;
								case 62:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置水位监测系统电池欠压阀值失败。</div>");
									break;
								case 70:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置报警按钮电池欠压阀值失败。</div>");
									break;
								case 71:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置声光报警电池欠压阀值失败。</div>");
									break;
								case 72:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置消防栓电池欠压阀值失败。</div>");
									break;
								case 73:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置防火门电池欠压阀值失败。</div>");
									break;
								}
								break;
							case 210:
								switch(d.configurationCode){
								case 1:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>查询电压过压阀值失败。</div>");
									break;
								case 2:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>查询电压欠压阀值失败。</div>");
									break;
								case 3:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>查询电流过流阀值失败。</div>");
									break;
								case 4:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>查询功率过载阀值失败。</div>");
									break;
								case 5:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>查询功率因素超限阀值失败。</div>");
									break;
								case 20:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>查询过温阀值失败。</div>");
									break;
								case 21:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>查询剩余电流超限阀值失败。</div>");
									break;
								case 22:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>查询时钟电池欠压阀值失败。</div>");
									break;
								case 23:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>查询抄表电池欠压阀值失败。</div>");
									break;
								case 24:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>查询温升判断阀值失败。</div>");
									break;
								case 30:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>查询水压过压阀值失败。</div>");
									break;
								case 31:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>查询水压欠压阀值失败。</div>");
									break;
								case 32:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>查询水压监测系统电池欠压阀值失败。</div>");
									break;
								case 40:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>查询烟感浓度超限阀值失败。</div>");
									break;
								case 41:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>查询烟感监测系统电池欠压阀值失败。</div>");
									break;
								case 50:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>查询燃气浓度超限阀值失败。</div>");
									break;
								case 51:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>查询燃气监测系统电池欠压阀值失败。</div>");
									break;
								case 60:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>查询高水位预警阀值失败。</div>");
									break;
								case 61:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>查询低水位预警阀值失败。</div>");
									break;
								case 62:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>查询水位监测系统电池欠压阀值失败。</div>");
									break;
								case 70:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>查询报警按钮电池欠压阀值失败。</div>");
									break;
								case 71:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>查询声光报警电池欠压阀值失败。</div>");
									break;
								case 72:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>查询消防栓电池欠压阀值失败。</div>");
									break;
								case 73:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>查询防火门电池欠压阀值失败。</div>");
									break;
								}
								break;
							}
							break;
						default:
							$("#resultPanel").prepend("<div style='color:red;padding:5px'>未知错误。</div>");
							break;
						}
					}
				});
            }
        }
    }

    function WSonClose(e) {
        try {
        	initProgress(); //初始化进度条
            //$.messager.alert("警告", "远程服务器连接中断，请刷新页面后重试。", "error");
        }
        catch (ex) {

        }
    }

    function WSonError(e) {
        
    }
</script>
</body>
</html>