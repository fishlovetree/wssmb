<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
    <%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<style>
    .editTable .label {
        min-width: 80px;
        width: 80px;
    }
    .easyui-passwordbox + .textbox .textbox-addon .textbox-icon {
	    background-position: -1px center;
	}
	.editTable{
		margin: auto;
	    position: relative;
	    top: 28px;
	}
</style>
<table class="editTable">
    <tr>
        <td class="label"><spring:message code="UserName"/>:</td>
        <td><input class="easyui-textbox" type="text" id="name" name="name" value="${requestScope.username}"></td>
    </tr>
    <tr>
        <td class="label"><spring:message code="OldPassword"/>:</td>
        <td><input class="easyui-passwordbox" type="text" id="oldpassword" name="oldpassword"></td>
    </tr>
    <tr>
        <td class="label"><spring:message code="NewPassword"/>:</td>
        <td><input class="easyui-passwordbox" type="text" id="password" name="password">
        </td>
    </tr>
    <tr>
        <td class="label"><spring:message code="RepeatNewPassword"/>:</td>
        <td><input class="easyui-passwordbox" type="text" id="password2" name="password2"></td>
    </tr>
</table>

<script type="text/javascript">
    $(function () {
        $('#name').textbox({
            width: 200,
            readonly: true
        });
        $('#oldpassword').passwordbox({
        	width: 200,
            required: true,
            validType: 'maxLength[50]'
        });
        $('#password').passwordbox({
            width: 200,
            required: true,
            validType: 'maxLength[50]'
        });
        $('#password2').passwordbox({
            width: 200,
            required: true,
            validType: "equals['#password']"
        });
    });
</script>
</body>
</html>