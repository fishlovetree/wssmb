var guidePointCollection;			 //绘制的辅助点
var drawHandler;                	 //鼠标事件
var isPolygon = false;         		 //是否是多边形
var activePoint = undefined;         //鼠标绘制的点
var tooltip;						//提示工具
var graphic = undefined;			//图形
var graphicPath = [];				//图形的坐标集合
var guideLine;                  //绘制面时的辅助线
var firstPoint;                 //保存绘制面时第一个点
var combatArea;					//保存作战区域坐标
var escapeRoute = [];		    //保存所有的逃生路线
var instantGraphic = undefined;		//当前绘制的图形
var graphicArray = [];				//保存所有的图形


//绘制初始化
function drawInit(){
	tooltipInit();
	guidePointInit();
}

//创建多边形
var CreatePolygon = (function() {               
    function _(positons) {
        if (!Cesium.defined(positons)) {
            throw new Cesium.DeveloperError('positions is required!');
        }
        if (positons.length < 3) {
            throw new Cesium.DeveloperError('positions 的长度必须大于等于3');
        }
        this.options = {
            polygon : {
                show : true,
                height:drawHeight,
                hierarchy : undefined,
                material : Cesium.Color.YELLOW.withAlpha(0.5)/*,
                outline:true,
                outlineWidth:2.0*/
            }			
        };
        this.path = positons;

        this._init();
    }

    _.prototype._init = function() {
        var that = this;
        var positionCBP = function() {
            return that.path;
        };
        this.options.polygon.hierarchy = new Cesium.CallbackProperty(positionCBP, false);
        instantGraphic = viewer.entities.add(this.options);		//赋值
    };

    return _;
})();

//创建线
var CreatePolyline = (function() {
    function _(positons) {
        this.options = {
            polyline : {
                show : true,
                material : new Cesium.PolylineArrowMaterialProperty(Cesium.Color.YELLOW.withAlpha(0.9)),	//带箭头
                width:8.0,
                followSurface:false
            }
        };
        this.path = positons;

        this._init();
    }
    _.prototype._init = function() {
        var that = this;
        var positionCBP = function() {
            return that.path;
        };
        this.options.polyline.positions = new Cesium.CallbackProperty(positionCBP, false);   //当属性赋值调用函数
        instantGraphic = viewer.entities.add(this.options);
    };
    return _;
})();

