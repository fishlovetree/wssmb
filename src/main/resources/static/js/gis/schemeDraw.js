var drawMark = false;			//开始绘制的标记
var drawType;					//绘制类型 "polygon":绘制面   "polyline":绘制线
var drawingPoint;				//basePath + '/images/gis/dragIcon.png'
var wsTooltip;					//绘制过程中的提示框
var nowGraphic;					//当前绘制的图形
var graphicPath = [];			//保存当前绘制图形的坐标

var delBtn;							//保存删除按钮实例

var drawTypeConst = {		//绘制样式的常量
	COMBAT : "combatarea",		//作战区域
	DANGER : "dangerarea"		//隐患区域
}

var areaTYPE = {			//区域类型常量
	COMBAT:"combatArea",	//作战区域
	DANGER:"dangerArea"		//隐患区域
}

var startMsg = "点击开始绘制!";
var continueMsg = "点击继续绘制!";
var startAndEndMsg = "点击继续绘制，双击结束绘制!";
var combatCoverMsg = "绘制新的作战区域将会覆盖原有的作战区域，继续吗？";
var dangerCoverMsg = "绘制新的隐患区域将会覆盖原有的作战区域，继续吗？";

var combat_m = 0xff0000;			//红色
var combat_m_s = 0xff00ff;			//粉红色
var combat_border_m = 0x839848;			
var combat_border_m_s = 0x8398ff;
var danger_m = 0xEE7600;			//红色
var danger_m_s = 0xEE4000;			//粉红色
var danger_border_m = 0x00d824;			
var danger_border_m_s = 0x00d8ff;

var MATERIAL = {};					//区域样式
MATERIAL.combat = new THREE.MeshBasicMaterial({color:combat_m,transparent:true,opacity:0.4});		//作战区域样式
MATERIAL.combat_s = new THREE.MeshBasicMaterial({color:combat_m_s,transparent:true,opacity:0.4});
MATERIAL.combat_border = new THREE.LineBasicMaterial({color:combat_border_m});
MATERIAL.combat_border_s = new THREE.LineBasicMaterial({color:combat_border_m_s});

MATERIAL.danger = new THREE.MeshBasicMaterial({color:danger_m,transparent:true,opacity:0.4});		//隐患区域样式
MATERIAL.danger_s = new THREE.MeshBasicMaterial({color:danger_m_s,transparent:true,opacity:0.4});
MATERIAL.danger_border = new THREE.LineBasicMaterial({color:danger_border_m});
MATERIAL.danger_border_s = new THREE.LineBasicMaterial({color:danger_border_m_s});

var lineMATERIAL = {};					//将线、面和箭头样式存入缓存
lineMATERIAL.line = new THREE.LineBasicMaterial({color:0x5b87c1});
lineMATERIAL.line_focus = new THREE.LineBasicMaterial({color:0x19fd18});
lineMATERIAL.rescueline = new THREE.LineBasicMaterial({color:0xEE7600});
lineMATERIAL.rescueline_focus = new THREE.LineBasicMaterial({color:0xEE4000});

//绘制提示框初始化
function schemeDrawInit(){
	tooltip = new createTooltip(container);
}

var combatAreaGroup;				//保存所有的作战区域
var dangerAreaGroup;				//保存隐患区域
var pathPointGroup;					//保存所有的节点
var staffRoutesGroup;				//保存所有的撤退路线
var fireManRoutesGroup;				//保存所有的救援路线

//初始化作战区域和隐患区域组
function schemeGroupsInit(){
	combatAreaGroup = new THREE.Object3D();			//作战区域组
	scene.add(combatAreaGroup);
	
	dangerAreaGroup = new THREE.Object3D();				//隐患区域组
	scene.add(dangerAreaGroup);
	
	pathPointGroup = new THREE.Object3D();					//所有的路径点集合
    scene.add(pathPointGroup);
    
    staffRoutesGroup = new THREE.Object3D();				//撤退路线
	scene.add(staffRoutesGroup);
    
	fireManRoutesGroup = new THREE.Object3D();				//消防员救援路线
	scene.add(fireManRoutesGroup);  
}

