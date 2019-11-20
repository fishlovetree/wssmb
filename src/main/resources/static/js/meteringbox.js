//获取图表数据
var alarmtype = [], alarmname = [];
function getCurveData() {
	var params={};
	$.ajax({
	   	url: basePath + '/meteringbox/getData?Math.random()',
	   	data:params,
	   	type:"post",
	   	success:function(d){
	   		if(d!=""){
	   			//月告警曲线-近30日告警趋势
		   		var list=JSON.parse(d.list);
				var listcount=d.listcount;

				var occurtime = [], num = [];
				for(var i=1;i<=listcount;i++){
					var n=list[i];
			    	occurtime.push(n.OCCURTIME);	//时间
			    	num.push(n.NUM);	//日告警总数
			    	
			    	if(i==listcount) todayalarmcount=n.NUM;
				}
			    
			    if(occurtime.length>0){
			    	lineChart.clear();
			    	lineChart.setOption(
		    			{
		    				tooltip : {
		    			        trigger: 'axis',
		    			        axisPointer : { // 坐标轴指示器，坐标轴触发有效
		    						type : 'shadow' // 默认为直线，可选为：'line' | 'shadow' 
		    					}
		    			    },
		    			    grid:{show:'true',borderWidth:'0',x:45,y:35,x2:45,y2:30},
		    				calculable : false,
		    				toolbox: {    //工具栏显示             
			                    show: false,
			                },
		    				legend : {
		    					x : 'center',
		    					data : ['告警数'],
		    					y : 15
		    				},
		    				xAxis : [ {
		    					type : 'category',
		    					name : '时间',
		    					boundaryGap : false,//曲线开始位置，false从原点开始，true从节点中间开始
		    					data : occurtime,
		    					splitLine:{show: false},//去除网格线
		    				} ],
		    				yAxis : [ { 
		    					type : 'value', 
		    					name : '总数（次）',
		    					splitLine:{show: false},//去除网格线
		    					splitNumber:3,
		    					scale: true
		    				} ],
		    				series : [
	    						{
	    							name : '告警数',
	    							type : 'line',
	    							data:num
	    						}
	               		    ]
	               		}
	   		   		);  // setOption
			    }

			    //今日告警
			    list=JSON.parse(d.todayalarm);
				listcount=d.todayalarmcount;
				
			    alarmChart.clear();
			    var option = {};
			    var alarmdata=[], legendData=[];
			    var alarmsum = 0;
			    alarmtype = [], alarmname = [];
				for(var i=1;i<=listcount;i++){
					var n=list[i];
					alarmtype.push(n.ALARMTYPE);
					alarmname.push(n.ALARMNAME);
					
					legendData.push(n.ALARMNAME);
					alarmdata.push({value:n.NUM, name:n.ALARMNAME});
			    	alarmsum += n.NUM;
				}
				if(alarmsum==0){
					legendData.push("今日告警");
					alarmdata.push({value:alarmsum, name:'今日告警'});
				}
				option = {
					title: {
				    	x: 'right',
				    	y: 'center',
				    	text: "告\n警\n总\n数\n"+alarmsum,
				        textStyle : {
				            fontSize : 14,
                            color:'#55e0ed',
                            textAlign:'center',
                            fontWeight: 'normal'
				        }
				    },
				    tooltip: {
				        trigger: 'item',
				        formatter: "{a} <br/>{b}: {c} ({d}%)"
				    },
				    legend: {
				        data: legendData
				    },
				    series : [
				        {
				            name: '今日告警',
				            type: 'pie',
				            radius : ['45%', '65%'],
				            center: ['50%', '55%'],
				            data:alarmdata
				        }
				    ]
				};
		   		alarmChart.setOption(option);
		   		alarmChart.on("click", aChartClick);
				option={};
					
				//今日隐患
				dangerChart.clear();
				option = {
					title: {
				        text: '总  数\n'+0,
				        left: '23%',
				        top: '52%',
				        textAlign:'center'
				    },
				    tooltip: {
				    	show: false
				    },
           		    toolbox: {    //工具栏显示             
	                     show: true,
	                     feature: { 
	                    	 myTool:{//自定义按钮 danielinbiti,这里增加，myTool2可以随便取名字    
	                            show : true, 
	                            title : '还原',
	                            icon: "image://"+basePath + "/images/refresh2.png", //图标   
                                onclick:function() {//点击事件,这里的option1是chart的option信息    
                                	getCurveData();
                                }
                         	}
	                     },
	                     right : 0,
	                     bottom : 0
	                 },
				    legend: {
				    	type: 'scroll',
           		        orient: 'vertical',
           		        right: 0,
           		        top: 10,
           		        bottom: 10,
           		        data: ['今日隐患'],
           		 		selectedMode:false,
           		        pageIconColor: '#55e0ed' ,
           		        pageIconInactiveColor : '#aaa',
           		        pageTextStyle : {
           		            color:'#55e0ed'
           		        }
				    },
				    series: [
				        {
				        	name:'隐患数',
		                    type:'pie',
		                    radius: ['40%', '60%'],
           		            center: ['25%', '60%'],
				            label: {
				                normal: {
				                    show: false
				                }
				            },
				            labelLine: {
				                normal: {
				                    show: false
				                }
				            },
				            data:[
				                {value:0, name:'今日隐患'}
				            ]
				        }
				    ]
				};
				dangerChart.setOption(option);
				
				option={};
		    }
	   	},
	   	error:function(e){
	   		$.messager.alert('警告','连接服务器失败。', 'warning');
	   	}
	});	
							
} 

//图表添加监听时间
function aChartClick(param){
	var type="";
	var Name = param.name;
	var result= $.inArray(Name, alarmname);
	if(result!=-1)
		type=alarmtype[result];
	
	$("#warntype").val(type);
	doLoadAlarm();
}

