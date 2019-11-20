var stencilRealOption = {
	tooltip : {
        trigger: 'axis',
        axisPointer : { // 坐标轴指示器，坐标轴触发有效
			type : 'shadow' // 默认为直线，可选为：'line' | 'shadow' 
		},
		formatter: function (params) {
	        var relVal = params[0].value[0];
	        for (var i = 0, l = params.length; i < l; i++) {
	            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
	            relVal += params[i].seriesName + ' : ' + params[i].value[1] ;
	        }
	        return relVal;
	    },
        position: function (point, params, dom, rect, size) {
            // 固定在顶部
            return [point[0] < (size.viewSize[0] / 2) ? point[0] : point[0] - 150, '20%'];
        }
    },
	calculable : false,
	grid : { show:'true', borderWidth:'0', left : 50, right : 60, top : 60, bottom : 65 },
	xAxis: {
        type: 'time',
        minInterval: 15 * 1000,//15秒
        maxInterval: 3600 * 2 * 1000,//2小时
        axisLabel: {
        	// 使用函数模板，函数参数分别为刻度数值（类目），刻度的索引
        	formatter: function (value, index) {
        	    // 格式化成月/日，只在第一个刻度显示年份
        	    var date = new Date(value);
        	    var ss=Format(date,"yy-MM-dd HH:mm:ss").split(' ');
        	    return ss[0]+"\n"+ss[1];
        	}
        }
    },
    dataZoom : {    //放大缩小轴
        y:225,
        show : true,
        realtime: true,
        height:25
    },
	toolbox: {    //工具栏显示             
        show: true,
        feature: { 
        	dataZoom : {
                show : true,  //legendshow
                title : {
                    dataZoom : '区域缩放',
                    dataZoomReset : '区域缩放后退'
                },
                yAxisIndex : false
            },
            dataView : {
                show : true,   //legendshow
                title : '数据视图',
                readOnly: true,
                lang: [],
                optionToContent:function(opt) {
                	return dataviewformate(opt);
                }
            },
            restore : { show : true, title : '还原' } 
        },
        right:20
    },
    legend : {
		x : 'center',
		data : []
	},
    yAxis : [ ],
    series: []
};

