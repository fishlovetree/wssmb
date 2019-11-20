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
<title>Insert title here</title>
</head>
<body>
<c:set var="type" value="${requestScope.type}" />
	<table id="tableList" cellpadding=5 class="mTable" cellspacing=0 width=100% height=100%
		align="center" border="1px">
		<tr style="background: #f3f3f3; height: 5%">
			<td align="center" style="width: 12%">过温</td>
			<td align="center" style="width: 12%">水压欠压</td>
			<td align="center" style="width: 12%">水压过压</td>
			<td align="center" style="width: 12%">功率因数超</td>
			<td align="center" style="width: 12%">功率过载</td>
			<td align="center" style="width: 12%">电流过流</td>
			<td align="center" style="width: 12%">电压欠压</td>
			<td align="center" style="width: 12%">电压过压</td>

		</tr>
		<tr id="${type}_01" style="height: 5%">
			<c:set var="goods" value="${requestScope.arry}" />
			<c:forEach items="${goods}" varStatus="s" begin="1" end="8">
				 <c:set var="good" value="${goods[s.index +8]}" />
				<c:choose>
					<c:when test="${good==1}">
						<td align="center" style="width: 12%"><input id="sb${s.index}"
							name="sb" class="easyui-switchbutton switchbutton-yellow"
							data-options="onText:'支持',offText:'不支持'," checked></td>
					</c:when>
					<c:otherwise>
						<td  align="center" style="width: 12%"><input id="sb${s.index}" name="sb"
							class="easyui-switchbutton switchbutton-yellow"
							data-options="onText:'支持',offText:'不支持',"></td>
					</c:otherwise>
				</c:choose>
			</c:forEach>
		</tr>
		<tr style="background: #f3f3f3; height: 5%">
			<td align="center" style="width: 12%">保留</td>
			<td align="center" style="width: 12%">温升判断</td>
			<td align="center" style="width: 12%">低水位报警</td>
			<td align="center" style="width: 12%">超水位报警</td>
			<td align="center" style="width: 12%">报警按钮</td>
			<td align="center" style="width: 12%">燃气报警</td>
			<td align="center" style="width: 12%">烟感报警</td>
			<td align="center" style="width: 12%">剩余电流超</td>

		</tr>
		<tr id="${type}_02" style="height: 5%">			
			<c:set var="goods" value="${requestScope.arry}" />
			<c:forEach items="${goods}" varStatus="s" begin="1" end="8">
				<c:set var="good" value="${goods[s.index]}" />
				 <c:choose>
					<c:when test="${s.index<2}">
						<td align="center" style="width: 12%"><input id="sb${17-s.index}" name="sb"
							class="easyui-switchbutton"
							data-options="onText:'保留',offText:'保留',readonly:true"></td>
					</c:when>
					<c:when test="${good==1}">
						<td align="center" style="width: 12%"><input id="sb${17-s.index}" name="sb"
							class="easyui-switchbutton switchbutton-yellow" 
							data-options="onText:'支持',offText:'不支持'," checked></td>
					</c:when>
					<c:otherwise>
						<td align="center" style="width: 12%"><input id="sb${17-s.index}" name="sb"
							class="easyui-switchbutton switchbutton-yellow"
							data-options="onText:'支持',offText:'不支持',"></td>
					</c:otherwise>				
				</c:choose> 
			</c:forEach>
		</tr>
	</table>	
</body>
</html>