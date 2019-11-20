var renderer, scene, camera, labelRenderer;
var raycaster;
var mouse;
var controls;
var container;

function init() {
	container = document.getElementById("wsContainer");
    renderer = new THREE.WebGLRenderer({
        antialias: true
    });
    renderer.setClearColor(0xFFFFFF, 1.0);
    renderer.setSize(container.clientWidth, container.clientHeight);
    scene = new THREE.Scene();
    scene.background = new THREE.Color( 0x212d39 );
    camera = new THREE.PerspectiveCamera(45, container.clientWidth/container.clientHeight, 0.1, 1000);
    camera.lookAt(new THREE.Vector3(0, 0, 4));
    camera.position.set(0, 25, -5);
    // 光线的照射
    var ambiColor = "#f2f2f2";
    var spotLight = new THREE.SpotLight(ambiColor);
    spotLight.position.set( -100, 100, -100);
    scene.add(spotLight);
    var spotLight2 = new THREE.SpotLight(ambiColor);
    spotLight2.position.set( 100, 100, -50);
    scene.add(spotLight2);
    
    controls = new THREE.OrbitControls( camera,renderer.domElement );//用户交互 翻转
    controls.zoomSpeed = 3;
    controls.maxPolarAngle = Math.PI/2;	//设置相机的角度范围 最大45度 Math.PI/4
    controls.minPolarAngle = 0;//设置相机的角度范围
    controls.minDistance = 5;         //相机距离目标点的最近距离
    controls.maxDistance = 200;         //相机距离目标点的最远距离
    controls.enableRotate = true;

    raycaster = new THREE.Raycaster();
    mouse = new THREE.Vector2();
    container.appendChild(renderer.domElement);
    container.addEventListener('dblclick', onDocumentMouseDblClick, false);

    render();
}

/*
* 打开E锁
* @param lockMac 锁MAC地址
*/
function openElock(lockMac){
	var object = boxGroup.getObjectByName("elock");
	if (object && object.userData.mac == lockMac){
		for (var i = 0; i < object.children.length; i++){
	        var child = object.children[i];
	        if (child.userData.id == 'metalLine'){
	            child.position.y = 0.1;
	        }
	        if (child.userData.id == 'bottom'){
	        	child.position.x = -0.3;
	            //child.rotation.y = Math.PI/2;
	        }
	    }
	    setTimeout( function(){
	        new TWEEN.Tween(object.rotation).to({
	            z: Math.PI/4
	        }, 500).onComplete(function(){
	        }).start();
	        new TWEEN.Tween(object.position).to({
	            x: 0.5,
	            z: 1.2
	        }, 500).onComplete(function(){
	        }).start();
	        setTimeout( function(){
		        new TWEEN.Tween(object.rotation).to({
		            z: 0
		        }, 500).onComplete(function(){
		        }).start();
		        new TWEEN.Tween(object.position).to({
		            x: 0.65,
		            z: 0.4
		        }, 500).onComplete(function(){
		        }).start();
		    }, 1000);
	    }, 1000);
	}
}

/*
* 关闭E锁
* @param lockMac 锁MAC地址
*/
function closeElock(lockMac){
	var object = boxGroup.getObjectByName("elock");
	if (object && object.userData.mac == lockMac){
		for (var i = 0; i < object.children.length; i++){
            var child = object.children[i];
            if (child.userData.id == 'metalLine'){
                child.position.y = 0;
            }
            if (child.userData.id == 'bottom'){
            	child.position.x = 0;
            }
        }
	}
}

/*
* 打开表箱
* @param boxNumber 表箱编号
*/
function openDoor(boxNumber){
	if (box && box.boxNumber == boxNumber){
		var leftDoorObj = boxGroup.getObjectByName("leftdoor");
		var rightDoorObj = boxGroup.getObjectByName("rightdoor");
		leftDoorObj.userData.status = "close";
		rightDoorObj.userData.status = "close";
		controlDoor(leftDoorObj);
		controlDoor(rightDoorObj);
		var elockObj = boxGroup.getObjectByName("elock");
		elockObj.visible = false;
	}
}

/*
* 关闭表箱
* @param boxnumber 表箱编号
*/
function closeDoor(boxNumber){
	if (box && box.boxNumber == boxNumber){
		var leftDoorObj = boxGroup.getObjectByName("leftdoor");
		var rightDoorObj = boxGroup.getObjectByName("rightdoor");
		leftDoorObj.userData.status = "open";
		rightDoorObj.userData.status = "open";
		controlDoor(leftDoorObj);
		controlDoor(rightDoorObj);
		setTimeout(function(){
			var elockObj = boxGroup.getObjectByName("elock");
			elockObj.visible = true;
		}, 1000)
	}
}

/*
* 设置电表显示屏的数字
* @param meterAddr 表号
* @param value 数字
*/
function setMeterValue(meterAddr, val){
	var object = boxGroup.getObjectByName("meter" + meterAddr);
	if (object){
		for (var i = 0; i < object.children.length; i++){
	        var child = object.children[i];
	        if (child.userData.id == 'meterScreen'){
	            var materials = child.material;
	            // top纹理
	            materials[2] = new THREE.MeshBasicMaterial( { map: new THREE.CanvasTexture(getMeterTextCanvas(val)) } );
	        }
	    }
	}
}

/*
* 设置监测终端显示屏的内容
* @param terminalAddr 终端地址
* @param temperature 环境温度 
* @param pressure 大气压力
* @param humidness 空气温度
*/
function setTerminalValue(terminalAddr, temperature, pressure, humidness){
	var object = boxGroup.getObjectByName("terminal");
	if (object){
		for (var i = 0; i < object.children.length; i++){
	        var child = object.children[i];
	        if (child.userData.id == 'terminalScreen'){
	            var materials = child.material;
	            // top纹理
	            materials[2] = new THREE.MeshBasicMaterial( { map: new THREE.CanvasTexture(getTerminalTextCanvas(temperature, pressure, humidness)) } );
	        }
	    }
	}
}

/*
* 总开关拉合闸
* @param status on-合闸，off-拉闸
*/
function changeMainBreaker(status){
  var object = boxGroup.getObjectByName("mainbreaker");
  if (object){
  	for (var i = 0; i < object.children.length; i++){
          var child = object.children[i];
          if (child.userData.id == 'mainswitch'){
              object.userData.status = status == "off" ? "on" : "off";
              controlMainBreaker(child);
          }
      }
  }
}

/*
* 电表拉合闸
* @param meterAddr 表号
* @param status on-合闸，off-拉闸
*/
function changeMeterBreaker(meterAddr, status){
    var object = boxGroup.getObjectByName("meterbreaker" + meterAddr);
    if (object){
  	    for (var i = 0; i < object.children.length; i++){
            var child = object.children[i];
            if (child.userData.id == 'meterswitch'){
                controlBreaker(child, status == "off" ? "on" : "off");
            }
        }
  	    //添加文字标注
  	    var text = status == "off" ? "拉闸" : "合闸";
  	    box.addTextSprite(text, {
            fontsize: 20,
            borderColor: {r:255, g:0, b:0, a:0.4},
            backgroundColor: {r:255, g:255, b:255, a:0.9}
        } , [object.position.x - 2.1,object.position.y + 0.5,object.position.z - 0.3], "meterbreaker" + meterAddr + "Text");
  	    
  	    //8秒后消失
  	    setTimeout(function(){
  	    	var meterbreakerText = boxGroup.getObjectByName("meterbreaker" + meterAddr + "Text");
			if (meterbreakerText){
				boxGroup.remove(meterbreakerText);
			}
  	    }, 8000);
    }
}

/*
* 电表错位三维接口
*/
var meterAlarmArray = [];		// 电表错位的集合
var meterAlarmParam = 0;		// 参数，保证所有告警频率一致
//电表错位动画
function updateMeterAlarm(){
  if(!meterAlarmArray || meterAlarmArray.length == 0) return;
  meterAlarmParam ++;
  meterAlarmParam = meterAlarmParam%2;
  if(meterAlarmParam == 0){
      for(var i=0;i<meterAlarmArray.length;i++){
          var meterAddr = meterAlarmArray[i];
          changeMeterStyleByName(meterAddr, true);	// 正常样式
      }
  }else{
      for(var i=0;i<meterAlarmArray.length;i++){
          var meterAddr = meterAlarmArray[i];
          changeMeterStyleByName(meterAddr, false);	// 告警样式
      }
  }
}

function changeMeterStyleByName(meterAddr,isnormal){
  var color = 0xD8D0C8;
  if (isnormal){
      color = 0xD8D0C8;
  }
  else{
      color = 0xFF0000;
  }
  var material = new THREE.MeshBasicMaterial( { color: color } );

  var obj = boxGroup.getObjectByName("meter" + meterAddr);   // 根据id获取
  if(obj){
      for (var i = 0; i < obj.children.length; i++){
          if (obj.children[i].userData.id == "bottom"){
              obj.children[i].material = material;
          }
      }
  }
}

/*
* 设置电表告警状态
* @param meterAddr 表号
* @param flag 是否告警
*/
function setMeterAlarm(meterAddr, flag){
	if(!flag){
		for(var i=0;i < meterAlarmArray.length;i++){
			if(meterAddr == meterAlarmArray[i]){
				changeMeterStyleByName(meterAddr, true);	//恢复正常
				meterAlarmArray.splice(i,1);
				var meterText = boxGroup.getObjectByName(meterAddr + "Text");
				if (meterText){
					boxGroup.remove(meterText);
				}
			}
		}						
	}
	else{
		var isAlarm = false;
		for(var i=0;i < meterAlarmArray.length;i++){
			if(meterAddr == meterAlarmArray[i]){
				isAlarm = true;
			}
		}
		if(!isAlarm){
			meterAlarmArray.push(meterAddr);
			var obj = boxGroup.getObjectByName("meter" + meterAddr);   // 根据id获取
			if (obj){
				box.addTextSprite("表计错位",
			            {
			        fontsize: 20,
			        borderColor: {r:255, g:0, b:0, a:0.4},
			        backgroundColor: {r:255, g:255, b:255, a:0.9}
			    } , [obj.position.x - 1.7,obj.position.y + 0.5,obj.position.z + 0.5], meterAddr + "Text");
			}
		}
  }
}

/*
* 剩余电流超限三维接口
*/
var isTransformerAlarm = false; //是否剩余电流超限告警
var transformerAlarmParam = 0;		// 参数，保证所有告警频率一致
//剩余电流超限动画
function updateTransformerAlarm(){
  transformerAlarmParam ++;
  transformerAlarmParam = transformerAlarmParam%2;
  if (isTransformerAlarm){
	  if(transformerAlarmParam == 0){
		  changeTransformerStyleByName(true);	// 正常样式
	  }else{
		  changeTransformerStyleByName(false);	// 告警样式
	  }
  }
}

function changeTransformerStyleByName(isnormal){
  var color = 0x000000;
  if (isnormal){
      color = 0x000000;
  }
  else{
      color = 0xFF0000;
  }
  var material = new THREE.MeshBasicMaterial( { color: color } );

  var obj = boxGroup.getObjectByName("transformer");   // 获取电流互感器对象
  if(obj){
      for (var i = 0; i < obj.children.length; i++){
          if (obj.children[i].userData.id != "plate"){
              obj.children[i].material = material;
          }
      }
  }
}

/*
* 设置电流互感器告警状态
* @param flag 是否告警
*/
function setTransformerAlarm(flag){
	isTransformerAlarm = flag;
	if (flag){
		box.addTextSprite("剩余电流超限",
	            {
	        fontsize: 20,
	        borderColor: {r:255, g:0, b:0, a:0.4},
	        backgroundColor: {r:255, g:255, b:255, a:0.9}
	    } , [1.5,2,4.5], "transformerText");
	}
	else{
		changeTransformerStyleByName(true);	//恢复正常
		var transformerText = boxGroup.getObjectByName("transformerText");
		if (transformerText){
			boxGroup.remove(transformerText);
		}
	}
}

/*
* 电表误差三维接口
*/
var meterErrorArray = [];		// 电表误差的集合
var meterErrorParam = 0;		// 参数，保证所有告警频率一致
//电表误差动画
function updateMeterError(){
  if(!meterErrorArray || meterErrorArray.length == 0) return;
  meterErrorParam ++;
  meterErrorParam = meterErrorParam%2;
  if(meterErrorParam == 0){
      for(var i=0;i<meterErrorArray.length;i++){
          var meterAddr = meterErrorArray[i].meterAddr;
          var data = meterErrorArray[i].data;
          changeScreenStyleByName(meterAddr, data, true);	// 正常样式
      }
  }else{
      for(var i=0;i<meterErrorArray.length;i++){
    	  var meterAddr = meterErrorArray[i].meterAddr;
          var data = meterErrorArray[i].data;
          changeScreenStyleByName(meterAddr, data, false);	// 告警样式
      }
  }
}
/*
 * 电表屏幕误差时的文字
 */
function getMeterErrorTextCanvas(text, color){
	var width=1000, height=400;
    var canvas = document.createElement('canvas');
    canvas.width = width;
    canvas.height = height;
    var ctx = canvas.getContext('2d');
    ctx.fillStyle = color;
    ctx.fillRect(0, 0, width, height);

    ctx.font = '100px Bahnschrift';
    ctx.fillStyle = '#000000';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.letterSpacingText(text, 500, 200, 10);

    return canvas;
}

//更改电表屏幕样式
function changeScreenStyleByName(meterAddr, data, isnormal){
	var screenMaterial;
    if (isnormal){
	    screenMaterial = new THREE.MeshBasicMaterial( { map: new THREE.CanvasTexture(getMeterErrorTextCanvas(data, '#7D8070'))} );
    }
    else{
	    screenMaterial = new THREE.MeshBasicMaterial( { map: new THREE.CanvasTexture(getMeterErrorTextCanvas(data, '#ff0000'))} );;
    }

    var obj = boxGroup.getObjectByName("meter" + meterAddr);   // 根据id获取
    if(obj){
        for (var i = 0; i < obj.children.length; i++){
            if (obj.children[i].userData.id == "meterScreen"){
                obj.children[i].material[2] = screenMaterial;
            }
        }
    }
}

