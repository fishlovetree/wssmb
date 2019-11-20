var deviceEntityArray = [];

//标注图片的路径
var labelPicUrl = {			
	1:bathPath+"/images/gis/label/stairs.png",		//楼梯图标
	2:bathPath+"/images/gis/label/elevator.png",	//电梯图标
	3:bathPath+"/images/gis/label/wc.png",			//厕所图标
	"default":bathPath+"/images/gis/label/default.png"	//默认的图标
}

//保存设备图片url
var DEVIMGURL = {
	smoke:bathPath + "/images/divice/smoke.png",
	smokeAlarm:bathPath + "/images/divice/smokeAlarm.png",
	fireHydrant:bathPath + "/images/divice/fireHydrant.png",
	fireHydrantAlarm:bathPath + "/images/divice/fireHydrantAlarm.png",
	defaultP:bathPath + "/images/divice/defaultP.png",
	defaultPAlarm:bathPath + "/images/divice/defaultPAlarm.png",
	video:bathPath + "/images/divice/video.png"
}
var MODELURL = {
	fireHydrant:'http://192.168.88.21:8082/wssfmodel/gltf/device/xfs/xfs.gltf'
}
/*
*	根据建筑id添加设备和模型
*/
function addModelAndEquipments(buildingId,callback){
	getModelByBuildingId(buildingId,function(model){	    //根据建筑id获取模型
		if(model != undefined){
			if(buildingId == totalBuildingId){
				removeAllModel();
				enableTileMap();
				ws3d.addModelTile();	//添加总体概貌三维切片
			}else{
				removeAllModel();
				disableTileMap();
				addmodel(model);		//添加楼层模型
				zoomToEntity();
				createLabel(model); 
			}
		}
	});
	getEquipmentByBuildingId(buildingId,function(data){	//根据建筑id获取设备
		if(data && data instanceof Array && data.length!=0){
			addDeviceToMap(data);		//添加楼层设备
		}
	});
	if(typeof(callback)==="function"){
		callback();
	}
}
	
/*
 * 返回默认位置
 */
 function returnInitialPosition(){
	if(recentEntity){
	     viewer.zoomTo(recentEntity);
	}else{
		viewer.camera.setView({
	      	destination: Cesium.Cartesian3.fromDegrees(121.04133367538452,29.115408360958103, 100.0),//设置相机位置经度、纬度、高度
	      	orientation: {
	          	heading : Cesium.Math.toRadians(10.0),
	          	pitch : Cesium.Math.toRadians(-45.0),//垂直向下90度
	          	roll : 0.0
	      	}
		  });
	}
 }

 /*
  * 相机向前移动，放大
  */
 function zoomIn(){
	  viewer.camera.zoomIn(100);  
 }
 
 /*
  * 鼠标向后移动，缩小
  */
 function zoomOut(){
      viewer.camera.zoomOut(100);	  
 }

/*
 * 聚焦到当前的实体
 */
function zoomToEntity(){
	viewer.zoomTo(recentEntity);
}

/*
 * 禁用切片，楼层管理不需要显示切片
 */
function disableTileMap(){
	viewer.scene.globe.show=false;
}

/*
 * 启用切片
 */
function enableTileMap(){
	viewer.scene.globe.show=true;
}