function makeRealCurveSingle(array){
	var ectricitylegendp = [ "正总电量" ];
	var ectricitylegendr = [ "反总电量" ];
	var voltagelegend = [ "A相电压"];
	var cueeentlegend = [ "A相电流", "剩余电流" ];
	var powerlegend = [ "A相功率"];
	var pflegend = [ "A相功率因数"];
	var temperaturelegend = [ "A相温度", "N相温度"];
	var otherlegend = [ "频率" ];

	var option4=deepClone(stencilRealOption);
	option4.toolbox.feature.dataView.lang = ['电流', '关闭'];
	option4.legend.data = cueeentlegend;
	option4.yAxis = [ {
		type : 'value',
		name : '电流 (A)',
		scale: true,
		splitLine: {show: false}
	} ];
	option4.series= [{
			name : 'A相电流',
			type : 'line',
			connectNulls : false,
			progressiveThreshold : 100,
			data : cueeenta,
            markLine : {}
		},
		{
			name : '剩余电流',
			type : 'line',
			connectNulls : false,
			progressiveThreshold : 100,
			data : residualcueeent,
			lineStyle : {
				color : '#735b52'
			},
			itemStyle : {
                normal: {
                	color : '#735b52'
                }
            },
            markLine : {}
		}, 
        {
            name:'',
            type:'line', 
            showSymbol:false, 
            data:anchor,
            itemStyle:{normal:{opacity:0}},
            lineStyle:{normal:{opacity:0}}
        }];
	if(typeof array[2]!='undefined'){
		option4.series[0].markLine = {
            data : [ { name: '过流', yAxis: array[2] } ]
        };
	}
	if(typeof array[6]!='undefined'){
		option4.series[1].markLine = {
                data : [ { name: '剩余电流超限', yAxis: array[6] } ]
        }
	}
	myChart4.setOption(option4);
	option4={};

	var option7=deepClone(stencilRealOption);
	option7.toolbox.feature.dataView.lang = ['温度', '关闭'];
	option7.legend.data = temperaturelegend;
	option7.yAxis = [ {
		type : 'value',
		name : '温度 (°C)',
		scale: true,
		splitLine: {show: false}
	} ];
	option7.series= [{
			name : 'A相温度',
			type : 'line',
			connectNulls : false,
			progressiveThreshold : 100,
			data : temperaturea,
            markLine : {}
		},
		{
			name : 'N相温度',
			type : 'line',
			connectNulls : false,
			progressiveThreshold : 100,
			data : temperaturen
		}, 
        {
            name:'',
            type:'line', 
            showSymbol:false, 
            data:anchor,
            itemStyle:{normal:{opacity:0}},
            lineStyle:{normal:{opacity:0}}
        }];
	if(typeof array[5]!='undefined'){
		var lowvalue= array[5].split(",");
		option7.series[0].markLine = {
            data : [ { name: '过温1', yAxis: lowvalue[0] } ]
        };
		if(lowvalue[1]!=0)
			option7.series[0].markLine.data.push({ name: '过温2', yAxis: lowvalue[1] });
		if(lowvalue[2]!=0)
			option7.series[0].markLine.data.push({ name: '过温3', yAxis: lowvalue[2] });
	}
	myChart7.setOption(option7);
	option7={};

	var option3=deepClone(stencilRealOption);
	option3.toolbox.feature.dataView.lang = ['电压', '关闭'];
	option3.legend.data = voltagelegend;
	option3.yAxis = [ {
		type : 'value',
		name : '电压 (V)',
		scale: true,
		splitLine: {show: false}
	}];
	option3.series= [{
			name : 'A相电压',
			type : 'line',
			connectNulls : false,
			progressiveThreshold : 100,
			data : voltagea,
            markLine : {}
		}, 
        {
            name:'',
            type:'line', 
            showSymbol:false, 
            data:anchor,
            itemStyle:{normal:{opacity:0}},
            lineStyle:{normal:{opacity:0}}
        }];
	var voltageData=[];
	if(typeof array[0]!='undefined'){
		voltageData.push({ name: '过压', yAxis: array[0] });
	}
	if(voltageData!=[]){
		option3.series[0].markLine = { data : voltageData };
	}
	myChart3.setOption(option3);
	option3={};
	
	var option6=deepClone(stencilRealOption);
	option6.toolbox.feature.dataView.lang = ['功率因数', '关闭'];
	option6.legend.data = pflegend;
	option6.yAxis =  [ {
		type : 'value',
		name : '功率因数',
		scale: true,
		splitLine: {show: false}
	}];
	option6.series= [
		{
			name : 'A相功率因数',
			type : 'line',
			connectNulls : false,
			progressiveThreshold : 100,
			data : pfa,
            markLine : {}
		},
        {
            name:'',
            type:'line', 
            showSymbol:false, 
            data:anchor,
            itemStyle:{normal:{opacity:0}},
            lineStyle:{normal:{opacity:0}}
        }];
	if(typeof array[4]!='undefined'){
		option6.series[0].markLine = {
            data : [ { name: '功率因数超限', yAxis: array[4] } ]
        };
	}
	myChart6.setOption(option6);
	option6={};

	var option5=deepClone(stencilRealOption);
	option5.toolbox.feature.dataView.lang = ['功率', '关闭'];
	option5.legend.data = powerlegend;
	option5.yAxis =  [ {
		type : 'value',
		name : '功率 (kW)',
		scale: true,
		splitLine: {show: false}
	}];
	option5.series= [
		{
			name : 'A相功率',
			type : 'line',
			connectNulls : false,
			progressiveThreshold : 100,
			data : powera,
            markLine : {}
		},
        {
            name:'',
            type:'line', 
            showSymbol:false, 
            data:anchor,
            itemStyle:{normal:{opacity:0}},
            lineStyle:{normal:{opacity:0}}
        }];
	if(typeof array[3]!='undefined'){
		option5.series[0].markLine = {
            data : [ { name: '功率过载', yAxis: array[3] } ]
        };
	}
	myChart5.setOption(option5);
	option5={};

	var option=deepClone(stencilRealOption);
	option.toolbox.feature.dataView.lang = ['正向电量', '关闭'];
	option.legend.data = ectricitylegendp;
	option.yAxis = [{
			type : 'value',
			name : '总电量 (kWh)',
			scale: true,
			splitLine: {show: false}
		} ];
	option.series= [
		{
			name : '正总电量',
			type : 'line',
			connectNulls : false,
			progressiveThreshold : 100,
			data : positiveelectricity
		},
        {
            name:'',
            type:'line', 
            showSymbol:false, 
            data:anchor,
            itemStyle:{normal:{opacity:0}},
            lineStyle:{normal:{opacity:0}}
        }];
	myChart.setOption(option);
	option={};
	
	var option2=deepClone(stencilRealOption);
	option2.toolbox.feature.dataView.lang = ['反向电量', '关闭'];
	option2.legend.data = ectricitylegendr;
	option2.yAxis = [ {
			type : 'value',
			name : '总电量 (kWh)',
			scale: true,
			splitLine: {show: false}
		} ];
	option2.series= [ 
		{
			name : '反总电量',
			type : 'line',
			connectNulls : false,
			progressiveThreshold : 100,
			data : reverseelectricity
		},
        {
            name:'',
            type:'line', 
            showSymbol:false, 
            data:anchor,
            itemStyle:{normal:{opacity:0}},
            lineStyle:{normal:{opacity:0}}
        }];
	myChart2.setOption(option2);
	option2={};

	var option8=deepClone(stencilRealOption);
	option8.toolbox.feature.dataView.lang = ['频率', '关闭'];
	option8.legend.data = otherlegend;
	option8.yAxis =  [ {
		type : 'value',
		name : '频率 (Hz)',
		scale: true,
		splitLine: {show: false}
	} ];
	option8.series= [{
			name : '频率',
			type : 'line',
			connectNulls : false,
			progressiveThreshold : 100,
			data : frequency
		}, 
        {
            name:'',
            type:'line', 
            showSymbol:false, 
            data:anchor,
            itemStyle:{normal:{opacity:0}},
            lineStyle:{normal:{opacity:0}}
        }];
	myChart8.setOption(option8);
	option8={};
	
	echarts.connect([ myChart4, myChart7, myChart3, myChart6, myChart5, myChart, myChart2, myChart8 ]);
} 
function makeRealCurveThree(array){
	if(wsresidualcueeenta.length>0){
		var option4=deepClone(stencilRealOption);
		option4.toolbox.feature.dataView.lang = ['电流', '关闭'];
		option4.legend.data = [ "A相电流","B相电流","C相电流" ];
		option4.yAxis = [ {
			type : 'value',
			name : '电流 (A)',
			scale: true,
			splitLine: {show: false}
		} ];
		option4.series= [{
				name : 'A相电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : wsresidualcueeenta,
	            markLine : {}
			}, 
			{
				name : 'B相电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : wsresidualcueeentb,
	            markLine : {}
			}, 
			{
				name : 'C相电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : wsresidualcueeentc,
	            markLine : {}
			},
	        {
	            name:'',
	            type:'line', 
	            showSymbol:false, 
	            data:anchor,
	            itemStyle:{normal:{opacity:0}},
	            lineStyle:{normal:{opacity:0}}
	        }];
		if(typeof array[2]!='undefined'){
			option4.series[0].markLine = {
	            data : [ { name: '过流', yAxis: array[2] } ]
	        };
		}
		if(typeof array[6]!='undefined'){
			option4.series[3].markLine = {
	                data : [ { name: '超限', yAxis: array[6] } ]
	        }
		}
		myChart4.setOption(option4);
		option4={};
	}

	if(wsambienttemperature.length>0){
		var option7=deepClone(stencilRealOption);
		option7.toolbox.feature.dataView.lang = ['温度', '关闭'];
		option7.legend.data = [ "温度"];
		option7.yAxis = [ {
			type : 'value',
			name : '温度 (°C)',
			scale: true,
			splitLine: {show: false}
		} ];
		option7.series= [{
				name : '温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : wsambienttemperature,
	            markLine : {}
			},
	        {
	            name:'',
	            type:'line', 
	            showSymbol:false, 
	            data:anchor,
	            itemStyle:{normal:{opacity:0}},
	            lineStyle:{normal:{opacity:0}}
	        }];
		if(typeof array[5]!='undefined'){
			var lowvalue= array[5].split(",");
			option7.series[0].markLine = {
	            data : [ { name: '过温1', yAxis: lowvalue[0] } ]
	        };
			if(lowvalue[1]!=0)
				option7.series[0].markLine.data.push({ name: '过温2', yAxis: lowvalue[1] });
			if(lowvalue[2]!=0)
				option7.series[0].markLine.data.push({ name: '过温3', yAxis: lowvalue[2] });
		}
		myChart7.setOption(option7);
		option7={};
	}

	if(wsvoltagea.length>0){
		var option3=deepClone(stencilRealOption);
		option3.toolbox.feature.dataView.lang = ['电压', '关闭'];
		option3.legend.data = [ "A相电压","B相电压","C相电压" ];
		option3.yAxis = [ {
			type : 'value',
			name : '电压 (V)',
			scale: true,
			splitLine: {show: false}
		}];
		option3.series= [{
				name : 'A相电压',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : wsvoltagea,
	            markLine : {}
			},
			{
				name : 'B相电压',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : wsvoltageb,
	            markLine : {}
			},
			{
				name : 'C相电压',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : wsvoltagec,
	            markLine : {}
			},
	        {
	            name:'',
	            type:'line', 
	            showSymbol:false, 
	            data:anchor,
	            itemStyle:{normal:{opacity:0}},
	            lineStyle:{normal:{opacity:0}}
	        }];
		var voltageData=[];
		if(typeof array[0]!='undefined'){
			voltageData.push({ name: '过压', yAxis: array[0] });
		}
		if(typeof array[1]!='undefined'){
			voltageData.push({ name: '欠压', yAxis: array[1] });
		}
		if(voltageData!=[]){
			option3.series[0].markLine = { data : voltageData };
		}
		myChart3.setOption(option3);
		option3={};
	}

	if(wspower.length>0){
		var option5=deepClone(stencilRealOption);
		option5.toolbox.feature.dataView.lang = ['功率', '关闭'];
		option5.legend.data = [ "功率","A相功率","B相功率","C相功率" ];
		option5.yAxis =  [ {
			type : 'value',
			name : '功率 (W)',
			scale: true,
			splitLine: {show: false}
		}];
		option5.series= [
			{
				name : '功率',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : wspower,
	            markLine : {}
			},
			{
				name : 'A相功率',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : wspowera,
	            markLine : {}
			},
			{
				name : 'B相功率',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : wspowerb,
	            markLine : {}
			},
			{
				name : 'C相功率',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : wspowerc,
	            markLine : {}
			},
	        {
	            name:'',
	            type:'line', 
	            showSymbol:false, 
	            data:anchor,
	            itemStyle:{normal:{opacity:0}},
	            lineStyle:{normal:{opacity:0}}
	        }];
		if(typeof array[3]!='undefined'){
			option5.series[0].markLine = {
	            data : [ { name: '过载', yAxis: array[3] } ]
	        };
		}
		myChart5.setOption(option5);
		option5={};
	}

	if(wspositiveelectricity.length>0){
		var option=deepClone(stencilRealOption);
		option.toolbox.feature.dataView.lang = ['正向电量', '关闭'];
		option.legend.data = [ "正相电量" ];
		option.yAxis = [ {
				type : 'value',
				name : '电量 (kWh)',
				scale: true,
				splitLine: {show: false}
			} ];
		option.series= [
			{
				name : '正相电量',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : wspositiveelectricity
			},
	        {
	            name:'',
	            type:'line', 
	            showSymbol:false, 
	            data:anchor,
	            itemStyle:{normal:{opacity:0}},
	            lineStyle:{normal:{opacity:0}}
	        }];
		myChart.setOption(option);
		option={};
	}

	if(wsreverseelectricity.length>0){
		var option2=deepClone(stencilRealOption);
		option2.toolbox.feature.dataView.lang = ['反向电量', '关闭'];
		option2.legend.data = [ "反相电量" ];
		option2.yAxis = [ {
				type : 'value',
				name : '电量 (kWh)',
				scale: true,
				splitLine: {show: false}
			}];
		option2.series= [
			{
				name : '反相电量',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : wsreverseelectricity
			},
	        {
	            name:'',
	            type:'line', 
	            showSymbol:false, 
	            data:anchor,
	            itemStyle:{normal:{opacity:0}},
	            lineStyle:{normal:{opacity:0}}
	        }];
		myChart2.setOption(option2);
		option2={};
	}
	
	if(wsgasconcentration.length>0){
		var option8=deepClone(stencilRealOption);
		option8.toolbox.feature.dataView.lang = ['烟感浓度', '关闭'];
		option8.legend.data = [ "烟感浓度" ];
		option8.yAxis =  [ {
			type : 'value',
			name : '烟感浓度 (%FT)',
			scale: true,
			splitLine: {show: false}
		} ];
		option8.series= [{
				name : '烟感浓度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : wsgasconcentration
			}, 
	        {
	            name:'',
	            type:'line', 
	            showSymbol:false, 
	            data:anchor,
	            itemStyle:{normal:{opacity:0}},
	            lineStyle:{normal:{opacity:0}}
	        }];
		myChart8.setOption(option8);
		option8={};
	}
	
	if(wshumidness.length>0){
		var option9=deepClone(stencilRealOption);
		option9.toolbox.feature.dataView.lang = ['湿度', '关闭'];
		option9.legend.data = [ "湿度" ];
		option9.yAxis =  [ {
			type : 'value',
			name : '湿度 (%)',
			scale: true,
			splitLine: {show: false}
		} ];
		option9.series= [{
				name : '湿度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : wshumidness
			}, 
	        {
	            name:'',
	            type:'line', 
	            showSymbol:false, 
	            data:anchor,
	            itemStyle:{normal:{opacity:0}},
	            lineStyle:{normal:{opacity:0}}
	        }];
		myChart9.setOption(option9);
		option9={};
	}		
	
	if(wsbarometricPressure.length>0){
		var optionbarometricPressure=deepClone(stencilRealOption);
		optionbarometricPressure.toolbox.feature.dataView.lang = ['大气压', '关闭'];
		optionbarometricPressure.legend.data = [ "大气压" ];
		optionbarometricPressure.yAxis =  [ {
			type : 'value',
			name : '大气压 (Pa)',
			scale: true,
			splitLine: {show: false}
		} ];
		optionbarometricPressure.series= [{
				name : '大气压',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : wsbarometricPressure
			}, 
	        {
	            name:'',
	            type:'line', 
	            showSymbol:false, 
	            data:anchor,
	            itemStyle:{normal:{opacity:0}},
	            lineStyle:{normal:{opacity:0}}
	        }];
		myCharta.setOption(optionbarometricPressure);
		optionbarometricPressure={};
	}	
	
	echarts.connect([ myChart4, myChart7, myChart3, myChart6, myChart5, myChart, myChart2, myChart8, myChart9, myCharta]);
}