/*
 * 	开始绘制作战区域或隐患区域
 * 	@param {String} type 绘制类型     "combatArea"作战区域	"dangerArea" 隐患区域
 */
function startDraw(type){		
	var group,coverMsg;
	if(type == areaTYPE.COMBAT){		//判断绘制类型
		group = combatAreaGroup;
		coverMsg = combatCoverMsg;
	}else{
		group = dangerAreaGroup;
		coverMsg = dangerCoverMsg;
	}
	var areas = group.children;
	if(areas.length != 0){
		if(confirm(coverMsg)){		//确认区域覆盖
			var area = areas[0];
			group.remove(area);		//删除原有的区域
			stopDraw();			//先停止
			drawType = type;
			drawMark = true;	//设置绘制类型和标记
		}
	}else{
		stopDraw();
		drawType = type;
		drawMark = true;		//设置绘制类型和标记
	}		
	if(delBtn){			//存在选中区域和按钮
		delBtn.clear();
		delBtn = undefined;
	}
}

//停止绘制,并清除正在绘制的内容
function stopDraw(){
	drawMark = false;
	drawType = undefined;

	graphicPath = [];		//清空坐标
	tooltip.setVisible(false);		//隐藏绘制提示框
	
	if(drawingPoint && drawingPoint.object){		//跟随鼠标移动的点
		scene.remove(drawingPoint.object);		//移除
		drawingPoint = undefined;
	}
	
	if(nowGraphic){			//当前正在绘制
		var areaType = nowGraphic.areatype,selectDev = false;	//是否需要框选设备
		if(areaType == areaTYPE.COMBAT){
			group = combatAreaGroup;
		}else{
			group = dangerAreaGroup;
			selectDev = true;
		}
		if(!nowGraphic.getDrawingStatus()){				//没有绘制完成
			group.remove(nowGraphic.getPolygon());		//移除
		}else{
			if(selectDev){		//绘制完成，隐患区域需要根据区域选择设备
				var positions = nowGraphic.shapePositons,points = [];
				if(positions){
					for(var i=0;i<positions.length;i++){
						var position = positions[i];
						points.push([position.x,position.z]);
					}
				}
				polygonSelect(points);			//根据多边形选择设备
			}
		}
		nowGraphic = undefined;			//初始化
	}
	
	$("#areaBtn a").removeClass("selected");
	$("#dangerBtn a").removeClass("selected");		//移除选中样式
	
	if(delBtn){		//取消 删除按钮
		delBtn.clear();
		delBtn = undefined;
	}
}

//更新图形删除按钮的位置
function updateDelBtn(){
	if(delBtn){
		delBtn.update();		//更新删除按钮的位置
	}
}

/*
 * 	根据建筑id显示图形，图形包括作战区域、隐患区域、道路节点、逃生路线和救援路线
 * 	@param {String} id 建筑id 
 */
function showGraphicByBuildingId(id){
	if(!id) return;
	if(!combatAreaGroup || !dangerAreaGroup) return;
	//根据建筑id显示作战区域
	for(var i=0;i<combatAreaGroup.children.length;i++){
		var type = areaTYPE.COMBAT;
		if(combatAreaGroup.children[i].name != id){
			combatAreaGroup.children[i].visible = false;
		}else{
			combatAreaGroup.children[i].visible = true;
		}
	}
	//根据建筑id显示隐患区域
	for(var i=0;i<dangerAreaGroup.children.length;i++){
		var type = areaTYPE.DANGER;
		if(dangerAreaGroup.children[i].name != id){
			dangerAreaGroup.children[i].visible = false;
		}else{
			dangerAreaGroup.children[i].visible = true;
		}
	}
	
	//根据建筑id显示道路节点
	if(pathPointGroup){
		if(id != pathPointGroup.name){
			pathPointGroup.visible = false;
		}else{
			pathPointGroup.visible = true;
		}
	}
	
	//根据建筑id显示逃生路线
	for(var i=0;i<staffRoutesGroup.children.length;i++){
		var staffRoutes = staffRoutesGroup.children[i];
		if(id != staffRoutes.buildingid){
			staffRoutes.visible = false;
		}else{
			staffRoutes.visible = true;
		}
	}
	
	//根据建筑id显示救援路线
	for(var i=0;i<fireManRoutesGroup.children.length;i++){
		var fireManRoutes = fireManRoutesGroup.children[i];
		if(id != fireManRoutes.buildingid){
			fireManRoutes.visible = false;
		}else{
			fireManRoutes.visible = true;
		}
	}
}

