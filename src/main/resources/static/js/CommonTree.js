function codeCommentRemove(f) {　
    return f.toString().replace(/^[^\/]+\/\*!?\s?/, '').replace(/\*\/[^\/]+$/, '');
}

//前端使用树
var front_CustomerTree = codeCommentRemove(function () {
	/*
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
					<option id="" value="customer" selected="selected">用户名称</option>
					<option id="" value="region">区域</option>
				</select>
			</td>
			<td>
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
			   	data: {type: 1},
			   	type:"post",
			   	success:function(d){
					$("#region_node").hide();
					$("#customer_node").show();
					
			   		listParse(d.customerlist, $('#customer_list'));
			   		listParse(d.regionlist, $('#region_list'));
			   		
			   		$("#left-table").show();
			   	}
			});
			
			$('#region_tree').tree({
			    url: basePath + '/customerTree?Math.random()',
			    queryParams: { treetype: '3'},
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
   	    	
   	    	$(down).addClass("searchable-select-hide");
		}
		
		function changeSearchType(n){
			$("#region_node").hide();
			$("#customer_node").hide();
			switch(n){
				case "region":
					$("#region_node").show();
					break;
				case "customer":
					$("#customer_node").show();
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
*/
});

var front_DeviceTree = codeCommentRemove(function () {
    /*
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
    */
});

var front_BuildingTree = codeCommentRemove(function () {
    /*
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
					<option id="" value="building" >建筑</option>
					<option id="" value="customer" selected="selected">用户名称</option>
					<option id="" value="region">区域</option>
				</select>
			</td>
			<td>
				<div id="building_node">
                	<select id="building_list"></select>
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
			   	data: {type: 4},
			   	type:"post",
			   	success:function(d){
			   		$("#region_node").hide();
					$("#customer_node").show();
					$("#building_node").hide();
			
			   		listParse(d.customerlist, $('#customer_list'));
			   		listParse(d.regionlist, $('#region_list'));
			   		listParse(d.buildinglist, $('#building_list'));
		   		
		   			$("#left-table").show();
			   	}
			});

			$('#region_tree').tree({
			    url: basePath + '/buildingTree?Math.random()',
			    queryParams: { treetype: '3' },
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
		   	
		   	$('#building_list').on('change',function(){
		   		listChange($('#building_list'), $('#building_node .searchable-select-dropdown'));
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
   	    	
   	    	$(down).addClass("searchable-select-hide");
		}
		
		function changeSearchType(n){
			$("#region_node").hide();
			$("#customer_node").hide();
			$("#building_node").hide();
			switch(n){
				case "region":
					$("#region_node").show();
					break;
				case "customer":
					$("#customer_node").show();
					break;
				case "building":
					$("#building_node").show();
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
    */
});

var front_VideoTree = codeCommentRemove(function () {
    /*
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
					<option id="" value="video" >摄像头</option>
					<option id="" value="building" >建筑</option>
					<option id="" value="customer" selected="selected">用户名称</option>
					<option id="" value="region">区域</option>
				</select>
			</td>
			<td>
				<div id="video_node">
                	<select id="video_list"></select>
                </div>
                <div id="building_node">
                	<select id="building_list"></select>
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
			   	data: {type: 5},
			   	type:"post",
			   	success:function(d){
			   		$("#region_node").hide();
					$("#customer_node").show();
					$("#building_node").hide();
					$("#video_node").hide();
			
			   		listParse(d.customerlist, $('#customer_list'));
			   		listParse(d.regionlist, $('#region_list'));
			   		listParse(d.buildinglist, $('#building_list'));
			   		listParse(d.videolist, $('#video_list'));
		   		
		   			$("#left-table").show();
			   	}
			});
			
			$('#region_tree').tree({
			    url: basePath + '/videoTree?Math.random()',
			    queryParams: { treetype: '3' },
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
		   	
		   	$('#building_list').on('change',function(){
		   		listChange($('#building_list'), $('#building_node .searchable-select-dropdown'));
		   	});
		   	
		   	$('#video_list').on('change',function(){
		   		listChange($('#video_list'), $('#video_node .searchable-select-dropdown'));
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
   	    	
   	    	$(down).addClass("searchable-select-hide");
		}
		
		function changeSearchType(n){
			$("#region_node").hide();
			$("#customer_node").hide();
			$("#building_node").hide();
			$("#video_node").hide();
			switch(n){
				case "region":
					$("#region_node").show();
					break;
				case "customer":
					$("#customer_node").show();
					break;
				case "building":
					$("#building_node").show();
					break;
				case "video":
					$("#video_node").show();
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
    */
});
//前端使用树

