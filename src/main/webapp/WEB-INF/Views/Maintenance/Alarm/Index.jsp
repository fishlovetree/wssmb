<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
    <%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>预警处理</title>
<jsp:include page="../../FrontHeader.jsp"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/parseAlarm.js"></script>
<style type="text/css">
.tableTr{
    display:block; /*将tr设置为块体元素*/
    margin:10px 0;  /*设置tr间距为2px*/
}

.layout-split-west {
    border-right: 1px solid #ccc;
}
</style>
</head>
<body>	
<table id="dg"  style="width: 100%;"></table>

<!-- 处理弹出框 -->
<div id="dlg" class="easyui-dialog" style="width:300px;height:280px;padding:10px 20px;" closed="true" buttons="#dlg-buttons">
	 <form id="fm" class="easyui-form" method="post" enctype="multipart/form-data">
             <table cellpadding="5" align="center">
                <tr class="tableTr">                 
                    <td ><input class="easyui-datetimebox" editable="fasle" name="processtime" style="width:100%;" data-options="label:'处理时间',required:true,formatter:myformatter,parser:myparser"></td>
                </tr>             
                <tr class="tableTr">
                    <td><input class="easyui-textbox" type="text" style="width:100%" name="processmethod" data-options="label:'处理方法',required:true,"></input></td>
                </tr>
                <tr class="tableTr">
                   <td>
                		 <input class="easyui-filebox"  style="width:100%" name="myAnnex" data-options="label:'上传附件',buttonText: '选择文件'," />
                	</td>
                </tr>
                
            </table>
        </form>
</div>
<div id="dlg-buttons">
	<a href="#" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveEarly()"><spring:message code="Save"/></a>
	<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')"><spring:message code="Cancel"/></a>
</div>

<!-- 明细弹出框 -->
<div id="w" class="easyui-window" closed="true" data-options="cls:'theme-panel-blue'" style="width:380px;height:250px;padding:10px;">
	<div id="dataDetail" align="center"> </div>
</div>

<script type="text/javascript">	
var alarmtype;

$(function(){
	alarmtype='${requestScope.type}';
	 
	$('#dg').datagrid({
		url:'${pageContext.request.contextPath}/alarm/earlyDataGrid?Math.random()',
		queryParams: { status:0, alarm:alarmtype},
		cls:"theme-datagrid", 
		singleSelect:true,
		//showFooter:true,
		title:'',
		//cache:false,	
		/* sortName : 'occurtime',
		sortOrder : 'desc', //降序 */
		remoteSort:false,
		nowrap: true,//数据长度超出列宽时将会自动截取。
		rownumbers:true,//显示序号
		pagination:true,//分页控件  
		pageSize:10,
		pageList: [10, 15, 50, 100],
		toolbar:'#toolbar',
		collapsible:true,
		fit: true,   //自适应大小
		loader: myLoader, //前端分页加载函数  
		columns: [[  
			/* {title: '操作', field: 'id', width:'100px',formatter:Button,}, */
			{title: '设备名称', field: 'equipmentname', width: '150px'},
			{title: '设备地址', field: 'equipmentaddress', width: '150px'},
			{title: '报警类型', field: 'alarmName', width: '110px'}, 
			{title: '发生时间', field: 'occurtime', width: '180px',sortable:true}, 
			{title: '发生数据', field: 'occurdata', width: '100px',
				formatter:function(value,rowData,rowIndex){
					if(null!=rowData.id && rowData.id!=""){
						var id=rowData.id;	//告警表id
						var dataType=1; //数据类型：1-开始数据
						return "<a href='#' class='asyui-linkbutton button-default button-view' onclick='queryData(&apos;" + id +"&apos;"+","+"&apos;"+dataType+"&apos;"+","+"&apos;"+rowData.alarmtype+"&apos;);'>查看详情</a>";
					}
            	}
			},
			{title: '用户编号', field: 'customerCode', width: '120px'},    	           	
			{title: '终端地址', field: 'unitaddress', width: '100px'}, 				 				
			{title: '累计次数', field: 'cumulativenum', width: '100px'}, 				
		]],
	 	onDblClickCell: function(index,field,value){
			editEarly(index);
		}, 
		onLoadSuccess:function(){
			$('.button-view').linkbutton({ 
			});
			
			$('.text').textbox({
				width:70,
				height:30
			})

		}	
	});	
})   
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	var h = date.getHours();  
    var min = date.getMinutes();  
    var sec = date.getSeconds();
	return  y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d)+' '+(h<10?('0'+h):h)+':'+(min<10?('0'+min):min)+':'+(sec<10?('0'+sec):sec);
}
function myparser(s){
	if (!s) return new Date();
	 var y = s.substring(0,4);  
     var m =s.substring(5,7);  
     var d = s.substring(8,10);
     var h = s.substring(11,13);  
     var min = s.substring(14,16);  
     var sec = s.substring(17,19);
	if (!isNaN(y) && !isNaN(m) && !isNaN(d) && !isNaN(h) && !isNaN(min) && !isNaN(sec)){
		return new Date(y,m-1,d,h,min,sec);
	} else {
		return new Date();
	}
}

//编辑菜单
function editEarly(rowIndex){
	$('#fm').form('clear');
	 var rows = $('#dg').datagrid('getRows');
	  var row = rows[rowIndex];
	if (row){
		if(row.status==0){
			$('#dlg').dialog('open').dialog('setTitle','预警处理');
			$('#fm').form('load',row);
			url = '${pageContext.request.contextPath}/frontEarlyWarn/processEarly?id='+row.id;
		}else{
			 $.messager.alert('<spring:message code="Prompt"/>',"该预警已经处理。",'warning')
		}	
	}
}	
	