/*
* 设置电表误差告警状态
* @param meterAddr 表号
* @param data 误差数据
* @param flag 是否误差告警
*/
function setMeterErrorAlarm(meterAddr, data, flag){
	if(!flag){
		for(var i=0;i < meterErrorArray.length;i++){
			if(meterAddr == meterErrorArray[i].meterAddr){
				meterErrorArray.splice(i,1);
				//恢复正常
				$.ajax({
				 	type:'POST', 
			     	url:basePath + '/virtualBox/getMeterData',           
			     	data:{"meterAddr": meterAddr},
			        success:function(d){
			    	    if(d){
			    	    	setMeterValue(meterAddr, d);
			    	    }
			        },	        
			        error:function(d){
			        }
			    });
			}
		}						
	}
	else{
		var isAlarm = false;
		for(var i=0;i < meterErrorArray.length;i++){
			if(meterAddr == meterErrorArray[i].meterAddr){
				meterErrorArray[i].data = data;
				isAlarm = true;
			}
		}
		if(!isAlarm){
			meterErrorArray.push({'meterAddr': meterAddr, 'data': data});
		}
    }
}

/*
* 终端端子过温三维接口
*/
var terminalLineAlarmArray = [];		// 终端端子的集合
var terminalLineAlarmParam = 0;		// 参数，保证所有告警频率一致
//终端端子过温动画
function updateTerminalLineAlarm(){
  if(!terminalLineAlarmArray || terminalLineAlarmArray.length == 0) return;
  terminalLineAlarmParam ++;
  terminalLineAlarmParam = terminalLineAlarmParam%2;
  if(terminalLineAlarmParam == 0){
      for(var i=0;i<terminalLineAlarmArray.length;i++){
          var linename = terminalLineAlarmArray[i];
          changeTerminalLineStyleByName(linename, true);	// 正常样式
      }
  }else{
      for(var i=0;i<terminalLineAlarmArray.length;i++){
          var linename = terminalLineAlarmArray[i];
          changeTerminalLineStyleByName(linename, false);	// 告警样式
      }
  }
}

function changeTerminalLineStyleByName(linename,isnormal){
  var color = 0x000000;
  if (isnormal){
      color = 0x000000;
  }
  else{
      color = 0xFF0000;
  }
  var material = new THREE.MeshBasicMaterial( { color: color } );

  var obj = boxGroup.getObjectByName(linename);   // 根据id获取
  if(obj){
	  obj.material = material;
  }
}

/*
* 设置终端端子状态
* @param terminalAddr 终端地址
* @param num 端子编号
* @param val 温度值
* @param flag 是否告警
*/
function setTerminalLineAlarm(terminalAddr, num, val, flag){
	var linename = terminalAddr + "head" + num;
	if(!flag){
		for(var i=0;i < terminalLineAlarmArray.length;i++){
			if(linename == terminalLineAlarmArray[i]){
				changeTerminalLineStyleByName(linename, true);	//恢复正常
				terminalLineAlarmArray.splice(i,1);
				var lineText = boxGroup.getObjectByName(linename + "Text");
				if (lineText){
					boxGroup.remove(lineText);
				}
			}
		}						
	}
	else{
		var isAlarm = false;
		for(var i=0;i < terminalLineAlarmArray.length;i++){
			if(linename == terminalLineAlarmArray[i]){
				isAlarm = true;
			}
		}
		if(!isAlarm){
			terminalLineAlarmArray.push(linename);
			var obj = boxGroup.getObjectByName(linename);   // 根据id获取
			if (obj){
				box.addTextSprite(val,
			            {
			        fontsize: 20,
			        borderColor: {r:255, g:0, b:0, a:0.4},
			        backgroundColor: {r:255, g:255, b:255, a:0.9}
			    } , [obj.position.x + 1.4,obj.position.y + 0.8,obj.position.z + 0.5], linename + "Text");
			}
		}
    }
}

/*
* 电表端子过温三维接口
*/
var meterLineAlarmArray = [];		// 电表端子的集合
var meterLineAlarmParam = 0;		// 参数，保证所有告警频率一致
//电表端子过温动画
function updateMeterLineAlarm(){
  if(!meterLineAlarmArray || meterLineAlarmArray.length == 0) return;
  meterLineAlarmParam ++;
  meterLineAlarmParam = meterLineAlarmParam%2;
  if(meterLineAlarmParam == 0){
      for(var i=0;i<meterLineAlarmArray.length;i++){
          var linename = meterLineAlarmArray[i];
          changeMeterLineStyleByName(linename, true);	// 正常样式
      }
  }else{
      for(var i=0;i<meterLineAlarmArray.length;i++){
          var linename = meterLineAlarmArray[i];
          changeMeterLineStyleByName(linename, false);	// 告警样式
      }
  }
}

function changeMeterLineStyleByName(linename,isnormal){
    var obj = boxGroup.getObjectByName(linename);   // 根据id获取
    if(obj){
    	var color;
    	if (isnormal){
            color = obj.userData.color;
        }
    	else{
    		color = 0xFF0000;
    	}
    	var material = new THREE.MeshBasicMaterial( { color: color } );
	    obj.material = material;
    }
}

/*
* 设置电表端子状态
* @param meterAddr 电表地址
* @param num 端子编号
* @param val 温度值
* @param flag 是否告警
*/
function setMeterLineAlarm(meterAddr, num, val, flag){
	var linename = meterAddr + "line" + num;
	if(!flag){
		for(var i=0;i < meterLineAlarmArray.length;i++){
			if(linename == meterLineAlarmArray[i]){
				changeMeterLineStyleByName(linename, true);	//恢复正常
				meterLineAlarmArray.splice(i,1);
				var lineText = boxGroup.getObjectByName(linename + "Text");
				if (lineText){
					boxGroup.remove(lineText);
				}
			}
		}						
	}
	else{
		var isAlarm = false;
		for(var i=0;i < meterLineAlarmArray.length;i++){
			if(linename == meterLineAlarmArray[i]){
				isAlarm = true;
			}
		}
		if(!isAlarm){
			meterLineAlarmArray.push(linename);
			var obj = boxGroup.getObjectByName("meter" + meterAddr);   // 根据id获取
			if (obj){
				box.addTextSprite(val,
			            {
			        fontsize: 20,
			        borderColor: {r:255, g:0, b:0, a:0.4},
			        backgroundColor: {r:255, g:255, b:255, a:0.9}
			    } , [obj.position.x - 1.55,obj.position.y + 0.5,obj.position.z - 1.5], linename + "Text");
			}
		}
    }
}

/*
* 添加烟雾
* @param position 烟雾位置
*/
function addFire(position){
	box.addFire(position);
}

/*
* 删除所有烟雾
*/
function removeAllFire(){
	box.removeAllFire();
}

var boxGroup;     // 表箱元素组
// 表箱类
var loadBox = function(){
    if(!boxGroup){
        boxGroup = new THREE.Object3D();
        scene.add(boxGroup);
    }
}

// 加载表箱
loadBox.prototype.load = function(boxId, boxNumber, boxName){
    this.boxId = boxId;
    this.boxNumber = boxNumber;
    this.boxName = boxName;
    // 加载表箱壳体
    this.addWall([10.3,2.2,0.3], [0,0,-6], [0,0,0]); // 前墙
    this.addWall([0.3,2.2,12.3], [5,0,0], [0,0,0]); // 左墙
    this.addWall([0.3,2.2,12.3], [1,0,0], [0,0,0]); // 中墙
    this.addWall([10.3,2.2,0.3], [0,0,6], [0,0,0]); // 后墙
    this.addWall([0.3,2.2,12.3], [-5,0,0], [0,0,0]); // 右墙
    // 加载门
    this.addDoor([4.2,0.1,12.3], [5.15,2.2,-6.15], [0,0,0],"leftdoor", "close", [
        {size:[1.3,0.1,1.1],position:[-1.7,0,5.5]}
    ]); // 左门
    this.addDoor([6.12,0.1,12.3], [-5.15,2.2,-6.15], [0,0,0],"rightdoor", "close",[
        {size:[1.3,0.1,1.1],position:[2,0,4.35]},
        {size:[1.3,0.1,1.1],position:[2,0,7.45]},
        {size:[1.3,0.1,1.1],position:[2,0,10.6]},
        {size:[1.3,0.1,1.1],position:[4,0,4.35]},
        {size:[1.3,0.1,1.1],position:[4,0,7.45]},
        {size:[1.3,0.1,1.1],position:[4,0,10.6]}
    ]); // 右门
    // 加载集中器
    //this.addConcentrator([1.6,0.8,2.2], [3.3,0,-2.5], [0,0,0], "concentrator", {'address': '123456'});
    // 加载集中器断路器
    this.addConBreaker([1,1,1.2], [2.1,0,-3.2], [0,0,0], "conbreaker-left", "on");
    // this.addConBreaker([1,1,1.2], [1.6,0,-3], [0,0,0],
	// "conbreaker-right", "open");
    // 加载监测终端
    //this.addTerminal([2.5,0.8,1.5], [3,0,0], [0,0,0], "terminal", {'address': '66666666'});
    // 加载总断路器
    this.addMainBreaker([1,1,1.2], [3.1,0,2.6], [0,0,0], "mainbreaker", "on");
    // 加载接地模块
    this.addGreenModule([0.3, 0.7, 1.4], [2.1,0,2.6], [0,0,0], "greenmodule-top"); // 上接地模块
    this.addGreenModule([0.3, 0.7, 1.4], [3.1,0,-5], [0,Math.PI/2,0], "greenmodule-bottom"); // 下接地模块
    // 加载电表
    //this.addMeter([1.5, 0.8, 2.5], [-0.8,0,4], [0,0,0], "meter1", {'address': '1'});
    //this.addMeter([1.5, 0.8, 2.5], [-3,0,4], [0,0,0], "meter2", {'address': '2'});
    //this.addMeter([1.5, 0.8, 2.5], [-0.8,0,1], [0,0,0], "meter3", {'address': '3'});
    //this.addMeter([1.5, 0.8, 2.5], [-3,0,1], [0,0,0], "meter4", {'address': '4'});
    //this.addMeter([1.5, 0.8, 2.5], [-0.8,0,-2], [0,0,0], "meter5", {'address': '5'});
    //this.addMeter([1.5, 0.8, 2.5], [-3,0,-2], [0,0,0], "meter6", {'address': '6'});
    // 加载电表断路器
    //this.addMeterBreaker([1, 1, 1.2], [0,0,-4.5], [0,0,0], "meterbreaker1", "on");
    //this.addMeterBreaker([1, 1, 1.2], [-0.8,0,-4.5], [0,0,0], "meterbreaker2", "off");
    //this.addMeterBreaker([1, 1, 1.2], [-1.6,0,-4.5], [0,0,0], "meterbreaker3", "on");
    //this.addMeterBreaker([1, 1, 1.2], [-2.4,0,-4.5], [0,0,0], "meterbreaker4", "off");
    //this.addMeterBreaker([1, 1, 1.2], [-3.2,0,-4.5], [0,0,0], "meterbreaker5", "on");
    //this.addMeterBreaker([1, 1, 1.2], [-4,0,-4.5], [0,0,0], "meterbreaker6", "off");
    // 加载电线
    // 接地线
    this.addWire([[2, 0.2, 2.8], [1, 0.2, 2.8]], 0.04, 0x2357A0, 'groundline1');
    this.addWire([[2, 0.2, 2.7], [1, 0.2, 2.7]], 0.04, 0x2357A0, 'groundline2');
    this.addWire([[2, 0.2, 2.6], [1.31, 0.2, 2.6], [1.3, 0.2, 2.59], [1.3, 0.2, -0.1], [1.29, 0.2, -0.2], [1, 0.2, -0.2]], 0.04, 0x2357A0, 'groundline3');
    this.addWire([[2, 0.2, 2.5], [1.41, 0.2, 2.5], [1.4, 0.2, 2.49], [1.4, 0.2, -0.2], [1.39, 0.2, -0.3], [1, 0.2, -0.3]], 0.04, 0x2357A0, 'groundline4');
    this.addWire([[2, 0.2, 2.4], [1.51, 0.2, 2.4], [1.5, 0.2, 2.39], [1.5, 0.2, -3.5], [1.49, 0.2, -3.6], [1, 0.2, -3.6]], 0.04, 0x2357A0, 'groundline5');
    this.addWire([[2, 0.2, 2.3], [1.61, 0.2, 2.3], [1.6, 0.2, 2.29], [1.6, 0.2, -3.6], [1.59, 0.2, -3.7], [1, 0.2, -3.7]], 0.04, 0x2357A0, 'groundline6');
    this.addWire([[2, 0.2, 2.2], [1.71, 0.2, 2.2], [1.7, 0.2, 2.19], [1.7, 0.2, -2.3], [1.71, 0.2, -2.31], [1.99, 0.2, -2.31], [2, 0.2, -2.32], [2, 0.2, -2.7]], 0.03, 0x2357A0, 'groundline7');
    // 电表接总开关接线
    this.addWire([[3.7, 0.6, 1.25], [3.7, 0.6, 0.26], [3.69, 0.6, 0.25], [1.7, 0.6, 0.25], [1.69, 0.6, 0.24], [1.69, 0.6, -3.69], [1.68, 0.6, -3.7], [1, 0.6, -3.7]], 0.04, 0xBCAA39, 'mainbreakerline1');
    this.addWire([[3.6, 0.6, 1.25], [3.6, 0.6, 0.36], [3.59, 0.6, 0.35], [1.6, 0.6, 0.35], [1.59, 0.6, 0.34], [1.59, 0.6, -3.59], [1.58, 0.6, -3.6], [1, 0.6, -3.6]], 0.04, 0xBCAA39, 'mainbreakerline2');
    this.addWire([[3.15, 0.6, 1.25], [3.15, 0.6, 0.46], [3.14, 0.6, 0.45], [1.5, 0.6, 0.45], [1.49, 0.6, 0.44], [1.49, 0.6, -0.29], [1.48, 0.6, -0.3], [1, 0.6, -0.3]], 0.04, 0x568263, 'mainbreakerline3');
    this.addWire([[3.05, 0.6, 1.25], [3.05, 0.6, 0.56], [3.04, 0.6, 0.55], [1.4, 0.6, 0.55], [1.39, 0.6, 0.54], [1.39, 0.6, -0.19], [1.38, 0.6, -0.2], [1, 0.6, -0.2]], 0.04, 0x568263, 'mainbreakerline4');
    this.addWire([[2.6, 0.6, 1.25], [2.6, 0.6, 0.66], [2.59, 0.6, 0.65], [1, 0.6, 0.65]], 0.04, 0x862f32, 'mainbreakerline5');
    this.addWire([[2.5, 0.6, 1.25], [2.5, 0.6, 0.76], [2.49, 0.6, 0.75], [1, 0.6, 0.75]], 0.04, 0x862f32, 'mainbreakerline6');
    // 集中器断路器接线
    this.addWire([[2.4, 0.6, 1.25], [2.4, 0.6, 0.86], [2.4, 0.2, 0.86], [2.39, 0.2, 0.85], [1.8, 0.2, 0.85], [1.79, 0.2, 0.84], [1.79, 0.2, -2.2], [1.8, 0.2, -2.21], [2.25, 0.2, -2.21], [2.26, 0.2, -2.22], [2.26, 0.2, -2.7]], 0.03, 0x862f32, 'conbreakerline1');
    // 监测终端端子
    /*this.addWire([[3.8, 0.7, 0.75], [3.8, 0.7, 0]], 0.02, 0xBCAA39, 'terminalline1');
    this.addWire([[3.77, 0.7, 0.75], [3.77, 0.7, 0]], 0.02, 0xBCAA39, 'terminalline2');
    this.addWire([[3.785, 0.7, 1], [3.785, 0.7, 0.75]], 0.04, 0x000000, 'terminalhead1');
    this.addWire([[3.25, 0.7, 0.75], [3.25, 0.7, 0]], 0.02, 0x568263, 'terminalline3');
    this.addWire([[3.22, 0.7, 0.75], [3.22, 0.7, 0]], 0.02, 0x568263, 'terminalline4');
    this.addWire([[3.235, 0.7, 1], [3.235, 0.7, 0.75]], 0.04, 0x000000, 'terminalhead2');
    this.addWire([[2.7, 0.7, 0.75], [2.7, 0.7, 0]], 0.02, 0x862f32, 'terminalline5');
    this.addWire([[2.67, 0.7, 0.75], [2.67, 0.7, 0]], 0.02, 0x862f32, 'terminalline6');
    this.addWire([[2.685, 0.7, 1], [2.685, 0.7, 0.75]], 0.04, 0x000000, 'terminalhead3');*/
    // 电表接线
    // 表1
    /*this.addWire([[-0.75, 0, 2.9], [-0.75, 0.4, 2.9], [-0.75, 0.4, 3.4]], 0.04, 0x862f32, 'meterline11');
    this.addWire([[-1.05, 0, 2.9], [-1.05, 0.4, 2.9], [-1.05, 0.4, 3.4]], 0.04, 0x862f32, 'meterline12');
    this.addWire([[-1.35, 0, 2.9], [-1.35, 0.4, 2.9], [-1.35, 0.4, 3.4]], 0.04, 0x2357A0, 'meterline13');
    this.addWire([[-1.65, 0, 2.9], [-1.65, 0.4, 2.9], [-1.65, 0.4, 3.4]], 0.04, 0x2357A0, 'meterline14');
    // 表2
    this.addWire([[-2.85, 0, 2.9], [-2.85, 0.4, 2.9], [-2.85, 0.4, 3.4]], 0.04, 0x862f32, 'meterline21');
    this.addWire([[-3.15, 0, 2.9], [-3.15, 0.4, 2.9], [-3.15, 0.4, 3.4]], 0.04, 0x862f32, 'meterline22');
    this.addWire([[-3.45, 0, 2.9], [-3.45, 0.4, 2.9], [-3.45, 0.4, 3.4]], 0.04, 0x2357A0, 'meterline23');
    this.addWire([[-3.75, 0, 2.9], [-3.75, 0.4, 2.9], [-3.75, 0.4, 3.4]], 0.04, 0x2357A0, 'meterline24');
    // 表3
    this.addWire([[-0.75, 0, -0.4], [-0.75, 0.4, -0.4], [-0.75, 0.4, 0.1]], 0.04, 0x568263, 'meterline31');
    this.addWire([[-1.05, 0, -0.4], [-1.05, 0.4, -0.4], [-1.05, 0.4, 0.1]], 0.04, 0x568263, 'meterline32');
    this.addWire([[-1.35, 0, -0.4], [-1.35, 0.4, -0.4], [-1.35, 0.4, 0.1]], 0.04, 0x2357A0, 'meterline33');
    this.addWire([[-1.65, 0, -0.4], [-1.65, 0.4, -0.4], [-1.65, 0.4, 0.1]], 0.04, 0x2357A0, 'meterline34');
    // 表4
    this.addWire([[-2.85, 0, -0.4], [-2.85, 0.4, -0.4], [-2.85, 0.4, 0.1]], 0.04, 0x568263, 'meterline41');
    this.addWire([[-3.15, 0, -0.4], [-3.15, 0.4, -0.4], [-3.15, 0.4, 0.1]], 0.04, 0x568263, 'meterline42');
    this.addWire([[-3.45, 0, -0.4], [-3.45, 0.4, -0.4], [-3.45, 0.4, 0.1]], 0.04, 0x2357A0, 'meterline43');
    this.addWire([[-3.75, 0, -0.4], [-3.75, 0.4, -0.4], [-3.75, 0.4, 0.1]], 0.04, 0x2357A0, 'meterline44');
    // 表5
    this.addWire([[-0.75, 0, -3.7], [-0.75, 0.4, -3.7], [-0.75, 0.4, -3.2]], 0.04, 0xBCAA39, 'meterline51');
    this.addWire([[-1.05, 0, -3.7], [-1.05, 0.4, -3.7], [-1.05, 0.4, -3.2]], 0.04, 0xBCAA39, 'meterline52');
    this.addWire([[-1.35, 0, -3.7], [-1.35, 0.4, -3.7], [-1.35, 0.4, -3.2]], 0.04, 0x2357A0, 'meterline53');
    this.addWire([[-1.65, 0, -3.7], [-1.65, 0.4, -3.7], [-1.65, 0.4, -3.2]], 0.04, 0x2357A0, 'meterline54');
    // 表6
    this.addWire([[-2.85, 0, -3.7], [-2.85, 0.4, -3.7], [-2.85, 0.4, -3.2]], 0.04, 0xBCAA39, 'meterline61');
    this.addWire([[-3.15, 0, -3.7], [-3.15, 0.4, -3.7], [-3.15, 0.4, -3.2]], 0.04, 0xBCAA39, 'meterline62');
    this.addWire([[-3.45, 0, -3.7], [-3.45, 0.4, -3.7], [-3.45, 0.4, -3.2]], 0.04, 0x2357A0, 'meterline63');
    this.addWire([[-3.75, 0, -3.7], [-3.75, 0.4, -3.7], [-3.75, 0.4, -3.2]], 0.04, 0x2357A0, 'meterline64');*/
    // 加载e锁
    //this.addLock([0.6, 0.3, 1], [0.7, 2.2, 0.7], [Math.PI/2, 0, 0], 'elock', 'close');
    //加载电流互感器
    this.addTransformer([1.4, 1.4, 0.3], [3,0,5], [0,0,0], "transformer");
    //加载湿度传感器
    this.addHumidity([0.3, 0.2, 0.2], [1.2, 0.5, -1], [Math.PI/2, 0, Math.PI/2], "humidity");
    //加载烟感
    this.addSmokeSense([0, 0.6, 0], [0, 1, 6], [-Math.PI/2, 0, 0], "smokesense");
}

