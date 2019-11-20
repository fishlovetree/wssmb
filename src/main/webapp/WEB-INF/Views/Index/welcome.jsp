<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
    <%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>

<jsp:include page="../Header.jsp"/>
<style type="text/css">
.row{
	width: 100%;
    text-align: center;
	/* padding-top: 10px; */
}
.col{
	display: inline-block;
    text-align: center;
    position: relative;
    min-height: 1px;
    width:245px;
}
.card{
    margin-bottom: 20px;
    margin-top: 10px;
    background-color: #ffffff;
    border: 1px solid #ccc;
    border-radius: 4px;
    -webkit-box-shadow: 1px 1px 5px 1px #cccccc;
    box-shadow: 1px 1px 5px 1px #cccccc;
}
.panel-heading {
    padding: 10px 0px;
    border-top-right-radius: 6px;
    border-top-left-radius: 6px;
}
.topfa{
	position: relative;
    min-height: 1px;
    padding-right: 15px;
    padding-left: 15px;
    display: inline-block;
}
.topa{
	position: relative;
    display: inline-block;
    padding: 5px 0px 5px 0px;
    color: #654b24;
}
.topfa2{
	display: inline-block;
    padding: 5px 0px 5px 0px;
    color: #654b24;
    float: right;
    right: 10px;
    margin-right: 10px;
}
.text-right {
    text-align: right;
}
.announcement-heading, .announcement-heading label {
	font-size: 35px;
    margin: 0;
    font-weight: bold;
    color: #545454;
}
.announcement-text {
    margin: 0;
    color: #888;
}

a {
    color: #428bca;
    text-decoration: none;
    background: transparent;
}

.testButton { 
	color:rgb(255, 255, 255) !important;
	font-size:15px;
	padding-top:6px;
	padding-bottom:6px;
	padding-left:15px;
	padding-right:15px;
	border-width:3px;
	border-color:rgb(255, 246, 235);
	border-style:double;
	border-radius:3px;
}
.testButton-unselect { 
	background-color:#adadad;
}
.testButton-select { 
	background-color:#fb9d48;
}
.testButton:hover{
	background-color:#ffbf70;
	border-color:#ffffff;
}

.table-data-table{
    font-size: 12px;
    table-layout: fixed;
    empty-cells: show;
    border-collapse: collapse;
    margin: 5px auto;

    color: #666;
    width: 100%;
} 
.table-data-table td{ 
	padding:0 1em 0; 
	height:30px; 
} 

.panel-body {
    /* border: 1px !important; */
}

#warn{
	width: 97%;
	margin:0px auto;
}
dt{
	padding: 5px 0 10px 10px;
    color: red;
    font-size: 12px;
    background: #fff9e0;
    border: 1px solid #ccc;
    margin-bottom: -5px;
}
dd{
	margin-top: -5px;
	border-bottom: 1px solid #ccc;
    border-left: 1px solid #ccc;
    border-right: 1px solid #ccc;
}
.datagrid-body .datagrid-cell {
    text-align: left !important;
}
</style>

<script type="text/javascript">

</script>
</head>
<body ><!-- style="min-width:1000px;" -->

</body>
</html>