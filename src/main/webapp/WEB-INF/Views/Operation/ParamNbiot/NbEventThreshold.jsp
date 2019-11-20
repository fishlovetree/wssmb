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
<style type="text/css">
.left-td {
	width: 75px;
}

.data-unit-cls{
    padding-left:5px;
}
</style>
</head>
<body>
	<div class="easyui-layout" fit="true">
		<div id="west" region="west" iconCls="icon-organization" split="true" title="设备" style="width:284px;min-width:284px;" collapsible="true">
			<jsp:include page="../../CommonTree/nb_DeviceTree.jsp"/>
		</div>
		<div id="mainPanel" region="center" style="overflow-y: hidden">
			<table border="0" cellspacing="8" cellpadding="8">
				<tr>
					<td class="tableHead_right" align="right">节点：</td>
					<td><input type="text" id='snode' class="easyui-textbox"
						readonly="readonly" style="width: 200px;" /> <input
						type="hidden" id="selectedID" /> <input type="hidden"
						id="selectedType" /> <input type="hidden"
						id="customerid" /></td>
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
										class="easyui-linkbutton" onclick="setOverVoltage()" title="设置">设置</a></td>
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
										class="easyui-linkbutton" onclick="setUnderVoltage()" title="设置">设置</a></td>
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
										class="easyui-linkbutton" onclick="setOverCurrent()" title="设置">设置</a></td>
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
										class="easyui-linkbutton" onclick="setOverPower()" title="设置">设置</a></td>
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
										class="easyui-linkbutton" onclick="setOverPowerFactor()" title="设置">设置</a></td>
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
										class="easyui-linkbutton" onclick="setOverTemperature()" title="设置">设置</a></td>
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
										class="easyui-linkbutton" onclick="setOverResidualCurrent()" title="设置">设置</a></td>
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
										class="easyui-linkbutton" onclick="setClockBattery()" title="设置">设置</a></td>
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
										class="easyui-linkbutton" onclick="setMeterReadingBattery()" title="设置">设置</a></td>
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
										<span class="data-unit-cls"></span>
									</td>
								</tr>										
								<tr>
									<td class="left-td">触发下限:</td>
									<td><input type="text" class="easyui-numberbox"
										name="lowervalue"
										data-options="required:true,min:0,max:99" />
										<span class="data-unit-cls"></span>
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
										class="easyui-linkbutton" onclick="setTemperatureUp()" title="设置">设置</a></td>
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
										class="easyui-linkbutton" onclick="setOverGas()" title="设置">设置</a></td>
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
										class="easyui-linkbutton" onclick="setGasBattery()" title="设置">设置</a></td>
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
										class="easyui-linkbutton" onclick="setOverSmoke()" title="设置">设置</a></td>
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
										class="easyui-linkbutton" onclick="setSmokeBattery()" title="设置">设置</a></td>
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
										class="easyui-linkbutton" onclick="setOverWaterPressure()" title="设置">设置</a></td>
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
										class="easyui-linkbutton" onclick="setUnderWaterPressure()" title="设置">设置</a></td>
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
										class="easyui-linkbutton" onclick="setWaterPressureBattery()" title="设置">设置</a></td>
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
										class="easyui-linkbutton" onclick="setHighWaterLine()" title="设置">设置</a></td>
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
										class="easyui-linkbutton" onclick="setLowWaterLine()" title="设置">设置</a></td>
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
										class="easyui-linkbutton" onclick="setWaterLineBattery()" title="设置">设置</a></td>
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
										class="easyui-linkbutton" onclick="setAlarmButtonBattery()" title="设置">设置</a></td>
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
										class="easyui-linkbutton" onclick="setAlarmDeviceBattery()" title="设置">设置</a></td>
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
										class="easyui-linkbutton" onclick="setFireplugBattery()" title="设置">设置</a></td>
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
										class="easyui-linkbutton" onclick="setFireDoorBattery()" title="设置">设置</a></td>
								</tr>
							</table>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
