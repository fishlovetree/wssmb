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
<title>前端数据分析页面-在线率</title>
<%@include file="../../FrontHeader.jsp"%>
<style type="text/css">
* {
	color: white;
}

.layout-split-west {
	border-right: 10px solid #081a30;
}

.layout-split-north {
	border-bottom: 5px solid #212d39;
}

.tableTr {
	display: block; /*将tr设置为块体元素*/
	margin: 10px 0; /*设置tr间距为2px*/
}

.mydiv {
	float: left;
}

.tabs-header {
	border: 0;
	width: 30px;
}

#west, .datagrid-wrap, #p {
	border-image:
		url(${pageContext.request.contextPath}/js/easyui/themes/ui-dark-hive/images/body-border.png);
	border-image-slice: 6 5 6 5 fill;
	border-image-width: 2px;
}

.table-data-table {
	font-size: 13px;
	table-layout: fixed;
	empty-cells: show;
	border-collapse: collapse;
	margin: 0 auto;
	border: 1px solid #cad9ea;
	color: #2a8aba;
	width: 90%;
}

.table-data-table th {
	background-repeat: repeat-x;
}

.table-data-table td, .table-data-table th {
	border: 1px solid #2a8aba;
	padding: 0 1em 0;
}

.detailunitonlie, .detaildeviceonlie {
	border-collapse: collapse;
	text-align: center;
	cursor: pointer;
}

.detailunitonlie td, .detailunitonlie th, .detaildeviceonlie td,
	.detaildeviceonlie th {
	border: 1px solid #cad9ea;
	color: #666;
	height: 30px;
}

.detailunitonlie thead th, .detaildeviceonlie thead th {
	background-color: #CCE8EB;
	width: 100px;
}

.detailunitonlie tr:nth-child(odd), .detaildeviceonlie tr:nth-child(odd)
	{
	background: #fff;
}

.detailunitonlie tr:nth-child(even), .detaildeviceonlie tr:nth-child(even)
	{
	background: #F5FAFA;
}

.n_label {
	background-color: #4caf50;
}

.u_label {
	background-color: #8a8a8a;
}

.c_label {
	background-color: #ad5d5d;
}

.d_label {
	background-color: #2091c3;
}

.a_label {
	background-color: #ca1d1d;
}

.f_label {
	background-color: #d4941f;
}

.square {
	display: inline-block;
	margin-right: 5px;
	width: 10px; /* 宽度 */
	height: 10px; /* 高度 */
	top: 1px;
	position: relative;
}

.squarename {
	font-size: 12px;
}

.squarevalue {
	color: #7dc2ff;
	cursor: pointer;
}

hr.style { /*透明渐变水平线*/
	width: 100%;
	margin: 0 auto;
	border: 0;
	height: 1px;
	background-image: linear-gradient(to right, rgba(0, 0, 0, 0), #6f9bb1,
		rgba(0, 0, 0, 0));
}

hr.style2 { /*透明渐变水平线*/
	width: 1px;
	margin: 0 auto;
	border: 0;
	height: 195px;
	background-image: linear-gradient(to bottom, rgba(0, 0, 0, 0), #6f9bb1,
		rgba(0, 0, 0, 0));
	display: inline-block;
}

.trTitle {
	width: 1.5em;
	position: relative;
	padding-left: 8px;
}

/* Border styles */
.detail_table {
	border-top-width: 1px;
	border-top-style: solid;
	border-top-color: rgb(103, 143, 164);
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: rgb(103, 143, 164);
}

.detail_table td, .detail_table th {
	padding: 3px 5px 4px 5px;
	font-size: 13px;
	font-family: Verdana;
	text-align: center;
}

