$(function () {
    //设焦点
    if ($("input[name='userlogin']").val() == '') {
        $("input[name='userlogin']").focus();
    } else if ($("input[name='userpwd']").val() == '') {
    	$("input[name='userpwd']").focus();
    } else {
        $("input[name='authcode']").focus();
    }

    //$(":text,:password").addClass("textWidth");

    AutoPos();                                           //窗口位置
    $(window).resize(AutoPos);

    //单击切换验证码
    $(".authcode").click(function () {
    	$(this).attr('src','Kaptcha.jpg?' + Math.floor(Math.random() * 100));
    });
    
    $("#userlogin").blur(function(){
    	/*var username = $(this).val();
        if(username != '') {
	   	 	var data={"userlogin":username};
	        $.ajax({
		       	url:"${pageContext.request.contextPath}/getOrginization",
		       	data:data,
		       	type:"post",
		       	dataType:"json",
		       	success:function(result){
		       		if(result=="0"){
		       			alert('获取组织机构失败');
		       			return;
		       		}else{
		       			$("#orginizationName").html("XXXXX");  
		       		}
		       	},
		       	error:function(e){
		       		alert('连接服务器失败');
		       	}
	       });
        }*/
    });
});

function changecode(){
	$(".authcode").attr('src','/WSSF/admin/Kaptcha.jpg?' + Math.floor(Math.random() * 100));
}

//调节登录窗口的位置
var AutoPos=function() {
    var high = $(window).height();
    //$(".login_div").css({ "top": (high / 2) - 240 });
}

//控制在子页登录验证失败后不会在子框架中显示
if (window != top)
    top.location.href = location.href;  