//后端使用树
var customerTree = codeCommentRemove(function () {
	/*
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
					<option id="" value="customer" selected="selected">用户名称</option>
					<option id="" value="region">区域</option>
					<option id="" value="org">组织结构</option>
				</select>
			</td>
			<td style="padding-top: 1px;">
				<div id="customer_node">
                	<select id="customer_list"></select>
                </div>
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
			   		$("#org_node").hide();
				   	$("#region_node").hide();
					$("#customer_node").show();
					
			   		listParse(d.customerlist, $('#customer_list'));
			   		listParse(d.regionlist, $('#region_list'));
			   		listParse(d.orglist, $('#org_list'));
			   		
			   		$("#left-table").show();
			   	}
			});

			setTimeout(function(){ 
				$('#region_tree').tree({
				    url: basePath + '/admin/customerTree?Math.random()',
				    queryParams: { treetype: '3'},
				    lines: true,
				    onClick: function (n) {
				    	treeClick(treeObj, n);
				    }
				});
			}, 500);//延迟0.5秒
			
			setTimeout(function(){ 
				$('#org_tree').tree({
				    url: basePath + '/admin/customerTree?Math.random()',
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
            
            $('#customer_list').on('change',function(){
				listChange($('#customer_list'), $('#customer_node .searchable-select-dropdown'),2);
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
			$("#customer_node").hide();
			switch(n){
				case "org":
					$("#org_node").show();
					break;
				case "region":
					$("#region_node").show();
					break;
				case "customer":
					$("#customer_node").show();
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
*/
});

var unitTree = codeCommentRemove(function () {
	/*
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
					<option id="" value="unit" >终端</option>
					<option id="" value="customer" selected="selected">用户名称</option>
					<option id="" value="region">区域</option>
					<option id="" value="org">组织结构</option>
				</select>
			</td>
			<td style="padding-top: 1px;">
				<div id="unit_node">
                	<select id="unit_list"></select>
                </div>
                <div id="customer_node">
                	<select id="customer_list"></select>
                </div>
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
			   	data: {type: 2, systemtype: '', showGprs: true, showLora: true,
			   	       showNB: true, showTransmission: true},
			   	type:"post",
			   	success:function(d){
			   		$("#org_node").hide();
			   		$("#region_node").hide();
					$("#customer_node").show();
					$("#unit_node").hide();
			   		
			   		listParse(d.customerlist, $('#customer_list'));
			   		listParse(d.regionlist, $('#region_list'));
			   		listParse(d.unitlist, $('#unit_list'));
			   		listParse(d.orglist, $('#org_list'));
			   		
			   		$("#left-table").show();
			   	}
			});
			
			setTimeout(function(){ 
				$('#region_tree').tree({
				    url: basePath + '/admin/unitTree?Math.random()',
				    queryParams: { treetype: '3', showGprs: true, showLora: true, showNB: true, 
				    			   showTransmission: true},
				    lines: true,
				    onClick: function (n) {
				    	treeClick(treeObj, n);
				    }
				});
			}, 500);//延迟0.5秒
			
			setTimeout(function(){ 
				$('#org_tree').tree({
				    url: basePath + '/admin/unitTree?Math.random()',
				    queryParams: { treetype: '1', showGprs: true, showLora: true, showNB: true, 
			    			       showTransmission: true},
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

		   	$('#unit_list').on('change',function(){
		   		listChange($('#unit_list'), $('#unit_node .searchable-select-dropdown'),2);
		   	});
		   	
		   	$('#customer_list').on('change',function(){
				listChange($('#customer_list'), $('#customer_node .searchable-select-dropdown'),2);
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
			$("#region_node").hide();
			$("#customer_node").hide();
			$("#unit_node").hide();
			$("#org_node").hide();
			switch(n){
				case "org":
					$("#org_node").show();
					break;
				case "region":
					$("#region_node").show();
					break;
				case "customer":
					$("#customer_node").show();
					break;
				case "unit":
					$("#unit_node").show();
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
*/
});