function makeAmmeterRealCurveThree(array){
	if(wsresidualcueeent.length>0){
		var option4=deepClone(stencilRealOption);
		option4.toolbox.feature.dataView.lang = ['电流', '关闭'];
		option4.legend.data = [ "电流" ];
		option4.yAxis = [ {
			type : 'value',
			name : '电流 (A)',
			scale: true,
			splitLine: {show: false}
		} ];
		option4.series= [{
				name : '电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : wsresidualcueeent,
	            markLine : {}
			}, 
	        {
	            name:'',
	            type:'line', 
	            showSymbol:false, 
	            data:anchor,
	            itemStyle:{normal:{opacity:0}},
	            lineStyle:{normal:{opacity:0}}
	        }];
		if(typeof array[2]!='undefined'){
			option4.series[0].markLine = {
	            data : [ { name: '过流', yAxis: array[2] } ]
	        };
		}
		if(typeof array[6]!='undefined'){
			option4.series[3].markLine = {
	                data : [ { name: '超限', yAxis: array[6] } ]
	        }
		}
		myChart4.setOption(option4);
		option4={};
	}

	if(wsambienttemperaturea.length>0){
		var option7=deepClone(stencilRealOption);
		option7.toolbox.feature.dataView.lang = ['温度', '关闭'];
		option7.legend.data = [ "A相温度","B相温度","C相温度","零线温度"];
		option7.yAxis = [ {
			type : 'value',
			name : '温度 (°C)',
			scale: true,
			splitLine: {show: false}
		} ];
		option7.series= [{
				name : 'A相温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : wsambienttemperaturea,
	            markLine : {}
			},
			{
				name : 'B相温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : wsambienttemperatureb,
	            markLine : {}
			},
			{
				name : 'C相温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : wsambienttemperaturec,
	            markLine : {}
			},
			{
				name : '零线温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : wsambienttemperaturezero,
	            markLine : {}
			},
	        {
	            name:'',
	            type:'line', 
	            showSymbol:false, 
	            data:anchor,
	            itemStyle:{normal:{opacity:0}},
	            lineStyle:{normal:{opacity:0}}
	        }];
		if(typeof array[5]!='undefined'){
			var lowvalue= array[5].split(",");
			option7.series[0].markLine = {
	            data : [ { name: '过温1', yAxis: lowvalue[0] } ]
	        };
			if(lowvalue[1]!=0)
				option7.series[0].markLine.data.push({ name: '过温2', yAxis: lowvalue[1] });
			if(lowvalue[2]!=0)
				option7.series[0].markLine.data.push({ name: '过温3', yAxis: lowvalue[2] });
		}
		myChart7.setOption(option7);
		option7={};
	}

	if(wsvoltage.length>0){
		var option3=deepClone(stencilRealOption);
		option3.toolbox.feature.dataView.lang = ['电压', '关闭'];
		option3.legend.data = [ "电压" ];
		option3.yAxis = [ {
			type : 'value',
			name : '电压 (V)',
			scale: true,
			splitLine: {show: false}
		}];
		option3.series= [{
				name : '电压',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : wsvoltage,
	            markLine : {}
			},
	        {
	            name:'',
	            type:'line', 
	            showSymbol:false, 
	            data:anchor,
	            itemStyle:{normal:{opacity:0}},
	            lineStyle:{normal:{opacity:0}}
	        }];
		var voltageData=[];
		if(typeof array[0]!='undefined'){
			voltageData.push({ name: '过压', yAxis: array[0] });
		}
		if(typeof array[1]!='undefined'){
			voltageData.push({ name: '欠压', yAxis: array[1] });
		}
		if(voltageData!=[]){
			option3.series[0].markLine = { data : voltageData };
		}
		myChart3.setOption(option3);
		option3={};
	}

	if(wspfa.length>0){
		var option6=deepClone(stencilRealOption);
		option6.toolbox.feature.dataView.lang = ['功率因数', '关闭'];
		option6.legend.data = [ "正向功率因数","反向功率因数" ];
		option6.yAxis =  [ {
			type : 'value',
			name : '功率因数',
			scale: true,
			splitLine: {show: false}
		}];
		option6.series= [
			{
				name : '正向功率因数',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : wspfa,
	            markLine : {}
			},
			{
				name : '反向功率因数',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : wspfb,
	            markLine : {}
			},
	        {
	            name:'',
	            type:'line', 
	            showSymbol:false, 
	            data:anchor,
	            itemStyle:{normal:{opacity:0}},
	            lineStyle:{normal:{opacity:0}}
	        }];
		if(typeof array[4]!='undefined'){
			option6.series[0].markLine = {
	            data : [ { name: '超限', yAxis: array[4] } ]
	        };
		}
		myChart6.setOption(option6);
		option6={};
	}

	if(wspowera.length>0){
		var option5=deepClone(stencilRealOption);
		option5.toolbox.feature.dataView.lang = ['功率', '关闭'];
		option5.legend.data = [ "正向功率","反向功率" ];
		option5.yAxis =  [ {
			type : 'value',
			name : '功率 (W)',
			scale: true,
			splitLine: {show: false}
		} ];
		option5.series= [
			{
				name : '正向功率',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : wspowera,
	            markLine : {}
			},
			{
				name : '反向功率',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : wspowerb,
	            markLine : {}
			},
	        {
	            name:'',
	            type:'line', 
	            showSymbol:false, 
	            data:anchor,
	            itemStyle:{normal:{opacity:0}},
	            lineStyle:{normal:{opacity:0}}
	        }];
		if(typeof array[3]!='undefined'){
			option5.series[0].markLine = {
	            data : [ { name: '过载', yAxis: array[3] } ]
	        };
		}
		myChart5.setOption(option5);
		option5={};
	}

	if(wspositiveelectricity.length>0){
		var option=deepClone(stencilRealOption);
		option.toolbox.feature.dataView.lang = ['正向电量', '关闭'];
		option.legend.data = [ "正相电量" ];
		option.yAxis = [ {
				type : 'value',
				name : '电量 (kWh)',
				scale: true,
				splitLine: {show: false}
			} ];
		option.series= [
			{
				name : '正相电量',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : wspositiveelectricity
			},
	        {
	            name:'',
	            type:'line', 
	            showSymbol:false, 
	            data:anchor,
	            itemStyle:{normal:{opacity:0}},
	            lineStyle:{normal:{opacity:0}}
	        }];
		myChart.setOption(option);
		option={};
	}

	if(wsreverseelectricity.length>0){
		var option2=deepClone(stencilRealOption);
		option2.toolbox.feature.dataView.lang = ['反向电量', '关闭'];
		option2.legend.data = [ "反相电量" ];
		option2.yAxis = [ {
				type : 'value',
				name : '电量 (kWh)',
				scale: true,
				splitLine: {show: false}
			} ];
		option2.series= [
			{
				name : '反相电量',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : wsreverseelectricity
			},
	        {
	            name:'',
	            type:'line', 
	            showSymbol:false, 
	            data:anchor,
	            itemStyle:{normal:{opacity:0}},
	            lineStyle:{normal:{opacity:0}}
	        }];
		myChart2.setOption(option2);
		option2={};
	}	
	echarts.connect([ myChart4, myChart7, myChart3, myChart6, myChart5, myChart, myChart2]);
}

