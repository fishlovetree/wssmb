<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>异常界面</title>
<style type="text/css">
.box{
    width: 100%;
    height: 300px;
    text-align: center;
    position: relative;
}
.box span{
	color: slategrey;
    position: absolute;
    left: 50%;
    top: 50%;
    -webkit-transform: translate(-50%, -50%);
    -moz-transform: translate(-50%, -50%);
    -ms-transform: translate(-50%, -50%);
    -o-transform: translate(-50%, -50%);
    transform: translate(-50%, -50%);
}
</style>
</head>
<body>
	<!-- yemianwufangwenquanxian --><!-- 用于判断页面，前面的注释不能删除 -->
	<div class="box">
	    <span>无访问权限(登录信息失效或密码已更改)，<a style="color: #5d5df1; cursor: pointer;" onclick="toLogin()">点击此处</a>，跳转到登录页，
	    	或者刷新系统，然后重新登录！！！</span>
	</div>
	<script type="text/javascript">
		function toLogin(){
			top.location.href= "${pageContext.request.contextPath}/login";
		}
	</script>
</body>
</html>