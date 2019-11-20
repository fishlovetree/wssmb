//在地图中定位表箱
function findBox(node) {
	if(node.type == 3){
		fly(node.gid);
	}else if(node.type == 2){			//行政区域的区域
		var regionid = node.gid;
		$.ajax({
		    type:'POST', 
	        url: basePath + '/region/selectRegionById?Math.random()',           
	        data:{"regionid":regionid},
	        success:function(data){
	        	var region = eval("("+data+")");
	        	if(region && region.lng && region.lat){
	        		//不同层级缩放等级不同
	        		if (region.leveltype == 0){ 
	        			map.setZoomAndCenter(4, [region.lng, region.lat]);
	        		}
	        		else if (region.leveltype == 1){ //省
	        			map.setZoomAndCenter(6.5, [region.lng, region.lat]);
	        		}
	        		else if (region.leveltype == 2){ //市
	        			map.setZoomAndCenter(11, [region.lng, region.lat]);
	        		}
	        		else if (region.leveltype == 3){ //区县
	        			map.setZoomAndCenter(13, [region.lng, region.lat]);
	        		}
	        		else{
	        			map.setZoomAndCenter(16, [region.lng, region.lat]);
	        		}
	        	}
        	},     
	        error:function(data){
	        }
		});
	
	}
}

/*******************************************************************************************************
 ** 二维地图相关
 *******************************************************************************************************/
var heatmap; //热力图对象

//初始化二维地图
function initMap(){
	var mapCenter;
	var isRegion = false; //中心点是区域
	//地图加载
	var mapOpt = {
        mapStyle: 'amap://styles/e669bfcd88d5760c202fa10ef1f07346', //设置地图的显示样式
        resizeEnable: true		//设置可调整大小
    }
	if(mapCenter){
		mapOpt.center = mapCenter;
		if (isRegion){
			mapOpt.zoom = 10;
		}
		else{
		    mapOpt.zoom = 10;
		}
	}else{
		mapOpt.center = initCenter;
		mapOpt.zoom = 10;
	}
    map = new AMap.Map("map", mapOpt); 
    map.plugin(["AMap.Heatmap"], function() {
    	//初始化heatmap对象
        heatmap = new AMap.Heatmap(map, {
            radius: 18, //给定半径
            opacity: [0, 0.8],
        });
    });
    //地图模块加载完成后
    map.on("complete",function(){	//地图模块加载完成
    	initAnimateMarker();		//初始化告警和故障动画效果对象
    	queryAllBoxs();	//获取所有的表箱
    }) 
}

function latlonStr(latstr,lonstr){
	map.setZoomAndCenter(map.getZoom(), [lonstr,latstr]);
}

//初始化各个图标对象
function initAnimateMarker(){
	alarmAnimateMarker = new FlashMarker(map,[]);
	troubleAnimateMarker = new FlashMarker(map,[]);
	offlineAnimateMarker = new FlashMarker(map,[]);
}

//添加电表告警动画效果
var secondStatus=0;

function removeBoxAlarm(boxObj){
	for(var item in boxObj){
		alarmAnimateMarker.removeMarkerById(item);
	}
}

//添加电表故障动画效果
function addMeasureFault(cusObj){
	for(var item in faultMeasureObj){
		troubleAnimateMarker.removeMarkerById(item);
	}
	for(var item in cusObj){					//增加告警
		var circleType=1;
		var latitude = cusObj[item].latitude;
		var longitude = cusObj[item].longitude;
		var lonlat={};
		lonlat.O=latitude;
		lonlat.P=longitude;
		lonlat.lat=latitude;
		lonlat.lng=longitude;
		troubleAnimateMarker.addMarkerToMap({lonlat:lonlat,markerId:item,color:"#FFFF00"},circleType);
	}
}

function addMeasureMessage(cusObj){
	for(var item in messageMeasureObj){
		offlineAnimateMarker.removeMarkerById(item);
	}
	messageMeasureObj=[];
	for(var item in cusObj){					//增加告警
		messageMeasureObj.push(item);
		var circleType=0;
		var latitude = cusObj[item].latitude;
		var longitude = cusObj[item].longitude;
		var lonlat={};
		lonlat.O=latitude;
		lonlat.P=longitude;
		lonlat.lat=latitude;
		lonlat.lng=longitude;
		offlineAnimateMarker.addMarkerToMap({lonlat:lonlat,markerId:item,color:"#A6A5A5"},circleType);
	}
}

function addBoxAlarm(boxObj){
	if(!alarmAnimateMarker) return;
	for(var item in alarmBoxObj){			//移除消失的告警
		if(!boxObj[item] && alarmBoxObj[item]){
			alarmAnimateMarker.removeMarkerById(item);
			alarmBoxObj[item] = null;
			//如果有故障，则显示故障动画
			if (troubleBoxObj[item]){
				var circleType=1;
				var lonlat = boxMarkersObj[item].getPosition();
				troubleAnimateMarker.addMarkerToMap({lonlat:lonlat,markerId:item,color:"#FFFF00"},circleType);
			}
			//如果没有故障，有终端离线，则显示离线动画
			else if (offlineBoxObj[item]){
				var circleType=0;
				var lonlat = boxMarkersObj[item].getPosition();
				offlineAnimateMarker.addMarkerToMap({lonlat:lonlat,markerId:item,color:"#A6A5A5"},circleType);
			}
		}
	}
	for(var item in boxObj){					//增加告警
		if(boxObj[item] && !alarmBoxObj[item]){
			if(boxMarkersObj[item]){
				var lonlat = boxMarkersObj[item].getPosition();
				alarmAnimateMarker.addMarkerToMap({lonlat:lonlat,markerId:item});
				alarmBoxObj[item] = item;
				
				//如果有故障，则移除故障动画
				if (troubleBoxObj[item]){
					troubleAnimateMarker.removeMarkerById(item);
				}
				//如果有终端离线，则移除离线动画
				if (offlineBoxObj[item]){
					offlineAnimateMarker.removeMarkerById(item);
				}
			}
		}
	}
	
	var cusCoords = [];
	for(var item in alarmBoxObj){
		if(boxMarkersObj[item]){
			var lonlat = boxMarkersObj[item].getPosition();
			cusCoords.push(lonlat);
		}
	}
	
	if(cusCoords.length != 0){
		if(cusCoords.length == 1){
			var center = cusCoords[0]
			if(secondStatus==0){
				secondStatus=1;
				map.setZoomAndCenter(18, center);
			}
			
		}else{
			var testLine = new AMap.Polyline({path:cusCoords});
			var bounds = testLine.getBounds();
			if(secondStatus==0){
				secondStatus=1;
				map.setBounds(bounds);
			}
		
		}
	}
}

