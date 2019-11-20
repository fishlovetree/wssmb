var labelGroup;			//用于存放标注的组
var fireGroup;			//用于存放模拟火点图标的组
var deviceGroup;		//楼层设备组
var videoGroup;         //视频组
var floorGroup;         						//楼层组
var center = {x: 3390453.5408852194,y: 0,z:13474270.229348525 };             //中心点
var drawingPlane;       						//绘制的平面区域
var recentBuildingId;

var rightMenu,rightMenuPosition,rightMenuData;		//右键相关
var deviceOverlayArray = [];						//保存所有的设备覆盖物
var deviceStatusArray = [];							//保存设备状态
var instantOverlayArray;							//模拟演练中临时保存隐藏的外部标注
var noShowType = [];    							//保存不显示的设备类型，用以筛选
var selectedArea = undefined;						//保存选中的区域要素

//楼层子项的分类类型
var ObjType = {
    CUBE:"cube",
    FLOOR:"floor",          //地板
    CELL:"cell",            //常用的小隔间
    WALL:"wall",            //墙体
    GLASS:"glass",          //玻璃
    DISPLAY:"display"		//演示厅
}

//颜色常量 包括填充颜色和边框颜色
var colorConst = [
    {fill:"#F8D3A5",stroke:"#F7A540"},          //橙色
    {fill:"#f7dee4",stroke:"#EEAEEE"},          //粉红色，
    {fill:"#bfdaf7",stroke:"#99ccff"},          //蓝色
    {fill:"#ece4d8",stroke:"#D2B48C"}           //土色
]

//标注图片的路径
var labelPicUrl = {			
	1:basePath+"/images/gis/label/stairs1.png",					//楼梯图标
	2:basePath+"/images/gis/label/elevator1.png",				//电梯图标
	3:basePath+"/images/gis/label/wc1.png",						//厕所图标
	4:basePath+"/images/gis/label/goodelevator1.png",			//货梯图标
	"default":basePath+"/images/gis/label/default.png"			//默认的图标
}

//保存设备图片url
var DEVIMGURL = {
	defaultP:basePath + "/images/device/defaultP.png",				//默认图标
	defaultPAlarm:basePath + "/images/device/defaultPAlarm.png",
	smoke:basePath + "/images/device/smoke.png",					//烟感探测器
	smokeAlarm:basePath + "/images/device/smokeAlarm.png",
	fireHydrant:basePath + "/images/device/fireHydrant.png",		//消防栓
	fireHydrantAlarm:basePath + "/images/device/fireHydrantAlarm.png",	
	video:basePath + "/images/device/video.png",					//视频
	alarmer:basePath + "/images/device/alarmer.png",				//声光报警器
	alarmerAlarm:basePath + "/images/device/alarmerAlarm.png",	
	button:basePath + "/images/device/button.png",					//报警按钮
	buttonAlarm:basePath + "/images/device/buttonAlarm.png",
	detector:basePath + "/images/device/smokeDetector.png",			//可燃气体探测器
	detectorAlarm:basePath + "/images/device/smokeDetectorAlarm.png",
	watergage:basePath + "/images/device/watergage.png",			//水压
	watergageAlarm:basePath + "/images/device/watergageAlarm.png",
	monitor:basePath + "/images/device/monitor.png",				//电气火灾监控设备
	monitorAlarm:basePath + "/images/device/monitorAlarm.png"
}

//初始化三维对象
function init3DObject(){
	labelGroup = new THREE.Object3D();			//初始化标注组
    scene.add(labelGroup);
    
    fireGroup = new THREE.Group();				//初始化模拟点图标
    scene.add(fireGroup);
    
    deviceGroup = new THREE.Object3D();				//初始化楼层设备组
    scene.add(deviceGroup);
    
    videoGroup = new THREE.Object3D();				//初始化楼层视频组
    scene.add(videoGroup);
    
    floorGroup = new THREE.Object3D();				//初始化楼层模型组
    scene.add(floorGroup);
}

//三维页面窗口改变处理
function handleWindowResize() {
	if(container.style.display == "none") return;			//针对三维建筑，处理窗口改变事件
	var HEIGHT = container.clientHeight;		// 更新渲染器的高度和宽度以及相机的纵横比
	var WIDTH = container.clientWidth;
	camera.aspect = WIDTH / HEIGHT;
	camera.updateProjectionMatrix();
	renderer.setSize( WIDTH, HEIGHT );
	 
	updatePopPosition();		//更新弹出框的位置
    updateRightMenu();			//更新右键框位置
}

//三维页面窗口改变处理
function resizeThreeWindow(width,height) {
	camera.aspect = width / height;
	camera.updateProjectionMatrix();
	renderer.setSize( width, height );
	 
	updatePopPosition();		//更新弹出框的位置
    updateRightMenu()			//更新右键框位置
}

/*
 * 为设备添加dom类型的标注
 * @param {String} text 标注内容
 * @param {THREE.Vector3} position 设备位置点
 * @param {String} etype 设备类型
 * */
function addDeviceLabelToMap(text,position,etype){
	if(!(position instanceof THREE.Vector3)) return;
	var threePosition = [position.x,position.y,position.z];
	var deviceOverlay = new ws3doverlay({
		target:container,
		position:threePosition,
		text:text ? text : "",
		etype:etype
	})
	deviceOverlayArray.push(deviceOverlay);
}

//移除设备外部dom标注
function  removeDeviceLabel(){
	for(var i=0;i<deviceOverlayArray.length;i++){
		var deviceOverlay = deviceOverlayArray[i];
		deviceOverlay.clear();
	}
	deviceOverlayArray = [];
}

//更新外部标注的位置 和相交判断
function updateDeviceLabel(){
	if(!deviceOverlayArray || deviceOverlayArray.length == 0) return;
	for(var i=0;i<deviceOverlayArray.length;i++){
		var deviceOverlay = deviceOverlayArray[i];
		var level = getPointLevel(deviceOverlay.getThreePosition());
		if(level>2.8){			//模拟显示级别
			deviceOverlay.hide();
		}else{
			if(typeof(noShowType)!="undefined" && noShowType.length != 0){
				var show = true;
				for(var j=0;j<noShowType.length;j++){
					if(noShowType[j] == deviceOverlay.getEType()){
						show = false;
					}
				}
				if(!show){
					deviceOverlay.hide();
				}else{
					deviceOverlay.show();
				}
			}else{
				if(!deviceOverlay.getVisible()){
					deviceOverlay.show();
				}
			}
		}
	}
	for(var i=0;i<deviceOverlayArray.length;i++){		//设备标注集合 相交判断
		var comparedOverlay = deviceOverlayArray[i];
		comparedOverlay.updatePosition();
		if(comparedOverlay.getVisible()){
			for(var j=i+1;j<deviceOverlayArray.length;j++){
				var deviceOverlay = deviceOverlayArray[j];
				if(isDeviceLabelRect(comparedOverlay,deviceOverlay)){
					deviceOverlay.hide();
		        }
			}
		}
	}
}

/*
 *	验证两个标注是否相交 
 *  @param {ws3doverlay} a 标注a
 *  @param {ws3doverlay} b 标注b
 *  @return {boolean} true则相交
 */
