
//事件类型名称和单位数组;type:事件类型代码
function getEventName(type){
	var myEvent=new Array();
	//var eventName="";
	if(type>=1 && type<=6) {myEvent[0]="电压";myEvent[1]="V";}
	else if(type>=7 && type<=9) {myEvent[0]="电流";myEvent[1]="A";}
	else if(type>=10 && type<=12) {myEvent[0]="功率";myEvent[1]="KW";}
	else if(type>=13 && type<=15) {myEvent[0]="功率因素";myEvent[1]="";}
	else if(type==16) {myEvent[0]="停电";myEvent[1]="";}
	else if(type==17 || type==18 || type==72 || type==81 || type==91 
			|| type==101 || type==111 || type==122 || type==131 || type==141) {myEvent[0]="电压值";myEvent[1]="V";}
	else if(type==19) {myEvent[0]="控制继电器开";myEvent[1]="";}
	else if(type==20) {myEvent[0]="控制继电器合";myEvent[1]="";}
	else if(type==21) {myEvent[0]="报警继电器开";myEvent[1]="";}
	else if(type==22) {myEvent[0]="报警继电器合";myEvent[1]="";}
	else if(type==23) {myEvent[0]="遥信1变位告警";myEvent[1]="";}
	else if(type==24) {myEvent[0]="遥信2变位告警";myEvent[1]="";}
	else if(type>=50 && type<=53) {myEvent[0]="温度";myEvent[1]="℃";}
	else if(type==54) {myEvent[0]="温升";myEvent[1]="";}
	else if(type>=55 && type<=57) {myEvent[0]="温度";myEvent[1]="℃";}
	else if(type==60) {myEvent[0]="剩余电流";myEvent[1]="A";}
	else if(type==70 || type==71) {myEvent[0]="水压值";myEvent[1]="MPa";}
	else if(type==73) {myEvent[0]="";myEvent[1]="MPa";myEvent[2]="V"}
	else if(type==80) {myEvent[0]="烟感浓度";myEvent[1]="%";}
	else if(type==82) {myEvent[0]="";myEvent[1]="%";myEvent[2]="V"}
	else if(type==83) {myEvent[0]="";myEvent[1]="";myEvent[2]="";myEvent[3]="";}
	else if(type==84) {myEvent[0]="";myEvent[1]="";myEvent[2]="";myEvent[3]="";myEvent[4]="V";}
	else if(type==90) {myEvent[0]="燃气浓度";myEvent[1]="%";}
	else if(type==92) {myEvent[0]="";myEvent[1]="%";myEvent[2]="V";}
	else if(type==100) {myEvent[0]="报警按钮";myEvent[1]="";}
	else if(type==102) {myEvent[0]="电池电压";myEvent[1]="V";}
	else if(type==110) {myEvent[0]="报警状态";myEvent[1]="";}
	else if(type==112 || type==132 || type==142) {myEvent[0]="";myEvent[1]="";myEvent[2]="V";}
	else if(type==120 || type==121 ) {myEvent[0]="水位高度";myEvent[1]="m";}
	else if(type==123 ) {myEvent[0]="";myEvent[1]="水位高度";myEvent[1]="m";myEvent[2]="V";}
	else if(type==130) {myEvent[0]="消防栓按钮报警";myEvent[1]="";}
	else if(type==140) {myEvent[0]="消防门启动";myEvent[1]="";}
	else if(type==254) {myEvent[0]="消音命令";myEvent[1]="";}
	else if(type==150) {myEvent[0]="温度";myEvent[1]="℃";}
	else if(type==151) {myEvent[0]="电流";myEvent[1]="A";}
	return myEvent;
}