.detail_table tr:nth-child(even) {
	background: rgb(58, 72, 86);
}
</style>
</head>
<body style="min-width: 910px;">
	<input type="hidden" id="selectedParentid" value="0" />
	<input type="hidden" id="selectedUnitid" value="0" />
	<input type="hidden" id="selectedUnitType" value="0" />
	<input type="hidden" id="uptype" />
	<input type="hidden" id="commtype" />

	<table style="width: 100%;">
		<tr id="unitTr">
			<td style="width: 25px;">
				<div class="trTitle">设备</div>
			</td>
			<td style="width: 1px;">
				<hr class="style2" />
			</td>
			<td style="padding-top: 5px;">
				<!-- 终端在线率-->
				<div id="unitonline"
					style="height: 200px; width: 350px; margin: auto;"></div>
			</td>
			<td style="width: 60%;">
				<table class="detail_table">
					<tr>
						<td style="width: 20px;">&nbsp;</td>
						<td style="width: 70px;">&nbsp;</td>
						<td style="width: 90px;">集中器</td>
						<td style="width: 90px;">监控终端</td>
						<td style="width: 90px;">电表</td>
						<td style="width: 70px;">总计</td>
					</tr>
					<tr>
						<td><div class="square n_label"></div></td>
						<td><label class="squarename">在线终端</label></td>
						<td><label class="squarevalue" id="terminal-normal"
							onClick="unitInfo('集中器','1','1')"></label></td>
						<td><label class="squarevalue" id="transmission-normal"
							onClick="unitInfo('监控终端','2','1')"></label></td>
						<td><label class="squarevalue" id="gprsdevice-normal"
							onClick="unitInfo('电表','3','1')"></label></td>
						<td><label class="squarevalue" id="unit-normal"
							onClick="unitInfo('','0','1')"></label></td>
					</tr>
					<tr>
						<td><div class="square u_label"></div></td>
						<td><label class="squarename">离线终端</label></td>
						<td><label class="squarevalue" id="terminal-unonline"
							onClick="unitInfo('集中器','1','0')"></label></td>
						<td><label class="squarevalue" id="transmission-unonline"
							onClick="unitInfo('监控终端','2','0')"></label></td>
						<td><label class="squarevalue" id="gprsdevice-unonline"
							onClick="unitInfo('电表','3','0')"></label></td>
						<td><label class="squarevalue" id="unit-unonline"
							onClick="unitInfo('','0','0')"></label></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td><label class="squarename">总计</label></td>
						<td><label class="squarevalue" id="terminal-all"
							onClick="unitInfo('集中器','1','')"></label></td>
						<td><label class="squarevalue" id="transmission-all"
							onClick="unitInfo('监控终端','2','')"></label></td>
						<td><label class="squarevalue" id="gprsdevice-all"
							onClick="unitInfo('电表','3','')"></label></td>
						<td><label class="squarevalue" id="unit-all"
							onClick="unitInfo('','0','')"></label></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr class="hr">
			<td colspan="3"><hr class="style" /></td>
		</tr>
		<tr id="deviceTr">
			<td>
				<div class="trTitle">设备</div>
			</td>
			<td style="width: 1px;">
				<hr class="style2" />
			</td>
			<td>
				<!-- 设备在线率-->
				<div id="deviceonline"
					style="height: 200px; width: 350px; margin: auto;"></div>
			</td>
			<td style="width: 60%;">
				<table class="detail_table">
					<tr>
						<td style="width: 20px;"><div class="square n_label"></div></td>
						<td style="width: 85px;"><label class="squarename">正常设备</label></td>
						<td style="width: 90px;"><label class="squarevalue"
							id="normal" onClick="deviceInfo('','','','1')"></label></td>
						<td rowspan="7" style="display: none;"><label
							id="unknowntype" style="color: red;"></label></td>
					</tr>
					<tr>
						<td><div class="square a_label"></div></td>
						<td><label class="squarename">告警设备</label></td>
						<td><label class="squarevalue" id="alarm"
							onClick="deviceInfo('','','','2')"></label></td>
					</tr>
					<tr>
						<td><div class="square f_label"></div></td>
						<td><label class="squarename">故障设备</label></td>
						<td><label class="squarevalue" id="fault"
							onClick="deviceInfo('','','','3')"></label></td>
					</tr>
					<tr>
						<td><div class="square u_label"></div></td>
						<td><label class="squarename">离线设备</label></td>
						<td><label class="squarevalue" id="unonline"
							onClick="deviceInfo('','','','0')"></label></td>
					</tr>
					<tr>
						<td><div class="square c_label"></div></td>
						<td><label class="squarename">不可通讯设备</label></td>
						<td><label class="squarevalue" id="nocomm"
							onClick="deviceInfo('','','','4')"></label></td>
					</tr>
					<tr>
						<td><div class="square d_label"></div></td>
						<td><label class="squarename">未下发设备</label></td>
						<td><label class="squarevalue" id="nodown"
							onClick="deviceInfo('','','','5')"></label></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td><label class="squarename">总计</label></td>
						<td><label class="squarevalue" id="all"
							onClick="deviceInfo('','','','')"></label></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<div class="easyui-tabs" id="menuTab"
		style="width: 100%; height: 245px;" data-options="tabPosition:'top'">
		<div id="10" title="电气火灾监控设备">
			<table
				style="width: 100%; border-collapse: collapse; border-spacing: 0; table-layout: fixed; margin: auto;">
				<tr>
					<td style="width: 50px;">&nbsp;</td>
					<td style="padding-top: 5px;">
						<div id="deviceonline-10"
							style="height: 200px; width: 350px; margin: auto;"></div>
					</td>
					<td style="width: 60%;">
						<table class="detail_table">
							<tr>
								<td style="width: 20px;">&nbsp;</td>
								<td style="width: 85px;">&nbsp;</td>
								<td style="width: 90px;">智慧消防设备</td>
								<td style="width: 90px;">智慧用电</td>
								<td style="width: 70px;">总计</td>
							</tr>
							<tr>
								<td><div class="square n_label"></div></td>
								<td><label class="squarename">正常设备</label></td>
								<td><label class="squarevalue" id="fire-normal-10"
									onClick="deviceInfo('智慧消防设备','10','1','1')"></label></td>
								<td><label class="squarevalue" id="elec-normal-10"
									onClick="deviceInfo('智慧用电','10','2','1')"></label></td>
								<td><label class="squarevalue" id="normal-10"
									onClick="deviceInfo('电气火灾监控设备','10','','1')"></label></td>
							</tr>
							<tr>
								<td><div class="square a_label"></div></td>
								<td><label class="squarename">告警设备</label></td>
								<td><label class="squarevalue" id="fire-alarm-10"
									onClick="deviceInfo('智慧消防设备','10','1','2')"></label></td>
								<td><label class="squarevalue" id="elec-alarm-10"
									onClick="deviceInfo('智慧用电','10','2','2')"></label></td>
								<td><label class="squarevalue" id="alarm-10"
									onClick="deviceInfo('电气火灾监控设备','10','','2')"></label></td>
							</tr>
							<tr>
								<td><div class="square f_label"></div></td>
								<td><label class="squarename">故障设备</label></td>
								<td><label class="squarevalue" id="fire-fault-10"
									onClick="deviceInfo('智慧消防设备','10','1','3')"></label></td>
								<td><label class="squarevalue" id="elec-fault-10"
									onClick="deviceInfo('智慧用电','10','2','3')"></label></td>
								<td><label class="squarevalue" id="fault-10"
									onClick="deviceInfo('电气火灾监控设备','10','','3')"></label></td>
							</tr>
							<tr>
								<td><div class="square u_label"></div></td>
								<td><label class="squarename">离线设备</label></td>
								<td><label class="squarevalue" id="fire-unonline-10"
									onClick="deviceInfo('智慧消防设备','10','1','0')"></label></td>
								<td><label class="squarevalue" id="elec-unonline-10"
									onClick="deviceInfo('智慧用电','10','2','0')"></label></td>
								<td><label class="squarevalue" id="unonline-10"
									onClick="deviceInfo('电气火灾监控设备','10','','0')"></label></td>
							</tr>
							<tr>
								<td><div class="square c_label"></div></td>
								<td><label class="squarename">不可通讯设备</label></td>
								<td><label class="squarevalue" id="fire-nocomm-10"
									onClick="deviceInfo('智慧消防设备','10','1','4')"></label></td>
								<td><label class="squarevalue" id="elec-nocomm-10"
									onClick="deviceInfo('智慧用电','10','2','4')"></label></td>
								<td><label class="squarevalue" id="nocomm-10"
									onClick="deviceInfo('电气火灾监控设备','10','','4')"></label></td>
							</tr>
							<tr>
								<td><div class="square d_label"></div></td>
								<td><label class="squarename">未下发设备</label></td>
								<td><label class="squarevalue" id="fire-nodown-10"
									onClick="deviceInfo('智慧消防设备','10','1','5')"></label></td>
								<td><label class="squarevalue" id="elec-nodown-10"
									onClick="deviceInfo('智慧用电','10','2','5')"></label></td>
								<td><label class="squarevalue" id="nodown-10"
									onClick="deviceInfo('电气火灾监控设备','10','','5')"></label></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td><label class="squarename">总计</label></td>
								<td><label class="squarevalue" id="fire-all-10"
									onClick="deviceInfo('智慧消防设备','10','1','')"></label></td>
								<td><label class="squarevalue" id="elec-all-10"
									onClick="deviceInfo('智慧用电','10','2','')"></label></td>
								<td><label class="squarevalue" id="all-10"
									onClick="deviceInfo('电气火灾监控设备','10','','')"></label></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>
		<div id="128" title="烟雾监控设备">
			<table
				style="width: 100%; border-collapse: collapse; border-spacing: 0; table-layout: fixed; margin: auto">
				<tr>
					<td style="width: 50px;">&nbsp;</td>
					<td style="padding-top: 5px;">
						<div id="deviceonline-128"
							style="height: 200px; width: 350px; margin: auto;"></div>
					</td>
					<td style="width: 60%;">
						<table class="detail_table">
							<tr>
								<td style="width: 20px;">&nbsp;</td>
								<td style="width: 85px;">&nbsp;</td>
								<td style="width: 90px;">智慧消防烟感</td>
								<td style="width: 90px;">NB烟感</td>
								<td style="width: 70px;">总计</td>
							</tr>
							<tr>
								<td><div class="square n_label"></div></td>
								<td><label class="squarename">正常设备</label></td>
								<td><label class="squarevalue" id="fire-normal-128"
									onClick="deviceInfo('智慧消防烟感','128','1','1')"></label></td>
								<td><label class="squarevalue" id="nb-normal-128"
									onClick="deviceInfo('NB烟感','128','4','1')"></label></td>
								<td><label class="squarevalue" id="normal-128"
									onClick="deviceInfo('烟雾监控设备','128','','1')"></label></td>
							</tr>
							<tr>
								<td><div class="square a_label"></div></td>
								<td><label class="squarename">告警设备</label></td>
								<td><label class="squarevalue" id="fire-alarm-128"
									onClick="deviceInfo('智慧消防烟感','128','1','2')"></label></td>
								<td><label class="squarevalue" id="nb-alarm-128"
									onClick="deviceInfo('NB烟感','128','4','2')"></label></td>
								<td><label class="squarevalue" id="alarm-128"
									onClick="deviceInfo('烟雾监控设备','128','','2')"></label></td>
							</tr>
							<tr>
								<td><div class="square f_label"></div></td>
								<td><label class="squarename">故障设备</label></td>
								<td><label class="squarevalue" id="fire-fault-128"
									onClick="deviceInfo('智慧消防烟感','128','1','3')"></label></td>
								<td><label class="squarevalue" id="nb-fault-128"
									onClick="deviceInfo('NB烟感','128','4','3')"></label></td>
								<td><label class="squarevalue" id="fault-128"
									onClick="deviceInfo('烟雾监控设备','128','','3')"></label></td>
							</tr>
							<tr>
								<td><div class="square u_label"></div></td>
								<td><label class="squarename">离线设备</label></td>
								<td><label class="squarevalue" id="fire-unonline-128"
									onClick="deviceInfo('智慧消防烟感','128','1','0')"></label></td>
								<td><label class="squarevalue" id="nb-unonline-128"
									onClick="deviceInfo('NB烟感','128','4','0')"></label></td>
								<td><label class="squarevalue" id="unonline-128"
									onClick="deviceInfo('烟雾监控设备','128','','0')"></label></td>
							</tr>
							<tr>
								<td><div class="square c_label"></div></td>
								<td><label class="squarename">不可通讯设备</label></td>
								<td><label class="squarevalue" id="fire-nocomm-128"
									onClick="deviceInfo('智慧消防设备','128','1','4')"></label></td>
								<td><label class="squarevalue" id="elec-nocomm-128"
									onClick="deviceInfo('NB烟感','128','4','4')"></label></td>
								<td><label class="squarevalue" id="nocomm-128"
									onClick="deviceInfo('电气火灾监控设备','128','','4')"></label></td>
							</tr>
							<tr>
								<td><div class="square d_label"></div></td>
								<td><label class="squarename">未下发设备</label></td>
								<td><label class="squarevalue" id="fire-nodown-128"
									onClick="deviceInfo('智慧消防设备','128','1','5')"></label></td>
								<td><label class="squarevalue" id="elec-nodown-128"
									onClick="deviceInfo('NB烟感','128','4','5')"></label></td>
								<td><label class="squarevalue" id="nodown-128"
									onClick="deviceInfo('电气火灾监控设备','128','','5')"></label></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td><label class="squarename">总计</label></td>
								<td><label class="squarevalue" id="fire-all-128"
									onClick="deviceInfo('智慧消防烟感','128','1','')"></label></td>
								<td><label class="squarevalue" id="nb-all-128"
									onClick="deviceInfo('NB烟感','128','4','')"></label></td>
								<td><label class="squarevalue" id="all-128"
									onClick="deviceInfo('烟雾监控设备','128','','')"></label></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>
		<div id="129" title="消防水压监控设备">
			<table
				style="width: 100%; border-collapse: collapse; border-spacing: 0; table-layout: fixed; margin: auto">
				<tr>
					<td style="width: 50px;">&nbsp;</td>
					<td style="padding-top: 5px;">
						<div id="deviceonline-129"
							style="height: 200px; width: 350px; margin: auto;"></div>
					</td>
					<td style="width: 60%;">
						<table class="detail_table">
							<tr>
								<td style="width: 20px;">&nbsp;</td>
								<td style="width: 85px;">&nbsp;</td>
								<td style="width: 90px;">智慧消防水压</td>
								<td style="width: 90px;">NB水压</td>
								<td style="width: 70px;">总计</td>
							</tr>
							<tr>
								<td><div class="square n_label"></div></td>
								<td><label class="squarename">正常设备</label></td>
								<td><label class="squarevalue" id="fire-normal-129"
									onClick="deviceInfo('智慧消防水压','129','1','1')"></label></td>
								<td><label class="squarevalue" id="nb-normal-129"
									onClick="deviceInfo('NB水压','129','6','1')"></label></td>
								<td><label class="squarevalue" id="normal-129"
									onClick="deviceInfo('消防水压监控设备','129','','1')"></label></td>
							</tr>
							<tr>
								<td><div class="square a_label"></div></td>
								<td><label class="squarename">告警设备</label></td>
								<td><label class="squarevalue" id="fire-alarm-129"
									onClick="deviceInfo('智慧消防水压','129','1','2')"></label></td>
								<td><label class="squarevalue" id="nb-alarm-129"
									onClick="deviceInfo('NB水压','129','6','2')"></label></td>
								<td><label class="squarevalue" id="alarm-129"
									onClick="deviceInfo('消防水压监控设备','129','','2')"></label></td>
							</tr>
							<tr>
								<td><div class="square f_label"></div></td>
								<td><label class="squarename">故障设备</label></td>
								<td><label class="squarevalue" id="fire-fault-129"
									onClick="deviceInfo('智慧消防水压','129','1','3')"></label></td>
								<td><label class="squarevalue" id="nb-fault-129"
									onClick="deviceInfo('NB水压','129','6','3')"></label></td>
								<td><label class="squarevalue" id="fault-129"
									onClick="deviceInfo('消防水压监控设备','129','','3')"></label></td>
							</tr>
							<tr>
								<td><div class="square u_label"></div></td>
								<td><label class="squarename">离线设备</label></td>
								<td><label class="squarevalue" id="fire-unonline-129"
									onClick="deviceInfo('智慧消防水压','129','1','0')"></label></td>
								<td><label class="squarevalue" id="nb-unonline-129"
									onClick="deviceInfo('NB水压','129','6','0')"></label></td>
								<td><label class="squarevalue" id="unonline-129"
									onClick="deviceInfo('消防水压监控设备','129','','0')"></label></td>
							</tr>
							<tr>
								<td><div class="square c_label"></div></td>
								<td><label class="squarename">不可通讯设备</label></td>
								<td><label class="squarevalue" id="fire-nocomm-129"
									onClick="deviceInfo('智慧消防设备','129','1','4')"></label></td>
								<td><label class="squarevalue" id="elec-nocomm-129"
									onClick="deviceInfo('NB水压','129','6','4')"></label></td>
								<td><label class="squarevalue" id="nocomm-129"
									onClick="deviceInfo('电气火灾监控设备','129','','4')"></label></td>
							</tr>
							<tr>
								<td><div class="square d_label"></div></td>
								<td><label class="squarename">未下发设备</label></td>
								<td><label class="squarevalue" id="fire-nodown-129"
									onClick="deviceInfo('智慧消防设备','129','1','5')"></label></td>
								<td><label class="squarevalue" id="elec-nodown-129"
									onClick="deviceInfo('NB水压','129','6','5')"></label></td>
								<td><label class="squarevalue" id="nodown-129"
									onClick="deviceInfo('电气火灾监控设备','129','','5')"></label></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td><label class="squarename">总计</label></td>
								<td><label class="squarevalue" id="fire-all-129"
									onClick="deviceInfo('智慧消防水压','129','1','')"></label></td>
								<td><label class="squarevalue" id="nb-all-129"
									onClick="deviceInfo('NB水压','129','6','')"></label></td>
								<td><label class="squarevalue" id="all-129"
									onClick="deviceInfo('消防水压监控设备','129','','')"></label></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>
		<div id="11" title="可燃气体报警设备">
			<table
				style="width: 100%; border-collapse: collapse; border-spacing: 0; table-layout: fixed; margin: auto">
				<tr>
					<td style="width: 50px;">&nbsp;</td>
					<td style="padding-top: 5px;">
						<div id="deviceonline-11"
							style="height: 200px; width: 350px; margin: auto;"></div>
					</td>
					<td style="width: 60%;">
						<table class="detail_table">
							<tr>
								<td style="width: 20px;">&nbsp;</td>
								<td style="width: 85px;">&nbsp;</td>
								<td style="width: 90px;">智慧消防燃气</td>
								<td style="width: 90px;">智慧用电</td>
								<td style="width: 90px;">NB燃气</td>
								<td style="width: 70px;">总计</td>
							</tr>
							<tr>
								<td><div class="square n_label"></div></td>
								<td><label class="squarename">正常设备</label></td>
								<td><label class="squarevalue" id="fire-normal-11"
									onClick="deviceInfo('智慧消防燃气','11','1','1')"></label></td>
								<td><label class="squarevalue" id="elec-normal-11"
									onClick="deviceInfo('智慧用电','11','2','1')"></label></td>
								<td><label class="squarevalue" id="nb-normal-11"
									onClick="deviceInfo('NB燃气','11','5','1')"></label></td>
								<td><label class="squarevalue" id="normal-11"
									onClick="deviceInfo('可燃气体报警设备','11','','1')"></label></td>
							</tr>
							<tr>
								<td><div class="square a_label"></div></td>
								<td><label class="squarename">告警设备</label></td>
								<td><label class="squarevalue" id="fire-alarm-11"
									onClick="deviceInfo('智慧消防燃气','11','1','2')"></label></td>
								<td><label class="squarevalue" id="elec-alarm-11"
									onClick="deviceInfo('智慧用电','11','2','2')"></label></td>
								<td><label class="squarevalue" id="nb-alarm-11"
									onClick="deviceInfo('NB燃气','11','5','2')"></label></td>
								<td><label class="squarevalue" id="alarm-11"
									onClick="deviceInfo('可燃气体报警设备','11','','2')"></label></td>
							</tr>
							<tr>
								<td><div class="square f_label"></div></td>
								<td><label class="squarename">故障设备</label></td>
								<td><label class="squarevalue" id="fire-fault-11"
									onClick="deviceInfo('智慧消防燃气','11','1','3')"></label></td>
								<td><label class="squarevalue" id="elec-fault-11"
									onClick="deviceInfo('智慧用电','11','2','3')"></label></td>
								<td><label class="squarevalue" id="nb-fault-11"
									onClick="deviceInfo('NB燃气','11','5','3')"></label></td>
								<td><label class="squarevalue" id="fault-11"
									onClick="deviceInfo('可燃气体报警设备','11','','3')"></label></td>
							</tr>
							<tr>
								<td><div class="square u_label"></div></td>
								<td><label class="squarename">离线设备</label></td>
								<td><label class="squarevalue" id="fire-unonline-11"
									onClick="deviceInfo('智慧消防燃气','11','1','0')"></label></td>
								<td><label class="squarevalue" id="elec-unonline-11"
									onClick="deviceInfo('智慧用电','11','2','0')"></label></td>
								<td><label class="squarevalue" id="nb-unonline-11"
									onClick="deviceInfo('NB燃气','11','5','0')"></label></td>
								<td><label class="squarevalue" id="unonline-11"
									onClick="deviceInfo('可燃气体报警设备','11','','0')"></label></td>
							</tr>
							<tr>
								<td><div class="square c_label"></div></td>
								<td><label class="squarename">不可通讯设备</label></td>
								<td><label class="squarevalue" id="fire-nocomm-11"
									onClick="deviceInfo('智慧消防设备','11','1','4')"></label></td>
								<td><label class="squarevalue" id="elec-nocomm-11"
									onClick="deviceInfo('智慧用电','11','2','4')"></label></td>
								<td><label class="squarevalue" id="nb-nocomm-11"
									onClick="deviceInfo('NB燃气','11','5','4')"></label></td>
								<td><label class="squarevalue" id="nocomm-11"
									onClick="deviceInfo('电气火灾监控设备','11','','4')"></label></td>
							</tr>
							<tr>
								<td><div class="square d_label"></div></td>
								<td><label class="squarename">未下发设备</label></td>
								<td><label class="squarevalue" id="fire-nodown-11"
									onClick="deviceInfo('智慧消防设备','11','1','5')"></label></td>
								<td><label class="squarevalue" id="elec-nodown-11"
									onClick="deviceInfo('智慧用电','11','2','5')"></label></td>
								<td><label class="squarevalue" id="nb-nodown-11"
									onClick="deviceInfo('NB燃气','11','5','5')"></label></td>
								<td><label class="squarevalue" id="nodown-11"
									onClick="deviceInfo('电气火灾监控设备','11','','5')"></label></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td><label class="squarename">总计</label></td>
								<td><label class="squarevalue" id="fire-all-11"
									onClick="deviceInfo('智慧消防燃气','11','1','')"></label></td>
								<td><label class="squarevalue" id="elec-all-11"
									onClick="deviceInfo('智慧用电','11','2','')"></label></td>
								<td><label class="squarevalue" id="nb-all-11"
									onClick="deviceInfo('NB燃气','11','5','')"></label></td>
								<td><label class="squarevalue" id="all-11"
									onClick="deviceInfo('可燃气体报警设备','11','','')"></label></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>
		<div id="130" title="报警按钮及声光报警器">
			<table
				style="width: 100%; border-collapse: collapse; border-spacing: 0; table-layout: fixed; margin: auto">
				<tr>
					<td style="width: 50px;">&nbsp;</td>
					<td style="padding-top: 5px;">
						<div id="deviceonline-130"
							style="height: 200px; width: 350px; margin: auto;"></div>
					</td>
					<td style="width: 60%;">
						<table class="detail_table">
							<tr>
								<td style="width: 20px;">&nbsp;</td>
								<td style="width: 85px;">&nbsp;</td>
								<td style="width: 90px;">智慧消防设备</td>
							</tr>
							<tr>
								<td><div class="square n_label"></div></td>
								<td><label class="squarename">正常设备</label></td>
								<td><label class="squarevalue" id="fire-normal-130"
									onClick="deviceInfo('智慧消防设备','130','1','1')"></label></td>
							</tr>
							<tr>
								<td><div class="square a_label"></div></td>
								<td><label class="squarename">告警设备</label></td>
								<td><label class="squarevalue" id="fire-alarm-130"
									onClick="deviceInfo('智慧消防设备','130','1','2')"></label></td>
							</tr>
							<tr>
								<td><div class="square f_label"></div></td>
								<td><label class="squarename">故障设备</label></td>
								<td><label class="squarevalue" id="fire-fault-130"
									onClick="deviceInfo('智慧消防设备','130','1','3')"></label></td>
							</tr>
							<tr>
								<td><div class="square u_label"></div></td>
								<td><label class="squarename">离线设备</label></td>
								<td><label class="squarevalue" id="fire-unonline-130"
									onClick="deviceInfo('智慧消防设备','130','1','0')"></label></td>
							</tr>
							<tr>
								<td><div class="square c_label"></div></td>
								<td><label class="squarename">不可通讯设备</label></td>
								<td><label class="squarevalue" id="fire-nocomm-130"
									onClick="deviceInfo('智慧消防设备','130','1','4')"></label></td>
							</tr>
							<tr>
								<td><div class="square d_label"></div></td>
								<td><label class="squarename">未下发设备</label></td>
								<td><label class="squarevalue" id="fire-nodown-130"
									onClick="deviceInfo('智慧消防设备','130','1','5')"></label></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td><label class="squarename">总计</label></td>
								<td><label class="squarevalue" id="fire-all-130"
									onClick="deviceInfo('智慧消防设备','130','1','')"></label></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>
		<div id="20" title="消火栓设备">
			<table
				style="width: 100%; border-collapse: collapse; border-spacing: 0; table-layout: fixed; margin: auto">
				<tr>
					<td style="width: 50px;">&nbsp;</td>
					<td style="padding-top: 5px;">
						<div id="deviceonline-20"
							style="height: 200px; width: 350px; margin: auto;"></div>
					</td>
					<td style="width: 60%;">
						<table class="detail_table">
							<tr>
								<td style="width: 20px;">&nbsp;</td>
								<td style="width: 85px;">&nbsp;</td>
								<td style="width: 90px;">智慧消防设备</td>
							</tr>
							<tr>
								<td><div class="square n_label"></div></td>
								<td><label class="squarename">正常设备</label></td>
								<td><label class="squarevalue" id="fire-normal-20"
									onClick="deviceInfo('智慧消防设备','20','1','1')"></label></td>
							</tr>
							<tr>
								<td><div class="square a_label"></div></td>
								<td><label class="squarename">告警设备</label></td>
								<td><label class="squarevalue" id="fire-alarm-20"
									onClick="deviceInfo('智慧消防设备','20','1','2')"></label></td>
							</tr>
							<tr>
								<td><div class="square f_label"></div></td>
								<td><label class="squarename">故障设备</label></td>
								<td><label class="squarevalue" id="fire-fault-20"
									onClick="deviceInfo('智慧消防设备','20','1','3')"></label></td>
							</tr>
							<tr>
								<td><div class="square u_label"></div></td>
								<td><label class="squarename">离线设备</label></td>
								<td><label class="squarevalue" id="fire-unonline-20"
									onClick="deviceInfo('智慧消防设备','20','1','0')"></label></td>
							</tr>
							<tr>
								<td><div class="square c_label"></div></td>
								<td><label class="squarename">不可通讯设备</label></td>
								<td><label class="squarevalue" id="fire-nocomm-20"
									onClick="deviceInfo('智慧消防设备','20','1','4')"></label></td>
							</tr>
							<tr>
								<td><div class="square d_label"></div></td>
								<td><label class="squarename">未下发设备</label></td>
								<td><label class="squarevalue" id="fire-nodown-20"
									onClick="deviceInfo('智慧消防设备','20','1','5')"></label></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td><label class="squarename">总计</label></td>
								<td><label class="squarevalue" id="fire-all-20"
									onClick="deviceInfo('智慧消防设备','20','1','')"></label></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>
		<div id="131" title="消防水位监控设备">
			<table
				style="width: 100%; border-collapse: collapse; border-spacing: 0; table-layout: fixed; margin: auto">
				<tr>
					<td style="width: 50px;">&nbsp;</td>
					<td style="padding-top: 5px;">
						<div id="deviceonline-131"
							style="height: 200px; width: 350px; margin: auto;"></div>
					</td>
					<td style="width: 60%;">
						<table class="detail_table">
							<tr>
								<td style="width: 20px;">&nbsp;</td>
								<td style="width: 85px;">&nbsp;</td>
								<td style="width: 90px;">智慧消防水位</td>
								<td style="width: 90px;">NB水位</td>
								<td style="width: 70px;">总计</td>
							</tr>
							<tr>
								<td><div class="square n_label"></div></td>
								<td><label class="squarename">正常设备</label></td>
								<td><label class="squarevalue" id="fire-normal-131"
									onClick="deviceInfo('智慧消防水位','131','1','1')"></label></td>
								<td><label class="squarevalue" id="nb-normal-131"
									onClick="deviceInfo('NB水位','131','6','1')"></label></td>
								<td><label class="squarevalue" id="normal-131"
									onClick="deviceInfo('消防水位监控设备','131','','1')"></label></td>
							</tr>
							<tr>
								<td><div class="square a_label"></div></td>
								<td><label class="squarename">告警设备</label></td>
								<td><label class="squarevalue" id="fire-alarm-131"
									onClick="deviceInfo('智慧消防水位','131','1','2')"></label></td>
								<td><label class="squarevalue" id="nb-alarm-131"
									onClick="deviceInfo('NB水位','131','6','2')"></label></td>
								<td><label class="squarevalue" id="alarm-131"
									onClick="deviceInfo('消防水位监控设备','131','','2')"></label></td>
							</tr>
							<tr>
								<td><div class="square f_label"></div></td>
								<td><label class="squarename">故障设备</label></td>
								<td><label class="squarevalue" id="fire-fault-131"
									onClick="deviceInfo('智慧消防水位','131','1','3')"></label></td>
								<td><label class="squarevalue" id="nb-fault-131"
									onClick="deviceInfo('NB水位','131','6','3')"></label></td>
								<td><label class="squarevalue" id="fault-131"
									onClick="deviceInfo('消防水位监控设备','131','','3')"></label></td>
							</tr>
							<tr>
								<td><div class="square u_label"></div></td>
								<td><label class="squarename">离线设备</label></td>
								<td><label class="squarevalue" id="fire-unonline-131"
									onClick="deviceInfo('智慧消防水位','131','1','0')"></label></td>
								<td><label class="squarevalue" id="nb-unonline-131"
									onClick="deviceInfo('NB水位','131','6','0')"></label></td>
								<td><label class="squarevalue" id="unonline-131"
									onClick="deviceInfo('消防水位监控设备','131','','0')"></label></td>
							</tr>
							<tr>
								<td><div class="square c_label"></div></td>
								<td><label class="squarename">不可通讯设备</label></td>
								<td><label class="squarevalue" id="fire-nocomm-131"
									onClick="deviceInfo('智慧消防设备','131','1','4')"></label></td>
								<td><label class="squarevalue" id="elec-nocomm-131"
									onClick="deviceInfo('NB水位','131','6','4')"></label></td>
								<td><label class="squarevalue" id="nocomm-131"
									onClick="deviceInfo('电气火灾监控设备','131','','4')"></label></td>
							</tr>
							<tr>
								<td><div class="square d_label"></div></td>
								<td><label class="squarename">未下发设备</label></td>
								<td><label class="squarevalue" id="fire-nodown-131"
									onClick="deviceInfo('智慧消防设备','131','1','5')"></label></td>
								<td><label class="squarevalue" id="elec-nodown-131"
									onClick="deviceInfo('NB水位','131','6','5')"></label></td>
								<td><label class="squarevalue" id="nodown-131"
									onClick="deviceInfo('电气火灾监控设备','131','','5')"></label></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td><label class="squarename">总计</label></td>
								<td><label class="squarevalue" id="fire-all-131"
									onClick="deviceInfo('智慧消防水位','131','1','')"></label></td>
								<td><label class="squarevalue" id="nb-all-131"
									onClick="deviceInfo('NB水位','131','6','')"></label></td>
								<td><label class="squarevalue" id="all-131"
									onClick="deviceInfo('消防水位监控设备','131','','')"></label></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>
		<div id="18" title="防火卷级防火门监控设备">
			<table
				style="width: 100%; border-collapse: collapse; border-spacing: 0; table-layout: fixed; margin: auto">
				<tr>
					<td style="width: 50px;">&nbsp;</td>
					<td style="padding-top: 5px;">
						<div id="deviceonline-18"
							style="height: 200px; width: 350px; margin: auto;"></div>
					</td>
					<td style="width: 60%;">
						<table class="detail_table">
							<tr>
								<td style="width: 20px;">&nbsp;</td>
								<td style="width: 85px;">&nbsp;</td>
								<td style="width: 90px;">智慧消防设备</td>
							</tr>
							<tr>
								<td><div class="square n_label"></div></td>
								<td><label class="squarename">正常设备</label></td>
								<td><label class="squarevalue" id="fire-normal-18"
									onClick="deviceInfo('智慧消防设备','18','1','1')"></label></td>
							</tr>
							<tr>
								<td><div class="square a_label"></div></td>
								<td><label class="squarename">告警设备</label></td>
								<td><label class="squarevalue" id="fire-alarm-18"
									onClick="deviceInfo('智慧消防设备','18','1','2')"></label></td>
							</tr>
							<tr>
								<td><div class="square f_label"></div></td>
								<td><label class="squarename">故障设备</label></td>
								<td><label class="squarevalue" id="fire-fault-18"
									onClick="deviceInfo('智慧消防设备','18','1','3')"></label></td>
							</tr>
							<tr>
								<td><div class="square u_label"></div></td>
								<td><label class="squarename">离线设备</label></td>
								<td><label class="squarevalue" id="fire-unonline-18"
									onClick="deviceInfo('智慧消防设备','18','1','0')"></label></td>
							</tr>
							<tr>
								<td><div class="square c_label"></div></td>
								<td><label class="squarename">不可通讯设备</label></td>
								<td><label class="squarevalue" id="fire-nocomm-18"
									onClick="deviceInfo('智慧消防设备','18','1','4')"></label></td>
							</tr>
							<tr>
								<td><div class="square d_label"></div></td>
								<td><label class="squarename">未下发设备</label></td>
								<td><label class="squarevalue" id="fire-nodown-18"
									onClick="deviceInfo('智慧消防设备','18','1','5')"></label></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td><label class="squarename">总计</label></td>
								<td><label class="squarevalue" id="fire-all-18"
									onClick="deviceInfo('智慧消防设备','18','1','')"></label></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>
	</div>

	<!-- 终端列表弹出框 -->
	<div id="unitdlg" class="easyui-dialog"
		style="width: 800px; height: 530px;" closable="true" closed="true"
		buttons="#unitdlg-buttons" data-options="">
		<table id="unitdg"></table>
	</div>
	<div id="unitdlg-buttons">
		<a href="#" class="easyui-linkbutton" iconCls="icon-cancel"
			onclick="javascript:$('#unitdg').datagrid('loadData', { total: 0, rows: [] }); $('#unitdlg').dialog('close');">关闭</a>
	</div>

	<!-- 设备列表弹出框 -->
	<div id="devicedlg" class="easyui-dialog"
		style="width: 800px; height: 530px;" closable="true" closed="true"
		buttons="#devicedlg-buttons" data-options="">
		<table id="devicedg"></table>

		<!-- 列表-按钮 -->
		<div id="devicetoolbar">
			<input type="hidden" id="systemtype" /> <input type="hidden"
				id="subtype" />
			<div style="display: inline-block;">
				<label style="font-size: 14px">设备地址:</label> <input
					id="devicestatusaddress" class="easyui-textbox"
					style="width: 160px; height: 26px;"
					data-options="
                  prompt: '请输入地址……'" />
			</div>
			<div style="display: inline-block;">
				<label style="font-size: 14px">设备名称:</label> <input
					id="devicestatusname" class="easyui-textbox"
					style="width: 160px; height: 26px;"
					data-options="
                  prompt: '请输入名称……'" />
			</div>
			<div style="display: inline-block;">
				<label for="status">设备状态:</label> <select class="easyui-combobox"
					style="width: 80px;" id="status" name="status">
					<option value="">所有</option>
					<option value="0" selected="selected">离线</option>
					<option value="1">正常</option>
					<option value="2">告警</option>
					<option value="3">故障</option>
					<option value="4">不可通讯</option>
					<option value="5">未下发</option>
				</select>
			</div>
			<a href="javascript:void(0)"
				class="easyui-linkbutton button-edit button-default"
				data-options="iconCls:'icon-search'" onclick="doSearch()"
				title="Search">检索</a>
		</div>
	</div>
	<div id="devicedlg-buttons">
		<a href="#" class="easyui-linkbutton" iconCls="icon-cancel"
			onclick="javascript:$('#devicedg').datagrid('loadData', { total: 0, rows: [] }); $('#devicedlg').dialog('close');">关闭</a>
	</div>

