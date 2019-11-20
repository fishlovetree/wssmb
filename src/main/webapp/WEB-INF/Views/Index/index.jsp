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
<title>万胜智慧表箱系统</title>
<style type="text/css">
</style>
<script>
var basePath = '${pageContext.request.contextPath}';

</script>
	<!-- FontAwesome字体图标 -->
	<link type="text/css" href="${pageContext.request.contextPath}/css/font-awesome/css/font-awesome.min.css" rel="stylesheet"/>
	
	<link type="text/css" href="${pageContext.request.contextPath}/js/easyui/themes/pepper-grinder/easyui.css" rel="stylesheet">
	<link type="text/css" href="${pageContext.request.contextPath}/css/index.css" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/easyui/themes/icon.css">
	<link href="${pageContext.request.contextPath}/css/gis/iconfont/iconfont.css" rel="stylesheet" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/${requestScope.theme}.css">
	<link rel="shortcut icon" href="${pageContext.request.contextPath}/images/Avatar.png" />
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/jquery.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/locale/easyui-lang-zh_CN.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.cookie.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/global.js"></script>
	
</head>
<body>
<!-- tab页右击弹出框 -->
<div id="mm" class="easyui-menu submenubutton" style="width: 140px;">
    <div id="mm-tabclose" name="6" iconCls="fa fa-refresh"><spring:message code="Refresh"/></div>
    <div class="menu-sep"></div>
    <div id="Div1" name="1" iconCls="fa fa-close"><spring:message code="Close"/></div>
    <div id="mm-tabcloseother" name="3"><spring:message code="CloseOther"/></div>
    <div id="mm-tabcloseall" name="2"><spring:message code="CloseAll"/></div>
    <div class="menu-sep"></div>
    <div id="mm-tabcloseright" name="4"><spring:message code="CloseRightTab"/></div>
    <div id="mm-tabcloseleft" name="5"><spring:message code="CloseLeftTab"/></div>
</div>

<!-- 修改密码弹出框 -->
<form id="pwdDialog" modal="true" class="easyui-dialog"
      data-options="iconCls:'fa fa-key',
      width: 400,
      height: 250,
      href: '${pageContext.request.contextPath}/admin/modifyPassword'"></form>
      
