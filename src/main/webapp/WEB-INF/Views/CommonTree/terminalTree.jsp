<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
	
<style type="text/css">
	.searchable-select {
		width: 182px;
	}
	.searchable-select-holder, .searchable-select-item, .searchable-select-item .selected{
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}
	#left-table span.textbox.combo{
		height: 28px !important;
		border-right: 0px;
	}
</style>

<table id="left-table" border="0" cellspacing="0" cellpadding="0" style="width:100%;height:100%;">
	<tr>
		<td style="width:96px;text-align:right;padding-left: 1px;padding-top: 1px;">
			<select class="easyui-combobox" id="searchType" style="width:95px;height:32px;">				
				<option id="" value="region">行政区域</option>
				<option id="" value="org" selected="selected">组织结构</option>
			</select>
		</td>
		<td style="padding-top: 1px;">
			
			<div id="region_node">
            	<select id="region_list"></select>
            </div>
            <div id="org_node">
            	<select id="org_list"></select>
            </div>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<div id="left-tree">
				<div id="tree_tab" class="easyui-tabs" fit="true" data-options="border:false">
			        <div id="region_tab" title="行政区域">
						<ul id="region_tree"></ul>
			        </div>
			        <div id="org_tab" title="组织机构">
						<ul id="org_tree"></ul>
			        </div>
				</div>
			</div>
		</td>
	</tr>
</table>

<script type="text/javascript">  
	var treeObj = $('#region_tree');
	$(function(){
		$.ajax({
		   	url: basePath + '/admin/treeNode?Math.random()',
		   	data: {type: 1},
		   	type:"post",
		   	success:function(d){
		   		$("#org_node").show();
			   	$("#region_node").hide();

		   		listParse(d.regionlist, $('#region_list'));
		   		listParse(d.orglist, $('#org_list'));
		   		
		   		$("#left-table").show();
		   	}
		});

		setTimeout(function(){ 
			$('#region_tree').tree({
			    url: basePath + '/admin/terminalTree?Math.random()',
			    queryParams: { treetype: '3'},
			    lines: true,
			    onClick: function (n) {
			    	treeClick(treeObj, n);
			    }
			});
		}, 500);//延迟0.5秒
		
		setTimeout(function(){ 
			$('#org_tree').tree({
			    url: basePath + '/admin/terminalTree?Math.random()',
			    queryParams: { treetype: '1'},
			    lines: true,
			    onClick: function (n) {
			    	treeClick(treeObj, n);
			    }
			});
		}, 2000);//延迟2秒

		$("#left-table").hide();
		
		$('#tree_tab').tabs({
              onSelect:function(title,index){
              	if(index==0)
              		treeObj = $('#region_tree');
              	else
              		treeObj = $('#org_tree');
              }
        });
             
		$('#region_list').on('change',function(){
			listChange($('#region_list'), $('#region_node .searchable-select-dropdown'),0);
	   	});
	   	
	   	$('#org_list').on('change',function(){
			listChange($('#org_list'), $('#org_node .searchable-select-dropdown'),1);
	   	});

	   	$("#searchType").combobox({
			onChange: function (n,o) {
				changeSearchType(n);
			}
		});
	});
	
	function listParse(list, obj){
		if(typeof list !='undefined' && list.length>0){
   			var options = "<option value=''>所有</option>";
   			for(var i=0;i<list.length;i++){
   				var temp = list[i];
   		   		options += "<option value='" + temp.id + "'>"+temp.text+"</option>";
   			}
   			$(obj).html(options);
   		}
   		$(obj).searchableSelect();
	}
	
	function listChange(obj, down, index){
		var value = $(obj).val()
    	if(null!=value && value!=""){
    		if(index<2)
    			$('#tree_tab').tabs("select",index);
    		
    		var n = $(treeObj).tree('find', value);//选中值
			$(treeObj).tree('select', n.target);//调用选中事件

    		expandParent(n);
    		$(treeObj).tree("scrollTo",n.target);
    		
    		treeClick(treeObj, n);
    	}

    	$(down).addClass("searchable-select-hide");
	}
	
	function changeSearchType(n){
		$("#org_node").hide();
		$("#region_node").hide();
		switch(n){
			case "org":
				$("#org_node").show();
				break;
			case "region":
				$("#region_node").show();
				break;
		}
	}

	function expandParent(node){  
	    var parentNode = treeObj.tree("getParent", node.target);  
	    if(parentNode != null && parentNode != "undefined"){  
	        treeObj.tree("expand", parentNode.target);  
	        expandParent(parentNode);  
	    }  
	} 
</script>