//相数名称;Inumber:数据项序号排序（按规约顺序排序），earlyType:事件类型代码
function getNumberName(Inumber,earlyType){
	var numberName="";
	if((earlyType>=1 && earlyType<=15) || (earlyType>=19 && earlyType<=53) || earlyType==58 || earlyType==59){
		if(Inumber==1) numberName="A相";
		else if(Inumber==2) numberName="B相";
		else if(Inumber==3) numberName="C相";
		else if(Inumber==4) numberName="N相";
		else if(Inumber==5) numberName="环境";
	}else if(earlyType>=55 && earlyType<=57){
		numberName="温度超报警" + Inumber;
	}else if(earlyType==73){
		if(Inumber==1) numberName="水压值";
		else if(Inumber==2) numberName="电池电压值";
	}else if(earlyType==82){
		if(Inumber==1) numberName="烟感浓度值";
		else if(Inumber==2) numberName="电池电压值";
	}else if(earlyType==83){
		if(Inumber==1) numberName="烟感状态字";
		else if(Inumber==2) numberName="白烟值";
		else if(Inumber==3) numberName="黑烟值";
	}else if(earlyType==84){
		if(Inumber==1) numberName="烟感状态字";
		else if(Inumber==2) numberName="白烟值";
		else if(Inumber==3) numberName="黑烟值";
		else if(Inumber==4) numberName="电池电压值";
	}else if(earlyType==92){
		if(Inumber==1) numberName="燃气浓度";
		else if(Inumber==2) numberName="电压值";
	}else if(earlyType==112 || earlyType==132 || earlyType==142){
		if(Inumber==1) numberName="报警状态";
		else if(Inumber==2) numberName="电池电压";
	}else if(earlyType==123){
		if(Inumber==1) numberName="水位高度";
		else if(Inumber==2) numberName="电池电压";
	}else if(earlyType==150 || earlyType==151){
		if(Inumber==1) numberName="A相";
		else if(Inumber==2) numberName="B相";
		else if(Inumber==3) numberName="C相";
		else if(Inumber==4) numberName="N相";
		else if(Inumber==5) numberName="环境";
	}else if (earlyType==530){
		if(Inumber==1) numberName="控制柜编号";
	}else if (earlyType==540 || earlyType==541){
		if(Inumber==1) numberName="控制柜编号";
		else if(Inumber==2) numberName="部件类型";
		else if(Inumber==3) numberName="部件地址";
	}
	
	return numberName;
}

//黑白烟感状态字
var statusWord = ["正常","测试按钮","迷宫污染","电池低压","白烟报警","黑烟报警","预警","消音"];

//状态解析;earlyType:事件类型代码，Inumber:数据项序号排序（按规约顺序排序），eventdata:数据项内容，eventArray:( getEventName(type) )事件类型名称和单位数组
function getEventData(earlyType,Inumber,eventdata,eventArray){
	var mEventData="";//数据值和单位
	
	if(typeof eventdata=="undefined" || null==eventdata || eventdata=="" || eventdata=="无数据")
		return "无数据";
	
	if((earlyType==23 || earlyType==24) && Inumber==1){
		if(eventdata=="00")mEventData="合";
		else if(eventdata=="01")mEventData="开";
		else mEventData=eventdata;
	}else if((earlyType==110 ||earlyType==112) && Inumber==1) { //声光报警器测试状态的值
		if(eventdata=="00") mEventData="无远程报警,市电供电,无本地报警";
		else if(eventdata=="01")mEventData="远程报警,市电供电,无本地报警";
		else if(eventdata=="02")mEventData="无远程报警,电池供电,无本地报警";
		else if(eventdata=="03")mEventData="远程报警,电池供电,无本地报警";
		else if(eventdata=="04")mEventData="无远程报警,市电供电,本地报警";
		else if(eventdata=="05")mEventData="远程报警,市电供电,本地报警";
		else if(eventdata=="06")mEventData="无远程报警,电池供电,本地报警";
		else if(eventdata=="07")mEventData="远程报警,电池供电,本地报警";
		else mEventData=eventdata;
	}else if(earlyType==132 && Inumber==1){
		if(eventdata=="00")mEventData="已打开";
		else if(eventdata=="01")mEventData="已关闭";
		else mEventData=eventdata;
	}else if(earlyType==142 && Inumber==1){
		if(eventdata=="00") mEventData="已关闭,市电供电";
		else if(eventdata=="01")mEventData="已关闭,电池供电";
		else if(eventdata=="02")mEventData="已打开,市电供电";
		else if(eventdata=="03")mEventData="已打开,市电供电";
		else mEventData=eventdata;
	}else{
		if(earlyType==92 && Inumber==2){//屏蔽燃气告警-电池电压
			mEventData = "";
		}
		else if((earlyType==83 || earlyType==84) && Inumber==1){//屏蔽黑白烟感-烟感状态字
			mEventData = "";
			var word = parseInt(eventdata,16).toString(2);
			while(word.length<8){ word = '0'+  word; }
			for(var i=0;i<word.length;i++){
				if(word[i]=='1'){
					mEventData += statusWord[i]+",";
				}
			}
			if(mEventData!="") mEventData = mEventData.substring(0, mEventData.lastIndexOf(','));
		}else
			mEventData=parseFloat(eventdata)+eventArray[Inumber]; 
	} 
	return mEventData;
}

//值格式化
function FormatValue(value){
	if(typeof value=="undefined" || null==value)
		return "无数据";
	else
		return value;
}