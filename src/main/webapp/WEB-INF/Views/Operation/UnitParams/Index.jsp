<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
    <%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>参数设置</title>
<jsp:include page="../../Header.jsp"/>
<style type="text/css">
    .left-td{
        width: 75px;
    }
    .read-result-tbl{
        margin: 0px;
	    padding: 0px;
	    font-size: 12px;
	    color: #335169;
	    background: #fff;
	    border-top: 1px solid #a8c7ce;
	    border-right: 1px solid #a8c7ce;
    }
    .read-result-tbl th, .read-result-tbl td{
        padding: 2px 5px 2px 5px;
	    border-bottom: 1px solid #a8c7ce;
	    border-left: 1px solid #a8c7ce;
	    vertical-align: middle;
    }
    .layout-split-west {
	    border-right: 1px solid #ccc;
	}
	.layout-split-north{
	    border-bottom: 1px solid #ccc;
	}
	.mTable{border-collapse:collapse;
	    border:1px solid gray;
	}
	.mTable tr  td{ 
	    border:1px solid gray;
	}
	.layout-split-west {
	    border-right: 1px solid #ccc;
	}
</style>
</head>
<body>
    <div class="easyui-layout" fit="true">
        <div id="west" region="west" iconCls="icon-organization" split="true" title="终端/GPRS设备" style="width:284px;min-width:284px;" collapsible="true">
			<jsp:include page="../../CommonTree/termGprs_UnitTree.jsp"/>
		</div>
		<div id="mainPanel" region="center" style="overflow-y:hidden">
		    <div class="easyui-layout" fit="true">
		        <div region="north" style="height: 220px;" split="true">
		            <table border="0" cellspacing="8" cellpadding="8">
                            <tr>
                                <td class="tableHead_right" align="right">
                                                                                    终端：
                                </td>
                                <td>
                                    <input type="text" id='snode' class="easyui-textbox" readonly="readonly" style="width:200px;" />
                                    <input type="hidden" id="selectedID" />
                                    <input type="hidden" id="selectedType" />
                                    <input type="hidden" id="selectedAddress" />
                                </td>
                                <td>
	                                <a href="javascript:void(0)" class="easyui-linkbutton" onclick="getVersion()" title="读取终端版本号">读取终端版本号</a>
	                                <a href="javascript:void(0)" class="easyui-linkbutton" onclick="getSim()" title="读取终端SIM卡序号">读取终端SIM卡序号</a>
	                            </td>
                            </tr>
                        </table>
			        <div class="easyui-tabs" id="tab" fit="true" data-options="tabPosition:'top'">
		           		<div title="主站IP">
		           		    <form id="ipForm" class="easyui-form" method="post">
		           		    <table cellspacing="8" style="min-width: 500px;">
		                        <tr>
		                            <td class="left-td">
		                                                                           主站IP:
		                            </td>
		                            <td>
		                                <input type="text" class="easyui-textbox" id="mainIpTxt" name="mainip" data-options="required:true,validType:'ip'"/>
		                            </td>
		                            <td class="left-td">
		                                                                           主站端口:
		                            </td>
		                            <td>
		                                <input type="text" class="easyui-numberbox" id="mainPortTxt" name="mainport" data-options="required:true,min:0,max:65535"/>
		                            </td>
		                            <td class="left-td">
		                                                                           主站APN:
		                            </td>
		                            <td>
		                                <input type="text" class="easyui-textbox" id="apnTxt" name="apn" data-options="required:true,validType:'maxlength[48]'"/>
		                            </td>
		                        </tr>
		                        <tr>
		                            <td class="left-td">
		                                                                           备站IP:
		                            </td>
		                            <td>
		                                <input type="text" class="easyui-textbox" id="backupIpTxt" name="backupip" data-options="required:true,validType:'ip'"/>
		                            </td>
		                            <td class="left-td">
		                                                                           备站端口:
		                            </td>
		                            <td>
		                                <input type="text" class="easyui-numberbox" id="backupPortTxt" name="backupport" data-options="required:true,min:0,max:65535"/>
		                            </td>
		                        </tr>
		                        <tr>
		                            <td class="left-td">
		                            </td>
		                            <td>
		                                <a href="javascript:void(0)" class="easyui-linkbutton" onclick="setIp()" title="设置">设置</a>
                                        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="readIp()" title="查询">查询</a>
		                            </td>
		                        </tr>
		                    </table>
		                    </form>
		            	</div>
		            	<div title="WIFI">
		            	    <form id="wifiForm" class="easyui-form" method="post">
		           		    <table cellspacing="8" style="min-width: 500px;">
		                        <tr>
		                            <td class="left-td">
		                                                                           用户名:
		                            </td>
		                            <td>
		                                <input type="text" class="easyui-textbox" id="userNameTxt" name="username" data-options="required:true,validType:'maxlength[16]'"/>
		                            </td>
		                        </tr>
		                        <tr>
		                            <td class="left-td">
		                                                                           密码:
		                            </td>
		                            <td>
		                                <input type="text" class="easyui-textbox" id="pwdTxt" name="pwd" data-options="required:true,validType:'maxlength[16]'"/>
		                            </td>
		                        </tr>
		                        <tr>
		                            <td class="left-td">
		                            </td>
		                            <td>
		                                <a href="javascript:void(0)" class="easyui-linkbutton" onclick="setWifi()" title="设置">设置</a>
                                        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="readWifi()" title="查询">查询</a>
		                            </td>
		                        </tr>
		                    </table>
		                    </form>
		            	</div>
		            	<div title="以太网">
		            	    <form id="ethernetForm" class="easyui-form" method="post">
		           		    <table cellspacing="8" style="min-width: 500px;">
		                        <tr>
		                            <td class="left-td">
		                                MAC地址:
		                            </td>
		                            <td>
		                                <input type="text" class="easyui-textbox" id="macTxt" name="mac" data-options="required:true,validType:'length[12]'"/>
		                            </td>
		                            <td class="left-td">
		                                                                           本地IP:
		                            </td>
		                            <td>
		                                <input type="text" class="easyui-textbox" id="localIpTxt" name="localip" data-options="required:true,validType:'ip'"/>
		                            </td>
		                        </tr>
		                        <tr>
		                            <td class="left-td">
		                                                                           子网掩码:
		                            </td>
		                            <td>
		                                <input type="text" class="easyui-textbox" id="submaskTxt" name="submask" data-options="required:true,validType:'ip'"/>
		                            </td>
		                            <td class="left-td">
		                                                                           网关地址:
		                            </td>
		                            <td>
		                                <input type="text" class="easyui-textbox" id="gatewayTxt" name="gateway" data-options="required:true,validType:'ip'"/>
		                            </td>
		                        </tr>
		                        <tr>
		                            <td class="left-td">
		                            </td>
		                            <td>
		                                <a href="javascript:void(0)" class="easyui-linkbutton" onclick="setEthernet()" title="设置">设置</a>
                                        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="readEthernet()" title="查询">查询</a>
		                            </td>
		                        </tr>
		                    </table>
		                    </form>
		            	</div>
		            	<div title="短信">
		            	    <form id="smsForm" class="easyui-form" method="post">
		           		    <table cellspacing="8" style="min-width: 500px;">
		                        <tr>
		                            <td class="left-td">
		                                                                          短信中心:
		                            </td>
		                            <td>
		                                <input type="text" class="easyui-textbox" id="smsCenterTxt" name="smscenter" data-options="required:true,validType:'maxlength[16]'"/>
		                            </td>
		                        </tr>
		                        <tr>
		                            <td class="left-td">
		                                                                          用户手机:
		                            </td>
		                            <td>
		                                <input type="text" class="easyui-textbox" id="userMobileTxt" name="usermobile" data-options="required:true,validType:'maxlength[16]'"/>
		                            </td>
		                        </tr>
		                        <tr>
		                            <td class="left-td">
		                            </td>
		                            <td>
		                                <a href="javascript:void(0)" class="easyui-linkbutton" onclick="setSms()" title="设置">设置</a>
                                        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="readSms()" title="查询">查询</a>
		                            </td>
		                        </tr>
		                    </table>
		                    </form>
		            	</div>
		            	<div title="重发机制">
		            	    <form id="repeatForm" class="easyui-form" method="post">
		           		    <table cellspacing="8" style="min-width: 500px;">
		                        <tr>
		                            <td style="width:80px;" >
		                                                                          超时等待时间:
		                            </td>
		                            <td>
		                                <input type="text" class="easyui-numberbox" id="waitTimeTxt" name="waittime" data-options="required:true,min:0,max:99"/>
		                            </td>
		                            <td style="width:80px;">
		                                                                          超时重发次数:
		                            </td>
		                            <td>
		                                <input type="text" class="easyui-numberbox" id="repeatTimesTxt" name="repeattimes" data-options="required:true,min:0,max:5"/>
		                            </td>
		                        </tr>
		                        <tr>
		                            <td style="width:80px;">
		                                                                          心跳周期:
		                            </td>
		                            <td>
		                                <input type="text" class="easyui-numberbox" id="heartBeatTxt" name="heartbeat" data-options="required:true,min:0,max:99"/>
		                            </td>
		                        </tr>
		                        <tr>
		                            <td style="width:80px;">
		                            </td>
		                            <td>
		                                <a href="javascript:void(0)" class="easyui-linkbutton" onclick="setRepeat()" title="设置">设置</a>
                                        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="readRepeat()" title="查询">查询</a>
		                            </td>
		                        </tr>
		                    </table>
		                    </form>
		            	</div>
		            	<div title="终端时间">
		            	    <form id="timeForm" class="easyui-form" method="post">
		           		    <table cellspacing="8" style="min-width: 500px;">
		                        <tr>
		                            <td class="left-td">
		                                                                         年月日:
		                            </td>
		                            <td>
		                                <input type="text" class="easyui-datebox" editable="fasle" id="ymdTxt" name="ymd" data-options="required:true,formatter:dateformatter"/>
		                            </td>
		                        </tr>
		                        <tr>
		                            <td class="left-td">
		                                                                          时分秒:
		                            </td>
		                            <td>
		                                <input type="text" class="easyui-timespinner" id="hmsTxt" name="hms" style="height:30px;" data-options="required:true,showSeconds:true"/>
		                                <input type="checkbox" id="sysTimeCk" style="margin-left:10px;"/><span style="margin-left:5px;">取系统时间</span>
		                            </td>
		                        </tr>
		                        <tr>
		                            <td class="left-td">
		                            </td>
		                            <td>
		                                <a href="javascript:void(0)" class="easyui-linkbutton" onclick="setTime()" title="设置">设置</a>
                                        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="readTime()" title="查询">查询</a>
		                            </td>
		                        </tr>
		                    </table>
		                    </form>
		            	</div>
		            	<div title="密码">
		            	    <form id="pwdForm" class="easyui-form" method="post">
		           		    <table cellspacing="8" style="min-width: 500px;">
		                        <tr>
		                            <td style="width:80px;" >
		                                                                          密码:
		                            </td>
		                            <td>
		                                <input type="text" class="easyui-numberbox" id="passwordTxt" name="password" data-options="required:true,min:0,max:9999"/>
		                            </td>
		                        </tr>
		                        <tr>
		                            <td class="left-td">
		                            </td>
		                            <td>
		                                <a href="javascript:void(0)" class="easyui-linkbutton" onclick="setPwd()" title="设置">设置</a>
		                            </td>
		                        </tr>
		                    </table>
		                    </form>
		            	</div>
		            	<div title="密钥">
		            	    <form id="secretKeyForm" class="easyui-form" method="post">
		           		    <table cellspacing="8" style="min-width: 500px;">
		                        <tr>
		                            <td style="width:80px;" >
		                                                                          母钥版本号:
		                            </td>
		                            <td>
		                                <input type="text" class="easyui-numberspinner" id="keyversion" name="keyversion" data-options="required:true,min:0,max:127" value="${requestScope.keyversion}"/>
		                            </td>
		                        </tr>
		                        <tr>
		                            <td style="width:80px;" >
		                                                                          修改原因:
		                            </td>
		                            <td>
		                                <input type="text" class="easyui-textbox" id="remark" name="remark" data-options="validType:'maxlength[100]'"/>
		                            </td>
		                        </tr>
		                        <tr>
		                            <td class="left-td">
		                            </td>
		                            <td>
		                                <a href="javascript:void(0)" class="easyui-linkbutton" onclick="setSecretKey()" title="设置">设置</a>
		                            </td>
		                        </tr>
		                    </table>
		                    </form>
		            	</div>
		            	<div title="互感器变比">
		            	    <form id="ctrForm" class="easyui-form" method="post">
		           		    <table cellspacing="8" style="min-width: 500px;">
		                        <tr>
		                            <td style="width:80px;" >
		                                                                          互感器变比:
		                            </td>
		                            <td>
		                                <select id="ctr" name="ctr"  class="easyui-combobox" 					
											data-options="method: 'get',
											url: '${pageContext.request.contextPath}/constant/getDetailList?Math.random()&coding='+1143,
											valueField: 'detailvalue',
											textField:'detailname',
											editable:false,
											width:200,
									        onLoadSuccess: function (data) {
									        	var value=$(this).combobox('getValue');
									            if (null == value|| value=='') {
									                $(this).combobox('setValue',data[0].detailvalue);
									            }
									        }">
										 </select>
		                            </td>
		                        </tr>
		                        <tr>
		                            <td style="width:80px;">
		                            </td>
		                            <td>
		                                <a href="javascript:void(0)" class="easyui-linkbutton" onclick="setCtr()" title="设置">设置</a>
                                        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="readCtr()" title="查询">查询</a>
		                            </td>
		                        </tr>
		                    </table>
		                    </form>
		            	</div>
		            	<div title="接线模式字">
		            	    <form id="powerForm" class="easyui-form" method="post">
		           		    <table cellspacing="8" style="min-width: 500px;">
		                        <tr>
		                            <td style="width:120px;" >
		                                                                          三相供电模式字:
		                            </td>
		                            <td>
		                                <select class="easyui-combobox" id="powermodeSel" name="powermode" data-options="required:true,width:120">
		                                    <option value="1">单相</option>
		                                    <option value="3">三相</option>
		                                </select>
		                            </td>
		                            <td style="width:120px;">
		                                                                          单相供电接入相序:
		                            </td>
		                            <td>
		                                <select class="easyui-combobox" id="powerphaseSel" name="powerphase" data-options="required:true,width:120">
		                                    <option value="1">A</option>
		                                    <option value="2">B</option>
		                                    <option value="3">C</option>
		                                </select>
		                            </td>
		                        </tr>
		                        <tr>
		                            <td style="width:80px;">
		                                                                          温度接线端:
		                            </td>
		                            <td colspan="3">
		                                <table id="tableList" cellpadding=5 class="mTable" cellspacing=0 width=100% height=100%
											align="center" border="1px">
											<tr style="background: #f3f3f3; height: 5%">
												<td align="center" style="width: 12%">保留</td>
												<td align="center" style="width: 12%">保留</td>
												<td align="center" style="width: 12%">保留</td>
												<td align="center" style="width: 12%">保留</td>
												<td align="center" style="width: 12%">N相</td>
												<td align="center" style="width: 12%">C相</td>
												<td align="center" style="width: 12%">B相</td>
												<td align="center" style="width: 12%">A相</td>
											</tr>
											<tr style="height: 5%">
											    <td align="center" style="width: 12%;padding:5px;"><input id="sb7" name="sb"
													class="easyui-switchbutton"
													data-options="onText:'保留',offText:'保留',readonly:true"></td>
												<td align="center" style="width: 12%;padding:5px;"><input id="sb6" name="sb"
													class="easyui-switchbutton"
													data-options="onText:'保留',offText:'保留',readonly:true"></td>
												<td align="center" style="width: 12%;padding:5px;"><input id="sb5" name="sb"
													class="easyui-switchbutton"
													data-options="onText:'保留',offText:'保留',readonly:true"></td>
												<td align="center" style="width: 12%;padding:5px;"><input id="sb4" name="sb"
													class="easyui-switchbutton"
													data-options="onText:'保留',offText:'保留',readonly:true"></td>
												<td align="center" style="width: 12%;padding:5px;"><input id="sb3"
													name="sb" class="easyui-switchbutton switchbutton-yellow"
													data-options="onText:'接入',offText:'无效'," checked></td>
												<td align="center" style="width: 12%;padding:5px;"><input id="sb2"
													name="sb" class="easyui-switchbutton switchbutton-yellow"
													data-options="onText:'接入',offText:'无效'," checked></td>
												<td align="center" style="width: 12%;padding:5px;"><input id="sb1"
													name="sb" class="easyui-switchbutton switchbutton-yellow"
													data-options="onText:'接入',offText:'无效'," checked></td>
												<td align="center" style="width: 12%;padding:5px;"><input id="sb0"
													name="sb" class="easyui-switchbutton switchbutton-yellow"
													data-options="onText:'接入',offText:'无效'," checked></td>
											</tr>
										</table>	
		                            </td>
		                        </tr>
		                        <tr>
		                            <td style="width:80px;">
		                            </td>
		                            <td>
		                                <a href="javascript:void(0)" class="easyui-linkbutton" onclick="setPower()" title="设置">设置</a>
                                        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="readPower()" title="查询">查询</a>
		                            </td>
		                        </tr>
		                    </table>
		                    </form>
		            	</div>
	       		    </div>
		        </div>
		        <div region="center" title="结果<a href='javascript:void(0)' class='easyui-linkbutton' style='float: right; width: 40px;' 
		        onclick='clearResult();'>清空</a>" split="true">
			        <div id="resultPanel" style="margin: 10px;">
			        </div>
			    </div>
		    </div>
		</div>
 </div>
