(function (global, factory) {
    typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory() :
        typeof define === 'function' && define.amd ? define(factory) :
            (global.FlashMarker = factory());
}(this, (function () { 'use strict';
 
    /**
     * @author lzugis
     * @Date 2017-09-29
     * */
    function CanvasLayer(options) {
        this.options = options || {};
        this.paneName = this.options.paneName || 'labelPane';
        this.zIndex = this.options.zIndex || 201;
        this._map = options.map;
        this._lastDrawTime = null;
        this.show();
    }

    CanvasLayer.prototype.initialize = function () {
        var map = this._map;
        var canvas = this.canvas = document.createElement('canvas');
        var ctx = this.ctx = this.canvas.getContext('2d');
        canvas.style.cssText = 'position:absolute;' + 'left:0;' + 'top:0;' + 'z-index:' + this.zIndex + ';';
        this.adjustSize();
        this.adjustRatio(ctx);
        document.getElementsByClassName("amap-maps")[0].appendChild(canvas);
        var that = this;

        map.on('mapmove',function(e){
            that.adjustSize();
            if(alarmAnimateMarker && alarmAnimateMarker.markers){
                var markers = alarmAnimateMarker.markers;
                for(var i=0;i<markers.length;i++){
                    markers[i].minSize();
                }
            }
         })
        map.on('resize',function(){
            that.adjustSize();
            if(alarmAnimateMarker && alarmAnimateMarker.markers){
                var markers = alarmAnimateMarker.markers;
                for(var i=0;i<markers.length;i++){
                    markers[i].minSize();
                }
            }
        })
    };
 
    CanvasLayer.prototype.adjustSize = function () {
        var size = this._map.getSize();
        var canvas = this.canvas;
        canvas.width = size.width;
        canvas.height = size.height;
        canvas.style.width = canvas.width + 'px';
        canvas.style.height = canvas.height + 'px';
    };
 
    CanvasLayer.prototype.adjustRatio = function (ctx) {
        var backingStore = ctx.backingStorePixelRatio || ctx.webkitBackingStorePixelRatio || ctx.mozBackingStorePixelRatio || ctx.msBackingStorePixelRatio || ctx.oBackingStorePixelRatio || ctx.backingStorePixelRatio || 1;
        var pixelRatio = (window.devicePixelRatio || 1) / backingStore;
        var canvasWidth = ctx.canvas.width;
        var canvasHeight = ctx.canvas.height;
        ctx.canvas.width = canvasWidth * pixelRatio;
        ctx.canvas.height = canvasHeight * pixelRatio;
        ctx.canvas.style.width = canvasWidth + 'px';
        ctx.canvas.style.height = canvasHeight + 'px';
        ctx.scale(pixelRatio, pixelRatio);
    };
 
    CanvasLayer.prototype.getContainer = function () {
        return this.canvas;
    };
 
    CanvasLayer.prototype.show = function () {
        this.initialize();
        this.canvas.style.display = 'block';
    };
 
    CanvasLayer.prototype.hide = function () {
        this.canvas.style.display = 'none';
    };
 
    CanvasLayer.prototype.setZIndex = function (zIndex) {
        this.canvas.style.zIndex = zIndex;
    };
 
    CanvasLayer.prototype.getZIndex = function () {
        return this.zIndex;
    };
 
    var global = typeof window === 'undefined' ? {} : window;
 
    var requestAnimationFrame = global.requestAnimationFrame || global.mozRequestAnimationFrame || global.webkitRequestAnimationFrame || global.msRequestAnimationFrame || function (callback) {
            return global.setTimeout(callback, 1000 / 60);
        };
 
    function Marker(opts,circleType) {
        //this.city = opts.name;
        this.lonlat = opts.lonlat;
        this.color = opts.color || '#FF4500';
        this.type = opts.type || 'circle';
       
        this.size = 0;
        if(circleType==0){
        	this.speed = opts.speed || 0.2;
        	this.max = opts.max || 25;
        }else{
        	this.speed = opts.speed || 0.6;
        	this.max = opts.max || 50;
        }
        
        this.id = opts.markerId?opts.markerId:Math.random()*10;
    }
    
    Marker.prototype.getId = function(){
    	return this.id;
    }
    
    Marker.prototype.minSize = function(){
    	this.size = 0;
    }
 
    Marker.prototype.draw = function (context) {
        context.save();
        context.beginPath();
        switch (this.type) {
            case 'circle':
                this._drawCircle(context);
                break;
            case 'ellipse':
                this._drawEllipse(context);
                break;
            default:
                break;
        }
        context.closePath();
        context.restore();
 
        this.size += this.speed;
        if (this.size > this.max) {
            this.size = 0;
        }
    };
 
    Marker.prototype._drawCircle = function (context) {
        var pixel = this.pixel || map.lngLatToContainer(this.lonlat);//map.lngLatToContainer
        if(pixel){
        	context.strokeStyle = this.color;
            context.arc(pixel.x, pixel.y, this.size, 0, Math.PI * 2);
            context.stroke();
        }
    };
 
    Marker.prototype._drawEllipse = function (context) {
        var pixel = this.pixel || map.getPixelFromCoordinate(this.location);
        var x = pixel[0],
            y = pixel[1],
            w = this.size,
            h = this.size / 2,
            kappa = 0.5522848,
 
            // control point offset horizontal
            ox = w / 2 * kappa,
 
            // control point offset vertical
            oy = h / 2 * kappa,
 
            // x-start
            xs = x - w / 2,
 
            // y-start
            ys = y - h / 2,
 
            // x-end
            xe = x + w / 2,
 
            // y-end
            ye = y + h / 2;
 
        context.strokeStyle = this.color;
        context.moveTo(xs, y);
        context.bezierCurveTo(xs, y - oy, x - ox, ys, x, ys);
        context.bezierCurveTo(x + ox, ys, xe, y - oy, xe, y);
        context.bezierCurveTo(xe, y + oy, x + ox, ye, x, ye);
        context.bezierCurveTo(x - ox, ye, xs, y + oy, xs, y);
        context.stroke();
    };
 
    function FlashMarker(map, dataSet){	
    	var animationLayer = null,animationFlag = true,
    	width = map.getSize().width,height = map.getSize().height,markers = [];
	    for (var i = 0; i < dataSet.length; i++) {
	        markers.push(new Marker(dataSet[i]));
	    }
	    
    	//图标告警
    	var aniMarker = function(){        	    
		    this.init();
	    }
	    //添加图标告警
	    aniMarker.prototype.addMarkerToMap = function(dataSetItem,circleType){
	    	markers.push(new Marker(dataSetItem,circleType));
	    	this.markers = markers;
	    }
	    //移除图标告警
	    aniMarker.prototype.removeMarkerById = function(id){
	    	for(var i=0;i<markers.length;i++){
	    		var marker = markers[i];
	    		if(id == marker.getId()){
	    			markers.splice(i,1);
	    		}
	    	}
	    	this.markers = markers;
	    }
	    //上层canvas渲染，动画效果
	    aniMarker.prototype.render = function(){
	    	 var animationCtx = animationLayer.canvas.getContext('2d');
	         if (!animationCtx) {
	             return;
	         }	
		     if (!animationFlag) {
		         animationCtx.clearRect(0, 0, width, height);
		         return;
		     }
	         animationCtx.fillStyle = 'rgba(0,0,0,.95)';
	         var prev = animationCtx.globalCompositeOperation;
	         animationCtx.globalCompositeOperation = 'destination-in';
	         animationCtx.fillRect(0, 0, width, height);
	         animationCtx.globalCompositeOperation = prev;
		
	         for (var i = 0; i < markers.length; i++) {
	             var marker = markers[i];
	             marker.draw(animationCtx);
	         }
	    }
	    //初始化
	    aniMarker.prototype.init = function() {
	    	var render = this.render;
	    	
	    	animationLayer = new CanvasLayer({
	            map: map,
	            update: render
	        });
	
	        (function drawFrame() {
	            requestAnimationFrame(drawFrame);
	            render();
	        })();
	    };
	
	    return new aniMarker()
    }
    return FlashMarker;
})));