/* 创建字体精灵 */
loadBox.prototype.addTextSprite = function(message, parameters, position, name) {
    if ( parameters === undefined ) parameters = {};
    var fontface = parameters.hasOwnProperty("fontface") ?
        parameters["fontface"] : "Arial";
    /* 字体大小 */
    var fontsize = parameters.hasOwnProperty("fontsize") ?
        parameters["fontsize"] : 18;
    /* 边框厚度 */
    var borderThickness = parameters.hasOwnProperty("borderThickness") ?
        parameters["borderThickness"] : 4;
    /* 边框颜色 */
    var borderColor = parameters.hasOwnProperty("borderColor") ?
        parameters["borderColor"] : { r:0, g:0, b:0, a:1.0 };
    /* 背景颜色 */
    var backgroundColor = parameters.hasOwnProperty("backgroundColor") ?
        parameters["backgroundColor"] : { r:255, g:255, b:255, a:1.0 };
    /* 创建画布 */
    var canvas = document.createElement('canvas');
    var context = canvas.getContext('2d');
    /* 字体加粗 */
    context.font = "Bold " + fontsize + "px " + fontface;
    /* 获取文字的大小数据，高度取决于文字的大小 */
    var metrics = context.measureText( message );
    var textWidth = metrics.width;
    /* 背景颜色 */
    context.fillStyle   = "rgba(" + backgroundColor.r + "," + backgroundColor.g + ","
        + backgroundColor.b + "," + backgroundColor.a + ")";
    /* 边框的颜色 */
    context.strokeStyle = "rgba(" + borderColor.r + "," + borderColor.g + ","
        + borderColor.b + "," + borderColor.a + ")";
    context.lineWidth = borderThickness;
    /* 绘制圆角矩形 */
    roundRect(context, borderThickness/2, borderThickness/2, textWidth + borderThickness, fontsize * 1.4 + borderThickness, 6);
    /* 字体颜色 */
    context.fillStyle = "rgba(0, 0, 0, 1.0)";
    context.fillText( message, borderThickness, fontsize + borderThickness);
    /* 画布内容用于纹理贴图 */
    var texture = new THREE.Texture(canvas);
    texture.needsUpdate = true;
    var spriteMaterial = new THREE.SpriteMaterial({ map: texture } );
    var sprite = new THREE.Sprite( spriteMaterial );
    //console.log(sprite.spriteMaterial);
    /* 缩放比例 */
    sprite.scale.set(5,2,0);
    sprite.position.x = position[0];
    sprite.position.y = position[1];
    sprite.position.z = position[2];
    sprite.name = name;
    boxGroup.add(sprite);
}

/* 绘制圆角矩形 */
function roundRect(ctx, x, y, w, h, r) {
    ctx.beginPath();
    ctx.moveTo(x+r, y);
    ctx.lineTo(x+w-r, y);
    ctx.quadraticCurveTo(x+w, y, x+w, y+r);
    ctx.lineTo(x+w, y+h-r);
    ctx.quadraticCurveTo(x+w, y+h, x+w-r, y+h);
    ctx.lineTo(x+r, y+h);
    ctx.quadraticCurveTo(x, y+h, x, y+h-r);
    ctx.lineTo(x, y+r);
    ctx.quadraticCurveTo(x, y, x+r, y);
    ctx.closePath();
    ctx.fill();
    ctx.stroke();
}

/*
 *   加载烟感
 * */
loadBox.prototype.addSmokeSense = function(size,position,rotation,name){
    var senseObj = new THREE.Object3D();
    //底座
    var bottomGeometry = new THREE.CylinderGeometry(0.55, 0.6, 0.2, 64);
    var bottomMaterial = new THREE.MeshLambertMaterial( {color: 0xffffff} );
    var bottom = new THREE.Mesh( bottomGeometry, bottomMaterial );
    bottom.position.x = 0;
    bottom.position.y = 0.1;
    bottom.position.z = 0;
    senseObj.add(bottom);
    //中
    var centerGeometry = new THREE.CylinderGeometry(0.4, 0.47, 0.2, 64);
    var centerMaterial = new THREE.MeshLambertMaterial( {color: 0x000000} );
    var center = new THREE.Mesh( centerGeometry, centerMaterial );
    center.position.x = 0;
    center.position.y = 0.3;
    center.position.z = 0;
    senseObj.add(center);
    //上
    var topGeometry = new THREE.CylinderGeometry(0.4, 0.45, 0.2, 64);
    var topMaterial = new THREE.MeshLambertMaterial( {color: 0xffffff} );
    var top = new THREE.Mesh( topGeometry, topMaterial );
    top.position.x = 0;
    top.position.y = 0.5;
    top.position.z = 0;
    senseObj.add(top);
    //八柱国
    var columnGeometry = new THREE.BoxGeometry(0.08, 0.25, 0.08);
    var columnMaterial = new THREE.MeshBasicMaterial( {color: 0xffffff} );
    var column1 = new THREE.Mesh( columnGeometry, columnMaterial );
    column1.position.x = 0.38;
    column1.position.y = 0.3;
    column1.position.z = -0.18;
    column1.rotation.z = Math.PI / 7;
    senseObj.add(column1);
    
    var column2 = new THREE.Mesh( columnGeometry, columnMaterial );
    column2.position.x = 0.18;
    column2.position.y = 0.3;
    column2.position.z = -0.38;
    column2.rotation.x = Math.PI / 10;
    column2.rotation.z = Math.PI / 15;
    senseObj.add(column2);
    
    var column3 = new THREE.Mesh( columnGeometry, columnMaterial );
    column3.position.x = -0.18;
    column3.position.y = 0.3;
    column3.position.z = -0.38;
    column3.rotation.x = Math.PI / 10;
    column3.rotation.z = -Math.PI / 15;
    senseObj.add(column3);
    
    var column4 = new THREE.Mesh( columnGeometry, columnMaterial );
    column4.position.x = -0.38;
    column4.position.y = 0.3;
    column4.position.z = -0.18;
    column4.rotation.z = -Math.PI / 7;
    senseObj.add(column4);
    
    var column5 = new THREE.Mesh( columnGeometry, columnMaterial );
    column5.position.x = -0.38;
    column5.position.y = 0.3;
    column5.position.z = 0.18;
    column5.rotation.z = -Math.PI / 7;
    senseObj.add(column5);
    
    var column6 = new THREE.Mesh( columnGeometry, columnMaterial );
    column6.position.x = -0.18;
    column6.position.y = 0.3;
    column6.position.z = 0.38;
    column6.rotation.x = -Math.PI / 10;
    column6.rotation.z = -Math.PI / 15;
    senseObj.add(column6);
    
    var column7 = new THREE.Mesh( columnGeometry, columnMaterial );
    column7.position.x = 0.18;
    column7.position.y = 0.3;
    column7.position.z = 0.38;
    column7.rotation.x = -Math.PI / 10;
    column7.rotation.z = Math.PI / 15;
    senseObj.add(column7);
    
    var column8 = new THREE.Mesh( columnGeometry, columnMaterial );
    column8.position.x = 0.38;
    column8.position.y = 0.3;
    column8.position.z = 0.18;
    column8.rotation.z = Math.PI / 7;
    senseObj.add(column8);
    
    senseObj.name = name;
    senseObj.position.x = position[0];
    senseObj.position.y = position[1];
    senseObj.position.z = position[2];
    senseObj.rotation.x = rotation[0];
    senseObj.rotation.y = rotation[1];
    senseObj.rotation.z = rotation[2];
    boxGroup.add(senseObj);
}