function makeRealCurveMul(){
	if(onecue.length>0){

		var option4=deepClone(stencilRealOption);
		option4.toolbox.feature.dataView.lang = ['电流', '关闭'];
		option4.legend.data = [ "1路电流", "2路电流", "3路电流", "4路电流", '', "5路电流", "6路电流", "7路电流", "8路电流" ];
		option4.yAxis = [ {
			type : 'value',
			name : '电流 (A)',
			scale: true,
			splitLine: {show: false}
		} ];
		option4.series= [{
				name : '1路电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : onecue
			},
			{
				name : '2路电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : twocue
			},
			{
				name : '3路电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : threecue
			},
			{
				name : '4路电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : fourcue,
			}, {
				name : '5路电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : fivecue,
			},
			{
				name : '6路电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : sixcue
			},
			{
				name : '7路电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : sevencue
			},
			{
				name : '8路电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : eightcue,
			},
	        {
	            name:'',
	            type:'line', 
	            showSymbol:false, 
	            data:anchor,
	            itemStyle:{normal:{opacity:0}},
	            lineStyle:{normal:{opacity:0}}
	        }];
		myChart4.setOption(option4);
		option4={};
	}

	if(onetemp.length>0){
		var option7=deepClone(stencilRealOption);
		option7.toolbox.feature.dataView.lang = ['温度', '关闭'];
		option7.legend.data = [ "1路温度", "2路温度", "3路温度", "4路温度", '', "5路温度", "6路温度", "7路温度", "8路温度" ];
		option7.yAxis = [ {
			type : 'value',
			name : '温度 (°C)',
			scale: true,
			splitLine: {show: false}
		} ];
		option7.series= [{
				name : '1路温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : onetemp
			},
			{
				name : '2路温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : twotemp
			},
			{
				name : '3路温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : threetemp
			},
			{
				name : '4路温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : fourtemp,
			}, {
				name : '5路温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : fivetemp,
			},
			{
				name : '6路温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : sixtemp
			},
			{
				name : '7路温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : seventemp
			},
			{
				name : '8路温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : eighttemp,
			},
	        {
	            name:'',
	            type:'line', 
	            showSymbol:false, 
	            data:anchor,
	            itemStyle:{normal:{opacity:0}},
	            lineStyle:{normal:{opacity:0}}
	        }];
		myChart7.setOption(option7);
		option7={};
	}
	
	echarts.connect([ myChart4, myChart7]);
}
var stencilDayOption = {
	tooltip : {
        trigger: 'axis',
        axisPointer : { // 坐标轴指示器，坐标轴触发有效
			type : 'shadow' // 默认为直线，可选为：'line' | 'shadow' 
		},
		formatter: function (params) {
	        return "";
	    },
        position: function (point, params, dom, rect, size) {
            // 固定在顶部
            return [point[0] < (size.viewSize[0] / 2) ? point[0] : point[0] - 250, '20%'];
        }
    },
	calculable : false,
	grid : { show:'true', borderWidth:'0', left : 50, right : 60, top : 60, bottom : 65 },
	xAxis : [ {
		type : 'category',
		name : '时间',
		boundaryGap : true,//曲线开始位置，false从原点开始，true从节点中间开始
		data : [],
		splitLine: {show: false}
	} ],
	dataZoom : {    //放大缩小轴
        y:215,
        show : true,
        realtime: true,
        height:25
    },
    toolbox: {    //工具栏显示             
        show: true,
        feature: { 
        	dataZoom : {
                show : true,  //legendshow
                title : {
                    dataZoom : '区域缩放',
                    dataZoomReset : '区域缩放后退'
                },
                yAxisIndex : false
            },
            dataView : {
                show : true,   //legendshow
                title : '数据视图',
                readOnly: true,
                lang: [],
                optionToContent:function(opt) {
                	return dataviewformate_day(opt);
                }
            },
            restore : { show : true, title : '还原' } 
        },
        right:20
    },
    legend : {
		x : 'center',
		data : []
	},
    yAxis : [ ],
    series: []
};
function makeDayCurveSingle(array){
	var ectricitylegendp = [ "正总电量" ];
	var ectricitylegendr = [ "反总电量" ];//当前正反向电量(4*NNNNNN.NN kWh)总ABC    
	var voltagelegend = [ "最大A相电压", "最小A相电压" ];
	var cueeentlegend = [ "最大A相电流", "最大剩余电流", "最小A相电流", "最小剩余电流" ];
	var powerlegend = [ "最大A相功率", "最小A相功率" ];
	var pflegend = [ "最大A相功率因数","最小A相功率因数" ];
	var temperaturelegend = [ "最大A相温度", "最大N相温度", '', "最小A相温度", "最小N相温度" ];
	
	var option=deepClone(stencilDayOption);
	option.tooltip.formatter= function (params) {
        var relVal = params[0].axisValue;
        for (var i = 0, l = params.length; i < l; i++) {
            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
            relVal += params[i].seriesName + ' : ' + params[i].value ;
        }
        return relVal;
    };
	option.toolbox.feature.dataView.lang = ['正向电量', '关闭'];
	option.legend.data = ectricitylegendp;
	option.xAxis.data = freezetime;
	option.yAxis = [{
		type : 'value',
		name : '总电量 (kWh)',
		scale: true,
		splitLine: {show: false}
	} ];
	option.series= [
		{
			name : '正总电量',
			type : 'line',
			connectNulls : false,
			progressiveThreshold : 100,
			data : positiveelectricity
		} ];
	myChart.setOption(option);				option={};

	var option2=deepClone(stencilDayOption);
	option2.tooltip.formatter= function (params) {
        var relVal = params[0].axisValue;
        for (var i = 0, l = params.length; i < l; i++) {
            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
            relVal += params[i].seriesName + ' : ' + params[i].value ;
        }
        return relVal;
    };
	option2.toolbox.feature.dataView.lang = ['反向电量', '关闭'];
	option2.legend.data = ectricitylegendr;
	option2.xAxis.data = freezetime;
	option2.yAxis = [{
		type : 'value',
		name : '总电量 (kWh)',
		scale: true,
		splitLine: {show: false}
	} ];
	option2.series= [
		{
			name : '反总电量',
			type : 'line',
			connectNulls : false,
			progressiveThreshold : 100,
			data : reverseelectricity
		} ];
	myChart2.setOption(option2);
	option2={};

	var option3=deepClone(stencilDayOption);
    option3.tooltip.formatter= function (params) {
        var relVal = params[0].axisValue;
        for (var i = 0, l = params.length; i < l; i++) {
        	var time="";
        	switch(params[i].seriesIndex){
        	case 0:time = maxvoltageatime[params[i].dataIndex] + ' , ';break;
        	case 1:time = minvoltageatime[params[i].dataIndex] + ' , ';break;
        	}
        	if(time == " , " || time == ",") time = "";
            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
            relVal += params[i].seriesName + ' : ' + time + params[i].value ;
        }
        return relVal;
    };
	option3.toolbox.feature.dataView.lang = ['电压', '关闭'];
	option3.legend.data = voltagelegend;
	option3.xAxis.data = freezetime;
	option3.yAxis = [ {
		type : 'value',
		name : '电压 (V)',
		scale: true,
		splitLine: {show: false}
	} ];
	option3.series= [
		{
			name : '最大A相电压',
			type : 'line',
			connectNulls : false,
			progressiveThreshold : 100,
			data : maxvoltagea,
            markLine : {}
		},
		{
			name : '最小A相电压',
			type : 'line',
			connectNulls : false,
			progressiveThreshold : 100,
			data : minvoltagea
		}];
	var voltageData=[];
	if(typeof array[0]!='undefined'){
		voltageData.push({ name: '过压', yAxis: array[0] });
	}
	if(typeof array[1]!='undefined'){
		voltageData.push({ name: '欠压', yAxis: array[1] });
	}
	if(voltageData!=[]){
		option3.series[0].markLine = { data : voltageData };
	}
	myChart3.setOption(option3);
	option3={};

	var option4=deepClone(stencilDayOption);
	option4.tooltip.formatter= function (params) {
        var relVal = params[0].axisValue;
        for (var i = 0, l = params.length; i < l; i++) {
        	var time="";
        	switch(params[i].seriesIndex){
        	case 0:time = maxcueeentatime[params[i].dataIndex] + ' , ';break;
        	case 1:time = mincueeentatime[params[i].dataIndex] + ' , ';break;
        	case 2:time = maxresidualcurrenttime[params[i].dataIndex] + ' , ';break;
        	case 3:time = minresidualcurrenttime[params[i].dataIndex] + ' , ';break;
        	}
        	if(time == " , " || time == ",") time = "";
            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
            relVal += params[i].seriesName + ' : ' + time + params[i].value ;
        }
        return relVal;
    };
	option4.toolbox.feature.dataView.lang = ['电流', '关闭'];
	option4.legend.data = cueeentlegend;
	option4.xAxis.data = freezetime;
	option4.yAxis = [ {
		type : 'value',
		name : '电流 (A)',
		scale: true,
		splitLine: {show: false}
	} ];
	option4.series= [
		{
			name : '最大A相电流',
			type : 'line',
			connectNulls : false,
			progressiveThreshold : 100,
			data : maxcueeenta,
            markLine : {}
		},
		{
			name : '最小A相电流',
			type : 'line',
			connectNulls : false,
			progressiveThreshold : 100,
			data : mincueeenta
		},
		{
			name : '最大剩余电流',
			type : 'line',
			connectNulls : false,
			progressiveThreshold : 100,
			data : maxresidualcurrent,
            markLine : {}
		},
		{
			name : '最小剩余电流',
			type : 'line',
			connectNulls : false,
			progressiveThreshold : 100,
			data : minresidualcurrent
		} ];
	if(typeof array[2]!='undefined'){
		option4.series[0].markLine = {
            data : [ { name: '过流', yAxis: array[2] } ]
        };
	}
	if(typeof array[6]!='undefined'){
		option4.series[2].markLine = {
                data : [ { name: '超限', yAxis: array[6] } ]
        }
	}
	myChart4.setOption(option4);
	option4={};

	var option5=deepClone(stencilDayOption);
	option5.tooltip.formatter= function (params) {
        var relVal = params[0].axisValue;
        for (var i = 0, l = params.length; i < l; i++) {
        	var time="";
        	switch(params[i].seriesIndex){
        	case 0:time = maxpoweratime[params[i].dataIndex] + ' , ';break;
        	case 1:time = minpoweratime[params[i].dataIndex] + ' , ';break;
        	}
        	if(time == " , " || time == ",") time = "";
            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
            relVal += params[i].seriesName + ' : ' + time + params[i].value ;
        }
        return relVal;
    };
	option5.toolbox.feature.dataView.lang = ['功率', '关闭'];
	option5.legend.data = powerlegend;
	option5.xAxis.data = freezetime;
	option5.yAxis = [ {
		type : 'value',
		name : '功率 (kW)',
		scale: true,
		splitLine: {show: false}
	}];
	option5.series= [
		{
			name : '最大A相功率',
			type : 'line',
			connectNulls : false,
			progressiveThreshold : 100,
			data : maxpowera,
            markLine : {}
		},
		{
			name : '最小A相功率',
			type : 'line',
			connectNulls : false,
			progressiveThreshold : 100,
			data : minpowera
		}];
	if(typeof array[3]!='undefined'){
		option5.series[0].markLine = {
            data : [ { name: '过载', yAxis: array[3] } ]
        };
	}
	myChart5.setOption(option5);
	option5={};

	var option6=deepClone(stencilDayOption);
	option6.tooltip.formatter= function (params) {
        var relVal = params[0].axisValue;
        for (var i = 0, l = params.length; i < l; i++) {
        	var time="";
        	switch(params[i].seriesIndex){
        	case 0:time = maxpfatime[params[i].dataIndex] + ' , ';break;
        	case 1:time = minpfatime[params[i].dataIndex] + ' , ';break;
        	}
        	if(time == " , " || time == ",") time = "";
            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
            relVal += params[i].seriesName + ' : ' + time + params[i].value ;
        }
        return relVal;
    };
	option6.toolbox.feature.dataView.lang = ['功率因数', '关闭'];
	option6.legend.data = pflegend;
	option6.xAxis.data = freezetime;
	option6.yAxis = [ {
		type : 'value',
		name : '功率因数',
		scale: true,
		splitLine: {show: false}
	}];
	option6.series= [
		{
			name : '最大A相功率因数',
			type : 'line',
			connectNulls : false,
			progressiveThreshold : 100,
			data : maxpfa,
            markLine : {}
		},
		{
			name : '最小A相功率因数',
			type : 'line',
			connectNulls : false,
			progressiveThreshold : 100,
			data : minpfa
		} ];
	if(typeof array[4]!='undefined'){
		option6.series[0].markLine = {
            data : [ { name: '超限', yAxis: array[4] } ]
        };
	}
	myChart6.setOption(option6);
	option6={};

	var option7=deepClone(stencilDayOption);
	option7.tooltip.formatter= function (params) {
        var relVal = params[0].axisValue;
        for (var i = 0, l = params.length; i < l; i++) {
        	var time="";
        	switch(params[i].seriesIndex){
        	case 0:time = maxtempatime[params[i].dataIndex] + ' , ';break;
        	case 1:time = mintempatime[params[i].dataIndex] + ' , ';break;
        	case 2:time = maxtempntime[params[i].dataIndex] + ' , ';break;
        	case 3:time = mintempntime[params[i].dataIndex] + ' , ';break;
        	case 4:time = maxambienttemptime[params[i].dataIndex] + ' , ';break;
        	case 5:time = minambienttemptime[params[i].dataIndex] + ' , ';break;
        	}
        	if(time == " , " || time == ",") time = "";
            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
            relVal += params[i].seriesName + ' : ' + time + params[i].value ;
        }
        return relVal;
    };
	option7.toolbox.feature.dataView.lang = ['温度', '关闭'];
	option7.legend.data = temperaturelegend;
	option7.xAxis.data = freezetime;
	option7.yAxis = [ {
		type : 'value',
		name : '温度 (°C)',
		scale: true,
		splitLine: {show: false}
	} ];
	option7.series= [
		{
			name : '最大A相温度',
			type : 'line',
			connectNulls : false,
			progressiveThreshold : 100,
			data : maxtempa,
            markLine : {}
		},
		{
			name : '最小A相温度',
			type : 'line',
			connectNulls : false,
			progressiveThreshold : 100,
			data : mintempa
		},
		{
			name : '最大N相温度',
			type : 'line',
			connectNulls : false,
			progressiveThreshold : 100,
			data : maxtempn
		},
		{
			name : '最小N相温度',
			type : 'line',
			connectNulls : false,
			progressiveThreshold : 100,
			data : mintempn
		}];
	if(typeof array[5]!='undefined'){
		var lowvalue= array[5].split(",");
		option7.series[0].markLine = {
            data : [ { name: '过温1', yAxis: lowvalue[0] } ]
        };
		if(lowvalue[1]!=0)
			option7.series[0].markLine.data.push({ name: '过温2', yAxis: lowvalue[1] });
		if(lowvalue[2]!=0)
			option7.series[0].markLine.data.push({ name: '过温3', yAxis: lowvalue[2] });
	}
	myChart7.setOption(option7);
	option7={};

	echarts.connect([ myChart, myChart2, myChart3, myChart4, myChart5, myChart6, myChart7 ]);
}

