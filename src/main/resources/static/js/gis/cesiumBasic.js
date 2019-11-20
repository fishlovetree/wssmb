var ws3d = {};			//定义一个对象保存所有的基础方法
var viewer;				//视图
var globe;				//地球
var imageryProvider;	//底图
var billboards;			//图形集合
var handler;			//保存三维控件的事件
var tileset;
var recentEntity;

Window.LOADING_FLAG = true;
var loadingBar;
var oldTime;
var dTime;	//进度动画参数

//进度动画
ws3d.run = function(){			
	var curTime = new Date().getTime();
    if (curTime - oldTime >= 3500) {
        loadingBar.className = "";
        if (curTime - oldTime >= 3550) {
            loadingBar.className = "ins";
            oldTime = curTime;
        }
    }
    if (Window.LOADING_FLAG == true) {
        requestAnimationFrame(ws3d.run);
    }
}

//初始化进度条
ws3d.initLoadingBar = function(){	
	loadingBar = document.getElementById('loadbar');
	oldTime = new Date().getTime();
	requestAnimationFrame(this.run);	
}

//加载的文字
ws3d.loadText = function(str){
	$("#loadText").html(str);
}

//隐藏进度动画
ws3d.hideLoadingBar = function(){	
	$("#loadOverlay").hide();
	$('#loadbar').removeClass('ins');
	Window.LOADING_FLAG = false;
}

//球体初始化
ws3d.globeInit = function(boolean){
	globe = new Cesium.Globe(Cesium.Ellipsoid.WGS84);
	if(!boolean){
		globe.show = false;
	}
}

//底图初始化
ws3d.basicMapInit = function(url){
	if(!url){	//默认加载谷歌底图
		url = 'http://mt2.google.cn/vt/lyrs=y&hl=zh-CN&gl=CN&src=app&x={x}&y={y}&z={z}&s=G';
	}
	imageryProvider = new Cesium.UrlTemplateImageryProvider({
        url : url,
        minimumLevel:0,
        maximumLevel:21
    })
}

//视图初始化
ws3d.initViewer = function(){
	viewer = new Cesium.Viewer('cesiumContainer', {
        animation: false,            //是否显示图层选择器
        baseLayerPicker: false,      //是否显示全屏按钮
        fullscreenButton: false,     //是否显示geocoder小器件，右上角查询按钮
        geocoder: false,	//坐标查询
        homeButton: false,//是否显示Home按钮
        infoBox: false,//是否显示信息框   
        //sceneMode:Cesium.SceneMode.SCENE2D,		//视图模式，默认为3d模式
        sceneModePicker: false, //是否显示3D/2D选择器
        selectionIndicator: false,//是否显示选取指示器组件
        skyBox: new Cesium.SkyBox({//关闭月亮、星星等
            show: false
        }),
        globe:globe,
        timeline: false,//是否显示时间轴
        navigationHelpButton: false,	//是否显示右上角的帮助按钮
        scene3DOnly: true,	//如果设置为true，则所有几何图形以3D模式绘制以节约GPU资源
        navigationInstructionsInitiallyVisible: false,
        showRenderLoopErrors: false,
        imageryProvider:imageryProvider
    });
	
	var canvas = viewer.canvas; // 获取画布
    canvas.setAttribute('tabindex', '0'); // 获取焦点
    canvas.onclick = function() {
        canvas.focus();
    };
    
	viewer.scene.globe.enableLighting = false;      //不允许光照
	viewer._cesiumWidget.creditContainer.style.display = "none";	//用js的方法去掉logo
	viewer.scene.backgroundColor = Cesium.Color.AZURE;			//白色背景
	
	 billboards = new Cesium.BillboardCollection();//图形集合
     viewer.scene.primitives.add(billboards);
     
    viewer.camera.percentageChanged = 0.01;		//设置触发相机改变时间的百分比
    //viewer.camera.constrainedAxis = new Cesium.Cartesian3(1.0, 1.0, 1.0);
    viewer.camera.setView({
    	destination: Cesium.Cartesian3.fromDegrees(121.01800918579102,29.13677215576172, 8000.0),//设置相机位置经度、纬度、高度
    	orientation: {
    		//heading : Cesium.Math.toRadians(10.0),
    		pitch : Cesium.Math.toRadians(-90.0),//垂直向下90度
    		roll : 0.0
    	}
    });
    
	viewer.scene.screenSpaceCameraController.enableRotate = true;		//旋转
	//viewer.scene.screenSpaceCameraController.enableTranslate = true;	//平移
	viewer.scene.screenSpaceCameraController.enableZoom = true;	//缩放
	viewer.scene.screenSpaceCameraController.enableTilt = true;	//倾斜
	viewer.scene.screenSpaceCameraController.enableLook = false;
	viewer.scene.screenSpaceCameraController.zoomEventTypes = [Cesium.CameraEventType.WHEEL];	//设置滚轮缩放
	viewer.scene.screenSpaceCameraController.tiltEventTypes = [Cesium.CameraEventType.RIGHT_DRAG];	//设置右键倾斜
	viewer.scene.screenSpaceCameraController.minimumZoomDistance = 1.0;		//缩放的最小距离，不会进入地球和模型内部
	viewer.scene.screenSpaceCameraController.maximumZoomDistance = 1000000.0;		//缩放的最大距离
	
	viewer.scene.screenSpaceCameraController.inertiaSpin = 0;			//惯性
	viewer.scene.screenSpaceCameraController.inertiaTranslate = 0;
	viewer.scene.screenSpaceCameraController.inertiaZoom = 0;
	
	handler = new Cesium.ScreenSpaceEventHandler(viewer.scene.canvas);//初始化鼠标事件
	
	viewer.camera.changed.addEventListener(function(event){
		updateBillboards();
	})
}