/*
 *   加载湿度传感器
 * */
loadBox.prototype.addHumidity = function(size,position,rotation,name){
    var humidityObj = new THREE.Object3D();
    //底座
    var bottomGeometry = new THREE.BoxGeometry(size[0], size[1], size[2]);
    var bototmMaterials = [
        new THREE.MeshBasicMaterial( { color: 0xFFFFFF } ), // right
        new THREE.MeshBasicMaterial( { color: 0xFFFFFF } ), // left
        new THREE.MeshBasicMaterial( { color: 0xFFFFFF } ), // top
        new THREE.MeshBasicMaterial( { color: 0xFFFFFF } ), // bottom
        new THREE.MeshBasicMaterial( { color: 0xFFFFFF } ), // back
        new THREE.MeshBasicMaterial( { color: 0xFFFFFF } ) // front
    ];
    var bottom = new THREE.Mesh( bottomGeometry,bototmMaterials);
    bottom.position.x = 0;
    bottom.position.y = 0;
    bottom.position.z = 0;
    humidityObj.add(bottom);
    
    humidityObj.name = name;
    humidityObj.position.x = position[0];
    humidityObj.position.y = position[1];
    humidityObj.position.z = position[2];
    humidityObj.rotation.x = rotation[0];
    humidityObj.rotation.z = rotation[2];
    boxGroup.add(humidityObj);
}

/*
 *   加载电流互感器
 * */
loadBox.prototype.addTransformer = function(size,position,rotation,name){
    var transformerObj = new THREE.Object3D();
    //底座
    var bottomGeometry = new THREE.BoxGeometry(2.6, 0.2, 0.5);
    var bototmMaterials = [
        new THREE.MeshBasicMaterial( { color: 0x000000 } ), // right
        new THREE.MeshBasicMaterial( { color: 0x000000 } ), // left
        new THREE.MeshBasicMaterial( { color: 0x000000 } ), // top
        new THREE.MeshBasicMaterial( { color: 0x000000 } ), // bottom
        new THREE.MeshBasicMaterial( { color: 0x000000 } ), // back
        new THREE.MeshBasicMaterial( { color: 0x000000 } ) // front
    ];
    var bottom = new THREE.Mesh( bottomGeometry,bototmMaterials);
    bottom.position.x = 0;
    bottom.position.y = 0.1;
    bottom.position.z = 0;
    bottom.geometry.vertices[0].x = 1;
    bottom.geometry.vertices[1].x = 1;
    bottom.geometry.vertices[4].x = -1;
    bottom.geometry.vertices[5].x = -1;
    transformerObj.add(bottom);
    //中
    var centerGeometry = new THREE.CylinderGeometry(0.9, 0.9, 0.5, 64);
    var centerMaterial = new THREE.MeshLambertMaterial( {color: 0x000000} );
    var center = new THREE.Mesh( centerGeometry, centerMaterial );
    center.position.x = 0
    center.position.y = 0.9;
    center.position.z = 0;
    center.rotation.x = Math.PI/2;
    //洞
    var totalBSP = new ThreeBSP(center);
    var holeGeometry = new THREE.CylinderGeometry(0.6, 0.6, 0.5, 64);
    var holeCube = new THREE.Mesh( holeGeometry);
    holeCube.position.x = 0;
    holeCube.position.y = 0.9;
    holeCube.position.z = 0;
    holeCube.rotation.x = Math.PI/2;
    var clipBSP = new ThreeBSP(holeCube);
    var resultBSP = totalBSP.subtract(clipBSP);
    center = resultBSP.toMesh();
    center.material = centerMaterial;
    transformerObj.add(center);
    //棱角
    var hornholeGeometry = new THREE.CylinderGeometry(0.9, 0.9, 0.5, 64);
    var hornholeCube = new THREE.Mesh( hornholeGeometry);
    hornholeCube.position.x = 0
    hornholeCube.position.y = 0.9;
    hornholeCube.position.z = 0;
    hornholeCube.rotation.x = Math.PI/2;
    var hornholeBSP = new ThreeBSP(hornholeCube);

    var hornGeometry = new THREE.CylinderGeometry(0.6, 0.6, 0.5, 64);
    var hornMaterial = new THREE.MeshLambertMaterial( {color: 0x000000} );
    var horn1 = new THREE.Mesh( hornGeometry, hornMaterial );
    horn1.position.x = 0.5;
    horn1.position.y = 1.2;
    horn1.position.z = 0;
    horn1.rotation.x = Math.PI/2;
    var horn1BSP = new ThreeBSP(horn1);
    var horn1resultBSP = horn1BSP.subtract(hornholeBSP);
    horn1 = horn1resultBSP.toMesh();
    horn1.material = hornMaterial;
    transformerObj.add(horn1);

    var horn2 = new THREE.Mesh( hornGeometry, hornMaterial );
    horn2.position.x = -0.5;
    horn2.position.y = 1.2;
    horn2.position.z = 0;
    horn2.rotation.x = Math.PI/2;
    var horn2BSP = new ThreeBSP(horn2);
    var horn2resultBSP = horn2BSP.subtract(hornholeBSP);
    horn2 = horn2resultBSP.toMesh();
    horn2.material = hornMaterial;
    transformerObj.add(horn2);

    //名牌
    var topGeometry = new THREE.BoxGeometry(0.85, 0.1, 0.5);
    var topTexture = new THREE.TextureLoader().load(basePath + "/images/box/transformer.jpg");
    var topMaterials = [
        new THREE.MeshBasicMaterial( { color: 0x000000 } ), // right
        new THREE.MeshBasicMaterial( { color: 0x000000 } ), // left
        new THREE.MeshBasicMaterial( { map: topTexture,side:THREE.DoubleSide } ), // top
        new THREE.MeshBasicMaterial( { color: 0x000000 } ), // bottom
        new THREE.MeshBasicMaterial( { color: 0x000000 } ), // back
        new THREE.MeshBasicMaterial( { color: 0x000000 } ) // front
    ];
    var top = new THREE.Mesh( topGeometry,topMaterials);
    top.position.x = 0;
    top.position.y = 1.8;
    top.position.z = 0;
    top.userData.id = "plate";
    transformerObj.add(top);

    transformerObj.name = name;
    transformerObj.position.x = position[0];
    transformerObj.position.y = position[1];
    transformerObj.position.z = position[2];
    boxGroup.add(transformerObj);
}

/*
 * 加载智能E锁
 */
loadBox.prototype.addLock = function(size, position, rotation, name, status, userData) {
    var lockObj = new THREE.Object3D();
    // 底座
    var bottomGeometry = new THREE.BoxGeometry(0.6, 0.6, 0.25);
    var bottomMaterials = [
        new THREE.MeshBasicMaterial( { color: 0x000000 } ), // right
        new THREE.MeshBasicMaterial( { color: 0x000000 } ), // left
        new THREE.MeshBasicMaterial( { color: 0x000000 } ), // top
        new THREE.MeshBasicMaterial( { color: 0x000000 } ), // bottom
        new THREE.MeshBasicMaterial( { color: 0x000000 } ), // back
        new THREE.MeshBasicMaterial( { color: 0x000000 } ) // front
    ];
    var bottom = new THREE.Mesh( bottomGeometry,bottomMaterials);
    bottom.position.x = 0;
    bottom.position.y = 0;
    bottom.position.z = 0;
    bottom.userData.id = "bottom";
    lockObj.add(bottom);
    // 黑色圆柱
    var blackCylinder = new THREE.CylinderGeometry(0.07, 0.07, 0.03, 64);
    var bMaterial = new THREE.MeshLambertMaterial( {color: 0x000000} );
    var b = new THREE.Mesh( blackCylinder, bMaterial );
    b.position.x = -0.16
    b.position.y = 0.315;
    b.position.z = 0;
    lockObj.add( b );
    // 金属圆柱
    var metalCylinder = new THREE.CylinderGeometry(0.07, 0.07, 0.08, 64);
    var mMaterial = new THREE.MeshLambertMaterial( {color: 0xBDBCB5} );
    var m = new THREE.Mesh( metalCylinder, mMaterial );
    m.position.x = -0.16
    m.position.y = 0.37;
    m.position.z = 0;
    lockObj.add( m );
    // 金属扣
    var metalLine = new THREE.Object3D();
    var vector3s = [];
    vector3s.push( new THREE.Vector3(0.2, 0.3, 0));
    vector3s.push( new THREE.Vector3(0.17, 0.6, 0));
    vector3s.push( new THREE.Vector3(0, 0.65, 0));
    vector3s.push( new THREE.Vector3(-0.13, 0.6, 0));
    vector3s.push( new THREE.Vector3(-0.16, 0.3, 0));
    var curve = new THREE.SplineCurve3(vector3s);
    var geometry = new THREE.TubeGeometry( curve, 64, 0.04, 8, false );
    var material = new THREE.MeshBasicMaterial( { color: 0xBDBCB5 } );
    var mesh = new THREE.Mesh( geometry, material );
    metalLine.add(mesh);
    metalLine.position.x = 0;
    metalLine.position.y = 0;
    metalLine.position.z = 0;
    metalLine.userData.id = "metalLine";
    lockObj.add( metalLine );

    lockObj.name = name;
    lockObj.position.x = position[0];
    lockObj.position.y = position[1] + size[1]/2;
    lockObj.position.z = position[2];
    lockObj.rotation.x = rotation[0];
    lockObj.rotation.y = rotation[1];
    lockObj.rotation.z = rotation[2];
    lockObj.userData = userData;
    boxGroup.add(lockObj);
}

/*
 * 加载电线
 */
loadBox.prototype.addWire = function(points, radius, color, name) {
    var vector3s = [];
    for (var i = 0; i < points.length; i++){
        point = points[i];
        vector3s.push( new THREE.Vector3(point[0], point[1], point[2]));
    }
    var curve = new THREE.SplineCurve3(vector3s);
    var geometry = new THREE.TubeGeometry( curve, 64, radius, 8, false );
    var material = new THREE.MeshBasicMaterial( { color: color } );
    var mesh = new THREE.Mesh( geometry, material );
    mesh.name = name;
    mesh.userData.color = color;
    boxGroup.add( mesh );
}

/*
 * 加载螺丝
 */
loadBox.prototype.addRose = function(parent, size, position, color) {
    var roseObj = new THREE.Object3D();
    var roseGeometry = new THREE.CylinderGeometry(size[0], size[1], size[2], 64);
    var roseMaterial = new THREE.MeshLambertMaterial( {color: color} );
    var rose = new THREE.Mesh( roseGeometry, roseMaterial);
    rose.position.x = position[0];
    rose.position.y = position[1];
    rose.position.z = position[2];
    parent.add(rose);
}

/*
 * 加载电表断路器
 */
loadBox.prototype.addMeterBreaker = function(size,position,rotation,name,status,userData){
    var breakerObj = new THREE.Object3D();
    // 上
    var topGeometry = new THREE.BoxGeometry(0.8, 0.5, 0.3);
    var topTexture = new THREE.TextureLoader().load(basePath + "/images/box/switch_bottom.jpg");
    var topMaterials = [
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // right
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // left
        new THREE.MeshBasicMaterial( { map: topTexture,side:THREE.DoubleSide } ), // top
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // bottom
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // back
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ) // front
    ];
    var top = new THREE.Mesh( topGeometry,topMaterials);
    top.position.x = 0;
    top.position.y = 0;
    top.position.z = 0.45;
    breakerObj.add(top);

    // 中
    var centerGeometry = new THREE.BoxGeometry(0.8, 0.7, 0.6);
    var centerTexture = new THREE.TextureLoader().load(basePath + "/images/box/switch_center.jpg");
    var centerMaterials = [
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // right
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // left
        new THREE.MeshBasicMaterial( { map: centerTexture,side:THREE.DoubleSide } ), // top
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // bottom
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // back
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ) // front
    ];
    var center = new THREE.Mesh( centerGeometry,centerMaterials);
    center.position.x = 0;
    center.position.y = 0;
    center.position.z = 0;
    breakerObj.add(center);

    // 下
    var bottomGeometry = new THREE.BoxGeometry(0.8, 0.5, 0.3);
    var bottomTexture = new THREE.TextureLoader().load(basePath + "/images/box/switch_top.jpg");
    var bottomMaterials = [
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // right
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // left
        new THREE.MeshBasicMaterial( { map: bottomTexture,side:THREE.DoubleSide } ), // top
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // bottom
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // back
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ) // front
    ];
    var bottom = new THREE.Mesh( bottomGeometry,bottomMaterials);
    bottom.position.x = 0;
    bottom.position.y = 0;
    bottom.position.z = -0.45;
    breakerObj.add(bottom);

    // 开关
    var switchObj = new THREE.Object3D();
    // 横杠
    var hGeometry = new THREE.CylinderGeometry(0.06, 0.06 ,0.5, 64);
    var hMaterial = new THREE.MeshLambertMaterial( {color: 0x000000} );
    var h = new THREE.Mesh( hGeometry, hMaterial );
    h.position.x = 0;
    h.position.y = 0.18;
    h.position.z = 0;
    h.rotation.z = Math.PI/2;
    h.userData.id = "meterswitch_h";
    switchObj.add( h );

    // 左支脚
    var lGeometry = new THREE.CylinderGeometry(0.06, 0.06 ,0.15, 64);
    var lMaterial = new THREE.MeshLambertMaterial( {color: 0x000000} );
    var l = new THREE.Mesh( lGeometry, lMaterial );
    l.position.x = 0.13;
    l.position.y = 0.075;
    l.position.z = 0;
    l.userData.id = "meterswitch_l";
    switchObj.add( l );

    // 右支脚
    var rGeometry = new THREE.CylinderGeometry(0.06, 0.06 ,0.15, 64);
    var rMaterial = new THREE.MeshLambertMaterial( {color: 0x000000} );
    var r = new THREE.Mesh( rGeometry, rMaterial );
    r.position.x = -0.15;
    r.position.y = 0.075;
    r.position.z = 0;
    r.userData.id = "meterswitch_r";
    switchObj.add( r );

    switchObj.position.x = -0.12;
    switchObj.position.y = 0.35;
    switchObj.position.z = 0;
    switchObj.userData.id = "meterswitch";
    switchObj.userData.status = status;
    if (status == "off"){
        switchObj.rotation.x = -Math.PI/4;
    }
    else{
        switchObj.rotation.x = Math.PI/4;
    }
    breakerObj.add(switchObj);

    breakerObj.name = name;
    breakerObj.position.x = position[0];
    breakerObj.position.y = position[1] + size[1]/2;
    breakerObj.position.z = position[2];
    breakerObj.userData = userData;
    boxGroup.add(breakerObj);
}