function makeDayCurveThree(array){
	if(positiveelectricity.length>0){
		var option=deepClone(stencilDayOption);
		option.tooltip.formatter= function (params) {
	        var relVal = params[0].axisValue;
	        for (var i = 0, l = params.length; i < l; i++) {
	            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
	            relVal += params[i].seriesName + ' : ' + params[i].value ;
	        }
	        return relVal;
	    };
		option.toolbox.feature.dataView.lang = ['正向电量', '关闭'];
		option.legend.data = [ "正向电量" ];
		option.xAxis.data = positiveelectricityfreezetime;
		option.yAxis = [ {
			type : 'value',
			name : '电量 (kWh)',
			scale: true,
			splitLine: {show: false}
		} ];
		option.series= [		
			{
				name : '正向电量',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : positiveelectricity
			}];
		myChart.setOption(option);				
		option={};
	} 
	
	if(humidness.length>0){
		var optionhumidness=deepClone(stencilDayOption);
		optionhumidness.tooltip.formatter= function (params) {
	        var relVal = params[0].axisValue;
	        for (var i = 0, l = params.length; i < l; i++) {
	            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
	            relVal += params[i].seriesName + ' : ' + params[i].value ;
	        }
	        return relVal;
	    };
		optionhumidness.toolbox.feature.dataView.lang = ['湿度', '关闭'];
		optionhumidness.legend.data = [ "湿度" ];
		optionhumidness.xAxis.data = humidnesstime;
		optionhumidness.yAxis = [ {
			type : 'value',
			name : '湿度 (%)',
			scale: true,
			splitLine: {show: false}
		}];
		optionhumidness.series= [
			{
				name : '湿度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : humidness,
	            markLine : {}
			} ];
		myChart9.setOption(optionhumidness);				
		optionhumidness={};
	}
	
	if(barometricPressure.length>0){
		var optionbarometricPressure=deepClone(stencilDayOption);
		optionbarometricPressure.tooltip.formatter= function (params) {
	        var relVal = params[0].axisValue;
	        for (var i = 0, l = params.length; i < l; i++) {
	            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
	            relVal += params[i].seriesName + ' : ' + params[i].value ;
	        }
	        return relVal;
	    };
		optionbarometricPressure.toolbox.feature.dataView.lang = ['大气压', '关闭'];
		optionbarometricPressure.legend.data = [ "大气压" ];
		optionbarometricPressure.xAxis.data = barometricPressuretime;
		optionbarometricPressure.yAxis = [ {
			type : 'value',
			name : '大气压 (Pa)',
			scale: true,
			splitLine: {show: false}
		}];
		optionbarometricPressure.series= [
			{
				name : '大气压',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : barometricPressure,
	            markLine : {}
			} ];
		myCharta.setOption(optionbarometricPressure);				
		optionbarometricPressure={};
	}
	
	if(gasconcentration.length>0){
		var optiongasconcentration=deepClone(stencilDayOption);
		optiongasconcentration.tooltip.formatter= function (params) {
	        var relVal = params[0].axisValue;
	        for (var i = 0, l = params.length; i < l; i++) {
	            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
	            relVal += params[i].seriesName + ' : ' + params[i].value ;
	        }
	        return relVal;
	    };
	    optiongasconcentration.toolbox.feature.dataView.lang = ['烟感浓度', '关闭'];
	    optiongasconcentration.legend.data = [ "烟感浓度" ];
	    optiongasconcentration.xAxis.data = gasconcentrationtime;
	    optiongasconcentration.yAxis = [ {
			type : 'value',
			name : '烟感浓度(%FT)',
			scale: true,
			splitLine: {show: false}
		}];
	    optiongasconcentration.series= [
			{
				name : '烟感浓度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : gasconcentration,
	            markLine : {}
			} ];
		myChartb.setOption(optiongasconcentration);				
		optiongasconcentration={};
	}
	
	if(reverseelectricity.length>0){
		var option2=deepClone(stencilDayOption);
		option2.tooltip.formatter= function (params) {
	        var relVal = params[0].axisValue;
	        for (var i = 0, l = params.length; i < l; i++) {
	            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
	            relVal += params[i].seriesName + ' : ' + params[i].value ;
	        }
	        return relVal;
	    };
		option2.toolbox.feature.dataView.lang = ['反向电量', '关闭'];
		option2.legend.data = [  "反相电量" ];;
		option2.xAxis.data = reverseelectricityfreezetime;
		option2.yAxis = [ {
			type : 'value',
			name : '电量 (kWh)',
			scale: true,
			splitLine: {show: false}
		} ];
		option2.series= [
			
			{
				name : '反相电量',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : reverseelectricity
			} ];
		myChart2.setOption(option2);
		option2={};
	}
		
	if(voltagea.length>0){
		var option3=deepClone(stencilDayOption);
	    option3.tooltip.formatter= function (params) {
	        var relVal = params[0].axisValue;
	        for (var i = 0, l = params.length; i < l; i++) {
	            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
	            relVal += params[i].seriesName + ' : ' + params[i].value ;
	        }
	        return relVal;
	    };
		option3.toolbox.feature.dataView.lang = ['电压', '关闭'];
		option3.legend.data = [ "A相电压", "B相电压", "C相电压" ];
		option3.xAxis.data = voltagefreezetime;
		option3.yAxis = [ {
			type : 'value',
			name : '电压 (V)',
			scale: true,
			splitLine: {show: false}
		} ];
		option3.series= [
			{
				name : 'A相电压',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : voltagea,
	            markLine : {}
			},
			{
				name : 'B相电压',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : voltageb
			},
			{
				name : 'C相电压',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : voltagec
			}];
		myChart3.setOption(option3);
		option3={};
	}
	
	if(maxcueeenta.length>0){
		var option4=deepClone(stencilDayOption);
		option4.tooltip.formatter= function (params) {
	        var relVal = params[0].axisValue;
	        for (var i = 0, l = params.length; i < l; i++) {
	            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
	            relVal += params[i].seriesName + ' : ' + params[i].value ;
	        }
	        return relVal;
	    };
		option4.toolbox.feature.dataView.lang = ['电流', '关闭'];
		option4.legend.data = [ "A相电流", "B相电流", "C相电流" ];
		option4.xAxis.data = electricityfreezetime;
		option4.yAxis = [ {
			type : 'value',
			name : '电流 (A)',
			scale: true,
			splitLine: {show: false}
		} ];
		option4.series= [
			{
				name : 'A相电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : maxcueeenta,
	            markLine : {}
			},
			{
				name : 'B相电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : maxcueeentb
			},
			{
				name : 'C相电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : maxcueeentc
			} ];
	
		myChart4.setOption(option4);
		option4={};
	}
	
	if(power.length>0){
		var option5=deepClone(stencilDayOption);
		option5.tooltip.formatter= function (params) {
	        var relVal = params[0].axisValue;
	        for (var i = 0, l = params.length; i < l; i++) {
	            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
	            relVal += params[i].seriesName + ' : ' + params[i].value ;
	        }
	        return relVal;
	    };
		option5.toolbox.feature.dataView.lang = ['功率', '关闭'];
		option5.legend.data = [ "总功率", "A相功率", "B相功率", "C相功率" ];
		option5.xAxis.data = powerfreezetime;
		option5.yAxis = [ {
			type : 'value',
			name : '功率 (W)',
			scale: true,
			splitLine: {show: false}
		},{
			type : 'value',
			name : '总功率 (W)',
			scale: true,
			splitLine: {show: false}
		} ];
		option5.series= [
			{
				name : '总功率',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				yAxisIndex:1,
				data : power
			},
			{
				name : 'A相功率',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : powera,
	            markLine : {}
			},
			{
				name : 'B相功率',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : powerb
			},
			{
				name : 'C相功率',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : powerc
			}];
		if(typeof array[3]!='undefined'){
			option5.series[0].markLine = {
	            data : [ { name: '过载', yAxis: array[3] } ]
	        };
		}
		myChart5.setOption(option5);
		option5={};
	}
	
/*	if(maxpf.length>0){
		var option6=deepClone(stencilDayOption);
		option6.tooltip.formatter= function (params) {
	        var relVal = params[0].axisValue;
	        for (var i = 0, l = params.length; i < l; i++) {
	        	var time="";
	        	switch(params[i].seriesIndex){
	        	case 0:time = maxpftime[params[i].dataIndex] + ' , ';break;
	        	case 1:time = minpftime[params[i].dataIndex] + ' , ';break;
	        	case 2:time = maxpfatime[params[i].dataIndex] + ' , ';break;
	        	case 3:time = minpfatime[params[i].dataIndex] + ' , ';break;
	        	case 4:time = maxpfbtime[params[i].dataIndex] + ' , ';break;
	        	case 5:time = minpfbtime[params[i].dataIndex] + ' , ';break;
	        	case 6:time = maxpfctime[params[i].dataIndex] + ' , ';break;
	        	case 7:time = minpfctime[params[i].dataIndex] + ' , ';break;
	        	}
	        	if(time == " , " || time == ",") time = "";
	            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
	            relVal += params[i].seriesName + ' : ' + time + params[i].value ;
	        }
	        return relVal;
	    };
		option6.toolbox.feature.dataView.lang = ['功率因数', '关闭'];
		option6.legend.data = [ "最大总功率因数", "最大A相功率因数", "最大B相功率因数", "最大C相功率因数", '', "最小总功率因数", "最小A相功率因数", "最小B相功率因数", "最小C相功率因数" ];
		option6.xAxis.data = freezetime;
		option6.yAxis = [ {
			type : 'value',
			name : '功率因数',
			scale: true,
			splitLine: {show: false}
		}, {
			type : 'value',
			name : '总功率因数',
			scale: true,
			splitLine: {show: false}
		} ];
		option6.series= [
			{
				name : '最大总功率因数',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				yAxisIndex:1,
				data : maxpf
			},
			{
				name : '最小总功率因数',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				yAxisIndex:1,
				data : minpf
			},
			{
				name : '最大A相功率因数',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : maxpfa,
	            markLine : {}
			},
			{
				name : '最小A相功率因数',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : minpfa
			},
			{
				name : '最大B相功率因数',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : maxpfb
			},
			{
				name : '最小B相功率因数',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : minpfb
			},
			{
				name : '最大C相功率因数',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : maxpfc
			},
			{
				name : '最小C相功率因数',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : minpfc
			} ];
		if(typeof array[4]!='undefined'){
			option6.series[0].markLine = {
	            data : [ { name: '超限', yAxis: array[4] } ]
	        };
		}
		myChart6.setOption(option6);
		option6={};
	}*/
	
	if(temp.length>0){
		var option7=deepClone(stencilDayOption);
		option7.tooltip.formatter= function (params) {
	        var relVal = params[0].axisValue;
	        for (var i = 0, l = params.length; i < l; i++) {
	            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
	            relVal += params[i].seriesName + ' : ' + params[i].value ;
	        }
	        return relVal;
	    };
		option7.toolbox.feature.dataView.lang = ['温度', '关闭'];
		option7.legend.data = [ "环境温度" ];
		option7.xAxis.data = temptime;
		option7.yAxis = [ {
			type : 'value',
			name : '温度 (°C)',
			scale: true,
			splitLine: {show: false}
		} ];
		option7.series= [
			{
				name : '环境温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : temp,
	            markLine : {}
			} ];
		
		myChart7.setOption(option7);
		option7={};
	}
	
	echarts.connect([ myChart, myChart2, myChart3, myChart4, myChart5, myChart6, myChart7,  myChart9,  myCharta,myChartb]);
}

