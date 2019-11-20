var scene,camera,renderer,light;      //场景、相机、渲染、光源
var renderAnimation;				//保存渲染动画，用于停止
var container;				//三维容器
var controls;
var overlay,popTitle,popContent,popPosition=[];	//弹出框相关

//整体初始化
function init3D(domId){
	initContainer(domId);
	initScene();
    initCamera();
    initLight();
    initRender();
    initControls();
    initPopup();	//初始化弹出框
}

//初始化三维容器
function initContainer(domId){
	if(domId){
		container = document.getElementById(domId);
	}else{
		container = document.body;
	}
}

//初始化场景
function initScene(){
    scene = new THREE.Scene();
    scene.background = new THREE.Color( 0x212d39 );		//背景颜色
    //scene.fog = new THREE.Fog( 0x72645b);//雾效果 	颜色、最短距离、最长距离
}

//初始化相机
function initCamera(){
	var aspect = container.clientWidth/container.clientHeight;	//纵横比
    camera = new THREE.PerspectiveCamera( 40, aspect, 1, 1000);//第一个参数为渲染角度，人眼一般设置为40-50
}

//初始化光照
function initLight() {
    var ambientLight = new THREE.AmbientLight( 0xffffff, 0.5 );		//环境光
    scene.add( ambientLight );
    
    var directionalLight = new THREE.DirectionalLight( 0xffffff, 0.4 );		//直射光 模拟日光  l
    directionalLight.position.set( 1, 1, 0 ).normalize();
    scene.add( directionalLight );
    
    var directionalLight2 = new THREE.DirectionalLight( 0xffffff, 0.4 );		//直射光 模拟日光
    directionalLight2.position.set( 0, -1, -1 ).normalize();
    scene.add( directionalLight2 );
}

//初始化渲染
function initRender(){
    renderer = new THREE.WebGLRenderer({antialias: true});
    renderer.setSize( container.clientWidth, container.clientHeight );
    container.appendChild( renderer.domElement );
    renderer.setClearColor(0xFFFFFF, 1.0);
}

//初始化用户交互
function initControls(){
	controls = new THREE.OrbitControls( camera,renderer.domElement );//用户交互 翻转
    controls.zoomSpeed = 3;
    controls.maxPolarAngle = Math.PI/2;	//设置相机的角度范围 最大45度 Math.PI/4
    controls.minPolarAngle = 0;//设置相机的角度范围
    controls.minDistance = 5;         //相机距离目标点的最近距离
    controls.maxDistance = 200;         //相机距离目标点的最远距离
    controls.enableRotate = true;
    controls.mouseButtons = {
		ORBIT: THREE.MOUSE.RIGHT,
		ZOOM: THREE.MOUSE.MIDDLE,
		PAN:THREE.MOUSE.LEFT
	},
    controls.addEventListener('change',function(){			//用户交互改变事件
    	updatePopPosition();		//更新弹出框的位置
    	updateRightMenu();			//更新右键框位置
    });
}

//更新交互控制
function updateControls() {
    controls.update();
}

//初始化弹出框
function initPopup(){
	overlay = $("#popup");
	popTitle = $("#popup-title");
	popContent = $("#popup-content");
	
	$("#popup-closer").click(function(){
		hideDeviceInfo();
    })
    if(overlay[0]){
    	overlay[0].addEventListener("contextmenu",function(event){
    		event.preventDefault();					//禁止弹出框上 默认的右键事件
    	});
    }
}

//右键菜单	已废弃不用
function initRightMenu(){
	rightMenu = $("#contextmenu_container");
	if(rightMenu[0]){
		rightMenu[0].addEventListener("contextmenu",function(event){
			event.preventDefault();
		});
	}
}

 //刷新三维渲染
 function refreshThreeWindow(){
	 var HEIGHT = container.clientHeight;		// 更新渲染器的高度和宽度以及相机的纵横比
	 var WIDTH = container.clientWidth;
	 camera.aspect = WIDTH / HEIGHT;
	 camera.updateProjectionMatrix();
	 renderer.setSize( WIDTH, HEIGHT );
 }

 /*
  * 创建设备弹出框标注
  *	@param {Array || undefined} options.position 三维坐标中的位置比如[0,0,0]
  *	@param {DOM || undefined} options.target 放置dom的位置
  *	@param {string || undefined} options.etype 设备类型
  *	@param {string || undefined} options.text 标注名称
  * */
 var ws3doverlay = function(options){
	var position = options.position ? options.position : [0,0,0];
	this.screenPosition = threeToScreenPos(position,camera);
	this.target_ = options.target ? options.target : document.body;
	this.equipmentType_ = options.etype ? options.etype : "";
	var text = options.text ? options.text:"";
			
	this.div_ = document.createElement("div");
	this.div_.innerHTML = "<span class=\"devicelabel\">"+text+"</span>";
	this.div_.className = "labeltip";
	this.target_.appendChild(this.div_);
	
	this.width = this.div_.offsetWidth;	//offsetWidth offsetHeight
	this.height = this.div_.offsetHeight;	//offsetWidth offsetHeight
	this.div_.style.top = this.screenPosition.y - 2*this.height - 10 + "px";
	this.div_.style.left = this.screenPosition.x - this.width/2 + "px";		
	this.position_ = position;
}