/*
 * 加载电表
 */
loadBox.prototype.addMeter = function(size,position,rotation,name,userData){
    var meterObj = new THREE.Object3D();
    // 底座
    var bottomGeometry = new THREE.BoxGeometry(1.5, 0.3, 2.2);
    var bottomMaterials = [
        new THREE.MeshBasicMaterial( { color: 0xD8D0C8 } ), // right
        new THREE.MeshBasicMaterial( { color: 0xD8D0C8 } ), // left
        new THREE.MeshBasicMaterial( { color: 0xD8D0C8  } ), // top
        new THREE.MeshBasicMaterial( { color: 0xD8D0C8 } ), // bottom
        new THREE.MeshBasicMaterial( { color: 0xD8D0C8 } ), // back
        new THREE.MeshBasicMaterial( { color: 0xD8D0C8 } ) // front
    ];
    var bottom = new THREE.Mesh( bottomGeometry, bottomMaterials);
    bottom.userData.id = "bottom";
    bottom.position.x = 0;
    bottom.position.y = -0.25;
    bottom.position.z = 0;
    meterObj.add(bottom);
    // 金属壳
    var metalGeometry = new THREE.BoxGeometry(1.5, 0.4, 1.8);
    var texture = new THREE.TextureLoader().load(basePath + "/images/box/meter.jpg");
    var metalMaterials = [
        new THREE.MeshBasicMaterial( { color: 0xE3DAD3 } ), // right
        new THREE.MeshBasicMaterial( { color: 0xE3DAD3 } ), // left
        new THREE.MeshBasicMaterial( { map: texture,side:THREE.DoubleSide  } ), // top
        new THREE.MeshBasicMaterial( { color: 0xE3DAD3 } ), // bottom
        new THREE.MeshBasicMaterial( { color: 0xE3DAD3 } ), // back
        new THREE.MeshBasicMaterial( { color: 0xE3DAD3 } ) // front
    ];
    var metal = new THREE.Mesh( metalGeometry, metalMaterials);
    metal.position.x = 0;
    metal.position.y = 0.1;
    metal.position.z = 0.2;
    metal.userData.id = "metal";
    meterObj.add(metal);

    // 塑料壳
    var plasticObj = new THREE.Object3D();
    var plasticGeometry = new THREE.BoxGeometry(1.5, 0.4, 0.4);
    var plasticMaterials = [
        new THREE.MeshBasicMaterial( { color: 0x706d64, transparent: true, opacity: 0.4 } ), // right
        new THREE.MeshBasicMaterial( { color: 0x706d64, transparent: true, opacity: 0.4 } ), // left
        new THREE.MeshBasicMaterial( { color: 0x706d64, transparent: true, opacity: 0.4  } ), // top
        new THREE.MeshBasicMaterial( { color: 0x706d64, transparent: true, opacity: 0 } ), // bottom
        new THREE.MeshBasicMaterial( { color: 0x706d64, transparent: true, opacity: 0 } ), // back
        new THREE.MeshBasicMaterial( { color: 0x706d64, transparent: true, opacity: 0.4 } ) // front
    ];
    var plastic = new THREE.Mesh( plasticGeometry, plasticMaterials);
    plastic.position.x = 0;
    plastic.position.y = -0.2;
    plastic.position.z = -0.2;
    plastic.userData.id = 'meterplastic';
    plasticObj.add(plastic);

    plasticObj.position.x = 0;
    plasticObj.position.y = 0.3;
    plasticObj.position.z = -0.7;
    plasticObj.userData.status = "close";
    meterObj.add(plasticObj);

    // 屏幕
    var screenGeometry = new THREE.BoxGeometry(0.82, 0.01, 0.33);
    var screenMaterials = [
        new THREE.MeshBasicMaterial( { color: 0x7D8070 } ), // right
        new THREE.MeshBasicMaterial( { color: 0x7D8070 } ), // left
        new THREE.MeshBasicMaterial( { map: new THREE.CanvasTexture(getMeterTextCanvas('000000.00')) } ), // top
        new THREE.MeshBasicMaterial( { color: 0x7D8070 } ), // bottom
        new THREE.MeshBasicMaterial( { color: 0x7D8070 } ), // back
        new THREE.MeshBasicMaterial( { color: 0x7D8070 } ) // front
    ];
    var screen = new THREE.Mesh( screenGeometry,screenMaterials);
    // 设置监测终端屏幕位置
    screen.userData.id = "meterScreen";
    screen.position.x = 0.02;
    screen.position.y = 0.31;
    screen.position.z = 0.77;
    screen.rotation.y = Math.PI;
    meterObj.add(screen);

    meterObj.name = name;
    meterObj.position.x = position[0];
    meterObj.position.y = position[1] + size[1]/2;
    meterObj.position.z = position[2];
    meterObj.userData = userData;
    boxGroup.add(meterObj);
}

/*
 *   增加字符间距
 * */
CanvasRenderingContext2D.prototype.letterSpacingText = function (text, x, y, letterSpacing) {
    var context = this;
    var canvas = context.canvas;

    if (!letterSpacing && canvas) {
        letterSpacing = parseFloat(window.getComputedStyle(canvas).letterSpacing);
    }
    if (!letterSpacing) {
        return this.fillText(text, x, y);
    }

    var arrText = text.split('');
    var align = context.textAlign || 'left';

    // 这里仅考虑水平排列
    var originWidth = context.measureText(text).width;
    // 应用letterSpacing占据宽度
    var actualWidth = originWidth + letterSpacing * (arrText.length - 1);
    // 根据水平对齐方式确定第一个字符的坐标
    if (align == 'center') {
        x = x - actualWidth / 2;
    } else if (align == 'right') {
        x = x - actualWidth;
    }

    // 临时修改为文本左对齐
    context.textAlign = 'left';
    // 开始逐字绘制
    arrText.forEach(function (letter) {
        var letterWidth = context.measureText(letter).width;
        context.fillText(letter, x, y);
        // 确定下一个字符的横坐标
        x = x + letterWidth + letterSpacing;
    });
    // 对齐方式还原
    context.textAlign = align;
};

/*
 * 电表屏幕
 */
function getMeterTextCanvas(text){
	var width=1000, height=400;
    var canvas = document.createElement('canvas');
    canvas.width = width;
    canvas.height = height;
    var ctx = canvas.getContext('2d');
    ctx.fillStyle = '#7D8070';
    ctx.fillRect(0, 0, width, height);
    ctx.font = '65px Arial';
    ctx.fillStyle = '#000000';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText("有功总电量", 200, 70);

    ctx.font = '120px Bahnschrift Light';
    ctx.fillStyle = '#000000';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.letterSpacingText(text, 500, 200, 40);

    ctx.font = '65px Arial';
    ctx.fillStyle = '#000000';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText("kWh", 900, 330);
    return canvas;
}

/*
 * 加载监测终端
 */
loadBox.prototype.addTerminal = function(size,position,rotation,name,userData){
    var terminalObj = new THREE.Object3D();
    var terminalGeometry = new THREE.BoxGeometry(size[0], size[1], size[2]);
    var texture = new THREE.TextureLoader().load(basePath + "/images/box/terminal.jpg");
    var materials = [
        new THREE.MeshBasicMaterial( { color: 0xE3DAD3 } ), // right
        new THREE.MeshBasicMaterial( { color: 0xE3DAD3 } ), // left
        new THREE.MeshBasicMaterial( { map: texture,side:THREE.DoubleSide  } ), // top
        new THREE.MeshBasicMaterial( { color: 0xE3DAD3 } ), // bottom
        new THREE.MeshBasicMaterial( { color: 0xE3DAD3 } ), // back
        new THREE.MeshBasicMaterial( { color: 0xE3DAD3 } ) // front
    ];
    var terminal = new THREE.Mesh( terminalGeometry,materials);
    // 设置监测终端位置
    terminal.position.x = 0;
    terminal.position.y = 0;
    terminal.position.z = 0;
    terminalObj.add(terminal);

    var screenGeometry = new THREE.BoxGeometry(0.82, 0.02, 0.33);
    var screenMaterials = [
        new THREE.MeshBasicMaterial( { color: 0x4C3F2F } ), // right
        new THREE.MeshBasicMaterial( { color: 0x4C3F2F } ), // left
        new THREE.MeshBasicMaterial( { map: new THREE.CanvasTexture(getTerminalTextCanvas('', '', '')) } ), // top
        new THREE.MeshBasicMaterial( { color: 0x4C3F2F } ), // bottom
        new THREE.MeshBasicMaterial( { color: 0x4C3F2F } ), // back
        new THREE.MeshBasicMaterial( { color: 0x4C3F2F } ) // front
    ];
    var screen = new THREE.Mesh( screenGeometry,screenMaterials);
    // 设置监测终端屏幕位置
    screen.userData.id = "terminalScreen";
    screen.position.x = 0.445;
    screen.position.y = 0.41;
    screen.position.z = 0.025;
    screen.rotation.y = Math.PI;
    terminalObj.add(screen);

    terminalObj.name = name;
    terminal.userData = userData;
    terminalObj.position.x = position[0];
    terminalObj.position.y = position[1] + size[1]/2;
    terminalObj.position.z = position[2];
    boxGroup.add(terminalObj);
}

/*
* 监测终端显示屏的内容
* @param temperature 环境温度 
* @param pressure 大气压力
* @param humidness 空气温度
*/
function getTerminalTextCanvas(temperature, pressure, humidness){
	var width=1000, height=400;
    var canvas = document.createElement('canvas');
    canvas.width = width;
    canvas.height = height;
    var ctx = canvas.getContext('2d');
    ctx.fillStyle = '#7D8070';
    ctx.fillRect(0, 0, width, height);
    
    ctx.font = '90px Arial';
    ctx.fillStyle = '#000000';
    ctx.textAlign = 'right';
    ctx.textBaseline = 'middle';
    ctx.fillText("环境温度:", 500, 100);
    
    ctx.font = '90px Arial';
    ctx.fillStyle = '#000000';
    ctx.textAlign = 'left';
    ctx.textBaseline = 'middle';
    ctx.fillText(temperature + "℃", 500, 100);
    
    ctx.font = '90px Arial';
    ctx.fillStyle = '#000000';
    ctx.textAlign = 'right';
    ctx.textBaseline = 'middle';
    ctx.fillText("大气压力:", 500, 200);
    
    ctx.font = '90px Arial';
    ctx.fillStyle = '#000000';
    ctx.textAlign = 'left';
    ctx.textBaseline = 'middle';
    ctx.fillText(pressure + "kPa", 500, 200);
    
    ctx.font = '90px Arial';
    ctx.fillStyle = '#000000';
    ctx.textAlign = 'right';
    ctx.textBaseline = 'middle';
    ctx.fillText("空气湿度:", 500, 300);
    
    ctx.font = '90px Arial';
    ctx.fillStyle = '#000000';
    ctx.textAlign = 'left';
    ctx.textBaseline = 'middle';
    ctx.fillText(humidness, 500, 300);
    return canvas;
}

/*
 * 加载集中器断路器
 */
loadBox.prototype.addConBreaker = function(size,position,rotation,name,status){
    var breakerObj = new THREE.Object3D();
    // 上
    var topGeometry = new THREE.BoxGeometry(0.6, 0.5, 0.3);
    var topTexture = new THREE.TextureLoader().load(basePath + "/images/box/conbreaker_back.jpg");
    var topMaterials = [
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // right
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // left
        new THREE.MeshBasicMaterial( { map: topTexture,side:THREE.DoubleSide } ), // top
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // bottom
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // back
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ) // front
    ];
    var top = new THREE.Mesh( topGeometry,topMaterials);
    top.position.x = 0;
    top.position.y = 0;
    top.position.z = 0.45;
    breakerObj.add(top);

    // 中
    var centerGeometry = new THREE.BoxGeometry(0.6, 0.7, 0.6);
    var centerTexture = new THREE.TextureLoader().load(basePath + "/images/box/conbreaker_center.jpg");
    var centerMaterials = [
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // right
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // left
        new THREE.MeshBasicMaterial( { map: centerTexture,side:THREE.DoubleSide } ), // top
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // bottom
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // back
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ) // front
    ];
    var center = new THREE.Mesh( centerGeometry,centerMaterials);
    center.position.x = 0;
    center.position.y = 0;
    center.position.z = 0;
    breakerObj.add(center);

    // 下
    var bottomGeometry = new THREE.BoxGeometry(0.6, 0.5, 0.3);
    var bottomTexture = new THREE.TextureLoader().load(basePath + "/images/box/conbreaker.jpg");
    var bottomMaterials = [
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // right
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // left
        new THREE.MeshBasicMaterial( { map: bottomTexture,side:THREE.DoubleSide } ), // top
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // bottom
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // back
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ) // front
    ];
    var bottom = new THREE.Mesh( bottomGeometry,bottomMaterials);
    bottom.position.x = 0;
    bottom.position.y = 0;
    bottom.position.z = -0.45;
    breakerObj.add(bottom);

    // 开关
    var switchObj = new THREE.Object3D();
    // 横杠
    var hGeometry = new THREE.CylinderGeometry(0.07, 0.07 ,0.5, 64);
    var hMaterial = new THREE.MeshLambertMaterial( {color: 0x315590} );
    var h = new THREE.Mesh( hGeometry, hMaterial );
    h.position.x = 0;
    h.position.y = 0.18;
    h.position.z = 0;
    h.rotation.z = Math.PI/2;
    h.userData.id = "conswitch_h";
    switchObj.add( h );

    // 左支脚
    var lGeometry = new THREE.CylinderGeometry(0.06, 0.06 ,0.15, 64);
    var lMaterial = new THREE.MeshLambertMaterial( {color: 0x315590} );
    var l = new THREE.Mesh( lGeometry, lMaterial );
    l.position.x = 0.13;
    l.position.y = 0.075;
    l.position.z = 0;
    l.userData.id = "conswitch_l";
    switchObj.add( l );

    // 右支脚
    var rGeometry = new THREE.CylinderGeometry(0.06, 0.06 ,0.15, 64);
    var rMaterial = new THREE.MeshLambertMaterial( {color: 0x315590} );
    var r = new THREE.Mesh( rGeometry, rMaterial );
    r.position.x = -0.15;
    r.position.y = 0.075;
    r.position.z = 0;
    // r.rotation.x = -Math.PI/4;
    r.userData.id = "conswitch_r";
    switchObj.add( r );

    switchObj.position.x = 0;
    switchObj.position.y = 0.35;
    switchObj.position.z = -0.02;
    switchObj.userData.status = status;
    switchObj.userData.id = "conswitch";
    if (status == "off"){
        switchObj.rotation.x = -Math.PI/4;
    }
    else{
        switchObj.rotation.x = Math.PI/4;
    }
    breakerObj.add(switchObj);

    breakerObj.name = name;
    breakerObj.position.x = position[0];
    breakerObj.position.y = position[1] + size[1]/2;
    breakerObj.position.z = position[2];
    boxGroup.add(breakerObj);
}