var deviceTree = codeCommentRemove(function () {
	/*
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
					<option id="" value="device" >设备</option>
					<option id="" value="unit" >终端</option>
					<option id="" value="customer" selected="selected">用户名称</option>
					<option id="" value="region">区域</option>
					<option id="" value="org">组织结构</option>
				</select>
			</td>
			<td style="padding-top: 1px;">
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
			   	data: {type: 3, systemtype: '', showGprs: true, showLora: true,
			   	       showNB: true, showTransmission: true},
			   	type:"post",
			   	success:function(d){
			   		$("#org_node").hide();
			   		$("#region_node").hide();
					$("#customer_node").show();
					$("#unit_node").hide();
					$("#device_node").hide();

			   		listParse(d.customerlist, $('#customer_list'));
			   		listParse(d.regionlist, $('#region_list'));
			   		listParse(d.unitlist, $('#unit_list'));
			   		listParse(d.devicelist, $('#device_list'));
			   		listParse(d.orglist, $('#org_list'));
		   		
		   			$("#left-table").show();
			   	}
			});
			
			setTimeout(function(){ 
				$('#region_tree').tree({
				    url: basePath + '/admin/deviceTree?Math.random()',
				    queryParams: { treetype: '3', systemtype: '', showGprs: true, showLora: true, 
				    			   showNB: true, showTransmission: true },
				    lines: true,
				    onClick: function (n) {
				    	treeClick(treeObj, n);
				    }
				});
			}, 500);//延迟0.5秒
			
			setTimeout(function(){ 
				$('#org_tree').tree({
				    url: basePath + '/admin/deviceTree?Math.random()',
				    queryParams: { treetype: '1', systemtype: '', showGprs: true, showLora: true, 
			    			       showNB: true, showTransmission: true },
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
		   	
		   	$('#org_list').on('change',function(){
				listChange($('#org_list'), $('#org_node .searchable-select-dropdown'),1);
		   	});

			$('#region_list').on('change',function(){
				listChange($('#region_list'), $('#region_node .searchable-select-dropdown'),0);
		   	});
			
			$('#customer_list').on('change',function(){
				listChange($('#customer_list'), $('#customer_node .searchable-select-dropdown'),2);
		   	});
		   	
		   	$('#unit_list').on('change',function(){
		   		listChange($('#unit_list'), $('#unit_node .searchable-select-dropdown'),2);
		   	});
		   	
		   	$('#device_list').on('change',function(){
		   		listChange($('#device_list'), $('#device_node .searchable-select-dropdown'),2);
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
			$("#customer_node").hide();
			$("#unit_node").hide();
			$("#device_node").hide();
			switch(n){
				case "org":
					$("#org_node").show();
					break;
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
	
		function expandParent(node){  
		    var parentNode = treeObj.tree("getParent", node.target);  
		    if(parentNode != null && parentNode != "undefined"){  
		        treeObj.tree("expand", parentNode.target);  
		        expandParent(parentNode);  
		    }  
		} 
	</script>
	*/
});

var elecDeviceTree = codeCommentRemove(function () {
	/*
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
					<option id="" value="device" >设备</option>
					<option id="" value="unit" >终端</option>
					<option id="" value="customer" selected="selected">用户名称</option>
					<option id="" value="region">区域</option>
					<option id="" value="org">组织结构</option>
				</select>
			</td>
			<td style="padding-top: 1px;">
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
			   	data: {type: 3, systemtype: '10', showGprs: true, showLora: true,
			   	       showNB: false, showTransmission: false},
			   	type:"post",
			   	success:function(d){
			   		$("#org_node").hide();
			   		$("#region_node").hide();
					$("#customer_node").show();
					$("#unit_node").hide();
					$("#device_node").hide();

			   		listParse(d.customerlist, $('#customer_list'));
			   		listParse(d.regionlist, $('#region_list'));
			   		listParse(d.unitlist, $('#unit_list'));
			   		listParse(d.devicelist, $('#device_list'));
			   		listParse(d.orglist, $('#org_list'));
		   		
		   			$("#left-table").show();
			   	}
			});
			
			setTimeout(function(){ 
				$('#region_tree').tree({
				    url: basePath + '/admin/deviceTree?Math.random()',
				    queryParams: { treetype: '3', systemtype: '10', showGprs: true, showLora: true, 
				    			   showNB: false, showTransmission: false },
				    lines: true,
				    onClick: function (n) {
				    	treeClick(treeObj, n);
				    }
				});
			}, 500);//延迟0.5秒
			
			setTimeout(function(){ 
				$('#org_tree').tree({
				    url: basePath + '/admin/deviceTree?Math.random()',
				    queryParams: { treetype: '1', systemtype: '10', showGprs: true, showLora: true, 
			    			       showNB: false, showTransmission: false },
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
		   	
		   	$('#org_list').on('change',function(){
				listChange($('#org_list'), $('#org_node .searchable-select-dropdown'),1);
		   	});

			$('#region_list').on('change',function(){
				listChange($('#region_list'), $('#region_node .searchable-select-dropdown'),0);
		   	});
			
			$('#customer_list').on('change',function(){
				listChange($('#customer_list'), $('#customer_node .searchable-select-dropdown'),2);
		   	});
		   	
		   	$('#unit_list').on('change',function(){
		   		listChange($('#unit_list'), $('#unit_node .searchable-select-dropdown'),2);
		   	});
		   	
		   	$('#device_list').on('change',function(){
		   		listChange($('#device_list'), $('#device_node .searchable-select-dropdown'),2);
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
			$("#customer_node").hide();
			$("#unit_node").hide();
			$("#device_node").hide();
			switch(n){
				case "org":
					$("#org_node").show();
					break;
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
	
		function expandParent(node){  
		    var parentNode = treeObj.tree("getParent", node.target);  
		    if(parentNode != null && parentNode != "undefined"){  
		        treeObj.tree("expand", parentNode.target);  
		        expandParent(parentNode);  
		    }  
		} 
	</script>
	*/
});

