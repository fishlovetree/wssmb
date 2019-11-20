<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<jsp:include page="../Header.jsp"/>
<script>
	var basePath = '${pageContext.request.contextPath}';
</script>
<script type="text/javascript" src="https://webapi.amap.com/maps?v=1.4.10&key=b2d0df047c4228dc9243e6fda961aeb0&plugin=AMap.Autocomplete,AMap.PlaceSearch"></script><!-- 二维地图 -->
<link href="${pageContext.request.contextPath}/css/gis/amap.css" rel="stylesheet" />
<style type="text/css">
	.ol-attribution{
	    display:none;
	}
	.ol-zoom{
		display:none;
	}
	#extentInfo{
	    background-color: rgba(200,200,200,0.7);
	    padding: 2px 3px;
	    border: 1px solid #aaa;
	    height:16px;
	    white-space:nowrap;
	    overflow:hidden;
	    word-wrap: inherit;
	    position: absolute;
	    right: 0px;
	    bottom: 0px;
	    z-index: 101;
	}
</style>
</head>
<body>
<div id="map" style="width:100%;height:100%;" style="overflow-y:hidden">
</div>
<div id="extentInfo" style="position:absolute;right:0px;bottom:0px;z-index:101;">范围:</div>
<script type="text/javascript">
var map;
var initZoom = 14;					//默认的放缩级别
var initCenter = [121.04142889380456,29.11627471446991];	//默认的中间点
var nowExtent = undefined;

$(function(){
	initMap();
	initParentButton();
})

function initParentButton(){
	$('#getExtentButton', parent.document).click(function(){
		if(nowExtent && nowExtent instanceof Array && nowExtent.length ==4){
			if(parent != null){
				parent.getExtent(nowExtent);
			}
		}
	});
}

function initMap(){
	var mapOpt = {
        mapStyle: 'amap://styles/e669bfcd88d5760c202fa10ef1f07346', //设置地图的显示样式
        resizeEnable: true		//设置可调整大小
    }
	
	var certainCenter = false;
	var fartExtentStr = "${requestScope.extent}";
	if(/^\[\d+(\.\d+)?\,\d+(\.\d+)?\,\d+(\.\d+)?\,\d+(\.\d+)?\]$/.test(fartExtentStr)){
		var extentArray = eval("("+ fartExtentStr +")");
        nowExtent = [extentArray[0].toFixed(6),extentArray[1].toFixed(6),
                     		extentArray[2].toFixed(6),extentArray[3].toFixed(6)];
    	$("#extentInfo").html("范围:["+nowExtent[0]+","+nowExtent[1]+","+nowExtent[2]+","+nowExtent[3]+"]");
	}else{
		certainCenter = true;
		mapOpt.center = initCenter;
		mapOpt.zoom = initZoom;	
	}
	
	map = new AMap.Map("map", mapOpt);

	if(!certainCenter){
		var wsPos = new AMap.LngLat(nowExtent[0], nowExtent[1]);
		var nePos = new AMap.LngLat(nowExtent[2], nowExtent[3]);
		map.setBounds(new AMap.Bounds(wsPos,nePos));
	}
    
	map.on("moveend",function(e){
		var bounds = map.getBounds();
		nowExtent = [bounds.getSouthWest().getLng().toFixed(6),bounds.getSouthWest().getLat().toFixed(6),
	             		bounds.getNorthEast().getLng().toFixed(6),bounds.getNorthEast().getLat().toFixed(6)];
    	$("#extentInfo").html("范围:["+nowExtent[0]+","+nowExtent[1]+","+nowExtent[2]+","+nowExtent[3]+"]");
	})
	
	
}
//初始化二维地图
/*function initMap(){ 
	var projection = ol.proj.get("EPSG:3857");
  	var resolutions = [];
  	for(var i=0; i<19; i++){
    	resolutions[i] = Math.pow(2, 18-i);
  	}
  	var tilegrid  = new ol.tilegrid.TileGrid({
    	origin: [0,0],
    	resolutions: resolutions
  	});

  	var baidu_source = new ol.source.TileImage({
    	projection: projection,
    	tileGrid: tilegrid,
    	tileUrlFunction: function(tileCoord, pixelRatio, proj){
      		if(!tileCoord){
        		return "";
      		}
      		var z = tileCoord[0];
     	 	var x = tileCoord[1];
      		var y = tileCoord[2];
          	if(x<0){
            	x = "M"+(-x);
          	}
          	if(y<0){
            	y = "M"+(-y);
          	}
          	return "http://api0.map.bdimg.com/customimage/tile?&x="+x+"&y="+y+"&z="+z+"&udt=20180628&scale=1&ak=E4805d16520de693a3fe707cdc962045&customid=midnight";
    	}
  	});

  	var baidulayer = new ol.layer.Tile({
    	source:baidu_source
  	});

    map = new ol.Map({
        target: 'map',
        layers: [baidulayer],
        view: new ol.View({
            projection: projection,
            center:ol.proj.transform(initCenter,'EPSG:4326','EPSG:3857'),//initCenter,
            zoom:initZoom,
            resolutions:resolutions
        })
    });
    
    map.on('moveend',function(){
    	var extent = map.getView().calculateExtent(map.getSize());
    	nowExtent = ol.proj.transformExtent(extent,'EPSG:3857','EPSG:4326');
    	nowExtent[0] = nowExtent[0].toFixed(6);
    	nowExtent[1] = nowExtent[1].toFixed(6);
    	nowExtent[2] = nowExtent[2].toFixed(6);
    	nowExtent[3] = nowExtent[3].toFixed(6);
    	$("#extentInfo").html("范围:["+Number(nowExtent[0]).toFixed(6)+","+Number(nowExtent[1]).toFixed(6)+","+Number(nowExtent[2]).toFixed(6)+","+Number(nowExtent[3]).toFixed(6)+"]");
    })
    
    var extentStr = "${requestScope.extent}";
	if(extentStr != ""){
		var extent = eval("("+ extentStr +")");
		if(!(extent instanceof Array) && extent.length == 4){
			map.getView().fit(extent);
	    	nowExtent = ol.proj.transformExtent(extent,'EPSG:3857','EPSG:4326');
	    	nowExtent[0] = nowExtent[0].toFixed(6);
	    	nowExtent[1] = nowExtent[1].toFixed(6);
	    	nowExtent[2] = nowExtent[2].toFixed(6);
	    	nowExtent[3] = nowExtent[3].toFixed(6);
	    	$("#extentInfo").html("范围:["+Number(nowExtent[0]).toFixed(6)+","+Number(nowExtent[1]).toFixed(6)+","+Number(nowExtent[2]).toFixed(6)+","+Number(nowExtent[3]).toFixed(6)+"]");
		}
	}
}*/
</script>
</body>
</html>