/*
 *	移除一个区域图形 
 * 	@param {areaPolygon} areaObject 区域面的实例
 */
function removeGraphic(areaObject){
	var area = areaObject.getPolygon();
	var type = areaObject.areatype;
	if(type == areaTYPE.COMBAT){
		combatAreaGroup.remove(area);
	}else{
		dangerAreaGroup.remove(area);
	}
	if(delBtn){
		delBtn.clear();
		delBtn = undefined;
	}
}

/*
 *	获取鼠标和线面的相交物体 
 * 	@param {Array} position 屏幕坐标[x,y]
 * 	@param {[THREE.Group]}	group数组
 * 	@return {Object} intersects 相交的object
 */
function getGroupIntersects(position,groupArray){
	var vector = new THREE.Vector3();//三维坐标对象
    vector.set(
            ( position[0] / container.clientWidth ) * 2 - 1,
            - ( position[1] / container.clientHeight ) * 2 + 1,
            0.5 );
    vector.unproject( camera );
    var raycaster = new THREE.Raycaster(camera.position, vector.sub(camera.position).normalize());
    var intersects = raycaster.intersectObjects(groupArray,true);
    return intersects;
}

//拾取人员位置或者经纬度
function startPick(type){
	if(drawMark) drawMark = false;
	if(pickMark){
		stopPick();
	}
	pickMark = true;
	pickType = type;
}

//停止拾取
function stopPick(){
	pickMark = false;
	pickType = undefined;	
	$("#staffBtn a").removeClass("selected");
	$("#firemanBtn a").removeClass("selected");
	if(nearestPoint){
		resetPointStatus(nearestPoint);		//清空节点状态
		nearestPoint = undefined;
	}
	if(editPoint){		//正在编辑
		var eidtType = editPoint.userData.editType;
		removeRoutesByType(eidtType);			//清除显示的线，只显示正在编辑的线
		$("#pointManNum").val("");		//节点人数
		$("#routesPopup").hide();		//隐藏路线框
		editPoint = undefined;			
	}
}

/*
 * 创建绘制div
 * @param {DOM} frameDiv 放置绘制div的容器
 */
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
    //根据屏幕坐标和内容，弹出绘制信息框
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

/*
 *	创建绘制点 
 * 	@param {Object} position 绘制点坐标 {x:x,y:y,z:z}
 */
function createDrawingPoint(position){
	var drawingPoint = function(position){
		var loader = new THREE.TextureLoader();
	    var texture = loader.load(basePath + '/images/gis/dragIcon.png', function () { }, undefined, function () { });
	    var spriteMaterial = new THREE.SpriteMaterial({ map: texture});
	    this.position = position;
	    this.object = new THREE.Sprite(spriteMaterial);
	    this.object.position.x = this.position.x;
	    this.object.position.y = this.position.y;
	    this.object.position.z = this.position.z;
	    this.object.scale.x = this.object.scale.y = (new THREE.Vector3()).subVectors( this.position, camera.position ).length() / 65;
	}

	drawingPoint.prototype.updatePosition = function(position){		//绘制的点跟随鼠标更新位置
		this.object.position.x = position.x;
	    this.object.position.y = position.y;
	    this.object.position.z = position.z;
	    this.object.scale.x = this.object.scale.y = (new THREE.Vector3()).subVectors( position, camera.position ).length() / 65;
	}
	return new drawingPoint(position);		//实例
}