<script type="text/javascript">
	//websocket相关
	var ws;
	var port = '0'; //前一次端口号，断线重连时用到
	var frameNumber = 1; //帧序号
	
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
    	//取系统时间
    	initDateTime();
    	$('#sysTimeCk').change(function() { 
    		if ($('#sysTimeCk').prop('checked')){
    			initDateTime();
    		}
    	}); 
    	
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
			/* if (node.type == commonTreeNodeType.terminal || node.type == commonTreeNodeType.gprsDevice){
        		 */$("#snode").textbox('setValue', node.text);
                $("#selectedID").val(node.gid);
                $("#selectedType").val(node.type);
                $("#selectedAddress").val(node.name);
        	/* }
        	else{
        		$("#snode").textbox('setValue', "");
                $("#selectedID").val("");
                $("#selectedType").val("");
                $("#selectedAddress").val("");
        	}	 */
		}
	}
	
	//初始化日期时间
	function initDateTime(){
    	var now = new Date();
    	var nowplus = new Date(now.getTime()+2000); //延时2秒
    	var y = nowplus.getFullYear();
        var m = nowplus.getMonth()+1;
        var d = nowplus.getDate();
        var h = nowplus.getHours();
        var t = nowplus.getMinutes();
        var s = nowplus.getSeconds();
    	$('#ymdTxt').datebox('setValue', y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d));
    	$('#hmsTxt').timespinner('setValue', (h<10?('0'+h):h)+':'+(t<10?('0'+t):t)+':'+(s<10?('0'+s):s));
	}
    
    function dateformatter(date){
        var y = date.getFullYear().toString().substr(2,2);
        var m = date.getMonth()+1;
        var d = date.getDate();
        return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
    }
    
    //设置设备地址
    function setAddress(){
    	var selectedID = $.trim($("#selectedID").val());
    	var selectedType = $.trim($("#selectedType").val());
        if (selectedID == "") {
        	$.messager.alert("提示", "请选择终端。", "warning");
            return;
        }
        if (ws) {
            if (ws.readyState == 1) {
            	if ($('#addressForm').form('validate')){
            		$.ajax({
    					type: 'POST',
    					url: "${pageContext.request.contextPath}/unitParams/setAddress",
    					data: {
    						"id": selectedID,
    						"type": selectedType,
    						"address": $("#selectedAddress").val(),
    						"webaddress": $("#webAddrTxt").val(),
    						"deviceaddress": $("#deviceAddrTxt").val()
    					},
    					success: function(d) {
    						if (d == ""){
    							$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置设备地址失败。</div>");
    						}
    						else {
    			                if (d.indexOf("html") > 0) { //session超时
    			                    parent.window.location.reload();
    			                }
    			                else {
    			                    frameNumber++;
    			                    //组帧，Global.js中定义
    			                    var frame = makeWSFrame(frameNumber, 0, 1, 1, d, '');
    			                    ws.send(frame);
    			                    if ($("body").find(".datagrid-mask").length == 0) {
    	                                //添加等待提示
    	                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
    	                                $("<div class=\"datagrid-mask-msg\"></div>").html("设置中，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
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
    
    //查询设备地址
    function readAddress(){
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
					url: '${pageContext.request.contextPath}/unitParams/getAddress',
					data: {
						"id": selectedID,
						"type": selectedType,
						"address": $("#selectedAddress").val()
					},
					success: function(d) {
						if (d != "" && d !="[]"){
			                if (d.indexOf("html") > 0) { //session超时
			                    parent.window.location.reload();
			                }
			                else {
			                    frameNumber++;
			                    //组帧，Global.js中定义
			                    var frame = makeWSFrame(frameNumber, 0, 1, 1, d, '');
			                    ws.send(frame);
			                    if ($("body").find(".datagrid-mask").length == 0) {
	                                //添加等待提示
	                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
	                                $("<div class=\"datagrid-mask-msg\"></div>").html("查询中，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
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
    
    //设置主站IP
    function setIp(){
    	var selectedID = $.trim($("#selectedID").val());
    	var selectedType = $.trim($("#selectedType").val());
        if (selectedID == "") {
        	$.messager.alert("提示", "请选择终端。", "warning");
            return;
        }
        if (ws) {
            if (ws.readyState == 1) {
            	if ($('#ipForm').form('validate')){
            		$.messager.confirm('警告','确认设置 '+$("#snode").textbox('getValue')+" 下所有终端和GPRS设备",function(r){
					    if (r){					    	
		            		$.ajax({
		    					type: 'POST',
		    					url: "${pageContext.request.contextPath}/unitParams/setIp",
		    					data: {
		    						"id": selectedID,
		    						"type": selectedType,
		    						"address": $("#selectedAddress").val(),
		    						"mainip": $("#mainIpTxt").val(),
		    						"mainport": $("#mainPortTxt").val(),
		    						"apn": $("#apnTxt").val(),
		    						"backupip": $("#backupIpTxt").val(),
		    						"backupport": $("#backupPortTxt").val()
		    					},
		    					success: function(d) {
		    						if (d == ""){
		                        		$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置主站IP失败。</div>");
		                        	}
		    						else {
		    	                        if (d.indexOf("html") > 0) { //session超时
		    	                            parent.window.location.reload();
		    	                        }
		    	                        else {
		    	                        	var a = JSON.parse(d);
		    			                    for(var p in a){
		        			                    frameNumber++;
		    		                            //组帧，Global.js中定义
		    		                            var frame = makeWSFrame(frameNumber, 0, 1, 1, a[p], '');
		    		                            ws.send(frame);
		    			                    }
		    	                            if ($("body").find(".datagrid-mask").length == 0) {
		    	                                //添加等待提示
		    	                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
		    	                                $("<div class=\"datagrid-mask-msg\"></div>").html("设置中，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
		    	                            }
		    	                        }
		    	                    } 
		    					}
		    				});
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
    
    //查询主站IP
    function readIp(){
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
					url: '${pageContext.request.contextPath}/unitParams/getIp',
					data: {
						"id": selectedID,
						"type": selectedType,
						"address": $("#selectedAddress").val()
					},
					success: function(d) {
						if (d != "" && d !="[]") {
			                if (d.indexOf("html") > 0) { //session超时
			                    parent.window.location.reload();
			                }
			                else {
			                	var a = JSON.parse(d);
			                    for(var p in a){
    			                    frameNumber++;
		                            //组帧，Global.js中定义
		                            var frame = makeWSFrame(frameNumber, 0, 1, 1, a[p], '');
		                            ws.send(frame);
			                    }
			                    if ($("body").find(".datagrid-mask").length == 0) {
	                                //添加等待提示
	                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
	                                $("<div class=\"datagrid-mask-msg\"></div>").html("查询中，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
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
    
    //设置WIFI
    function setWifi(){
    	var selectedID = $.trim($("#selectedID").val());
    	var selectedType = $.trim($("#selectedType").val());
        if (selectedID == "") {
        	$.messager.alert("提示", "请选择终端。", "warning");
            return;
        }
        if (ws) {
            if (ws.readyState == 1) {
            	if ($('#wifiForm').form('validate')){
            		$.messager.confirm('警告','确认设置 '+$("#snode").textbox('getValue')+" 下所有终端和GPRS设备",function(r){
					    if (r){		
	            		$.ajax({
	    					type: 'POST',
	    					url: "${pageContext.request.contextPath}/unitParams/setWifi",
	    					data: {
	    						"id": selectedID,
	    						"type": selectedType,
	    						"address": $("#selectedAddress").val(),
	    						"username": $("#userNameTxt").val(),
	    						"pwd": $("#pwdTxt").val()
	    					},
	    					success: function(d) {
	    						if (d == ""){
	                        		$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置WIFI失败。</div>");
	                        	}
	    						else {
	    	                        if (d.indexOf("html") > 0) { //session超时
	    	                            parent.window.location.reload();
	    	                        }
	    	                        else {
	    	                        	var a = JSON.parse(d);
	    			                    for(var p in a){
	        			                    frameNumber++;
	    		                            //组帧，Global.js中定义
	    		                            var frame = makeWSFrame(frameNumber, 0, 1, 1, a[p], '');
	    		                            ws.send(frame);
	    			                    }
	    	                            if ($("body").find(".datagrid-mask").length == 0) {
	    	                                //添加等待提示
	    	                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
	    	                                $("<div class=\"datagrid-mask-msg\"></div>").html("设置中，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
	    	                            }
	    	                        }
	    	                    } 
	    					}
	    				});
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
    
    //查询WIFI
    function readWifi(){
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
					url: '${pageContext.request.contextPath}/unitParams/getWifi',
					data: {
						"id": selectedID,
						"type": selectedType,
						"address": $("#selectedAddress").val()
					},
					success: function(d) {
						if (d != "" && d !="[]"){
			                if (d.indexOf("html") > 0) { //session超时
			                    parent.window.location.reload();
			                }
			                else {
			                	var a = JSON.parse(d);
			                    for(var p in a){
    			                    frameNumber++;
		                            //组帧，Global.js中定义
		                            var frame = makeWSFrame(frameNumber, 0, 1, 1, a[p], '');
		                            ws.send(frame);
			                    }
			                    if ($("body").find(".datagrid-mask").length == 0) {
	                                //添加等待提示
	                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
	                                $("<div class=\"datagrid-mask-msg\"></div>").html("查询中，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
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
    
    //设置以太网
    function setEthernet(){
    	var selectedID = $.trim($("#selectedID").val());
    	var selectedType = $.trim($("#selectedType").val());
        if (selectedID == "") {
        	$.messager.alert("提示", "请选择终端。", "warning");
            return;
        }
        if (ws) {
            if (ws.readyState == 1) {
            	if ($('#ethernetForm').form('validate')){
            		$.messager.confirm('警告','确认设置 '+$("#snode").textbox('getValue')+" 下所有终端和GPRS设备",function(r){
					    if (r){	
	            		$.ajax({
	    					type: 'POST',
	    					url: "${pageContext.request.contextPath}/unitParams/setEthernet",
	    					data: {
	    						"id": selectedID,
	    						"type": selectedType,
	    						"address": $("#selectedAddress").val(),
	    						"mac": $("#macTxt").val(),
	    						"localip": $("#localIpTxt").val(),
	    						"submask": $("#submaskTxt").val(),
	    						"gateway": $("#gatewayTxt").val()
	    					},
	    					success: function(d) {
	    						if (d == ""){
	                        		$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置以太网失败。</div>");
	                        	}
	    						else {
	    	                        if (d.indexOf("html") > 0) { //session超时
	    	                            parent.window.location.reload();
	    	                        }
	    	                        else {
	    	                        	var a = JSON.parse(d);
	    			                    for(var p in a){
	        			                    frameNumber++;
	    		                            //组帧，Global.js中定义
	    		                            var frame = makeWSFrame(frameNumber, 0, 1, 1, a[p], '');
	    		                            ws.send(frame);
	    			                    }
	    	                            if ($("body").find(".datagrid-mask").length == 0) {
	    	                                //添加等待提示
	    	                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
	    	                                $("<div class=\"datagrid-mask-msg\"></div>").html("设置中，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
	    	                            }
	    	                        }
	    	                    } 
	    					}
	    				});
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
    
    //查询以太网
    function readEthernet(){
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
					url: '${pageContext.request.contextPath}/unitParams/getEthernet',
					data: {
						"id": selectedID,
						"type": selectedType,
						"address": $("#selectedAddress").val()
					},
					success: function(d) {
						if (d != "" && d !="[]") {
			                if (d.indexOf("html") > 0) { //session超时
			                    parent.window.location.reload();
			                }
			                else {
			                	var a = JSON.parse(d);
			                    for(var p in a){
    			                    frameNumber++;
		                            //组帧，Global.js中定义
		                            var frame = makeWSFrame(frameNumber, 0, 1, 1, a[p], '');
		                            ws.send(frame);
			                    }
			                    if ($("body").find(".datagrid-mask").length == 0) {
	                                //添加等待提示
	                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
	                                $("<div class=\"datagrid-mask-msg\"></div>").html("查询中，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
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
    
    //设置短信
    function setSms(){
    	var selectedID = $.trim($("#selectedID").val());
    	var selectedType = $.trim($("#selectedType").val());
        if (selectedID == "") {
        	$.messager.alert("提示", "请选择终端。", "warning");
            return;
        }
        if (ws) {
            if (ws.readyState == 1) {
            	if ($('#smsForm').form('validate')){
            		$.messager.confirm('警告','确认设置 '+$("#snode").textbox('getValue')+" 下所有终端和GPRS设备",function(r){
					    if (r){	
	            		$.ajax({
	    					type: 'POST',
	    					url: "${pageContext.request.contextPath}/unitParams/setSms",
	    					data: {
	    						"id": selectedID,
	    						"type": selectedType,
	    						"address": $("#selectedAddress").val(),
	    						"smscenter": $("#smsCenterTxt").val(),
	    						"usermobile": $("#userMobileTxt").val()
	    					},
	    					success: function(d) {
	    						if (d == ""){
	                        		$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置短信失败。</div>");
	                        	}
	    						else {
	    	                        if (d.indexOf("html") > 0) { //session超时
	    	                            parent.window.location.reload();
	    	                        }
	    	                        else {
	    	                        	var a = JSON.parse(d);
	    			                    for(var p in a){
	        			                    frameNumber++;
	    		                            //组帧，Global.js中定义
	    		                            var frame = makeWSFrame(frameNumber, 0, 1, 1, a[p], '');
	    		                            ws.send(frame);
	    			                    }
	    	                            if ($("body").find(".datagrid-mask").length == 0) {
	    	                                //添加等待提示
	    	                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
	    	                                $("<div class=\"datagrid-mask-msg\"></div>").html("设置中，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
	    	                            }
	    	                        }
	    	                    } 
	    					}
	    				});
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
    
    //查询短信
    function readSms(){
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
					url: '${pageContext.request.contextPath}/unitParams/getSms',
					data: {
						"id": selectedID,
						"type": selectedType,
						"address": $("#selectedAddress").val()
					},
					success: function(d) {
						if (d != "" && d !="[]") {
			                if (d.indexOf("html") > 0) { //session超时
			                    parent.window.location.reload();
			                }
			                else {
			                	var a = JSON.parse(d);
			                    for(var p in a){
    			                    frameNumber++;
		                            //组帧，Global.js中定义
		                            var frame = makeWSFrame(frameNumber, 0, 1, 1, a[p], '');
		                            ws.send(frame);
			                    }
			                    if ($("body").find(".datagrid-mask").length == 0) {
	                                //添加等待提示
	                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
	                                $("<div class=\"datagrid-mask-msg\"></div>").html("查询中，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
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
    
    //设置重发机制
    function setRepeat(){
    	var selectedID = $.trim($("#selectedID").val());
    	var selectedType = $.trim($("#selectedType").val());
        if (selectedID == "") {
        	$.messager.alert("提示", "请选择终端。", "warning");
            return;
        }
        if (ws) {
            if (ws.readyState == 1) {
            	if ($('#repeatForm').form('validate')){
            		$.messager.confirm('警告','确认设置 '+$("#snode").textbox('getValue')+" 下所有终端和GPRS设备",function(r){
					    if (r){	
		            		$.ajax({
		    					type: 'POST',
		    					url: "${pageContext.request.contextPath}/unitParams/setRepeat",
		    					data: {
		    						"id": selectedID,
		    						"type": selectedType,
		    						"address": $("#selectedAddress").val(),
		    						"waittime": $("#waitTimeTxt").val(),
		    						"repeattimes": $("#repeatTimesTxt").val(),
		    						"heartbeat": $("#heartBeatTxt").val()
		    					},
		    					success: function(d) {
		    						if (d == ""){
		                        		$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置重发机制失败。</div>");
		                        	}
		    						else {
		    	                        if (d.indexOf("html") > 0) { //session超时
		    	                            parent.window.location.reload();
		    	                        }
		    	                        else {
		    	                        	var a = JSON.parse(d);
		    			                    for(var p in a){
		        			                    frameNumber++;
		    		                            //组帧，Global.js中定义
		    		                            var frame = makeWSFrame(frameNumber, 0, 1, 1, a[p], '');
		    		                            ws.send(frame);
		    			                    }
		    	                            if ($("body").find(".datagrid-mask").length == 0) {
		    	                                //添加等待提示
		    	                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
		    	                                $("<div class=\"datagrid-mask-msg\"></div>").html("设置中，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
		    	                            }
		    	                        }
		    	                    } 
		    					}
		    				});
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
    
    //查询重发机制
    function readRepeat(){
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
					url: '${pageContext.request.contextPath}/unitParams/getRepeat',
					data: {
						"id": selectedID,
						"type": selectedType,
						"address": $("#selectedAddress").val()
					},
					success: function(d) {
						if (d != "" && d !="[]") {
			                if (d.indexOf("html") > 0) { //session超时
			                    parent.window.location.reload();
			                }
			                else {
			                	var a = JSON.parse(d);
			                    for(var p in a){
    			                    frameNumber++;
		                            //组帧，Global.js中定义
		                            var frame = makeWSFrame(frameNumber, 0, 1, 1, a[p], '');
		                            ws.send(frame);
			                    }
			                    if ($("body").find(".datagrid-mask").length == 0) {
	                                //添加等待提示
	                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
	                                $("<div class=\"datagrid-mask-msg\"></div>").html("查询中，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
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
    
    //设置终端时间
    function setTime(){
    	if ($('#sysTimeCk').prop('checked')){
    		//取当前时间
    		initDateTime();
    	}
    	var selectedID = $.trim($("#selectedID").val());
    	var selectedType = $.trim($("#selectedType").val());
        if (selectedID == "") {
        	$.messager.alert("提示", "请选择终端。", "warning");
            return;
        }
        if (ws) {
            if (ws.readyState == 1) {
            	if ($('#timeForm').form('validate')){
            		$.messager.confirm('警告','确认设置 '+$("#snode").textbox('getValue')+" 下所有终端和GPRS设备",function(r){
					    if (r){	
		            		$.ajax({
		    					type: 'POST',
		    					url: "${pageContext.request.contextPath}/unitParams/setTime",
		    					data: {
		    						"id": selectedID,
		    						"type": selectedType,
		    						"address": $("#selectedAddress").val(),
		    						"ymd": $("#ymdTxt").val(),
		    						"hms": $("#hmsTxt").val()
		    					},
		    					success: function(d) {
		    						if (d == ""){
		                        		$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置终端时间失败。</div>");
		                        	}
		    						else {
		    	                        if (d.indexOf("html") > 0) { //session超时
		    	                            parent.window.location.reload();
		    	                        }
		    	                        else {
		    	                        	var a = JSON.parse(d);
		    			                    for(var p in a){
			    			                    frameNumber++;
					                            //组帧，Global.js中定义
					                            var frame = makeWSFrame(frameNumber, 0, 1, 1, a[p], '');
					                            ws.send(frame);
		    			                    }
		    	                            if ($("body").find(".datagrid-mask").length == 0) {
		    	                                //添加等待提示
		    	                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
		    	                                $("<div class=\"datagrid-mask-msg\"></div>").html("设置中，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
		    	                            }
		    	                        }
		    	                    } 
		    					}
		    				});
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
    
    //查询终端时间
    function readTime(){
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
					url: '${pageContext.request.contextPath}/unitParams/getTime',
					data: {
						"id": selectedID,
						"type": selectedType,
						"address": $("#selectedAddress").val()
					},
					success: function(d) {
						if (d != "" && d !="[]") {
			                if (d.indexOf("html") > 0) { //session超时
			                    parent.window.location.reload();
			                }
			                else {
			                	var a = JSON.parse(d);
			                    for(var p in a){
    			                    frameNumber++;
		                            //组帧，Global.js中定义
		                            var frame = makeWSFrame(frameNumber, 0, 1, 1, a[p], '');
		                            ws.send(frame);
			                    }
			                    if ($("body").find(".datagrid-mask").length == 0) {
	                                //添加等待提示
	                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
	                                $("<div class=\"datagrid-mask-msg\"></div>").html("查询中，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
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
    
    //设置互感器变比
    function setCtr(){
    	var selectedID = $.trim($("#selectedID").val());
    	var selectedType = $.trim($("#selectedType").val());
        if (selectedID == "") {
        	$.messager.alert("提示", "请选择终端。", "warning");
            return;
        }
        if (ws) {
            if (ws.readyState == 1) {
            	if ($('#ctrForm').form('validate')){
            		$.messager.confirm('警告','确认设置 '+$("#snode").textbox('getValue')+" 下所有终端和GPRS设备",function(r){
					    if (r){	
		            		$.ajax({
		    					type: 'POST',
		    					url: "${pageContext.request.contextPath}/unitParams/setCtr",
		    					data: {
		    						"id": selectedID,
		    						"type": selectedType,
		    						"address": $("#selectedAddress").val(),
		    						"ctr": $("#ctr").combotree('getValue')
		    					},
		    					success: function(d) {
		    						if (d == ""){
		                        		$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置电流互感器变比失败。</div>");
		                        	}
		    						else {
		    	                        if (d.indexOf("html") > 0) { //session超时
		    	                            parent.window.location.reload();
		    	                        }
		    	                        else {
		    	                        	var a = JSON.parse(d);
		    			                    for(var p in a){
		        			                    frameNumber++;
		    		                            //组帧，Global.js中定义
		    		                            var frame = makeWSFrame(frameNumber, 0, 1, 1, a[p], '');
		    		                            ws.send(frame);
		    			                    }
		    	                            if ($("body").find(".datagrid-mask").length == 0) {
		    	                                //添加等待提示
		    	                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
		    	                                $("<div class=\"datagrid-mask-msg\"></div>").html("设置中，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
		    	                            }
		    	                        }
		    	                    } 
		    					}
		    				});
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
    
    //查询电流互感器变比
    function readCtr(){
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
					url: '${pageContext.request.contextPath}/unitParams/getCtr',
					data: {
						"id": selectedID,
						"type": selectedType,
						"address": $("#selectedAddress").val()
					},
					success: function(d) {
						if (d != "" && d !="[]") {
			                if (d.indexOf("html") > 0) { //session超时
			                    parent.window.location.reload();
			                }
			                else {
			                	var a = JSON.parse(d);
			                    for(var p in a){
    			                    frameNumber++;
		                            //组帧，Global.js中定义
		                            var frame = makeWSFrame(frameNumber, 0, 1, 1, a[p], '');
		                            ws.send(frame);
			                    }
			                    if ($("body").find(".datagrid-mask").length == 0) {
	                                //添加等待提示
	                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
	                                $("<div class=\"datagrid-mask-msg\"></div>").html("查询中，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
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
    
    //设置接线模式字
    function setPower(){
    	var selectedID = $.trim($("#selectedID").val());
    	var selectedType = $.trim($("#selectedType").val());
        if (selectedID == "") {
        	$.messager.alert("提示", "请选择终端。", "warning");
            return;
        }
        if (ws) {
            if (ws.readyState == 1) {
            	if ($('#powerForm').form('validate')){
            		$.messager.confirm('警告','确认设置 '+$("#snode").textbox('getValue')+" 下所有终端和GPRS设备",function(r){
					    if (r){	
		            		$.ajax({
		    					type: 'POST',
		    					url: "${pageContext.request.contextPath}/unitParams/setPower",
		    					data: {
		    						"id": selectedID,
		    						"type": selectedType,
		    						"address": $("#selectedAddress").val(),
		    						"powermode": $("#powermodeSel").combobox('getValue'),
		    						"powerphase": $("#powerphaseSel").combobox('getValue'),
		    						"temptermina": getParam()
		    					},
		    					success: function(d) {
		    						if (d == ""){
		                        		$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置接线模式字失败。</div>");
		                        	}
		    						else {
		    	                        if (d.indexOf("html") > 0) { //session超时
		    	                            parent.window.location.reload();
		    	                        }
		    	                        else {
		    	                        	var a = JSON.parse(d);
		    			                    for(var p in a){
		        			                    frameNumber++;
		    		                            //组帧，Global.js中定义
		    		                            var frame = makeWSFrame(frameNumber, 0, 1, 1, a[p], '');
		    		                            ws.send(frame);
		    			                    }
		    	                            if ($("body").find(".datagrid-mask").length == 0) {
		    	                                //添加等待提示
		    	                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
		    	                                $("<div class=\"datagrid-mask-msg\"></div>").html("设置中，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
		    	                            }
		    	                        }
		    	                    } 
		    					}
		    				});
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
    
    //获取温度模式字拼凑字符串
    function getParam(){
    	var words = $("input[name='sb']");
    	var s="";
    	for (i = 0; i < words.length; i++) {
    		var status= words[i].checked;
			if(status) s+="1";
			else s+="0";
    	}
    	return s;
    }
    
    //查询接线模式字
    function readPower(){
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
					url: '${pageContext.request.contextPath}/unitParams/getPower',
					data: {
						"id": selectedID,
						"type": selectedType,
						"address": $("#selectedAddress").val()
					},
					success: function(d) {
						if (d != "" && d !="[]") {
			                if (d.indexOf("html") > 0) { //session超时
			                    parent.window.location.reload();
			                }
			                else {
			                	var a = JSON.parse(d);
			                    for(var p in a){
    			                    frameNumber++;
		                            //组帧，Global.js中定义
		                            var frame = makeWSFrame(frameNumber, 0, 1, 1, a[p], '');
		                            ws.send(frame);
			                    }
			                    if ($("body").find(".datagrid-mask").length == 0) {
	                                //添加等待提示
	                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
	                                $("<div class=\"datagrid-mask-msg\"></div>").html("查询中，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
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
    
    //数据清零
    function clearData(){
    	var selectedID = $.trim($("#selectedID").val());
    	var selectedType = $.trim($("#selectedType").val());
        if (selectedID == "") {
        	$.messager.alert("提示", "请选择终端。", "warning");
            return;
        }
        if (ws) {
            if (ws.readyState == 1) {
            	$.messager.confirm('数据清零','你确定要执行数据清零操作吗？',
    				function(r) {
    					if (r) {
			            	$.ajax({
								type: 'POST',
								url: '${pageContext.request.contextPath}/unitParams/clearData',
								data: {
									"id": selectedID,
		    						"type": selectedType,
		    						"address": $("#selectedAddress").val(),
								},
								success: function(d) {
					                if (d.indexOf("html") > 0) { //session超时
					                    parent.window.location.reload();
					                }
					                else {
					                    frameNumber++;
					                    //组帧，Global.js中定义
					                    var frame = makeWSFrame(frameNumber, 0, 1, 1, d, '');
					                    ws.send(frame);
					                    if ($("body").find(".datagrid-mask").length == 0) {
			                                //添加等待提示
			                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
			                                $("<div class=\"datagrid-mask-msg\"></div>").html("数据清零中，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
			                            }
					                }
								}
							});
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
    
    //清空返回结果
    function clearResult(){
    	$("#resultPanel").html("");
    }
    
    //设置密码
    function setPwd(){
    	var selectedID = $.trim($("#selectedID").val());
    	var selectedType = $.trim($("#selectedType").val());
        if (selectedType != commonTreeNodeType.terminal 
				&& node.type != commonTreeNodeType.gprsDevice) {
        	$.messager.alert("提示", "请选择终端或GPRS设备。", "warning");
            return;
        }
        if (ws) {
            if (ws.readyState == 1) {
            	if ($('#pwdForm').form('validate')){
            		$.messager.confirm('警告','确认设置 '+$("#snode").textbox('getValue'),function(r){
					    if (r){	
		            		$.ajax({
		    					type: 'POST',
		    					url: "${pageContext.request.contextPath}/unitParams/setPwd",
		    					data: {
		    						"id": selectedID,
		    						"type": selectedType,
		    						"address": $("#selectedAddress").val(),
		    						"password": $("#passwordTxt").val()
		    					},
		    					success: function(d) {
		    						if (d == ""){
		                        		$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置密码失败。</div>");
		                        	}
		    						else {
		    	                        if (d.indexOf("html") > 0) { //session超时
		    	                            parent.window.location.reload();
		    	                        }
		    	                        else {
		    	                            frameNumber++;
		    	                            //组帧，Global.js中定义
		    	                            var frame = makeWSFrame(frameNumber, 0, 1, 1, d, '');
		    	                            ws.send(frame);
		    	                            if ($("body").find(".datagrid-mask").length == 0) {
		    	                                //添加等待提示
		    	                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
		    	                                $("<div class=\"datagrid-mask-msg\"></div>").html("设置中，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
		    	                            }
		    	                        }
		    	                    } 
		    					}
		    				});
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
    
    //设置密钥
    function setSecretKey(){
    	if ($('#secretKeyForm').form('validate')){
    		$.ajax({
				type: 'POST',
				url: "${pageContext.request.contextPath}/unitParams/setSecretKey",
				data: {
					"keyversion": $("#keyversion").numberspinner('getValue'),
					"remark": $("#remark").val()
				},
				success: function(d) {
					if (d == "success"){
						$("#resultPanel").prepend("<div style='color:green;padding:5px'>设置密钥成功。</div>");
                	}
					else {
						$("#resultPanel").prepend("<div style='color:red;padding:5px'>设置密钥失败。</div>");
                    } 
				}
			});
    	}
    }
    
    //读取终端版本号
    function getVersion(){
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
					url: '${pageContext.request.contextPath}/unitParams/getVersion',
					data: {
						"id": selectedID,
						"type": selectedType,
						"address": $("#selectedAddress").val()
					},
					success: function(d) {
						if (d != "" && d !="[]") {
			                if (d.indexOf("html") > 0) { //session超时
			                    parent.window.location.reload();
			                }
			                else {
			                	var a = JSON.parse(d);
			                    for(var p in a){
    			                    frameNumber++;
		                            //组帧，Global.js中定义
		                            var frame = makeWSFrame(frameNumber, 0, 1, 1, a[p], '');
		                            ws.send(frame);
			                    }
			                    if ($("body").find(".datagrid-mask").length == 0) {
	                                //添加等待提示
	                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
	                                $("<div class=\"datagrid-mask-msg\"></div>").html("读取中，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
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
    
    //读取终端SIM卡号
    function getSim(){
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
					url: '${pageContext.request.contextPath}/unitParams/getSim',
					data: {
						"id": selectedID,
						"type": selectedType,
						"address": $("#selectedAddress").val()
					},
					success: function(d) {
						if (d != "" && d !="[]") {
			                if (d.indexOf("html") > 0) { //session超时
			                    parent.window.location.reload();
			                }
			                else {
			                	var a = JSON.parse(d);
			                    for(var p in a){
    			                    frameNumber++;
		                            //组帧，Global.js中定义
		                            var frame = makeWSFrame(frameNumber, 0, 1, 1, a[p], '');
		                            ws.send(frame);
			                    }
			                    if ($("body").find(".datagrid-mask").length == 0) {
	                                //添加等待提示
	                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
	                                $("<div class=\"datagrid-mask-msg\"></div>").html("读取中，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
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
    	//删除等待提示
        $("body").find("div.datagrid-mask-msg").remove();
        $("body").find("div.datagrid-mask").remove();
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
        //删除等待提示
        $("body").find("div.datagrid-mask-msg").remove();
        $("body").find("div.datagrid-mask").remove();
        //帧类型为3（握手），表示端口号
        if (frame.type == '3') {
            port = frame.data;
        }
        else if (frame.type == '2') {  //帧类型为2（应答）
            if (frame.data.length.toString() == frame.len) { //判断是否接收到完整的数据帧
            	$.ajax({
					type: 'POST',
					url: '${pageContext.request.contextPath}/unitParams/parseResponse',
					data: {
						"strXML": frame.data
					},
					success: function(d) {
						switch(d.result){
						case 1:
							switch (d.typeFlagCode){
							case 128:
								switch(d.configurationCode){
								case 1:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>"+d.address+":设置设备地址成功。</div>");
									break;
								case 2:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>"+d.address+":设置主站IP成功。</div>");
									break;
								case 3:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>"+d.address+":设置WIFI信息成功。</div>");
									break;
								case 4:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>"+d.address+":设置以太网成功。</div>");
									break;
								case 5:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>"+d.address+":设置短信信息成功。</div>");
									break;
								case 10:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>"+d.address+":设置重发机制成功。</div>");
									break;
								case 11:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>"+d.address+":设置密码成功。</div>");
									break;
								case 13:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>"+d.address+":设置电流互感器变比成功。</div>");
									break;
								case 14:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>"+d.address+":设置接线模式字成功。</div>");
									break;
								}
								break;
							case 130:
								$("#resultPanel").prepend("<div style='color:green;padding:5px'>"+d.address+":设置终端时间成功。</div>");
								break;
							case 152:
								$("#resultPanel").prepend("<div style='color:green;padding:5px'>"+d.address+":数据清零成功。</div>");
								break;
							case 206:
								switch(d.configurationCode){
								case 1:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>"+d.address+":查询设备地址成功。</div>");
									$("#resultPanel").prepend(d.data);
									break;
								case 2:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>"+d.address+":查询主站IP成功。</div>");
									$("#resultPanel").prepend(d.data);
									break;
								case 3:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>"+d.address+":查询WIFI信息成功。</div>");
									$("#resultPanel").prepend(d.data);
									break;
								case 4:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>"+d.address+":查询以太网成功。</div>");
									$("#resultPanel").prepend(d.data);
									break;
								case 5:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>"+d.address+":查询短信信息成功。</div>");
									$("#resultPanel").prepend(d.data);
									break;
								case 10:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>"+d.address+":查询重发机制成功。</div>");
									$("#resultPanel").prepend(d.data);
									break;
								case 12:	
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>"+d.address+":读取SIM卡序号成功。</div>");
									$("#resultPanel").prepend(d.data);
									break;
								case 13:	
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>"+d.address+":查询电流互感器变比成功。</div>");
									$("#resultPanel").prepend(d.data);
									break;
								case 14:			
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>"+d.address+":查询接线模式字成功。</div>");
									$("#resultPanel").prepend(d.data);
									break;
								}
								break;
							case 208:			
								$("#resultPanel").prepend("<div style='color:green;padding:5px'>"+d.address+":查询终端时间成功。</div>");
								$("#resultPanel").prepend(d.data);
								break;
							case 215:
								$("#resultPanel").prepend("<div style='color:green;padding:5px'>"+d.address+":查询终端版本号成功。</div>");
								$("#resultPanel").prepend(d.data);
								break;
							}
							break;
						case 2:
							$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+d.address+":终端连接超时。</div>");
							break;
						case 3:
							$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+d.address+":终端否认应答。</div>");
							break;
						case 4:
							$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+d.address+":终端不在线。</div>");
							break;
						case 8:
							switch (d.typeFlagCode){
							case 128:
								switch(d.configurationCode){
								case 1:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+d.address+":设置设备地址失败。</div>");
									break;
								case 2:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+d.address+":设置主站IP失败。</div>");
									break;
								case 3:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+d.address+":设置WIFI信息失败。</div>");
									break;
								case 4:		
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+d.address+":设置以太网失败。</div>");
									break;
								case 5:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+d.address+":设置短信信息失败。</div>");
									break;
								case 10:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+d.address+":设置重发机制失败。</div>");
									break;
								case 11:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+d.address+":设置密码失败。</div>");
									break;
								case 13:	
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+d.address+":设置电流互感器变比失败。</div>");
									break;
								case 14:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+d.address+":设置接线模式字失败。</div>");
									break;
								}
								break;
							case 130:			
								$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+d.address+":设置终端时间失败。</div>");
								break;
							case 152:					
								$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+d.address+":数据清零失败。</div>");
								break;
							case 206:
								switch(d.configurationCode){
								case 1:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+d.address+":查询设备地址失败。</div>");
									$("#resultPanel").prepend(d.data);
									break;
								case 2:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+d.address+":查询主站IP失败。</div>");
									$("#resultPanel").prepend(d.data);
									break;
								case 3:	
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+d.address+":查询WIFI信息失败。</div>");
									$("#resultPanel").prepend(d.data);
									break;
								case 4:					
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+d.address+":查询以太网失败。</div>");
									$("#resultPanel").prepend(d.data);
									break;
								case 5:	
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+d.address+":查询短信信息失败。</div>");
									$("#resultPanel").prepend(d.data);
									break;
								case 10:		
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+d.address+":查询重发机制失败。</div>");
									$("#resultPanel").prepend(d.data);
									break;
								case 12:			
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+d.address+":读取SIM卡序号失败。</div>");
									$("#resultPanel").prepend(d.data);
									break;
								case 13:				
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+d.address+":查询电流互感器变比失败。</div>");
									$("#resultPanel").prepend(d.data);
									break;
								case 14:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+d.address+":查询接线模式字失败。</div>");
									$("#resultPanel").prepend(d.data);
									break;
								}
								break;
							case 208:					
								$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+d.address+":查询终端时间失败。</div>");
								break;
							case 215:						
								$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+d.address+":查询终端版本号失败。</div>");
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
        	$("body").find("div.datagrid-mask-msg").remove();
            $("body").find("div.datagrid-mask").remove();
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