//添加表箱故障动画效果
function addBoxTrouble(boxObj){
	if(!troubleAnimateMarker) return;
	for(var item in troubleBoxObj){			//移除消失的故障动画效果
		if(!boxObj[item] && troubleBoxObj[item]){
			troubleAnimateMarker.removeMarkerById(item);
			troubleBoxObj[item] = null;
			if (offlineBoxObj[item] && !alarmBoxObj[item]){ //如果没有告警，但有终端离线，则显示离线动画
				var circleType=0;
				var lonlat = boxMarkersObj[item].getPosition();
				offlineAnimateMarker.addMarkerToMap({lonlat:lonlat,markerId:item,color:"#A6A5A5"},circleType);
			}
		}
	}
	for(var item in boxObj){					//添加故障动画效果
		if(!troubleBoxObj[item]){
			if(boxMarkersObj[item]){
				//如果有告警，则添加到故障队列，不显示故障动画
				if (alarmBoxObj[item]){
					troubleBoxObj[item] = item;
				}
				else{
					var lonlat = boxMarkersObj[item].getPosition();
					var circleType=1;
					troubleAnimateMarker.addMarkerToMap({lonlat:lonlat,markerId:item,color:"#FFFF00"},circleType);
					troubleBoxObj[item] = item;
					//如果有离线动画，则移除
					if (offlineBoxObj[item]){
						offlineAnimateMarker.removeMarkerById(item);
					}
				}
			}
		}
	}
}

//添加表箱内集中区离线动画效果
function addBoxOffline(boxObj){
	if(!offlineAnimateMarker) return;
	for(var item in offlineBoxObj){			//移除消失的离线动画效果
		if(!cusObj[item] && offlineBoxObj[item]){
			offlineAnimateMarker.removeMarkerById(item);
			offlineBoxObj[item] = null;
		}
	}
	for(var item in boxObj){					//添加离线动画效果
		if(!offlineBoxObj[item]){
			if(boxMarkersObj[item]){
				//如果有告警或者故障，则只加入到离线队列，不显示离线动画
				if (alarmBoxObj[item] || troubleBoxObj[item]){
					offlineBoxObj[item] = item;
				}
				else{
					var lonlat = boxMarkersObj[item].getPosition();
					var circleType=0;
					offlineAnimateMarker.addMarkerToMap({lonlat:lonlat,markerId:item,color:"#A6A5A5"},circleType);
					offlineBoxObj[item] = item;
				}
			}
		}
	}
}

var boxMarkersObj = {};			//保存所有的表箱图标要素
var boxMarkers = [];            //保存图标数组

//查询所有的表箱和告警情况，并添加到地图上
function queryAllBoxs(){
	var dataObj;
	$.ajax({
	    type:'POST', 
        url:basePath + '/measureFile/getDataGrid?Math.random()',           
        data:{page:1,rows:99999},
        async:false,
        success:function(data){
    	    if (data){
    		    dataObj = eval("("+data+")");
    		    addMarker(dataObj.rows); //添加图标
    		    addHeatMap(dataObj.rows); //添加热力图
    	   }
       },	        
       error:function(data){

       }
    })
    map.on("zoomchange",function(){
       var currentZoom=map.getZoom();
       if(currentZoom<8){
    	   heatmap.Ye.radius=18;
       }else{
    	   heatmap.Ye.radius=50;
       }    
    })    
}

function addHeatMap(data) {//添加热力图
	//热力图按钮初始化
	$("#heatMapId").on("click",function(){
	     if ($("#heatMapId").is(':checked')){
		     if (heatmap){
			     heatmap.show();
		     }
		     if (boxMarkers){
			     map.remove(boxMarkers);//删除图标
		     }
	     }
	     else{
		     if (heatmap){
			     heatmap.hide();
		     }
		     if (boxMarkers){
			     map.add(boxMarkers);//添加图标
		     }
	     }
    });
    
	var points=[];
	for(var i = 0; i < data.length; i++){   
		if(data[i].latitude){
		var lat=data[i].latitude;
        var lon=data[i].longitude;
		}
        var pointJson ={"lat":lat,"lng":lon}
        points.push(pointJson);
    }
    //设置数据集
    heatmap.setDataSet({
	    data: points ,
    });
	heatmap.hide(); 
}