/*
 * 加载集中器
 */
loadBox.prototype.addConcentrator = function(size,position,rotation,name, userData){
    var conObj = new THREE.Object3D();
    // 底座
    var bottomGeometry = new THREE.BoxGeometry(1.5, 0.3, 2.2);
    var bottomTexture = new THREE.TextureLoader().load(basePath + "/images/box/conbottom.jpg");
    var bottomMaterials = [
        new THREE.MeshBasicMaterial( { color: 0x8B8A88 } ), // right
        new THREE.MeshBasicMaterial( { color: 0x8B8A88 } ), // left
        new THREE.MeshBasicMaterial( { color: 0x8B8A88  } ), // top
        new THREE.MeshBasicMaterial( { color: 0x8B8A88 } ), // bottom
        new THREE.MeshBasicMaterial( { color: 0x8B8A88 } ), // back
        new THREE.MeshBasicMaterial( { map: bottomTexture,side:THREE.DoubleSide } ) // front
    ];
    var bottom = new THREE.Mesh( bottomGeometry, bottomMaterials);
    bottom.position.x = 0;
    bottom.position.y = -0.25;
    bottom.position.z = 0;
    conObj.add(bottom);
    // 中间层
    var centerGeometry = new THREE.BoxGeometry(1.5, 0.3, 2.2);
    var centerMaterials = [
        new THREE.MeshBasicMaterial( { color: 0xB3A7A0 } ), // right
        new THREE.MeshBasicMaterial( { color: 0xB3A7A0 } ), // left
        new THREE.MeshBasicMaterial( { color: 0xB3A7A0  } ), // top
        new THREE.MeshBasicMaterial( { color: 0xB3A7A0 } ), // bottom
        new THREE.MeshBasicMaterial( { color: 0xB3A7A0 } ), // back
        new THREE.MeshBasicMaterial( { color: 0xB3A7A0 } ) // front
    ];
    var center = new THREE.Mesh( centerGeometry, centerMaterials);
    center.position.x = 0;
    center.position.y = 0.05;
    center.position.z = 0;
    conObj.add(center);
    // 上层
    var topGeometry = new THREE.BoxGeometry(1.5, 0.2, 2.2);
    var topTextureTop = new THREE.TextureLoader().load(basePath + "/images/box/contop.jpg");
    var topTextureFront = new THREE.TextureLoader().load(basePath + "/images/box/confront.jpg");
    var topMaterials = [
        new THREE.MeshBasicMaterial( { color: 0xB3A7A0 } ), // right
        new THREE.MeshBasicMaterial( { color: 0xB3A7A0 } ), // left
        new THREE.MeshBasicMaterial( { map: topTextureTop,side:THREE.DoubleSide  } ), // top
        new THREE.MeshBasicMaterial( { color: 0xB3A7A0 } ), // bottom
        new THREE.MeshBasicMaterial( { color: 0xB3A7A0 } ), // back
        new THREE.MeshBasicMaterial( { map: topTextureFront,side:THREE.DoubleSide } ) // front
    ];
    var top = new THREE.Mesh( topGeometry, topMaterials);
    top.position.x = 0;
    top.position.y = 0.3;
    top.position.z = 0;
    top.geometry.vertices[1].z = -0.8;
    top.geometry.vertices[4].z = -0.8;
    conObj.add(top);

    conObj.name = name;
    conObj.userData = userData;
    conObj.position.x = position[0];
    conObj.position.y = position[1] + size[1]/2;
    conObj.position.z = position[2];
    boxGroup.add(conObj);
}

function getTextCanvas(text){
    var width=120, height=100;
    var canvas = document.createElement('canvas');
    canvas.width = width;
    canvas.height = height;
    var ctx = canvas.getContext('2d');
    ctx.fillStyle = '#4C3F2F';
    ctx.fillRect(0, 0, width, height);
    ctx.font = 20+'px " bold';
    ctx.fillStyle = '#2891FF';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText(text, width/2,height/4);
    return canvas;
}

/*
 * 表箱壳体
 */
loadBox.prototype.addWall = function(size, position, rotation){
    var cubeGeometry = new THREE.BoxGeometry(size[0], size[1], size[2]);
    // 合成立方体
    var material = new THREE.MeshLambertMaterial({color: 0xbdb5a5,side:THREE.DoubleSide});
    // var cube = new THREE.Mesh( cubeGeometry, faceMaterial );
    var cube = new THREE.Mesh( cubeGeometry,material);
    cube.position.x = position[0];
    cube.position.y = position[1] + size[1]/2;
    cube.position.z = position[2];
    var result = cube;
    boxGroup.add(result);
}

/*
 * 创建门
 */
loadBox.prototype.addDoor = function(size,position,rotation,name,status,holes){
	var doorObj = new THREE.Object3D();
    var frontTexture; //正面贴图
    var backTexture; //背面贴图
    var otherTexture; //其他面贴图
    if (name == "leftdoor"){
        frontTexture = new THREE.TextureLoader().load(basePath + '/images/box/leftdoor.png');
        backTexture = new THREE.TextureLoader().load(basePath + '/images/box/leftdoor_back.png');
        otherTexture = new THREE.TextureLoader().load(basePath + '/images/box/leftdoor.png');
    }
    else{
        frontTexture = new THREE.TextureLoader().load(basePath + '/images/box/rightdoor.png');
        backTexture = new THREE.TextureLoader().load(basePath + '/images/box/rightdoor_back.png');
        otherTexture = new THREE.TextureLoader().load(basePath + '/images/box/rightdoor.png');
    }

    var geometry = new THREE.BoxGeometry(size[0], size[1], size[2]);
    var material = new THREE.MeshBasicMaterial({map: otherTexture,side:THREE.DoubleSide});
    var door  = new THREE.Mesh(geometry, material);
    door.position.x = (name=="leftdoor"?-size[0]/2:size[0]/2);
    door.position.y = 0;
    door.position.z = size[2]/2;
    var result = door;
    if (holes){
        for (var i = 0 ; i < holes.length; i++){
            var totalBSP = new ThreeBSP(result);
            var holeGeometry = new THREE.BoxGeometry(holes[i].size[0], holes[i].size[1], holes[i].size[2]);
            var holeCube = new THREE.Mesh( holeGeometry);
            holeCube.position.x = holes[i].position[0];
            holeCube.position.y = holes[i].position[1];
            holeCube.position.z = holes[i].position[2];
            var clipBSP = new ThreeBSP(holeCube);
            var resultBSP = totalBSP.subtract(clipBSP);
            result = resultBSP.toMesh();
        }
        result.material = material;
    }
    result.userData.id = "door";
    doorObj.add(result);
    //门表面
    var faceGeometry = new THREE.BoxGeometry(size[0], 0.01, size[2]);
    var frontMaterial = new THREE.MeshBasicMaterial({map: frontTexture,side:THREE.DoubleSide});
    var doorFront = new THREE.Mesh(faceGeometry, frontMaterial);
    doorFront.position.x = (name=="leftdoor"?-size[0]/2:size[0]/2);
    doorFront.position.y = 0.055;
    doorFront.position.z = size[2]/2;
    if (holes){
        for (var i = 0 ; i < holes.length; i++){
            var totalBSP = new ThreeBSP(doorFront);
            var holeGeometry = new THREE.BoxGeometry(holes[i].size[0], 0.01, holes[i].size[2]);
            var holeCube = new THREE.Mesh( holeGeometry);
            holeCube.position.x = holes[i].position[0];
            holeCube.position.y = 0.055;
            holeCube.position.z = holes[i].position[2];
            var clipBSP = new ThreeBSP(holeCube);
            var resultBSP = totalBSP.subtract(clipBSP);
            doorFront = resultBSP.toMesh();
        }
        doorFront.material = frontMaterial;
    }
    doorFront.userData.id = "doorfront";
    doorObj.add(doorFront);
    //门背面
    var backGeometry = new THREE.BoxGeometry(size[0], 0.01, size[2]);
    var backMaterial = new THREE.MeshBasicMaterial({map: backTexture,side:THREE.DoubleSide});
    var doorBack = new THREE.Mesh(backGeometry, backMaterial);
    doorBack.position.x = (name=="leftdoor"?-size[0]/2:size[0]/2);
    doorBack.position.y = -0.055;
    doorBack.position.z = size[2]/2;
    if (holes){
        for (var i = 0 ; i < holes.length; i++){
            var totalBSP = new ThreeBSP(doorBack);
            var holeGeometry = new THREE.BoxGeometry(holes[i].size[0], 0.01, holes[i].size[2]);
            var holeCube = new THREE.Mesh( holeGeometry);
            holeCube.position.x = holes[i].position[0];
            holeCube.position.y = -0.055;
            holeCube.position.z = holes[i].position[2];
            var clipBSP = new ThreeBSP(holeCube);
            var resultBSP = totalBSP.subtract(clipBSP);
            doorBack = resultBSP.toMesh();
        }
        doorBack.material = backMaterial;
    }
    doorBack.userData.id = "doorback";
    doorObj.add(doorBack);

    doorObj.userData.status = status;
    doorObj.name = name;
    doorObj.position.x = position[0];
    doorObj.position.y = position[1];
    doorObj.position.z = position[2];
    if (status == "open"){
        if(name == "leftdoor"){
            doorObj.rotation.z = -Math.PI/2 - 1;
        }else{
            doorObj.rotation.z = Math.PI/2 + 1;
        }
    }
    else{
        doorObj.rotation.z = 0;
    }
    boxGroup.add(doorObj);				// 添加填充
}

/*
 * 总断路器
 */