var buildingTree = codeCommentRemove(function () {
	/*
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
					<option id="" value="building" >建筑</option>
					<option id="" value="customer" selected="selected">用户名称</option>
					<option id="" value="region">区域</option>
					<option id="" value="org">组织结构</option>
				</select>
			</td>
			<td style="padding-top: 1px;">
				<div id="building_node">
                	<select id="building_list"></select>
                </div>
                <div id="customer_node">
                	<select id="customer_list"></select>
                </div>
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
			   	data: {type: 4},
			   	type:"post",
			   	success:function(d){
			   		$("#org_node").hide();
			   		$("#region_node").hide();
					$("#customer_node").show();
					$("#building_node").hide();

			   		listParse(d.customerlist, $('#customer_list'));
			   		listParse(d.regionlist, $('#region_list'));
			   		listParse(d.buildinglist, $('#building_list'));
			   		listParse(d.orglist, $('#org_list'));
		   		
		   			$("#left-table").show();
			   	}
			});
			
			setTimeout(function(){ 
				$('#region_tree').tree({
				    url: basePath + '/admin/buildingTree?Math.random()',
				    queryParams: { treetype: '3' },
				    lines: true,
				    onClick: function (n) {
				    	treeClick(treeObj, n);
				    }
				});
			}, 500);//延迟0.5秒
			
			setTimeout(function(){ 
				$('#org_tree').tree({
				    url: basePath + '/admin/buildingTree?Math.random()',
				    queryParams: { treetype: '1' },
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
		   	
		   	$('#org_list').on('change',function(){
				listChange($('#org_list'), $('#org_node .searchable-select-dropdown'),1);
		   	});

			$('#region_list').on('change',function(){
				listChange($('#region_list'), $('#region_node .searchable-select-dropdown'),0);
		   	});
			
			$('#customer_list').on('change',function(){
				listChange($('#customer_list'), $('#customer_node .searchable-select-dropdown'),2);
		   	});
		   	
		   	$('#building_list').on('change',function(){
		   		listChange($('#building_list'), $('#building_node .searchable-select-dropdown'),2);
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
			$("#customer_node").hide();
			$("#building_node").hide();
			switch(n){
				case "org":
					$("#org_node").show();
					break;
				case "region":
					$("#region_node").show();
					break;
				case "customer":
					$("#customer_node").show();
					break;
				case "building":
					$("#building_node").show();
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
	*/
});

var videoTree = codeCommentRemove(function () {
	/*
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
					<option id="" value="video" >摄像头</option>
					<option id="" value="building" >建筑</option>
					<option id="" value="customer" selected="selected">用户名称</option>
					<option id="" value="region">区域</option>
					<option id="" value="org">组织结构</option>
				</select>
			</td>
			<td style="padding-top: 1px;">
				<div id="video_node">
                	<select id="video_list"></select>
                </div>
                <div id="building_node">
                	<select id="building_list"></select>
                </div>
                <div id="customer_node">
                	<select id="customer_list"></select>
                </div>
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
			   	data: {type: 5},
			   	type:"post",
			   	success:function(d){
			   		$("#org_node").hide();
			   		$("#region_node").hide();
					$("#customer_node").show();
					$("#building_node").hide();
					$("#video_node").hide();

			   		listParse(d.customerlist, $('#customer_list'));
			   		listParse(d.regionlist, $('#region_list'));
			   		listParse(d.buildinglist, $('#building_list'));
			   		listParse(d.videolist, $('#video_list'));
			   		listParse(d.orglist, $('#org_list'));
		   		
		   			$("#left-table").show();
			   	}
			});
			
			setTimeout(function(){ 
				$('#region_tree').tree({
				    url: basePath + '/admin/videoTree?Math.random()',
				    queryParams: { treetype: '3' },
				    lines: true,
				    onClick: function (n) {
				    	treeClick(treeObj, n);
				    }
				});
			}, 500);//延迟0.5秒
			
			setTimeout(function(){ 
				$('#org_tree').tree({
				    url: basePath + '/admin/videoTree?Math.random()',
				    queryParams: { treetype: '1' },
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
		   	
		   	$('#org_list').on('change',function(){
				listChange($('#org_list'), $('#org_node .searchable-select-dropdown'),1);
		   	});

			$('#region_list').on('change',function(){
				listChange($('#region_list'), $('#region_node .searchable-select-dropdown'),0);
		   	});
			
			$('#customer_list').on('change',function(){
				listChange($('#customer_list'), $('#customer_node .searchable-select-dropdown'),2);
		   	});
		   	
		   	$('#building_list').on('change',function(){
		   		listChange($('#building_list'), $('#building_node .searchable-select-dropdown'),2);
		   	});
		   	
		   	$('#video_list').on('change',function(){
		   		listChange($('#video_list'), $('#video_node .searchable-select-dropdown'),2);
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
			$("#customer_node").hide();
			$("#building_node").hide();
			$("#video_node").hide();
			switch(n){
				case "org":
					$("#org_node").show();
					break;
				case "region":
					$("#region_node").show();
					break;
				case "customer":
					$("#customer_node").show();
					break;
				case "building":
					$("#building_node").show();
					break;
				case "video":
					$("#video_node").show();
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
	*/
});