</body>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/echarts/echarts.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/echarts/DarkGray.js"></script>
<script type="text/javascript">
var unitonline = document.getElementById('unitonline');
var unitChart = echarts.init(unitonline,'DarkGray');

var deviceonline = document.getElementById('deviceonline');
var deviceChart = echarts.init(deviceonline,'DarkGray'); // 初始化

var deviceonline10 = document.getElementById('deviceonline-10');
var deviceChart10 = echarts.init(deviceonline10,'DarkGray'); // 初始化

var deviceonline128 = document.getElementById('deviceonline-128');
var deviceChart128 = echarts.init(deviceonline128,'DarkGray'); // 初始化

var deviceonline129 = document.getElementById('deviceonline-129');
var deviceChart129 = echarts.init(deviceonline129,'DarkGray'); // 初始化

var deviceonline11 = document.getElementById('deviceonline-11');
var deviceChart11 = echarts.init(deviceonline11,'DarkGray'); // 初始化

var deviceonline130 = document.getElementById('deviceonline-130');
var deviceChart130 = echarts.init(deviceonline130,'DarkGray'); // 初始化

var deviceonline20 = document.getElementById('deviceonline-20');
var deviceChart20 = echarts.init(deviceonline20,'DarkGray'); // 初始化

var deviceonline131 = document.getElementById('deviceonline-131');
var deviceChart131 = echarts.init(deviceonline131,'DarkGray'); // 初始化