/*
 *	根据建筑id获取模型id，回调模型id*/
 function getModelId(buildingId,callback){
 	var param={"id":buildingId}; 
 	 $.ajax({
		   type:'POST', 
           url:bathPath + '/visualization/getModelId',           
           data:param,
           async:false,
	       success:function(data){
	    	   callback(data);
	       },	        
	       error:function(data){
          }
	   });
 }
 
 /*
 *	移除所有的实体*/
 function removeAllModel(){
	if(tileset){		//移除3d切片
	    viewer.scene.primitives.remove(tileset)
	}
	if(recentEntity){
		viewer.entities.remove(recentEntity);			//清除楼层
	}
	if(deviceEntityArray && deviceEntityArray instanceof Array && deviceEntityArray.length != 0){
		for(var i=0;i<deviceEntityArray.length;i++){
			viewer.entities.remove(deviceEntityArray[i]);		//清除设备
		}
		deviceEntityArray = [];
	}
 	billboards.removeAll();					//广告牌清除重新生成
 	if($("#popup").css("display")!="none"){
 		$("#popup").hide();
 	}
 }
 
 /*移除删除按钮*/
 function removeDeletePoint(){
	 if(deletePoint && deletePoint != undefined && $("#closePoint").css("diaplay")!="none"){
		 removePolyPoint();
		 removeDeleteButton();
	 }
 }

 /*
 *	根据id获取模型，后面需要从数据库中取
 */
 function getModelById(id,callback){
 	var param={"id":id}; 
 	$.ajax({
	    type:'POST', 
        url:bathPath + '/visualization/getModelById',           
        data:param,
        async:false,
	       success:function(data){
	    	   var dataObj = eval("("+data+")");
	    	   var json = 
	    	   {id:dataObj.modelcode,url:dataObj.modelurl,heading: eval("("+dataObj.rotation+")")[2],
	    	          name: dataObj.modelname,coords: eval("("+dataObj.position+")"),label:dataObj.label}
	    	   callback(json);
	       },	        
	       error:function(data){
       }
	   });
 }
 
 /*
  *	根据建筑id获取模型
  */
  function getModelByBuildingId(id,callback){
  	var param={"id":id}; 
  	$.ajax({
 		 type:'POST', 
         url:bathPath + '/visualization/getModelByBuildingId',           
         data:param,
         async:false,
 	       success:function(data){
 	    	   var dataObj = eval("("+data+")");
 	    	   var json;
 	    	   if(null != dataObj){
 	    		  json = {id:dataObj.modelcode,url:dataObj.modelurl,heading: eval("("+dataObj.rotation+")")[2],
 	 	    	          name: dataObj.modelname,coords: eval("("+dataObj.position+")"),label:dataObj.label};
 	    	   }
 	    	   callback(json);
 	       },	        
 	       error:function(data){
        }
 	   });
  }
 
 /*
  * 添加楼层
  * @param model 楼层对应的模型实体 
  * */
 function addmodel(model){
	 var position = Cesium.Cartesian3.fromDegrees(model.coords[0], model.coords[1],model.coords[2]);
     var heading = Cesium.Math.toRadians(model.heading);//竖直方向旋转
     var pitch = Cesium.Math.toRadians(0.0);//x、y方向旋转 x、y轴之一
     var roll = 0.0;//x、y方向旋转 x、y轴之一
     var hpr = new Cesium.HeadingPitchRoll(heading, pitch, roll);
     var orientation = Cesium.Transforms.headingPitchRollQuaternion(position,hpr);
     recentEntity = viewer.entities.add({
         position: position,
         orientation: orientation,
         name: model.name,
         id: model.id,
         model: {
             uri: model.url,
             scale: 1
         }
     });
     recentHeight = model.coords[2] + 2.2;
}
 