<script>
var hometitle="<spring:message code='SystemHomePage'/>"

    $(function () {	
		var width=window.innerWidth;
		if(width<1275){
			$(".hide_img").hide();
			if(width<620)
				$(".hide_title").hide();
			else
				$(".hide_title").show();
		}
		else{
			$(".hide_img").show();
			$(".hide_title").show();
		}

		//浏览器大小改变时重置大小
		window.onresize = function () {
			width=window.innerWidth;
			if(width<1275){
				$(".hide_img").hide();
				if(width<620)
					$(".hide_title").hide();
				else
					$(".hide_title").show();
			}
			else{
				$(".hide_img").show();
				$(".hide_title").show();
			}
		};
    	
    	// 初始化accordion
        $("#RightAccordion").accordion({
            fit: true,
            border: false
        });
    	
      //左侧导航栏--展开和折叠
        $(".collapseMenu").on("click", function () {
            var p = $("#index_layout").layout("panel", "west")[0].clientWidth;
            if (p > 0) {
                $('#index_layout').layout('collapse', 'west');
                $(this).children('span').removeClass('fa-chevron-circle-left').addClass('fa-chevron-circle-right');
                $(".list-title").width(28);
                $(".list-center").css('left', '28px');
                $(".dislpayArrow a").removeClass('collapse').addClass('expand');
                
            } else {
                $('#index_layout').layout('expand', 'west');
                $(this).children('span').removeClass('fa-chevron-circle-right').addClass('fa-chevron-circle-left');
                $(".list-title").width(230);
                $(".list-center").css('left', '230px');
                $(".dislpayArrow a").removeClass('expand').addClass('collapse');
            }
        });

        // 首页tabs选项卡
        var index_tabs = $('#index_tabs').tabs({
            fit: true,
            tools: [{
                iconCls: 'fa fa-refresh',
                handler: function () {
                    var refresh_tab = $('#index_tabs').tabs('getSelected');
                    var refresh_iframe = refresh_tab.find('iframe')[0];
                    
                    refresh_iframe.contentWindow.location.href = refresh_iframe.src;
                }
            }, {
                iconCls: 'fa fa-close',
                handler: function () {
                    var index = $('#index_tabs').tabs('getTabIndex', $('#index_tabs').tabs('getSelected'));
                    var tab = $('#index_tabs').tabs('getTab', index);
                    if (tab.panel('options').closable) {
                        $('#index_tabs').tabs('close', index);
                    }
                }
            }],
            //监听右键事件，创建右键菜单
            onContextMenu: function (e, title, index) {
                e.preventDefault();
                if (index >= 0) {
                    $('#mm').menu('show', {
                        left: e.pageX,
                        top: e.pageY
                    }).data("tabTitle", title);
                }
            }
        });

        //tab右键菜单
        $("#mm").menu({
            onClick: function (item) {
                tabMenuOprate(this, item.name);
            }
        });

        // 修改密码窗口
        $('#pwdDialog').dialog({
        	title: '<spring:message code="ChangePassword"/>',
            buttons: [{
                text: '<spring:message code="Determine"/>',
                iconCls: 'fa fa-save',
                btnCls: 'easyui-btn',
                handler: function () {
                    if ($('#pwdDialog').form('validate')) {
                        if ($("#password").val().length > 50) {
                            $.messager.alert('<spring:message code="Prompt"/>', '<spring:message code="PasswordRules"/>', 'warning');
                        } else {
                            var formData = $("#pwdDialog").serialize();
                            $.ajax({
                                url: '${pageContext.request.contextPath}/user/changePassword',
                                type: 'post',
                                cache: false,
                                data: formData,
                                beforeSend: function () {
                                    $.messager.progress({
                                        text: '<spring:message code="Operating"/>'
                                    });
                                },
                                success: function (data, response, status) {
                                    $.messager.progress('close');
                                    if (data == "success") {
                                    	$.messager.alert('<spring:message code="Prompt"/>', '<spring:message code="SuccessOperation"/>', 'info');
                                        $("#pwdDialog").dialog('close').form('reset');
                						
                                        window.location.href= basePath + "/admin/login"; 
                					} else {
                						$.messager.alert('<spring:message code="Warning"/>', '<spring:message code="ChangePasswordFailed"/>', 'error');
                					}
                                }
                            });
                        }
                    }
                }
            },{
                text: '<spring:message code="Cancel"/>',
                iconCls: 'fa fa-close',
                btnCls: 'easyui-btn',
                handler: function () {
                	$("#pwdDialog").dialog('close');
                }
            }],
            onOpen: function () {
                $(this).panel('refresh');
            }
        });
        //默认关闭
        $("#pwdDialog").dialog('close');

        //绑定默认导航栏
        getTopMenu();
        
        $('#ulMenu>li').hover(
                function () {
                	var temp=$(this);
                	var of = temp.offset();
                    var m = temp.data('menu');
                    if (!m) {
                        m = $(this).find('ul').clone();
                        m.appendTo(document.body);
                        $(this).data('menu', m);
                        m.css({left: of.left, top: 40});//ul下的sub显示位置
                        m.hover(function () {
                        	temp.find('h3').find('a').addClass("bannerbtn-hover");
                            
                            clearTimeout(m.timer);
                        }, function () {
                        	temp.find('h3').find('a').removeClass("bannerbtn-hover");
                        	
                            m.hide();
                        });
                    }
                    else
                    	m.css({left: of.left, top: 40});//ul下的sub显示位置
                    temp.find('h3').find('a').addClass("bannerbtn-hover");
                    
                    m.show();
                }, function () {
                	$(this).find('h3').find('a').removeClass("bannerbtn-hover");
                	
                    var m = $(this).data('menu');
                    if (m) {
                        m.timer = setTimeout(function () {
                        	m.hide();
                        }, 100);//延时隐藏，时间自定义，100ms
                    }
                } 
        );
      
    });
   
    
    //生成左侧导航栏
    function getTopMenu(){
        var allPanel = $("#RightAccordion").accordion('panels');
        var size = allPanel.length;
        if (size > 0) {
            for (i = 0; i < size; i++) {
                var index = $("#RightAccordion").accordion('getPanelIndex', allPanel[i]);
                $("#RightAccordion").accordion('remove', 0);
            }
        }

        var params={};
        $.ajax({
           	url:'${pageContext.request.contextPath}/sysMenu/getMenuJson',
           	data:params,
           	type:"post",
           	dataType:"json",
           	success:function(data){
           		if(data=="-1"){
           			$.messager.show({title: '<spring:message code="Prompt"/>', msg: '<spring:message code="GetMenuJsonFailed"/>'});
           			return;
           		}
           		else{
           			for(var i=0;i<data.length;i++){
           				var e=data[i];
           				var pid = e.superid;
                        var isSelected = i == 0 ? true : false;
                        
                        var menulist = "";
                		menulist += '<ul id="tree' + e.id + '" class="easyui-tree tree">';
                		if(null!=e.children && e.children!="undefined"){
	                		$.each(e.children, function(j, o) {
	                			 if(o.menuurl!=""){
	                				var url=o.menuurl;
	                				var icon='fa fa-file-text-o';
	                				if(null!=o.menuicon && o.menuicon!="")
	                					icon = o.menuicon;
	                				
	                				menulist += '<a ref="' + o.id + '"'
		                			+ 'class="menucss" href="javascript:addTab(\''+'${pageContext.request.contextPath}'+url+'\', \''+o.text+'\', \''+o.menuicon+'\', \''+o.menuenname+'\')">'
		                			+ '<li><div class="tree-node"><span class="tree-indent"></span><span class="treeicon '+icon+'">'
		                			+ '</span><span class="tree-title">'+ o.text+'</span></div></li></a>';

	                			}
	                			else{ 
	                				menulist += '<li><span>'+o.text+'</span></li>';
	                			}
	                		});
	                		menulist += '</ul>';
                		}
                        
                        $('#RightAccordion').accordion('add', {
                            fit: false,
                            title: e.text,
                            content: menulist,
                            border: false,
                            selected: isSelected,
                            iconCls: e.menuicon
                        });
           			}
           		}
           	},
           	error:function(e){
           		$.messager.alert('<spring:message code="Warning"/>','<spring:message code="ConnectionFailure"/>', 'error');
           	}
       });
    	
    }
  
	//编辑账户信息
    function editcustomerfile(src, title, iconCls){
    	var username=$("#username").text();
		//判断账户为用户，而非管理员
		$.ajax({
           	url:'${pageContext.request.contextPath}/sysCustomerFile/getCustomerRow?Math.random()&type=index&value='+username,
           	type:"post",
           	success:function(data){
           		if(data.flag=="true"){
           		    var href=src+'?Math.random()&type=index&customer='+encodeURI(encodeURI(data.json));
           	    	addTab(href, '<spring:message code="EditCustomerFile"/>', '')
           		}
           		else{
           			$.messager.alert('<spring:message code="Prompt"/>', '用户账号才可编辑用户信息（代理账号无用户信息）！', 'info');
           		}
           	},
           	error:function(e){
           		$.messager.alert('<spring:message code="Warning"/>','<spring:message code="ConnectionFailure"/>', 'error');
           	}
       });
    }

    // Tab菜单右击操作
    function tabMenuOprate(menu, type) {
        var allTabs = $('#index_tabs').tabs('tabs');
        var allTabtitle = [];
        $.each(allTabs, function (i, n) {
            var opt = $(n).panel('options');
            if (opt.closable)
                allTabtitle.push(opt.title);
        });
        var curTabTitle = $(menu).data("tabTitle");
        var curTabIndex = $('#index_tabs').tabs("getTabIndex", $('#index_tabs').tabs("getTab", curTabTitle));
        switch (type) {
            case "1"://关闭当前
                if (curTabIndex > 0) {
                	closeTab(curTabTitle);
                    return false;
                    break;
                } else {
                    $.messager.show({
                        title: '<spring:message code="Prompt"/>',
                        msg: '<spring:message code="HomePageNotAllowedClose"/>'
                    });
                    break;
                }
            case "2"://全部关闭
                for (var i = 0; i < allTabtitle.length; i++) {
                	closeTab(allTabtitle[i]);
                }
                $('#index_tabs').tabs('select', hometitle);
                break;
            case "3"://除此之外全部关闭
                for (var i = 0; i < allTabtitle.length; i++) {
                	if (curTabTitle != allTabtitle[i])
                		closeTab(allTabtitle[i]);
                }
                $('#index_tabs').tabs('select', curTabTitle);
                break;
            case "4"://当前侧面右边
                for (var i = curTabIndex; i < allTabtitle.length; i++) {
                	closeTab(allTabtitle[i]);
                }
                $('#index_tabs').tabs('select', curTabTitle);
                break;
            case "5": //当前侧面左边
                for (var i = 0; i < curTabIndex - 1; i++) {
                	closeTab(allTabtitle[i]);
                }
                $('#index_tabs').tabs('select', curTabTitle);
                break;
            case "6": //刷新
                var refresh_tab = $('#index_tabs').tabs('getSelected');
                var refresh_iframe = refresh_tab.find('iframe')[0];
                
                refresh_iframe.contentWindow.location.href = refresh_iframe.src;
                break;
        }

    }

    // 退出系统
    function logout() {
        $.messager.confirm('<spring:message code="Prompt"/>', '<spring:message code="SureToExit"/>', function (r) {
            if (r) {
                $.messager.progress({
                    text: '<spring:message code="Exiting"/>'
                });
                window.location.href = '${pageContext.request.contextPath}/admin/logout';
            }
        });
    }

    //打开Tab窗口
    function addTab(src, title, iconCls,menuenname) {
        var iframe = '<iframe allowFullScreen="true" src="' + src + '" name="'+ menuenname+'" scrolling="auto" frameborder="0" style="width:100%;height:100%;"></iframe>';
        var t = $('#index_tabs');
        var $selectedTab = t.tabs('getSelected');
        var selectedTabOpts = $selectedTab.panel('options');  
        var opts = {
            refererTab: {},
            title: title,
            closable: true,
            iconCls: (iconCls!="" && iconCls!="undefined") ? iconCls : 'fa fa-file-text-o',
            content: iframe,
            fit: true
        };
        if (t.tabs('exists', opts.title)) {
            t.tabs('select', opts.title);
        } else {
            var lastMenuClickTime = $.cookie("menuClickTime");
            var nowTime = new Date().getTime();
            if ((nowTime - lastMenuClickTime) >= 500) {
                $.cookie("menuClickTime", new Date().getTime());
                t.tabs('add', opts);
            } else {
                $.messager.show({
                    title: '<spring:message code="Tips"/>',
                    msg: '<spring:message code="TooFast"/>',
                    style:{
                    	width:250,
                    	height:100
                    }
                });
            }
        }
    }

    function addParentTab(options) {
        var src, title;
        src = options.href;
        title = options.title;

        var iframe = '<iframe allowFullScreen="true" src="' + src + '" frameborder="0" style="border:0;width:100%;height:100%;"></iframe>';
        parent.$('#index_tabs').tabs("add", {
            title: title,
            content: iframe,
            colsabel:true,
            iconCls: 'fa fa-th',
            border: true
        });
    }

    /** 
     * 刷新指定的tab里面的数据 
     * @param title 选项卡标题 
     * @param refreshTabFunc  自定义的刷新方法(再各个页面具体实现) 
     */  
    function refreshTabData(title,refreshGridFunc)  
    {  
        if ($("#index_tabs" ).tabs('exists', title)) {  
            $('#index_tabs').tabs('select' , title);  
            typeof refreshGridFunc === 'function' && refreshGridFunc.call();  
        }  
    }

    //关闭Tab窗口
    function closeTab(curTabTitle) {
    	if(curTabTitle!=hometitle){
    		$('#index_tabs').tabs("close", curTabTitle);
    	}
    }
  
    function modifyPwd() {
        $("#pwdDialog").dialog('open');
        $("#pwdDialog").window('center');//使Dialog居中显示
    };
 	
	 //切换主题
    function changeTheme(code){
    	$.messager.confirm('<spring:message code="Confirm"/>',"确定修改主题？",function(r){
    		if (r){
    			var params={"theme":code};
    	        $.ajax({
    	           	url:'${pageContext.request.contextPath}/user/changeTheme?Math.random()',  
    	           	data:params,
    	           	type:"post",
    	           	success:function(data){
    	           		switch(data){
	    	           		case "success":
	    	           			window.location.reload();
	    	           			break;
	    	           		case "1":
	    	           			$.messager.alert('<spring:message code="Prompt"/>','所选主题与原主题一致。', 'warning');
	    	           			break;
	    	           		default:
	    	           			$.messager.alert('<spring:message code="Warning"/>','修改主题失败。', 'error');
    	           		}
    	           	},
    	           	error:function(e){
    	           		$.messager.alert('<spring:message code="Warning"/>','<spring:message code="ConnectionFailure"/>', 'error');
    	           	}
    	       });
    		
    		}
    	});
    }