//NB设备
var nb_DeviceTree = codeCommentRemove(function () {
	/*
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
					<option id="" value="device" >设备</option>
					<option id="" value="unit" >终端</option>
					<option id="" value="customer" selected="selected">用户名称</option>
					<option id="" value="region">区域</option>
					<option id="" value="org">组织结构</option>
				</select>
			</td>
			<td style="padding-top: 1px;">
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
			   	data: {type: 3, systemtype: '', showGprs: false, showLora: false, 
		    			   showNB: true, showTransmission: false},
			   	type:"post",
			   	success:function(d){
			   		$("#org_node").hide();
			   		$("#region_node").hide();
					$("#customer_node").show();
					$("#unit_node").hide();
					$("#device_node").hide();

			   		listParse(d.customerlist, $('#customer_list'));
			   		listParse(d.regionlist, $('#region_list'));
			   		listParse(d.unitlist, $('#unit_list'));
			   		listParse(d.devicelist, $('#device_list'));
			   		listParse(d.orglist, $('#org_list'));
		   		
		   			$("#left-table").show();
			   	}
			});
			
			setTimeout(function(){ 
				$('#region_tree').tree({
				    url: basePath + '/admin/deviceTree?Math.random()',
				    queryParams: { treetype: '3', systemtype: '', showGprs: false, showLora: false, 
				    			   showNB: true, showTransmission: false },
				    lines: true,
				    onClick: function (n) {
				    	treeClick(treeObj, n);
				    }
				});
			}, 500);//延迟0.5秒
			
			setTimeout(function(){ 
				$('#org_tree').tree({
				    url: basePath + '/admin/deviceTree?Math.random()',
				    queryParams: { treetype: '1', systemtype: '', showGprs: false, showLora: false, 
			    			   showNB: true, showTransmission: false },
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
		   	
		   	$('#org_list').on('change',function(){
				listChange($('#org_list'), $('#org_node .searchable-select-dropdown'),1);
		   	});

			$('#region_list').on('change',function(){
				listChange($('#region_list'), $('#region_node .searchable-select-dropdown'),0);
		   	});
			
			$('#customer_list').on('change',function(){
				listChange($('#customer_list'), $('#customer_node .searchable-select-dropdown'),2);
		   	});
		   	
		   	$('#unit_list').on('change',function(){
		   		listChange($('#unit_list'), $('#unit_node .searchable-select-dropdown'),2);
		   	});
		   	
		   	$('#device_list').on('change',function(){
		   		listChange($('#device_list'), $('#device_node .searchable-select-dropdown'),2);
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
			$("#customer_node").hide();
			$("#unit_node").hide();
			$("#device_node").hide();
			switch(n){
				case "org":
					$("#org_node").show();
					break;
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
	
		function expandParent(node){  
		    var parentNode = treeObj.tree("getParent", node.target);  
		    if(parentNode != null && parentNode != "undefined"){  
		        treeObj.tree("expand", parentNode.target);  
		        expandParent(parentNode);  
		    }  
		} 
	</script>
	*/
});

//智慧消防终端设备
var term_DeviceTree = codeCommentRemove(function () {
	/*
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
					<option id="" value="device" >设备</option>
					<option id="" value="unit" >终端</option>
					<option id="" value="customer" selected="selected">用户名称</option>
					<option id="" value="region">区域</option>
					<option id="" value="org">组织结构</option>
				</select>
			</td>
			<td style="padding-top: 1px;">
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
			   	data: {type: 3, systemtype: '', showGprs: false, showLora: true, 
		    			   showNB: false, showTransmission: false},
			   	type:"post",
			   	success:function(d){
			   		$("#org_node").hide();
			   		$("#region_node").hide();
					$("#customer_node").show();
					$("#unit_node").hide();
					$("#device_node").hide();

			   		listParse(d.customerlist, $('#customer_list'));
			   		listParse(d.regionlist, $('#region_list'));
			   		listParse(d.unitlist, $('#unit_list'));
			   		listParse(d.devicelist, $('#device_list'));
			   		listParse(d.orglist, $('#org_list'));
		   		
		   			$("#left-table").show();
			   	}
			});
			
			setTimeout(function(){ 
				$('#region_tree').tree({
				    url: basePath + '/admin/deviceTree?Math.random()',
				    queryParams: { treetype: '3', systemtype: '', showGprs: false, showLora: true, 
				    			   showNB: false, showTransmission: false },
				    lines: true,
				    onClick: function (n) {
				    	treeClick(treeObj, n);
				    }
				});
			}, 500);//延迟0.5秒
			
			setTimeout(function(){ 
				$('#org_tree').tree({
				    url: basePath + '/admin/deviceTree?Math.random()',
				    queryParams: { treetype: '1', systemtype: '', showGprs: false, showLora: true, 
			    			   showNB: false, showTransmission: false },
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
		   	
		   	$('#org_list').on('change',function(){
				listChange($('#org_list'), $('#org_node .searchable-select-dropdown'),1);
		   	});

			$('#region_list').on('change',function(){
				listChange($('#region_list'), $('#region_node .searchable-select-dropdown'),0);
		   	});
			
			$('#customer_list').on('change',function(){
				listChange($('#customer_list'), $('#customer_node .searchable-select-dropdown'),2);
		   	});
		   	
		   	$('#unit_list').on('change',function(){
		   		listChange($('#unit_list'), $('#unit_node .searchable-select-dropdown'),2);
		   	});
		   	
		   	$('#device_list').on('change',function(){
		   		listChange($('#device_list'), $('#device_node .searchable-select-dropdown'),2);
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
			$("#customer_node").hide();
			$("#unit_node").hide();
			$("#device_node").hide();
			switch(n){
				case "org":
					$("#org_node").show();
					break;
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
	
		function expandParent(node){  
		    var parentNode = treeObj.tree("getParent", node.target);  
		    if(parentNode != null && parentNode != "undefined"){  
		        treeObj.tree("expand", parentNode.target);  
		        expandParent(parentNode);  
		    }  
		} 
	</script>
	*/
});