function isDeviceLabelRect(a,b){
	if(!(a instanceof ws3doverlay) || !(b instanceof ws3doverlay)) return true;
	var acenter = a.getScreenPosition(),asize = a.getSize();
	var bcenter = b.getScreenPosition(),bsize = b.getSize();
	if(!acenter || !asize || !bcenter || !bsize) return true;
	var w1 = asize.width,h1 = asize.height;
	var x1 = acenter.x - w1/2,y1 = acenter.y - h1/2;
	
	var w2 = bsize.width,h2 = bsize.height;
	var x2 = bcenter.x - w2/2,y2 = bcenter.y - h2/2;
	
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

/*
 *	获取鼠标选中的设备和视频
 *	@param {number} x 屏幕坐标X
 *	@param {number} y 屏幕坐标Y
 *	@return {THREE.Sprite || undefined} intersects 设备或视频的Sprite
 */
function getDeviceIntersects(x,y){
	var vector = new THREE.Vector3();//三维坐标对象
    vector.set(
            ( x / container.clientWidth ) * 2 - 1,
            - ( y / container.clientHeight ) * 2 + 1,
            0.5 );
    vector.unproject( camera );
    var raycaster = new THREE.Raycaster(camera.position, vector.sub(camera.position).normalize());
    var intersects = raycaster.intersectObjects([deviceGroup,videoGroup],true);
    return intersects;
}

/*
 *	添加绘制平面，辅助绘制
 *	@param {Array} position [x,y,z,w]
 */
function addDrawingPlane(position){
	var height = position[2],buildHeight = position[3];		//楼的基点高度、和建筑厚度
	if(!drawingPlane){
		var geometry = new THREE.PlaneGeometry( 1000,1000,0.1);
		var material = new THREE.MeshBasicMaterial( {color: 0xffffff,transparent:true,opacity:0.0,side: THREE.DoubleSide} );
		drawingPlane = new THREE.Mesh( geometry, material );
		drawingPlane.position.x = 0;
		drawingPlane.position.y = height + buildHeight;
		drawingPlane.position.z = 0;
		drawingPlane.rotation.x = - Math.PI / 2;
		scene.add( drawingPlane );
	}else{
		drawingPlane.position.y = height + buildHeight;
	}
}

//删除绘制平面
function removeDrawingPlane(){
	if(drawingPlane){
		scene.remove(drawingPlane);
		drawingPlane = undefined;
	}
}

//清除一个建筑的通用要素
function clearBuilding(){
	if(floorGroup){
		scene.remove(floorGroup);		
		floorGroup = new THREE.Object3D();
		scene.add(floorGroup);								//清除楼层
	}
	if(deviceGroup){
		scene.remove(deviceGroup);			
		deviceGroup = new THREE.Object3D();
		scene.add(deviceGroup);								//清除设备图标
	}
	if(videoGroup){
		scene.remove(videoGroup);			
		videoGroup = new THREE.Object3D();
		scene.add(videoGroup);								//清除视频图标
	}
	if(labelGroup){
		scene.remove(labelGroup);			
		labelGroup = new THREE.Object3D();
		scene.add(labelGroup);								//清除楼层标注
	}
	if(deviceOverlayArray && deviceOverlayArray.length != 0){
		for(var i=0;i<deviceOverlayArray.length;i++){		//清除设备和楼层标注
			var deviceOverlay = deviceOverlayArray[i];
			deviceOverlay.clear();
		}
		deviceOverlayArray = [];
	}
	if(overlay && overlay.css("display") != "none"){
		popPosition = [];
		overlay.hide();						//隐藏弹出框
	}
}

var floorArrays = [];		//所有的楼层
/*
 * 添加楼层
 * @param model 楼层对应的模型实体 
 * (model.coords模型中心点坐标；model.url模型路径；model.cameraposition模型相机点位置	model.cameratarget模型相机目标位置)
 * */
function addmodel(model){
	center = getThreeCenter(model.coords);
	var position = lonlatToThree(model.coords);		//经纬度转three	
    if(model.url){									//模型json路径,有则添加
    	$.ajax({
    		type: "POST",//type: "get",
            url: model.url,
            dataType: "text",//数据类型可以为 text xml json  script  jsonp
            async: false,
            success: function(d) {
    			var floorInfo = eval("("+ d +")");
    			if(floorInfo instanceof Object){
    				var floor = new WsFloor(floorInfo);
    	            floor.load(position.y);
    			}
            }
    	})
    }
    var cameraposition = model.cameraposition ? model.cameraposition:undefined;
    var cameratarget = model.cameratarget ? model.cameratarget:undefined;
    adjustCamera(position,cameraposition,cameratarget); 
}


var cameraOffset;			//每个建筑的offset都不一样
/*
 *	根据楼层调整相机 
 *  @param {THREE.Vector3} position 目标点位置
 *  @param {Array} cameraposition 相机位置 [x,y,z]
 */
function adjustCamera(position,cameraposition,cameratarget){
   if(cameraposition && cameratarget){
	   cameraOffset = [cameraposition[0]-cameratarget[0],cameraposition[1]-cameratarget[1],cameraposition[2]-cameratarget[2]];
	   camera.position.y = position.y + cameraposition[1];
	   camera.position.z = position.z + cameraposition[2];
	   camera.position.x = position.x + cameraposition[0];
	   var targetx = position.x+cameratarget[0],targety = position.y+cameratarget[1],targetz = position.z+cameratarget[2]
	   camera.lookAt({x:targetx,y:targety,z:targetz});
	   controls.target = new THREE.Vector3(targetx,targety,targetz);
   }else{
	   cameraOffset = [0,10,0];
	   camera.position.y = position.y + 10;
	   camera.position.z = position.z;
	   camera.position.x = position.x;
	   camera.lookAt({x:position.x,y:position.y,z:position.z});
	   controls.target = new THREE.Vector3(position.x,position.y,position.z); 
   }
}

/*
 *	定位到一个设备sprite
 *	@param {THREE.Sprite} sprite 设备sprite 
 */
function flyToDevice(sprite){
	var position = sprite.position;
	if(!position || !cameraOffset) return;
	camera.position.y = position.y + cameraOffset[1];
    camera.position.z = position.z + cameraOffset[2];
    camera.position.x = position.x + cameraOffset[0];
    camera.lookAt({x:position.x,y:position.y,z:position.z});
    controls.target = new THREE.Vector3(position.x,position.y,position.z);           //设置orbit交互的中心点
}

/*
 *  显示弹出框内容
 *  @param {Array} position [x,y,z]弹出的三维世界坐标
 *  @param {String} header 弹出框标题
 *	@param {String} content 弹出框内容
 */
function showPopup(position,title,content){
	var screenPos = threeToScreenPos(position);
	popTitle.html(title);
	popContent.html(content);
	popPosition = position;
	var top = container.offsetTop !=0?container.offsetTop:0;
	var left = container.offsetLeft != 0?container.offsetLeft:0;
	overlay.css("top",screenPos.y + top - overlay.height()-40+"px");
	overlay.css("left",screenPos.x + left - overlay.width()/2+"px");
	overlay.show();
}

//隐藏设备弹出框
function hideDeviceInfo(){
	popPosition = [];
	overlay.hide();
}

//更新弹出框的位置，用户交互改变时触发
function updatePopPosition(){
	if(overlay.css("display")!="none"){
		if(popPosition.length != 0){
			var screenPos = threeToScreenPos(popPosition);
			var top = container.offsetTop !=0?container.offsetTop:0;
			var left = container.offsetLeft != 0?container.offsetLeft:0;
			overlay.css("top",screenPos.y + top - overlay.height()-40+"px");
			overlay.css("left",screenPos.x + left - overlay.width()/2+"px");
		}
	}
}

//隐藏右键菜单
function hideRightMenu(){
	rightMenuPosition = undefined;
	rightMenuData = undefined;
	rightMenu.hide();
}

//更新右键菜单位置	用户交互改变时触发
function updateRightMenu(){
	if(rightMenu && rightMenu.css("display")!="none" && rightMenuPosition){
		var position = threeToScreenPos(rightMenuPosition);
		rightMenu.css("top",position.y+"px");
		rightMenu.css("left",position.x+"px");
	}
}

//设备图片url常量
var DEVIMGURL = {
	defaultP:basePath + "/images/device/defaultP.png",				//默认图标
	defaultPAlarm:basePath + "/images/device/defaultPAlarm.png",
	smoke:basePath + "/images/device/smoke.png",					//烟感探测器
	smokeAlarm:basePath + "/images/device/smokeAlarm.png",
	fireHydrant:basePath + "/images/device/fireHydrant.png",		//消防栓
	fireHydrantAlarm:basePath + "/images/device/fireHydrantAlarm.png",	
	video:basePath + "/images/device/video.png",					//视频
	alarmer:basePath + "/images/device/alarmer.png",				//声光报警器
	alarmerAlarm:basePath + "/images/device/alarmerAlarm.png",	
	button:basePath + "/images/device/button.png",					//报警按钮
	buttonAlarm:basePath + "/images/device/buttonAlarm.png",
	detector:basePath + "/images/device/smokeDetector.png",			//可燃气体探测器
	detectorAlarm:basePath + "/images/device/smokeDetectorAlarm.png",
	watergage:basePath + "/images/device/watergage.png",			//水压
	watergageAlarm:basePath + "/images/device/watergageAlarm.png",
	monitor:basePath + "/images/device/monitor.png",				//电气火灾监控设备
	monitorAlarm:basePath + "/images/device/monitorAlarm.png"
}

/*
 * 添加楼层设备到地图上
 * @param {[Object]} data 设备数据组 
 * (Object.coordinate 设备经纬度	Object.equipmenttype 设备类型   
 * Object.systemtype 设备系统类型  Object.equipmentaddress 设备地址)
 * */
function addDeviceToMap(data){
    for(var i=0; i<data.length; i++){
    	var dataItem = data[i];
    	if(/^\[\d+(\.\d+)\,\d+(\.\d+)\,\d+(\.\d+)\]$/.test(dataItem.coordinate)){		//验证经纬度高度
			var coordinate = eval("("+ data[i].coordinate +")");
    		var loader = new THREE.TextureLoader();
			var url = getImageByType(dataItem.equipmenttype);
			var sprite = makeIconSprite(url);
			sprite.renderOrder = 2;		//渲染顺序
			sprite.center.set( 0.5, 0 );
	        sprite.name = 'syscode:'+data[i].systemtype+'address:' + data[i].equipmentaddress;
			sprite.userData = data[i];
			sprite.userData.type = "device";
			var spritePos = lonlatToThree(coordinate);
			sprite.position.x = spritePos.x;
			sprite.position.y = spritePos.y;
			sprite.position.z = spritePos.z;
			deviceGroup.add(sprite);			//添加设备到
    	}
	}
    
	var devices = deviceGroup.children ? deviceGroup.children:[];		//所有的设备
	for(var i=0;i<devices.length;i++){
	    var sprite = devices[i];
		var text = sprite.userData.equipmentname ? sprite.userData.equipmentname : "";
		var etype = sprite.userData.equipmenttype ? "device"+sprite.userData.equipmenttype : "";
		var position = sprite.position;
		addDeviceLabelToMap(text,position,etype);						//添加设备标注
	}
	if(instantOverlayArray){			//模拟演练中隐藏设备外部标注
		instantOverlayArray = deviceOverlayArray;
		for(var i=0;i<deviceOverlayArray.length;i++){
			var overlay_ = deviceOverlayArray[i];
			if(overlay_) overlay_.hide();
		}
		deviceOverlayArray = [];
	}
}

/*
 *	根据设备类型获取设备图标
 *	@param {String} type 设备类型
 *	@return {String} ImgUrl 图标路径
 */
function getImageByType(type){
	var ImgUrl;
	switch(type){
		case "1":
			ImgUrl = DEVIMGURL.smoke;
			break;
		case "21":						//烟感
			ImgUrl = DEVIMGURL.smoke;
			break;
		case "61":						//报警按钮
			ImgUrl = DEVIMGURL.button;
			break;
		case "62":						//消防栓
			ImgUrl = DEVIMGURL.fireHydrant;
			break;
		case "82":						//声光报警器
			ImgUrl = DEVIMGURL.alarmer;
			break;
		case "101":						//可燃气体探测器
			ImgUrl = DEVIMGURL.detector;
			break;
		case "110":						//电气火灾监控设备
			ImgUrl = DEVIMGURL.monitor;
			break;
		case "181":						//水压探测器
			ImgUrl = DEVIMGURL.watergage;
			break;
		default:
			ImgUrl = DEVIMGURL.defaultP;
	}
	return ImgUrl;
}

/*
 * 添加楼层摄像头到地图上
 * @param {[Object]} data 摄像头数组 
 * (Object.coordinate 摄像头经纬度 Object.videomonitorid 摄像头id Object.videomonitorcode 摄像头编码)
 * */
function addVideoToMap(data){
    for(var i=0; i<data.length; i++){
    	if(/^\[\d+(\.\d+)\,\d+(\.\d+)\,\d+(\.\d+)\]$/.test(data[i].coordinate)){
		     var coordinate = eval("("+ data[i].coordinate +")");
		     var url = DEVIMGURL.video;
		     var sprite = makeIconSprite(url);
		     sprite.renderOrder = 1;
		     sprite.center.set( 0.5, 0 );
	         sprite.name = 'videomonitorid:'+data[i].videomonitorid+';' + data[i].videomonitorcode;
		     sprite.userData = data[i];
		     sprite.userData.type = "video";
		     var spritePos = lonlatToThree(coordinate);
		     sprite.position.x = spritePos.x;
		     sprite.position.y = spritePos.y;
		     sprite.position.z = spritePos.z;
		     videoGroup.add(sprite);
    	}
    }
    var videos = videoGroup.children ? videoGroup.children:[];
    for(var i=0;i<videos.length;i++){
    	var video = videos[i],etype = "video";
		var text = video.userData.videomonitorname ? video.userData.videomonitorname:"";
		addDeviceLabelToMap(text,video.position,etype);								//添加视频标注
    }
}

/*
 *	 创建楼层标注
 * 	@param {Object} model --model.label 模型标注文件的路径
 */
function createLabel(model){
	if(!model || !model.label) return;
	$.ajax({
		type: "POST",//type: "get",
        url: model.label,
        dataType: "text",//数据类型可以为 text xml json  script  jsonp
        async: true,
        success: function(d) {
			var label = eval("("+d+")");
			for(var i=0;i<label.length;i++) {
		 		 var type = label[i].type;
			   	 if(labelPicUrl[type]){
			   		addIconSprite(labelPicUrl[type],label[i].position);
			   	 }else{
			   		addLabelSprite(label[i].text,label[i].position);
			   	 }
		     }
        }
	})
}

/*
 * 根据图片url添加标注
 * @param {String} url 图片的路径
 * @param {Array} position 标注点的经纬度高度[lon,lat,height]
 */
function addIconSprite(url,position){
	var sprite = makeIconSprite(url);
	sprite.renderOrder = 0;
	var spritePos = lonlatToThree(position);
	sprite.center.set( 0.5, 0 );		//设置锚点
    sprite.position.x = spritePos.x;
    sprite.position.y = spritePos.y;
    sprite.position.z = spritePos.z;
    sprite.visible = false;
    labelGroup.add(sprite);
}

/*
 *	根据图片创建Sprite，通用方法
 *	@param {String} url 图片路径 
 *	@return {THREE.Sprite} sprite 图标sprite
 */
function makeIconSprite(url){
    var loader = new THREE.TextureLoader();
    var texture = loader.load(url);
    var spriteMaterial = new THREE.SpriteMaterial({ map: texture,depthWrite:false});
    var sprite = new THREE.Sprite(spriteMaterial);
    return sprite;
}

/*
 *	根据文字添加标注 
 *	@param {String} message 文字内容 
 *	@param {Array} position 经纬度高度
 */
function addLabelSprite(message,position){
	var sprite = makeTextSprite(message);
	sprite.renderOrder = 0;
    sprite.center = new THREE.Vector2(0.5,0);
    
	var spritePos = lonlatToThree(position);
    sprite.position.x = spritePos.x;
    sprite.position.y = spritePos.y;
    sprite.position.z = spritePos.z;
    sprite.visible = false; 
    labelGroup.add(sprite);
}

/*
 * 根据文字创建sprite
 * @param {String} message 文字内容
 * @return {THREE.Sprite} sprite 文字sprite
 */
function makeTextSprite(message){
    var textCanvas = makeTextCanvas(message);
	var texture = new THREE.Texture(textCanvas);
    texture.needsUpdate = true;
    var spriteMaterial = new THREE.SpriteMaterial({map : texture,depthWrite:false});
    var sprite = new THREE.Sprite(spriteMaterial);
    return sprite; 
}

/*
 * 根据文字绘制canvas图形
 * @param {String} text 文字内容
 * @return canvas canvas图形
 */
function makeTextCanvas(text) {
    var canvas = document.createElement( 'canvas' );
    var context = canvas.getContext( '2d' );
    
    context.font='50px Microsoft YaHei';
    canvas.width = context.measureText(text).width;      //根据文字内容获取宽度
    canvas.height = 58; // fontsize * 1.5

    context.beginPath();
    context.font='50px Microsoft YaHei';
    context.fillStyle = "#222";
    context.fillText(text,0,50);
    context.fill();
    context.stroke();
    return canvas;
}

/*
 *	根据图标+文字 绘制图形canvas
 *  @param url {String} 图标路径
 *  @param text {String} 文字内容
 *  @return {canvas} 图形
 */
function makeIconTextCanvas(url,text){
	var img = new Image;
	img.src = url;
	img.onload = function () {              //为了解决图片异步加载的问题
        var canvas = drawDeviceCanvas(img,text,12);
        var color = '#f00';
    	var fontsize = 14;
    	var canvas = document.createElement('canvas');      //创建canvas标签
        var ctx = canvas.getContext('2d');
        ctx.font = fontsize + "px Calibri,sans-serif";
        var length = ctx.measureText(message).width;
        
        canvas.width = length + 8;      //根据文字内容获取宽度
        canvas.height = 40 + fontsize; // fontsize * 1.5
        ctx.drawImage(img, (length + 8)/2-16,8 + fontsize,32,32);	//x,y,width,height

        ctx.fillStyle = color;
        ctx.font = fontsize + "px Calibri,sans-serif";
        ctx.fillText(message, 4, fontsize+4);
        console.log(canvas);
    }
}

/*
 *	获取POI标注sprite的合适比例
 *	@param {THREE.Vector3} position poi点的位置
 *  @param {Object} poiRect sprite的像素高度和宽度{w:width,h:height}
 *  @return {Array}	[scaleX,scaleY,1.0]
 */
function getPoiScale(position,poiRect){
    if(!position) return;
    var distance = camera.position.distanceTo(position);        //相机和标注点的距离
    var top = Math.tan(camera.fov / 2 * Math.PI / 180)*distance;    //camera.fov 相机的拍摄距离
    var meterPerPixel = 2*top/container.clientHeight;
    var scaleX = poiRect.w * meterPerPixel;
    var scaleY = poiRect.h * meterPerPixel;
    return [scaleX,scaleY,1.0];
}

/*	
 * 	获取设备Sprite的大小比例
 *	@param {THREE.Vector3} position poi点的位置
 *  @param {Object} poiRect sprite的像素高度和宽度{w:width,h:height}
 *  @return {Array}	[scaleX,scaleY,1.0] 
 */
function getDeviceScale(position,poiRect){			//1-2之间  20-200
	if(!position) return;
    var distance = camera.position.distanceTo(position);        //相机和标注点的距离
    var minDis = controls.minDistance,maxDis = controls.maxDistance;
 	var level = 1+(distance - minDis)*6/(maxDis - minDis);		 //按照相机与点的距离，细分为7个级别
     
 	var top = Math.tan(camera.fov / 2 * Math.PI / 180)*distance;    //camera.fov 相机的拍摄距离
    var meterPerPixel = 2*top/container.clientHeight;
    var scaleX = (1.2-level/14)*poiRect.w * meterPerPixel;
    var scaleY = (1.2-level/14)*poiRect.h * meterPerPixel;
    return [scaleX,scaleY,1.0];
}

//var v = new THREE.Vector3();
//var scale_factor = 3;
//sprite.scale.x = sprite.scale.y = v.subVectors( sprite.position, camera.position ).length() / scale_factor;

/*
 * 	相机点与某位置的距离与 最大最小距离的比值,距离不足以判断
 * 	@param {THREE.Vector3} position sprite点的位置
 *	@return {number} 比值
 */
function getPointLevel(position){
	var distance = camera.position.distanceTo(position);        //相机和标注点的距离
	var minDis = controls.minDistance,maxDis = controls.maxDistance;
	return (distance - minDis)*6/(maxDis - minDis);
}

//更新文字sprite标注
function updateLabelSprite(){
    var sprites = labelGroup.children;
    if(sprites.length == 0) return; 
    for(var i=0;i<sprites.length;i++){
		var sprite = sprites[i];
		sprite.visible = true;
	}
    
    for(var i=0;i<sprites.length;i++){
    	var compareSprite = sprites[i];
    	var canvas = compareSprite.material.map.image;
        if(canvas){
        	var position =  compareSprite.position;
        	var scale = getPoiScale(position,{w:canvas.width,h:canvas.height});
        	compareSprite.scale.set(scale[0]/4,scale[1]/4,1.0);
        	if(compareSprite.visible){		//true
    			for(var j=i+1;j<sprites.length;j++){
    				var sprite = sprites[j];
    				if(isPOILabelRect(compareSprite,sprite)){
    					sprite.visible = false;
    		        }
    			}
    		}
        }
    }
}

/*
 *	检测两个标注sprite是否碰撞
 *  @param {THREE.Sprite} sprite1 标注sprite1
 *  @param {THREE.Sprite} sprite2 标注sprite2
 *  @return {boolean} true则碰撞 false不碰撞
 */
function isPOILabelRect(sprite1,sprite2){
    var comparePosition = threeToScreenPos([sprite1.position.x,sprite1.position.y,sprite1.position.z]);
    var spritePosition = threeToScreenPos([sprite2.position.x,sprite2.position.y,sprite2.position.z]);
    
    var image1 = sprite1.material.map.image;
    var image2 = sprite2.material.map.image;
    var w1 = image1.width/2;
    var h1 = image1.height/2;
    var x1 = comparePosition.x - w1/2;
    var y1 = comparePosition.y - h1/2;

    var w2 = image2?image2.width/2:0;
    var h2 = image2?image2.height/2:0;

    var x2 = spritePosition.x - w2/2;         //点2左下角的xy点
    var y2 = spritePosition.y - h2/2;

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
    
//更新设备sprite尺寸，并和设备筛选结合
function updateDeviceSprite(){
	var sprites = deviceGroup.children;
	if(!deviceGroup || !sprites || sprites.length == 0) return;
	for(var i=0;i<sprites.length;i++){
		var sprite = sprites[i];
		var position =  controls.target;//sprite.position;
        var canvas = sprite.material.map.image;
        if(canvas){
        	var scale = getDeviceScale(position,{w:canvas.width,h:canvas.height});
        	sprite.scale.set(scale[0],scale[1],1.0);
        	var show = true;
        	if(typeof(noShowType)!="undefined" && noShowType.length != 0){	
    			var etype = "device" + sprite.userData.equipmenttype;
    			for(var j=0;j<noShowType.length;j++){
    				if(noShowType[j] == etype){
    					show = false;
    				}
    			}
    		}
			if(show){		//&& !isOffScreen(position,camera)
				sprite.visible = true;
			}else{
				sprite.visible = false;
			}	
        }
    }
}

//更新视频sprite的尺寸，并和设备筛选结合
function updateVideoSprite(){
	var sprites = videoGroup.children;
	if(!videoGroup || !sprites || sprites.length == 0) return;
    for(var i=0;i<sprites.length;i++){
    	var sprite = sprites[i];
		var position =  sprites[i].position;
        var canvas = sprites[i].material.map.image;
        if(canvas){
        	var scale = getPoiScale(position,{w:canvas.width,h:canvas.height});
            sprites[i].scale.set(scale[0],scale[1],1.0);
            var show = true;
            if(typeof(noShowType)!="undefined" && noShowType.length != 0){
    			var etype = "video";
    			for(var j=0;j<noShowType.length;j++){
    				if(noShowType[j] == etype){
    					show = false;
    				}
    			}
    		}
            if(show){
				sprite.visible = true;
			}else{
				sprite.visible = false;
			}
        }
    }
}

/*
 *	测试三维点坐标是否在可视范围内
 * 	@param {Array} position 三维点坐标 [x,y,z]
 *  @return {boolean}
 */
function isOffScreen(position){
    var Vector = new THREE.Vector3(
            position[0],
            position[1],
            position[2]
    );
    var frustum = new THREE.Frustum(); //Frustum用来确定相机的可视区域
    var cameraViewProjectionMatrix = new THREE.Matrix4();
    cameraViewProjectionMatrix.multiplyMatrices(camera.projectionMatrix, camera.matrixWorldInverse); //获取相机的法线
    frustum.setFromMatrix(cameraViewProjectionMatrix); //设置frustum沿着相机法线方向

    return frustum.containsPoint(Vector);       //可视范围包含这个点
}

/*
 * 初始化三维中心点的墨卡托坐标，用以经纬度转三维世界坐标
 * @param {Array} coords 经纬度高度坐标
 * @return {Object} 中心点的三维坐标
 */
function getThreeCenter(coords){
	var z = coords[2]? coords[2]:0;
    var x = (coords[0] / 180.0) * 20037508.3427892;
    var y = (Math.PI / 180.0) * coords[1];
    var tmp = Math.PI / 4.0 + y / 2.0;
    y = 20037508.3427892 * Math.log(Math.tan(tmp)) / Math.PI;
	return {x: y,y: 0,z:x };
}

/*
 *	三维中这里使用Z轴对应实际的经度，Y轴对应实际的高度，X轴对应实际的纬度
 *   @param {Array} lonlat 经纬度高度 
 *   @return {Object} {x,y,z} 三维世界坐标
 */
function lonlatToThree(lonlat){
    var z = lonlat[2]? lonlat[2]:0;
    var x = (lonlat[0] / 180.0) * 20037508.3427892;
    var y = (Math.PI / 180.0) * lonlat[1];
    var tmp = Math.PI / 4.0 + y / 2.0;
    y = 20037508.3427892 * Math.log(Math.tan(tmp)) / Math.PI;
    var result = {
        x: y - center.x,
        y: z - center.y,
        z: x -center.z
    };
    return result;
}

/*
 *  三维世界坐标转经纬度坐标
 *  @param {THREE.Vector3} 
 *  @return {Array} [lon,lat,height]
 */
function threeToLonlat(three){
    var lng = (three.z + center.z)/20037508.34*180;
    var lat = (three.x + center.x)/20037508.34*180;
    lat= 180/Math.PI*(2*Math.atan(Math.exp(lat*Math.PI/180))-Math.PI/2);
    var height = three.y + center.y;
    return [lng, lat,height]; //[114.32894001591471, 30.58574800385281]  
}

/*
 *  判断一个点是否在多边形内部 
 *  @param {[[x1,y1],[x2,y2],[x3,y3]]}points 多边形坐标集合 
 *  @param {[test1,test2]} testPoint 测试点坐标 
 *  @return {boolean} 返回true为真，false为假 
 */  
function insidePolygon(points, testPoint){  
    var x = testPoint[0], y = testPoint[1];  
    var inside = false;  
    for (var i = 0, j = points.length - 1; i < points.length; j = i++) {  
        var xi = points[i][0], yi = points[i][1];  
        var xj = points[j][0], yj = points[j][1];  

        var intersect = ((yi > y) != (yj > y))  
                && (x < (xj - xi) * (y - yi) / (yj - yi) + xi);  
        if (intersect) inside = !inside;  
    }  
    return inside;  
}

/*
 * 	屏幕坐标与指定平面相交的three坐标
 *	鼠标的点在三维中是射线，需要借助绘制平面来转三维世界坐标
 *  @param screenX 屏幕坐标X screenY 屏幕坐标Y
 * 	@return  {THREE.Vector3}	鼠标和绘制平面相交的坐标
 */
function convertTo3DCoordinate(screenX,screenY){
	if(!drawingPlane || typeof(drawingPlane)==="undefined") return;
    var mv = new THREE.Vector3(
        (screenX / container.clientWidth) * 2 - 1,
        -(screenY / container.clientHeight) * 2 + 1,
        0.5 );
    mv.unproject(this.camera);
    var raycaster = new THREE.Raycaster(camera.position, mv.sub(camera.position).normalize());
   	var intersects = raycaster.intersectObjects([drawingPlane]);	//scene.children
    if (intersects.length > 0) {
       var selected = intersects[0];//取第一个物体
   	   return selected.point;		//相交点坐标
    }
}

/*
 * 三维坐标转屏幕坐标
 * @param {Array} position 三维世界坐标[0,0,0]
 * @return {object}	屏幕坐标
 */
function threeToScreenPos(position){
    var worldVector = new THREE.Vector3(
            position[0],
            position[1],
            position[2]
    );
    var standardVector = worldVector.project(camera);//世界坐标转标准设备坐标
    var a = container.clientWidth / 2;
    var b = container.clientHeight / 2;
    var x = Math.round(standardVector.x * a + a);//标准设备坐标转屏幕坐标
    var y = Math.round(-standardVector.y * b + b);//标准设备坐标转屏幕坐标
    return {
        x: x,
        y: y
    };
}

/*
 *	根据建筑id获取模型
 *	@param {String} id 建筑id
 *	@param {String} url 模型路径
 *	@param {function || undefined}	callback 回调函数
 */
function addModelByBuildingId(id,url, callback){
 	$.ajax({
	    type:'POST', 
        url: url,           
        data:{"id":id},
        async:false,
        success:function(data){
    	    var dataObj = eval("("+data+")");
    	    if(null != dataObj){
    		   var json = {id:dataObj.modelcode,url:dataObj.modelurl,heading: eval("("+dataObj.rotation+")")[2],
 	    	           name: dataObj.modelname,coords: eval("("+dataObj.position+")"),label:dataObj.label,
 	    	           cameraposition:eval("("+dataObj.cameraposition+")"),cameratarget:eval("("+dataObj.cameratarget+")")};
    		   addmodel(json);
    		   if (typeof(callback) === "function"){
	    			callback(json);
	    		}
    	    }else{
    	    	if (typeof(callback) === "function"){
	    			callback(null);
	    		}
    	    }
        },	        
        error:function(data){
        }
    });
 }

/*
 *	根据建筑id添加设备
 *	@param {String} id 建筑id
 *	@param {String} url 后台路径
 *	@param {function || undefined } callback 回调函数
 */
function getEquipmentByBuildingId(id,url,callback){
 	$.ajax({
	    type:'POST', 
        url: url,           
        data:{"id":id},
        async:false,
	    success:function(data){
	    	var dataObj = eval("("+data+")");
	    	if(dataObj && dataObj instanceof Array && dataObj.length!=0){
	    		addDeviceToMap(dataObj,true);
	    		if (typeof(callback) === "function"){
	    			callback(dataObj);
	    		}
	    	}
	    },	        
	    error:function(data){
        }
	});
}
 
/*
 *	根据建筑id添加摄像头
 *	@param {String} id 建筑id
 *	@param {String} url 后台路径
 *	@param {function || undefined } callback 回调函数
 */
 function getVideoByBuildingId(id,url,callback){
  	$.ajax({
 	    type:'POST', 
        url: url,           
        data: {"id":id},
        async:false,
 	    success:function(data){
 	        var dataObj = eval("("+data+")");
 	       if(dataObj && dataObj instanceof Array && dataObj.length!=0){
 	    	  addVideoToMap(dataObj,true);
	    		if (typeof(callback) === "function"){
	    			callback(dataObj);
	    		}
	    	}
 	    },	        
 	    error:function(data){
        }
 	});
}

var deviceAlarmArray = [];		//告警设备的集合
var deviceAlarmParam = 0;		//设备告警的参数，保证所有告警频率一致
//设备告警动画
function updateDeviceAlarm(){
	if(!deviceAlarmArray || deviceAlarmArray.length == 0) return;
	deviceAlarmParam ++;
	deviceAlarmParam = deviceAlarmParam%2;
	if(deviceAlarmParam == 0){
		for(var i=0;i<deviceAlarmArray.length;i++){
			var deviceAlarm = deviceAlarmArray[i];
			changeSpriteByName(deviceAlarm.name,deviceAlarm.imgurl);	//正常样式
		}
	}else{
		for(var i=0;i<deviceAlarmArray.length;i++){
			var deviceAlarm = deviceAlarmArray[i];
			changeSpriteByName(deviceAlarm.name,deviceAlarm.imgurlalarm);	//告警样式
		}
	}
}

/*
 *	增加告警 
 *  @param {String} name 模拟的设备名称 syscode:'+systemtype+'address:' + equipmentaddress
 *  @param {boolean} flag 告警标记(true告警 false消除告警)
 *  @param {String} equipmenttype 设备类型，不同的设备类型对应不同的显示图片
 */
function deviceAlarm(name,flag,equipmenttype){
	var imgurl="";
	var imgurlalarm="";
	switch(equipmenttype){
	case "21":						//烟感
		imgurl = DEVIMGURL.smoke;
	    imgurlalarm = DEVIMGURL.smokeAlarm;
		break;
	case "61":						//报警按钮
		imgurl = DEVIMGURL.button;
	    imgurlalarm = DEVIMGURL.buttonAlarm;
		break;
	case "62":						//消防栓
		imgurl = DEVIMGURL.fireHydrant;
	    imgurlalarm = DEVIMGURL.fireHydrantAlarm;
		break;
	case "82":						//声光报警器
		imgurl = DEVIMGURL.alarmer;
	    imgurlalarm = DEVIMGURL.alarmerAlarm;
		break;
	case "101":						//可燃气体探测器
		imgurl = DEVIMGURL.detector;
	    imgurlalarm = DEVIMGURL.detectorAlarm;
		break;
	case "110":						//电气火灾监控设备
		imgurl = DEVIMGURL.monitor;
	    imgurlalarm = DEVIMGURL.monitorAlarm;
		break;
	case "181":						//水压探测器
		imgurl = DEVIMGURL.watergage;
	    imgurlalarm = DEVIMGURL.watergageAlarm;
		break;
	default:
		imgurl = DEVIMGURL.defaultP;
		imgurlalarm = DEVIMGURL.defaultPAlarm;
	}
	
	if(!flag){
		for(var i=0;i<deviceAlarmArray.length;i++){
			if(name == deviceAlarmArray[i].name){
				changeSpriteByName(name,imgurl);	//恢复正常
				deviceAlarmArray.splice(i,1);
			}
		}						
	}
	else{
		var isAlarm = false;
		for(var i=0;i<deviceAlarmArray.length;i++){
			if(name == deviceAlarmArray[i].name){
				isAlarm = true;
			}
		}
		if(!isAlarm){
			var deviceAlarm = {name:name,imgurl:imgurl,imgurlalarm:imgurlalarm};
			deviceAlarmArray.push(deviceAlarm);
		}
    }
}

/*
 *	根据设备名称(虚拟的名称)更改设备图标
 *  @param {String} name 设备名称 syscode:'+systemtype+'address:' + equipmentaddress
 *  @param {String} url 图标的路径
 */
function changeSpriteByName(name,url){
	var loader = new THREE.TextureLoader();
	var texture = loader.load(url, function () { }, undefined, function () { });
	var spriteMaterial = new THREE.SpriteMaterial({ map: texture,color:0xffffff });
	 
	var sprite = deviceGroup.getObjectByName(name);   //根据名称获取
	if(sprite){
	    sprite.material = spriteMaterial;
	}
}

//全屏
var fullscreen = function () {
	var elem = document.body;
    if (elem.webkitRequestFullScreen) {
        elem.webkitRequestFullScreen();
    } else {
        if (elem.mozRequestFullScreen) {
            elem.mozRequestFullScreen()
        } else {
            if (elem.requestFullScreen) {
                elem.requestFullscreen()
            } else {
                alert("浏览器不支持全屏");
            }
        }
    }
};

//取消全屏
var exitFullscreen = function () {
    var elem = parent.document;
    if (elem.webkitCancelFullScreen) {
        elem.webkitCancelFullScreen()
    } else {
        if (elem.mozCancelFullScreen) {
            elem.mozCancelFullScreen()
        } else {
            if (elem.cancelFullScreen) {
                elem.cancelFullScreen()
            } else {
                if (elem.exitFullscreen) {
                    elem.exitFullscreen()
                } else {
                    alert("浏览器不支持全屏")
                }
            }
        }
    }
};

//绑定捕捉全屏变化
function bindFullscreen() {
    document.addEventListener("fullscreenchange", function () {
        changeFullscreen();
    }, false);
    document.addEventListener("mozfullscreenchange", function () {
        changeFullscreen();
    }, false);
    document.addEventListener("webkitfullscreenchange", function () {
        changeFullscreen();
    }, false);
    document.addEventListener("MSFullscreenChange", function () {
        changeFullscreen();
    }, false);
}

//全屏变化事件
function changeFullscreen() {
    var isFullscreen = document.fullscreenElement || document.mozFullScreenElement || document.webkitFullscreenElement || document.msFullscreenElement; //是否处于全屏状态document.fullscreenElement || document.mozFullScreenElement || document.webkitFullscreenElement;
    if (!isFullscreen) {
        $("#fullScreenBtn a").attr("title","全屏");
        if($("#fullScreenBtn a i").hasClass("icon-cancelFullscreen")){		//cancelFullscreen
        	$("#fullScreenBtn a i").removeClass("icon-cancelFullscreen");
        	$("#fullScreenBtn a i").addClass("icon-fullscreen");
        }
        $("#fullScreenBtn").unbind('click', exitFullscreen);
        $("#fullScreenBtn").bind('click', fullscreen);
    } else {
    	$("#fullScreenBtn a").attr("title","退出全屏");
    	if($("#fullScreenBtn a i").hasClass("icon-fullscreen")){		//cancelFullscreen
        	$("#fullScreenBtn a i").removeClass("icon-fullscreen");
        	$("#fullScreenBtn a i").addClass("icon-cancelFullscreen");
        }
        $("#fullScreenBtn").unbind('click', fullscreen);
        $("#fullScreenBtn").bind('click', exitFullscreen);
    }
}

//初始化全屏
function initFullscreen(){
	$("#fullScreenBtn").bind('click', fullscreen);
	bindFullscreen();
}



/*
 * 楼层示例数据
 */
var floorInfo =
{
    buildingId:01,buildingName:"万胜1号楼4层",center:[120,30,6],
    buildingItems:[
        {type:"floor",name:"地板",points:[[-53.70,0,13.94],[-50.34,0,11.59],[-44.45,0,19.99],[-5.23,0,-7.47],[0,0,0],[12.14,0,-8.5],[53.99,0,51.26],[79.43,0,33.45],[14.53,0,-59.22],[-56.66,0,-9.37],[-55.48,0,-7.69],[-64.45,0,-1.41]]},
        {type:"wall",name:"1",color:0,points:[[46.47,0,11.7586],[46.5354,0,11.852],[58.2316,0,3.66221],[58.1662,0,3.56883]]},
        {type:"wall",name:"2",color:1,points:[[33.1769,0,21.0666],[33.2423,0,21.16],[44.9385,0,12.9702],[44.8731,0,12.8768]]},
        {type:"cell",name:"3",color:2,points:[[76.6906,0,30.0243],[73.9705,0,26.1396],[70.2725,0,28.7289],[72.9926,0,32.6137]]},
        {type:"wall",name:"4",color:3,points:[[15.8232,0,-21.9625],[7.25063,0,-15.9599],[6.85831,0,-16.5202],[14.8706,0,-22.1305],[-2.50946,0,-46.9518],[-1.94916,0,-47.3441]]},
        {type:"cell",name:"5",color:2,points:[[7.53654,0,-15.0746],[6.90882,0,-15.9711],[4.14467,0,-14.0356],[4.77239,0,-13.1391]]},
        {type:"cell",name:"6",color:1,points:[[-31.6316,0,-10.194],[-32.8478,0,-11.931],[-34.8649,0,-10.5186],[-33.6487,0,-8.78167]]},
        {type:"cell",name:"7",color:0,points:[[-31.4746,0,-9.96993],[-33.4917,0,-8.55755],[-32.0793,0,-6.54047],[-30.0623,0,-7.95285]]},
        {type:"cell",name:"8",color:1,points:[[-39.0863,0,-8.98224],[-34.8492,0,-2.931],[-31.5188,0,-5.26294],[-35.7559,0,-11.3142]]},
        {type:"cell",name:"9",color:2,points:[[-35.1421,0,-2.7259],[-39.3792,0,-8.77714],[-43.0025,0,-6.2401],[-38.7654,0,-0.188857]]},
        {type:"cell",name:"10",color:3,points:[[-46.7971,0,0.146606],[-48.471,0,-2.24401],[-53.7565,0,1.45694],[-52.0826,0,3.84755]]},
        {type:"cell",name:"11",color:2,points:[[-51.9256,0,4.07167],[-49.5978,0,7.39612],[-46.4601,0,5.19909],[-48.7879,0,1.87464]]},
        {type:"cell",name:"12",color:1,points:[[-48.5638,0,1.71771],[-46.236,0,5.04216],[-44.3123,0,3.69517],[-46.6401,0,0.370726]]},
        {type:"cell",name:"13",color:0,points:[[54.9134,0,44.1595],[58.2379,0,41.8317],[56.0409,0,38.694],[52.7164,0,41.0218]]},
        {type:"cell",name:"14",color:1,points:[[-50.1128,0,11.4307],[-44.3848,0,19.6111],[-38.9731,0,15.8218],[-44.7011,0,7.64143]]},
        {type:"cell",name:"15",color:2,points:[[-60.2006,0,0.95912],[-61.7134,0,2.0184],[-59.5164,0,5.15608],[-56.3787,0,2.95905],[-57.7911,0,0.941973],[-59.416,0,2.07972]]},
        {type:"cell",name:"16",color:3,points:[[-52.0631,0,9.12235],[-56.2218,0,3.18317],[-59.3595,0,5.3802],[-55.2008,0,11.3194]]},
        {type:"cell",name:"17",color:2,points:[[-53.6315,0,13.5606],[-50.4938,0,11.3636],[-51.9062,0,9.34647],[-55.0439,0,11.5435]]},
        {type:"cell",name:"18",color:1,points:[[-55.2866,0,-0.728232],[-52.1489,0,-2.92526],[-55.3267,0,-7.46369],[-58.4644,0,-5.26666]]},
        {type:"cell",name:"19",color:0,points:[[-34.2038,0,-24.7592],[-37.5934,0,-22.3857],[-31.8563,0,-14.2118],[-28.4758,0,-16.5788]]},
        {type:"cell",name:"20",color:1,points:[[-24.0481,0,-10.494],[-28.2068,0,-16.4331],[-30.971,0,-14.4977],[-26.8123,0,-8.55848]]},
        {type:"cell",name:"21",color:2,points:[[-35.0218,0,-10.7427],[-33.0047,0,-12.1551],[-33.4363,0,-12.7714],[-35.4534,0,-11.3591]]},
        {type:"cell",name:"22",color:3,points:[[-12.8586,0,-2.46377],[-18.5866,0,-10.6441],[-37.0132,0,2.25828],[-31.2852,0,10.4387]]},
        {type:"cell",name:"23",color:2,points:[[-44.477,0,7.4845],[-38.749,0,15.6649],[-31.5093,0,10.5956],[-37.2373,0,2.41521]]},
        {type:"cell",name:"24",color:1,points:[[1.74755,0,-5.45436],[-0.0827666,0,-4.17276],[-1.0505,0,-5.55484],[-2.7314,0,-4.37786],[0.0671895,0,-0.38105],[3.5784,0,-2.83963]]},
        {type:"cell",name:"25",color:0,points:[[1.97167,0,-5.61129],[3.80252,0,-2.99656],[7.03359,0,-5.25897],[5.20273,0,-7.87371]]},
        {type:"cell",name:"26",color:1,points:[[7.69347,0,-14.8505],[4.92932,0,-12.915],[9.21876,0,-6.78905],[11.9829,0,-8.72452]]},
        {type:"cell",name:"27",color:2,points:[[1.92625,0,-50.0577],[-1.86724,0,-47.4014],[3.90649,0,-39.1557],[7.69999,0,-41.8119]]},
        {type:"cell",name:"28",color:3,points:[[16.1045,0,-47.6968],[10.3308,0,-55.9426],[2.01964,0,-50.1231],[7.79337,0,-41.8773]]},
        {type:"cell",name:"29",color:2,points:[[14.4676,0,-58.8393],[10.4241,0,-56.008],[16.1979,0,-47.7622],[20.2414,0,-50.5935]]},
        {type:"cell",name:"30",color:1,points:[[65.5678,0,31.6892],[50.0432,0,9.51786],[58.289,0,3.74413],[73.8135,0,25.9155]]},
        {type:"cell",name:"31",color:0,points:[[70.8642,0,39.1141],[68.6671,0,35.9764],[73.0375,0,32.9163],[76.8475,0,30.2484],[79.0445,0,33.3861]]},
        {type:"cell",name:"32",color:1,points:[[59.5154,0,41.2712],[54.8462,0,44.5406],[52.4923,0,41.1788],[48.9811,0,43.6373],[54.0552,0,50.8839],[62.2355,0,45.1559]]},
        {type:"cell",name:"33",color:2,points:[[67.253,0,34.4338],[65.566,0,32.0245],[64.6695,0,32.6522],[66.3565,0,35.0615]]},
        {type:"cell",name:"34",color:3,points:[[65.7901,0,31.8675],[67.0847,0,33.7165],[69.3633,0,32.1211],[69.4025,0,32.1771],[69.7949,0,32.7374],[71.7746,0,31.3512],[70.0484,0,28.8859]]},
        {type:"cell",name:"35",color:2,points:[[0.925462,0,-7.10542],[4.15653,0,-9.36784],[1.9595,0,-12.5055],[-1.27156,0,-10.2431]]},
        {type:"cell",name:"36",color:1,points:[[-37.8084,0,-22.2352],[-56.2796,0,-9.30152],[-51.7678,0,-2.85807],[-55.1296,0,-0.504112],[-53.9134,0,1.23282],[-48.4038,0,-2.62506],[-44.0882,0,3.53824],[-38.9895,0,-0.0319267],[-43.4228,0,-6.36332],[-35.5599,0,-11.869],[-35.4422,0,-11.7009],[-32.0804,0,-14.0548]]},
        {type:"cell",name:"37",color:0,points:[[-31.2947,0,-5.41987],[-29.2776,0,-6.83225],[-29.9053,0,-7.72873],[-31.9224,0,-6.31635]]},
        {type:"cell",name:"38",color:1,points:[[-64.0674,0,-1.3434],[-61.8704,0,1.79428],[-60.3576,0,0.735],[-61.1422,0,-0.3856],[-59.5173,0,-1.52335],[-60.9297,0,-3.54043]]}
    ]
}

/*
 * 楼层数据初始化
 * @param {Object} floor 楼层数据自定义json
 */
var WsFloor = function(floor){
    if(!floorGroup){
        console.log("组件初始化尚未完成！");
        return;
    }
    this.container = floorGroup;
    this.floorItem = new THREE.Object3D();		//floorGroup;  //存放楼层元素的容器
    this.container.add(this.floorItem);
    this.data = floor;
}

/*
 *	楼层数据加载
 *	@param {number} height 楼层所在的高度 
 */
WsFloor.prototype.load = function(height){
    var floor = this.data;
    var id = floor.buildingId,name = floor.buildingName;
    var items = floor.buildingItems;
    for(var i=0;i<items.length;i++){
        var item = items[i];
        var type = item.type;
        var points = item.points;
        switch(type){
            case ObjType.CELL:
                var colorIndex = item.color;
                this.addCell(points,2,colorIndex);
                break;
            case ObjType.WALL:
                this.addWall(points,2.5);
                break;
            case ObjType.FLOOR:
                this.addFloor(points,0.1);
                break;
            case ObjType.DISPLAY:
                var colorIndex = item.color;
            	this.addDisplay(points,0.2,colorIndex);
                break;
        }
    }
    this.floorItem.position.y = height;
}

/*
*   创建地板平面
*   @param {Array} points 底部坐标集合
*   @height {number} height 地板高度
* */
WsFloor.prototype.addFloor = function(points,height){
	var transPoints = [];
	for(var i=0;i<points.length;i++){
		var point = points[i];
		transPoints.push([-point[2],point[1],point[0]]);		//z轴是反的
	}
	var geometry = this.getGeometry(transPoints,height);
    geometry.computeFaceNormals();          //计算法向量
    var material = [
        new THREE.MeshLambertMaterial({color: "#eee",side:THREE.DoubleSide,blending:THREE.NoBlending}),
        new THREE.MeshBasicMaterial({color: "#eee",side:THREE.DoubleSide,blending:THREE.NoBlending})
    ]
    var mesh = new THREE.Mesh(geometry,material);
    mesh.castShadow = true;
    this.floorItem.add(mesh);				//添加填充
    if(controls) controls.minDistance = 30;
}

/*
*   创建演示厅
*   @param {Array} points 底部坐标点集合
*   @param {number} height 高度
*   @param {number} colorIndex 颜色在colorConst中的序号
* */
WsFloor.prototype.addDisplay = function(points,height,colorIndex){
    var geometry = new THREE.CubeGeometry(4, 0.2, 1.88, 0, 0, 1);
    var materials = [];
	var texture = new THREE.TextureLoader().load( '/WSSF/images/gis/display.png');
	for(var i=0;i<6;i++){
		var material;
		if(i==2){
			material = new THREE.MeshBasicMaterial({map: texture,side:THREE.DoubleSide});		//顶部
		}else{
			material = new THREE.MeshBasicMaterial({color:"#f7dee4",side:THREE.DoubleSide});
		}
		materials.push(material);    
    }
    
    var cube = new THREE.Mesh(geometry, materials);
    cube.position.y = 0.1;
    cube.rotation.y = Math.PI*125/180;		//逆时针旋转90+45
    this.floorItem.add(cube);
    if(controls) controls.minDistance = 4;
}

/*
*   创建不规则的小室
*   @param {Array} points 底部坐标点集合
*   @param {number} height 高度
*   @param {number} colorIndex 颜色在colorConst中的序号
* */
WsFloor.prototype.addCell = function(points,height,colorIndex){
	var transPoints = [];
	for(var i=0;i<points.length;i++){
		var point = points[i];
		transPoints.push([-point[2],point[1],point[0]]);		//z轴是反的
	}
    var geometry = this.getGeometry(transPoints,height);
    geometry.computeFaceNormals();          //计算法向量
    var material = [
        new THREE.MeshLambertMaterial({color:colorConst[colorIndex].fill,side:THREE.DoubleSide}),
        new THREE.MeshBasicMaterial({color:colorConst[colorIndex].fill,side:THREE.DoubleSide})		//不受光照影响
    ];
    var mesh = new THREE.Mesh(geometry,material);
    this.floorItem.add(mesh);				//添加填充

    var lineMaterial = new THREE.LineBasicMaterial({color:colorConst[colorIndex].stroke});
    var lineGeometry =this.getBorderGeometry(transPoints,height);
    var line = new THREE.Line(lineGeometry, lineMaterial);
    this.floorItem.add(line);
}

/*
*   创建墙体
*   @param {Array} points 底部坐标点集合
*   @param {number} height 墙体的高度
*/
WsFloor.prototype.addWall = function(points,height){
	var transPoints = [];
	for(var i=0;i<points.length;i++){
		var point = points[i];
		transPoints.push([-point[2],point[1],point[0]]);		//z轴是反的
	}
    var geometry = this.getGeometry(transPoints,height);
    geometry.computeFaceNormals();          //计算法向量
    var material = [
        new THREE.MeshLambertMaterial({color:'#fff',side:THREE.DoubleSide,blending:THREE.NoBlending}),
        new THREE.MeshBasicMaterial({color:'#fff',side:THREE.DoubleSide,blending:THREE.NoBlending})
    ]
    var mesh = new THREE.Mesh(geometry,material);
    this.floorItem.add(mesh);				//添加填充
}

/*
 *	生成顶部的边线 
 *	@param {Array} points 底部坐标点集合
 *	@param {number} height 盒子的高度
 * 	@param {number} color 颜色序号
 */
WsFloor.prototype.getBorderGeometry = function(points,height,color){
    var geometry = new THREE.Geometry();
    var topPoints = [];
    for(var i=0;i<points.length;i++){
        var vertice = points[i];
        topPoints.push([vertice[0],vertice[1]+height,vertice[2]]);
    }
    for(var i=0;i<topPoints.length;i++){
        var topPoint = topPoints[i];
        geometry.vertices.push(new THREE.Vector3(topPoint[0],topPoint[1],topPoint[2]));
        if(i==topPoints.length-1){
            geometry.vertices.push(new THREE.Vector3(topPoints[0][0],topPoints[0][1],topPoints[0][2]));
        }
    }
    return geometry;
}

/*
 *	根据传入的底部坐标点和高度，创建几何 
 *	@param {Array} points 底部坐标点集合
 *	@param {height} height 高度
 *	@return {THREE.Geometry} geometry
 */
WsFloor.prototype.getGeometry = function(points,height){
    if(points.length < 3){
        console.log("至少需要三个点来创建盒子");
        return;
    }
    var topPoints = [];
    for(var i=0;i<points.length;i++){
        var vertice = points[i];
        topPoints.push([vertice[0],vertice[1]+height,vertice[2]]);
    }
    var totalPoints = points.concat(topPoints);
    var vertices =[];
    for(var i=0;i<totalPoints.length;i++){
        vertices.push(new THREE.Vector3(totalPoints[i][0],totalPoints[i][1],totalPoints[i][2]))
    }
    var length = points.length;
    var faces = [];
    for(var j=0;j<length;j++){                      //侧面生成三角形
        if(j!=length-1){
            faces.push(new THREE.Face3(j,j+1,length+j+1));
            faces.push(new THREE.Face3(length+j+1,length+j,j));
        }else{
            faces.push(new THREE.Face3(j,0,length));
            faces.push(new THREE.Face3(length,length+j,j));
        }
    }
    var data=[];
    for(var i=0;i<length;i++){
        data.push(points[i][0],points[i][2]);
    }
    var triangles = Earcut.triangulate(data);
    if(triangles && triangles.length != 0){
        for(var i=0;i<triangles.length;i++){
            var tlength = triangles.length;
            if(i%3==0 && i < tlength-2){
                faces.push(new THREE.Face3(triangles[i],triangles[i+1],triangles[i+2]));                            //底部的三角面
                var topface = new THREE.Face3(triangles[i]+length,triangles[i+1]+length,triangles[i+2]+length);
                topface.materialIndex = 1;
                faces.push(topface);        //顶部的三角面
            }
        }
    }
    var geometry = new THREE.Geometry();
    geometry.vertices = vertices;
    geometry.faces = faces;
    return geometry;
}

//清除楼层数据
WsFloor.prototype.clear = function(){
	floorGroup.remove(this.floorItem);
    this.floorItem = null;
}