/*
 * 	添加设备
 *	@param url 设备对应的图片url
 *	@param position 设备的位置 [lon,lat,height]
 */
 function addDevice(url,position){
 	if(billboards instanceof Cesium.BillboardCollection){
 		billboards.add({
             image: url,
             position: Cesium.Cartesian3.fromDegrees(position[0], position[1], position[2]),
             scale:0.6,
             pixelOffset : new Cesium.Cartesian2( 0,-10)
         });
 	} 
 }
 
 /*
  *	根据建筑id获取模型
  */
  function getEquipmentByBuildingId(id,callback){
  	var param={"id":id}; 
  	$.ajax({
 	    type:'POST', 
         url:bathPath + '/visualization/getEquipmentByBuildingId',           
         data:param,
         async:false,
 	       success:function(data){
 	    	   var dataObj = eval("("+data+")");
 	    	   callback(dataObj);
 	       },	        
 	       error:function(data){
        }
 	   });
  }
  
  /*
   * 添加楼层设备到地图上
   * */
  function addDeviceToMap(data){
	 for(var i=0; i<data.length; i++){
		  var coordinate = eval("("+ data[i].coordinate +")");
		  if(coordinate != undefined && coordinate instanceof Array && coordinate.length == 3){	//简单验证经、纬度、高度
			  if(data[i].equipmenttype){
				  
				  var position = new Cesium.Cartesian3.fromDegrees(coordinate[0],coordinate[1],coordinate[2]);
				  var entityarray = {
					    name:data[i].equipmentname,
						type:'device',
		    		    id : 'syscode:'+data[i].systemtype+'address:' + data[i].equipmentaddress,
		    		    position: position, 
		    		    billboard:{ //图标
			    		        scale:0.11,
					            pixelOffset : new Cesium.Cartesian2( 0,-10)},
		    		    label : { //文字标签
					        text : data[i].equipmentname,
					        font : '10pt monospace',
					        style : Cesium.LabelStyle.FILL_AND_OUTLINE,//FILL_AND_OUTLINE,
					        fillColor : Cesium.Color.RED,
					        outlineColor : Cesium.Color.RED,
					        outlineWidth :0.5,
					        verticalOrigin : Cesium.VerticalOrigin.TOP, //垂直方向以底部来计算标签的位置
					        pixelOffset : new Cesium.Cartesian2( 0, -48 )},	//偏移量
					    properties:data[i]
				  }
				  
				 /* 调用--模型
				  * var heading = Cesium.Math.toRadians(180);
				  var pitch = Cesium.Math.toRadians(0);
				  var roll = Cesium.Math.toRadians(0);
				  var hpr = new Cesium.HeadingPitchRoll(heading, pitch, roll);
				  var orientation = Cesium.Transforms.headingPitchRollQuaternion(position, hpr);
				  entityarray["orientation"] = orientation; 
				  entityarray["model"] = { uri : MODELURL.fireHydrant, scale : 1.0 }; //color:Cesium.Color.DARKCYAN
				  */				  
				  switch(data[i].equipmenttype){
					  case "1":
						  entityarray.billboard.image = DEVIMGURL.smoke;
					  break;
					  case "2":
						  entityarray.billboard.image = DEVIMGURL.fireHydrant;
						  break;
					  default:
						  entityarray.billboard.image = DEVIMGURL.defaultP;
						  break;
				  }
				  
				  deviceEntityArray.push( viewer.entities.add(entityarray) );
				  
			  }
		  }
	  }
  }
  
  function deviceAlarm(entityId,flag,equipmenttype){
  	var entity = viewer.entities.getById(entityId);
  	
  	if(entity){
  		var imgurl="";
  		var imgurlalarm="";
  		switch(equipmenttype){
	  		case "1":
			    imgurl = DEVIMGURL.smoke;
			    imgurlalarm = DEVIMGURL.smokeAlarm;
		    break;
		    case "2":
			    imgurl = DEVIMGURL.fireHydrant;
			    imgurlalarm = DEVIMGURL.fireHydrantAlarm;
			    break;
		    default:
			    imgurl = DEVIMGURL.defaultP;
		  		imgurlalarm = DEVIMGURL.defaultPAlarm;
			    break;
	    }
    	if(flag==false){
			window.clearInterval(entity.imageClock);
			entity.billboard.image = imgurl;									
		}
    	else{
    		entity.addProperty("imageClock");
    		
			// 用计时器控制台风图标的转动
			var second=0;
			entity.imageClock=setInterval(function () {
		        second+=1;
		        if(second%2==0){
		        	entity.billboard.image = imgurlalarm;
		        }
		        else{
		        	entity.billboard.image = imgurl;
		        }
			}, 20);
    	}
  	}
  }
  
  /*
   *	根据建筑id获取摄像头
   */
   function getVideoByBuildingId(id,callback){
   	var param={"id":id}; 
   	$.ajax({
  	    type:'POST', 
          url:bathPath + '/visualization/getVideoByBuildingId',           
          data:param,
          async:false,
  	       success:function(data){
  	    	   var dataObj = eval("("+data+")");
  	    	   callback(dataObj);
  	       },	        
  	       error:function(data){
         }
  	   });
   }
   
   /*
    * 添加楼层摄像头到地图上
    * */
   function addVideoToMap(data){
 	 for(var i=0; i<data.length; i++){
 		  var coordinate = eval("("+ data[i].coordinate +")");
 		  if(coordinate != undefined && coordinate instanceof Array && coordinate.length == 3){	//简单验证经、纬度、高度
			  var position = new Cesium.Cartesian3.fromDegrees(coordinate[0],coordinate[1],coordinate[2]);
			  var heading = Cesium.Math.toRadians(180);
			  var pitch = Cesium.Math.toRadians(0);
			  var roll = Cesium.Math.toRadians(0);
			  var hpr = new Cesium.HeadingPitchRoll(heading, pitch, roll);
			  var orientation = Cesium.Transforms.headingPitchRollQuaternion(position, hpr);
			  deviceEntityArray.push(
				  viewer.entities.add({
				    name : data[i].videomonitorname,
				    type:'video',
				    id:'videomonitorid:'+data[i].videomonitorid+';' + data[i].videomonitorcode,
				    position : position,
				    orientation : orientation,
				    billboard : { //图标
	    		        image : DEVIMGURL.video,
	    		        width:25,
	    		        height:25,
			            pixelOffset : new Cesium.Cartesian2( 0,0)
				    },
				    label : { //文字标签
				        text : data[i].videomonitorname,
				        font : '10pt monospace',
				        style : Cesium.LabelStyle.FILL,
				        fillColor : Cesium.Color.BLACK,
				        //outlineColor : Cesium.Color.BLACK,
				        //outlineWidth : 1,
				        verticalOrigin : Cesium.VerticalOrigin.TOP, //垂直方向以底部来计算标签的位置
				        pixelOffset : new Cesium.Cartesian2( 0, -28 )   //偏移量
				    },properties:data[i]
				})
			); 
 		  }
 	 	}
	}
  
 
  /*
   * 根据设备id更改设备图标
   * @param id  设备实体id
   * @param url 设备图标url
   * */
  function changeIconById(id,url){
	  var entity = viewer.entities.getById(id);
	  if(entity && entity.billboard){
		  entity.billboard.image = url;
	  }
	  if(entity && entity.model){
		  entity.model.uri = url;
	  }
  }
  
  /*
   * 根据设备id重置设备图标
   * @param id  设备实体的id
   * */
  function resetIconById(id){
	  var defaultImgUrl = DEVIMGURL.device;
	  var entity = viewer.entities.getById(id);
	  if(entity && entity.billboard){
		  entity.billboard.image = defaultImgUrl;
	  }
	  if(entity && entity.model){
		  entity.model.uri = url;
	  }
  }
  
  /*
   * 添加总体概貌的消防栓
   * */
  function addXfs(data){
	  var xfsUrl = MODELURL.fireHydrant;
	  for(var i=0; i<data.length; i++){
		  var coordinate = eval("("+ data[i].coordinate +")");
		  if(coordinate != undefined && coordinate instanceof Array && coordinate.length == 3){	//简单验证经、纬度、高度
			  var position = new Cesium.Cartesian3.fromDegrees(coordinate[0],coordinate[1],coordinate[2]);
			  var heading = Cesium.Math.toRadians(180);
			  var pitch = Cesium.Math.toRadians(0);
			  var roll = Cesium.Math.toRadians(0);
			  var hpr = new Cesium.HeadingPitchRoll(heading, pitch, roll);
			  var orientation = Cesium.Transforms.headingPitchRollQuaternion(position, hpr);
			  
			  var xfsEntity = viewer.entities.add({
				    name : '浙江万胜园区消防栓',
				    id:'xfs'+data[i].equipmentid,
				    position : position,
				    orientation : orientation,
				    model : {
				        uri : xfsUrl,
				        scale : 1.0
				    }
				});
		  }
	  }
	}
  
  /*
   * 初始化弹出框
   * */
  function initPopup(){
		handler.setInputAction(function(movement) {
			var pick = viewer.scene.pick(movement.endPosition);
	        if(pick && pick.id && pick.primitive){
	        	$('#cesiumContainer').css('cursor', 'pointer');
	        }
	        if(pick && pick.primitive && pick.primitive instanceof Cesium.Billboard){
	        	$('#cesiumContainer').css('cursor', 'pointer');
	        }
	        else{
	        	$('#cesiumContainer').css('cursor', 'default');
	        }
	    }, Cesium.ScreenSpaceEventType.MOUSE_MOVE);		//鼠标平移更改鼠标样式
	    
	    $("#popup-closer").click(function(){
	    	$("#popup").hide();
	    })
		handler.setInputAction(function(movement) {
			var pick = viewer.scene.pick(movement.position);
			if(pick && pick.id && pick.primitive && pick.id._id){
				var entityId = pick.id._id+"";
				showPopupByEntityId(entityId);	//根据模型实体显示弹出框
			}
			else{
				$("#popup").hide();
			}
	    }, Cesium.ScreenSpaceEventType.LEFT_CLICK);	//鼠标左键点击
	    
	    viewer.camera.changed.addEventListener(function(event){
	    	if($("#popup").css("display")!="none"){
	    		var entityId = $("#entityId").val();
	    		var entity = viewer.entities.getById(entityId);
	    		var position;
	    		if(entity){
	    			position = entity._position._value;
	    		}else{
	    			for(var i=0;i<billboards._billboards.length;i++){
	    				if(billboards._billboards[i]._id.id == entityId){
	    					position = billboards._billboards[i]._position;
	    				}
	    			}
	    		}
	    		var pick = Cesium.SceneTransforms.wgs84ToWindowCoordinates(viewer.scene, position);
	    		if(pick!=undefined && pick.y <$("#cesiumContainer").height() && pick.x <$("#cesiumContainer").width()){
	    			if(pick.y > 0 && pick.x > 0){
	    				$("#popup").css("top",pick.y-171+"px");
						$("#popup").css("left",pick.x-137+"px");
	    			}else{
	    				$("#popup").hide();
	    			}
	    		}else{
	    			$("#popup").hide();
	    		}
	    	}
	    })
	}
  
  function showPopupByEntityId(entityId){
	  if(!entityId) return;
	  var entity = viewer.entities.getById(entityId);
	  var str = "<table class='popupTable' style='width:250px;table-layout:fixed;WORD-BREAK: break-all;WORD-WRAP:break-word;'><tbody>";
	  if(entity){			//暂时写死
		  var equipmenttype = entity.properties["equipmentname"]._value;
		  if(equipmenttype == "2"){
			  str += "<tr><td width='60px' align='right'>名称：</td>"
		           	+ "<td width='120px' align='left'><font color='#8a4141'>" + entity.name + "</font></td></tr>"
		           + "<tr><td width='60px' align='right'>静水压：</td>"
		           	+ "<td width='120px' align='left'><font color='#8a4141'>0.9MPa</font></td></tr>"
		           + "<tr><td width='60px' align='right'>出水压：</td>"
		           	+ "<td width='120px' align='left'><font color='#8a4141'>0.45MPa</font></td></tr>"
		           + "<tr><td width='60px' align='right'>地址：</td>"
		           	+ "<td width='120px' align='left'><font color='#8a4141'>万胜一号楼</font></td></tr>"
		           +"</tbody></table>";
		  }else{
			  str += "<tr><td width='60px' align='right'>名称：</td>"
	              	+ "<td width='120px' align='left'><font color='#8a4141'>" + entity.name + "</font></td></tr>"
	               + "<tr><td width='60px' align='right'>烟雾浓度：</td>"
	              	+ "<td width='120px' align='left'><font color='#8a4141'>2%obs/m</font></td></tr>"
	               + "<tr><td width='60px' align='right'>探测距离：</td>"
	               	+ "<td width='120px' align='left'><font color='#8a4141'>50平米（m）</font></td></tr>"
	               + "<tr><td width='60px' align='right'>负责人电话：</td>"
	                	+ "<td width='120px' align='left'><font color='#8a4141'>0571-88210378</font></td></tr>"
	               + "</tbody></table>";
		  }
		  position = entity._position._value;
		  var x,y;
		  var pick = Cesium.SceneTransforms.wgs84ToWindowCoordinates(viewer.scene, position);
		  if(pick!=undefined && pick.y <$("#cesiumContainer").height() && pick.x <$("#cesiumContainer").width()){
			  y = pick.y;
		      x = pick.x;
		  }
		  $("#popup-title").html("设备信息");
		  $("#popup-content").html(str);
		  $("#entityId").val(entityId);
		  $("#popup").css("top",y-171+"px");
		  $("#popup").css("left",x-137+"px");
		  $("#popup").show();
	  }
  }
  
  /*
  *	websocket组帧
  */
  function makeWSFrame(num, opcode, type, machineNum, data, ck) {
      //帧格式：序号 + 控制码 + 帧类型 + 前置机编号 + 数据长度 + 数据(类型1为请求) + 校验
      return "^" + num + "|" + opcode + "|" + type + "|" + machineNum + "|" + data.length + "|" + data + "|" + ck + "*";
  }

  /*
  *	websocket解帧
  */
  function parseWSFrame(frame) {
      //入口参数检查
      if (frame == null || frame == "") return "";
      var param = frame.split('|');
      if (param.length != 7) return "";
      var num = param[0];
      var opcode = param[1];
      var type = param[2];
      var machineNum = param[3]
      var len = param[4];
      var data = param[5];
      var ck = param[6].substring(0, param[6].indexOf('*'));
      return { num: num, opcode: opcode, type: type, machineNum: machineNum, len: len, data: data, ck: ck };
  }
  
  
  /*创建标注*/
  function createLabel(model){
  	var label,height;
  	if(model && model.label){
      	$.ajax({
              type: "get",
          url: model.label,
          async: false,
          success: function(d) {
			label = eval("("+d+")"),height = model.coords[2]+2.2;
			if(label.length > 0){
				for(var i=0;i<label.length;i++) {
			  		 var type = label[i].type;
			  		label[i].position[2] = height;
			    	 if(labelPicUrl[type]){
			    		 addLabelIcon(labelPicUrl[type],label[i].position);
			    	 }else{
			    		 addLabelIconAndText(labelPicUrl["default"],label[i].text,14,label[i].position);
			    	 }
			      }
				/*setTimeout(function(){
					updateBillboards();
				},100);*/
  				};
              }
          });
  	}	
  }