var deviceonline18 = document.getElementById('deviceonline-18');
var deviceChart18 = echarts.init(deviceonline18,'DarkGray'); // 初始化

var node;
var pnode;
var ppnode;
$(function(){
		
	$("#unitTr").hide();
	$("#deviceTr").hide();
	$(".hr").hide();
	$("#menuTab").hide();
	
	initCount(); 
	node = parent.node;
	if(node != null){
		pnode = parent.p_node;
		ppnode = parent.pp_node;
	
	    $("#selectedParentid").val(0);
	    $("#selectedUnitid").val(0);
	    $("#selectedUnitType").val(0);
	    var flag=true;
	    
	    switch (node.type){
	    case commonTreeNodeType.terminal:
	    	$("#selectedUnitType").val(1);
	    	break;
	    case commonTreeNodeType.transmission:
	    	$("#selectedUnitType").val(2);
	    	break;
	    case commonTreeNodeType.gprsBigType:
	        $("#selectedParentid").val(pnode.gid);//customerid
	        $("#selectedUnitType").val(3);
	        $("#uptype").val(0);
		    $("#commtype").val(3);
	    	break;
	    case commonTreeNodeType.terminalBigType:
	        $("#selectedUnitid").val(pnode.gid);//unitid
	        $("#selectedParentid").val(pnode.gid);//unitid
	        $("#selectedUnitType").val(1);
	        $("#uptype").val(1);
	    	break; 
	    case commonTreeNodeType.terminalDevice:
	    	$("#selectedParentid").val(pnode.gid);//bigtype----controlid
	        $("#selectedUnitid").val(ppnode.gid);//unitid
	        $("#uptype").val(1);
	    	break; 
	    case commonTreeNodeType.gprsDevice:
	    	$("#selectedUnitType").val(3);
	    	$("#uptype").val(0);
		    $("#commtype").val(3);
	    	break;
	    case commonTreeNodeType.nbBigType:
	    	$("#selectedParentid").val(pnode.gid);//customerid
	    	flag=false;
	    	$("#uptype").val(0);
		    $("#commtype").val(4);
	    	break;
	    case commonTreeNodeType.nbDevice:
	    	flag=false;
	    	$("#uptype").val(0);
		    $("#commtype").val(4);
	    	break;
	    }
		
		if(flag){
			$("#unitTr").show();
			searchUnitOnline();
		}else{
			$("#unitTr").hide();
		}
		//searchDeviceOnline();
	}
	else{
		$("#unitTr").show();
		searchUnitOnline();
		//searchDeviceOnline();
	}

}); 