//获取弹出框标注的三维世界坐标
ws3doverlay.prototype.getThreePosition = function(){
	return new THREE.Vector3(this.position_.x,this.position_.y,this.position_.z);
} 

//更新弹出框位置
ws3doverlay.prototype.updatePosition = function(){
	var position = this.position_ ? this.position_ : {x:0,y:0};
	
	this.screenPosition = threeToScreenPos(position,camera);
	
	this.div_.style.top = this.screenPosition.y - 2*this.height - 10 + "px";
	this.div_.style.left = this.screenPosition.x - this.width/2 + "px";
}

//显示
ws3doverlay.prototype.show = function(){
	this.div_.style.display = "block";
}

//获取可见性
ws3doverlay.prototype.getVisible = function(){
	var visible = true;
	if(this.div_.style.display == "none"){
		visible = false;
	}
	return visible;
}

//获取标注的设备类型，用于实时监控过滤
ws3doverlay.prototype.getEType = function(){			
	return this.equipmentType_;
}

//隐藏
ws3doverlay.prototype.hide = function(){
	this.div_.style.display = "none";
}

//获取屏幕位置坐标
ws3doverlay.prototype.getScreenPosition = function(){
	return {
		x : this.screenPosition.x,
		y : this.screenPosition.y - 2*this.height - 10
	}
}

//获取弹出坐标的尺寸，为了进行相交判断
ws3doverlay.prototype.getSize = function(){			//获取尺寸
	return{
		width:this.width,
		height:this.height
	}
}

//清除弹出标注
ws3doverlay.prototype.clear = function(){
	var div = this.div_ ? this.div_ : null;
	this.target_.removeChild(div);
}


/*
 * 创建设备状态,在模拟演练中用到
  *	@param {Array || undefined} options.position 三维坐标中的位置比如[0,0,0]
  *	@param {DOM || undefined} options.target 放置dom的位置
  *	@param {string || undefined} options.buildingid 建筑id
  *	@param {string || undefined} options.name 名称
  *	@param {string || undefined} options.text 状态内容
  * */
var ws3dstatus = function(options){
	var position = options.position ? options.position : [0,0,0];
	var screenPosition = threeToScreenPos(position,camera);
	this.target_ = options.target ? options.target : document.body
	this.buildingid_ = options.buildingid ? options.buildingid : undefined;
	this.name_ = options.name ? options.name : undefined;
	var text = options.text ? options.text:"";
			
	this.div_ = document.createElement("div");
	this.div_.innerHTML = "<span class=\"devicelabel\">"+text+"</span>";
	this.div_.className = "statustip";
	this.target_.appendChild(this.div_);
	
	var offsetHeight = this.div_.offsetHeight;	//offsetWidth offsetHeight
	this.div_.style.top = screenPosition.y - 25 + "px";
	this.div_.style.left = screenPosition.x + 14 + "px";		
	this.position_ = position;
}

//更新设备状态的位置
ws3dstatus.prototype.updatePosition = function(){
	this.show();
	
	var position = this.position_ ? this.position_ : {x:0,y:0};
	
	var screenPosition = threeToScreenPos(position,camera);
	
	var offsetHeight = this.div_.offsetHeight;	//offsetWidth offsetHeight
	this.div_.style.top = screenPosition.y - 25 + "px";
	this.div_.style.left = screenPosition.x + 14 + "px";
}

//隐藏
ws3dstatus.prototype.hide = function(){
	this.div_.style.display = "none";
}

//显示
ws3dstatus.prototype.show = function(){
	this.div_.style.display = "block";
}

//获取楼层id
ws3dstatus.prototype.getbuildingid = function(){
	return this.buildingid_;
}

//获取名称
ws3dstatus.prototype.getName = function(){
	return this.name_;
}

//清除
ws3dstatus.prototype.clear = function(){
	var div = this.div_ ? this.div_ : null;
	this.target_.removeChild(div);
}