//只添加标注图标(不添加文字)
function addLabelIcon(url,position){
	 billboards.add({
  	    image: url,
  	    position: Cesium.Cartesian3.fromDegrees(position[0], position[1], position[2]),
  	    scale:0.4,
  	    pixelOffset : new Cesium.Cartesian2( 0,-10),
  	    show:false
  	})
}

/*
 * 添加图标和文字
 * @param url 图片路径
 * @param text 文字内容
 * @param fonsize 文字大小
 * @param position 标注添加的位置
 */
function addLabelIconAndText(url,text,fontsize,position){
	var img = new Image;
	img.src = url;
	img.onload = function(){
		var canvas = drawCanvas(img,text,fontsize);
	    billboards.add({
     	    image: canvas,
     	    position: Cesium.Cartesian3.fromDegrees(position[0], position[1], position[2]),
     	    scale:1,
     	    pixelOffset : new Cesium.Cartesian2( 0,-10),
     	    show:false
     	})
	}
}

//根据图片和文字绘制canvas
function drawCanvas(img,text,fontsize){
    var canvas = document.createElement('canvas');      //创建canvas标签
    var ctx = canvas.getContext('2d');

    ctx.fillStyle = '#99f';
    ctx.font = fontsize + "px Arial";

    canvas.width = ctx.measureText(text).width + fontsize * 2;      //根据文字内容获取宽度
    canvas.height = fontsize * 2; // fontsize * 1.5

    ctx.drawImage(img, fontsize/2,fontsize/2,fontsize,fontsize);

    ctx.fillStyle = '#000';
    ctx.font = fontsize + "px SimHei";
    ctx.shadowOffsetX = 1;    //阴影往左边偏，横向位移量
    ctx.shadowOffsetY = 0;   //阴影往左边偏，纵向位移量
    ctx.shadowColor = "#fff"; //阴影颜色
    ctx.shadowBlur = 0.3; //阴影的模糊范围
    ctx.fillText(text, fontsize*7/4, fontsize*4/3);
    return canvas;
}