function initCount(){
	$("label[id^='terminal-']").html(0);
	$("label[id^='transmission-']").html(0);
	$("label[id^='gprsdevice-']").html(0);
	$("label[id^='unit-']").html(0);
	$("label[id^='fire-']").html(0);
	$("label[id^='elec-']").html(0);
	$("label[id^='nb-']").html(0);
	$("label[id^='all-']").html(0);
	$("label[id^='normal-']").html(0);
	$("label[id^='unonline-']").html(0);
	$("label[id^='alarm-']").html(0);
	$("label[id^='fault-']").html(0);
	$("label[id^='nocomm-']").html(0);
	$("label[id^='nodown-']").html(0);
	$("#normal").html(0);
	$("#unonline").html(0);
	$("#alarm").html(0);
	$("#fault").html(0);
	$("#nocomm").html(0);
	$("#nodown").html(0);
	$("#all").html(0);
	
	$('#unitdlg').dialog({
	    onClose:function(){
	    	$("#unitdg").datagrid('loadData',{total:0,rows:[]});
	    }
	});
    
    $('#devicedlg').dialog({
	    onClose:function(){
	    	$("#devicedg").datagrid('loadData',{total:0,rows:[]});
	    }
	});
	
	$('#unitdg').datagrid({
   		url :'',
   		queryParams : { },
		pagination : true,//分页控件
		pageList: [10, 20, 30, 40, 50],
		fit: true,   //自适应大小
		singleSelect: true,
		iconCls : 'icon-save',
		border:false,
		nowrap: true,//数据长度超出列宽时将会自动截取。
		rownumbers:true,//行号
		fitColumns:true,//自动使列适应表格宽度以防止出现水平滚动。
		toolbar : "#unittoolbar",
		columns: [[ 			
			{title: '终端类型', field: 'typename', width:'100px'}, 
			{title: '终端地址', field: 'address', width:'125px'}, 
			{title: '终端名称', field: 'equipname', width:'200px',
				formatter : function(value, rowData, rowIndex) {
            		if(rowData.unitflie!=null){
						return rowData.unitflie.unitname;
            		}else{
            			return value;
            		}
				}	
	        },
	        {title: '状态', field: 'status',width:'80px',
				formatter : function(value, rowData, rowIndex) {
					if(value==0){
            			return "<span style='color:red'>离线<span>";
            		}else{
            			return "在线";
            		}
				}	
	        }, 
			{title: '在线时间', field: 'onlinetime', width:'140px'},
			{title: '离线时间', field: 'droppedtime', width:'140px'}       
		]]
	});
	
	$('#devicedg').datagrid({
   		url :'',
   		queryParams : { },
   		pagination : true,//分页控件
		pageList: [10, 20, 30, 40, 50],
		fit: true,   //自适应大小
		singleSelect: true,
		border:false,
		nowrap: true,//数据长度超出列宽时将会自动截取。
		rownumbers:true,//行号
		fitColumns:true,//自动使列适应表格宽度以防止出现水平滚动。
		toolbar : "#devicetoolbar",
		columns: [[ 
			{title: '用户名', field: 'customername', width:'180px',
				formatter : function(value, rowData, rowIndex) {
            		if(rowData.unitflie!=null){
						return rowData.unitflie.customername;
            		}else{
            			return value;
            		}
				}	
	        },
			{title: '设备类型', field: 'equipmenttypename', width:'120px'},
			{title: '设备名称', field: 'equipmentname', width:'160px'},
			{title: '设备地址', field: 'equipmentaddress',width:'135px'},
			{title: '设备状态', field: 'statustype', width:'80px',
				formatter : function(value, rowData, rowIndex) {
					switch(value){
					case 0: return "<span style='color:#8a8a8a'>离线</span>"; break;
					case 1: return "<span style='color:#4caf50'>正常</span>"; break;
					case 2: return "<span style='color:#ca1d1d'>告警</span>"; break;
					case 3: return "<span style='color:#d4941f'>故障</span>"; break;
					case 4: return "<span style='color:#ad5d5d'>不可通讯</span>"; break;
					case 5: return "<span style='color:#2091c3'>未下发</span>"; break;
					default: return ""; break;
					}
				}	
	        },
	        {title: '所属终端状态', field: 'unitstatus', width:'80px',
				formatter : function(value, rowData, rowIndex) {
					switch(value){
					case 0: return "<span style='color:#8a8a8a'>离线</span>"; break;
					case 1: return "<span style='color:#4caf50'>在线</span>"; break;
					default: return ""; break;
					}
				}	
	        },
	        {title: '冻结类型', field: 'freezingtype', width:'80px',
				formatter : function(value, rowData, rowIndex) {
					switch(value){
					case 11: return "日冻结"; break;
					case 77: return "周冻结"; break;
					case 99: return "月冻结"; break;
					default: return ""; break;
					}
				}	
	        },
	        {title: '上次冻结时间', field: 'freezetime', width:'140px'}, 
	        {title: '上次告警时间', field: 'alarmtime', width:'140px'}, 
	        {title: '上次故障时间', field: 'faulttime', width:'140px'}, 
	        {title: '系统类型', field: 'systemtypename', width:'200px'},  
	        {title: '所属楼层', field: 'buildingname', width:'100px'}, 
	        {title: '安装位置', field: 'installationsite', width:'150px'}
		]]
	});
}