function makeAmmeterDayCurveThree(array){
	if(positiveelectricity.length>0){
		var option=deepClone(stencilDayOption);
		option.tooltip.formatter= function (params) {
	        var relVal = params[0].axisValue;
	        for (var i = 0, l = params.length; i < l; i++) {
	            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
	            relVal += params[i].seriesName + ' : ' + params[i].value ;
	        }
	        return relVal;
	    };
		option.toolbox.feature.dataView.lang = ['正向电量', '关闭'];
		option.legend.data = [ "正向电量" ];
		option.xAxis.data = positiveelectricityfreezetime;
		option.yAxis = [ {
			type : 'value',
			name : '电量 (kWh)',
			scale: true,
			splitLine: {show: false}
		} ];
		option.series= [		
			{
				name : '正向电量',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : positiveelectricity
			}];
		myChart.setOption(option);				
		option={};
	} 	
	
	if(reverseelectricity.length>0){
		var option2=deepClone(stencilDayOption);
		option2.tooltip.formatter= function (params) {
	        var relVal = params[0].axisValue;
	        for (var i = 0, l = params.length; i < l; i++) {
	            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
	            relVal += params[i].seriesName + ' : ' + params[i].value ;
	        }
	        return relVal;
	    };
		option2.toolbox.feature.dataView.lang = ['反向电量', '关闭'];
		option2.legend.data = [  "反相电量" ];;
		option2.xAxis.data = reverseelectricityfreezetime;
		option2.yAxis = [ {
			type : 'value',
			name : '电量 (kWh)',
			scale: true,
			splitLine: {show: false}
		} ];
		option2.series= [
			
			{
				name : '反相电量',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : reverseelectricity
			} ];
		myChart2.setOption(option2);
		option2={};
	}
		
	if(voltage.length>0){
		var option3=deepClone(stencilDayOption);
	    option3.tooltip.formatter= function (params) {
	        var relVal = params[0].axisValue;
	        for (var i = 0, l = params.length; i < l; i++) {
	            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
	            relVal += params[i].seriesName + ' : ' + params[i].value ;
	        }
	        return relVal;
	    };
		option3.toolbox.feature.dataView.lang = ['电压', '关闭'];
		option3.legend.data = [ "电压" ];
		option3.xAxis.data = voltagefreezetime;
		option3.yAxis = [ {
			type : 'value',
			name : '电压 (V)',
			scale: true,
			splitLine: {show: false}
		} ];
		option3.series= [
			{
				name : '电压',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : voltage,
	            markLine : {}
			}];
		myChart3.setOption(option3);
		option3={};
	}
	
	if(maxcueeent.length>0){
		var option4=deepClone(stencilDayOption);
		option4.tooltip.formatter= function (params) {
	        var relVal = params[0].axisValue;
	        for (var i = 0, l = params.length; i < l; i++) {
	            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
	            relVal += params[i].seriesName + ' : ' + params[i].value ;
	        }
	        return relVal;
	    };
		option4.toolbox.feature.dataView.lang = ['电流', '关闭'];
		option4.legend.data = [ "电流" ];
		option4.xAxis.data = electricityfreezetime;
		option4.yAxis = [ {
			type : 'value',
			name : '电流 (A)',
			scale: true,
			splitLine: {show: false}
		} ];
		option4.series= [
			{
				name : '电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : maxcueeent,
	            markLine : {}
			}];
	
		myChart4.setOption(option4);
		option4={};
	}
	
	if(powera.length>0){
		var option5=deepClone(stencilDayOption);
		option5.tooltip.formatter= function (params) {
	        var relVal = params[0].axisValue;
	        for (var i = 0, l = params.length; i < l; i++) {
	            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
	            relVal += params[i].seriesName + ' : ' + params[i].value ;
	        }
	        return relVal;
	    };
		option5.toolbox.feature.dataView.lang = ['功率', '关闭'];
		option5.legend.data = [ "正向功率", "反向功率"];
		option5.xAxis.data = powertime;
		option5.yAxis = [ {
			type : 'value',
			name : '功率 (kW)',
			scale: true,
			splitLine: {show: false}
		} ];
		option5.series= [
						{
				name : '正向功率',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : powera,
	            markLine : {}
			},
			{
				name : '反向功率',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : powerb
			} ];
		
		myChart5.setOption(option5);
		option5={};
	}
	
	if(pfa.length>0){
		var option6=deepClone(stencilDayOption);
		option6.tooltip.formatter= function (params) {
	        var relVal = params[0].axisValue;
	        for (var i = 0, l = params.length; i < l; i++) {
	            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
	            relVal += params[i].seriesName + ' : ' + params[i].value ;
	        }
	        return relVal;
	    };
		option6.toolbox.feature.dataView.lang = ['功率因数', '关闭'];
		option6.legend.data = [ "正向功率因数", "反向功率因数" ];
		option6.xAxis.data = pftime;
		option6.yAxis = [ {
			type : 'value',
			name : '功率因数',
			scale: true,
			splitLine: {show: false}
		} ];
		option6.series= [		
			{
				name : '正向功率因数',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : pfa,
	            markLine : {}
			},
			{
				name : '反向功率因数',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : pfb
			}];
		if(typeof array[4]!='undefined'){
			option6.series[0].markLine = {
	            data : [ { name: '超限', yAxis: array[4] } ]
	        };
		}
		myChart6.setOption(option6);
		option6={};
	}
	
	if(tempa.length>0){
		var option7=deepClone(stencilDayOption);
		option7.tooltip.formatter= function (params) {
	        var relVal = params[0].axisValue;
	        for (var i = 0, l = params.length; i < l; i++) {
	            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
	            relVal += params[i].seriesName + ' : ' + params[i].value ;
	        }
	        return relVal;
	    };
		option7.toolbox.feature.dataView.lang = ['温度', '关闭'];
		option7.legend.data = [ "A相温度", "B相温度", "C相温度", "零线温度" ];
		option7.xAxis.data = temptime;
		option7.yAxis = [ {
			type : 'value',
			name : '温度 (°C)',
			scale: true,
			splitLine: {show: false}
		} ];
		option7.series= [
			{
				name : 'A相温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : tempa,
	            markLine : {}
			},
			{
				name : 'B相温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : tempb
			},
			{
				name : 'C相温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : tempc
			},
			{
				name : '零线温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : tempzero
			}];
		
		myChart7.setOption(option7);
		option7={};
	}
	
	echarts.connect([ myChart, myChart2, myChart3, myChart4, myChart5, myChart6, myChart7, ]);
}

