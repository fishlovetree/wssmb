<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>通用树配置</title>
<jsp:include page="../Header.jsp"/>
<script type="text/javascript">
    $(function(){
    	$('#organizationUl').tree({
            url: '${pageContext.request.contextPath}/commonTree/organizationTreeJson',
            lines: true,
            checkbox: true,
            cascadeCheck: false,
            onCheck: function(node, checked){
            	if (checked){
            		$('#organizationUl').tree('collapse', node.target);
            	}
            	else{
            		$('#organizationUl').tree('expand', node.target);
            	}
            },
            onExpand: function(node){
            	var targetNode = $('#organizationUl').tree('getNode', node.target);
            	if (targetNode.checked){
            		$('#organizationUl').tree('uncheck', node.target);
            	}
            },
            onCollapse: function(node){
            	var targetNode = $('#organizationUl').tree('getNode', node.target);
            	if (!targetNode.checked){
            		$('#organizationUl').tree('check', node.target);
            	}
            }
        });
    	
    	$('#regionUl').tree({
            url: '${pageContext.request.contextPath}/commonTree/regionTreeJson',
            lines: true,
            checkbox: true,
            cascadeCheck: false,
            onCheck: function(node, checked){
            	if (checked){
            		$('#regionUl').tree('collapse', node.target);
            	}
            	else{
            		$('#regionUl').tree('expand', node.target);
            	}
            },
            onExpand: function(node){
            	var targetNode = $('#regionUl').tree('getNode', node.target);
            	if (targetNode.checked){
            		$('#regionUl').tree('uncheck', node.target);
            	}
            },
            onCollapse: function(node){
            	var targetNode = $('#regionUl').tree('getNode', node.target);
            	if (!targetNode.checked){
            		$('#regionUl').tree('check', node.target);
            	}
            }
        });
    	
    	$('#buildingUl').tree({
            url: '${pageContext.request.contextPath}/commonTree/buildingTreeJson',
            lines: true,
            checkbox: true,
            cascadeCheck: false,
            onCheck: function(node, checked){
            	if (checked){
            		$('#buildingUl').tree('collapse', node.target);
            	}
            	else{
            		$('#buildingUl').tree('expand', node.target);
            	}
            },
            onExpand: function(node){
            	var targetNode = $('#buildingUl').tree('getNode', node.target);
            	if (targetNode.checked){
            		$('#buildingUl').tree('uncheck', node.target);
            	}
            },
            onCollapse: function(node){
            	var targetNode = $('#buildingUl').tree('getNode', node.target);
            	if (!targetNode.checked){
            		$('#buildingUl').tree('check', node.target);
            	}
            }
        });
    })
    
    function save(){
    	var data = [];//JSON只能接受数组加对象的格式，例如[{},{}]
    	var orgNodes = $('#organizationUl').tree('getChecked');
    	if (orgNodes){
    		$.each(orgNodes, function(i, n){
    			data.push({'nodeid': n.id, 'treetype': 1});
    		})
    	}
    	var regionNodes = $('#regionUl').tree('getChecked');
    	if (regionNodes){
    		$.each(regionNodes, function(i, n){
    			data.push({'nodeid': n.id, 'treetype': 2});
    		})
    	}
    	var buildingNodes = $('#buildingUl').tree('getChecked');
    	if (buildingNodes){
    		$.each(buildingNodes, function(i, n){
    			data.push({'nodeid': n.id, 'treetype': 3});
    		})
    	}
    	$.ajax({
            url:'${pageContext.request.contextPath}/commonTree/saveSettingNodes',
            type:'post',
            data:{
                json:JSON.stringify(data)
            },
            cache:false,
            success:function(msg){
                if (msg == "success"){
                	$.messager.alert('提示', '树节点收起配置成功。', 'info');
                }
                else{
                	$.messager.alert('警告', '抱歉，出错了，请重试。', 'error');
                }
            }
        });
    }
</script>
</head>
<body>
    <div class="easyui-layout" fit="true">
	    <div region="center">
			<div class="easyui-tabs" id="tab" fit="true"
				data-options="tabPosition:'top'">
				<div title="组织机构树">
					<ul id="organizationUl">
					</ul>
				</div>
				<div title="行政区域树">
					<ul id="regionUl">
					</ul>
				</div>
				<div title="建筑树">
					<ul id="buildingUl">
					</ul>
				</div>
			</div>
		</div>
		<div region="south" style="height:50px;">
		    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save()" style="margin:10px;">保存</a>
		    <span>（注：在树上勾选需要收起的节点）</span>
		</div>
	</div>
</body>
</html>