//终端在线率：按终端类型（消防监测终端、用传、GPRS）
function searchUnitOnline(){
	var unitonlineurl = "${pageContext.request.contextPath}/unitonline?Math.random()";
	$.ajax({   type : "POST",
		url : unitonlineurl,
		data : {
			id : $("#selectedID" , parent.document).val(),
			type : $("#selectedType" , parent.document).val(),
			nodeName : $("#selectedAddress" , parent.document).val(),
			parentid : $("#selectedParentid").val(),
			unitid : $("#selectedUnitid").val(),
			unittype : $("#selectedUnitType").val()
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
			$.messager.alert("警告",  "获取终端在线率数据方法错误。", "error");
		}, //错误执行方法
		success : function(d) {
			$("body").find("div.datagrid-mask-msg").remove();
            $("body").find("div.datagrid-mask").remove();
            if(typeof d!="string")
            	makeUnitCurve(d);//------后台获取数据成功，前台展示待续饼图
            else
            	$.messager.alert("警告",  "获取终端在线率数据失败。", "error");
		}
	}); //ajax
}

var label= {
    normal: {
        show: false
    },
    emphasis: {
        show: false
    }
};
var labelLine= {
    normal: {
        show: false
    },
    emphasis: {
        show: false
    }
};

function makeUnitCurve(d){
	var online=0,offline=0;
	for ( var p in d) {
		var list=d[p];
		var type=list[0],unitonlinecount=parseInt(list[1]),notunitonlinecount=parseInt(list[2]),totalcount=parseInt(list[3]);
		online+=unitonlinecount;
		offline+=notunitonlinecount;
		var total = unitonlinecount + notunitonlinecount;
		switch(p){
		case "1":
			$("#terminal-normal").html(unitonlinecount);
			$("#terminal-unonline").html(notunitonlinecount);
			$("#terminal-all").html(total);
			break;
		case "2":
			$("#transmission-normal").html(unitonlinecount);
			$("#transmission-unonline").html(notunitonlinecount);
			$("#transmission-all").html(total);
			break;
		default:
			$("#gprsdevice-normal").html(unitonlinecount);
			$("#gprsdevice-unonline").html(notunitonlinecount);
			$("#gprsdevice-all").html(total);
			break;
		}
	}
	if(online+offline!=0){
		$("#unit-normal").html(online);
		$("#unit-unonline").html(offline);
		$("#unit-all").html((online+offline));

		unitChart.clear();
		unitChart.resize();
		
		var option = {
			    tooltip : {
			        trigger: 'item',
			        formatter: "{b} :<br/>{c} ({d}%)"
			    },
			    legend:{ 
			    	orient: 'vertical',
			        x: 'left',
			        data : ["正常","离线"] 
		        },
			    series: [
			        {
			            name:'终端',
			            type:'pie',
			            radius: ['60%', '75%'],
			            avoidLabelOverlap: false,
			            data:[
			                {value:online, name:'正常', 
			                	label: {
					                normal: {
					                    show: true,
					                    position: 'center',
					                    textStyle: {
					                        fontSize: '15'
					                    },
			                			formatter : '{b}\n{c} 个'
					                },
					                emphasis: {
					                    show: true,
					                    textStyle: {
					                        fontSize: '20',
					                        fontWeight: 'bold'
					                    }
					                }
					            },
					            labelLine:labelLine,itemStyle:{color: '#4caf50'}
					        },
			                {value:offline, name:'离线', label:label,labelLine:labelLine,
			                	itemStyle:{color: '#8a8a8a'}
					        }
			            ]
			        }
			    ]
			};
		unitChart.setOption(option);
		window.onresize = unitChart.resize;
	}
	else{
		$("#unitTr").hide();
	}
}

//增加监听事件
function unitInfo(typename,unittype,status) {
   	var temp="";
   	if(status=="0") temp="离线";
   	else if(status=="1") temp="在线";
   	else temp="所有";

   	var title=typename;
   	if(title!="") title+="--";
   	title+=temp+"终端";
   	
   	$('#unitdlg').dialog('open').dialog('setTitle',title);

   	var opts = $("#unitdg").datagrid("options");
    opts.url = basePath + '/unitFileInf?Math.random';
    opts.queryParams = {
    		id : $("#selectedID" , parent.document).val(),
			type : $("#selectedType" , parent.document).val(),
			nodeName : $("#selectedAddress" , parent.document).val(),
			parentid : $("#selectedParentid").val(),
   			unitid : $("#selectedUnitid").val(),
   			status : status,
   			unittype : unittype
    	};
    $("#unitdg").datagrid("load");
}
//终端在线率：按终端类型（消防监测终端、用传、GPRS） 