loadBox.prototype.addMainBreaker = function(size,position,rotation,name,status){
    var breakerObj = new THREE.Object3D();
    // 黑色底座
    var bottomGeometry = new THREE.BoxGeometry(1.5, 0.4, 2);
    var materials = [
        new THREE.MeshBasicMaterial( { color: 0x303433 } ), // right
        new THREE.MeshBasicMaterial( { color: 0x303433 } ), // left
        new THREE.MeshBasicMaterial( { color: 0x303433 } ), // top
        new THREE.MeshBasicMaterial( { color: 0x303433 } ), // bottom
        new THREE.MeshBasicMaterial( { color: 0x303433 } ), // back
        new THREE.MeshBasicMaterial( { color: 0x303433 } ) // front
    ];
    var bottom = new THREE.Mesh( bottomGeometry,materials);
    bottom.position.x = 0;
    bottom.position.y = -0.2;
    bottom.position.z = 0;
    var bottomBsp = new ThreeBSP(bottom);
    // 接线孔
    bottomBsp = addHole(bottomBsp, [0.25, 0.2, 0.3], [0, -0.1, 0.85]);
    bottomBsp = addHole(bottomBsp, [0.25, 0.2, 0.3], [0.55, -0.1, 0.85]);
    bottomBsp = addHole(bottomBsp, [0.25, 0.2, 0.3], [-0.55, -0.1, 0.85]);
    bottomBsp = addHole(bottomBsp, [0.25, 0.2, 0.3], [0, -0.1, -0.85]);
    bottomBsp = addHole(bottomBsp, [0.25, 0.2, 0.3], [0.55, -0.1, -0.85]);
    bottomBsp = addHole(bottomBsp, [0.25, 0.2, 0.3], [-0.55, -0.1, -0.85]);
    bottom = bottomBsp.toMesh();
    bottom.material = materials;
    breakerObj.add(bottom);

    // 中间层
    var centerGeometry = new THREE.BoxGeometry(1.5, 0.3, 2);
    var centerMaterials = [
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // right
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // left
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // top
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // bottom
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // back
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ) // front
    ];
    var center = new THREE.Mesh( centerGeometry,centerMaterials);
    center.position.x = 0;
    center.position.y = 0.15;
    center.position.z = 0;
    var centerBsp = new ThreeBSP(center);
    // 接线孔
    centerBsp = addHole(centerBsp, [0.25, 0.3, 0.3], [0, 0.15, 0.85]);
    centerBsp = addHole(centerBsp, [0.25, 0.3, 0.3], [0.55, 0.15, 0.85]);
    centerBsp = addHole(centerBsp, [0.25, 0.3, 0.3], [-0.55, 0.15, 0.85]);
    centerBsp = addHole(centerBsp, [0.25, 0.3, 0.3], [0, 0.15, -0.85]);
    centerBsp = addHole(centerBsp, [0.25, 0.3, 0.3], [0.55, 0.15, -0.85]);
    centerBsp = addHole(centerBsp, [0.25, 0.3, 0.3], [-0.55, 0.15, -0.85]);

    // 黑洞
    centerBsp = addCircleHole(centerBsp, [0.1, 0.1, 0.3], [0.25, 0.15, 0.85]);
    centerBsp = addCircleHole(centerBsp, [0.1, 0.1, 0.3], [-0.25, 0.15, 0.85]);
    centerBsp = addCircleHole(centerBsp, [0.1, 0.1, 0.3], [0.25, 0.15, -0.85]);
    centerBsp = addCircleHole(centerBsp, [0.1, 0.1, 0.3], [-0.25, 0.15, -0.85]);
    // 螺孔
    centerBsp = addCircleHole(centerBsp, [0.07, 0.07, 0.3], [0.25, 0.15, 0.6]);
    centerBsp = addCircleHole(centerBsp, [0.07, 0.07, 0.3], [0.7, 0.15, 0.6]);
    centerBsp = addCircleHole(centerBsp, [0.07, 0.07, 0.3], [-0.25, 0.15, 0.6]);
    centerBsp = addCircleHole(centerBsp, [0.07, 0.07, 0.3], [-0.7, 0.15, 0.6]);
    centerBsp = addCircleHole(centerBsp, [0.07, 0.07, 0.3], [0.25, 0.15, -0.6]);
    centerBsp = addCircleHole(centerBsp, [0.07, 0.07, 0.3], [-0.25, 0.15, -0.6]);

    center = centerBsp.toMesh();
    center.material = centerMaterials;
    breakerObj.add(center);
    // 接线孔螺丝
    this.addRose(breakerObj, [0.1, 0.1, 0.6], [0, -0.05, 0.85], 0xc9c9c9);
    this.addRose(breakerObj, [0.1, 0.1, 0.6], [0.55, -0.05, 0.85], 0xc9c9c9);
    this.addRose(breakerObj, [0.1, 0.1, 0.6], [-0.55, -0.05, 0.85], 0xc9c9c9);
    this.addRose(breakerObj, [0.1, 0.1, 0.6], [0, -0.05, -0.85], 0xc9c9c9);
    this.addRose(breakerObj, [0.1, 0.1, 0.6], [0.55, -0.05, -0.85], 0xc9c9c9);
    this.addRose(breakerObj, [0.1, 0.1, 0.6], [-0.55, -0.05, -0.85], 0xc9c9c9);

    // 黑洞螺丝
    this.addRose(breakerObj, [0.1, 0.1, 0.3], [0.25, 0.15, 0.85], 0x362d29);
    this.addRose(breakerObj, [0.1, 0.1, 0.3], [-0.25, 0.15, 0.85], 0x362d29);
    this.addRose(breakerObj, [0.1, 0.1, 0.3], [0.25, 0.15, -0.85], 0x362d29);
    this.addRose(breakerObj, [0.1, 0.1, 0.3], [-0.25, 0.15, -0.85], 0x362d29);

    // 螺孔螺丝
    this.addRose(breakerObj, [0.05, 0.05, 0.2], [0.25, 0.2, 0.6], 0x8d9295);
    this.addRose(breakerObj, [0.05, 0.05, 0.2], [0.7, 0.2, 0.6], 0x8d9295);
    this.addRose(breakerObj, [0.05, 0.05, 0.2], [-0.25, 0.2, 0.6], 0x8d9295);
    this.addRose(breakerObj, [0.05, 0.05, 0.2], [-0.7, 0.2, 0.6], 0x8d9295);
    this.addRose(breakerObj, [0.05, 0.05, 0.2], [0.25, 0.2, -0.6], 0x8d9295);
    this.addRose(breakerObj, [0.05, 0.05, 0.2], [-0.25, 0.2, -0.6], 0x8d9295);

    // 盖子
    var topGeometry = new THREE.BoxGeometry(1.5, 0.1, 1);
    var texture = new THREE.TextureLoader().load(basePath + "/images/box/mainbreaker.jpg");
    var topMaterials = [
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // right
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // left
        new THREE.MeshBasicMaterial( { map: texture,side:THREE.DoubleSide } ), // top
        // new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), //top
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // bottom
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ), // back
        new THREE.MeshBasicMaterial( { color: 0xD9CDC4 } ) // front
    ];
    var top = new THREE.Mesh( topGeometry,topMaterials);
    top.position.x = 0;
    top.position.y = 0.35;
    top.position.z = 0;
    breakerObj.add(top);

    // 开关
    var switchObj = new THREE.Object3D();
    // OFF
    var offGeometry = new THREE.BoxGeometry(0.25, 0.05 ,0.25);
    var offMaterial = new THREE.MeshLambertMaterial( {color: 0x00a496} );
    var off = new THREE.Mesh( offGeometry, offMaterial );
    off.position.x = 0;
    off.position.y = 0;
    off.position.z = 0.125;
    off.rotation.x = Math.PI/4;
    off.userData.id = "mainswitch_off";
    switchObj.add( off );

    // ON
    var onGeometry = new THREE.BoxGeometry(0.25, 0.05 ,0.25);
    var onMaterial = new THREE.MeshLambertMaterial( {color: 0x97130f} );
    var on = new THREE.Mesh( onGeometry, onMaterial );
    on.position.x = 0;
    on.position.y = 0;
    on.position.z = -0.125;
    on.rotation.x = -Math.PI/4;
    on.userData.id = "mainswitch_on";
    switchObj.add( on );

    // 扳手
    var banGeometry = new THREE.BoxGeometry(0.25, 0.15 ,0.3);
    var banMaterial = new THREE.MeshLambertMaterial( {color: 0x000000} );
    var ban = new THREE.Mesh( banGeometry, banMaterial );
    ban.position.x = 0;
    ban.position.y = 0.25;
    ban.position.z = 0;
    ban.rotation.x = -Math.PI/2;
    ban.userData.id = "mainswitch_ban";
    switchObj.add( ban );

    switchObj.position.x = 0;
    switchObj.position.y = 0.35;
    switchObj.position.z = 0;
    switchObj.userData.status = status;
    switchObj.userData.id = "mainswitch";
    if (status == "off"){
        switchObj.rotation.x = -Math.PI/4;
    }
    else{
        switchObj.rotation.x = Math.PI/4;
    }
    breakerObj.add(switchObj);

    // 下方接线端
    // 左侧
    var portGeometry = new THREE.BoxGeometry(0.3, 0.2, 0.4);
    var portMaterials = [
        new THREE.MeshBasicMaterial( { color: 0xD5CAC0 } ), // right
        new THREE.MeshBasicMaterial( { color: 0xD5CAC0 } ), // left
        new THREE.MeshBasicMaterial( { color: 0xD5CAC0 } ), // top
        new THREE.MeshBasicMaterial( { color: 0xD5CAC0 } ), // bottom
        new THREE.MeshBasicMaterial( { color: 0xD5CAC0 } ), // back
        new THREE.MeshBasicMaterial( { color: 0xD5CAC0 } ) // front
    ];
    var leftPort = new THREE.Mesh( portGeometry,portMaterials);
    leftPort.position.x = 0.56;
    leftPort.position.y = 0.2;
    leftPort.position.z = - 1.2;
    var leftPortBsp = new ThreeBSP(leftPort);
    // 接线孔
    leftPortBsp = addHole(leftPortBsp, [0.25, 0.19, 0.4], [0.55, 0.21, -1.2]);
    leftPort = leftPortBsp.toMesh();
    leftPort.material = portMaterials;
    breakerObj.add(leftPort);
    // 接线孔螺丝
    this.addRose(breakerObj, [0.03, 0.03, 0.1], [0.6, 0.2, - 1.1], 0x8d9295);
    this.addRose(breakerObj, [0.03, 0.03, 0.1], [0.50, 0.2, - 1.1], 0x8d9295);
    this.addRose(breakerObj, [0.03, 0.03, 0.1], [0.6, 0.2, - 1.18], 0x8d9295);
    this.addRose(breakerObj, [0.03, 0.03, 0.1], [0.50, 0.2, - 1.18], 0x8d9295);
    this.addRose(breakerObj, [0.03, 0.03, 0.1], [0.6, 0.2, - 1.26], 0x8d9295);
    this.addRose(breakerObj, [0.03, 0.03, 0.1], [0.50, 0.2, - 1.26], 0x8d9295);
    this.addRose(breakerObj, [0.03, 0.03, 0.1], [0.6, 0.2, - 1.34], 0x8d9295);
    this.addRose(breakerObj, [0.03, 0.03, 0.1], [0.50, 0.2, - 1.34], 0x8d9295);

    var centerPort = new THREE.Mesh( portGeometry,portMaterials);
    centerPort.position.x = 0;
    centerPort.position.y = 0.2;
    centerPort.position.z = - 1.2;
    var centerPortBsp = new ThreeBSP(centerPort);
    // 接线孔
    centerPortBsp = addHole(centerPortBsp, [0.25, 0.19, 0.4], [0, 0.21, -1.2]);
    centerPort = centerPortBsp.toMesh();
    centerPort.material = portMaterials;
    breakerObj.add(centerPort);
    // 接线孔螺丝
    this.addRose(breakerObj, [0.03, 0.03, 0.1], [0.05, 0.2, - 1.1], 0x8d9295);
    this.addRose(breakerObj, [0.03, 0.03, 0.1], [-0.05, 0.2, - 1.1], 0x8d9295);
    this.addRose(breakerObj, [0.03, 0.03, 0.1], [0.05, 0.2, - 1.18], 0x8d9295);
    this.addRose(breakerObj, [0.03, 0.03, 0.1], [-0.05, 0.2, - 1.18], 0x8d9295);
    this.addRose(breakerObj, [0.03, 0.03, 0.1], [0.05, 0.2, - 1.26], 0x8d9295);
    this.addRose(breakerObj, [0.03, 0.03, 0.1], [-0.05, 0.2, - 1.26], 0x8d9295);
    this.addRose(breakerObj, [0.03, 0.03, 0.1], [0.05, 0.2, - 1.34], 0x8d9295);
    this.addRose(breakerObj, [0.03, 0.03, 0.1], [-0.05, 0.2, - 1.34], 0x8d9295);

    var rightPort = new THREE.Mesh( portGeometry,portMaterials);
    rightPort.position.x = -0.56;
    rightPort.position.y = 0.2;
    rightPort.position.z = - 1.2;
    var rightPortBsp = new ThreeBSP(rightPort);
    // 接线孔
    rightPortBsp = addHole(rightPortBsp, [0.25, 0.19, 0.4], [-0.55, 0.21, -1.2]);
    rightPort = rightPortBsp.toMesh();
    rightPort.material = portMaterials;
    breakerObj.add(rightPort);
    // 接线孔螺丝
    this.addRose(breakerObj, [0.03, 0.03, 0.1], [-0.6, 0.2, - 1.1], 0x8d9295);
    this.addRose(breakerObj, [0.03, 0.03, 0.1], [-0.50, 0.2, - 1.1], 0x8d9295);
    this.addRose(breakerObj, [0.03, 0.03, 0.1], [-0.6, 0.2, - 1.18], 0x8d9295);
    this.addRose(breakerObj, [0.03, 0.03, 0.1], [-0.50, 0.2, - 1.18], 0x8d9295);
    this.addRose(breakerObj, [0.03, 0.03, 0.1], [-0.6, 0.2, - 1.26], 0x8d9295);
    this.addRose(breakerObj, [0.03, 0.03, 0.1], [-0.50, 0.2, - 1.26], 0x8d9295);
    this.addRose(breakerObj, [0.03, 0.03, 0.1], [-0.6, 0.2, - 1.34], 0x8d9295);
    this.addRose(breakerObj, [0.03, 0.03, 0.1], [-0.50, 0.2, - 1.34], 0x8d9295);

    breakerObj.name = name;
    breakerObj.position.x = position[0];
    breakerObj.position.y = position[1] + size[1]/2;
    breakerObj.position.z = position[2];
    boxGroup.add(breakerObj);
}

/*
 * 接地模块
 */
loadBox.prototype.addGreenModule = function(size,position,rotation,name){
    var greenObj = new THREE.Object3D();
    // 绿色模块-接地线
    var greenGeometry = new THREE.BoxGeometry(size[0], size[1], size[2]);
    var greenMaterials = [
        new THREE.MeshBasicMaterial( { color: 0x314a28 } ), // right
        new THREE.MeshBasicMaterial( { color: 0x314a28 } ), // left
        new THREE.MeshBasicMaterial( { color: 0x314a28 } ), // top
        new THREE.MeshBasicMaterial( { color: 0x314a28 } ), // bottom
        new THREE.MeshBasicMaterial( { color: 0x314a28 } ), // back
        new THREE.MeshBasicMaterial( { color: 0x314a28 } ) // front
    ];
    var greenModel = new THREE.Mesh( greenGeometry,greenMaterials);
    greenModel.position.x = 0;
    greenModel.position.y = 0;
    greenModel.position.z = 0;
    var greenModelBsp = new ThreeBSP(greenModel);
    // 上部
    greenModelBsp = addHole(greenModelBsp, [0.3, 0.35, 0.5], [0, 0.175, 0.5]);
    greenModelBsp = addCircleHole(greenModelBsp, [0.1, 0.1, 0.2], [0, -0.1, 0.6]);
    this.addRose(greenObj, [0.05, 0.05, 0.1], [0, -0.1, 0.6], 0x8d9295);
    this.addRose(greenObj, [0.07, 0.07, 0.2], [0, 0.175, 0.4], 0x644E37);
    // 中部
    greenModelBsp = addHole(greenModelBsp, [0.27, 0.05, 0.8], [0, 0.325, -0.16]);
    this.addRose(greenObj, [0.03, 0.03, 0.05], [0.05, 0.325, 0.2], 0x8d9295);
    this.addRose(greenObj, [0.03, 0.03, 0.05], [-0.05, 0.325, 0.2], 0x8d9295);
    this.addRose(greenObj, [0.03, 0.03, 0.05], [0.05, 0.325, 0.1], 0x8d9295);
    this.addRose(greenObj, [0.03, 0.03, 0.05], [-0.05, 0.325, 0.1], 0x8d9295);
    this.addRose(greenObj, [0.03, 0.03, 0.05], [0.05, 0.325, 0], 0x8d9295);
    this.addRose(greenObj, [0.03, 0.03, 0.05], [-0.05, 0.325, 0], 0x8d9295);
    this.addRose(greenObj, [0.03, 0.03, 0.05], [0.05, 0.325, -0.1], 0x8d9295);
    this.addRose(greenObj, [0.03, 0.03, 0.05], [-0.05, 0.325, -0.1], 0x8d9295);
    this.addRose(greenObj, [0.03, 0.03, 0.05], [0.05, 0.325, -0.2], 0x8d9295);
    this.addRose(greenObj, [0.03, 0.03, 0.05], [-0.05, 0.325, -0.2], 0x8d9295);
    this.addRose(greenObj, [0.03, 0.03, 0.05], [0.05, 0.325, -0.3], 0x8d9295);
    this.addRose(greenObj, [0.03, 0.03, 0.05], [-0.05, 0.325, -0.3], 0x8d9295);
    this.addRose(greenObj, [0.03, 0.03, 0.05], [0.05, 0.325, -0.4], 0x8d9295);
    this.addRose(greenObj, [0.03, 0.03, 0.05], [-0.05, 0.325, -0.4], 0x8d9295);
    this.addRose(greenObj, [0.03, 0.03, 0.05], [0.05, 0.325, -0.5], 0x8d9295);
    this.addRose(greenObj, [0.03, 0.03, 0.05], [-0.05, 0.325, -0.5], 0x8d9295);
    // 下部
    greenModelBsp = addCircleHole(greenModelBsp, [0.1, 0.1, 0.4], [0, 0.15, -0.6]);
    this.addRose(greenObj, [0.05, 0.05, 0.2], [0, 0.15, -0.6], 0x644E37);

    greenModel = greenModelBsp.toMesh();
    greenModel.material = greenMaterials;
    greenObj.add(greenModel);

    greenObj.name = name;
    greenObj.position.x = position[0];
    greenObj.position.y = position[1] + size[1]/2;
    greenObj.position.z = position[2];
    greenObj.rotation.x = rotation[0];
    greenObj.rotation.y = rotation[1];
    greenObj.rotation.z = rotation[2];
    boxGroup.add(greenObj);
}