<script type="text/javascript">
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
	        height : "auto"
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
    })
    
    var treeTab = $('#region_tree');
	//公用树点击事件
	var node;
	function treeClick(treeObj, n){
		if(typeof n!='undefined' ){
			node=n;
			treeTab = treeObj;
			if (node.type >= commonTreeNodeType.nbBigType){ //NB大类及设备
        		$("#snode").textbox('setValue', node.text);
                $("#selectedID").val(node.gid);
                $("#selectedType").val(node.type);
                var sysType; //系统类型
                switch (node.type){
                    case commonTreeNodeType.nbBigType: //nb大类
                    	var pnode = treeTab.tree('getParent', node.target);
                    	$("#customerid").val(pnode.gid);
                    	sysType = node.gid;
                    	break;
                    case commonTreeNodeType.nbDevice: //nb设备
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
       	if ($('#' + formname).form('validate')){
       		if(eventtypecode==20){//过温
    			data = {
						"id": selectedID,
						"type": selectedType,
						"eventtypecode": eventtypecode,
						"customerid": $("#customerid").val(),
						"lowervalue": $('#' + formname + " input[name='lowervalue']").val(),
						"lowervalue2": $('#' + formname + " input[name='lowervalue2']").val(),
						"lowervalue3": $('#' + formname + " input[name='lowervalue3']").val(),
						"delaytime": $('#' + formname + " input[name='delaytime']").val()
					};
    		}else if(eventtypecode==24){//温升
    			data = {
						"id": selectedID,
						"type": selectedType,
						"eventtypecode": eventtypecode,
						"customerid": $("#customerid").val(),
						"lowervalue": $('#' + formname + " input[name='lowervalue']").val(),
						"lowervalue2": $('#' + formname + " input[name='lowervalue2']").val(),
						"delaytime": $('#' + formname + " input[name='delaytime']").val()
					};
    		}else{
    			data = {
    					"id": selectedID,
    					"type": selectedType,
    					"eventtypecode": eventtypecode,
    					"customerid": $("#customerid").val(),
    					"lowervalue": $('#' + formname + " input[name='lowervalue']").val(),
    					"delaytime": $('#' + formname + " input[name='delaytime']").val()
					};
    		}
       		$.ajax({
				type: 'POST',
				url: "${pageContext.request.contextPath}/paramNbiot/setEventThreshold",
				data: data,
				success: function(d) {
					if (d != "") {
                        if (d.indexOf("html") > 0) { //session超时
                            parent.window.location.reload();
                        }
                        else {
                        	$.messager.alert("提示", "已成功插入到命令列表中。", "info");
                        }
					}
				}
			});
       	}
	}
	
    //设置电压过压阀值
    function setOverVoltage(){
    	setThreshold("overVoltageForm", 1);
    }
    
    //设置电压欠压阀值
    function setUnderVoltage(){
    	setThreshold("underVoltageForm", 2);
    }
    
    //设置电流过流阀值
    function setOverCurrent(){
    	setThreshold("overCurrentForm", 3);
    }
    
    //设置功率过载阀值
    function setOverPower(){
    	setThreshold("overPowerForm", 4);
    }
    
    //设置功率因素超限阀值
    function setOverPowerFactor(){
    	setThreshold("overPowerFactorForm", 5);
    }
    
    //设置过温阀值
    function setOverTemperature(){
    	setThreshold("overTemperatureForm", 20);
    }
    
    //设置剩余电流超限阀值
    function setOverResidualCurrent(){
    	setThreshold("overResidualCurrentForm", 21);
    }
    
    //设置时钟电池欠压阀值
    function setClockBattery(){
    	setThreshold("clockBatteryForm", 22);
    }
    
    //设置抄表电池欠压阀值
    function setMeterReadingBattery(){
    	setThreshold("meterReadingBatteryForm", 23);
    }
    
    //设置温升判断阀值
    function setTemperatureUp(){
    	setThreshold("temperatureUpForm", 24);
    }
    
    //设置水压过压阀值
    function setOverWaterPressure(){
    	setThreshold("overWaterPressureForm", 30);
    }
    
    //设置水压欠压阀值
    function setUnderWaterPressure(){
    	setThreshold("underWaterPressureForm", 31);
    }
    
    //设置水压监测系统电池欠压阀值
    function setWaterPressureBattery(){
    	setThreshold("waterPressureBatteryForm", 32);
    }
    
    //设置烟感浓度超限阀值
    function setOverSmoke(){
    	setThreshold("overSmokeForm", 40);
    }
    
    //设置烟感监测系统电池欠压阀值
    function setSmokeBattery(){
    	setThreshold("smokeBatteryForm", 41);
    }
    
    //设置燃气浓度超限阀值
    function setOverGas(){
    	setThreshold("overGasForm", 50);
    }
    
    //设置燃气系统电池欠压阀值
    function setGasBattery(){
    	setThreshold("gasBatteryForm", 51);
    }
    
    //设置高水位预警阀值
    function setHighWaterLine(){
    	setThreshold("highWaterLineForm", 60);
    }
    
    //设置低水位预警阀值
    function setLowWaterLine(){
    	setThreshold("lowWaterLineForm", 61);
    }

    //设置水位监测系统电池欠压阀值
    function setWaterLineBattery(){
    	setThreshold("waterLineBatteryForm", 62);
    }
    
    //设置报警按钮电池欠压阀值
    function setAlarmButtonBattery(){
    	setThreshold("alarmButtonBatteryForm", 70);
    }
    
    //设置声光报警电池欠压阀值
    function setAlarmDeviceBattery(){
    	setThreshold("alarmDeviceBatteryForm", 71);
    }
    
    //设置消防栓电池欠压阀值
    function setFireplugBattery(){
    	setThreshold("fireplugBatteryForm", 72);
    }
    
    //设置防火门电池欠压阀值
    function setFireDoorBattery(){
    	setThreshold("fireDoorBatteryForm", 73);
    }
</script>
</body>
</html>