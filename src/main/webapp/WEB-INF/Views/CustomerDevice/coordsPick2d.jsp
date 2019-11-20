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
<title>拾取经纬度坐标</title>
<%@include file="../Header.jsp" %>
<script>
	var basePath = '${pageContext.request.contextPath}';
</script>
<script type="text/javascript" src="https://webapi.amap.com/maps?v=1.4.10&key=b2d0df047c4228dc9243e6fda961aeb0&plugin=AMap.Autocomplete,AMap.PlaceSearch,AMap.DistrictSearch"></script><!-- 二维地图 -->
<script src="//webapi.amap.com/ui/1.0/main.js?v=1.0.11"></script>
<link href="${pageContext.request.contextPath}/css/gis/amap.css" rel="stylesheet" />
<style type="text/css">
	#coordinatesInfo{
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
	.amap-sug-result {
	    right: 0 !important;
	    left: 400px !important;
	}
	#pickerBox {
        position: absolute;
        z-index: 9999;
        top: 20px;
        right: 30px;
        width: 300px;
    }
    
    #pickerInput {
        width: 200px;
        padding: 5px 5px;
    }
    
    #poiInfo {
        background: #fff;
    }
    
    .amap_lib_placeSearch .poibox.highlight {
        background-color: #CAE1FF;
    }
    
    .amap_lib_placeSearch .poi-more {
        display: none!important;
    }
</style>
</head>
<body>
<div id="map" style="width:100%;height:100%;" style="overflow-y:hidden">
</div>
<div id="pickerBox">
    <input id="pickerInput" placeholder="输入关键字选取地点" />
    <div id="poiInfo"></div>
</div>

<div id="coordinatesInfo" style="position:absolute;right:0px;bottom:0px;z-index:101;">经度：,纬度：</div>
<script type="text/javascript">
var map;
var defaultCenter = [121.04142889380456,29.11627471446991]; //默认中心点
var posCenter;		//中心点的坐标
var nowCoordinates = undefined;		//拾取的坐标
var posMarker;			//保存定位点

$(function(){
	initParam();
	initMap();
	initParentButton();
})

//初始化中间点
function initParam(){
	var lonlatStr = "${requestScope.coords}";
	if(/^\[\d+(\.\d+)?\,\d+(\.\d+)?\]$/.test(lonlatStr)){		//已拾取的坐标
		posCenter = eval("("+ lonlatStr +")");
	}	
	var regionCenterStr = "${requestScope.regionCenter}";
	if(!posCenter && /^\[\d+(\.\d+)?\,\d+(\.\d+)?\]$/.test(regionCenterStr)){		//区域中心点
		posCenter = eval("("+regionCenterStr+")")
	}
}

//初始化二维地图
function initMap(){
	//地图加载
    map = new AMap.Map("map", {
    	center: posCenter ? posCenter : defaultCenter,
    	zoom: 13,
        mapStyle: 'amap://styles/e669bfcd88d5760c202fa10ef1f07346', //设置地图的显示样式e669bfcd88d5760c202fa10ef1f07346
        resizeEnable: true
    });
	
    posMarker = new AMap.Marker({
    	icon: basePath+'/images/gis/customer.png',
		offset: new AMap.Pixel(-17, -17)	//默认(-10,-34)
    });
    
    if (posCenter){ //默认坐标
    	posMarker.setPosition(posCenter);
    	posMarker.setMap(map);
    	map.setCenter(posCenter);
    	showCoordinates({lng:posCenter[0],lat:posCenter[1]});
    }
	
    //搜索框
	AMapUI.loadUI(['misc/PoiPicker'], function(PoiPicker) {

        var poiPicker = new PoiPicker({
            input: 'pickerInput',
            city: '${requestScope.cityname}'
        });

        //初始化poiPicker
        poiPickerReady(poiPicker);
    });

    function poiPickerReady(poiPicker) {
        window.poiPicker = poiPicker;

        //选取了某个POI
        poiPicker.on('poiPicked', function(poiResult) {

        	var poi = poiResult.item;
        	posMarker.setPosition(poi.location);
        	posMarker.setMap(map);
        	map.setCenter(poi.location);
    		showCoordinates({lng:poi.location['lng'],lat:poi.location['lat']});
        });

        /*poiPicker.onCityReady(function() {
            poiPicker.suggest('美食');
        });*/
    }
	
    //点击事件
	map.on('click',function(e){
		posMarker.setPosition(e.lnglat);
		posMarker.setMap(map);
		showCoordinates(e.lnglat);
	})
}

//信息框显示经纬度的值
function showCoordinates(lnglat){
	var lngVal = lnglat.lng.toFixed(10),latVal = lnglat.lat.toFixed(10);
    $("#coordinatesInfo").html("经度:" + lngVal + "," + "纬度：" + latVal);
    nowCoordinates = [lngVal,latVal];
}

//调用父页面的方法，填充父页面的经纬度框
function initParentButton(){
	$('#getCoordsButton', parent.document).click(function(){
		if(nowCoordinates && nowCoordinates instanceof Array && nowCoordinates.length ==2){
			var lonlatArray = [nowCoordinates[0],nowCoordinates[1]];
			if(parent != null){
				parent.getCoords(lonlatArray);
			}
		}
	});
}
</script>
</body>
</html>