function addMarker(dataObj) {//添加图标
    $.each(dataObj, function(i, n){
    	//在地图上添加-用户标记
		if(/^\d+(\.\d+)?$/.test(n.longitude) &&  /^\d+(\.\d+)?$/.test(n.latitude)){
    		var marker = new AMap.Marker({
    			position: [Number(n.longitude),Number(n.latitude)],
    			icon: basePath+'/images/gis/customer.png',
    			offset: new AMap.Pixel(-17, -17),	//默认(-10,-34)
    			label:{
	    			offset: new AMap.Pixel(20, 40),
	    			content: "<div class='info'>"+n.measureName+"</div>"
    		    }
 		    });
    		marker.on('click',function(){
    			showBoxInfo(n.measureId);			//设置弹出框事件
    		})
    		marker.on('mouseover',markerOver);
    		marker.on('mouseout',markerOut);
    		boxMarkers.push(marker);
    		boxMarkersObj[n.measureId] = marker;
    	}
    });		    
    map.add(boxMarkers);
}
//图标over
function markerOver(e){
	var marker = e.target;
	marker.setzIndex(101);
}

//图标out
function markerOut(e){
	var marker = e.target;
	marker.setzIndex(100);
}

/*
 * 地图适应到一个范围
 * @param {Array} extent 左下角和右上角的经纬度 [x0,y0,x1,y1]
 */
function fitExtent(extent){
	var wsPos = new AMap.LngLat(extent[0], extent[1]);
	var nePos = new AMap.LngLat(extent[2], extent[3]);
    map.setBounds(new AMap.Bounds(wsPos,nePos));      //高德地图fit到一个范围
}

/*
 * 跳转到地图上的表箱点
 * @param {String} boxid 表箱id
 */
function fly(boxid){
	if(!boxid) return;
	var marker = boxMarkersObj[boxid];
	if(marker){
		var pos = marker.getPosition();
		map.setZoomAndCenter(18, [pos.lng, pos.lat]);		//高德地图
	}  	
}

/*******************************************************************************************************
 ** 弹出框相关
 *******************************************************************************************************/

//在弹出框中显示用户信息
function showBoxInfo(id){
	$.ajax({
	    type:'POST', 
        url:basePath + '/measureFile/getMeasurefileByMeasureId?Math.random()',           
        data:{id:id},
        async: false,
        success:function(data){
        	data = eval("("+data+")");
  	        if (data){
	  	    	$('#boxid').val(id);
    			$('#boxname').html(data.MeasureName);
    			$('#address').html(data.Address);
    			if(null!=data.MeasureNumber){
	    			$('#legalrepresentative').html(data.Creater);
	    			$('#measureNumber').html(data.MeasureNumber);
    			}
    			
    			$(".userBox").show();

    			//在弹出框中显示表箱内电表
    			showConcentratorInfo();
  	        }
        },	        
        error:function(data){
        }
	})
}

function closeBoxInfo(){
	$('.userBox').hide();
	$(".concentratorInfo").hide();
}

//在弹出框中显示表箱内集中器
function showConcentratorInfo(){
	var id = $("#boxid").val();
	if (id == "") return;
	$(".floorInfo").hide();
	$(".concentratorInfo").show();
	$(".elockList").hide();
	$(".breakerList").hide();
	$(".ammeterList").hide();
	$(".terminalList").hide();
	//清除统计列表内容
	$("#concentratorTbl").datagrid('loadData',{total:0,rows:[]});
	getConcentratorData(id);
}

function closeConcentratorInfo(){
	$("#concentratorTbl").datagrid('loadData',{total:0,rows:[]});
	$(".concentratorInfo").hide();
}

//在弹出框中显示集中器信息
function getConcentratorData(id){
	$.ajax({
	    type:'POST', 
      url:basePath + '/concentratorFile/getConcentratorByMeasureId?Math.random()', 
      data:{measureId: id},
      success:function(data){
	        if (data){
	        	$("#concentratorTbl").datagrid('loadData',{total:0,rows:[]});
	        	var list=eval("("+data+")");
			    //统计信息
			    for(var i=0;i<list.length;i++){
					var n=list[i];
						//{listcount=6, list={"1":{"RN":1,"systemtype":"10","systemname":"电气火灾监控系统","equipmentcount":3,"alarmdevicecount":2,"unonlinedevicecount":1,"faultdevicecount":0,"normalcount":0,"nocommcount":0,"nodowncount":0},"2":{"RN":2,"systemtype":"11","systemname":"可燃气体报警系统","equipmentcount":1,"alarmdevicecount":1,"unonlinedevicecount":0,"faultdevicecount":0,"normalcount":0,"nocommcount":0,"nodowncount":0},"3":{"RN":3,"systemtype":"128","systemname":"烟雾监控系统","equipmentcount":8,"alarmdevicecount":7,"unonlinedevicecount":1,"faultdevicecount":0,"normalcount":0,"nocommcount":0,"nodowncount":0},"4":{"RN":4,"systemtype":"129","systemname":"消防水压监控系统","equipmentcount":6,"alarmdevicecount":4,"unonlinedevicecount":2,"faultdevicecount":0,"normalcount":0,"nocommcount":0,"nodowncount":0},"5":{"RN":5,"systemtype":"130","systemname":"报警按钮及声光报警器","equipmentcount":5,"alarmdevicecount":4,"unonlinedevicecount":1,"faultdevicecount":0,"normalcount":0,"nocommcount":0,"nodowncount":0},"6":{"RN":6,"systemtype":"131","systemname":"消防水位监控系统","equipmentcount":2,"alarmdevicecount":2,"unonlinedevicecount":0,"faultdevicecount":0,"normalcount":0,"nocommcount":0,"nodowncount":0}}}
				    	var row = { "concentratorType": n.concentratorType, "concentratorName": n.concentratorName, "creater": n.creater, "concentratorId": n.concentratorId, "simCard": n.simCard, "address": n.address};
		                $("#concentratorTbl").datagrid('insertRow', { index: 0, row: row });
				}
	        }
    },	        
    error:function(data){

    }
	})
}

