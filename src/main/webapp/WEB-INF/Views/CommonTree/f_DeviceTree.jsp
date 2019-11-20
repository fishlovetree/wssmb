<%@ page pageEncoding="utf-8"%>
	
<style type="text/css">
	.searchable-select {
		width: 171px;
	}
	.searchable-select-holder, .searchable-select-item, .searchable-select-item .selected{
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}
</style>

<table id="left-table" border="0" cellspacing="0" cellpadding="0" style="width:100%;height:100%;">
	<tr>
		<td style="width:96px;text-align:right;padding-left: 1px;">
			<select class="easyui-combobox" id="searchType" style="width:95px;height:32px;">
				<option id="" value="device" >设备</option>
				<option id="" value="unit" >终端</option>
				<option id="" value="customer" selected="selected">用户名称</option>
				<option id="" value="region">区域</option>
			</select>
		</td>
		<td>
			<div id="device_node">
               	<select id="device_list"></select>
               </div>
               <div id="unit_node">
               	<select id="unit_list"></select>
               </div>
               <div id="customer_node">
               	<select id="customer_list"></select>
               </div>
               <div id="region_node">
               	<select id="region_list"></select>
               </div>
		</td>
   	</tr>
   	<tr>
		<td colspan="2">
			<div id="left-tree" style="overflow: auto;">
				<ul id="region_tree" style="width:100%;"></ul>
			</div>
		</td>
   	</tr>
</table>

<script type="text/javascript">  
	$(function(){
		$("#left-table").hide();
		
		$.ajax({
		   	url: basePath + '/treeNode?Math.random()',
		   	data: {type: 3, systemtype: '', showGprs: true, showLora: true,
			   	       showNB: true, showTransmission: true},
		   	type:"post",
		   	success:function(d){
		   		$("#region_node").hide();
				$("#customer_node").show();
				$("#unit_node").hide();
				$("#device_node").hide();
		
		   		listParse(d.customerlist, $('#customer_list'));
		   		listParse(d.regionlist, $('#region_list'));
		   		listParse(d.unitlist, $('#unit_list'));
		   		listParse(d.devicelist, $('#device_list'));
	   		
	   			$("#left-table").show();
		   	}
		});
		
		$('#region_tree').tree({
		    url: basePath + '/deviceTree?Math.random()',
		    queryParams: { treetype: '3', systemtype: '', showGprs: true, showLora: true, 
		    			   showNB: true, showTransmission: true },
		    lines: true,
		    onClick: function (n) {
		    	treeClick(n);
		    }
		});
		
		$('#region_list').on('change',function(){
			listChange($('#region_list'), $('#region_node .searchable-select-dropdown'));
	   	});
		
		$('#customer_list').on('change',function(){
			listChange($('#customer_list'), $('#customer_node .searchable-select-dropdown'));
	   	});
	   	
	   	$('#unit_list').on('change',function(){
	   		listChange($('#unit_list'), $('#unit_node .searchable-select-dropdown'));
	   	});
	   	
	   	$('#device_list').on('change',function(){
	   		listChange($('#device_list'), $('#device_node .searchable-select-dropdown'));
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

	function listChange(obj, down){
		var value = $(obj).val()
 	    if(null!=value && value!=""){
 	    	var n = $('#region_tree').tree('find', value);//选中值
			$('#region_tree').tree('select', n.target);//调用选中事件
	
	   		expandParent($('#region_tree'),n);
	   		$('#region_tree').tree("scrollTo",n.target);
	   		
	   		treeClick(n);
 	    }
 	    else{
 	    	$('#region_tree').scrollTop(0);
 	    }
 	    	
 	    $(down).addClass("searchable-select-hide");
	}
	
	function changeSearchType(n){
		$("#region_node").hide();
		$("#customer_node").hide();
		$("#unit_node").hide();
		$("#device_node").hide();
		switch(n){
			case "region":
				$("#region_node").show();
				break;
			case "customer":
				$("#customer_node").show();
				break;
			case "unit":
				$("#unit_node").show();
				break;
			case "device":
				$("#device_node").show();
				break;
		}
	}

	function expandParent(treeObj, node){  
	    var parentNode = treeObj.tree("getParent", node.target);  
	    if(parentNode != null && parentNode != "undefined"){  
	        treeObj.tree("expand", parentNode.target);  
	        expandParent(treeObj, parentNode);  
	    }  
	} 
</script>