//设备在线率：按设备类型（消防监测终端设备、用传设备、GPRS设备、NB设备）
//function searchDeviceOnline(){
//	var deviceonlineurl = "${pageContext.request.contextPath}/deviceonline?Math.random()";
//	$.ajax({   type : "POST",
//		url : deviceonlineurl,
//		data : {
//			id : $("#selectedID" , parent.document).val(),
//			type : $("#selectedType" , parent.document).val(),
//			nodeName : $("#selectedAddress" , parent.document).val(),
//			parentid : $("#selectedParentid").val(),
//			uptype : $("#uptype").val(),
//			commtype : $("#commtype").val()
//		},
//		async : true,
//		beforeSend : function() {
			//加载层
//            if ($("body").find(".datagrid-mask").length == 0) {
                //添加等待提示
//               $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
 //              $("<div class=\"datagrid-mask-msg\"></div>").html("加载中，请稍后...").appendTo("body").css({ color:'#fff', display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
//            }
//		}, //加载执行方法
//		error : function() {
//			$.messager.alert("警告",  "获取设备在线率数据方法错误。", "error");
//		}, //错误执行方法
//		success : function(d) {
//			$("body").find("div.datagrid-mask-msg").remove();
 //           $("body").find("div.datagrid-mask").remove();
            
//            if(typeof d!="string")
//            	makeDeviceCurve(d);//------后台获取数据成功，前台展示待续饼图
 //           else
 //           	$.messager.alert("警告",  "获取设备在线率数据失败。", "error");
//		}
//	}); //ajax
//}

function makeDeviceCurve(d){
	var unonline = 0, normal = 0, alarm = 0, fault = 0, nocomm = 0, nodown = 0;

	var existDevice=[];
	var unknowntype = 0;
	var unAddress=[];
	for ( var key in d) {
		var value=d[key];
		
		var systemtype = key.split('-');
		var systemtypename = systemtype[1].replace(/(.*)系统/,'$1设备');
		existDevice.push(systemtypename);
		
		var s_name = [], subunonline = [], subnormal = [], subalarm = [], subfault = [];
		var subnocomm = [], subnodown = [];
		for (var subname in value) {
			var statustype=value[subname];
			if(subname.indexOf("-")!=-1){
				s_name.push(subname); 
				subunonline.push(statustype[0]); 
				subnormal.push(statustype[1]);
				subalarm.push(statustype[2]);
				subfault.push(statustype[3]);
				subnocomm.push(statustype[4]);
				subnodown.push(statustype[5]);
			}
			else{//出现0，则表示有设备的型号不匹配（主要看上行设备类型和通讯类型）
				unknowntype += statustype[0] + statustype[1] + statustype[2] + statustype[3] + 
					statustype[4] + statustype[5];
				var ss = "";
				switch(statustype.join("").indexOf('1')){
				case 0:ss = ":离线";break;
				case 1:ss = ":正常";break;
				case 2:ss = ":告警";break;
				case 3:ss = ":故障";break;
				case 4:ss = ":不可通讯";break;
				case 5:ss = ":未下发";break;
				}
				unAddress.push(subname+ss); 
			}

			unonline += statustype[0]; 
			normal += statustype[1];
			alarm += statustype[2];
			fault += statustype[3];
			nocomm += statustype[4];
			nodown += statustype[5];
		}
		
		makePie(systemtype[0],s_name,subnormal,subunonline,subalarm,subfault,subnocomm,subnodown);
	}
	
	if(unknowntype!=0)
		$("#unknowntype").html("(存在" + unknowntype + "个无法确定类型的设备)<br/>"+unAddress.join('<br/>'));
	else
		$("#unknowntype").html("");
	
	//先全部隐藏
	var all=["电气火灾监控设备","烟雾监控设备","消防水压监控设备","可燃气体报警设备","报警按钮及声光报警器",
		"消火栓设备","消防水位监控设备","防火卷级防火门监控设备"];
	for(var i=0;i<all.length;i++)
		$('#menuTab').tabs('getTab',all[i]).panel('options').tab.hide();
	
	//判断是否存在设备
	if(existDevice.length==0 || normal+unonline+alarm+fault+nocomm+nodown==0){
		$('#menuTab .tabs-panels').css("display","none");	
		$("#deviceTr").hide();
		$(".hr").hide();
		$("#menuTab").hide();
	}
	else{
		$('#menuTab .tabs-panels').css("display","block");
		$("#menuTab").show();
		
		var firstTitle = "";
		for(var i=0;i<existDevice.length;i++){
			$('#menuTab').tabs('getTab',existDevice[i]).panel('options').tab.show();
			if(i==0) firstTitle = existDevice[i];
		}

		var title = $('#menuTab .tabs-selected').text(); 
		if($.inArray(title, existDevice)==-1)
			$("#menuTab").tabs('select',firstTitle);
		
		$("#deviceTr").show();$(".hr").show();
		makePie("",[],normal,unonline,alarm,fault,nocomm,nodown);
	}
}