//智慧消防终端设备+GPRS设备
var termGprs_DeviceTree = codeCommentRemove(function () {
	/*
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
					<option id="" value="device" >设备</option>
					<option id="" value="unit" >终端</option>
					<option id="" value="customer" selected="selected">用户名称</option>
					<option id="" value="region">区域</option>
					<option id="" value="org">组织结构</option>
				</select>
			</td>
			<td style="padding-top: 1px;">
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
			   	data: {type: 3, systemtype: '', showGprs: true, showLora: true,
			   	       showNB: false, showTransmission: false},
			   	type:"post",
			   	success:function(d){
			   		$("#org_node").hide();
			   		$("#region_node").hide();
					$("#customer_node").show();
					$("#unit_node").hide();
					$("#device_node").hide();

			   		listParse(d.customerlist, $('#customer_list'));
			   		listParse(d.regionlist, $('#region_list'));
			   		listParse(d.unitlist, $('#unit_list'));
			   		listParse(d.devicelist, $('#device_list'));
			   		listParse(d.orglist, $('#org_list'));
		   		
		   			$("#left-table").show();
			   	}
			});
			
			setTimeout(function(){ 
				$('#region_tree').tree({
				    url: basePath + '/admin/deviceTree?Math.random()',
				    queryParams: { treetype: '3', systemtype: '', showGprs: true, showLora: true, 
				    			   showNB: false, showTransmission: false },
				    lines: true,
				    onClick: function (n) {
				    	treeClick(treeObj, n);
				    }
				});
			}, 500);//延迟0.5秒
			
			setTimeout(function(){ 
				$('#org_tree').tree({
				    url: basePath + '/admin/deviceTree?Math.random()',
				    queryParams: { treetype: '1', systemtype: '', showGprs: true, showLora: true, 
			    			       showNB: false, showTransmission: false },
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
		   	
		   	$('#org_list').on('change',function(){
				listChange($('#org_list'), $('#org_node .searchable-select-dropdown'),1);
		   	});

			$('#region_list').on('change',function(){
				listChange($('#region_list'), $('#region_node .searchable-select-dropdown'),0);
		   	});
			
			$('#customer_list').on('change',function(){
				listChange($('#customer_list'), $('#customer_node .searchable-select-dropdown'),2);
		   	});
		   	
		   	$('#unit_list').on('change',function(){
		   		listChange($('#unit_list'), $('#unit_node .searchable-select-dropdown'),2);
		   	});
		   	
		   	$('#device_list').on('change',function(){
		   		listChange($('#device_list'), $('#device_node .searchable-select-dropdown'),2);
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
			$("#customer_node").hide();
			$("#unit_node").hide();
			$("#device_node").hide();
			switch(n){
				case "org":
					$("#org_node").show();
					break;
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
	
		function expandParent(node){  
		    var parentNode = treeObj.tree("getParent", node.target);  
		    if(parentNode != null && parentNode != "undefined"){  
		        treeObj.tree("expand", parentNode.target);  
		        expandParent(parentNode);  
		    }  
		} 
	</script>
	*/
});