var drawHeight = 0;
//绘制图形，参数isPolygn，true为绘制多边形，false为绘制线
function DrawGraphic(isPolygon){
    drawHandler = viewer.cesiumWidget.screenSpaceEventHandler;
    resetDraw();
    if(typeof(recentHeight) != "undefined") drawHeight = recentHeight;
    drawHandler.setInputAction(function(movement) {
        var ray = viewer.scene.camera.getPickRay(movement.endPosition);
        var globeCartesian = viewer.scene.globe.pick(ray, viewer.scene);		//相机和鼠标射线与球体的交点
        if(!globeCartesian) return;
        var cartographic = viewer.scene.globe.ellipsoid.cartesianToCartographic(globeCartesian);	//转为弧度坐标
        
        var cameraCartographic = viewer.scene.globe.ellipsoid.cartesianToCartographic(viewer.scene.camera.position);	//相机世界坐标
        //var lng = Cesium.Math.toDegrees(cartographic1.longitude);  
        //var lat = Cesium.Math.toDegrees(cartographic1.latitude);  
        var cameraHeight = cameraCartographic.height;
        
        var drawLon = cartographic.longitude + (cameraCartographic.longitude - cartographic.longitude)*drawHeight/cameraHeight;
        var drawLat = cartographic.latitude + (cameraCartographic.latitude - cartographic.latitude)*drawHeight/cameraHeight;
        var drawCartographic = {
        		height:drawHeight,
        		longitude:drawLon,
        		latitude:drawLat
        }
        var cartesian = viewer.scene.globe.ellipsoid.cartographicToCartesian(drawCartographic);
        if(!cartesian) return;
        
        if(!activePoint){
            activePoint =  guidePointCollection.add(guidePoint(cartesian));
        }else{
            activePoint.position = cartesian;
        }
        /*if(isPolygon){              //绘制面时的辅助线
            if(firstPoint && guideLine && guideLine.path){
                if(guideLine.path.length == 2){
                    guideLine.path.pop();
                    guideLine.path.push(cartesian);         //引导线
                    guideLine.path.push(firstPoint);
                }
                if(guideLine.path.length >= 3){
                    guideLine.path.pop();
                    guideLine.path.pop();
                    guideLine.path.push(cartesian);         //引导线
                    guideLine.path.push(firstPoint);         //引导线
                }else{
                    guideLine.path.pop();
                    guideLine.path.push(cartesian);         //引导线
                }
            }
        }*/
        if (graphicPath.length == 0) {
            tooltip.showAt(movement.endPosition,"点击开始绘制！");
        }else{
            tooltip.showAt(movement.endPosition,"点击继续绘制，双击结束绘制！");
        }
        if (!Cesium.defined(graphic)) {
            if(isPolygon){
                if(graphicPath.length >= 2){        //绘制面
                    graphicPath.push(cartesian);
                    graphic = new CreatePolygon(graphicPath);
                }
            }else{
                if(graphicPath.length >= 1){        //绘制线
                    graphicPath.push(cartesian);
                    graphic = new CreatePolyline(graphicPath);
                }
            }
        } else {
            graphic.path.pop();
            graphic.path.push(cartesian);
        }
    }, Cesium.ScreenSpaceEventType.MOUSE_MOVE);

    drawHandler.setInputAction(function(movement) {
        var ray = viewer.scene.camera.getPickRay(movement.position);        //射线
        var globeCartesian = viewer.scene.globe.pick(ray, viewer.scene);
        if(!globeCartesian) return;
        var cartographic = viewer.scene.globe.ellipsoid.cartesianToCartographic(globeCartesian);	//转为弧度坐标
        
        var cameraCartographic = viewer.scene.globe.ellipsoid.cartesianToCartographic(viewer.scene.camera.position);	//相机世界坐标
        //var lng = Cesium.Math.toDegrees(cartographic1.longitude);  
        //var lat = Cesium.Math.toDegrees(cartographic1.latitude);  
        var cameraHeight = cameraCartographic.height;
        
        var drawLon = cartographic.longitude + (cameraCartographic.longitude - cartographic.longitude)*drawHeight/cameraHeight;
        var drawLat = cartographic.latitude + (cameraCartographic.latitude - cartographic.latitude)*drawHeight/cameraHeight;
        var drawCartographic = {
        		height:drawHeight,
        		longitude:drawLon,
        		latitude:drawLat
        }
        var cartesian = viewer.scene.globe.ellipsoid.cartographicToCartesian(drawCartographic);
        if(!cartesian) return;
        
        guidePointCollection.add(guidePoint(cartesian));     //增加辅助点
        /*if(isPolygon){
            if(graphicPath.length == 0){
                firstPoint = cartesian;
                guideLine = new CreatePolyline([cartesian,firstPoint]);
            }else{
                guideLine.path.pop();
                guideLine.path.push(cartesian);
                guideLine.path.push(firstPoint);
            }
        }*/
        graphicPath.push(cartesian);
    }, Cesium.ScreenSpaceEventType.LEFT_CLICK);

    drawHandler.setInputAction(function() {
        stopDraw(); 
        addDefaultClickHandler();	//恢复默认的点击事件
        /*if(isPolygon){			//只能绘制一个作战区域
        	combatArea = graphicPath;	
        	addGraphicByInstantGraphic(graphicPath,isPolygon);
        }else{
        	escapeRoute.push(graphicPath);
        	addGraphicByInstantGraphic(graphicPath,isPolygon)
        }*/
        addGraphicByInstantGraphic(graphicPath,isPolygon);
        tooltip.setVisible(false);            //隐藏提示工具
        guidePointCollection.removeAll();      //移除全部的辅助点
    }, Cesium.ScreenSpaceEventType.LEFT_DOUBLE_CLICK);
}

