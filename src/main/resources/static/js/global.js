// 一些公用简化封装方法对象。
//扩展easyui校验规则
$.extend($.fn.validatebox.defaults.rules, {
	ip: {// 验证IP
	    validator: function(value){
	       return /\d+\.\d+\.\d+\.\d+/.test(value);
	    },
	    message: '请输入正确的IP地址。'
	},
	length: { validator: function (value, param) {
        var len = $.trim(value).length;
            return len == param[0];
        },
        message: "输入内容长度必须为{0}。"
    },
	minlength:{  
        validator:function(value,param){  
            return value.length >= param[0]  
        },  
        message:'至少输入{0}个字。'  
    },  
    maxlength:{  
        validator:function(value,param){  
            return value.length <= param[0]  
        },  
        message:'最多{0}个字。'  
    }, 
	coordinate:{
      validator: function(value){ 
    	  return /^\[[-\+]?\d+(\.\d+)\,[-\+]?\d+(\.\d+),[-\+]?\d+(\.\d+)\]$/.test(value);
         },    
	   message: '坐标固定格式[xxx.xx,xxx.xx,xxx.xx]' 
	},
	mobile:{
		validator: function(value){
			return /^1[3|4|5|7|8][0-9]\d{8}$/.test(value);
		},
		message: '不是正确的11位手机号' 
	},
	userlogin:{
		validator: function(value){
			return /^\w+$/.test(value);
		},
		message: '账号只能由数字和26个英文字母或者下划线组成' 
	}
});

//dialog 恒居中和蓝色主题
$.extend($.fn.dialog.defaults,{
    onOpen:function(){
    	$(this).window('center');
    	$(this).panel('refresh');
    },
    cls:'theme-panel-blue'
});

//window 蓝色主题
$.extend($.fn.window.defaults,{
    cls:'theme-panel-blue'
});

//messager 恒居中和蓝色主题
$.extend($.messager.defaults,{
	onOpen:function(){
    	$(this).window('center');
    	$(this).panel('refresh');
    },
    cls:'theme-panel-blue'
});

/*
*	websocket组帧
*/
function makeWSFrame(num, opcode, type, machineNum, data, ck) {
    //帧格式：序号 + 控制码 + 帧类型 + 前置机编号 + 数据长度 + 数据(类型1为请求) + 校验
    return "^" + num + "|" + opcode + "|" + type + "|" + machineNum + "|" + data.length + "|" + data + "|" + ck + "*";
}

/*
*	websocket解帧
*/
/*
 * 封装方法一     获取当前时间
 * */
function dateFtt() { //author: meizz   
	var date = new Date(); //获取系统当前时间
	var fmt="yyyy-MM-dd hh:mm:ss";
    var o = {
        "M+": date.getMonth() + 1, //月份   
        "d+": date.getDate(), //日   
        "h+": date.getHours(), //小时   
        "m+": date.getMinutes(), //分   
        "s+": date.getSeconds(), //秒   
        "q+": Math.floor((date.getMonth() + 3) / 3), //季度   
        "S": date.getMilliseconds() //毫秒   
    };
    if(/(y+)/.test(fmt))
        fmt = fmt.replace(RegExp.$1, (date.getFullYear() + "").substr(4 - RegExp.$1.length));
    for(var k in o)
        if(new RegExp("(" + k + ")").test(fmt))
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}

//数组去重，算法
function unique(arr) {
	 var res = [];
	 var json = {};
	 for(var i = 0; i < arr.length; i++){
	  	if(!json[arr[i]]){
	   		res.push(arr[i]);
	   		json[arr[i]] = 1;
	  	}
	 }
	 return res;
}

//通用树节点类型
var commonTreeNodeType = {
	organization: 1,
	customer: 2,
	area: 3, 
	terminal: 4, 
	transmission: 5, 
	gprsBigType: 6, 
	gprsDevice: 7, 
	building: 8, 
	vedioServer: 9, 
	vedioDrv: 10, 
	vedioMonitor: 11, 
	terminalBigType: 12, 
	terminalDevice: 13, 
	transmissionController: 14, 
	transmissionDevice: 15, 
	nbBigType: 16, 
	nbDevice: 17
}

jQuery(function($){  
    var _ajax=$.ajax;   // 备份jquery的ajax方法
    $.ajax=function(opt){  
        var _success = opt && opt.success || function(a, b){};  //获取ajax请求参数中的success方法；
        var _error = opt && opt.error || function(a, b, c){};
        var _opt = $.extend(opt, {  
            success:function(data, textStatus){  
                // 如果后台将请求重定向到了登录页，则data里面存放的就是登录页的源码，这里需要找到data是登录页的标记
                //（这里是在文件中加了“tiaozhuanhuidenglu”然后注释掉。）  
            	if(typeof data =="string"){
	                if(data.indexOf('tiaozhuanhuidengluqian') != -1) {  
	                	window.location.href= basePath + "/Front/login.jsp"; 
	                    return;  
	                }  
	                else if(data.indexOf('tiaozhuanhuidengluhou') != -1) {  
	                    window.location.href= basePath + "/Login/login.jsp";  
	                    return;  
	                } 
            	}
                _success(data, textStatus);    //执行每个ajax自身的success方法
            },
            error: function (xhr,status,error) {
                if(xhr.status=="401" && error.indexOf('session') != -1) {//session timeout; sessionOut返回401错误
                	window.location.href= basePath + "/Front/login.jsp"; 
                    return;
                }
                _error(xhr,status,error);
            }
        });  
        return _ajax(_opt);  //返回新的加入了session超时处理的ajax方法。
    };  
}); 

function setFirstPage(Ids){
    if($(Ids).datagrid().length>0){
    	$(Ids).datagrid('loadData',{total:0,rows:[]});
	    var opts = $(Ids).datagrid("options");
	    var pager = $(Ids).datagrid("getPager");
	    opts.pageNumber = 1;
	    opts.pageSize = 10;
	    pager.pagination("refresh",{
	        pageNumber:1,
	        pageSize:10
	    });
    }
} 