//设备系统树
var systemTree = codeCommentRemove(function () {
	/*
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
					<option id="" value="unit" >终端</option>
					<option id="" value="customer" selected="selected">用户名称</option>
					<option id="" value="region">区域</option>
					<option id="" value="org">组织结构</option>
				</select>
			</td>
			<td style="padding-top: 1px;">
				<div id="unit_node">
                	<select id="unit_list"></select>
                </div>
                <div id="customer_node">
                	<select id="customer_list"></select>
                </div>
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
			   	data: {type: 2, systemtype: '', showGprs: true, showLora: true, 
		    			   showNB: true, showTransmission: true},
			   	type:"post",
			   	success:function(d){
			   		$("#org_node").hide();
			   		$("#region_node").hide();
					$("#customer_node").show();
					$("#unit_node").hide();

			   		listParse(d.customerlist, $('#customer_list'));
			   		listParse(d.regionlist, $('#region_list'));
			   		listParse(d.unitlist, $('#unit_list'));
			   		listParse(d.orglist, $('#org_list'));
		   		
		   			$("#left-table").show();
			   	}
			});
			
			setTimeout(function(){ 
				$('#region_tree').tree({
				    url: basePath + '/admin/systemTree?Math.random()',
				    queryParams: { treetype: '3', systemtype: '', showGprs: true, showLora: true, 
				    			   showNB: true, showTransmission: true },
				    lines: true,
				    onClick: function (n) {
				    	treeClick(treeObj, n);
				    }
				});
			}, 500);//延迟0.5秒
			
			setTimeout(function(){ 
				$('#org_tree').tree({
				    url: basePath + '/admin/systemTree?Math.random()',
				    queryParams: { treetype: '1', systemtype: '', showGprs: true, showLora: true, 
			    			   showNB: true, showTransmission: true },
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
		   	
		   	$('#org_list').on('change',function(){
				listChange($('#org_list'), $('#org_node .searchable-select-dropdown'),1);
		   	});

			$('#region_list').on('change',function(){
				listChange($('#region_list'), $('#region_node .searchable-select-dropdown'),0);
		   	});
			
			$('#customer_list').on('change',function(){
				listChange($('#customer_list'), $('#customer_node .searchable-select-dropdown'),2);
		   	});
		   	
		   	$('#unit_list').on('change',function(){
		   		listChange($('#unit_list'), $('#unit_node .searchable-select-dropdown'),2);
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
			$("#customer_node").hide();
			$("#unit_node").hide();
			switch(n){
				case "org":
					$("#org_node").show();
					break;
				case "region":
					$("#region_node").show();
					break;
				case "customer":
					$("#customer_node").show();
					break;
				case "unit":
					$("#unit_node").show();
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
	*/
});

//智慧消防终端
var term_UnitTree = codeCommentRemove(function () {
	/*
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
					<option id="" value="unit" >终端</option>
					<option id="" value="customer" selected="selected">用户名称</option>
					<option id="" value="region">区域</option>
					<option id="" value="org">组织结构</option>
				</select>
			</td>
			<td style="padding-top: 1px;">
				<div id="unit_node">
                	<select id="unit_list"></select>
                </div>
                <div id="customer_node">
                	<select id="customer_list"></select>
                </div>
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
			   	data: {type: 2, systemtype: '', showGprs: false, showLora: true,
			   	       showNB: false, showTransmission: false},
			   	type:"post",
			   	success:function(d){
			   		$("#org_node").hide();
			   		$("#region_node").hide();
					$("#customer_node").show();
					$("#unit_node").hide();
			   		
			   		listParse(d.customerlist, $('#customer_list'));
			   		listParse(d.regionlist, $('#region_list'));
			   		listParse(d.unitlist, $('#unit_list'));
			   		listParse(d.orglist, $('#org_list'));
			   		
			   		$("#left-table").show();
			   	}
			});
			
			setTimeout(function(){ 
				$('#region_tree').tree({
				    url: basePath + '/admin/unitTree?Math.random()',
				    queryParams: { treetype: '3', showGprs: false, showLora: true, showNB: false, 
				    			   showTransmission: false},
				    lines: true,
				    onClick: function (n) {
				    	treeClick(treeObj, n);
				    }
				});
			}, 500);//延迟0.5秒
			
			setTimeout(function(){ 
				$('#org_tree').tree({
				    url: basePath + '/admin/unitTree?Math.random()',
				    queryParams: { treetype: '1', showGprs: false, showLora: true, showNB: false, 
			    			       showTransmission: false},
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

		   	$('#unit_list').on('change',function(){
		   		listChange($('#unit_list'), $('#unit_node .searchable-select-dropdown'),2);
		   	});
		   	
		   	$('#customer_list').on('change',function(){
				listChange($('#customer_list'), $('#customer_node .searchable-select-dropdown'),2);
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
			$("#region_node").hide();
			$("#customer_node").hide();
			$("#unit_node").hide();
			$("#org_node").hide();
			switch(n){
				case "org":
					$("#org_node").show();
					break;
				case "region":
					$("#region_node").show();
					break;
				case "customer":
					$("#customer_node").show();
					break;
				case "unit":
					$("#unit_node").show();
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
*/
});