</script>
<div id="index_layout" class="easyui-layout" data-options="fit:true">
    <div id="index_north" class="banner" data-options="region:'north',border:false,split:false"
         style="height: 70px; padding:0;margin:0; overflow: hidden;">
        <table style="float: left; border-spacing: 0px; height: 100%;">
            <tr>
                <td class="hide_title" style="cursor: pointer;height:50px;">
                	<img src="${pageContext.request.contextPath}/images/Login/Login-logo.png" height="45" alt="中国消防" style="padding-left: 20px;"> 
                </td>
                <td>
                	<span class="head-title"><spring:message code="Wisdom_fire_safety_system"/></span>
                </td>
                <td class="hide_title">
                	<img src="${pageContext.request.contextPath}/images/Front/wellsun_logo.png" height="45" alt="浙江万胜" style="padding-left: 5px;"> 
                </td>
                <td class="hide_img">
                	<img src="${pageContext.request.contextPath}/images/index-title.png" alt="消防" style="width:650px;height:70px;">
                </td>
            </tr>
        </table>
		
        <div class="top_right f_r">
            <!-- menu -->
            <div class="nav_bar">
                <ul class="nav clearfix" id="ulMenu">

                    <!-- 单一菜单 | end -->
                    
                    <li class="m">
                        <h3>
                            <a title="" id="setThemes" class="l-btn-text bannerbtn"
                               href="javascript:void(0)"><i class="fa fa-tree"></i></a><%-- <spring:message code="SwitchTheme"/> --%>
                        </h3>
                        <ul class="sub">
                            <li class="list-theme yellowtheme"><a onclick="changeTheme(1)" style="cursor:pointer;">橙色</a> </li>
                            <li class="list-theme bluetheme"><a onclick="changeTheme(2)" style="cursor:pointer;">蓝色</a> </li>
                        </ul> 
                    </li>
                    <li class="s">|</li>
                    
                    <li class="m">
                        <h3>
                            <a class="l-btn-text bannerbtn"
                               href="javascript:void(0)"><i class="fa fa-cog"></i></a>
                        </h3>
                        <ul class="sub">
                            <li><a id="about" href="javascript:addTab('${pageContext.request.contextPath}/admin/about', '<spring:message code='AboutSystem'/>','fa fa-info-circle')" target=""><i class="fa fa-info-circle"></i>&nbsp;<label for="about"><spring:message code="AboutSystem"/></label></a></li>
                            <li><a id="help" href="javascript:addTab('${pageContext.request.contextPath}/document/index', '<spring:message code='HelpDocument'/>','fa fa-file-word-o')" target=""><i class="fa fa-file-word-o"></i>&nbsp;<label for="help"><spring:message code="HelpDocument"/></label></a></li>
                            <li><a id="treeset" href="javascript:addTab('${pageContext.request.contextPath}/commonTree/index', '通用树配置','fa fa-tree')" target=""><i class="fa fa-tree"></i>&nbsp;<label for="treeset">通用树配置</label></a></li>
                        </ul>
                    </li>
                    <li class="s">|</li>
                    
                    <li class="m">
                        <h3>
                            <a id="showUserInfo" style="display:inline-block;" class="fa bannerbtn"
                               href="javascript:void(0)">
                                <img src="${pageContext.request.contextPath}/images/Avatar.png" class="user-image">
                                <span class="user-name" id="username" style="text-overflow:ellipsis;-o-text-overflow:ellipsis;
                                white-space:nowrap;max-width:110px;display:block;overflow: hidden;height:24px;"
                                title="${requestScope.username}">${requestScope.username}</span>
                            </a>
                        </h3>
                        <ul class="sub">
                            <li><a id="editcustomerfile" href="javascript:editcustomerfile('${pageContext.request.contextPath}/sysCustomerFile/CustomerFileAdd', '用户信息', 'fa fa-user')"><i class="fa fa-user"></i>&nbsp;<label for="editcustomerfile">用户信息</label></a></li>
                            <li><a id="modifyPwd" href="javascript:modifyPwd()"><i class="fa fa-key"></i>&nbsp;<label for="modifyPwd"><spring:message code="ChangePassword"/></label></a></li>
                            <li><a id="logout" href="javascript:logout()"> <i class="fa fa-power-off"></i>&nbsp;<label for="logout"><spring:message code="ExitSystem"/></label></a></li>
                        </ul>
                    </li>
                    <li class="block"></li><!-- 滑动块 -->

                </ul>
            </div>
            <!-- menu | end -->
        </div>
    </div>
    
    <!-- <a class="list-title"></a>  -->
    <div id="index_west" data-options="region:'west',split:true,border:false,headerCls:'border_right',bodyCls:'border_right'"
         title="" iconCls="fa fa-dashboard" style="border:0px;width:15%;min-width:150px">
    	<!-- <div id="accor"> -->
	        <div id="RightAccordion" class="easyui-accordion"></div>
	    <!-- </div> -->
    </div>

	<!-- <a class="list-center"></a>  -->
    <div id="index_center" data-options="region:'center',border:false" style="overflow:hidden;">
    	<div style="float:left;" class="collapseMenu">
        	<div class="dislpayArrow"><a class="collapse"></a></div>
	    </div>
        <div id="index_tabs" class="easyui-tabs" style="width:100%;height:100%;">
            <div title="<spring:message code='SystemHomePage'/>" iconCls="fa fa-home" data-options="border:true,
            content:'<iframe src=\'${pageContext.request.contextPath}\/admin\/welcome\' scrolling=\'auto\' frameborder=\'0\' style=\'width:100%;height:100%;\'></iframe>'"></div>
        </div>
        <div style="clear:both;"></div>
    </div>

    <div id="index_south" data-options="region:'south',border:true"
         style="text-align:center;height:30px;line-height:30px;border-bottom:0;overflow:hidden;">
        <span style="float:left;padding-left:5px;width:30%;text-align: left;"><spring:message code="CurrentUser"/>:&nbsp;${requestScope.username}</span>
        <span style="padding-right:5px;width:40%">
           <spring:message code="Copyright"/> 
            <a href="http://www.wellsun.com" target="_blank"><spring:message code="CompanyName"/></a>
            <a href="" target="_blank"><spring:message code="CompanyCode"/></a>
        </span>
        <span style="float:right;padding-right:5px;width:30%;text-align: right;"><spring:message code="Version"/>:${requestScope.version}</span>
    </div>
</div>
</body>
</html>