//在地图中定位用户
function findCustomer(node) {
	if(node.type == 2){
		fly(node.gid);
	}else if(node.type == 3){			//行政区域的区域
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
	
	}else if(node.type == 1){			//组织机构的机构
		var organizationid = node.gid;
		$.ajax({
		    type:'POST', 
	        url: basePath + '/region/selectRegionByOrgId?Math.random()',           
	        data:{"orgid":organizationid},
	        success:function(data){
	        	var region = eval("("+data+")");
	        	if(region && region.extent){
	        		var extent = eval("("+region.extent+")")
	        		fitExtent(extent);
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
//初始化二维地图
function initMap(){
	var parentCenter;
	if(customerLonlat != ""){
		if(/^\d+(\.\d+)?\,\d+(\.\d+)?$/.test(customerLonlat)){
			parentCenter = customerLonlat.split(",");
		}
	}
	if(customerRegion != ""){
		if(/^\d+(\.\d+)?\,\d+(\.\d+)?$/.test(customerRegion)){
			parentCenter = customerRegion.split(",");
		}
	}
	//地图加载
	var mapOpt = {
        mapStyle: 'amap://styles/e669bfcd88d5760c202fa10ef1f07346', //设置地图的显示样式
        resizeEnable: true		//设置可调整大小
    }
	if(parentCenter){
		mapOpt.center = parentCenter;
		mapOpt.zoom = 17;
	}else{
		mapOpt.center = initCenter;
		mapOpt.zoom = 17;
	}
    map = new AMap.Map("map", mapOpt); 
}

//初始化告警用户
function initAnimateMarker(){
	animateMarker = new FlashMarker(map,[]);
	troubleAnimateMarker = new FlashMarker(map,[]);
	offlineAnimateMarker = new FlashMarker(map,[]);
}

//添加用户告警动画效果
function addCustomerAlarm(cusObj){
	if(!animateMarker) return;
	for(var item in alarmCustomerObj){			//移除消失的告警
		if(!cusObj[item]){
			animateMarker.removeMarkerById(item);
			alarmCustomerObj[item] = null;
		}
	}
	for(var item in cusObj){					//增加告警
		if(!alarmCustomerObj[item]){
			if(customerMarkersObj[item]){
				var lonlat = customerMarkersObj[item].getPosition();
				animateMarker.addMarkerToMap({lonlat:lonlat,markerId:item});
				alarmCustomerObj[item] = item;
			}
		}
	}
	
	var cusCoords = [];
	for(var item in alarmCustomerObj){
		if(customerMarkersObj[item]){
			var lonlat = customerMarkersObj[item].getPosition();
			cusCoords.push(lonlat);
		}
	}
	
	if(cusCoords.length != 0){
		if(cusCoords.length == 1){
			var center = cusCoords[0]
			map.setZoomAndCenter(18, center);
		}else{
			var testLine = new AMap.Polyline({path:cusCoords});
			var bounds = testLine.getBounds();
			map.setBounds(bounds);
		}
	}
}

var customerMarkersObj = {};			//保存所有的用户图标要素
//查询所有的用户和告警情况，并添加到地图上
//function queryAllUsers(){
//	$.ajax({
//	    type:'POST', 
//        url:basePath + '/visualization/getCustomerFileList?Math.random()',           
//       data:{},
//        success:function(data){
//    	    if (data){
//    		    var dataObj = eval("("+data+")");
//    		    var customerMarkers = [];
//    		    $.each(dataObj, function(i, n){
//    		    	customer_list.push(n.name);
    		    	//在地图上添加-用户标记
//    		    	if(/^\d+(\.\d+)?$/.test(n.longitude) &&  /^\d+(\.\d+)?$/.test(n.latitude)){
 //   		    		var marker = new AMap.Marker({
 //   		    			position: [Number(n.longitude),Number(n.latitude)],
 //   		    			icon: basePath+'/images/gis/customer.png',
  //  		    			offset: new AMap.Pixel(-17, -17),	//默认(-10,-34)
   // 		    			label:{
  //      		    			offset: new AMap.Pixel(20, 40),
    //    		    			content: "<div class='info'>"+n.name+"</div>"
    	//	    		    }/*,
    		//    		    zIndex:1*/
		    	//	    });
    		    	//	marker.on('click',function(){
    		    		//	showUserInfo(n.customerid);			//设置弹出框事件
//    		    		})
 //   		    		marker.on('mouseover',markerOver)
 //   		    		marker.on('mouseout',markerOut)
  //  		    		customerMarkers.push(marker);
   // 		    		customerMarkersObj[n.customerid] = marker;
   // 		    	}
   // 		    });		    
   // 		    map.add(customerMarkers);
    		    
    //		    map.on("complete",function(){	//地图模块加载完成
 //   		    	initAnimateMarker();		//初始化告警和故障动画效果对象
 //   		    	addCustomerAlarm(parent.customerIdObj); //添加告警动画效果
 //   		    })    		    
//    	   }
 //      },	        
 //      error:function(data){

 //       }
 //	})
//}

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
 * 跳转到地图上的客户点
 * @param {String} customerid 用户id
 */
function fly(customerid){
	if(!customerid) return;
	var marker = customerMarkersObj[customerid];
	if(marker){
		var pos = marker.getPosition();
		map.setZoomAndCenter(18, [pos.lng, pos.lat]);		//高德地图
	}  	
}

/*******************************************************************************************************
 ** 弹出框相关
 *******************************************************************************************************/

//在弹出框中显示用户信息
function showUserInfo(id){
	$.ajax({
	    type:'POST', 
        url:basePath + '/meteringbox/getCustomerById?Math.random()',           
        data:{ id: id},
        async: false,
        success:function(data){
  	        if (data){
	  	    	$('#customerid').val(id);
    			$('#customername').html(data.name);
    			$('#address').html(data.address);
    			if(null!=data.legalrepresentative){
	    			$('#legalrepresentative').html(data.legalrepresentative.name);
	    			$('#phone').html(data.legalrepresentative.phone);
    			}
    			else{
    				$('#legalrepresentative').html("");
        			$('#phone').html("");
    			}
    			
    			//定义全景图按钮是否显示
    			$.ajax({
    		 	    type:'POST', 
    		        url:basePath + '/visualization/getVrCount?Math.random()',           
    		        data:{customerid: id},
    		        async:false,
    		 	    success:function(data){
    		 	    	if (data == '0'){
    		 	    		$('#vrBtn').hide();
    			 	    }
    		 	    	else{
    		 	    		$('#vrBtn').show();
    		 	    	}
    		 	    },	        
    		 	    error:function(data){
    		        }
    		 	});
    			
    			//定义楼层图按钮是否显示
    			$.ajax({
    		 	    type:'POST', 
    		        url:basePath + '/visualization/getModelCount?Math.random()',           
    		        data:{customerid: id},
    		        async:false,
    		 	    success:function(data){
    		 	    	if (data == '0'){
    		 	    		$('#floorBtn').hide();
    			 	    }
    		 	    	else{
    		 	    		$('#floorBtn').show();
    		 	    	}
    		 	    },	        
    		 	    error:function(data){
    		        }
    		 	});
    			
    			$(".userBox").show();

    			//在弹出框中显示用户设备
    			showDeviceInfo();
  	        }
        },	        
        error:function(data){
        }
	})
}

function closeUserInfo(){
	$('.userBox').hide();
}

//在弹出框中显示用户设备
function showDeviceInfo(){
	var id = $("#customerid").val();
	if (id == "") return;
	$(".vrInfo").hide();
	$(".videoInfo").hide();
	$(".floorInfo").hide();
	$(".linkInfo").hide();
	$(".deviceList").hide();
	$(".videoList").hide();
	$(".alarmList").hide();
	$(".unonlineList").hide();
}

//在弹出框中显示用户设备列表
function showDeviceList(){
	var id = $("#customerid").val();
	if (id == "") return;
	$(".vrInfo").hide();
	$(".videoInfo").hide();
	$(".floorInfo").hide();
	$(".linkInfo").hide();
	$(".deviceList").show();
	$(".videoList").hide();
	$(".alarmList").hide();
	$(".unonlineList").hide();
	getDeviceData(2,id);
}

function closeDeviceList(){
	$("#deviceListTbl").datagrid('loadData',{total:0,rows:[]});
	$(".deviceList").hide();
}

//在弹出框中显示用户的设备列表
function getDeviceData(type,id){
	$('#deviceListTbl').datagrid({
		url :basePath + '/meteringbox/getDeviceByCustomerId?Math.random()', 
		queryParams: {
		 	id : id
		}
	});
}

//在弹出框中显示今日告警列表
function doLoadAlarm(){
	$(".vrInfo").hide();
	$(".videoInfo").hide();
	$(".floorInfo").hide();
	$(".linkInfo").hide();
	$(".deviceList").hide();
	$(".videoList").hide();
	$(".alarmList").show();
	$(".unonlineList").hide();
	getAlarmBySystem();
}

function getAlarmBySystem(){
	var alarmtype=$("#warntype").val();
	$('#alarmListTbl').datagrid({
		url :basePath + '/meteringbox/alarmDataGrid?Math.random()', 
		queryParams: {
			end:2,
			alarmtype:alarmtype,
			startTime:Format(new Date(new Date().setHours(0, 0, 0, 0)),"yyyy-MM-dd HH:mm:ss"),
			endTime:Format(new Date(new Date(new Date().toLocaleDateString()).getTime()+24*60*60*1000-1),"yyyy-MM-dd HH:mm:ss")
		}
	});
}

function Format(now,mask)
{
    var d = now;
    var zeroize = function (value, length)
    {
        if (!length) length = 2;
        value = String(value);
        for (var i = 0, zeros = ''; i < (length - value.length); i++)
        {
            zeros += '0';
        }
        return zeros + value;
    };
 
    return mask.replace(/"[^"]*"|'[^']*'|\b(?:d{1,4}|m{1,4}|yy(?:yy)?|([hHMstT])\1?|[lLZ])\b/g, function ($0)
    {
        switch ($0)
        {
            case 'd': return d.getDate();
            case 'dd': return zeroize(d.getDate());
            case 'ddd': return ['Sun', 'Mon', 'Tue', 'Wed', 'Thr', 'Fri', 'Sat'][d.getDay()];
            case 'dddd': return ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'][d.getDay()];
            case 'M': return d.getMonth() + 1;
            case 'MM': return zeroize(d.getMonth() + 1);
            case 'MMM': return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][d.getMonth()];
            case 'MMMM': return ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'][d.getMonth()];
            case 'yy': return String(d.getFullYear()).substr(2);
            case 'yyyy': return d.getFullYear();
            case 'h': return d.getHours() % 12 || 12;
            case 'hh': return zeroize(d.getHours() % 12 || 12);
            case 'H': return d.getHours();
            case 'HH': return zeroize(d.getHours());
            case 'm': return d.getMinutes();
            case 'mm': return zeroize(d.getMinutes());
            case 's': return d.getSeconds();
            case 'ss': return zeroize(d.getSeconds());
            case 'l': return zeroize(d.getMilliseconds(), 3);
            case 'L': var m = d.getMilliseconds();
                if (m > 99) m = Math.round(m / 10);
                return zeroize(m);
            case 'tt': return d.getHours() < 12 ? 'am' : 'pm';
            case 'TT': return d.getHours() < 12 ? 'AM' : 'PM';
            case 'Z': return d.toUTCString().match(/[A-Z]+$/);
            // Return quoted strings with the surrounding quotes removed
            default: return $0.substr(1, $0.length - 2);
        }
    });
};

function closeAlarmList(){
	$("#alarmtype").combobox('setValue','');
	$('#alarmListTbl').datagrid('loadData',{total:0,rows:[]});
	$(".alarmList").hide();
}

//在弹出框中显示全景图
function showVrInfo(){
	var id = $("#customerid").val();
	if (id == "") return;
	$(".deviceList").hide();
	$(".videoList").hide();
	$(".alarmList").hide();
	$(".unonlineList").hide();
	$(".floorInfo").hide();
	$(".linkInfo").hide();
	$(".vrInfo").show();
	loadVr(id);
}

function closeVrInfo(){
	$(".vrInfo").hide();
}

var PSV;
var loadingVr;
var panoTimeout;	//全景加载延迟器
var panoTimer;		//全景动画定时器
var markerTimeout;  //图标加载延迟器
//加载全景图
function loadVr(id){
	if(loadingVr) return;
	if (PSV){
    	PSV.destroy();
    	PSV = undefined;
    }
	//动态加载首张全景图
	var _imgurl = '';
	var oriLongitude;		//初始经度
	var oriLatitude;		//初始纬度
	var originZoom;			//初始级别
	var desLongitude;		//目标经度
	var desLatitude;		//目标纬度
	var desZoom;			//目标级别
	var _links, _marks;
	$.ajax({
 	    type:'POST', 
        url:basePath + '/visualization/getFirstVrImg?Math.random()',           
        data:{customerid: id},
        async:false,
 	    success:function(data){
 	    	if (data){
 	    		if (data.img){
	 	    		_imgurl = basePath + '/images/vr/' + data.img.imgname;
	 	    		originLongitude = data.img.originlongitude;
	 	    		originLatitude = data.img.originlatitude;
	 	    		originZoom = data.img.originzoom;
	 	    		desLongitude = data.img.longitude;
	 	    		desLatitude = data.img.latitude;
	 	    		desZoom = data.img.destinzoom;	
 	    		}
 	    		_links = data.links;
 	    		_marks = data.marks;
	 	    }
 	    },	        
 	    error:function(data){
        }
 	});
	if(_imgurl =="") return;
	loadingVr = true;		//正在加载全景图
	PSV = new PhotoSphereViewer({
		container: 'photosphere',
		panorama: _imgurl,
		min_fov:20,
		max_fov:180,				//设置最大180 不然不能缩小
		fisheye:true,				//设置鱼眼
		time_anim:false,
		default_long:originLongitude ? originLongitude : Math.PI/12,	//Math.PI/12,
		default_lat:originLatitude ? originLatitude : -Math.PI/2,			//默认朝向 -Math.PI/2 竖直朝下   0 水平
		mousewheel:true,
		markers:[],
		navbar: false,
		zoom:originZoom ? originZoom : 10								//默认的显示级别
	});	
	
	PSV.on('ready', function() {
		panoTimeout = setTimeout(function(){
			panoTimeout = undefined;
 			panoTimer = setInterval(startAnim,20);
 			var position = {
 				longitude:desLongitude ? desLongitude : 0,
 				latitude:desLatitude ? desLatitude : 0
 			}
 			PSV.animate(position,2800);		//视角动画
 			markerTimeout = setTimeout(function(){
 				markerTimeout = undefined;
 				addLinks(_links); //添加超链接
 				addMarks(_marks); //添加标注
 			},2800);		
 		},2000)
 	});

 	var i= 10;			//[10,80]
 	var startAnim = function(){
 		i++
 		//PSV.zoom(10+(i-10)/2,true);			//140次循环
 		PSV.zoom(originZoom+(desZoom-originZoom)*(i-10)/140,true);
 		if(i>150){
 			clearInterval(panoTimer);
 			panoTimer = undefined;
 			loadingVr = false;
 		}
 	}
 	
 	/**
 	 * 用户点击标记的事件
 	 */
 	PSV.on('select-marker', function (marker) {
 		if (marker.data.type == 'link') {
 			PSV.clearMarkers();
 			$.ajax({
 		 	    type:'POST', 
 		        url:basePath + '/visualization/getVrImgById?Math.random()',           
 		        data:{imgid: marker.data.toImg},
 		 	    success:function(data){
 		 	    	if (data){
 		 	    		var toImgPosition = {
		 		 				longitude:data.img.longitude,
		 		 				latitude:data.img.latitude
		 		 			}
 		 	    		PSV.setPanorama(basePath + "/images/vr/" + data.img.imgname, toImgPosition);
 		 	    		addLinks(data.links); //添加超链接
 		 				addMarks(data.marks); //添加标注
 			 	    }
 		 	    },	        
 		 	    error:function(data){
 		        }
 		 	});
 		}
 		else if (marker.data.type == 'mark') {
 			if (marker.data.marktype == 1){ //摄像头
 				showVideoInfo(marker.data.gid, marker.data.name);
 			}
 		}
    });
}

//停止全景图渲染
function stopPano(){
	if(loadingVr){
		if(panoTimeout){
			clearTimeout(panoTimeout);
			panoTimeout = undefined;
		}
		if(markerTimeout){
			clearTimeout(markerTimeout);
			markerTimeout = undefined;
		}
		if(panoTimer){
			clearInterval(panoTimer);
			panoTimer = undefined;
		}
		loadingVr = false;
	}
	if(PSV){
		PSV.stopAnimation();
		PSV.destroy();
    	PSV = undefined;
	}
	$("#photosphere").hide();			//隐藏停止全景图
}

/*添加超链接*/
function addLinks(links){
	if (links){
		for (var i = 0; i < links.length; i++){
			var direction = ''; //箭头方向
			if (links[i].linktype == 1) direction = 'uparrow';
			else direction = 'downarrow';
			var link = {
	 		id: 'link' + links[i].linkid,
	 		longitude: links[i].longitude,
	 		latitude: links[i].latitude,
	 		html: '<a href="#" class="' + direction + '"><span></span><span></span><span></span></a>',
	 		anchor: 'bottom right',
	 		tooltip: '<span style="border: 1px solid white;font-size:12px;">' + links[i].remark + '</span>',
	 		data:{type:'link',id:links[i].linkid,toImg:links[i].toimg}
	 	}
			PSV.addMarker(link);
		}
	}
}

/*添加标注*/
function addMarks(marks){
	if (marks){
		for (var i = 0; i < marks.length; i++){
			var mark = {
	 		id: 'mark' + marks[i].markid,
	 		longitude: marks[i].longitude,
	 		latitude: marks[i].latitude,
	 		scale: [1, 1.5],
	 		html: '<img style="width:24px;height:24px" src="' + basePath + '/images/vr/' + marks[i].icon + '" />',
	 		anchor: 'bottom right',
	 		tooltip: '<span style="border: 1px solid white;font-size:12px;">' + marks[i].remark + '</span>',
	 		data:{type:'mark',id:marks[i].markid,gid:marks[i].gid,marktype:marks[i].marktype,name:marks[i].remark}
	 	}
			PSV.addMarker(mark);
		}
	}
}

//aes加密
function Encrypt(word,key){
	 var key = CryptoJS.enc.Utf8.parse(key);	

	 var srcs = CryptoJS.enc.Utf8.parse(word);
	 var encrypted = CryptoJS.AES.encrypt(srcs, key, {mode:CryptoJS.mode.ECB,padding: CryptoJS.pad.Pkcs7});
   return encrypted.toString();
}

//aes解密
function Decrypt(word,key){
	 var key = CryptoJS.enc.Utf8.parse(key);	

	 var decrypt = CryptoJS.AES.decrypt(word, key, {mode:CryptoJS.mode.ECB,padding: CryptoJS.pad.Pkcs7});
	 return CryptoJS.enc.Utf8.stringify(decrypt).toString();
} 

//三维楼层弹出框
//在弹出框中显示楼层
function showFloorInfo(floorid,devicename){
	var customerid = $("#customerid").val();
	if (customerid == "") return;
	$(".deviceList").hide();
	$(".videoList").hide();
	$(".alarmList").hide();
	$(".unonlineList").hide();
	$(".vrInfo").hide();
	$(".videoInfo").hide();
	$(".floorInfo").show();
	loadBanner(floorid,customerid,devicename);
}

function closeFloorInfo(){
	$(".floorInfo").hide();
}

//根据设备类型显示和不显示设备
function showDeviceByType(dom,type){
	var show = dom.checked ? true : false;
	if(show){
		for(var i=0;i<noShowType.length;i++){
			if(noShowType[i] == type){
				noShowType.splice(i,1);
			}
		}
	}else{
		noShowType.push(type);
		if($("input[name='showAll']").prop("checked")){
			$("input[name='showAll']").prop("checked",false);
		}
	}
}

//渲染三维模型
function render() {
	updatePopPosition();		//更新弹出框的位置
	
    updateLabelSprite();			//更新文字位置
    updateDeviceSprite();			//更新设备图标
    updateVideoSprite();			//更新视频图标
    updateDeviceLabel();			//更新设备和视频标注
    
    updateControls();               //更新鼠标交互
    renderAnimation = requestAnimationFrame( render );    //动画帧循环
    renderer.render(scene, camera); //进行渲染
}

//根据建筑id添加设备和模型
function addBuilding(buildingId){	
	//初始化设备筛选条件
	noShowType = [];
	$("#deviceItemContainer").html("");
	$("input[name='showAll']").prop("checked",true);
	if(!buildingId) return;
	
	$.ajax({
	 	type:'POST', 
     	url:basePath + '/visualization/getChildBuildings?Math.random()',           
     	data:{"id":buildingId},
     	async: false,
        success:function(data){
    	    var idArray = eval("("+ data +")");
    	    //建筑不包含子集，即某一层
    	    if(idArray.length == 0){
				addModelByBuildingId(buildingId, basePath + '/visualization/getModelByBuildingId?Math.random()',
					function(json){
					   createLabel(json);
				});	    //根据建筑id获取模型和标注
				
				//根据建筑id获取设备
				getEquipmentByBuildingId(buildingId, basePath + '/meteringbox/getDeviceByBuildingId?Math.random()',
					function(data){		
						var resultDatas = [],hash = {};
						for(var i=0;i<data.length;i++){
							var dataItem = data[i];
							if(!hash[dataItem.equipmenttype]){
								resultDatas.push(dataItem);
								hash[dataItem.equipmenttype] = true;
							}	
						}
						var itemStr = "";
						for(var j=0;j<resultDatas.length;j++){
							var resultData = resultDatas[j];
							var type = "device" + resultData.equipmenttype;
							itemStr += "<div class=\"deviceItem\">"
							+"<input type=\"checkbox\" checked=\"checked\" onchange=\"showDeviceByType(this,'"+type+"');\">"
							+ getDeviceTypeName(resultData.equipmenttype) +"</div>";
						}
						$("#deviceItemContainer").append(itemStr);
				});
				
				//根据建筑id获取摄像头
				getVideoByBuildingId(buildingId, basePath + '/visualization/getVideoByBuildingId?Math.random()', 
					function(data){	
						var type = "video";
						var itemStr = "<div class=\"deviceItem\">"
						+"<input type=\"checkbox\" checked=\"checked\" onchange=\"showDeviceByType(this,'"+type+"');\">监控点</div>";
						$("#deviceItemContainer").append(itemStr);
				}); 
			}else{							//建筑属于楼,建筑类型同样是8
				for(var i=0;i<idArray.length;i++){
					var id = idArray[i];
					addModelByBuildingId(id,basePath + '/visualization/getModelByBuildingId?Math.random()');
				}
			}
        },	        
        error:function(data){
        }
    });
}

/*
 *   获取设备类型名称
 *   */
function getDeviceTypeName(deviceType){
	var typeName = "";
	switch(deviceType){
	case "1":
		typeName = "1P断路器";
		break;
	case "2":
		typeName = "2P断路器";
		break;
	case "3":
		typeName = "3P断路器";
		break;
	case "4":
		typeName = "4P断路器";
		break;
	case "9":
		typeName = "通讯单元";
		break;
		default:
			break;
	}
	return typeName;
}

/*
 *   鼠标平移事件
 *   */
function onDocumentMouseMove(event) {
    event.preventDefault();
   	var intersects = getDeviceIntersects(event.offsetX,event.offsetY);
       if (intersects.length > 0) {
           var selected = intersects[0];	//取第一个物体
           if(selected.object instanceof THREE.Sprite){
           	   $(container).css('cursor','pointer');
           }else{
        	   $(container).css('cursor','default');
           } 
       }else{
    	   $(container).css('cursor','default');
       }
}

var highMesh;
/*
 *   鼠标单击事件
 *   */
function onDocumentMouseDown( event ) {
    event.preventDefault();
   	var intersects = getDeviceIntersects(event.offsetX,event.offsetY);
    if (intersects.length > 0) {
        var selected = intersects[0];//取第一个物体
        if(selected.object instanceof THREE.Sprite){
        	var sprite = selected.object;
        	if(sprite.userData.type=="device"){
        		var contentStr = setAlarmContent(sprite);
        		var position = [sprite.position.x,sprite.position.y,sprite.position.z];		//弹出的经纬度
        		console.log(sprite.position.x+","+sprite.position.y+","+sprite.position.z);
        	 	var title = "设备信息";
        	 	showPopup(position,title,contentStr);
        	}
        }
    }else{
    	hideDeviceInfo();
    }
    
  //test
    var vector = new THREE.Vector3();//三维坐标对象
    vector.set(
            ( event.offsetX / container.clientWidth ) * 2 - 1,
            - ( event.offsetY / container.clientHeight ) * 2 + 1,
            0.5 );
    vector.unproject( camera );
    var raycaster = new THREE.Raycaster(camera.position, vector.sub(camera.position).normalize());
    var intersects = raycaster.intersectObjects([floorGroup.children[0]],true);
    if(intersects.length != 0){
    	//highMesh = intersects[0].object;
    	//highMesh.material = new THREE.MeshBasicMaterial({ color:0xff0000 });
    	var point = intersects[0].point;
    	console.log(point.x+","+point.y+","+point.z);
    }
}

//设置设备信息框内容
function setAlarmContent(sprite){
	var data = sprite.userData;
 	var contentStr = "<input type='hidden' id='devicePop' value='" + sprite.name + "'/><table class='popupTable' style='table-layout:fixed;WORD-BREAK: break-all;WORD-WRAP:break-word;border-collapse: collapse;width:100%;'><tbody>";
	contentStr += "<tr><td width='70px' align='right'>设备名称：</td>"
           	+ "<td align='left'><font color='#8a4141'>" + data.equipmentname + "</font></td></tr>"
           + "<tr><td width='70px' align='right'>设备地址：</td>"
           	+ "<td align='left'><font color='#8a4141'>" + data.equipmentaddress + "</font></td></tr>"
           + "<tr><td width='70px' align='right'>设备类型：</td>"
           	+ "<td align='left'><font color='#8a4141'>" + getDeviceTypeName(data.equipmenttype) + "</font></td></tr>";
	//加载告警数据
	$(".alarmContentItem", parent.parent.document).each(function(){
		if ($(this).find("#entityId").html() == sprite.name){
			contentStr+= "<tr style='border-top:1px dashed darkgray;'><td width='70px' align='right'>告警事件：</td>"
	           	+ "<td align='left'><font color='#8a4141'>" + $(this).find("#alarmtype").html() + "</font></td></tr>"
	           	+ "<tr><td width='70px' align='right'>告警数据：</td>"
	           	+ "<td align='left'><font color='#8a4141'>" + $(this).find("#startdata").html() + "</font></td></tr>"
	           	+ "<tr style='border-bottom:1px dashed darkgray;'><td width='70px' align='right'>发生时间：</td>"
	           	+ "<td align='left'><font color='#8a4141'>" + $(this).find("#starttime").html() + "</font></td></tr>";
		}			
	});
	//加载联动按钮
	contentStr += "<tr><td width='70px' align='right'>设备联动：</td><td width='230px'>"
	  		+"<select id=" + 'link' + data.equipmentaddress + " style='float:left;width:110px;height:21px;margin:2px 0 2px 0;'>";
	var name = 'syscode:'+data.systemtype+'address:' + data.equipmentaddress;
	contentStr += "<option value='1'>开闸</option>";
	contentStr += "<option value='0'>合闸</option>";
	contentStr += "</select><button type='button' style='float:left;margin-left:10px;width: 80px;height: 25px;cursor:pointer;border-radius: 4px;' onclick='linkagesub(\""+name+"\",\""+'link' + data.equipmentaddress+"\")'>联动</button></td></tr>";
	//实时曲线
	contentStr += "<tr><td width='70px' align='right'>实时曲线：</td><td width='230px'>";
	var name = 'syscode:'+data.systemtype+'address:' + data.equipmentaddress;
	contentStr += "<button type='button' style='float:left;width: 80px;height: 25px;cursor:pointer;border-radius: 4px;' onclick='showCurve(\""+data.equipmentaddress +"\",\""+data.equipmenttype +"\",\""+data.equipmentname +"\")'>查看</button></td></tr>";
 	contentStr +="</tbody></table>";
 	return contentStr;
}

//加载楼层
function loadFloor(floorid,customerid,devicename){
	if(renderAnimation){
		cancelAnimationFrame(renderAnimation);
		renderAnimation = undefined;			//取消循环渲染
	}

	$("#popup").hide();		//隐藏设备信息弹出框
			
	clearBuilding(); //移除原有模型
	render(); //重新渲染
	refreshThreeWindow();
	addBuilding(floorid);		
	var buildingName = buildingObj[floorid] ? buildingObj[floorid] : "未定义楼层";
	
	$("#floorName").show();
	$("#floorName").html(buildingName);
	
	$(".alarmContentItem", parent.document).each(function(){
		var entityId = "", equipmenttype = "";
		//var divname=$(this).attr("id");
		$(this).find("label").each(function(){
			var id=$(this).attr("id");
			if(id=="entityId")
				entityId=$(this).prop("outerText");
			else
				equipmenttype=$(this).prop("outerText");
        });
		deviceAlarm(entityId,true,equipmenttype);			
	});
	
 	if(devicename){
 		var deviceSprite = deviceGroup.getObjectByName(devicename);
 		if(deviceSprite){
 			flyToDevice(deviceSprite);
 			setTimeout(function(){
 				var contentStr = setAlarmContent(deviceSprite);
        		var position = [deviceSprite.position.x,deviceSprite.position.y,deviceSprite.position.z];		//弹出的经纬度
        	 	var title = "设备信息";
        	 	showPopup(position,title,contentStr);
 			},100);
 		}
 	}
 	
	$("div[class^='als-item']").removeClass("als-item-selected");
    $(".als-item-"+floorid).addClass("als-item-selected");
}

//加载导航栏
function loadBanner(floorid,customerid,devicename){
	$("body").find("#my-als-list").remove();
	//动态加载楼层banner
	$.ajax({
 	    type:'POST', 
        url:basePath + '/visualization/getBuildingsByCustomerId?Math.random()',           
        data:{customerid: customerid},
 	    success:function(data){
 	    	var banner = "<div class='als-container' id='my-als-list' style='width: 100%;'><div class='als-top-con'><span class='als-down'></span></div>" +
 		    "<div class='als-viewport'>" +
 		    "<div class='als-wrapper'>";
 	    	if (data){
	 	    	var dataObj = eval("("+data+")");
	 	        $.each(dataObj, function(i, n){
	 	    	    var div = "<div class='als-item als-item-"+n.buildingid+"'><a href='#' onclick=loadFloor(" + n.buildingid + "," + customerid + ",'" + n.buildingname
	 	    	    		+ "')><img src='" + basePath + "/images/vr/" + n.picturename + "' alt='" + 
	 	    	    		n.buildingname + "' title='" + n.buildingname + "' /></a>" + n.buildingname + "</div>";
	 	    	    banner = banner + div;
	 	    	    if(!buildingObj[n.buildingid]){
	 	    	    	buildingObj[n.buildingid] = n.buildingname;
	 	    	    }
	 	    	});
	 	        //如果floorid为空，默认加载第一个楼层模型
	 	        if (!floorid && dataObj.length > 0){
	 	        	floorid = dataObj[0].buildingid;
	 	        	devicename = dataObj[0].buildingname;
	 	        }
	 	    }
 	    	banner = banner + "</div></div><span class='als-prev'></span><span class='als-next'></span></div>";
 			$("#wsContainer").append($(banner));
 			$("#my-als-list").als({
 				visible_items: 5,
 				scrolling_items: 1,
 				orientation: "horizontal",
 				circular: "yes",
 				autoscroll: "no",
 				interval: 5000,
 				speed: 500,
 				easing: "linear",
 				direction: "right",
 				start_from: 0
 			});
 			
 			$(".als-top-con").css('left', $(".floorInfo").width() / 2 -25);
 			
 			$(".als-top-con").click(function(){
 				var span=$(this).find("span");
 				var als=span.prop("class");
 				if(als=="als-down"){
 					span.prop("class","als-up");
 					$(".als-container").animate({bottom:"-88px"});
 				}
 				else{
 					span.prop("class","als-down");
 					$(".als-container").animate({bottom:"0px"});
 				}
 			});
 			//加载楼层
 			loadFloor(floorid,customerid,devicename);
 	    },	        
 	    error:function(data){
        }
 	});
}

function showCurve(equipmentaddress, equipmenttype, equipmentname){
	equipmentname=encodeURI(encodeURI(equipmentname));
	window.open('realtimeCurve?equipmentaddress='+equipmentaddress+'&equipmenttype='+equipmenttype+'&equipmentname='+equipmentname, equipmentname+'-实时曲线', 'height=450, width=900, top=0, left=0, toolbar=no, menubar=no, scrollbars=yes, resizable=no, location=no, status=no')   //该句写成一行代码
}

//打开联动弹出框
var plan_link=1;//0:预案；1:联动
function openLink(equipmentid,value){
	plan_link=1;
	$("#linkequipmentid").val(equipmentid);
	$("#linkvalue").val(value);
	$("#imgscodeLink").imgcode(); 
	$("#showLinkage").hide();
	$(".linkInfo").show();
}

//关闭联动弹出框
function closeLinkInfo(){
	$(".linkInfo").hide();
}

//设备联动
function linkagesub(name,equipmentname){
	var sprite = deviceGroup.getObjectByName(name);   //根据名称获取
	if(sprite){
		var data = sprite.userData;
		var value=$("#"+equipmentname).val();
		openLink(data.equipmentid,value);
	}
}
//设备联动2
function linkagesub2(equipmentid,equipmentname){
	var value=$("#"+equipmentname).val();
	openLink(equipmentid,value);
}

//设备联动-组帧
function linkage(){
	closeLinkInfo();
    if (ws && ws.readyState == 1) {
        $.ajax({
            type: "post",
            url: linkageUrl,
            data: {"equipmentid":$("#linkequipmentid").val(),"code":$("#linkvalue").val()},
            success: function (d) {
                if (d != "") {
                	frameNumber++;
                    //组帧，Global.js中定义
                    var frame = makeWSFrame(frameNumber, 0, 1, 1, d, '');
                    ws.send(frame); 
	                	
                	//加载层
                    if ($("body").find(".datagrid-mask").length == 0) {
                        //添加等待提示
                        $("<div class=\"datagrid-mask\"></div>").css({ display: "block", zIndex: 10011, width: "100%", height: $(window).height() }).appendTo("body"); //等待效果显示在wnavt控件
                        $("<div class=\"datagrid-mask-msg\"></div>").html("设备联动中，请稍后...").appendTo("body").css({ color:'#fff', display: "block", zIndex: 10012, left: $(window).width() / 2 - $("div.datagrid-mask-msg").outerWidth() / 2, top: $(window).height() / 2 - $("div.datagrid-mask-msg").outerHeight() / 2 }); //上同
                    }
                }
            }
        });
    }
}

/*******************************************************************************************************
 ** 前置机相关
 *******************************************************************************************************/
/*连接websocket*/
function connect() {
    var WebSocketsExist = true;
    try {
        ws = new ReconnectingWebSocket("ws://" + websocketip + ":" + websocketport);
    }
    catch (ex) {
        try {
            ws = new ReconnectingWebSocket("ws://" + websocketip + ":" + websocketport);
        }
        catch (ex) {
            WebSocketsExist = false;
        }
    }
    if (!WebSocketsExist) {
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
    var msg = event.data;
    //解析帧，Global.js中定义
    var frame = parseWSFrame(msg);
    if (frame == "") return;
    //帧类型为3（握手），表示端口号
    if (frame.type == '3') {
        port = frame.data;
    }
    else if(frame.type == "2"){//帧类型为2（应答）
    	if (frame.data.length.toString() == frame.len) { //判断是否接收到完整的数据帧
    		
        	$.ajax({
				type: 'POST',
				url: parseAlarmDataUrl,
				data: {
					"strXML": frame.data
				},
				success: function(d) {
					$("body").find("div.datagrid-mask-msg").remove();
		            $("body").find("div.datagrid-mask").remove();
				
					if(!d) return;
					switch(d.result){
					case 1:
						if(d.typeFlagCode == 138)
						    $.messager.alert("提示", "执行联动成功。", "info");
						break;
					case 2:
						$.messager.alert("警告", "终端连接超时。", "error");
						break;
					case 3:
						$.messager.alert("警告", "终端否认应答。", "error");
						break;
					case 4:
						$.messager.alert("警告", "终端不在线。", "error");
						break;
					case 8:
						if(d.typeFlagCode == 138)
						    $.messager.alert("警告", "执行联动失败。", "error");
						break;
					default:
						$.messager.alert("警告", "前置机未知错误。", "error");
						break;
					}
				}
			});
        }
    }
}

function WSonClose(e) {
    try {
    }
    catch (ex) {

    }
}

function WSonError(e) {}

/*******************************************************************************************************
 ** 首页调用方法相关
 *******************************************************************************************************/

//刷新页面
function refreshPage(){
	getCurveData();
	if ($(".deviceInfo").is(":visible")){
		showDeviceInfo();
	}
}

//关闭设备提示框
function closePop(){
	if(overlay.css("display")!="none"){
		hideDeviceInfo();
	}
}

//显示信息框
function openPop(entityId){
	//刷新弹出框
	if(overlay && overlay.css("display")!="none" && $("#devicePop").val() == entityId){
		var deviceSprite = deviceGroup.getObjectByName(entityId);
 		if(deviceSprite){
 			var contentStr = setAlarmContent(deviceSprite);
    		var position = [deviceSprite.position.x,deviceSprite.position.y,deviceSprite.position.z];		//弹出的经纬度
    	 	var title = "设备信息";
    	 	showPopup(position,title,contentStr);		//设置延迟弹出框
 		}
	}
}

//关闭事件-设备动作
function closeAlarm(entityId, divname, equipmenttype, flag){
	if (flag){
		deviceAlarm(entityId,false,equipmenttype,divname);
		//关闭弹出框
		if(overlay.css("display")!="none" && $("#devicePop").val() == entityId){
			hideDeviceInfo();
		}
	}
	else{
		//刷新弹出框
		if(overlay.css("display")!="none" && $("#devicePop").val() == entityId){
			var deviceSprite = deviceGroup.getObjectByName(entityId);
	 		if(deviceSprite){
	 			var contentStr = setAlarmContent(deviceSprite);
        		var position = [deviceSprite.position.x,deviceSprite.position.y,deviceSprite.position.z];		//弹出的经纬度
        	 	var title = "设备信息";
        	 	showPopup(position,title,contentStr);		//设置延迟弹出框
	 		}
		}
	}
}

//设备无告警，恢复正常
function clearBlinking(deviceAlarmArraynew){
	for(var i=0;i<deviceAlarmArray.length;i++){
		var f=true;
		for(var j=0;j<deviceAlarmArraynew.length;j++){
			if(deviceAlarmArraynew[j].name == deviceAlarmArray[i].name){
				f=false;
				break;
			}
		}
		
		openPop(deviceAlarmArray[i].name);//更新设备信息弹出框
		
		if(f){
			changeSpriteByName(deviceAlarmArray[i].name,deviceAlarmArray[i].imgurl);	//恢复正常
			deviceAlarmArray.splice(i,1);
		}
	}
}

//打开用户信息弹出框并打开楼层弹出框
function gotoPosition(floorid, customerid,devicename){
	showUserInfo(customerid);
	showFloorInfo(floorid,devicename);
}

var show=true;
var boxParam=1;
function boxStatus(){
	var width=$('#home_div').width();
	var height=$('#home_div').height();
	
	if(show){
		$('#layout_div').show();
		$('#alarm_line_tr').show();
	}else{
		$('#layout_div').hide();
		$('#alarm_line_tr').hide();
	}
	
	if(boxParam%2==0) MinMap(width,height);
	else MaxMap(width,height);
	
	boxParam++;
}

function MinMap(width,height){
	$('#map_td').width(width*0.77);
	$('#map').width(width*0.77);//地图高度
	
	$('#map').height(height*0.75);//地图高度

	//map.updateSize();  

	$('.boxClose').css("left","19%");
	$('.boxClose').css("top","0px");
	$('.boxClose i').addClass("rotateI");
}

function MaxMap(width,height){
	$('#map_td').width(width-15);
	$('#map').width(width-15);//地图高度
	
	$('#map').height(height-10);//地图高度
	
	//map.updateSize();  
	
	//$('.fa-times').css("animation","xz 5s linear infinite");
	$('.boxClose').css("left","10px");
	$('.boxClose').css("top","10px");
	$('.boxClose i').removeClass("rotateI");
}

function online_page(){
	if($("#unonlinecount").text()>0)
		window.parent.openPage('/WSSF/curve', '数据分析', 'fa-line-chart', 'undefined');
}