function makeDayCurveMul(){
	if(onemaxcue.length>0){

		var option4=deepClone(stencilDayOption);
		option4.tooltip.formatter= function (params) {
	        var relVal = params[0].axisValue;
	        for (var i = 0, l = params.length; i < l; i++) {
	        	var time="";
	        	switch(params[i].seriesIndex){
	        	case 0:time = onemaxcuetime[params[i].dataIndex] + ' , ';break;
	        	case 1:time = twomaxcuetime[params[i].dataIndex] + ' , ';break;
	        	case 2:time = threemaxcuetime[params[i].dataIndex] + ' , ';break;
	        	case 3:time = fourmaxcuetime[params[i].dataIndex] + ' , ';break;
	        	case 4:time = fivemaxcuetime[params[i].dataIndex] + ' , ';break;
	        	case 5:time = sixmaxcuetime[params[i].dataIndex] + ' , ';break;
	        	case 6:time = sevenmaxcuetime[params[i].dataIndex] + ' , ';break;
	        	case 7:time = eightmaxcuetime[params[i].dataIndex] + ' , ';break;
	        	}
	        	if(time == " , " || time == ",") time = "";
	            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
	            relVal += params[i].seriesName + ' : ' + time + params[i].value ;
	        }
	        return relVal;
	    };
		option4.toolbox.feature.dataView.lang = ['电流', '关闭'];
		option4.legend.data = [ "1路最大电流", "2路最大电流", "3路最大电流", "4路最大电流", '', 
					            "5路最大电流", "6路最大电流", "7路最大电流", "8路最大电流"];
		option4.xAxis.data = freezetime;
		option4.yAxis = [ {
			type : 'value',
			name : '电流 (A)',
			scale: true,
			splitLine: {show: false}
		} ];
		option4.series= [{
				name : '1路最大电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : onemaxcue
			},
			{
				name : '2路最大电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : twomaxcue
			},
			{
				name : '3路最大电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : threemaxcue
			},
			{
				name : '4路最大电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : fourmaxcue,
			}, {
				name : '5路最大电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : fivemaxcue,
			},
			{
				name : '6路最大电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : sixmaxcue
			},
			{
				name : '7路最大电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : sevenmaxcue
			},
			{
				name : '8路最大电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : eightmaxcue,
			}];
		myChart4.setOption(option4);
		option4={};
		
		var option7=deepClone(stencilDayOption);
		option7.tooltip.formatter= function (params) {
	        var relVal = params[0].axisValue;
	        for (var i = 0, l = params.length; i < l; i++) {
	        	var time="";
	        	switch(params[i].seriesIndex){
	        	case 0:time = onemincuetime[params[i].dataIndex] + ' , ';break;
	        	case 1:time = twomincuetime[params[i].dataIndex] + ' , ';break;
	        	case 2:time = threemincuetime[params[i].dataIndex] + ' , ';break;
	        	case 3:time = fourmincuetime[params[i].dataIndex] + ' , ';break;
	        	case 4:time = fivemincuetime[params[i].dataIndex] + ' , ';break;
	        	case 5:time = sixmincuetime[params[i].dataIndex] + ' , ';break;
	        	case 6:time = sevenmincuetime[params[i].dataIndex] + ' , ';break;
	        	case 7:time = eightmincuetime[params[i].dataIndex] + ' , ';break;
	        	}
	        	if(time == " , " || time == ",") time = "";
	            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
	            relVal += params[i].seriesName + ' : ' + time + params[i].value ;
	        }
	        return relVal;
	    };
		option7.toolbox.feature.dataView.lang = ['电流', '关闭'];
		option7.legend.data = [ "1路最小电流", "2路最小电流", "3路最小电流", "4路最小电流", '', 
					            "5路最小电流", "6路最小电流", "7路最小电流", "8路最小电流"];
		option7.xAxis.data = freezetime;
		option7.yAxis = [ {
			type : 'value',
			name : '电流 (A)',
			scale: true,
			splitLine: {show: false}
		} ];
		option7.series= [{
				name : '1路最小电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : onemincue
			},
			{
				name : '2路最小电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : twomincue
			},
			{
				name : '3路最小电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : threemincue
			},
			{
				name : '4路最小电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : fourmincue,
			}, {
				name : '5路最小电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : fivemincue,
			},
			{
				name : '6路最小电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : sixmincue
			},
			{
				name : '7路最小电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : sevenmincue
			},
			{
				name : '8路最小电流',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : eightmincue,
			}];
		myChart7.setOption(option7);
		option7={};
	}

	if(onemaxtemp.length>0){
		var option3=deepClone(stencilDayOption);
		option3.tooltip.formatter= function (params) {
	        var relVal = params[0].axisValue;
	        for (var i = 0, l = params.length; i < l; i++) {
	        	var time="";
	        	switch(params[i].seriesIndex){
	        	case 0:time = onemaxtemptime[params[i].dataIndex] + ' , ';break;
	        	case 1:time = twomaxtemptime[params[i].dataIndex] + ' , ';break;
	        	case 2:time = threemaxtemptime[params[i].dataIndex] + ' , ';break;
	        	case 3:time = fourmaxtemptime[params[i].dataIndex] + ' , ';break;
	        	case 4:time = fivemaxtemptime[params[i].dataIndex] + ' , ';break;
	        	case 5:time = sixmaxtemptime[params[i].dataIndex] + ' , ';break;
	        	case 6:time = sevenmaxtemptime[params[i].dataIndex] + ' , ';break;
	        	case 7:time = eightmaxtemptime[params[i].dataIndex] + ' , ';break;
	        	}
	        	if(time == " , " || time == ",") time = "";
	            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
	            relVal += params[i].seriesName + ' : ' + time + params[i].value ;
	        }
	        return relVal;
	    };
		option3.toolbox.feature.dataView.lang = ['温度', '关闭'];
		option3.legend.data = [ "1路最大温度", "2路最大温度", "3路最大温度", "4路最大温度", '', 
			                    "5路最大温度", "6路最大温度", "7路最大温度", "8路最大温度"];
		option3.xAxis.data = freezetime;
		option3.yAxis = [ {
			type : 'value',
			name : '温度 (°C)',
			scale: true,
			splitLine: {show: false}
		} ];
		option3.series= [{
				name : '1路最大温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : onemaxtemp
			},
			{
				name : '2路最大温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : twomaxtemp
			},
			{
				name : '3路最大温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : threemaxtemp
			},
			{
				name : '4路最大温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : fourmaxtemp,
			}, {
				name : '5路最大温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : fivemaxtemp,
			},
			{
				name : '6路最大温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : sixmaxtemp
			},
			{
				name : '7路最大温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : sevenmaxtemp
			},
			{
				name : '8路最大温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : eightmaxtemp,
			}];
		myChart3.setOption(option3);
		option3={};
		
		var option6=deepClone(stencilDayOption);
		option6.tooltip.formatter= function (params) {
	        var relVal = params[0].axisValue;
	        for (var i = 0, l = params.length; i < l; i++) {
	        	var time="";
	        	switch(params[i].seriesIndex){
	        	case 0:time = onemintemptime[params[i].dataIndex] + ' , ';break;
	        	case 1:time = twomintemptime[params[i].dataIndex] + ' , ';break;
	        	case 2:time = threemintemptime[params[i].dataIndex] + ' , ';break;
	        	case 3:time = fourmintemptime[params[i].dataIndex] + ' , ';break;
	        	case 4:time = fivemintemptime[params[i].dataIndex] + ' , ';break;
	        	case 5:time = sixmintemptime[params[i].dataIndex] + ' , ';break;
	        	case 6:time = sevenmintemptime[params[i].dataIndex] + ' , ';break;
	        	case 7:time = eightmintemptime[params[i].dataIndex] + ' , ';break;
	        	}
	        	if(time == " , " || time == ",") time = "";
	            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
	            relVal += params[i].seriesName + ' : ' + time + params[i].value ;
	        }
	        return relVal;
	    };
		option6.toolbox.feature.dataView.lang = ['温度', '关闭'];
		option6.legend.data = [ "1路最小温度", "2路最小温度", "3路最小温度", "4路最小温度", '', 
			                    "5路最小温度", "6路最小温度", "7路最小温度", "8路最小温度"];
		option6.xAxis.data = freezetime;
		option6.yAxis = [ {
			type : 'value',
			name : '温度 (°C)',
			scale: true,
			splitLine: {show: false}
		} ];
		option6.series= [{
				name : '1路最小温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : onemintemp
			},
			{
				name : '2路最小温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : twomintemp
			},
			{
				name : '3路最小温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : threemintemp
			},
			{
				name : '4路最小温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : fourmintemp,
			}, {
				name : '5路最小温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : fivemintemp,
			},
			{
				name : '6路最小温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : sixmintemp
			},
			{
				name : '7路最小温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : sevenmintemp
			},
			{
				name : '8路最小温度',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : eightmintemp,
			}];
		myChart6.setOption(option6);
		option6={};
	}
	
	echarts.connect([ myChart4, myChart7, myChart3, myChart6]);
}


function makeAlarmCurve(d,array,equipmenttype){

	var alarmlegend = [ "电池电压" ];

	var a = JSON.parse(d);
	if (a.length > 0) {
		
		myChart11.clear();

		var powersupply = [],batteryvoltage = [];
		
		var freezetime = [];
		for ( var p in a) {
			if (typeof a[p].freezetime!="undefined"){
				var d = new Date(a[p].freezetime);//实时冻结数据-时间只到日
				freezetime.push(Format(d,"yyyy-MM-dd"));//冻结时间

				var type=a[p].powersupply;
				var word = parseInt(type,16).toString(2);
				while(word.length<2){ word = '0'+  word; }
				
				if(equipmenttype==82){
					switch(word){
						case "00":powersupply.push("外部供电-关闭");
							break;
						case "01":powersupply.push("外部供电-报警");
							break;
						case "10":powersupply.push("电池供电-关闭");
							break;
						case "11":powersupply.push("电池供电-报警");
							break;
					}
				}
				else if(equipmenttype==61){
					switch(word){
						case "01":
							powersupply.push("开");
							break;
						case "10":
							powersupply.push("关");
							break;
					}
				}

				//电池电压
				batteryvoltage.push(FormatValue(a[p].batteryvoltage));//电池电压
			}
		}

		var option11=deepClone(stencilDayOption);
		option11.tooltip.formatter= function (params) {
	        var relVal = params[0].axisValue;
	        for (var i = 0, l = params.length; i < l; i++) {
	        	var time="";
	        	switch(params[i].seriesIndex){
	        	case 0:time = powersupply[params[i].dataIndex] + ' , ';break;
	        	}
	        	if(time == " , " || time == ",") time = "";
	            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
	            relVal += params[i].seriesName + ' : ' + time + params[i].value ;
	        }
	        return relVal;
	    };
		option11.toolbox.feature.dataView.lang = ['电池电压', '关闭'];
		option11.legend.data = alarmlegend;
		option11.xAxis.data = freezetime;
		option11.yAxis = [ {
			type : 'value',
			name : '电池电压 (V)',
			scale: true,
			splitLine: {show: false}
		} ];
		option11.series= [
			{
				name : '电池电压',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : batteryvoltage
			} ];
		var voltage=[];
		if(typeof array[0]!='undefined'){
			voltage.push({ name: '报警按钮电池欠压', yAxis: array[0] });
		}
		if(typeof array[1]!='undefined'){
			voltage.push({ name: '声光报警电池欠压', yAxis: array[1] });
		}
		if(voltage!=[]){
			option11.series[0].markLine = { data : voltage };
		}
		myChart11.setOption(option11);
		option11={};
	}
	else{
		$.messager.alert("提示",  "未查询到该报警设备的冻结数据。", "warning");
		myChart11.clear();
	} //if (a.length > 0)
		
	myChart.clear();
	myChart2.clear();
	myChart3.clear();
	myChart4.clear();
	myChart5.clear();
	myChart6.clear();
	myChart7.clear();
	myChart8.clear();
	myChart9.clear();
	myChart10.clear();
	myChart12.clear();
	myChart13.clear();
}




