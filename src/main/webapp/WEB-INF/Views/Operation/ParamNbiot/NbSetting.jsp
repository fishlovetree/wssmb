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
<title>NB参数设置</title>
<jsp:include page="../../Header.jsp"/>
<style type="text/css">
    .left-td{
        width: 75px;
    }
</style>
</head>
<body>
    <div class="easyui-layout" fit="true">
		<div id="west" region="west" iconCls="icon-organization" split="true" title="设备" style="width:284px;min-width:284px;" collapsible="true">
			<jsp:include page="../../CommonTree/nb_DeviceTree.jsp"/>
		</div>
		<div id="mainPanel" region="center" style="overflow-y:hidden">
            <table border="0" cellspacing="8" cellpadding="8">
                      <tr>
                          <td class="tableHead_right" align="right">
                                                                             设备：
                          </td>
                          <td>
                              <input type="text" id='snode' class="easyui-textbox" readonly="readonly" style="width:200px;" />
                              <input type="hidden" id="selectedID" />
                              <input type="hidden" id="selectedType" />
                              <input type="hidden" id="selectedAddress" />
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
                                <input type="text" class="easyui-textbox" id="apnTxt" name="apn" data-options="validType:'maxlength[48]'"/>
                            </td>
                        </tr>
                        <tr>
                            <td class="left-td">
                                                                           备站IP:
                            </td>
                            <td>
                                <input type="text" class="easyui-textbox" id="backupIpTxt" name="backupip" data-options="validType:'ip'"/>
                            </td>
                            <td class="left-td">
                                                                           备站端口:
                            </td>
                            <td>
                                <input type="text" class="easyui-numberbox" id="backupPortTxt" name="backupport" data-options="min:0,max:65535"/>
                            </td>
                        </tr>
                        <tr>
                            <td class="left-td">
                            </td>
                            <td>
                                <a href="javascript:void(0)" class="easyui-linkbutton" onclick="setIp()" title="设置">设置</a>
                            </td>
                        </tr>
                    </table>
                    </form>
            	</div>
		    </div>
		</div>
 </div>
<script type="text/javascript">
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
		resizeDiv();
    	
    	$("#west").panel({
            onResize: function (w, h) {
            	resizeDiv();
            }
        });
    	
    	$(window).resize(function(){ //浏览器窗口变化 
    		resizeDiv();
    	});
    })
    
    var treeTab = $('#region_tree');
	//公用树点击事件
	var node;
	function treeClick(treeObj, n){
		if(typeof n!='undefined' ){
			node=n;
			treeTab = treeObj;
			if (node.type == commonTreeNodeType.nbDevice){
        		$("#snode").textbox('setValue', node.text);
                $("#selectedID").val(node.gid);
                $("#selectedType").val(node.type);
                $("#selectedAddress").val(node.name);
        	}
        	else{
        		$("#snode").textbox('setValue', "");
                $("#selectedID").val("");
                $("#selectedType").val("");
                $("#selectedAddress").val("");
        	}
		}
	}
    
    //设置主站IP
    function setIp(){
    	var selectedID = $.trim($("#selectedID").val());
    	var selectedType = $.trim($("#selectedType").val());
        if (selectedID == "") {
        	$.messager.alert("提示", "请选择设备。", "warning");
            return;
        }
       	if ($('#ipForm').form('validate')){
       		$.ajax({
				type: 'POST',
				url: "${pageContext.request.contextPath}/paramNbiot/setIp",
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
					if (d != "") {
                        if (d.indexOf("html") > 0) { //session超时
                            parent.window.location.reload();
                        }
                        else {
                        	if (d == "success"){
                        		$.messager.alert("提示", "已成功插入到命令列表中。", "info");
                        	}
                        	else if (d == "failure"){
                        		$.messager.alert("提示", "请先配置设备协议类型。", "warning");
                        	}
                        	else{
                        		$.messager.alert("警告", "插入命令列表失败，清重试。", "error");
                        	}
                        }
					}
				}
			});
       	}
    }
</script>
</body>
</html>