function makePie(systemtype,name,normal,unonline,alarm,fault,nocomm,nodown){
	var Chart;
	var r_normal=0,r_unonline=0,r_alarm=0,r_fault=0,r_nocomm=0,r_nodown=0;
	
	if(systemtype==""){
		r_normal=normal;r_unonline=unonline;r_alarm=alarm;r_fault=fault;r_nocomm=nocomm;r_nodown=nodown;

		Chart=deviceChart;
		var r_total = r_normal + r_unonline + r_alarm + r_fault + r_nocomm + r_nodown;
		$("#all").html(r_total);
		$("#normal").html(r_normal);
		$("#unonline").html(r_unonline);
		$("#alarm").html(r_alarm);
		$("#fault").html(r_fault);
		$("#nocomm").html(r_nocomm);
		$("#nodown").html(r_nodown);
	}else{
		var index = name.length;
		for(var i=0;i<index;i++){
			r_normal+=normal[i];
			r_unonline+=unonline[i];
			r_alarm+=alarm[i];
			r_fault+=fault[i];
			r_nocomm+=nocomm[i];
			r_nodown+=nodown[i];
		}
		var r_total = r_normal + r_unonline + r_alarm + r_fault + r_nocomm + r_nodown;
		
		var total = 0;
		switch(systemtype){
		case "18":case "20":case "130":
			if(systemtype=="18") Chart=deviceChart18;
			else if(systemtype=="20") Chart=deviceChart20;
			else Chart=deviceChart130;
			if(index==1 && name[0].indexOf("1-")>-1){
				total = normal[0] + unonline[0] + alarm[0] + fault[0] + nocomm[0] + nodown[0];
				$("#fire-normal-" + systemtype).html(normal[0]);
				$("#fire-unonline-" + systemtype).html(unonline[0]);
				$("#fire-alarm-" + systemtype).html(alarm[0]);
				$("#fire-fault-" + systemtype).html(fault[0]);
				$("#fire-nocomm-" + systemtype).html(nocomm[0]);
				$("#fire-nodown-" + systemtype).html(nodown[0]);
				$("#fire-all-" + systemtype).html(total);
			}
			break;
		case "10":
			$("#all-10").html(r_total);
			$("#normal-10").html(r_normal);
			$("#unonline-10").html(r_unonline);
			$("#alarm-10").html(r_alarm);
			$("#fault-10").html(r_fault);
			$("#nocomm-10").html(r_nocomm);
			$("#nodown-10").html(r_nodown);
			
			Chart=deviceChart10;
			
			var fire_index=-1,other_index=-1;
			switch(index){
			case 2:
				if(name[0].indexOf("1-")>-1){
					fire_index = 0;
					other_index = 1;
				}else{
					fire_index = 1;
					other_index = 0;
				}
				break;
			case 1:
				if(name[0].indexOf("1-")>-1) fire_index = 0;
				else other_index = 0;
				break;
			}
			
			if(fire_index != -1){
				total = normal[fire_index] + unonline[fire_index] + alarm[fire_index] + fault[fire_index] 
					+ nocomm[fire_index] + nodown[fire_index];
				$("#fire-normal-10").html(normal[fire_index]);
				$("#fire-unonline-10").html(unonline[fire_index]);
				$("#fire-alarm-10").html(alarm[fire_index]);
				$("#fire-fault-10").html(fault[fire_index]);
				$("#fire-nocomm-10").html(nocomm[fire_index]);
				$("#fire-nodown-10").html(nodown[fire_index]);
				$("#fire-all-10").html(total);
			}
			
			if(other_index != -1){
				total = normal[other_index] + unonline[other_index] + alarm[other_index] + fault[other_index] 
					+ nocomm[other_index] + nodown[other_index];
				$("#elec-normal-10").html(normal[other_index]);
				$("#elec-unonline-10").html(unonline[other_index]);
				$("#elec-alarm-10").html(alarm[other_index]);
				$("#elec-fault-10").html(fault[other_index]);
				$("#elec-nocomm-10").html(nocomm[other_index]);
				$("#elec-nodown-10").html(nodown[other_index]);
				$("#elec-all-10").html(total);
			}
			
			break;
		case "128":case "129":case "131":
			$("#all-" + systemtype).html(r_total);
			$("#normal-" + systemtype).html(r_normal);
			$("#unonline-" + systemtype).html(r_unonline);
			$("#alarm-" + systemtype).html(r_alarm);
			$("#fault-" + systemtype).html(r_fault);
			$("#nocomm-" + systemtype).html(r_nocomm);
			$("#nodown-" + systemtype).html(r_nodown);
			
			if(systemtype=="128") Chart=deviceChart128;
			else if(systemtype=="129") Chart=deviceChart129;
			else Chart=deviceChart131;
	
			var fire_index=-1,other_index=-1;
			switch(index){
			case 2:
				if(name[0].indexOf("1-")>-1){
					fire_index = 0;
					other_index = 1;
				}else{
					fire_index = 1;
					other_index = 0;
				}
				break;
			case 1:
				if(name[0].indexOf("1-")>-1) fire_index = 0;
				else other_index = 0;
				break;
			}
			
			if(fire_index != -1){
				total = normal[fire_index] + unonline[fire_index] + alarm[fire_index] + fault[fire_index] 
					+ nocomm[fire_index] + nodown[fire_index];
				$("#fire-normal-" + systemtype).html(normal[fire_index]);
				$("#fire-unonline-" + systemtype).html(unonline[fire_index]);
				$("#fire-alarm-" + systemtype).html(alarm[fire_index]);
				$("#fire-fault-" + systemtype).html(fault[fire_index]);
				$("#fire-nocomm-" + systemtype).html(nocomm[fire_index]);
				$("#fire-nodown-" + systemtype).html(nodown[fire_index]);
				$("#fire-all-" + systemtype).html(total);
			}
			
			if(other_index != -1){
				total = normal[other_index] + unonline[other_index] + alarm[other_index] + fault[other_index] 
					+ nocomm[other_index] + nodown[other_index];
				$("#nb-normal-" + systemtype).html(normal[other_index]);
				$("#nb-unonline-" + systemtype).html(unonline[other_index]);
				$("#nb-alarm-" + systemtype).html(alarm[other_index]);
				$("#nb-fault-" + systemtype).html(fault[other_index]);
				$("#nb-nocomm-" + systemtype).html(nocomm[other_index]);
				$("#nb-nodown-" + systemtype).html(nodown[other_index]);
				$("#nb-all-" + systemtype).html(total);
			}
			break;
		case "11":
			$("#all-11").html(r_total);
			$("#normal-11").html(r_normal);
			$("#unonline-11").html(r_unonline);
			$("#alarm-11").html(r_alarm);
			$("#fault-11").html(r_fault);
			$("#nocomm-11").html(r_nocomm);
			$("#nodown-11").html(r_nodown);
			
			Chart=deviceChart11;
	
			var fire_index=-1,mid_index=-1,other_index=-1;
			switch(index){
			case 3:
				if(name[0].indexOf("1-")>-1){
					fire_index = 0;
					if(name[1].indexOf("2-")>-1){ mid_index = 1; other_index = 2;}
					else{ other_index = 1; mid_index = 2;}
				}else if(name[0].indexOf("2-")>-1){
					mid_index = 0;
					if(name[1].indexOf("1-")>-1){ fire_index = 1; other_index = 2;}
					else{ other_index = 1; fire_index = 2;}
				}
				else{
					other_index = 0;
					if(name[1].indexOf("1-")>-1){ fire_index = 1; mid_index = 2;}
					else{ mid_index = 1; fire_index = 2;}
				}
				break;
			case 2:
				if(name[0].indexOf("1-")>-1){
					fire_index = 0;
					if(name[1].indexOf("2-")>-1) mid_index = 1;
					else other_index = 1;
				}else if(name[0].indexOf("2-")>-1){
					mid_index = 0;
					if(name[1].indexOf("1-")>-1) fire_index = 1;
					else other_index = 1;
				}
				else{
					other_index = 0;
					if(name[1].indexOf("1-")>-1) fire_index = 1;
					else mid_index = 1;
				}
				break;
			case 1:
				if(name[0].indexOf("1-")>-1) fire_index = 0;
				else if(name[0].indexOf("2-")>-1) mid_index = 0;
				else other_index = 0;
				break;
			}
			
			if(fire_index != -1){
				total = normal[fire_index] + unonline[fire_index] + alarm[fire_index] + fault[fire_index] 
					+ nocomm[fire_index] + nodown[fire_index];
				$("#fire-normal-11").html(normal[fire_index]);
				$("#fire-unonline-11").html(unonline[fire_index]);
				$("#fire-alarm-11").html(alarm[fire_index]);
				$("#fire-fault-11").html(fault[fire_index]);
				$("#fire-nocomm-11").html(nocomm[fire_index]);
				$("#fire-nodown-11").html(nodown[fire_index]);
				$("#fire-all-11").html(total);
			}
			
			if(mid_index != -1){
				total = normal[mid_index] + unonline[mid_index] + alarm[mid_index] + fault[mid_index] 
					+ nocomm[mid_index] + nodown[mid_index];
				$("#elec-normal-11").html(normal[mid_index]);
				$("#elec-unonline-11").html(unonline[mid_index]);
				$("#elec-alarm-11").html(alarm[mid_index]);
				$("#elec-fault-11").html(fault[mid_index]);
				$("#elec-nocomm-11").html(nocomm[mid_index]);
				$("#elec-nodown-11").html(nodown[mid_index]);
				$("#elec-all-11").html(total);
			}
			
			if(other_index != -1){
				total = normal[other_index] + unonline[other_index] + alarm[other_index] + fault[other_index] 
					+ nocomm[other_index] + nodown[other_index];
				$("#nb-normal-11").html(normal[other_index]);
				$("#nb-unonline-11").html(unonline[other_index]);
				$("#nb-alarm-11").html(alarm[other_index]);
				$("#nb-fault-11").html(fault[other_index]);
				$("#nb-nocomm-11").html(nocomm[other_index]);
				$("#nb-nodown-11").html(nodown[other_index]);
				$("#nb-all-11").html(total);
			}
			break;
		}
	}

	Chart.clear();
	Chart.resize();
	
	var option = {
		    tooltip : {
		        trigger: 'item',
		        formatter: "{b} :<br/>{c} ({d}%)"
		    },
		    legend:{ 
		    	orient: 'vertical',
		        x: 'left',
		        data : ["正常","离线","告警","故障","不可通讯","未下发"] 
	        },
		    series: [
		        {
		            name:'设备',
		            type:'pie',
		            radius: ['60%', '75%'],
		            avoidLabelOverlap: false,
		            data:[
		                {value:r_normal, name:'正常', 
		                	label: {
				                normal: {
				                    show: true,
				                    position: 'center',
				                    textStyle: {
				                        fontSize: '15'
				                    },
		                			formatter : '{b}\n{c} 个',
				                },
				                emphasis: {
				                    show: true,
				                    textStyle: {
				                        fontSize: '20',
				                        fontWeight: 'bold'
				                    }
				                }
				            },
				            labelLine:labelLine,itemStyle:{color: '#4caf50'}
				        },
		                {value:r_alarm, name:'告警', label:label,labelLine:labelLine,
		                	itemStyle:{color: '#ca1d1d'}
				        },
		                {value:r_fault, name:'故障', label:label,labelLine:labelLine,
							itemStyle:{color: '#d4941f'}
				        },
		                {value:r_unonline, name:'离线', label:label,labelLine:labelLine,
		                	itemStyle:{color: '#8a8a8a'}
				        },
		                {value:r_nocomm, name:'不可通讯', label:label,labelLine:labelLine,
		                	itemStyle:{color: '#ad5d5d'}
				        },
		                {value:r_nodown, name:'未下发', label:label,labelLine:labelLine,
		                	itemStyle:{color: '#2091c3'}
				        }
		            ]
		        }
		    ]
		};
	
	Chart.setOption(option);
}

//增加监听事件
function deviceInfo(name,systemtype,subtype,statustype) {
	$("#status").combobox("setValue",statustype);
	$("#systemtype").val(systemtype);
	$("#subtype").val(subtype);

	var title = name;
	if(title!="") title += "--";
   	$('#devicedlg').dialog('open').dialog('setTitle',title);
   	
   	$('#devicestatusaddress').textbox("setValue","");
	$('#devicestatusname').textbox("setValue","");
	
   	doSearch();
}

function doSearch(){
	var statustype = $("#status").combobox("getValue");
	
	var status ="";
   	switch(statustype){
   	case '0': status = "离线"; break;
   	case '1': status = "正常"; break;
	case '2': status = "告警"; break;
    case '3': status = "故障"; break;
    case '4': status = "不可通讯"; break;
    case '5': status = "未下发"; break;
    default: status = "所有";break;
    }
   	
   	var opts = $('#devicedlg').panel('options');
	var title = opts.title;//获取title属性
	title = title.substring(0, title.lastIndexOf("-")+1)+status+"设备";
   	$('#devicedlg').dialog('setTitle',title);
	
	var opts = $("#devicedg").datagrid("options");
    opts.url = basePath + '/deviceFileInf?Math.random';
    opts.queryParams = {
    		id : $("#selectedID" , parent.document).val(),
			type : $("#selectedType" , parent.document).val(),
			nodeName : $("#selectedAddress" , parent.document).val(),
   			parentid : $("#selectedParentid").val(),
   			systemtype : $("#systemtype").val(),
   			subtype : $("#subtype").val(),
   			status : statustype,
	    	equipmentaddress : $('#devicestatusaddress').textbox("getValue"),
			equipmentname : $('#devicestatusname').textbox("getValue")
    	};
    $("#devicedg").datagrid("load");
}
//设备在线率：按设备类型（消防监测终端设备、用传设备、GPRS设备、NB设备）
</script>
</html>