function makeFireCurve(d){
	var firelegend = [ "电池电压" ];
	
	var a = JSON.parse(d);
	if (a.length > 0) {
		
		myChart13.clear();

		var firedooratatus = [],batteryvoltage = [];
		
		var freezetime = [];
		for ( var p in a) {
			if (typeof a[p].freezetime!="undefined"){
				var d = new Date(a[p].freezetime);//实时冻结数据-时间只到日
				freezetime.push(Format(d,"yyyy-MM-dd"));//冻结时间

				//供电方式和状态
				var type=a[p].firedooratatus;
				switch(type){
					case "00":firedooratatus.push("市电供电-关");
						break;
					case "01":firedooratatus.push("市电供电-开");
						break;
					case "10":firedooratatus.push("电池供电-关");
						break;
					case "11":firedooratatus.push("电池供电-开");
						break;
				}

				//电池电压
				batteryvoltage.push(FormatValue(a[p].batteryvoltage));//电池电压
			}
		}

		var option13=deepClone(stencilDayOption);
		option13.tooltip.formatter= function (params) {
	        var relVal = params[0].axisValue;
	        for (var i = 0, l = params.length; i < l; i++) {
	        	var time="";
	        	switch(params[i].seriesIndex){
	        	case 0:time = firedooratatus[params[i].dataIndex] + ' , ';break;
	        	}
	        	if(time == " , " || time == ",") time = "";
	            relVal += '<br/><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params[i].color + '"></span>';
	            relVal += params[i].seriesName + ' : ' + time + params[i].value ;
	        }
	        return relVal;
	    };
		option13.toolbox.feature.dataView.lang = ['电池电压', '关闭'];
		option13.legend.data = firelegend;
		option13.xAxis.data = freezetime;
		option13.yAxis = [ {
            name : '电池电压(V)',
            type : 'value',
			scale: true,
			splitLine: {show: false}
        } ];
		option13.series= [
			{
				name : '电池电压',
				type : 'line',
				connectNulls : false,
				progressiveThreshold : 100,
				data : batteryvoltage
			} ];
		myChart13.setOption(option13);
		option13={};
	}
	else{
		$.messager.alert("提示",  "未查询到该防火门设备的冻结数据。", "warning");
		myChart13.clear();
	} //if (a.length > 0)
		
	myChart.clear();
	myChart2.clear();
	myChart3.clear();
	myChart4.clear();
	myChart5.clear();
	myChart6.clear();
	myChart7.clear();
	myChart8.clear();
	myChart9.clear();
	myChart10.clear();
	myChart11.clear();
	myChart12.clear();
}

function parseThreshold(type,threshold){
	var array={};
	if(threshold=="null")
		return array;
	
	switch(type){
	    case "10"://电气火灾监控系统
	    	array=new Array(10);
	    	for(var i=0;i<threshold.length;i++){
	    		switch(threshold[i].eventtypecode){
	    		case 1:array[0]=threshold[i].lowervalue1;break;//1	电压过压
	    		case 2:array[1]=threshold[i].lowervalue1;break;//2	电压欠压
	    		case 3:array[2]=threshold[i].lowervalue1;break;//3	电流过流
	    		case 4:array[3]=threshold[i].lowervalue1;break;//4	功率过载
	    		case 5:array[4]=threshold[i].lowervalue1;break;//5	功率因数超限
	    		case 20:array[5]=threshold[i].lowervalue1 + "," + 
	    			threshold[i].lowervalue2 + "," + threshold[i].lowervalue3;break;//20	过温
	    		case 21:array[6]=threshold[i].lowervalue1;break;//21	剩余电流超
	    		case 22:array[7]=threshold[i].lowervalue1;break;//22	时钟电池
	    		case 23:array[8]=threshold[i].lowervalue1;break;//23	抄表电池
	    		case 24:array[9]=threshold[i].lowervalue1 + "," + threshold[i].lowervalue2;
	    			break;//24	温升判断阀值
	    		}
	    	}
	    	break;
		case "11"://可燃气体报警系统
			array=new Array(2);
			for(var i=0;i<threshold.length;i++){
	    		switch(threshold[i].eventtypecode){
	    		case 50:array[0]=threshold[i].lowervalue1;break;//50	可燃气体浓度超
	    		case 51:array[1]=threshold[i].lowervalue1;break;//51	电池欠压
	    		}
	    	}
			break;
		case "128"://火灾烟感检测系统
			array=new Array(2);
			for(var i=0;i<threshold.length;i++){
	    		switch(threshold[i].eventtypecode){
	    		case 40:array[0]=threshold[i].lowervalue1;break;//40	烟感浓度超
	    		case 41:array[1]=threshold[i].lowervalue1;break;//41	电池欠压
	    		}
	    	}
			break;
		case "129"://消防水压监控系统
			array=new Array(3);
			for(var i=0;i<threshold.length;i++){
	    		switch(threshold[i].eventtypecode){
	    		case 30:array[0]=threshold[i].lowervalue1;break;//30	水压过压
	    		case 31:array[1]=threshold[i].lowervalue1;break;//31	水压欠压
	    		case 32:array[1]=threshold[i].lowervalue1;break;//32	电池欠压
	    		}
	    	}
			break;
		case "130"://报警按钮及声光报警器
			array=new Array(2);
			for(var i=0;i<threshold.length;i++){
	    		switch(threshold[i].eventtypecode){
	    		case 70:array[0]=threshold[i].lowervalue1;break;//70	报警按钮电池欠压
	    		case 71:array[1]=threshold[i].lowervalue1;break;//71	声光报警电池欠压
	    		}
	    	}
			break;
		case "131"://消防水位监控系统
			array=new Array(3);
			for(var i=0;i<threshold.length;i++){
	    		switch(threshold[i].eventtypecode){
	    		case 60:array[0]=threshold[i].lowervalue1;break;//60	高水位预警
	    		case 61:array[1]=threshold[i].lowervalue1;break;//61	低水位预警
	    		case 62:array[1]=threshold[i].lowervalue1;break;//62	电池欠压
	    		}
	    	}
			break;
	}
	
	return array;
}

//数据视图格式化
function dataviewformate(opt){
    var axisData = opt.series[0].data;
    var series = opt.series;

    var tableDom = document.createElement("table");
    tableDom.setAttribute("id","test");
    tableDom.setAttribute("class","table-data-table");
    // <table id="test" class="table-bordered table-striped" style="width:100%;text-align:center"
    
    var table = '<thead><tr>' + '<th style="width:130px;">时间</th>';
    for(var j=0;j<series.length-1;j++){
    	table = table + '<th>' + series[j].name + '</th>'
    }
    table = table+ '</tr></thead><tbody>';
    
    for (var i = 1, l = axisData.length; i < l; i++) {
        table += '<tr>' + '<td>' + axisData[i][0] + '</td>'
        	for(var j=0;j<series.length-1;j++){
        		var dd;
        		if (typeof series[j].data[i]!="undefined")
        			dd=series[j].data[i][1];
        		else 
        			dd='-';
            	table = table + '<td>' + dd + '</td>';
            }
            table = table + '</tr>';
    }
    table += '</tbody>';
    tableDom.innerHTML = table;
    return tableDom.outerHTML;
}

function dataviewformate_day(opt){
    var axisData = opt.xAxis[0].data;
    var series = opt.series;

    var tableDom = document.createElement("table");
    tableDom.setAttribute("id","test");
    tableDom.setAttribute("class","table-data-table");
    // <table id="test" class="table-bordered table-striped" style="width:100%;text-align:center"
    
    var table = '<thead><tr>' + '<th style="width:70px;">时间</th>';
    for(var j=0;j<series.length;j++){
    	table = table + '<th>' + series[j].name + '</th>'
    }
    table = table+ '</tr></thead><tbody>';
    
    for (var i = 0, l = axisData.length; i < l; i++) {
        table += '<tr>' + '<td>' + axisData[i] + '</td>'
        	for(var j=0;j<series.length;j++){
        		var dd;
        		if (typeof series[j].data[i]!="undefined")
        			dd=series[j].data[i];
        		else 
        			dd='-';
            	table = table + '<td>' + dd + '</td>';
            }
            table = table + '</tr>';
    }
    table += '</tbody>';
    tableDom.innerHTML = table;
    return tableDom.outerHTML;
}

//值格式化
function FormatValue(value){
	if(typeof value=="undefined")
		return "null";
	else
		return value;
}

function MulFormatValue(value){
	if(typeof value=="undefined")
		return ",,,".split(',');
	else
		return value.split(',');
}
function MulValue(value){
	if(value=="")
		return "null";
	else
		return value;
}

//时间格式化方法
function Format(now,mask)
{
    var d = now;
    var zeroize = function (value, length)
    {
        if (!length) length = 2;
        value = String(value);
        for (var i = 0, zeros = ''; i < (length - value.length); i++)
        {
            zeros += '0';
        }
        return zeros + value;
    };
 
    return mask.replace(/"[^"]*"|'[^']*'|\b(?:d{1,4}|m{1,4}|yy(?:yy)?|([hHMstT])\1?|[lLZ])\b/g, function ($0)
    {
        switch ($0)
        {
            case 'd': return d.getDate();
            case 'dd': return zeroize(d.getDate());
            case 'ddd': return ['Sun', 'Mon', 'Tue', 'Wed', 'Thr', 'Fri', 'Sat'][d.getDay()];
            case 'dddd': return ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'][d.getDay()];
            case 'M': return d.getMonth() + 1;
            case 'MM': return zeroize(d.getMonth() + 1);
            case 'MMM': return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][d.getMonth()];
            case 'MMMM': return ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'][d.getMonth()];
            case 'yy': return String(d.getFullYear()).substr(2);
            case 'yyyy': return d.getFullYear();
            case 'h': return d.getHours() % 12 || 12;
            case 'hh': return zeroize(d.getHours() % 12 || 12);
            case 'H': return d.getHours();
            case 'HH': return zeroize(d.getHours());
            case 'm': return d.getMinutes();
            case 'mm': return zeroize(d.getMinutes());
            case 's': return d.getSeconds();
            case 'ss': return zeroize(d.getSeconds());
            case 'l': return zeroize(d.getMilliseconds(), 3);
            case 'L': var m = d.getMilliseconds();
                if (m > 99) m = Math.round(m / 10);
                return zeroize(m);
            case 'tt': return d.getHours() < 12 ? 'am' : 'pm';
            case 'TT': return d.getHours() < 12 ? 'AM' : 'PM';
            case 'Z': return d.toUTCString().match(/[A-Z]+$/);
            // Return quoted strings with the surrounding quotes removed
            default: return $0.substr(1, $0.length - 2);
        }
    });
};

//深度克隆
function deepClone(obj){
    var result={},oClass=isClass(obj);
    for(key in obj){
        var copy=obj[key];
        if(isClass(copy)=="Object"){
            result[key]=arguments.callee(copy);
        }else if(isClass(copy)=="Array"){
            result[key]=arguments.callee(copy);
        }else{
            result[key]=obj[key];
        }
    }
    return result;
}
function isClass(o){
    if(o===null) return "Null";
    if(o===undefined) return "Undefined";
    return Object.prototype.toString.call(o).slice(8,-1);
}