//保存
function saveEarly(){
	$('#fm').form('submit',{
		url: url,
		onSubmit: function(){
			return $(this).form('validate');
		},
		success: function(result){	
			if(result=="success"){
				$('#dlg').dialog('close');		// close the dialog
				$("#dg").data().datagrid.cache = null; 
				$('#dg').datagrid('reload');	// reload the user data			
				$.messager.alert('<spring:message code="Prompt"/>','<spring:message code="SuccessOperation"/>','info');
			}else{
				$.messager.alert('<spring:message code="Warning"/>',result,'error');
			}
		
		},
		  error:function(data){
			  $.messager.alert('<spring:message code="Warning"/>',data,'error');	        	
        }
	});
} 

//查询数据详情
//alarmId 告警表id
//dataType 数据类型：1-开始数据
//alarmType 事件类型id
function queryData(alarmId,dataType,alarmType){
	//清空表格
	$('#dataDetail').empty();
	var mData={"alarmId":alarmId,"dataType":dataType,"alarmType":alarmType}; 
	$.ajax({
		type:'POST', 
        url:'${pageContext.request.contextPath}/earlyWarn/earlyDataDetail',           
        data:mData,        
	       success:function(data){ 
	    	   var title;
	    		if(dataType == 1) title = "发生数据详情";
	    		else if(dataType == 2) title = "结束数据详情";
	    		var eventArray = getEventName(alarmType);
	    		var html = '';
	    		var height = "60px";
	    		if(data.length > 0){
	    			html='<table cellpadding="5" align="center">';
	    		    if(data.length > 7)
	    			    height = "320px";
	    		    else
	    			    height = 53*data.length+"px";
	    		    var numberName="";
	    	  	    for (var i = 0; i < data.length; i++) {  
	    			    numberName = getNumberName(data[i].itemnumber,alarmType); 
	    			    var evenName="";//项名称
	    			    var mEventData="";//数据值和单位
	    			    if(alarmType >= 1 && alarmType < 60 ){
	    				    if(alarmType == 23 || alarmType == 24){
	    					    evenName = eventArray[0] + numberName;//项名称
		    				    mEventData = getEventData(alarmType,data[i].itemnumber,FormatValue(data[i].eventdata), eventArray); 
	    				    }else{
	    					    evenName = numberName + eventArray[0];//项名称
	    					    if(null != data[i].eventdata)
	    						    mEventData = data[i].eventdata + eventArray[1];
	    		  			    else
	    		  				    mEventData = "无数据";
	    				    }	
	    			    }
	    			    else if (alarmType >= 520 && alarmType <= 600){ //用传告警
	    			    	var evenName = getNumberName(data[i].itemnumber, alarmType);
   	  			    	if(null != data[i].eventdata)
   						    mEventData = data[i].eventdata;
   		  			    else
   		  				    mEventData = "无数据";
	    	  			}
	    			    else {
	    				    evenName = eventArray[0] + numberName;//项名称
	    				    mEventData = getEventData(alarmType,data[i].itemnumber,FormatValue(data[i].eventdata), eventArray); 
	    			    } 
		    			if(alarmType != 92 || data[i].itemnumber != 2){//屏蔽燃气告警的电池电压数据
		    		   		var trTd = '<tr class="tableTr"> '
		    			 	    +'<td ><input class="easyui-textbox" readonly="true" value="'+mEventData +'" style="width:240px;" data-options="label:\''+evenName+'\'" ></td>'
		    			 	    +'</tr>';
		    			 	html = html + trTd;
		    			}
	    			}  
	    	  	    html=html+'</table>';
	    		}
	    		if(null==html || html=="") html="<p style='color: gold;font-size: 16px;margin-top:10px'>暂无数据<p>";
	    	    $("#dataDetail").append(html);
	    	    $.parser.parse( $('#w')); 
	    	    document.getElementById("w").style.height= height;
	    	    $('#w').window('open').dialog('setTitle',title);

	        },	        
	        error:function(data){
	        	$.messager.alert('<spring:message code="Warning"/>',"获取失败。",'error');
       	}
	   });	
}

//加载分页数据
function myLoader(param, success, error) {  
   var that = $(this);  
   var opts = that.datagrid("options");  
   if (!opts.url) {  
       return false;  
   }  
 
   var cache = that.data().datagrid.cache;  
   if (!cache) {  
       $.ajax({  
           type: opts.method,  
           url: opts.url,  
           data: param,  
           dataType: "json",  
           success: function (data) {  
               that.data().datagrid['cache'] = data;  
               success(bulidData(data));  
           },  
           error: function () {  
               error.apply(this, arguments);  
           	$.messager.alert('<spring:message code="Warning"/>',"获取失败。",'error');
           }  
       });  
   } else {  
       success(bulidData(cache));  
   }
 
   function bulidData(data) {  
      // debugger;  
       var temp = $.extend({}, data);  
       var tempRows = [];  
       var start = (param.page - 1) * parseInt(param.rows);  
       var end = start + parseInt(param.rows);  
       var rows = data.rows;  
       for (var i = start; i < end; i++) {  
           if (rows[i]) {  		            	
               tempRows.push(rows[i]);  
           } else {  
               break;  
           }  
       }  
 
       temp.rows = tempRows;  
       return temp;  
   }  
} 
</script>
</body>
</html>