/*
 *	创建区域多边形 
 *	options	{fillMaterial：填充样式,borderMaterial:边界样式,positions:坐标集合[[x,y,z],[x,y,z]...],buildingid：建筑id
 *	fillMaterial_s:选中后的填充样式,borderMaterial_s:选中后的边界样式,areatype:区域类型 作战区域or隐患区域}
 */
var areaPolygon = function(options){
	var area = function(options){
		var positions_ = options.positions ? options.positions : [];
		this.polygon = new THREE.Object3D();				//多边形组
		this.buildingid = options.buildingid ? options.buildingid : undefined;
		this.areatype = options.areatype ? options.areatype : undefined;		//区域类型
		this.drawFinish = false;			//默认未完成绘制
		this.fillMaterial = options.fillMaterial ? options.fillMaterial : new THREE.MeshBasicMaterial({color:0xff0000,transparent:true,opacity:0.4});
		this.borderMaterial = options.borderMaterial ? options.borderMaterial : new THREE.LineBasicMaterial({color:0x839848});
		this.fillMaterial_s = options.fillMaterial_s ? options.fillMaterial_s : new THREE.MeshBasicMaterial({color:0xff00ff,transparent:true,opacity:0.4});
		this.borderMaterial_s = options.borderMaterial_s ? options.borderMaterial_s : new THREE.LineBasicMaterial({color:0x8398ff});
		this.shapePositons = [];
		var data_ = [];
		for(var i=0;i<positions_.length;i++){
		    var position = positions_[i];
		    this.shapePositons.push(new THREE.Vector3(position[0],position[1],position[2]));
		    data_.push(position[2],position[0]);
	    }	
		var borderGeometry = new THREE.Geometry();
	    borderGeometry.vertices = this.shapePositons;
	    borderGeometry.vertices.push(this.shapePositons[0]);
	    
	    this.border = new THREE.Line(borderGeometry,this.borderMaterial,THREE.LineSegments);
	    this.border.computeLineDistances();  
		this.polygon.add(this.border);				//添加边界
		
		if(data_.length >= 3){
			var faces_ = [];
			var triangles_ = Earcut.triangulate(data_);
			if(triangles_ && triangles_.length != 0){
				for(var i=0;i<triangles_.length;i++){
					var length = triangles_.length;
					if(i%3==0 && i < length-2){
						faces_.push(new THREE.Face3(triangles_[i],triangles_[i+1],triangles_[i+2]));
					}
				}
			}else{
				faces_.push(new THREE.Face3(0,0,0));			//faces不能为空数组
			}
			var fillGeometry = new THREE.Geometry();
			fillGeometry.vertices = this.shapePositons;
			fillGeometry.faces = faces_;
			this.fill = new THREE.Mesh(fillGeometry,this.fillMaterial);
			this.polygon.add(this.fill);				//添加填充
		}
		
		this.polygon.name = this.buildingid;		//保存buildingId
		this.polygon.areatype = this.areatype;		//区域类型
	}

	//重新绘制区域多边形
	area.prototype.reshape = function(positions){
		var shapePositons = [],data_ = [];
		for(var i=0;i<positions.length;i++){
		    var position = positions[i];
		    shapePositons.push(new THREE.Vector3(position[0],position[1],position[2]));
		    data_.push(position[2],position[0]);
	    }
		this.shapePositons = shapePositons;		//保存多边形的所有顶点
		
		var borderGeometry = new THREE.Geometry();
		borderGeometry.vertices = this.shapePositons;
		borderGeometry.vertices.push(this.shapePositons[0]);
		this.border.geometry = borderGeometry;					//重绘线
		
		if(data_.length >= 3){
			var faces_ = [],triangles_ = Earcut.triangulate(data_);
			if(triangles_ && triangles_.length != 0){
				for(var i=0;i<triangles_.length;i++){
					var length = triangles_.length;
					if(i%3==0 && i < length-2){
						faces_.push(new THREE.Face3(triangles_[i],triangles_[i+1],triangles_[i+2]));
					}
				}
			}else{
				faces_.push(new THREE.Face3(0,0,0));				//faces不能为空数组
			}
			var fillGeometry = new THREE.Geometry();
			fillGeometry.vertices = this.shapePositons;
			fillGeometry.faces = faces_;			//多边形所有的三角面
			this.fill.geometry = fillGeometry;					//重绘面
		}
	}

	//获取多边形对象
	area.prototype.getPolygon = function(){
	    return this.polygon;
	}

	//获取多边形填充对象
	area.prototype.getFill = function(){
	    return this.fill;
	}
	
	//获取多边形填充对象
	area.prototype.getBorder = function(){
	    return this.border;
	}

	//获取区域所在的建筑
	area.prototype.getBuildingId = function(){
	    return this.buildingid;
	}

	//完成绘制，更改标记
	area.prototype.finishDraw = function(){
		this.drawFinish = true;
	}

	//获取绘制标记
	area.prototype.getDrawingStatus = function(){
		return this.drawFinish;
	}

	//选中区域
	area.prototype.selected = function(){
		this.fill.material = this.fillMaterial_s;
		this.border.material = this.borderMaterial_s;
	}

	//取消选中
	area.prototype.unSelected = function(){
		this.fill.material = this.fillMaterial;
		this.border.material = this.borderMaterial;
		selectedArea = undefined;			//取消选中
	}

	//设置可见
	area.prototype.setVisible = function(show){
		if(show){
			this.polygon.visible = true;
		}else{
			this.polygon.visible = false;
		}
	}

	//删除这个区域
	area.prototype.clear = function(){
		scene.remove(this.polygon);
	}

	//添加删除按钮
	area.prototype.addDelBtn = function(){
		
	}

	//移除删除按钮
	area.prototype.removeDelBtn = function(){
		
	}

	//根据区域获取这个object
	area.prototype.getObjectByArea = function(){
		
	}
	
	return new area(options);
}