//在弹出框中显示表箱e锁
function showElockList(){
	var id = $("#boxid").val();
	if (id == "") return;
	$(".virtualInfo").hide();
	$(".ammeterList").hide();
	$(".breakerList").hide();
	$(".concentratorInfo").hide();
	$(".terminalList").hide();
	$(".elockList").show();
	getElockData(3,id);
}
//点击电表
function showAmmeterList(){
	var id = $("#boxid").val();
	if (id == "") return;
	$(".virtualInfo").hide();;
	$(".concentratorInfo").hide();
	$(".elockList").hide();
	$(".ammeterList").show();
	$(".breakerList").hide();
	$(".terminalList").hide();
	getAmmeterData(3,id);
}

function closeElockList(){
	$("#elockListTbl").datagrid('loadData',{total:0,rows:[]});
	$(".elockList").hide();
}

function closeAmmeterList(){
	$("#ammeterListTbl").datagrid('loadData',{total:0,rows:[]});
	$(".ammeterList").hide();
}

//在弹出框中显示电表列表
function getAmmeterData(type,id){
	setFirstPage($("#ammeterListTbl"));
	$('#ammeterListTbl').datagrid({
		url :basePath + '/mbAmmeter/queryAmmeterByTree?Math.random()', 
		queryParams: {
			type : type,
		 	gid : id
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
		columns: [[ 
			{title: 'id', field: 'id', width:'0px',hidden:true},
			{title: '操作', field: 'switchStatus', width:'180px',
				formatter:function(value, rowData, rowIndex){
					var als="";
						als+= "<button type='button' style='width: 80px;height: 25px;cursor:pointer;border-radius: 4px;margin:2px' onclick='switchAmmeter("+rowData.id+",1)'>拉闸</button>";
						als+= "<button type='button' style='width: 80px;height: 25px;cursor:pointer;border-radius: 4px;margin:2px;' onclick='switchAmmeter("+rowData.id+",2)'>合闸</button>";
				 	return als;
				}
			},
			{title: '曲线', field: 'showCurve', width:'80px',
				formatter:function(value, rowData, rowIndex){
					var als="";
						als+= "<button type='button' style='width: 80px;height: 25px;cursor:pointer;border-radius: 4px;margin:2px' onclick=\"showCurve('"
						+rowData.id+"','"+rowData.ammeterName +"')\">查看</button>";
				 	return als;
				}
			},
			{title: '电表名称', field: 'ammeterName', width:'80px'},
			{title: '表号', field: 'ammeterCode', width:'80px'},
			{title: '安装位置', field: 'installAddress', width:'80px'},
			{title: '所属集中器', field: 'concentratorName', width:'80px'},
	        {title: '组织机构', field: 'organizationName', width:'80px'},
	        {title: '生产厂家', field: 'produce', width:'80px'},
	        {title: '生产日期', field: 'produceTime', width:'80px'},
	        {title: '创建人', field: 'createPerson', width:'80px'},
	        {title: '创建时间', field: 'createTime', width:'80px'},
	        {title: '所属表箱', field: 'boxName', width:'80px'},
	        {title: '电表型号', field: 'ammeterType', width:'80px'},
	        {title: '软件版本号', field: 'softType', width:'80px'},
	        {title: '硬件版本号', field: 'hardType', width:'80px'}
	        ]]
	});
}

//在弹出框中显示e锁
function getElockData(type,id){
	setFirstPage($("#elockListTbl"));
	$('#elockListTbl').datagrid({
		url :basePath + '/mbAieLock/queryAielockByTree?Math.random()', 
		queryParams: {
			type : type,
		 	gid : id
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
		columns : [ [
			{
			title : 'id',
			field : 'id',
			width : '200px',
			hidden:true
		}, {
			title : '锁名称',
			field : 'lockName',
			width : '180px'
		}, {
			title : '所属表箱',
			field : 'boxName',
			width : '180px'
		}, {
			title : '锁编号',
			field : 'lockCode',
			width : '100px'
		}, {
			title : '组织机构',
			field : 'organizationName',
			width : '120px'
		}, {
			title : '生产厂家',
			field : 'produce',
			width : '100px'
		}, {
			title : '生产日期',
			field : 'produceTime',
			width : '120px'
		},{
			title : '创建人',
			field : 'createPerson',
			width : '80px'
		}, {
			title : '创建时间',
			field : 'createTime',
			width : '100px'
		}, {
			title : 'apikey',
			field : 'apikey',
			width : '80px'
		}, {
			title : 'IMEI',
			field : 'imei',
			width : '80px'
		}, {
			title : 'IMSI',
			field : 'imsi',
			width : '80px'
		}, {
			title : '序列号',
			field : 'serialnumber',
			width : '80px'
		}, {
			title : '密码',
			field : 'password',
			width : '80px'
		}, {
			title : 'mac',
			field : 'mac',
			width : '90px'
		},
		{title: '操作', field: 'openStatus', width:'100px',
			formatter:function(value, rowData, rowIndex){
				var als="";
					als+= "<button type='button' style='width: 40px;height: 25px;cursor:pointer;border-radius: 4px;margin:2px;' onclick='openLock("+rowData.id+","+rowData.apikey+","+rowData.imei+")'>开锁</button>";
					als+= "<button type='button' style='width: 40px;height: 25px;cursor:pointer;border-radius: 4px;margin:2px;' onclick='closeLock("+rowData.id+","+rowData.apikey+","+rowData.imei+")'>关锁</button>";
			 	return als;
			}
		}] ]
	});
}


//开锁
function openLock(id,apikey,imei){
	$.ajax({
	    type:'POST', 
      url:basePath + '/mbAieLock/queryAielockOpenStatus?Math.random()',           
      data:{id: id,apikey:apikey,imei:imei},
      async:false,
	    success:function(data){
	    	alert(data);
	    },	        
	    error:function(data){
      }
	});
}


//关锁
function closeLock(id,apikey,imei){
	$.ajax({
	  type:'POST', 
      url:basePath + '/mbAieLock/queryAielockCloseStatus?Math.random()',           
      data:{id: id,apikey:apikey,imei:imei},
      async:false,
	    success:function(data){
	    	alert(data);
	    },	        
	    error:function(data){
      }
	});

}

//在弹出框中显示断路器列表
function showBreaker(){
	var id = $("#boxid").val();
	if (id == "") return;
	$(".concentratorInfo").hide();
	$(".elockList").hide();
	$(".ammeterList").hide();
	$(".breakerList").show();
	$(".terminalList").hide();
	$(".virtualInfo").hide();
	getBreakerData(3,id);
}

function getBreakerData(type,id){
	setFirstPage($("#breakerListTbl"));
	$('#breakerListTbl').datagrid({
		url :basePath + '/mbBlueBreaker/queryBlueBreakerByTree?Math.random()', 
		queryParams: {
			type : type,
		 	gid : id
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
		columns : [ [
			{
			title : 'id',
			field : 'id',
			width : '200px',
			hidden:true
		}, {
			title : '组织机构',
			field : 'organizationName',
			width : '180px'
		}, {
			title : '所属表箱',
			field : 'boxName',
			width : '180px'
		}, {
			title : '断路器名称',
			field : 'breakerName',
			width : '200px'
		}, {
			title : '断路器编号 ',
			field : 'breakerCode',
			width : '120px'
		}, {
			title : '生产厂家',
			field : 'produce',
			width : '100px'
		}, {
			title : '生产日期',
			field : 'produceTime',
			width : '120px'
		},{
			title : '创建人',
			field : 'createPerson',
			width : '100px'
		}, {
			title : '创建时间',
			field : 'createTime',
			width : '100px'
		}, {
			title : '型号',
			field : 'breakerType',
			width : '100px'
		}, {
			title : '关联电表',
			field : 'ammeterName',
			width : '100px'
		}] ]
	});
}
function closeBreakerList(){
	$("#breakerListTbl").datagrid('loadData',{total:0,rows:[]});
	$(".breakerList").hide();
}

//在弹出框中显示终端列表
function showTerminalList(){
	var id = $("#boxid").val();
	if (id == "") return;
	$(".virtualInfo").hide();
	$(".concentratorInfo").hide();
	$(".ammeterList").hide();
	$(".breakerList").hide();
	$(".elockList").hide();
	$(".terminalList").show();
	showTerminalData(id);
}

function closeTerminalList(){
	$("#terminalListTbl").datagrid('loadData',{total:0,rows:[]});
	$(".terminalList").hide();
}

//在弹出框中显示终端列表
function showTerminalData(id){
	setFirstPage($("#terminalListTbl"));
	//终端列表
	$('#terminalListTbl').datagrid({
		url :basePath + '/terminal/getDataGrid?Math.random()', 
		queryParams: {
			type : 3,
		 	id : id
		},
		pagination : true,//分页控件
		pageList: [10, 20, 30, 40, 50],
		fit: true,   //自适应大小
		singleSelect: true,
		//iconCls : 'icon-save',
		border:false,
		nowrap: true,//数据长度超出列宽时将会自动截取。
		rownumbers:true,//行号
		fitColumns:true,//自动使列适应表格宽度以防止出现水平滚动。
		columns : [ [{
			title : '终端名称',
			field : 'terminalName',
			width : '180px'
		}, {
			title : '终端地址',
			field : 'address',
			width : '200px',						
		}, {
			title : '安装位置',
			field : 'installationLocation',
			width : '200px'
		}, {
			title : '所属集中器',
			field : 'concentratorName',
			width : '120px'
		}, {
			title : '组织机构',
			field : 'organizationName',
			width : '120px'
		}, {
			title : '生产厂家',
			field : 'manufacturer',
			width : '100px'
		}, {
			title : '生产日期',
			field : 'produceDate',
			width : '100px'
		}, {
			title : '创建人',
			field : 'creater',
			width : '100px'
		}, {
			title : '创建日期',
			field : 'createDate',
			width : '100px'
		}, {
			title : '所属表箱',
			field : 'measureName',
			width : '100px'
		}, {
			title : '终端型号',
			field : 'terminalType',
			width : '100px'
		}, {
			title : '软件版本号',
			field : 'softType',
			width : '100px'
		}, {
			title : '硬件版本号',
			field : 'hardType',
			width : '100px'
		}] ]
	});
}

//三维表箱弹出框
//在弹出框中显示三维模型
function showVirtualInfo(){
	var boxid = $("#boxid").val();
	if (boxid == "") return;
	$(".virtualInfo").show();
	$(".concentratorInfo").hide();
	$(".ammeterList").hide();
	$(".breakerList").hide();
	$(".elockList").hide();
	$(".terminalList").hide();
	//加载表箱三维模型
	refreshThreeWindow();
	box.clear();
    addBox(boxid, $('#measureNumber').html(), $('#boxname').html());
}

//刷新三维渲染
function refreshThreeWindow(){
	 var HEIGHT = container.clientHeight;		// 更新渲染器的高度和宽度以及相机的纵横比
	 var WIDTH = container.clientWidth;
	 camera.aspect = WIDTH / HEIGHT;
	 camera.updateProjectionMatrix();
	 renderer.setSize( WIDTH, HEIGHT );
}

/*
*	根据表箱id添加表箱模型
*	@param {String} boxId 表箱id
*/
function addBox(boxId, boxNumber, boxName){	
	meterGroup = [];
	terminalGroup = [];
	box.load(boxId, boxNumber, boxName);
	//获取e锁
	$.ajax({
	 	type:'POST', 
     	url:basePath + '/virtualBox/getElockByBoxId',           
     	data:{"id":boxId},
     	//async:false,
        success:function(data){
    	    if(data && data.id){
    	    	box.addLock([0.6, 0.3, 1], [0.65, 2.2, 0.5], [Math.PI/2, 0, 0], 'elock', 'close', data);
    	    	var elock = boxGroup.getObjectByName("elock");
    	    	if(data.openStatus > 0){ //打开状态
    	    		setTimeout(function(){
    	    			openElock(data.mac);
    	    		}, 2000);
    	    		
    	    		//获取表箱门状态
    	    		$.ajax({
    	    		 	type:'POST', 
    	    	     	url:basePath + '/virtualBox/getBoxByBoxId',           
    	    	     	data:{"id":boxId},
    	    	     	//async:false,
    	    	        success:function(d){
    	    	    	    if(d && d.measureId){
    	    	    	    	if(d.openStatus > 0){ //表箱打开状态
    	    	    	    		setTimeout(function(){
    	    	    	    			openDoor(boxNumber);
    	    	    	    		}, 2000);
    	    	    	    	}
    	    	    	    }
    	    	        },	        
    	    	        error:function(data){
    	    	        }
    	    	    });
    	    	}
    	    }
        },	        
        error:function(data){
        }
    });
	//获取集中器
	$.ajax({
	 	type:'POST', 
     	url:basePath + '/virtualBox/getConcentratorByBoxId',           
     	data:{"id":boxId},
     	//async:false,
        success:function(data){
    	    if(data && data.concentratorId){
    	    	box.addConcentrator([1.6,0.8,2.2], [3.3,0,-3.2], [0,0,0], "concentrator", data);
    	    }
        },	        
        error:function(data){
        }
    });
	//获取监测终端
	$.ajax({
	 	type:'POST', 
     	url:basePath + '/virtualBox/getTerminalByBoxId',           
     	data:{"id":boxId},
     	//async:false,
        success:function(data){
    	    if(data && data.terminalId){
    	    	terminalGroup.push(data.address);
    	    	//alert(data.address)
    	    	box.addTerminal([2.5,0.8,1.5], [3.2,0,-0.7], [0,0,0], "terminal", data);
    	    	//接线
    	    	box.addWire([[3.8, 0.7, 0.75], [3.8, 0.7, 0]], 0.02, 0xBCAA39, data.address + 'line1');
    	    	box.addWire([[3.77, 0.7, 0.75], [3.77, 0.7, 0]], 0.02, 0xBCAA39, data.address + 'line2');
    	    	box.addWire([[3.785, 0.7, 1], [3.785, 0.7, 0.75]], 0.04, 0x000000, data.address + 'head1');
    	    	box.addWire([[3.25, 0.7, 0.75], [3.25, 0.7, 0]], 0.02, 0x568263, data.address + 'line3');
    	    	box.addWire([[3.22, 0.7, 0.75], [3.22, 0.7, 0]], 0.02, 0x568263, data.address + 'line4');
    	    	box.addWire([[3.235, 0.7, 1], [3.235, 0.7, 0.75]], 0.04, 0x000000, data.address + 'head2');
    	    	box.addWire([[2.7, 0.7, 0.75], [2.7, 0.7, 0]], 0.02, 0x862f32, data.address + 'line5');
    	    	box.addWire([[2.67, 0.7, 0.75], [2.67, 0.7, 0]], 0.02, 0x862f32, data.address + 'line6');
    	    	box.addWire([[2.685, 0.7, 1], [2.685, 0.7, 0.75]], 0.04, 0x000000, data.address + 'head3');
    	    	getTerminalData();
    	    }
        },	        
        error:function(data){
        }
    });
	//获取电表
	$.ajax({
	 	type:'POST', 
     	url:basePath + '/virtualBox/getAmmeterByBoxId',           
     	data:{"id":boxId},
     	//async:false,
        success:function(data){
    	    if(data){
    	    	$.each(data, function(i, n){
    	    		meterGroup.push(n.ammeterCode);
    	    		switch (n.installAddress.toString()){
	    	    		case '1':
		    				box.addMeter([1.5, 0.8, 2.5], [-1.2,0,4.2], [0,0,0], "meter" + n.ammeterCode, n);
		    				//接线
		    				box.addWire([[-0.75, 0, 2.9], [-0.75, 0.4, 2.9], [-0.75, 0.4, 3.4]], 0.04, 0x862f32, n.ammeterCode + 'line1');
		    				box.addWire([[-1.05, 0, 2.9], [-1.05, 0.4, 2.9], [-1.05, 0.4, 3.4]], 0.04, 0x862f32, n.ammeterCode + 'line2');
		    				box.addWire([[-1.35, 0, 2.9], [-1.35, 0.4, 2.9], [-1.35, 0.4, 3.4]], 0.04, 0x2357A0, n.ammeterCode + 'line3');
		    				box.addWire([[-1.65, 0, 2.9], [-1.65, 0.4, 2.9], [-1.65, 0.4, 3.4]], 0.04, 0x2357A0, n.ammeterCode + 'line4');
		    				break;
		    			case '2':
		    				box.addMeter([1.5, 0.8, 2.5], [-3.3,0,4.2], [0,0,0], "meter" + n.ammeterCode, n);
		    				//接线
		    				box.addWire([[-2.85, 0, 2.9], [-2.85, 0.4, 2.9], [-2.85, 0.4, 3.4]], 0.04, 0x862f32, n.ammeterCode + 'line1');
		    				box.addWire([[-3.15, 0, 2.9], [-3.15, 0.4, 2.9], [-3.15, 0.4, 3.4]], 0.04, 0x862f32, n.ammeterCode + 'line2');
		    				box.addWire([[-3.45, 0, 2.9], [-3.45, 0.4, 2.9], [-3.45, 0.4, 3.4]], 0.04, 0x2357A0, n.ammeterCode + 'line3');
		    				box.addWire([[-3.75, 0, 2.9], [-3.75, 0.4, 2.9], [-3.75, 0.4, 3.4]], 0.04, 0x2357A0, n.ammeterCode + 'line4');
		    				break;
		    			case '3':
		    				box.addMeter([1.5, 0.8, 2.5], [-1.2,0,0.9], [0,0,0], "meter" + n.ammeterCode, n);
		    				//接线
		    				box.addWire([[-0.75, 0, -0.4], [-0.75, 0.4, -0.4], [-0.75, 0.4, 0.1]], 0.04, 0x568263, n.ammeterCode + 'line1');
		    				box.addWire([[-1.05, 0, -0.4], [-1.05, 0.4, -0.4], [-1.05, 0.4, 0.1]], 0.04, 0x568263, n.ammeterCode + 'line2');
		    				box.addWire([[-1.35, 0, -0.4], [-1.35, 0.4, -0.4], [-1.35, 0.4, 0.1]], 0.04, 0x2357A0, n.ammeterCode + 'line3');
						    box.addWire([[-1.65, 0, -0.4], [-1.65, 0.4, -0.4], [-1.65, 0.4, 0.1]], 0.04, 0x2357A0, n.ammeterCode + 'line4');
		    				break;
		    			case '4':
		    				box.addMeter([1.5, 0.8, 2.5], [-3.3,0,0.9], [0,0,0], "meter" + n.ammeterCode, n);
		    				//接线
		    				box.addWire([[-2.85, 0, -0.4], [-2.85, 0.4, -0.4], [-2.85, 0.4, 0.1]], 0.04, 0x568263, n.ammeterCode + 'line1');
		    				box.addWire([[-3.15, 0, -0.4], [-3.15, 0.4, -0.4], [-3.15, 0.4, 0.1]], 0.04, 0x568263, n.ammeterCode + 'line2');
		    				box.addWire([[-3.45, 0, -0.4], [-3.45, 0.4, -0.4], [-3.45, 0.4, 0.1]], 0.04, 0x2357A0, n.ammeterCode + 'line3');
		    				box.addWire([[-3.75, 0, -0.4], [-3.75, 0.4, -0.4], [-3.75, 0.4, 0.1]], 0.04, 0x2357A0, n.ammeterCode + 'line4');
		    				break;
		    			case '5':
		    				box.addMeter([1.5, 0.8, 2.5], [-1.2,0,-2.4], [0,0,0], "meter" + n.ammeterCode, n);
		    				//接线
		    				box.addWire([[-0.75, 0, -3.7], [-0.75, 0.4, -3.7], [-0.75, 0.4, -3.2]], 0.04, 0xBCAA39, n.ammeterCode + 'line1');
		    				box.addWire([[-1.05, 0, -3.7], [-1.05, 0.4, -3.7], [-1.05, 0.4, -3.2]], 0.04, 0xBCAA39, n.ammeterCode + 'line2');
		    				box.addWire([[-1.35, 0, -3.7], [-1.35, 0.4, -3.7], [-1.35, 0.4, -3.2]], 0.04, 0x2357A0, n.ammeterCode + 'line3');
		    				box.addWire([[-1.65, 0, -3.7], [-1.65, 0.4, -3.7], [-1.65, 0.4, -3.2]], 0.04, 0x2357A0, n.ammeterCode + 'line4');
		    				break;
		    			case '6':
		    				box.addMeter([1.5, 0.8, 2.5], [-3.3,0,-2.4], [0,0,0], "meter" + n.ammeterCode, n);
		    				//接线
		    				box.addWire([[-2.85, 0, -3.7], [-2.85, 0.4, -3.7], [-2.85, 0.4, -3.2]], 0.04, 0xBCAA39, n.ammeterCode + 'line1');
		    				box.addWire([[-3.15, 0, -3.7], [-3.15, 0.4, -3.7], [-3.15, 0.4, -3.2]], 0.04, 0xBCAA39, n.ammeterCode + 'line2');
		    				box.addWire([[-3.45, 0, -3.7], [-3.45, 0.4, -3.7], [-3.45, 0.4, -3.2]], 0.04, 0x2357A0, n.ammeterCode + 'line3');
		    				box.addWire([[-3.75, 0, -3.7], [-3.75, 0.4, -3.7], [-3.75, 0.4, -3.2]], 0.04, 0x2357A0, n.ammeterCode + 'line4');
		    				break;
    	    		}
    	    	})
    	    	//获取电表数据
	    		getMeterData();
    	    }
        },	        
        error:function(data){
        }
    });
	
	//获取蓝牙断路器
	$.ajax({
	 	type:'POST', 
     	url:basePath + '/virtualBox/getBreakerByBoxId',           
     	data:{"id":boxId},
     	//async:false,
        success:function(data){
    	    if(data){
    	    	$.each(data, function(i, n){
    	    		switch (n.installAddress.toString()){
    	    			case '1':
    	    				box.addMeterBreaker([1, 1, 1.2], [0,0,-4.8], [0,0,0], "meterbreaker" + n.ammeterAddress, 
    	    						n.openStatus == 0 ? "off" : "on", n);
    	    				break;
    	    			case '2':
    	    				box.addMeterBreaker([1, 1, 1.2], [-0.8,0,-4.8], [0,0,0], "meterbreaker" + n.ammeterAddress, 
    	    						n.openStatus == 0 ? "off" : "on", n);
    	    				break;
    	    			case '3':
    	    				box.addMeterBreaker([1, 1, 1.2], [-1.6,0,-4.8], [0,0,0], "meterbreaker" + n.ammeterAddress, 
    	    						n.openStatus == 0 ? "off" : "on", n);
    	    				break;
    	    			case '4':
    	    				box.addMeterBreaker([1, 1, 1.2], [-2.4,0,-4.8], [0,0,0], "meterbreaker" + n.ammeterAddress, 
    	    						n.openStatus == 0 ? "off" : "on", n);
    	    				break;
    	    			case '5':
    	    				box.addMeterBreaker([1, 1, 1.2], [-3.2,0,-4.8], [0,0,0], "meterbreaker" + n.ammeterAddress, 
    	    						n.openStatus == 0 ? "off" : "on", n);
    	    				break;
    	    			case '6':
    	    				box.addMeterBreaker([1, 1, 1.2], [-4,0,-4.8], [0,0,0], "meterbreaker" + n.ammeterAddress, 
    	    						n.openStatus == 0 ? "off" : "on", n);
    	    				break;
    	    		}
    	    	})
    	    }
        },	        
        error:function(data){
        }
    });
	
	//初始化告警动画
	var alarmDivArray = window.parent.getBoxCurrentAlarm(boxId);
	if (alarmDivArray && alarmDivArray.length > 0){
		$.each(alarmDivArray, function(i, item){
			var oadOI = item.find("input[name='oadOI']").val();
			switch (oadOI){
			case "FF28": //剩余电流超限
				//var deviceType = item.find("input[name='deviceType']").val();
				//var deviceAddress = item.find("input[name='deviceAddress']").val();
				setTransformerAlarm(true);
				break;
			case "FF27": //烟雾事件
				addFire([0,0,5]);
				break;
			case "3060": //表计错位
				var meterAddress = item.find("input[name='deviceAddress']").val();
				setTimeout(function(){
					setMeterAlarm(meterAddress, true);
				}, 1000);
				break;
			case "3035": //误差自检事件
				var meterAddress = item.find("input[name='deviceAddress']").val();
				var data = item.find("input[name='valueText']").val(); 
				setTimeout(function(){
					setMeterErrorAlarm(meterAddress, data, true);
				}, 1000);
				break;
			case "3032": //端子过温
				var deviceType = item.find("input[name='deviceType']").val();
				var deviceAddress = item.find("input[name='deviceAddress']").val();
				var data = item.find("input[name='valueText']").val(); 
				var lineIndex = item.find("input[name='lineIndex']").val(); 
				if (deviceType == "meter"){ //电表
					var data = item.find("input[name='valueText']").val(); 
					setTimeout(function(){
						setMeterLineAlarm(deviceAddress, lineIndex, data, true);
					}, 1000);
				}
				else if (deviceType == "terminal"){ //监测终端
					var data = item.find("input[name='valueText']").val(); 
					setTimeout(function(){
						setTerminalLineAlarm(deviceAddress, lineIndex, data, true);
					}, 1000);
				}
				break;
			}
		})
	}
}

/*
*	遍历加载的表，分别获取其屏幕示数
*	@param {String} boxId 表箱id
*/
function getMeterData(){
	$.each(meterGroup, function(i, n){
		$.ajax({
		 	type:'POST', 
	     	url:basePath + '/virtualBox/getMeterData',           
	     	data:{"meterAddr": n},
	        success:function(data){
	    	    if(data){
	    	    	setMeterValue(n, data);
	    	    }
	        },	        
	        error:function(data){
	        }
	    });
	})
}

/*
*	遍历加载的监测终端，分别获取其屏幕示数
*	@param {String} boxId 表箱id
*/
function getTerminalData(){
	$.each(terminalGroup, function(i, n){
		$.ajax({
		 	type:'POST', 
	     	url:basePath + '/virtualBox/getTerminalData',           
	     	data:{"terminalAddr": n},
	        success:function(data){
	    	    if(data){
	    	    	setTerminalValue(n, data.ambienttemperature, data.barometricPressure, data.humidness);
	    	    }
	        },	        
	        error:function(data){
	        }
	    });
	})
}

function closeVirtualInfo(){
	$(".virtualInfo").hide();
}

function showCurve(equipmentid,equipmentname){
	equipmentname=encodeURI(encodeURI(equipmentname));
	window.open('ammeterAnalysis?type=realtime&nodetype=6&id='+equipmentid, equipmentname+'-实时曲线', 'height=450, width=900, top=0, left=0, toolbar=no, menubar=no, scrollbars=yes, resizable=no, location=no, status=no');   //该句写成一行代码
}

function switchAmmeter(id,action){
	if(action==1){//拉闸 
		$.ajax({
		 	type:'POST', 
	     	url:basePath + '/mbAmmeter/switchAmmeter?Math.random()',           
	     	data:{"id": id,funFlag:129},//129-跳闸 130- 合闸
	        success:function(data){
	    	    //alert(data);
	    	    window.parent.ws.onaction(data);
	        },	        
	        error:function(data){
	        }
	    });
		//1.组帧  发送拉闸消息给前置机
		//2.修改表里状态
		//3.三维拉闸接口调用
	}else if(action==2){//合闸
		$.ajax({
		 	type:'POST', 
	     	url:basePath + '/mbAmmeter/switchAmmeter?Math.random()',           
	     	data:{"id": id,funFlag:130},//129-跳闸 130- 合闸
	        success:function(data){
	    	    //alert(data);
	    	    window.parent.ws.onaction(data);
	        },	        
	        error:function(data){
	        	 //alert(data);
	        }
	    });
	}
}
