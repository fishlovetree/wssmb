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
<title>档案管理</title>
<jsp:include page="../../Header.jsp"/>
<style type="text/css">
	#organizationtree, #regiontree {
	    border-color: transparent;
	} 
	/* #menuTab{
		border-right: 1px solid #cfcfd1;
	} */
	
	#clearall{
		margin-top: 20px;
	    margin-left: 10px;
	    width: 200px;
	}
	#search{
	    width: 80px;
	    margin-left:5px;
	}
	
	/* #mainPanel .panel-header{
		border-top: 2px solid #ccc;
	}*/
	
	#searchDg,#searchDg tr th, #searchDg tr td { 
		border:1px solid #ccc; 
	} 
	
    #searchDg { 
    	width: 100%; 
    	text-align: center; 
    	border-collapse: collapse;
    } 
    
    #searchDg tr th{
    	 font-weight:bold;
    	 font-size:12px;
    	 height:35px;
    } 
    #searchDg tr td{
    	 font-size:12px;
    	 height:35px;
    }
    .layout-split-west {
	    border-right: 1px solid #ccc;
	}
	.layout-split-south {
	    border-top: 1px solid #ccc;
	}
</style>
</head>
<body>
    <div class="easyui-layout" fit="true">
	    <div id="west" region="west" iconCls="icon-organization" split="true" title="设备" style="width:284px;min-width:284px;" collapsible="true">
			<jsp:include page="../../CommonTree/term_DeviceTree.jsp"/>
		</div>
		<div id="mainPanel" region="center" width="100%" height="100%">
		    <div class="easyui-layout" fit="true">
			    <div data-options="region:'north',split:false" style="height:48px;">
					<table border="0" cellspacing="8" cellpadding="8">
						<tr>
							<td class="tableHead_right" align="right">节点：</td>
							<td><input type="text" id='snode' class="easyui-textbox"
								readonly="readonly" style="width: 180px;" /> 
								<input type="hidden" id="selectedParentid" />
								<input type="hidden" id="selectedUnitid" />
							</td>
						</tr>
					</table>
				</div>
		        <div data-options="region:'center',split:false">
		            <div id="menuTab" class="easyui-tabs" data-options="border:false" style="height:100%;width:100%;">
			            <div title="档案初始化" style="padding:0;height:100%;">
							<a href="#" class="easyui-linkbutton" data-options="" onclick="clearAll()" id="clearall">档案初始化</a>
			            </div>
			            <div title="下发档案" style="padding:0;height:100%;">
							<!-- 列表 -->
							<table id="setDg" ></table>
							
							<div id="settool">
								<a href="#" class="easyui-linkbutton" onclick="issued()" id="set">下发</a>
								<a href="#" class="easyui-linkbutton" data-options="" onclick="allIssued()">一键下发</a>
							</div>
			            </div>
			            <div title="查询档案" style="padding:0;height:100%;width:100%;">
			            	<div class="easyui-layout" style="width:100%;height:100%;">
					        	<div data-options="region:'north'" style="height:48px">
					            	<table border="0" cellspacing="8" cellpadding="8">
										<tr>
											<td class="tableHead_right" align="right">起始序号：</td>
											<td>
												<input type="text" id='stardNum' class="easyui-numberbox" style="width: 120px;" /> 
											</td>
											<td class="tableHead_right" align="right">读取个数：</td>
											<td>
												<input type="text" id='count' class="easyui-numberbox" data-options="precision:0" style="width: 120px;" /> 
											</td>
											<td style="border-left:1px solid #c5c5c5;">
												<a href="#" class="easyui-linkbutton" onclick="searchDevice()" id="search">搜索</a>
											</td>
											<td>
												<label style=" font-size: 8px !important; color: red; ">查询到的数据(上)</label>
												<br/><label style=" font-size: 8px !important; color: red; ">系统内的数据(下)</label>
											</td>
										</tr>
									</table>
								</div>
								<div data-options="region:'center'" style="width:100%;">
									<div class="easyui-layout" style="width:100%;height:100%;">
										<div data-options="region:'center'" style="height:50%;">
											<table id="existdg" ></table>
							        	</div>
							        	<div id="south" data-options="region:'south',split:true" style="height:55%;">
							        		<table id="dg" ></table>
							        	</div>
							        </div>
					        	</div>
					        </div>
			            </div>
					</div>
		        </div>
		        <div data-options="region:'south',split:true"  style="height: 120px;" title="结果<a href='javascript:void(0)' class='easyui-linkbutton' style='float: right; width: 40px;' 
		        onclick='clearResult();'>清空</a>">
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
	var equipmentids = [];
	var resultlist = [];

	var sendXmlCount = 0; //发送到前置机总数量
	var msgCount = 0; //接收到前置机消息数量
	var progressBar; //进度条
	//初始化进度条参数
	function initProgress() {
		sendXmlCount = 0;
		msgCount = 0;
	    progressBar = undefined;
	    $.messager.progress('close');
	}
	
	//用于使chart自适应高度和宽度,通过窗体高宽计算容器高宽
	var resizeDiv = function () {
		var width=$('#west').width();//当有title时，width:284px;min-width:284px;；反之，则width:280px;min-width:280px;
		var height=$('#west').height();
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

    	$('#existdg').datagrid({
			sortName: 'systemtypename,equipmentname',
		    sortOrder: 'asc,asc',
		    remoteSort: false,//定义是否通过远程服务器对数据排序。(默认为true) 一定改为false
			fit: true,   //自适应大小
			singleSelect: false,
			//iconCls : 'icon-save',
			border:false,
			nowrap: true,//数据长度超出列宽时将会自动截取。
			rownumbers:true,//行号
			fitColumns:true,//自动使列适应表格宽度以防止出现水平滚动。
			rowStyler:function(index,row){
				if(row.equipmentid==0)
					return 'color:red;';
				else
					return 'color:green;';
			},
			columns:  [[
						{title: '系统类型', field: 'systemtypename', width:'160px',sortable:true}, 
				        {title: '系统地址', field: 'systemaddress', width:'70px'},
						{title: '设备名称', field: 'equipmentname', width:'160px',sortable:true}, 
						{title: '设备类型', field: 'equipmenttypename', width:'140px'},
						{title: '设备地址', field: 'equipmentaddress',width:'125px'},
						{title: '设备说明', field: 'equipmentnote',width:'150px'}
			        ]]
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
    	
		//模拟时钟
    	setInterval(function(){
        	var now = new Date();
        	var y = now.getFullYear();
            var m = now.getMonth()+1;
            var d = now.getDate();
            var h = now.getHours();
            var t = now.getMinutes();
            var s = now.getSeconds();
        	$('#ymdTxt').datebox('setValue', y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d));
        	$('#hmsTxt').timespinner('setValue', (h<10?('0'+h):h)+':'+(t<10?('0'+t):t)+':'+(s<10?('0'+s):s));
        }, 1000);
    	
    	//websocket
    	connect();
    })

    var treeTab = $('#region_tree');
	//公用树点击事件
	function treeClick(treeObj, n){
		if(typeof n!='undefined' ){
			node = n;
			treeTab = treeObj;
			searchFile();
		}
	}

    function searchFile(){	
    	$("#snode").textbox('setValue', node.text);

		if(node.type == commonTreeNodeType.terminal
				|| node.type == commonTreeNodeType.terminalBigType
				|| node.type == commonTreeNodeType.terminalDevice){
	        $("#selectedParentid").val(0);
	        switch (node.type){//消防监测终端
            case commonTreeNodeType.terminal:
            	$("#selectedUnitid").val(node.gid);//终端ID
            	break;
            case commonTreeNodeType.terminalBigType: //消防监测终端大类
                var pnode = treeTab.tree('getParent', node.target);
                $("#selectedUnitid").val(pnode.gid);
                $("#selectedParentid").val(pnode.gid);
            	break;
            case commonTreeNodeType.terminalDevice: //消防监测终端设备
            	var pnode = treeTab.tree('getParent', node.target);
            	$("#selectedParentid").val(pnode.gid);
                var ppnode = treeTab.tree('getParent', pnode.target);
                $("#selectedUnitid").val(ppnode.gid);
            	break;
            }
		}
		else{
	        $("#selectedParentid").val(0);
	        $("#selectedUnitid").val(0);
		}

		setFirstPage($("#setDg"));
		$('#setDg').datagrid({
			url :'${pageContext.request.contextPath}/fileManage/equipmentfileInf?Math.random()',
			queryParams: {
				id : node.gid,
				type : node.type,
				nodeName : node.name,
			 	parentid : $("#selectedParentid").val(),
			 	downstatus:"0",
			 	communicationstatus:"1"
			},
			pagination : true,//分页控件
			pageList: [10, 20, 30, 40, 50],
			fit: true,   //自适应大小
			singleSelect: false,
			//iconCls : 'icon-save',
			border:false,
			nowrap: true,//数据长度超出列宽时将会自动截取。
			rownumbers:true,//行号
			fitColumns:true,//自动使列适应表格宽度以防止出现水平滚动。
			toolbar : "#settool",
			columns: [[
   					{title: 'ID', field: 'equipmentid', width:'100px',checkbox:true},
			        {title: '操作类型', field: 'status', width:'70px',        	
			        	formatter : function(value, rowData, rowIndex) {
			        		if(value==1){
								return "增加";
		            		}else if(value==2){
		            			return "删除";
		            		}else{
		            			return value;
		            		}
						}	
			        },
			        {title: '设备名称', field: 'equipmentname', width:'160px'}, 
					{title: '设备类型', field: 'equipmenttypename', width:'140px'},
					{title: '设备地址', field: 'equipmentaddress',width:'140px'},
					{title: '设备说明', field: 'equipmentnote',width:'150px'},
					{title: '系统类型', field: 'systemtypename', width:'160px'}, 
			        {title: '系统地址', field: 'systemaddress', width:'100px'}
		        ]]
		});

		$('#dg').datagrid({
			url :'${pageContext.request.contextPath}/fileManage/searchEquipmentfile?Math.random()',
			queryParams: {
				id : node.gid,
				type : node.type,
				nodeName : node.name,
			 	parentid : $("#selectedParentid").val(),
			 	downstatus:"1",
			 	devicestatus:"1",
			 	communicationstatus:"1"
			},
			sortName: 'systemtypename,equipmentname',
		    sortOrder: 'asc,asc',
		    remoteSort: false,//定义是否通过远程服务器对数据排序。(默认为true) 一定改为false
			fit: true,   //自适应大小
			singleSelect: false,
			//iconCls : 'icon-save',
			border:false,
			nowrap: true,//数据长度超出列宽时将会自动截取。
			rownumbers:true,//行号
			fitColumns:true,//自动使列适应表格宽度以防止出现水平滚动。
			columns:  [[
						{title: '系统类型', field: 'systemtypename', width:'160px',sortable:true}, 
				        {title: '系统地址', field: 'systemaddress', width:'70px'},
						{title: '设备名称', field: 'equipmentname', width:'160px',sortable:true}, 
						{title: '设备类型', field: 'equipmenttypename', width:'140px'},
						{title: '设备地址', field: 'equipmentaddress',width:'125px'},
						{title: '设备说明', field: 'equipmentnote',width:'150px'}
			        ]]
		});
	}
    
    function dateformatter(date){
        var y = date.getFullYear();
        var m = date.getMonth()+1;
        var d = date.getDate();
        return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
    }
    
    //档案清零
    function clearAll(){
        if (node.type != commonTreeNodeType.terminal && $("#selectedUnitid").val()!=0) {
        	$.messager.alert("提示", "请选择终端！", "warning");
            return;
        }
        
    	if (ws) {
            if (ws.readyState == 1) {
            	$.ajax({
					type: 'POST',
					url: '${pageContext.request.contextPath}/fileManage/clearData',
					data: {"unitid": $.trim($("#selectedUnitid").val())},
					success: function(d) {
		                if (d.indexOf("html") > 0) { //session超时
		                    //parent.window.location.reload();
		                    $.messager.alert('警告',"获取档案初始化的XML失败。",'error');
		                }
		                else {
		                    frameNumber++;
		                    //组帧，Global.js中定义
		                    var frame = makeWSFrame(frameNumber, 0, 1, 1, d, '');
		                    ws.send(frame);
		                    //加载层
		                    if ($("body").find(".datagrid-mask").length == 0) {
                                //添加等待提示
                                $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 1000, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
                                $("<div class=\"datagrid-mask-msg\"></div>").html("档案清零中，请稍候...").appendTo("body").css({ display: "block", zIndex: 1001, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
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
    
    //下发档案
    function issued(){
    	/* var selectedID = $.trim($("#selectedID").val());
        if (selectedID == "") {
        	$.messager.alert("提示", "请选择节点！", "warning");
            return;
        } */
        
    	//勾选的数据
		var selRow = $("#setDg").datagrid('getSelections');
        if (selRow.length == 0) {
       		$.messager.alert('提示','请勾选设备档案！','warning');
            return;
        }

        if (ws) {
            if (ws.readyState == 1) { 
            	
                var id = [];
                for (var i = 0; i < selRow.length; i++) {
               	 if(selRow[i].downstatus==0 && selRow[i].communicationstatus==1){//删除状态的设备不让删除
           	     	id.push(selRow[i].equipmentid); //把单个id循环放到ids的数组中  
               	 }
                }
                if(id.length==0){
               	 $.messager.alert('提示','选择的设备不可全为不可通讯或已下发的数据','warning');
               	 return false;
                }

                $.messager.confirm('提示', '确认下发?', function(r) {
                    if (r) {
                        $.ajax({
	                       	type:'POST', 
	           		        url:'${pageContext.request.contextPath}/fileManage/issued',  
                            data : {
                               "id[]" : id
                            },
                            success:function(d){ 
                            	dealSetXml(d);
	           		        },	        
	           		        error:function(d){
	           		        	$.messager.alert('警告',d,'error');
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
    
    function allIssued(){
        if (null == node || typeof node=='undefined' ) {
        	$.messager.alert("提示", "请选择节点！", "warning");
            return;
        }
        
        var data = $("#setDg").datagrid('getData');
        if (data.total == 0) {
       		$.messager.alert('提示','该节点下无未下发的设备档案，请重新选择！','warning');
            return;
        }

        $.messager.confirm('提示', '请确认，下发"'+$("#snode").textbox('getValue')+'"下的所有档案？', function(r) {
            if (r) {
                $.ajax({
    	           	type:'POST', 
    			    url:'${pageContext.request.contextPath}/fileManage/allIssued',  
    	            data : {
    	            	id : node.gid,
    					type : node.type,
    					nodeName : node.name,
    	       			parentid : $("#selectedParentid").val(),
    				 	downstatus:"0",
    				 	communicationstatus:"1"
    	            },
    	            success:function(d){ 
    	            	dealSetXml(d);
       		        },	        
       		        error:function(d){
       		        	$.messager.alert('警告',d,'error');
       			        	
       		        }
                });
            }
        });
    }

    //处理下发档案XML
    function dealSetXml(d){
    	if (d != "" && d.indexOf("html") == -1) {
			//parent.window.location.reload();
			var a = JSON.parse(d);
			if(a.length>0){
				$.messager.progress({
                   title: '档案下发中，请稍候...',
                   interval: 0
                });
                progressBar = $.messager.progress('bar');
                sendXmlCount = a.length;
               
				for(var p in a){
					frameNumber++;
	                   //组帧，Global.js中定义
	                   var frame = makeWSFrame(frameNumber, 0, 1, 1, a[p], '');
	                   ws.send(frame);
				}  
			}else{
				$.messager.alert('提示',"返回的XML为空，没有未下发的档案！",'info');
			} 
    	}else{
			$.messager.alert('警告',"获取下发所有档案的XML失败。",'error');
		}
    }
    
  //查询档案
  var resultcount=0;
  var searchfalg=false;
  function searchDevice(){  
    	if ($("#selectedUnitid").val()=="0" || $("#selectedUnitid").val()=="") {
        	$.messager.alert("提示", "请选择终端！", "warning");
            return;
        }

        var stardNum=$.trim($("#stardNum").val());
        if (stardNum == "") {
        	$.messager.alert("提示", "请输入起始序号。", "warning");
            return;
        }
        
        var count=$.trim($("#count").val());
        if (count == "") {
        	$.messager.alert("提示", "请输入读取个数。", "warning");
            return;
        }
        
        /* var options = $("#dg").datagrid('getPager').data("pagination").options;  
        var totalRowNum = options.total;
        if(count>totalRowNum){
        	$("#count").val(totalRowNum);
        	$.messager.alert("提示", "读取个数不能大于实际总设备数。", "warning");
            return;
        } */
        
        if (ws) {
            if (ws.readyState == 1) {
            	$.ajax({
					type: 'POST',
					url: '${pageContext.request.contextPath}/fileManage/searchFile',
					data: {
						"id" : node.gid,
						"type" : node.type,
						"unitid": $.trim($("#selectedUnitid").val()),
						"stardNum":stardNum,
						"count":count
					},
					success: function(d) {
						if (d != "" && d.indexOf("html") == -1) {
							//parent.window.location.reload();
							var a = JSON.parse(d);
							if(a.length>0){
								$('#dg').datagrid('reload');	// reload the user data
								equipmentids=[];
								resultlist = [];
								
								$.messager.progress({
	                                title: '档案查询中，请稍候...',
	                                interval: 0
	                            });
	                            progressBar = $.messager.progress('bar');
	                            sendXmlCount = a.length;
	                            
	                            resultcount=0;
	                            searchfalg=true;
	                            
								for(var p in a){
									frameNumber++;
		                            //组帧，Global.js中定义
		                            var frame = makeWSFrame(frameNumber, 0, 1, 1, a[p], '');
		                            ws.send(frame);
								} 
							}else{
								$.messager.alert('提示',"返回的XML为空！",'info');
							}
						}else{
							$.messager.alert('警告',"获取查询设备档案的XML失败。",'error');
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
    
    //清空返回结果
    function clearResult(){
    	$("#resultPanel").html("");
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
        //帧类型为3（握手），表示端口号
        if (frame.type == '3') {
            port = frame.data;
        }
        else if (frame.type == '2') {  //帧类型为2（应答）
        	
        	if (progressBar) { //进度变更
                msgCount++;
                if (msgCount == sendXmlCount || frame.num.substr(1) == frameNumber) { //关闭进度条
                    progressBar.progressbar("setValue", 100);
                    setTimeout(function () {
                        $.messager.progress('close');
                    }, 800);
                    initProgress();
                    searchfalg=false;
                }
                else {
                    var rate = 0;
                    if (sendXmlCount != 0) rate = Math.floor(msgCount / sendXmlCount * 100);
                    progressBar.progressbar("setValue", rate);
                }
            }
        	
            if (frame.data.length.toString() == frame.len) { //判断是否接收到完整的数据帧
            	$.ajax({
					type: 'POST',
					url: '${pageContext.request.contextPath}/fileManage/parseResponse',
					data: {
						"strXML": frame.data
					},
					success: function(d) {
						if(d.typeFlagCode==151){
							$("body").find("div.datagrid-mask-msg").remove();
				            $("body").find("div.datagrid-mask").remove();
						}
						var date=(new Date()).toLocaleString( );//获取当前日期时间
						switch(d.result){
						case 1:
							switch (d.typeFlagCode){
								case 151:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>"+date+"-档案清零成功。</div>");
									break;
								case 207:
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>"+date+"-查询档案成功。</div>");

									equipmentids.push.apply(equipmentids,d.equipmentids);
									resultlist.push.apply(resultlist,d.resultlist);
									break;
								case 129:	
									$("#resultPanel").prepend("<div style='color:green;padding:5px'>"+date+"-下发档案成功。</div>");

									parent.refreshTabData('设备档案',window.top.reload_deviceTab);
									$("#setDg").datagrid('reload');
									break;
							}
							break;
						case 2:
							$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+date+"-终端连接超时。</div>");
							break;
						case 3:
							$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+date+"-终端否认应答。</div>");
							break;
						case 4:
							$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+date+"-终端不在线。</div>");
							break;
						case 8:
							switch (d.typeFlagCode){
								case 151:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+date+"-档案清零失败。</div>");
									break;
								break;
								case 207:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+date+"-查询档案失败。</div>");
									break;
								case 129:
									$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+date+"-下发档案失败。</div>");
									break;
							}
							break;
						default:
							$("#resultPanel").prepend("<div style='color:red;padding:5px'>"+date+"-未知错误。</div>");
							break;
						}
						
						if(!searchfalg){
	                    	$('#dg').datagrid({
	    						rowStyler:function(index,row){
	    							if($.inArray(row.equipmentid, equipmentids)==-1)
	    								return 'color:red;';
	    							else
	    								return 'color:green;';
	    						}
	    					});
    						$("#existdg").datagrid("loadData",{ "total":resultlist.length,rows:resultlist });	
	                    }
					}
				});
            }
        }
    }

    function WSonClose(e) {
        try {
        	initProgress(); //初始化进度条
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