//智慧消防终端+GPRS设备
var termGprs_UnitTree = codeCommentRemove(function () {
	/*
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
					<option id="" value="unit" >终端</option>
					<option id="" value="customer" selected="selected">用户名称</option>
					<option id="" value="region">区域</option>
					<option id="" value="org">组织结构</option>
				</select>
			</td>
			<td style="padding-top: 1px;">
				<div id="unit_node">
                	<select id="unit_list"></select>
                </div>
                <div id="customer_node">
                	<select id="customer_list"></select>
                </div>
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
			   	data: {type: 2, systemtype: '', showGprs: true, showLora: true,
			   	       showNB: false, showTransmission: false},
			   	type:"post",
			   	success:function(d){
			   		$("#org_node").hide();
			   		$("#region_node").hide();
					$("#customer_node").show();
					$("#unit_node").hide();
			   		
			   		listParse(d.customerlist, $('#customer_list'));
			   		listParse(d.regionlist, $('#region_list'));
			   		listParse(d.unitlist, $('#unit_list'));
			   		listParse(d.orglist, $('#org_list'));
			   		
			   		$("#left-table").show();
			   	}
			});
			
			setTimeout(function(){ 
				$('#region_tree').tree({
				    url: basePath + '/admin/unitTree?Math.random()',
				    queryParams: { treetype: '3', showGprs: true, showLora: true, showNB: false, 
				    			   showTransmission: false},
				    lines: true,
				    onClick: function (n) {
				    	treeClick(treeObj, n);
				    }
				});
			}, 500);//延迟0.5秒
			
			setTimeout(function(){ 
				$('#org_tree').tree({
				    url: basePath + '/admin/unitTree?Math.random()',
				    queryParams: { treetype: '1', showGprs: true, showLora: true, showNB: false, 
			    			       showTransmission: false},
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

		   	$('#unit_list').on('change',function(){
		   		listChange($('#unit_list'), $('#unit_node .searchable-select-dropdown'),2);
		   	});
		   	
		   	$('#customer_list').on('change',function(){
				listChange($('#customer_list'), $('#customer_node .searchable-select-dropdown'),2);
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
			$("#region_node").hide();
			$("#customer_node").hide();
			$("#unit_node").hide();
			$("#org_node").hide();
			switch(n){
				case "org":
					$("#org_node").show();
					break;
				case "region":
					$("#region_node").show();
					break;
				case "customer":
					$("#customer_node").show();
					break;
				case "unit":
					$("#unit_node").show();
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
*/
});

//智慧消防终端+用传
var termTran_UnitTree = codeCommentRemove(function () {
	/*
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
					<option id="" value="unit" >终端</option>
					<option id="" value="customer" selected="selected">用户名称</option>
					<option id="" value="region">区域</option>
					<option id="" value="org">组织结构</option>
				</select>
			</td>
			<td style="padding-top: 1px;">
				<div id="unit_node">
                	<select id="unit_list"></select>
                </div>
                <div id="customer_node">
                	<select id="customer_list"></select>
                </div>
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
			   	data: {type: 2, systemtype: '', showGprs: false, showLora: true, showNB: false, 
		    			   showTransmission: true},
			   	type:"post",
			   	success:function(d){
			   		$("#org_node").hide();
			   		$("#region_node").hide();
					$("#customer_node").show();
					$("#unit_node").hide();
			   		
			   		listParse(d.customerlist, $('#customer_list'));
			   		listParse(d.regionlist, $('#region_list'));
			   		listParse(d.unitlist, $('#unit_list'));
			   		listParse(d.orglist, $('#org_list'));
			   		
			   		$("#left-table").show();
			   	}
			});
			
			setTimeout(function(){ 
				$('#region_tree').tree({
				    url: basePath + '/admin/unitTree?Math.random()',
				    queryParams: { treetype: '3', showGprs: false, showLora: true, showNB: false, 
				    			   showTransmission: true},
				    lines: true,
				    onClick: function (n) {
				    	treeClick(treeObj, n);
				    }
				});
			}, 500);//延迟0.5秒
			
			setTimeout(function(){ 
				$('#org_tree').tree({
				    url: basePath + '/admin/unitTree?Math.random()',
				    queryParams: { treetype: '1', showGprs: false, showLora: true, showNB: false, 
			    			   showTransmission: true},
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

		   	$('#unit_list').on('change',function(){
		   		listChange($('#unit_list'), $('#unit_node .searchable-select-dropdown'),2);
		   	});
		   	
		   	$('#customer_list').on('change',function(){
				listChange($('#customer_list'), $('#customer_node .searchable-select-dropdown'),2);
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
			$("#region_node").hide();
			$("#customer_node").hide();
			$("#unit_node").hide();
			$("#org_node").hide();
			switch(n){
				case "org":
					$("#org_node").show();
					break;
				case "region":
					$("#region_node").show();
					break;
				case "customer":
					$("#customer_node").show();
					break;
				case "unit":
					$("#unit_node").show();
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
*/
});

//后端使用树