/*
 * 长方形洞洞
 */
function addHole(bsp, size, position){
    var holeGeometry = new THREE.BoxGeometry(size[0], size[1], size[2]);
    var holeCube = new THREE.Mesh( holeGeometry);            // 设置墙面位置
    holeCube.position.x = position[0];
    holeCube.position.y = position[1];
    holeCube.position.z = position[2];
    var clipBSP = new ThreeBSP(holeCube);
    var resultBSP = bsp.subtract(clipBSP);
    return resultBSP;
}

/*
 * 圆形洞洞
 */
function addCircleHole(bsp, size, position){
    var holeGeometry = new THREE.CylinderGeometry(size[0], size[1], size[2], 64);
    var holeCube = new THREE.Mesh( holeGeometry);            // 设置墙面位置
    holeCube.position.x = position[0];
    holeCube.position.y = position[1];
    holeCube.position.z = position[2];
    var clipBSP = new ThreeBSP(holeCube);
    var  resultBSP = bsp.subtract(clipBSP);
    return resultBSP;
}

/*
 * 点击事件
 */
function onDocumentMouseDblClick(event) {
    event.preventDefault();
    var vector = new THREE.Vector3();// 三维坐标对象
    vector.set(
        ( event.offsetX / container.clientWidth ) * 2 - 1,
        - ( event.offsetY / container.clientHeight ) * 2 + 1,
        0.5 );
    vector.unproject( camera );
    var raycaster = new THREE.Raycaster(camera.position, vector.sub(camera.position).normalize());
    var intersects = raycaster.intersectObjects((boxGroup instanceof THREE.Object3D)?boxGroup.children:[],true);
    if(intersects.length > 0){
        var object = intersects[0].object;
        if (object.userData.id == "meterScreen" || object.userData.id == "terminalScreen"){
            camera.position.y = 4;
            camera.position.z = object.parent.position.z - 1;
            camera.position.x = object.parent.position.x;
            controls.target = new THREE.Vector3(object.parent.position.x,1,object.parent.position.z);           // 设置orbit交互的中心点
        }
        else if(object.userData.id == "door" || object.userData.id == "doorfront" || object.userData.id == "doorback"){
            var leftDoorObj = boxGroup.getObjectByName("leftdoor");
            var rightDoorObj = boxGroup.getObjectByName("rightdoor");
            controlDoor(leftDoorObj);
            controlDoor(rightDoorObj);
            var status = leftDoorObj.userData.status;
            var elock = boxGroup.getObjectByName("elock");
            if (elock){
            	elock.visible = status == 'open' ? false : true;
            }
        }
        /*else if (object.userData.id == "meterScreen"){
            camera.position.y = 4;
            camera.position.z = object.parent.position.z - 2;
            camera.position.x = object.parent.position.x;
            controls.target = new THREE.Vector3(object.parent.position.x,1,object.parent.position.z);           // 设置orbit交互的中心点
        }
        else if (object.userData.id == "conswitch_h" || object.userData.id == "conswitch_l"
            || object.userData.id == "conswitch_r"){
            controlBreaker(object);
        }
        else if (object.userData.id == "mainswitch_on" || object.userData.id == "mainswitch_off"
            || object.userData.id == "mainswitch_ban"){
            controlMainBreaker(object.parent);
        }
        else if (object.userData.id == "meterswitch_h" || object.userData.id == "meterswitch_l"
            || object.userData.id == "meterswitch_r"){
            controlBreaker(object.parent);
        }*/
        else if (object.userData.id == "meterplastic"){
            controlPlastic(object);
        }
        else if (object.userData.id == "meterswitch_h" || object.userData.id == "meterswitch_l"
            || object.userData.id == "meterswitch_r"){
            //controlBreaker(object.parent);
            if(object.parent.userData.status == "on"){
            	controlBreaker(object.parent, "on");
            	$.ajax({
        		 	type:'POST', 
        	     	url:basePath + '/mbAmmeter/switchAmmeter?Math.random()',           
        	     	data:{"id": object.parent.parent.userData.ammeterCode,funFlag:129},//129-跳闸 130- 合闸
        	        success:function(data){
        	        	if (window.parent.ws){
        	        		window.parent.ws.onaction(data);
        	        	}
        	        },	        
        	        error:function(data){
        	        }
        	    });
            }
            else{
            	controlBreaker(object.parent, "off");
            	$.ajax({
        		 	type:'POST', 
        	     	url:basePath + '/mbAmmeter/switchAmmeter?Math.random()',           
        	     	data:{"id": object.parent.parent.userData.ammeterCode,funFlag:130},//129-跳闸 130- 合闸
        	        success:function(data){
        	        	if (window.parent.ws){
        	        		window.parent.ws.onaction(data);
        	        	}
        	        },	        
        	        error:function(data){
        	        	 //alert(data);
        	        }
        	    });
            }
        }
    }else{

    }
}

// 文字变更
function changeText(obj, text){
    var materials = obj.material;
    // top纹理
    materials[2] = new THREE.MeshBasicMaterial( { map: new THREE.CanvasTexture(getMeterTextCanvas(text)) } );
}

// 总开关拉合闸
function controlMainBreaker(mainswitch){
    var status = mainswitch.parent.userData.status;
    if(status == "off"){
        mainswitch.parent.userData.status = "on";
        var desRotation;
        new TWEEN.Tween(mainswitch.rotation).to({
            x: Math.PI/4
        }, 500).onComplete(function(){
        }).start();
    }else{
        mainswitch.parent.userData.status = "off";
        new TWEEN.Tween(mainswitch.rotation).to({
            x: -Math.PI/4
        }, 500).onComplete(function(){
        }).start();
    }
}

// 开表壳
function controlPlastic(plastic){
    var plasticObj = plastic.parent;
    var status = plasticObj.userData.status;
    if(status == "close"){
        plasticObj.userData.status = "open";
        var desRotation;
        new TWEEN.Tween(plasticObj.rotation).to({
            x: 2 * Math.PI/3
        }, 500).onComplete(function(){
        }).start();
    }else{
        plasticObj.userData.status = "close";
        new TWEEN.Tween(plasticObj.rotation).to({
            x: 0
        }, 500).onComplete(function(){
        }).start();
    }
}

// 拉合闸
function controlBreaker(breakerObj, status){
    if(status == "off"){
        breakerObj.userData.status = "on";
        var desRotation;
        new TWEEN.Tween(breakerObj.rotation).to({
            x: Math.PI/4
        }, 500).onComplete(function(){
        }).start();
    }else{
        breakerObj.userData.status = "off";
        new TWEEN.Tween(breakerObj.rotation).to({
            x: -Math.PI/4
        }, 500).onComplete(function(){
        }).start();
    }
}

// 开关门动画
function controlDoor(doorObj){
    var status = doorObj.userData.status;
    var leftDoor = (doorObj.name == "leftdoor"?true:false);
    if(status == "close"){
        doorObj.userData.status = "open";
        var desRotation;
        if(leftDoor){
            desRotation = -Math.PI/2 - 1;
        }else{
            desRotation = Math.PI/2 + 1;
        }
        new TWEEN.Tween(doorObj.rotation).to({
            z: desRotation
        }, 1000).onComplete(function(){
        }).start();
    }else{
        doorObj.userData.status = "close";
        new TWEEN.Tween(doorObj.rotation).to({
            z: 0
        }, 1000).onComplete(function(){
        }).start();
    }
}

// 清除表箱
loadBox.prototype.clear = function(){
    scene.remove(boxGroup);
    boxGroup = new THREE.Object3D();
	scene.add(boxGroup);
}

var fireArray = [];		// 模拟火情的数组
/*
 * 新增模拟火情 @param {Array} position 火情的位置 [x,y,z]
 */
loadBox.prototype.addFire = function(position){
    var fire = new FirePoints(position);// 使用{FirePoints}创建火情
    fire.init();
    boxGroup.add(fire.obj);
    fireArray.push(fire);
}

// 移除全部火焰
loadBox.prototype.removeAllFire = function(){
    for(var i=0;i<fireArray.length;i++){
        var fire = fireArray[i];
        boxGroup.remove(fire.obj);
    }
    fireArray = [];
}

// 更新火焰
function updateFires(){
    var now = Date.now();
    for(var i=0;i<fireArray.length;i++){
        var fire = fireArray[i];
        if(fire.obj.visible){
            fire.update();
            if(!fire.last_time_activate) fire.last_time_activate = Date.now();
            if (now - fire.last_time_activate > 20) {
                fire.activateMover();
                fire.last_time_activate = Date.now();
            }
        }
    }
}

// 模拟火情的一些常量
var FireUtil = {
    getRandomInt: function(min, max) {
        return Math.floor(Math.random() * (max - min)) + min;
    },
    getDegree: function(radian) {
        return radian / Math.PI * 180;
    },
    getRadian: function(degrees) {
        return degrees * Math.PI / 180;
    },
    getSpherical: function(rad1, rad2, r) {
        var x = Math.cos(rad1) * Math.cos(rad2) * r;
        var z = Math.cos(rad1) * Math.sin(rad2) * r;
        var y = Math.sin(rad1) * r;
        return new THREE.Vector3(x, y, z);
    }
}

/*
 * 创建模拟火情的精灵点 @param {THREE.Material} material 材质
 */
var FireGrain = function(material) {
    this.position = new THREE.Vector3();
    this.velocity = new THREE.Vector3();
    this.acceleration = new THREE.Vector3();
    this.material = material;
    this.sprite = new THREE.Sprite(this.material);
    this.sprite.scale.set(1,1,0);
    this.mass = 2;
    this.is_active = false;
};

FireGrain.prototype = {
    init: function(vector) {
        this.position = vector.clone();
        this.velocity = vector.clone();
        this.acceleration.set(0, 0, 0);
        this.sprite.position.copy(this.position);
    },
    updatePosition: function() {
        this.position.copy(this.velocity);
        this.sprite.position.copy(this.position);
    },
    updateVelocity: function() {
        this.acceleration.divideScalar(this.mass);
        this.velocity.add(this.acceleration);
    },
    applyForce: function(vector) {
        this.acceleration.add(vector);
    },
    activate: function() {
        this.is_active = true;
    },
    inactivate: function() {
        this.is_active = false;
    }
};

/*
 * 根据三维坐标点创建模拟火情 @param {Array} position 坐标数组
 */
var FirePoints = function(position) {
    this.fireItem_num = 60;
    this.grains = [];
    this.geometry = null;
    this.material = null;
    this.obj = null;
    this.texture = null;
    this.antigravity = new THREE.Vector3(0, 0.05, 0);
    this.position = new THREE.Vector3(position[0], position[1]+1, position[2]);
};

FirePoints.prototype = {
    init: function() {
        this.createTexture();
        this.geometry = new THREE.Geometry();
        this.material = new THREE.SpriteMaterial({
            color: 0xccc8b9,
            transparent: true,
            map: this.texture,
            depthTest: false,
            blending: THREE.NormalBlending, 			// THREE.AdditiveBlending,
        });
        /*
		 * this.material = new THREE.PointsMaterial({ //另一种方法 size: 8,
		 * color: 0xff6633, transparent: true, map: this.texture, depthTest:
		 * false, blending: THREE.AdditiveBlending });
		 */

        // glBlendFunc(GL_ONE, GL_ZERO);

        this.obj = new THREE.Object3D();
        for (var i = 0; i < this.fireItem_num; i++) {
            var grain =  new FireGrain(this.material);
            grain.init(this.position);
            this.grains.push(grain);
            this.obj.add(grain.sprite);

            /*
			 * var grain = new FireGrain(this.material); //火的颗粒
			 * grain.init(this.position); this.grains.push(grain);
			 * this.geometry.vertices.push(grain.position);
			 */
        }
        // this.obj = new THREE.Points(this.geometry, this.material);
        // this.obj.renderOrder = 2;
    },
    update: function() {
        var points_vertices = [];
        for (var i = 0; i < this.grains.length; i++){
            var grain = this.grains[i];
            if (grain.is_active){
                grain.applyForce(this.antigravity);
                grain.updateVelocity();
                grain.updatePosition();
                if (grain.position.y > this.position.y + 1) {
                    grain.inactivate();			// 不激活
                }
            }
            points_vertices.push(grain.position);
        }
        // this.obj.geometry.vertices = points_vertices;
        // this.obj.geometry.verticesNeedUpdate = true;
    },
    updatePosition:function(position){
        this.position = new THREE.Vector3(position[0], position[1]+2, position[2]);
    },
    activateMover: function() {
        var count = 0;
        for (var i = 0; i < this.grains.length; i++){
            var grain = this.grains[i];
            if (grain.is_active) continue;
            var rad1 = FireUtil.getRadian(Math.log(FireUtil.getRandomInt(200, 256)) / Math.log(256) * 270);
            var rad2 = FireUtil.getRadian(FireUtil.getRandomInt(0, 360));
            var force = FireUtil.getSpherical(rad1, rad2, 5);
            force.y = 0.05;
            force.x = force.x/2;		// x增量和z增量
            force.z = force.z/2;
            grain.activate();					// 激活
            grain.init(this.position);
            grain.applyForce(force);
            count++;
            if (count >= 6) break;
        }
    },
    createTexture: function() {
        var canvas = document.createElement('canvas');
        var ctx = canvas.getContext('2d');
        var grad = null;
        canvas.width = 200;
        canvas.height = 200;
        grad = ctx.createRadialGradient(100, 100, 20, 100, 100, 100);
        grad.addColorStop(0.2, 'rgba(255, 255, 255, 1)');
        grad.addColorStop(0.5, 'rgba(255, 255, 255, 0.3)');
        grad.addColorStop(1.0, 'rgba(255, 255, 255, 0)');
        ctx.fillStyle = grad;
        ctx.arc(100, 100, 100, 0, Math.PI / 180, true);
        ctx.fill();
        this.texture = new THREE.Texture(canvas);
        this.texture.minFilter = THREE.NearestFilter;
        this.texture.needsUpdate = true;
    }
};

function render() {
    controls.update();
    TWEEN.update();
    requestAnimationFrame(render);
    updateFires();					// 更新火情动画
    renderer.render(scene, camera);
}