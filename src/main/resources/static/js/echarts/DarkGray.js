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

	//var colorPalette = [,'#1fa3f3','#55e0ed','#fbd8aa','#fda59b','#df5a7c','#d767f6','#027985','#967c1a','#fea801'];
	var colorPalette = ["#feec00",
	                    "#33ba50",
	                    "#de3636",
	            	    "#faef92",
	                    "#83ed43",
	                    "#2ec7c9",
	                    "#6be6c1",
	                    "#588dd5",
	                    "#a0bae0",
	                    "#d87a80",
	                    "#dc69aa",
	                    "#f2c3de",
	                    "#9a7fd1",
	                    "#c3a7f7",
	                    "#f78c35",
	                    "#ffb980"];
	echarts.registerTheme('DarkGray', {
        color: colorPalette,
        backgroundColor: 'rgba(33,45,57,1)',
        textStyle: {},
        title: {
            textStyle: {
                color: '#ffffff'
            },
            subtextStyle: {
                color: '#dddddd'
            }
        },
        line: {
            itemStyle: {
                normal: {
                    borderWidth: 1
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
        radar: {
            itemStyle: {
                normal: {
                    borderWidth: 1
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
        bar: {
            itemStyle: {
                normal: {
                    barBorderWidth: 0,
                    barBorderColor: '#ccc'
                },
                emphasis: {
                    barBorderWidth: 0,
                    barBorderColor: '#ccc'
                }
            }
        },
        pie: {
            itemStyle: {
                normal: {
                    borderWidth: 0,
                    borderColor: '#ccc'
                },
                emphasis: {
                    borderWidth: 0,
                    borderColor: '#ccc'
                }
            }
        },
        scatter: {
            itemStyle: {
                normal: {
                    borderWidth: 0,
                    borderColor: '#ccc'
                },
                emphasis: {
                    borderWidth: 0,
                    borderColor: '#ccc'
                }
            }
        },
        boxplot: {
            itemStyle: {
                normal: {
                    borderWidth: 0,
                    borderColor: '#ccc'
                },
                emphasis: {
                    borderWidth: 0,
                    borderColor: '#ccc'
                }
            }
        },
        parallel: {
            itemStyle: {
                normal: {
                    borderWidth: 0,
                    borderColor: '#ccc'
                },
                emphasis: {
                    borderWidth: 0,
                    borderColor: '#ccc'
                }
            }
        },
        sankey: {
            itemStyle: {
                normal: {
                    borderWidth: 0,
                    borderColor: '#ccc'
                },
                emphasis: {
                    borderWidth: 0,
                    borderColor: '#ccc'
                }
            }
        },
        funnel: {
            itemStyle: {
                normal: {
                    borderWidth: 0,
                    borderColor: '#ccc'
                },
                emphasis: {
                    borderWidth: 0,
                    borderColor: '#ccc'
                }
            }
        },
        gauge: {
            itemStyle: {
                normal: {
                    borderWidth: 0,
                    borderColor: '#ccc'
                },
                emphasis: {
                    borderWidth: 0,
                    borderColor: '#ccc'
                }
            }
        },
        candlestick: {
            itemStyle: {
                normal: {
                    color: '#4fbbfa',
                    color0: 'transparent',
                    borderColor: '#7eeaff',
                    borderColor0: '#f78787',
                    borderWidtd: 1
                }
            }
        },
        graph: {
            itemStyle: {
                normal: {
                    borderWidth: 0,
                    borderColor: '#ccc'
                }
            },
            lineStyle: {
                normal: {
                    width: 1,
                    color: '#ffffff'
                }
            },
            symbolSize: 4,
            symbol: 'circle',
            smooth: true,
            color: colorPalette,
            label: {
                normal: {
                    textStyle: {
                        color: '#1f2730'
                    }
                }
            }
        },
        map: {
            itemStyle: {
                normal: {
                    areaColor: '#f3f3f3',
                    borderColor: '#999999',
                    borderWidth: 0.5
                },
                emphasis: {
                    areaColor: 'rgba(91,255,235,1)',
                    borderColor: '#616361',
                    borderWidth: 1
                }
            },
            label: {
                normal: {
                    textStyle: {
                        color: '#6e5c58'
                    }
                },
                emphasis: {
                    textStyle: {
                        color: 'rgb(13,165,240)'
                    }
                }
            }
        },
        geo: {
            itemStyle: {
                normal: {
                    areaColor: '#f3f3f3',
                    borderColor: '#999999',
                    borderWidth: 0.5
                },
                emphasis: {
                    areaColor: 'rgba(91,255,235,1)',
                    borderColor: '#616361',
                    borderWidth: 1
                }
            },
            label: {
                normal: {
                    textStyle: {
                        color: '#6e5c58'
                    }
                },
                emphasis: {
                    textStyle: {
                        color: 'rgb(13,165,240)'
                    }
                }
            }
        },
        categoryAxis: {
            axisLine: {
                show: true,
                lineStyle: {
                    color: '#9dcfe6'
                }
            },
            axisTick: {
                show: false,
                lineStyle: {
                    color: '#333'
                }
            },
            axisLabel: {
                show: true,
                textStyle: {
                    color: '#9dcfe6'
                }
            },
            splitLine: {
                show: false,
                lineStyle: {
                    color: [
                        '#e6e6e6'
                    ]
                }
            },
            splitArea: {
                show: false,
                areaStyle: {
                    color: [
                        'rgba(250,250,250,0.05)',
                        'rgba(200,200,200,0.02)'
                    ]
                }
            }
        },
        valueAxis: {
            axisLine: {
                show: true,
                lineStyle: {
                    color: '#9dcfe6'
                }
            },
            axisTick: {
                show: false,
                lineStyle: {
                    color: '#333'
                }
            },
            axisLabel: {
                show: true,
                textStyle: {
                    color: '#9dcfe6'
                }
            },
            splitLine: {
                show: false,
                lineStyle: {
                    color: [
                        '#e6e6e6'
                    ]
                }
            },
            splitArea: {
                show: false,
                areaStyle: {
                    color: [
                        'rgba(250,250,250,0.05)',
                        'rgba(200,200,200,0.02)'
                    ]
                }
            }
        },
        logAxis: {
            axisLine: {
                show: true,
                lineStyle: {
                    color: '#9dcfe6'
                }
            },
            axisTick: {
                show: false,
                lineStyle: {
                    color: '#333'
                }
            },
            axisLabel: {
                show: true,
                textStyle: {
                    color: '#9dcfe6'
                }
            },
            splitLine: {
                show: false,
                lineStyle: {
                    color: [
                        '#e6e6e6'
                    ]
                }
            },
            splitArea: {
                show: false,
                areaStyle: {
                    color: [
                        'rgba(250,250,250,0.05)',
                        'rgba(200,200,200,0.02)'
                    ]
                }
            }
        },
        timeAxis: {
            axisLine: {
                show: true,
                lineStyle: {
                    color: '#9dcfe6'
                }
            },
            axisTick: {
                show: false,
                lineStyle: {
                    color: '#333'
                }
            },
            axisLabel: {
                show: true,
                textStyle: {
                    color: '#9dcfe6'
                }
            },
            splitLine: {
                show: false,
                lineStyle: {
                    color: [
                        '#e6e6e6'
                    ]
                }
            },
            splitArea: {
                show: false,
                areaStyle: {
                    color: [
                        'rgba(250,250,250,0.05)',
                        'rgba(200,200,200,0.02)'
                    ]
                }
            }
        },
        toolbox: {
            iconStyle: {
                normal: {
                    borderColor: '#cccccc'
                },
                emphasis: {
                    borderColor: '#666666'
                }
            }
        },
        legend: {
            textStyle: {
                color: '#9dcfe6'
            }
        },
        tooltip: {
            axisPointer: {
                lineStyle: {
                    color: '#cccccc',
                    width: 1
                },
                crossStyle: {
                    color: '#cccccc',
                    width: 1
                }
            }
        },
        timeline: {
            lineStyle: {
                color: '#32a3d6',
                width: 1
            },
            itemStyle: {
                normal: {
                    color: '#32a3d6',
                    borderWidth: 1
                },
                emphasis: {
                    color: '#57f55d'
                }
            },
            controlStyle: {
                normal: {
                    color: '#32a3d6',
                    borderColor: '#32a3d6',
                    borderWidth: 0.5
                },
                emphasis: {
                    color: '#32a3d6',
                    borderColor: '#32a3d6',
                    borderWidth: 0.5
                }
            },
            checkpointStyle: {
                color: '#68dcf5',
                borderColor: 'rgba(189,240,247,0.3)'
            },
            label: {
                normal: {
                    textStyle: {
                        color: '#32a3d6'
                    }
                },
                emphasis: {
                    textStyle: {
                        color: '#32a3d6'
                    }
                }
            }
        },
        visualMap: {
            color: [
                '#054b69',
                '#75cdf2'
            ]
        },
        dataZoom: {
            backgroundColor: 'rgba(114,204,255,0.23)',
            dataBackgroundColor: 'rgba(114,204,255,0.21)',
            fillerColor: 'rgba(146,167,181,0.47)',
            handleColor: '#4bbaf7',
            handleSize: '100%',
            textStyle: {
                color: '#1296f5'
            }
        },
        markPoint: {
            label: {
                normal: {
                    textStyle: {
                        color: '#1f2730'
                    }
                },
                emphasis: {
                    textStyle: {
                        color: '#1f2730'
                    }
                }
            }
        }
    });
}));