/*
 *	创建删除按钮
 *	options	{areaObject：使用areaPolygon方法创建的对象}
 */
var wsDelBtn = function(options){
	var deleteBtn = function(options){
		if(!options.areaObject) return;
		var areaObject = options.areaObject;
		this.graphic = areaObject.getPolygon();
		this.element = document.getElementById("closePoint");
		this.position = this.graphic.children[0].geometry.vertices[0];
		this.positionArray = [this.position.x,this.position.y,this.position.z];
		var screenPosition = threeToScreenPos(this.positionArray,camera);
		var testY = (screenPosition.y > 0) && (screenPosition.y < container.clientHeight);
		var testX = (screenPosition.x > 0) && (screenPosition.x < container.clientWidth);
		if(testX && testY){
			$(this.element).css("top",screenPosition.y-10+"px");
			$(this.element).css("left",screenPosition.x+10+"px");
			$(this.element).show();		//根据位置显示删除按钮
		}else{
			$(this.element).hide();
		}
		$(this.element).unbind();
		$("#closePoint").bind('click',function(){
			removeGraphic(areaObject);		//点击删除按钮，删除图形
		});	
	}

	deleteBtn.prototype.clear = function(){
		$(this.element).hide();
	}

	deleteBtn.prototype.getId = function(){
		return this.graphic.id;
	}

	deleteBtn.prototype.getGraphic = function(){
		return this.graphic;
	}

	deleteBtn.prototype.update = function(){
		var screenPosition = threeToScreenPos(this.positionArray,camera);
		var testY = (screenPosition.y > 0) && (screenPosition.y < container.clientHeight);
		var testX = (screenPosition.x > 0) && (screenPosition.x < container.clientWidth);
		if(testX && testY){
			$(this.element).css("top",screenPosition.y-10+"px");
			$(this.element).css("left",screenPosition.x+10+"px");
			$(this.element).show();
		}else{
			$(this.element).hide();
		}
	}
	
	return new deleteBtn(options);
}
