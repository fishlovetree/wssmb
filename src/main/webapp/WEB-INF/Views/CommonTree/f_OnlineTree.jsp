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
			<option id="" value="ammeter">电表</option>
				<option id="" value="terminal" >终端</option>
				<option id="" value="concentrator" >集中器</option>
				<option id="" value="measure" selected="selected">表箱</option>
				<option id="" value="region">区域</option>
			</select>
		</td>
		<td>
		<div id="ammeter_node">
               	<select id="ammeter_list"></select>
               </div>
			<div id="terminal_node">
               	<select id="terminal_list"></select>
               </div>
               <div id="concentrator_node">
               	<select id="concentrator_list"></select>
               </div>
               <div id="measure_node">
               	<select id="measure_list"></select>
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
		   	data: {type: 3},
		   	type:"post",
		   	success:function(d){
		   		$("#region_node").hide();
				$("#measure_node").show();
				$("#concentrator_node").hide();
				$("#terminal_node").hide();
				$("#ammeter_node").hide();
		
				listParse(d.ammeterList, $('#ammeter_list'));
		   		listParse(d.measurelist, $('#measure_list'));
		   		listParse(d.regionlist, $('#region_list'));
		   		listParse(d.concentratorlist, $('#concentrator_list'));
		   		listParse(d.terminallist, $('#terminal_list'));
	   		
	   			$("#left-table").show();
		   	}
		});
		
		$('#region_tree').tree({
		    url: basePath + '/deviceTree?Math.random()',
		    queryParams: { treetype: '2'},
		    lines: true,
		    onClick: function (n) {
		    	treeClick(n);
		    }
		});
		
		$('#region_list').on('change',function(){
			listChange($('#region_list'), $('#region_node .searchable-select-dropdown'));
	   	});
		
		$('#measure_list').on('change',function(){
			listChange($('#measure_list'), $('#measure_node .searchable-select-dropdown'));
	   	});
	   	
	   	$('#concentrator_list').on('change',function(){
	   		listChange($('#concentrator_list'), $('#concentrator_node .searchable-select-dropdown'));
	   	});
	   	
	   	$('#terminal_list').on('change',function(){
	   		listChange($('#terminal_list'), $('#terminal_node .searchable-select-dropdown'));
	   	});
	   	
		$('#ammeter_list').on('change',function(){
	   		listChange($('#ammeter_list'), $('#ammeter_node .searchable-select-dropdown'));
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
		$("#measure_node").hide();
		$("#concentrator_node").hide();
		$("#terminal_node").hide();
		$("#ammeter_node").hide();
		switch(n){
			case "region":
				$("#region_node").show();
				break;
			case "measure":
				$("#measure_node").show();
				break;
			case "concentrator":
				$("#concentrator_node").show();
				break;
			case "terminal":
				$("#terminal_node").show();
				break;
			case "ammeter":
				$("#ammeter_node").show();
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