//更新广告牌标注的显示
function updateBillboards(){
	var len = billboards.length;
	if(len == 0) return;
	var instantB = billboards.get(0);
	instantB.show = true;
	for (var i = 0; i < len; ++i) {
		if(i>0){
			if(isCollsionWithRect(instantB,billboards.get(i))){
				billboards.get(i).show = false;
			}else{
				billboards.get(i).show = true;
				instantB = billboards.get(i);
			}
		}
	}
}

//检测标注碰撞
function isCollsionWithRect(instantB,billboard){
	var position1 = instantB.position;
	var position2 = billboard.position;
	var screenPosition1 = Cesium.SceneTransforms.wgs84ToWindowCoordinates(viewer.scene, position1);
	var screenPosition2 = Cesium.SceneTransforms.wgs84ToWindowCoordinates(viewer.scene, position2);
	if(!screenPosition1 || !screenPosition2) return;
	var x1 = screenPosition1.x;
	var y1 = screenPosition1.y;
	var w1 = instantB.width*3;
	var h1 = instantB.height*3;
	
	
	var x2 = screenPosition2.x;
	var y2 = screenPosition2.y;
	var w2 = billboard.width*3;
	var h2 = billboard.height*3;
	
	if (x1 >= x2 && x1 >= x2 + w2) {
		return false;
	} else if (x1 <= x2 && x1 + w1 <= x2) {
		return false;
	} else if (y1 >= y2 && y1 >= y2 + h2) {
		return false;
	} else if (y1 <= y2 && y1 + h1 <= y2) {
		return false;
	}else{
		return true;
	}
}
	
//数组去重，算法
Array.prototype.unique = function(){
	 var res = [];
	 var json = {};
	 for(var i = 0; i < this.length; i++){
	  	if(!json[this[i]]){
	   		res.push(this[i]);
	   		json[this[i]] = 1;
	  	}
	 }
	 return res;
}