//绘制结束后，移除临时图层，根据临时图层添加新的图层
function addGraphicByInstantGraphic(graphicPath,isPolygon){
	viewer.entities.remove(instantGraphic);
	var option = {};
	var positions = [];
	var entity;
	for(var i=0;i<graphicPath.length;i++){
		positions.push(new Cesium.Cartesian3(graphicPath[i].x, graphicPath[i].y, graphicPath[i].z));
	}
	if(isPolygon){
		option = {
			name:{
				buildingId:buildingId?buildingId:undefined
			},
			polygon : {
	            show : true,
	            height:drawHeight,
	            hierarchy : positions,
	            material : Cesium.Color.YELLOW.withAlpha(0.5)
	        }	
		}
		entity = viewer.entities.add(option);
		combatArea = entity;
	}else{
		option = {
			name:{			//名称重复没关系
				buildingId:buildingId?buildingId:undefined
			},
            polyline : {
                show : true,
                material : new Cesium.PolylineArrowMaterialProperty(Cesium.Color.YELLOW.withAlpha(0.9)),	//带箭头
                width:8.0,
                followSurface:false,
                positions : positions
            }
        }
		entity = viewer.entities.add(option);
		escapeRoute.push(entity);
	}
	graphicArray.push(entity);			//添加到新绘制的图形
}
//停止绘制，移除鼠标监听
function stopDraw(){            
    drawHandler.removeInputAction(Cesium.ScreenSpaceEventType.MOUSE_MOVE);
    drawHandler.removeInputAction(Cesium.ScreenSpaceEventType.LEFT_CLICK);
    drawHandler.removeInputAction(Cesium.ScreenSpaceEventType.LEFT_DOUBLE_CLICK);
}

//重置一些参数
function resetDraw(){
	drawHandler.removeInputAction(Cesium.ScreenSpaceEventType.MOUSE_MOVE);
    drawHandler.removeInputAction(Cesium.ScreenSpaceEventType.LEFT_CLICK);
    drawHandler.removeInputAction(Cesium.ScreenSpaceEventType.LEFT_DOUBLE_CLICK);
    graphicPath = [];                     //清空线、面要素坐标
    graphic = undefined;                  //清空线、面要素
    activePoint = false;				  //动态的辅助点
    if(isPolygon){
    	//guideLine = undefined;                  //绘制面时的辅助线
        firstPoint = undefined;                 //保存绘制面时第一个点
    }
}

//绘制辅助点
function guidePoint(position){
    var billboard = {
        show : true,
        position : position,
        pixelOffset : new Cesium.Cartesian2(0, 0),
        eyeOffset : new Cesium.Cartesian3(0.0, 0.0, 0.0),
        horizontalOrigin : Cesium.HorizontalOrigin.CENTER,
        verticalOrigin : Cesium.VerticalOrigin.CENTER,
        scale : 1.0,
        image: basePath + '/images/gis/dragIcon.png',
        color : new Cesium.Color(1.0, 1.0, 1.0, 1.0)
    }
    return billboard;
}

//初始化辅助点集合
function guidePointInit(){
	guidePointCollection = new Cesium.BillboardCollection();			
	viewer.scene.primitives.add(guidePointCollection);
}

//提示框初始化
function tooltipInit(){
    var container = document.getElementById("cesiumContainer");
    tooltip = new createTooltip(container);
}

//创建提示框
function createTooltip(frameDiv){
    var wsTooltip = function(frameDiv) {
        var div = document.createElement('DIV');
        div.className = "tooltip_draw";
        this._div = div;
        frameDiv.appendChild(div);
    }

    wsTooltip.prototype.setVisible = function(visible) {
        this._div.style.display = visible ? 'block' : 'none';
    }

    wsTooltip.prototype.showAt = function(position, message) {      //屏幕坐标
        if(position && message) {
            this.setVisible(true);
            this._div.innerHTML = message;
            this._div.style.left = position.x + 10 + "px";
            this._div.style.top = (position.y - this._div.clientHeight / 2) + "px";
        }
    }
    return new wsTooltip(frameDiv);
}