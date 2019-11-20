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
<script type="text/javascript" src="https://webapi.amap.com/maps?v=1.4.10&key=b2d0df047c4228dc9243e6fda961aeb0&plugin=AMap.Autocomplete,AMap.PlaceSearch,AMap.DistrictSearch"></script><!-- 二维地图 -->
<link href="${pageContext.request.contextPath}/css/gis/amap.css" rel="stylesheet" />
<style type="text/css">
	.ol-attribution{
	    display:none;
	}
	.ol-zoom{
		display:none;
	}
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
</style>
</head>
<body>
<div id="map" style="width:100%;height:100%;" style="overflow-y:hidden">
</div>
<div id="myPageTop" style="right:0px !important">
    <table><tr><td><label>输入地点关键字：</label></td></tr><tr><td><input id="tipinput" style="border: 1px solid #666;height:20px;"/></td></tr></table>
</div>
<div id="coordinatesInfo" style="position:absolute;right:0px;bottom:0px;z-index:101;">经度：,纬度：</div>
<script type="text/javascript">
var map;
var initZoom = 16;					//默认的放缩级别
var defaultCenter = [121.04142889380456,29.11627471446991];
var posCenter;		//中心点的坐标
var nowCoordinates = undefined;		//
var posMarker;			//保存定位点

$(function(){
	initParam();
	initMap();
	initParentButton();
})

//初始化中间点和范围
function initParam(){
	var lonlatStr = "${requestScope.coords}";
	if(/^\[\d+(\.\d+)?\,\d+(\.\d+)?\]$/.test(lonlatStr)){		//验证经纬度字符串
		posCenter = eval("("+ lonlatStr +")");
	}	
}

//初始化二维地图
function initMap(){
	//地图加载
    map = new AMap.Map("map", {
    	center: posCenter ? posCenter : defaultCenter,
    	zoom:initZoom,
        mapStyle: 'amap://styles/e669bfcd88d5760c202fa10ef1f07346', //设置地图的显示样式e669bfcd88d5760c202fa10ef1f07346
        resizeEnable: true
    });
	
    var autoOptions = {
        input: "tipinput",
        datatype:"poi"		//只搜地址和POI点
    };
    var auto = new AMap.Autocomplete(autoOptions);

    var placeSearch = new AMap.PlaceSearch({        //地址查询
        map: map,
        children:0,
        type:"地名地址信息"
    });  //构造地点查询类

    var district = new AMap.DistrictSearch({        //行政区划查询
        extensions: 'all',
    })

    AMap.event.addListener(auto, "select", select);//注册监听，当选中某条记录时会触发

    function select(e) {
        placeSearch.setCity(e.poi.adcode);
        let zoom;
        switch(e.poi.typecode){
            case "190104":  //市
            case "190105":  //县
                zoom = 14;
                break;
            case "190106":  //镇
                zoom = 16;
                break;
            default:
                zoom = 17;
        }
        let lonlat = e.poi.location;
        district.search(e.poi.adcode, function(status, result) {      //e.poi.name  市 县、区的边界
            if(lonlat){
                map.setZoomAndCenter(zoom,new AMap.LngLat(lonlat.lng,lonlat.lat));
            }else{
                var items = result.districtList[0].districtList;
                if(items.length>0){
                    var points = [];
                    for(var i=0;i<items.length;i++){
                        var point = items[i].center;
                        points.push(new AMap.LngLat(point.lng,point.lat));
                    }
                    var bounds = (new AMap.Polyline({path:points})).getBounds();
                    map.setBounds(bounds);
                }
            }
        });
    }
	
	if(posCenter){
		addPosMarker(posCenter);	
		showCoordinates({lng:posCenter[0],lat:posCenter[1]});
	}
	
	map.on('click',function(e){
		if(!posMarker){
			addPosMarker(e.lnglat);
		}
		else{
			posMarker.setPosition(e.lnglat);
		}
		showCoordinates(e.lnglat);
	})
}

//新增可以拖动的定位点
function addPosMarker(lnglat){
	posMarker = new AMap.Marker({
		position: lnglat,
		icon: basePath+'/images/gis/customer.png',
		offset: new AMap.Pixel(-17, -17),	//默认(-10,-34)
		draggable: true,
	    cursor: 'move',
    });
	posMarker.on('dragging',function(evt){
		showCoordinates(evt.lnglat);
	})
    map.add(posMarker);
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