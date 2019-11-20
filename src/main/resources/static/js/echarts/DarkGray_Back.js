(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['exports', 'echarts'], factory);
    } else if (typeof exports === 'object' && typeof exports.nodeName !== 'string') {
        // CommonJS
        factory(exports, require('echarts'));
    } else {
        // Browser globals
        factory({}, root.echarts);
    }
}(this, function (exports, echarts) {
    var log = function (msg) {
        if (typeof console !== 'undefined') {
            console && console.error && console.error(msg);
        }
    };
    if (!echarts) {
        log('ECharts is not Loaded');
        return;
    }

	var colorPalette = ['#feec00','#33ba50','#de3636','#0881f0', '#2f4554', '#61a0a8', '#d48265', '#91c7ae', '#749f83',
	                    '#ca8622', '#bda29a', '#6e7074', '#546570', '#c4ccd3', '#c141e3', '#671599'];
    echarts.registerTheme('DarkGray_Back', {
        color: colorPalette,
        //backgroundColor: '#efefef',
        graph: {
            color: colorPalette
        },
        line: {
            itemStyle: {
                normal: {
                    borderWidth: 1,
                    borderColor: '#9dcfe6'
                }
            },
            lineStyle: {
                normal: {
                    width: 2
                }
            },
            symbolSize: 4,
            symbol: 'circle',
            smooth: true
        },
        categoryAxis: {
        	splitLine: {
                show: false
            }
        },
        valueAxis: {
        	splitLine: {
                show: false
            }
        },
        logAxis: {
        	splitLine: {
                show: false
            }
        },
        timeAxis: {
            splitLine: {
                show: false
            }
        }
    });
}));