//视图初始化
ws3d.initFloorViewer = function(){
	ws3d.loadText("初始化三维控件!");
	viewer = new Cesium.Viewer('cesiumContainer', {
        animation: false,            //是否显示图层选择器
        baseLayerPicker: false,      //是否显示全屏按钮
        fullscreenButton: false,     //是否显示geocoder小器件，右上角查询按钮
        geocoder: false,	//坐标查询
        homeButton: false,//是否显示Home按钮
        infoBox: false,//是否显示信息框    
        sceneModePicker: false, //是否显示3D/2D选择器
        selectionIndicator: false,//是否显示选取指示器组件
        skyBox: new Cesium.SkyBox({//关闭月亮、星星等
            show: false
        }),
        globe:globe,
        timeline: false,//是否显示时间轴
        navigationHelpButton: false,	//是否显示右上角的帮助按钮
        scene3DOnly: true,	//如果设置为true，则所有几何图形以3D模式绘制以节约GPU资源
        navigationInstructionsInitiallyVisible: false,
        showRenderLoopErrors: false,
        imageryProvider:imageryProvider
    });
    
	viewer.scene.globe.enableLighting = false;      //不允许光照
	viewer._cesiumWidget.creditContainer.style.display = "none";	//用js的方法去掉logo
	viewer.scene.backgroundColor = Cesium.Color.AZURE;			//白色背景
	
	 billboards = new Cesium.BillboardCollection();//图形集合
     viewer.scene.primitives.add(billboards);
     
    viewer.camera.percentageChanged = 0.01;		//设置触发相机改变时间的百分比
    //viewer.camera.constrainedAxis = new Cesium.Cartesian3(1.0, 1.0, 1.0);
    viewer.camera.setView({
    	destination: Cesium.Cartesian3.fromDegrees(121.01800918579102,29.13677215576172, 500.0),//设置相机位置经度、纬度、高度
    	orientation: {
    		heading : Cesium.Math.toRadians(10.0),
    		pitch : Cesium.Math.toRadians(-90.0),//垂直向下90度
    		roll : 0.0
    	}
    });
    
	viewer.scene.screenSpaceCameraController.enableRotate = true;		//旋转
	//viewer.scene.screenSpaceCameraController.enableTranslate = true;	//平移
	viewer.scene.screenSpaceCameraController.enableZoom = true;	//缩放
	viewer.scene.screenSpaceCameraController.enableTilt = true;	//倾斜
	viewer.scene.screenSpaceCameraController.enableLook = false;
	viewer.scene.screenSpaceCameraController.zoomEventTypes = [Cesium.CameraEventType.WHEEL];	//设置滚轮缩放
	viewer.scene.screenSpaceCameraController.tiltEventTypes = [Cesium.CameraEventType.RIGHT_DRAG];	//设置右键倾斜
	viewer.scene.screenSpaceCameraController.minimumZoomDistance = 1.0;		//缩放的最小距离，不会进入地球和模型内部
	viewer.scene.screenSpaceCameraController.maximumZoomDistance = 10000.0;		//缩放的最大距离
	
	viewer.scene.screenSpaceCameraController.inertiaSpin = 0;			//惯性
	viewer.scene.screenSpaceCameraController.inertiaTranslate = 0;
	viewer.scene.screenSpaceCameraController.inertiaZoom = 0;
	
	handler = new Cesium.ScreenSpaceEventHandler(viewer.scene.canvas);//初始化鼠标事件
	
	viewer.camera.changed.addEventListener(function(event){
		updateBillboards();
	})
}

//添加三维切片
ws3d.addModelTile = function(url){
	if(recentEntity){
		recentEntity = null;
	}
	
	tileset = viewer.scene.primitives.add(new Cesium.Cesium3DTileset({
	    url : url
	}));
	 
	tileset.readyPromise.then(function(tileset) {
		ws3d.loadText("正在加载模型!");
	});
	 
	tileset.tileLoad.addEventListener(function(tile) {
		ws3d.loadText("模型加载成功!");
		ws3d.hideLoadingBar();
	});
}

//右键初始化
ws3d.contextmenuInit = function(){
	$("#cesiumContainer").on("contextmenu", function(event){  
	    event.preventDefault();//屏蔽自带的右键事件  
	}); 
	handler.setInputAction(function(movement) {
		var pick = viewer.scene.pick(movement.endPosition);
        if(pick && pick.primitive && pick.primitive instanceof Cesium.Billboard){
        	if(pick.primitive)
        	$('#cesiumContainer').css('cursor', 'pointer');
        }else{
        	$('#cesiumContainer').css('cursor', 'default');
        }
    }, Cesium.ScreenSpaceEventType.MOUSE_MOVE);		//鼠标平移
	
	handler.setInputAction(function(movement) {
		if($("#contextmenu_container").css("display")){
    		$("#contextmenu_container").hide();
    	}
    }, Cesium.ScreenSpaceEventType.LEFT_CLICK);	//鼠标左键点击
    
    viewer.camera.changed.addEventListener(function(event){
    	$("#contextmenu_container").hide();
    })
}