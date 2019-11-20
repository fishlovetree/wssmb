//综合查询js


function dataQuery(){//数据召测
	evaluation();
	initDataGrid();
	
	$('#unitalarmtb').datagrid('loadData',{total:0,rows:[]});
	$('#faulttb').datagrid('loadData',{total:0,rows:[]});
	$('#messagetb').datagrid('loadData',{total:0,rows:[]});
	$('#elecurrenttb').datagrid('loadData',{total:0,rows:[]});
	$('#elecurvetb').datagrid('loadData',{total:0,rows:[]});
	$('#elefreezetb').datagrid('loadData',{total:0,rows:[]});
	$('#wgstb').datagrid('loadData',{total:0,rows:[]});
	$('#aavatb').datagrid('loadData',{total:0,rows:[]});
	$('#flmstb').datagrid('loadData',{total:0,rows:[]});
	$('#fdmstb').datagrid('loadData',{total:0,rows:[]});
	$("#result").html("");
	
	$("#dataQueryPage").dialog({
		title: '数据召测',    
	    collapsible: true
	}).dialog("open");
}

var totalalarmnum = 0;//报警数据总条数
var totalfaultnum = 0;//故障数据总条数
var totalmessagenum = 0;//消息推送总条数
var totalfreezenum = 0;//查询冻结个数
var freezeStartTime;//冻结起始时间

function initDataGrid() {	
	//报警事件记录
	$('#unitalarmtb').datagrid(
					{
						url : basePath + '/dataQuery/unitAlarmDataInf?Math.random()',
						pagination : true,//分页控件
						pageList : [ 10, 20, 30, 40, 50 ],
						fit : true, //自适应大小
						singleSelect : true,
						border : false,
						nowrap : true,//数据长度超出列宽时将会自动截取。
						rownumbers : true,//行号
						fitColumns : true,//自动使列适应表格宽度以防止出现水平滚动。
						columns : [ [
								{title : 'ID',field : 'id',width : '100px',hidden : true},
								{
									title : '操作',
									field : 'content',
									width : '80px',
									formatter : function(value,
											rowData, rowIndex) {
										return "<a href='javascript:void(0)' class='button-edit button-default' onclick='alarmDataDetail(&apos;"
												+ rowIndex
												+ "&apos;);'>详情</a> ";
									}
								},
								{title: '设备类型', field: 'equipmenttype', width:'120px'},
								{title : '设备地址',field : 'equipmentAddr',width : '124px'},
								{title : '发生时间',field : 'starttime',width : '130px'},
								{title : '报警类型',field : 'eventtypename',width : '120px'},
								{title : '累计次数',field : 'CumulativeNum',width : '100px'},
								{title: '客户编号', field: 'customercode', width:'120px'},
								{title: '单元地址', field: 'unitaddress', width:'100px'},
								{title: '系统类型', field: 'systemtype', width:'120px'},
								{title: '系统地址', field: 'systemaddress', width:'100px'},
								{title : '安装地点',field : 'buildingname',width : '100px'}
								 ] ],
								onLoadSuccess:function(data){
										$('.button-edit').linkbutton({ 
										});
										 if(data.total==0){
						                    var dc = $(this).data('datagrid').dc;
						                    var header2Row = dc.header2.find('tr.datagrid-header-row');
						                    dc.body2.find('table').append(header2Row.clone().css({"visibility":"hidden"}));
						                } 
									},
					});
	
		//设备故障记录
		$('#faulttb').datagrid(
						{
							url : basePath + '/dataQuery/unitFaultDataInf?Math.random()',
							pagination : true,//分页控件
							pageList : [ 10, 20, 30, 40, 50 ],
							fit : true, //自适应大小
							singleSelect : true,
							border : false,
							nowrap : true,//数据长度超出列宽时将会自动截取。
							rownumbers : true,//行号
							fitColumns : true,//自动使列适应表格宽度以防止出现水平滚动。
							columns : [ [
									{title : 'ID',field : 'id',width : '100px',hidden : true},
									{title: '设备类型', field: 'equipmenttype', width:'120px'},
									{title : '设备地址',field : 'equipmentaddress',width : '124px'},
									{title : '发生时间',field : 'occurtime',width : '130px'},
									{title : '结束时间',field : 'endtime',width : '130px'},
									{title : '故障类型',field : 'faultname',width : '120px'},
									{title : '累计次数',field : 'cumulativenum',width : '100px'},
									{title : '备注',field : 'remarks',width : '100px'},
									{title: '客户编号', field: 'customercode', width:'120px'},
									{title: '单元地址', field: 'unitaddress', width:'100px'},
									{title: '系统类型', field: 'systemtypename', width:'120px'},
									{title: '系统地址', field: 'systemaddress', width:'100px'},
									{title : '安装地点',field : 'buildingid',width : '100px'}
									 ] ],
									onLoadSuccess:function(data){
											$('.button-edit').linkbutton({ 
											});
											 if(data.total==0){
							                    var dc = $(this).data('datagrid').dc;
							                    var header2Row = dc.header2.find('tr.datagrid-header-row');
							                    dc.body2.find('table').append(header2Row.clone().css({"visibility":"hidden"}));
							                } 
										},
						});
		
		//消息推送记录
		$('#messagetb').datagrid(
						{
							url : basePath + '/dataQuery/unitMessageDataInf?Math.random()',
							pagination : true,//分页控件
							pageList : [ 10, 20, 30, 40, 50 ],
							fit : true, //自适应大小
							singleSelect : true,
							border : false,
							nowrap : true,//数据长度超出列宽时将会自动截取。
							rownumbers : true,//行号
							fitColumns : true,//自动使列适应表格宽度以防止出现水平滚动。
							columns : [ [
									{title : 'ID',field : 'id',width : '100px',hidden : true},
									{title: '设备类型', field: 'equipmenttype', width:'120px'},
									{title : '设备地址',field : 'equipmentaddress',width : '124px'},
									{title : '发生时间',field : 'occurtime',width : '130px'},
									{title : '消息类型',field : 'messagename',width : '120px'},
									{title : '累计次数',field : 'cumulativenum',width : '100px'},
									{title : '下限阀值',field : 'lowervalue',width : '100px'},
									{title : '延时时间',field : 'delaytime',width : '100px'},
									{title : '更新前SIM卡序号',field : 'befupdatenum',width : '100px'},
									{title : '更新后SIM卡序号',field : 'aftupdatenum',width : '100px'},
									{title: '客户编号', field: 'customercode', width:'120px'},
									{title: '单元地址', field: 'unitaddress', width:'100px'},
									{title: '系统类型', field: 'systemtypename', width:'120px'},
									{title: '系统地址', field: 'systemaddress', width:'100px'},
									{title : '安装地点',field : 'buildingname',width : '100px'}
									 ] ],
									onLoadSuccess:function(data){
											$('.button-edit').linkbutton({ 
											});
											 if(data.total==0){
							                    var dc = $(this).data('datagrid').dc;
							                    var header2Row = dc.header2.find('tr.datagrid-header-row');
							                    dc.body2.find('table').append(header2Row.clone().css({"visibility":"hidden"}));
							                } 
										},
						});

		
	//电气火灾报警系统实时数据(用电系统当前数据)
	$('#elecurrenttb').datagrid({
						url : basePath + '/dataQuery/eleCurrentDataInf?Math.random()',
						pagination : true,//分页控件
						pageList : [ 10, 20, 30, 40, 50 ],
						fit : true, //自适应大小
						singleSelect : true,
						border : false,
						nowrap : true,//数据长度超出列宽时将会自动截取。
						rownumbers : true,//行号
						fitColumns : true,//自动使列适应表格宽度以防止出现水平滚动。
						columns : [ [
								{
									title : 'ID',
									field : 'id',
									width : '100px',
									hidden : true
								},
								{
									title : '操作',
									field : 'content',
									width : '80px',
									formatter : function(value,
											rowData, rowIndex) {
										return "<a href='javascript:void(0)' class='button-edit button-default' onclick='currentDataDetail(&apos;"
												+ rowIndex
												+ "&apos;);'>详情</a> ";
									}
								},
								{title: '设备类型', field: 'equipmenttype', width:'150px'},
								{
									title : '设备地址',
									field : 'equipmentAddr',
									width : '124px',
									formatter : function(value,
											rowData, rowIndex) {
										return rowData.realtimedata.equipmentAddr;
									}
								},
								{
									title : '当前正向总电量',
									field : 'positiveElectricity',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										return formatData(rowData.realtimedata.positiveElectricity);
									}
								},
								{
									title : '当前正向A相电量 ',
									field : 'positiveElectricityA',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										return formatData(rowData.realtimedata.positiveElectricityA);
									}
								},
								{
									title : '当前正向B相电量',
									field : 'positiveElectricityB',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										return formatData(rowData.realtimedata.positiveElectricityB);
									}
								},
								{
									title : '当前正向C相电量',
									field : 'positiveElectricityC',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										return formatData(rowData.realtimedata.positiveElectricityC);
									}
								},
								{
									title : '当前反向总电量',
									field : 'reverseElectricity',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										return formatData(rowData.realtimedata.reverseElectricity);
									}
								},
								{
									title : '当前反向A相电量',
									field : 'reverseElectricityA',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										return formatData(rowData.realtimedata.reverseElectricityA);
									}
								},
								{
									title : '当前反向B相电量',
									field : 'reverseElectricityB',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										return formatData(rowData.realtimedata.reverseElectricityB);
									}
								},
								{
									title : '当前反向C相电量',
									field : 'reverseElectricityC',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										return formatData(rowData.realtimedata.reverseElectricityC);
									}
								},
								{
									title : 'A相电压',
									field : 'VA',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.realtimedata) {
											return formatData(rowData.realtimedata.VA);
										}
									}
								},
								{
									title : 'B相电压',
									field : 'VB',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.realtimedata) {
											return formatData(rowData.realtimedata.VB);
										}
									}
								},
								{
									title : 'C相电压',
									field : 'VC',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.realtimedata) {
											return formatData(rowData.realtimedata.VC);
										}
									}
								},
								{
									title : 'A相电流',
									field : 'AA',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.realtimedata) {
											return formatData(rowData.realtimedata.AA);
										}
									}
								},
								{
									title : 'B相电流',
									field : 'AB',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.realtimedata) {
											return formatData(rowData.realtimedata.AB);
										}
									}
								},
								{
									title : 'C相电流',
									field : 'AC',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.realtimedata) {
											return formatData(rowData.realtimedata.AC);
										}
									}
								},
								{
									title : '剩余电流',
									field : 'AOver',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.realtimedata) {
											return formatData(rowData.realtimedata.AOver);
										}
									}
								},
								{
									title : '总功率',
									field : 'Power',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.realtimedata) {
											return formatData(rowData.realtimedata.Power);
										}
									}
								},
								{
									title : 'A相功率',
									field : 'PowerA',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.realtimedata) {
											return formatData(rowData.realtimedata.PowerA);
										}
									}
								},
								{
									title : 'B相功率',
									field : 'PowerB',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.realtimedata) {
											return formatData(rowData.realtimedata.PowerB);
										}
									}
								},
								{
									title : 'C相功率',
									field : 'PowerC',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.realtimedata) {
											return formatData(rowData.realtimedata.PowerC);
										}
									}
								},
								{
									title : '总功率因素',
									field : 'PF',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.realtimedata) {
											return formatData(rowData.realtimedata.PF);
										}
									}
								},
								{
									title : 'A相功率因素',
									field : 'PFA',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.realtimedata) {
											return formatData(rowData.realtimedata.PFA);
										}
									}
								},
								{
									title : 'B相功率因素',
									field : 'PFB',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.realtimedata) {
											return formatData(rowData.realtimedata.PFB);
										}
									}
								},
								{
									title : 'C相功率因素',
									field : 'PFC',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.realtimedata) {
											return formatData(rowData.realtimedata.PFC);
										}
									}
								},
								{
									title : '频率',
									field : 'Frequency',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.realtimedata) {
											return formatData(rowData.realtimedata.Frequency);
										}
									}
								},
								{
									title : 'A相温度 ',
									field : 'tempA',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.realtimedata) {
											return formatData(rowData.realtimedata.tempA);
										}
									}
								},
								{
									title : 'B相温度',
									field : 'tempB',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.realtimedata) {
											return formatData(rowData.realtimedata.tempB);
										}
									}
								},
								{
									title : 'C相温度',
									field : 'tempC',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.realtimedata) {
											return formatData(rowData.realtimedata.tempC);
										}
									}
								},
								{
									title : '零线温度',
									field : 'NTemp',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.realtimedata) {
											return formatData(rowData.realtimedata.NTemp);
										}
									}
								},
								{
									title : '终端内部温度',
									field : 'ATemp',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.realtimedata) {
											return formatData(rowData.realtimedata.ATemp);
										}
									}
								},
								{
									title : '内部时钟 ',
									field : 'inBatteryVoltage',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.realtimedata) {
											return formatData(rowData.realtimedata.inBatteryVoltage);
										}
									}
								},
								{
									title : '外部电池电压',
									field : 'exBatteryVoltage',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.realtimedata) {
											return formatData(rowData.realtimedata.exBatteryVoltage);
										}
									}
								},
								{title: '客户编号', field: 'customercode', width:'120px'},
								{title: '单元地址', field: 'unitaddress', width:'100px'},
								{title: '系统类型', field: 'systemtype', width:'120px'},
								{title: '系统地址', field: 'systemaddress', width:'100px'},
								] ],
								onLoadSuccess:function(data){
									$('.button-edit').linkbutton({});
									if(data.total==0){
					                    var dc = $(this).data('datagrid').dc;
					                    var header2Row = dc.header2.find('tr.datagrid-header-row');
					                    dc.body2.find('table').append(header2Row.clone().css({"visibility":"hidden"}));
					                }
								}	
					});
	
	/*查询曲线数据（实时冻结）*/
	$('#elecurvetb').datagrid(
					{
						url : basePath + '/dataQuery/freezeDataInf?Math.random()',
						pagination : true,//分页控件
						pageList : [ 10, 20, 30, 40, 50 ],
						fit : true, //自适应大小
						singleSelect : true,
						border : false,
						nowrap : true,//数据长度超出列宽时将会自动截取。
						rownumbers : true,//行号
						fitColumns : true,//自动使列适应表格宽度以防止出现水平滚动。
						columns : [ [
								{
									title : 'ID',
									field : 'id',
									width : '100px',
									hidden : true
								},
								{
									title : '操作',
									field : 'content',
									width : '80px',
									formatter : function(value,
											rowData, rowIndex) {
										return "<a href='javascript:void(0)' class='button-edit button-default' onclick='curveDetail(&apos;"
												+ rowIndex
												+ "&apos;);'>详情</a> ";
									}
								},
								{title: '设备类型', field: 'equipmenttype', width:'150px'},
								{
									title : '设备地址',
									field : 'equipmentAddr',
									width : '124px',
									formatter : function(value,
											rowData, rowIndex) {
										return rowData.freezedatamsg.equipmentAddr;
									}
								},
								{
									title : '冻结时间',
									field : 'freezeTime',
									width : '140px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.freezedatamsg.efmsRealTimeData) {
											return rowData.freezedatamsg.freezeTime;
										}
									}
								},
								{
									title : '当前正向总电量',
									field : 'positiveElectricity',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										return formatData(rowData.freezedatamsg.efmsRealTimeData.positiveElectricity);
									}
								},
								{
									title : '当前正向A相电量 ',
									field : 'positiveElectricityA',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										return formatData(rowData.freezedatamsg.efmsRealTimeData.positiveElectricityA);
									}
								},
								{
									title : '当前正向B相电量',
									field : 'positiveElectricityB',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										return formatData(rowData.freezedatamsg.efmsRealTimeData.positiveElectricityB);
									}
								},
								{
									title : '当前正向C相电量',
									field : 'positiveElectricityC',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										return formatData(rowData.freezedatamsg.efmsRealTimeData.positiveElectricityC);
									}
								},
								{
									title : '当前反向总电量',
									field : 'reverseElectricity',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										return formatData(rowData.freezedatamsg.efmsRealTimeData.reverseElectricity);
									}
								},
								{
									title : '当前反向A相电量 ',
									field : 'reverseElectricityA',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										return formatData(rowData.freezedatamsg.efmsRealTimeData.reverseElectricityA);
									}
								},
								{
									title : '当前反向B相电量',
									field : 'reverseElectricityB',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										return formatData(rowData.freezedatamsg.efmsRealTimeData.reverseElectricityB);
									}
								},
								{
									title : '当前反向C相电量',
									field : 'reverseElectricityC',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										return formatData(rowData.freezedatamsg.efmsRealTimeData.reverseElectricityC);
									}
								},
								{
									title : 'A相电压',
									field : 'VA',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.freezedatamsg.efmsRealTimeData) {
											return formatData(rowData.freezedatamsg.efmsRealTimeData.VA);
										}
									}
								},
								{
									title : 'B相电压',
									field : 'VB',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.freezedatamsg.efmsRealTimeData) {
											return formatData(rowData.freezedatamsg.efmsRealTimeData.VB);
										}
									}
								},
								{
									title : 'C相电压',
									field : 'VC',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.freezedatamsg.efmsRealTimeData) {
											return formatData(rowData.freezedatamsg.efmsRealTimeData.VC);
										}
									}
								},
								{
									title : 'A相电流',
									field : 'AA',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.freezedatamsg.efmsRealTimeData) {
											return formatData(rowData.freezedatamsg.efmsRealTimeData.AA);
										}
									}
								},
								{
									title : 'B相电流',
									field : 'AB',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.freezedatamsg.efmsRealTimeData) {
											return formatData(rowData.freezedatamsg.efmsRealTimeData.AB);
										}
									}
								},
								{
									title : 'C相电流',
									field : 'AC',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.freezedatamsg.efmsRealTimeData) {
											return formatData(rowData.freezedatamsg.efmsRealTimeData.AC);
										}
									}
								},
								{
									title : '剩余电流',
									field : 'AOver',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.freezedatamsg.efmsRealTimeData) {
											return formatData(rowData.freezedatamsg.efmsRealTimeData.AOver);
										}
									}
								},
								{
									title : '总功率',
									field : 'Power',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.freezedatamsg.efmsRealTimeData) {
											return formatData(rowData.freezedatamsg.efmsRealTimeData.Power);
										}
									}
								},
								{
									title : 'A相功率',
									field : 'PowerA',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.freezedatamsg.efmsRealTimeData) {
											return formatData(rowData.freezedatamsg.efmsRealTimeData.PowerA);
										}
									}
								},
								{
									title : 'B相功率',
									field : 'PowerB',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.freezedatamsg.efmsRealTimeData) {
											return formatData(rowData.freezedatamsg.efmsRealTimeData.PowerB);
										}
									}
								},
								{
									title : 'C相功率',
									field : 'PowerC',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.freezedatamsg.efmsRealTimeData) {
											return formatData(rowData.freezedatamsg.efmsRealTimeData.PowerC);
										}
									}
								},
								{
									title : '总功率因素',
									field : 'PF',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.freezedatamsg.efmsRealTimeData) {
											return formatData(rowData.freezedatamsg.efmsRealTimeData.PF);
										}
									}
								},
								{
									title : 'A相功率因素',
									field : 'PFA',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
										if (null != rowData.freezedatamsg.efmsRealTimeData) {
											return formatData(rowData.freezedatamsg.efmsRealTimeData.PFA);
										}
									}
								},
								{
									title : 'B相功率因素',
									field : 'PFB',
									width : '100px',
									formatter : function(value,
											rowData, rowIndex) {
											if (null != rowData.freezedatamsg.efmsRealTimeData) {
												return formatData(rowData.freezedatamsg.efmsRealTimeData.PFB);
											}
										}
									},
									{
										title : 'C相功率因素',
										field : 'PFC',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											if (null != rowData.freezedatamsg.efmsRealTimeData) {
												return formatData(rowData.freezedatamsg.efmsRealTimeData.PFC);
											}
										}
									},
									{
										title : '频率',
										field : 'Frequency',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											if (null != rowData.freezedatamsg.efmsRealTimeData) {
												return formatData(rowData.freezedatamsg.efmsRealTimeData.Frequency);
											}
										}
									},
									{
										title : 'A相温度 ',
										field : 'tempA',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											if (null != rowData.freezedatamsg.efmsRealTimeData) {
												return formatData(rowData.freezedatamsg.efmsRealTimeData.tempA);
											}
										}
									},
									{
										title : 'B相温度',
										field : 'tempB',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											if (null != rowData.freezedatamsg.efmsRealTimeData) {
												return formatData(rowData.freezedatamsg.efmsRealTimeData.tempB);
											}
										}
									},
									{
										title : 'C相温度',
										field : 'tempC',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											if (null != rowData.freezedatamsg.efmsRealTimeData) {
												return formatData(rowData.freezedatamsg.efmsRealTimeData.tempC);
											}
										}
									},
									{
										title : '零线温度',
										field : 'NTemp',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											if (null != rowData.freezedatamsg.efmsRealTimeData) {
												return formatData(rowData.freezedatamsg.efmsRealTimeData.NTemp);
											}
										}
									},
									{
										title : '终端内部温度',
										field : 'ATemp',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											if (null != rowData.freezedatamsg.efmsRealTimeData) {
												return formatData(rowData.freezedatamsg.efmsRealTimeData.ATemp);
											}
										}
									},
									{
										title : '内部时钟 ',
										field : 'inBatteryVoltage',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											if (null != rowData.freezedatamsg.efmsRealTimeData) {
												return formatData(rowData.freezedatamsg.efmsRealTimeData.inBatteryVoltage);
											}
										}
									},
									{
										title : '外部电池电压',
										field : 'exBatteryVoltage',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											if (null != rowData.freezedatamsg.efmsRealTimeData) {
												return formatData(rowData.freezedatamsg.efmsRealTimeData.exBatteryVoltage);
											}
										}
									},
									{title: '客户编号', field: 'customercode', width:'120px'},
									{title: '单元地址', field: 'unitaddress', width:'100px'},
									{title: '系统类型', field: 'systemtype', width:'120px'},
									{title: '系统地址', field: 'systemaddress', width:'100px'},
									{
										title : '安装地点',
										field : 'buildingname',
										width : '100px'
									},
									 ] ],
									 onLoadSuccess:function(data){
											$('.button-edit').linkbutton({ 
											});
											if(data.total==0){
							                    var dc = $(this).data('datagrid').dc;
							                    var header2Row = dc.header2.find('tr.datagrid-header-row');
							                    dc.body2.find('table').append(header2Row.clone().css({"visibility":"hidden"}));
							                }
										},
						});
	
		//用电系统日冻结数据
		$('#elefreezetb').datagrid(
						{
							url : basePath + '/dataQuery/freezeDataInf?Math.random()',
							pagination : true,//分页控件
							pageList : [ 10, 20, 30, 40, 50 ],
							fit : true, //自适应大小
							singleSelect : true,
							border : false,
							nowrap : true,//数据长度超出列宽时将会自动截取。
							rownumbers : true,//行号
							fitColumns : true,//自动使列适应表格宽度以防止出现水平滚动。
							columns : [ [
									{
										title : 'ID',
										field : 'id',
										width : '100px',
										hidden : true
									},
									{
										title : '操作',
										field : 'content',
										width : '80px',
										formatter : function(value,
												rowData, rowIndex) {
											return "<a href='javascript:void(0)' class='button-edit button-default' onclick='eleFreezeDetail(&apos;"
													+ rowIndex
													+ "&apos;);'>详情</a> ";
										}
									},
									{title: '设备类型', field: 'equipmenttype', width:'150px'},
									{
										title : '设备地址',
										field : 'equipmentAddr',
										width : '124px',
										formatter : function(value,
												rowData, rowIndex) {
											return rowData.freezedatamsg.equipmentAddr;
										}
									},
									{
										title : '冻结时间',
										field : 'freezeTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return rowData.freezedatamsg.freezeTime;
										}
									},
									{
										title : '当前正向总电量',
										field : 'positiveElectricity',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.positiveElectricity);
										}
									},
									{
										title : '当前正向A相电量 ',
										field : 'positiveElectricityA',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.positiveElectricityA);
										}
									},
									{
										title : '当前正向B相电量',
										field : 'positiveElectricityB',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.positiveElectricityB);
										}
									},
									{
										title : '当前正向C相电量',
										field : 'positiveElectricityC',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.positiveElectricityC);
										}
									},
									{
										title : '当前反向总电量',
										field : 'reverseElectricity',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.reverseElectricity);
										}
									},
									{
										title : '当前反向A相电量 ',
										field : 'reverseElectricityA',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.reverseElectricityA);
										}
									},
									{
										title : '当前反向B相电量',
										field : 'reverseElectricityB',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.reverseElectricityB);
										}
									},
									{
										title : '当前反向C相电量',
										field : 'reverseElectricityC',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.reverseElectricityC);
										}
									},
									{title : '最大A相电压',field : 'maxVA',width : '100px',
										formatter : function(value,rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxVA);
										}
									},
									{title : '最大A相电压发生时间',field : 'maxVATime',width : '140px',
										formatter : function(value,rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxVATime);
										}
									},
									{title : '最大B相电压',field : 'maxVB',width : '100px',
										formatter : function(value,rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxVB);
										}
									},
									{title : '最大B相电压发生时间',field : 'maxVBTime',width : '140px',
										formatter : function(value,rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxVBTime);
										}
									},
									{title : '最大C相电压',field : 'maxVC',width : '100px',
										formatter : function(value,rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxVC);
										}
									},
									{title : '最大C相电压发生时间',field : 'maxVCTime',width : '140px',
										formatter : function(value,rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxVCTime);
										}
									},
									{title : '最小A相电压',field : 'minVA',width : '100px',
										formatter : function(value,rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minVA);
										}
									},
									{title : '最小A相电压发生时间',field : 'minVATime',width : '140px',
										formatter : function(value,rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minVATime);
										}
									},
									{title : '最小B相电压',field : 'minVB',width : '100px',
										formatter : function(value,rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minVB);
										}
									},
									{title : '最小B相电压发生时间',field : 'minVBTime',width : '140px',
										formatter : function(value,rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minVBTime);
										}
									},
									{title : '最小C相电压',field : 'minVC',width : '100px',
										formatter : function(value,rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minVC);
										}
									},
									{title : '最小C相电压发生时间',field : 'minVCTime',width : '140px',
										formatter : function(value,rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minVCTime);
										}
									},
									{
										title : '最大A相电流',
										field : 'maxAA',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxAA);
										}
									},
									{
										title : '最大A相电流发生时间',
										field : 'maxAATime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxAATime);
										}
									},
									{
										title : '最大B相电流',
										field : 'maxAB',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxAB);
										}
									},
									{
										title : '最大B相电流发生时间',
										field : 'maxABTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxABTime);
										}
									},
									{
										title : '最大C相电流',
										field : 'maxAC',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxAC);
										}
									},
									{
										title : '最大C相电流发生时间',
										field : 'maxACTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxACTime);
										}
									},
									{
										title : '最大剩余电流',
										field : 'maxAOver',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxAOver);
										}
									},
									{
										title : '最大剩余电流发生时间',
										field : 'maxAOverTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxAOverTime);
										}
									},
									{
										title : '最小A相电流',
										field : 'minAA',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minAA);
										}
									},
									{
										title : '最小A相电流发生时间',
										field : 'minAATime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minAATime);
										}
									},
									{
										title : '最小B相电流',
										field : 'minAB',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minAB);
										}
									},
									{
										title : '最小B相电流发生时间',
										field : 'minABTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minABTime);
										}
									},
									{
										title : '最小C相电流',
										field : 'minAC',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minAC);
										}
									},
									{
										title : '最小C相电流发生时间',
										field : 'minACTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minACTime);
										}
									},
									{
										title : '最小剩余电流',
										field : 'minAOver',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minAOver);
										}
									},
									{
										title : '最小剩余电流发生时间',
										field : 'minAOverTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minAOverTime);
										}
									},

									{
										title : '最大总功率',
										field : 'maxPower',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxPower);
										}
									},
									{
										title : '最大总功率发生时间',
										field : 'maxPowerTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxPowerTime);
										}
									},
									{
										title : '最大A相功率',
										field : 'maxPowerA',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxPowerA);
										}
									},
									{
										title : '最大A相功率发生时间',
										field : 'maxPowerATime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxPowerATime);
										}
									},
									{
										title : '最大B相功率',
										field : 'maxPowerB',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxPowerB);
										}
									},
									{
										title : '最大B相功率发生时间',
										field : 'maxPowerBTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxPowerBTime);
										}
									},
									{
										title : '最大C相功率',
										field : 'maxPowerC',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxPowerC);
										}
									},
									{
										title : '最大C相功率发生时间',
										field : 'maxPowerCTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxPowerCTime);
										}
									},
									{
										title : '最小总功率',
										field : 'minPower',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minPower);
										}
									},
									{
										title : '最小总功率发生时间',
										field : 'minPowerTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minPowerTime);
										}
									},
									{
										title : '最小A相功率',
										field : 'minPowerA',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minPowerA);
										}
									},
									{
										title : '最小A相功率发生时间',
										field : 'minPowerATime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minPowerATime);
										}
									},
									{
										title : '最小B相功率',
										field : 'minPowerB',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minPowerB);
										}
									},
									{
										title : '最小B相功率发生时间',
										field : 'minPowerBTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minPowerBTime);
										}
									},
									{
										title : '最小C相功率',
										field : 'minPowerC',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minPowerC);
										}
									},
									{
										title : '最小C相功率发生时间',
										field : 'minPowerCTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minPowerCTime);
										}
									},

									{
										title : '最大总功率因素',
										field : 'maxPF',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxPF);
										}
									},
									{
										title : '最大总功率因素发生时间',
										field : 'maxPFTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxPFTime);
										}
									},
									{
										title : '最大A相功率因素',
										field : 'maxPFA',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxPFA);
										}
									},
									{
										title : '最大A相功率因素发生时间',
										field : 'maxPFATime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxPFATime);
										}
									},
									{
										title : '最大B相功率因素',
										field : 'maxPFB',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxPFB);
										}
									},
									{
										title : '最大B相功率因素发生时间',
										field : 'maxPFBTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxPFBTime);
										}
									},
									{
										title : '最大C相功率因素',
										field : 'maxPFC',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxPFC);
										}
									},
									{
										title : '最大C相功率因素发生时间',
										field : 'maxPFCTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxPFCTime);
										}
									},
									{
										title : '最小总功率因素',
										field : 'minPF',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minPF);
										}
									},
									{
										title : '最小总功率因素发生时间',
										field : 'minPFTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minPFTime);
										}
									},
									{
										title : '最小A相功率因素',
										field : 'minPFA',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minPFA);
										}
									},
									{
										title : '最小A相功率因素发生时间',
										field : 'minPFATime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minPFATime);
										}
									},
									{
										title : '最小B相功率因素',
										field : 'minPFB',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minPFB);
										}
									},
									{
										title : '最小B相功率因素发生时间',
										field : 'minPFBTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minPFBTime);
										}
									},
									{
										title : '最小C相功率因素',
										field : 'minPFC',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minPFC);
										}
									},
									{
										title : '最小C相功率因素发生时间',
										field : 'minPFCTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minPFCTime);
										}
									},

									{
										title : '最大A相温度',
										field : 'maxTempA',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxTempA);
										}
									},
									{
										title : '最大A相温度发生时间',
										field : 'maxTempATime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxTempATime);
										}
									},
									{
										title : '最大B相温度',
										field : 'maxTempB',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxTempB);
										}
									},
									{
										title : '最大B相温度发生时间',
										field : 'maxTempBTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxTempBTime);
										}
									},
									{
										title : '最大C相温度',
										field : 'maxTempC',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxTempC);
										}
									},
									{
										title : '最大C相温度发生时间',
										field : 'maxTempCTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxTempCTime);
										}
									},
									{
										title : '最大零线温度',
										field : 'maxNTemp',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxNTemp);
										}
									},
									{
										title : '最大零线温度发生时间',
										field : 'maxNTempTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxNTempTime);
										}
									},
									{
										title : '最大终端内部温度',
										field : 'maxATemp',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxATemp);
										}
									},
									{
										title : '最大终端内部温度发生时间',
										field : 'maxATempTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.maxATempTime);
										}
									},

									{
										title : '最小A相温度',
										field : 'minTempA',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minTempA);
										}
									},
									{
										title : '最小A相温度发生时间',
										field : 'minTempATime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minTempATime);
										}
									},
									{
										title : '最小B相温度',
										field : 'minTempB',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minTempB);
										}
									},
									{
										title : '最小B相温度发生时间',
										field : 'minTempBTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minTempBTime);
										}
									},
									{
										title : '最小C相温度',
										field : 'minTempC',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minTempC);
										}
									},
									{
										title : '最小C相温度发生时间',
										field : 'minTempCTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minTempCTime);
										}
									},
									{
										title : '最小零线温度',
										field : 'minNTemp',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minNTemp);
										}
									},
									{
										title : '最小零线温度发生时间',
										field : 'minNTempTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minNTempTime);
										}
									},
									{
										title : '最小终端内部温度',
										field : 'minATemp',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minATemp);
										}
									},
									{
										title : '最小终端内部温度发生时间',
										field : 'minATempTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											return formatData(rowData.freezedatamsg.efmsFreezeData.minATempTime);
										}
									},
									{title: '客户编号', field: 'customercode', width:'120px'},
									{title: '单元地址', field: 'unitaddress', width:'100px'},
									{title: '系统类型', field: 'systemtype', width:'120px'},
									{title: '系统地址', field: 'systemaddress', width:'100px'},
									{
										title : '安装地点',
										field : 'buildingname',
										width : '100px'
									},
									] ],
									onLoadSuccess:function(data){
										$('.button-edit').linkbutton({ 
										});
										if(data.total==0){
						                    var dc = $(this).data('datagrid').dc;
						                    var header2Row = dc.header2.find('tr.datagrid-header-row');
						                    dc.body2.find('table').append(header2Row.clone().css({"visibility":"hidden"}));
						                }
									},
						});
		
		//水气烟感系统冻结数据(冻结类型3，4，5)
		$('#wgstb').datagrid(
						{
							url : basePath + '/dataQuery/freezeDataInf?Math.random()',
							pagination : true,//分页控件
							pageList : [ 10, 20, 30, 40, 50 ],
							fit : true, //自适应大小
							singleSelect : true,
							border : false,
							nowrap : true,//数据长度超出列宽时将会自动截取。
							rownumbers : true,//行号
							fitColumns : true,//自动使列适应表格宽度以防止出现水平滚动。
							columns : [ [
									{
										title : 'ID',
										field : 'id',
										width : '100px',
										hidden : true
									},
									{title: '设备类型', field: 'equipmenttype', width:'100px'},
									{
										title : '设备地址 ',
										field : 'equipmentAddr',
										width : '124px',
										formatter : function(value,
												rowData, rowIndex) {
												return rowData.freezedatamsg.equipmentAddr;
										}
									},
									/* {
										title : '冻结类型',
										field : 'freezeTypeCode',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											if (rowData.freezeTypeCode == 3) {
												return "气";
											} else if (rowData.freezeTypeCode == 4) {
												return "烟";
											} else if (rowData.freezeTypeCode == 5) {
												return "水";
											}
										}
									}, */
									{
										title : '冻结时间',
										field : 'freezeTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											
												return rowData.freezedatamsg.freezeTime;
										}
									},
									{
										title : '最大值',
										field : 'maxGasConcentration',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											if (rowData.freezeTypeCode == 3) {
												return formatData(rowData.freezedatamsg.cgasFreezeData.maxGasConcentration);
											} else if (rowData.freezeTypeCode == 4) {
												return formatData(rowData.freezedatamsg.fsdsFreezeData.maxSmokeConcentration);
											} else if (rowData.freezeTypeCode == 5) {
												return formatData(rowData.freezedatamsg.fhsFreezeData.maxWaterPressure);
											}
										}
									},
									{
										title : '最大值发生时间 ',
										field : 'maxConcentrationTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											if (rowData.freezeTypeCode == 3) {
												return formatData(rowData.freezedatamsg.cgasFreezeData.maxConcentrationTime);
											} else if (rowData.freezeTypeCode == 4) {
												return formatData(rowData.freezedatamsg.fsdsFreezeData.maxConcentrationTime);
											} else if (rowData.freezeTypeCode == 5) {
												return formatData(rowData.freezedatamsg.fhsFreezeData.maxPressureTime);
											}
										}
									},
									{
										title : '最小值',
										field : 'minGasConcentration',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											if (rowData.freezeTypeCode == 3) {
												return formatData(rowData.freezedatamsg.cgasFreezeData.minGasConcentration);
											} else if (rowData.freezeTypeCode == 4) {
												return formatData(rowData.freezedatamsg.fsdsFreezeData.minSmokeConcentration);
											} else if (rowData.freezeTypeCode == 5) {
												return formatData(rowData.freezedatamsg.fhsFreezeData.minWaterPressure);
											}
										}
									},
									{
										title : '最小值发生时间',
										field : 'minConcentrationTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
											if (rowData.freezeTypeCode == 3) {
												return formatData(rowData.freezedatamsg.cgasFreezeData.minConcentrationTime);
											} else if (rowData.freezeTypeCode == 4) {
												return formatData(rowData.freezedatamsg.fsdsFreezeData.minConcentrationTime);
											} else if (rowData.freezeTypeCode == 5) {
												return formatData(rowData.freezedatamsg.fhsFreezeData.minPressureTime);
											}
										}
									},
									{
										title : '电池电压',
										field : 'batteryVoltage',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
											if (rowData.freezeTypeCode == 3) {
												return formatData(rowData.freezedatamsg.cgasFreezeData.batteryVoltage);
											} else if (rowData.freezeTypeCode == 4) {
												return formatData(rowData.freezedatamsg.fsdsFreezeData.batteryVoltage);
											} else if (rowData.freezeTypeCode == 5) {
												return formatData(rowData.freezedatamsg.fhsFreezeData.batteryVoltage);
											}
										}
									},
									{title: '客户编号', field: 'customercode', width:'120px'},
									{title: '单元地址', field: 'unitaddress', width:'100px'},
									{title: '系统类型', field: 'systemtype', width:'120px'},
									{title: '系统地址', field: 'systemaddress', width:'100px'},
									{
										title : '安装地点',
										field : 'buildingname',
										width : '100px'
									},
									] ],
									onLoadSuccess:function(data){
										$('.button-edit').linkbutton({ 
										});
										if(data.total==0){
						                    var dc = $(this).data('datagrid').dc;
						                    var header2Row = dc.header2.find('tr.datagrid-header-row');
						                    dc.body2.find('table').append(header2Row.clone().css({"visibility":"hidden"}));
						                }
									},
						});
		
		//报警按钮及声光报警器冻结数据(冻结类型6)
		$('#aavatb').datagrid(
						{
							url : basePath + '/dataQuery/freezeDataInf?Math.random()',
							pagination : true,//分页控件
							pageList : [ 10, 20, 30, 40, 50 ],
							fit : true, //自适应大小
							singleSelect : true,
							border : false,
							nowrap : true,//数据长度超出列宽时将会自动截取。
							rownumbers : true,//行号
							fitColumns : true,//自动使列适应表格宽度以防止出现水平滚动。
							columns : [ [
									{
										title : 'ID',
										field : 'id',
										width : '100px',
										hidden : true
									},
									{title: '设备类型', field: 'equipmenttype', width:'100px'},
									{
										title : '设备地址 ',
										field : 'equipmentAddr',
										width : '124px',
										formatter : function(value,
												rowData, rowIndex) {
												return rowData.freezedatamsg.equipmentAddr;
										}
									},
									{
										title : '冻结时间',
										field : 'freezeTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
												return rowData.freezedatamsg.freezeTime;
										}
									},
									{title : '状态',field : 'powerSupplyMode',width : '100px',
										formatter : function(value,rowData, rowIndex) {
											var powerSupplyMode = rowData.freezedatamsg.aavaFreezeData.powerSupplyMode;
											return getAavaState(powerSupplyMode,rowData.freezedatamsg.equipmentCode);												
										}
									},
									{
										title : '电池电压',
										field : 'batteryVoltage',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
												return formatData(rowData.freezedatamsg.aavaFreezeData.batteryVoltage);
										}
									},
									{title: '客户编号', field: 'customercode', width:'120px'},
									{title: '单元地址', field: 'unitaddress', width:'100px'},
									{title: '系统类型', field: 'systemtype', width:'150px'},
									{title: '系统地址', field: 'systemaddress', width:'100px'},
									{
										title : '安装地点',
										field : 'buildingname',
										width : '100px'
									},
									] ],
									onLoadSuccess:function(data){
										$('.button-edit').linkbutton({ 
										});
										if(data.total==0){
						                    var dc = $(this).data('datagrid').dc;
						                    var header2Row = dc.header2.find('tr.datagrid-header-row');
						                    dc.body2.find('table').append(header2Row.clone().css({"visibility":"hidden"}));
						                }
									},
						});

		//消防水位监控系统（冻结类型=7）
		$('#flmstb').datagrid(
						{
							url : basePath + '/dataQuery/freezeDataInf?Math.random()',
							pagination : true,//分页控件
							pageList : [ 10, 20, 30, 40, 50 ],
							fit : true, //自适应大小
							singleSelect : true,
							border : false,
							nowrap : true,//数据长度超出列宽时将会自动截取。
							rownumbers : true,//行号
							fitColumns : true,//自动使列适应表格宽度以防止出现水平滚动。
							columns : [ [
									{
										title : 'ID',
										field : 'id',
										width : '100px',
										hidden : true
									},
									{title: '设备类型', field: 'equipmenttype', width:'100px'},
									{
										title : '设备地址 ',
										field : 'equipmentAddr',
										width : '124px',
										formatter : function(value,
												rowData, rowIndex) {
												return rowData.freezedatamsg.equipmentAddr;
										}
									},
									{
										title : '冻结时间',
										field : 'freezeTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
												return rowData.freezedatamsg.freezeTime;
										}
									},
									{title : '水位最大值',field : 'maxWaterLevel',width : '140px',
										formatter : function(value,rowData, rowIndex) {
												return rowData.freezedatamsg.flmsFreezeData.maxWaterLevel;
										}
									},
									{title : '水位最大值发送时间',field : 'maxWaterLevelTime',width : '140px',
										formatter : function(value,rowData, rowIndex) {
												return rowData.freezedatamsg.flmsFreezeData.maxWaterLevelTime;
										}
									},
									{title : '水位最小值 ',field : 'minWaterLevel',width : '140px',
										formatter : function(value,rowData, rowIndex) {
												return rowData.freezedatamsg.flmsFreezeData.minWaterLevel;
										}
									},
									{title : '水位最小值发送时间',field : 'minWaterLevelTime',width : '140px',
										formatter : function(value,rowData, rowIndex) {
												return rowData.freezedatamsg.flmsFreezeData.minWaterLevelTime;
										}
									},
									{
										title : '电池电压',
										field : 'batteryVoltage',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
												return formatData(rowData.freezedatamsg.flmsFreezeData.batteryVoltage);
										}
									},
									{title: '客户编号', field: 'customercode', width:'120px'},
									{title: '单元地址', field: 'unitaddress', width:'100px'},
									{title: '系统类型', field: 'systemtype', width:'120px'},
									{title: '系统地址', field: 'systemaddress', width:'100px'},
									{
										title : '安装地点',
										field : 'buildingname',
										width : '100px'
									},
									] ],
									onLoadSuccess:function(data){
										$('.button-edit').linkbutton({ 
										});
										if(data.total==0){
						                    var dc = $(this).data('datagrid').dc;
						                    var header2Row = dc.header2.find('tr.datagrid-header-row');
						                    dc.body2.find('table').append(header2Row.clone().css({"visibility":"hidden"}));
						                }
									},
						});
		
		//防火卷级防火门监控系统（冻结类型=8）
		$('#fdmstb').datagrid(
						{
							url : basePath + '/dataQuery/freezeDataInf?Math.random()',
							pagination : true,//分页控件
							pageList : [ 10, 20, 30, 40, 50 ],
							fit : true, //自适应大小
							singleSelect : true,
							border : false,
							nowrap : true,//数据长度超出列宽时将会自动截取。
							rownumbers : true,//行号
							fitColumns : true,//自动使列适应表格宽度以防止出现水平滚动。
							columns : [ [
									{
										title : 'ID',
										field : 'id',
										width : '100px',
										hidden : true
									},
									{
										title : '冻结时间',
										field : 'freezeTime',
										width : '140px',
										formatter : function(value,
												rowData, rowIndex) {
												return rowData.freezedatamsg.freezeTime;
										}
									},
									{
										title : '防火门状态',
										field : 'strFireDoorState',
										width : '100px',
										formatter : function(value,rowData, rowIndex) {
											var strFireDoorState = rowData.freezedatamsg.fdmsFreezeData.strFireDoorState
											if(""!=strFireDoorState){
												return getAavaState(strFireDoorState,131)
											}else{
												return strFireDoorState;
											}
										}
									},
									{
										title : '电池电压',
										field : 'batteryVoltage',
										width : '100px',
										formatter : function(value,
												rowData, rowIndex) {
												return formatData(rowData.freezedatamsg.fdmsFreezeData.batteryVoltage);
										}
									},
									{title: '客户编号', field: 'customercode', width:'120px'},
									{title: '单元地址', field: 'unitaddress', width:'100px'},
									{title: '系统类型', field: 'systemtype', width:'120px'},
									{title: '系统地址', field: 'systemaddress', width:'100px'},
									{title: '设备类型', field: 'equipmenttype', width:'100px'},
									{
										title : '设备地址 ',
										field : 'equipmentAddr',
										width : '124px',
										formatter : function(value,
												rowData, rowIndex) {
												return rowData.freezedatamsg.equipmentAddr;
										}
									},
									{
										title : '安装地点',
										field : 'buildingname',
										width : '100px'
									},
									] ],
									onLoadSuccess:function(data){
										$('.button-edit').linkbutton({ 
										});
										if(data.total==0){
						                    var dc = $(this).data('datagrid').dc;
						                    var header2Row = dc.header2.find('tr.datagrid-header-row');
						                    dc.body2.find('table').append(header2Row.clone().css({"visibility":"hidden"}));
						                }
									},
						});
}

function evaluation() {
	//查询条件 赋值
	$("#type").val(node.type);
	$("#datanode").html(node.text);
	
	$('#dataTab').tabs('getTab',"报警数据").panel('options').tab.hide(); 
    $('#dataTab').tabs('getTab',"设备故障").panel('options').tab.hide(); 
    $('#dataTab').tabs('getTab',"消息推送").panel('options').tab.hide(); 
    $('#dataTab').tabs('getTab',"用电系统当前数据").panel('options').tab.hide(); 
    $('#dataTab').tabs('getTab',"用电系统曲线数据").panel('options').tab.hide(); 
    $('#dataTab').tabs('getTab',"用电系统日冻结数据").panel('options').tab.hide(); 
    $('#dataTab').tabs('getTab',"水气烟感系统日冻结数据").panel('options').tab.hide(); 
    $('#dataTab').tabs('getTab',"报警按钮及声光报警器日冻结数据").panel('options').tab.hide();
    $('#dataTab').tabs('getTab',"消防水位监控系统日冻结数据").panel('options').tab.hide();
    $('#dataTab').tabs('getTab',"防火卷级防火门监控系统日冻结数据").panel('options').tab.hide();
	
	if (node.type == commonTreeNodeType.terminal) {//终端
		$("#unitid").val(node.gid);
		$("#equipmentid").val("");

		$("#selectedID").val(node.gid);
	    $("#selectedType").val(node.type);
	    
	    $('#dataTab').tabs('getTab',"报警数据").panel('options').tab.show(); 
        $('#dataTab').tabs('getTab',"设备故障").panel('options').tab.show(); 
        $('#dataTab').tabs('getTab',"消息推送").panel('options').tab.show(); 
		
		var data,json;
        data = [];
        data.push({ "text": "所有", "id": 255 });
        data.push({ "text": "A相过压", "id": 1 });
        data.push({ "text": "B相过压", "id": 2 });
        data.push({ "text": "C相过压", "id": 3 });
        data.push({ "text": "A相欠压", "id": 4 });
        data.push({ "text": "B相欠压", "id": 5 });
        data.push({ "text": "C相欠压", "id": 6 });
        data.push({ "text": "A相过流", "id": 7 });
        data.push({ "text": "B相过流", "id": 8 });
        data.push({ "text": "C相过流", "id": 9 });
        data.push({ "text": "A相过载", "id": 10 });
        data.push({ "text": "B相过载", "id": 11 });
        data.push({ "text": "C相过载", "id": 12 });
        data.push({ "text": "A相功率因数超限", "id": 13 });
        data.push({ "text": "B相功率因数超限", "id": 14 });
        data.push({ "text": "C相功率因数超限", "id": 15 });
        data.push({ "text": "停电", "id": 16 });
        data.push({ "text": "时钟电池欠压", "id": 17 });
        data.push({ "text": "抄表电池欠压", "id": 18 });
        data.push({ "text": "A相过温", "id": 50 });
        data.push({ "text": "B相过温", "id": 51 });
        data.push({ "text": "C相过温", "id": 52 });
        data.push({ "text": "N相过温", "id": 53 });
        data.push({ "text": "剩余电流超", "id": 60 });
        
        data.push({ "text": "水压过压", "id": 70});
        data.push({ "text": "水压欠压", "id": 71 });
        data.push({ "text": "水压监测电池欠压", "id": 72 });
        data.push({ "text": "水压监测测试", "id": 73 });

        data.push({ "text": "烟感报警", "id": 80});
        data.push({ "text": "烟感报警电池欠压", "id": 81 });
        data.push({ "text": "烟感报警测试", "id": 82 });
        
        data.push({ "text": "燃气报警", "id": 90});
        //data.push({ "text": "燃气报警电池欠压", "id": 91 });
        data.push({ "text": "燃气报警测试", "id": 92 });
        data.push({ "text": "燃气开阀", "id": 93 });
        data.push({ "text": "燃气关阀", "id": 94 });
        data.push({ "text": "燃气故障", "id": 95 });
        
        data.push({ "text": "报警按钮", "id": 100 });
        data.push({ "text": "报警按钮电池欠压", "id": 101 });
        data.push({ "text": "报警按钮测试", "id":102  });
        
        data.push({ "text": "声光报警器报警", "id":110  });
        data.push({ "text": "声光报警器电池欠压", "id":111  });
        data.push({ "text": "声光报警器测试", "id":112  });
        
        data.push({ "text": "超水位报警", "id":120  });
        data.push({ "text": "低水位报警", "id":121  });
        data.push({ "text": "水位监测电池欠压", "id":122  });
        data.push({ "text": "水位监测测试", "id":123 });
        
        data.push({ "text": "消防栓按钮报警", "id":130  });
        data.push({ "text": "消防栓按钮电池欠压", "id":131  });
        data.push({ "text": "消防栓按钮测试", "id":132  });
        
        data.push({ "text": "消防门启动", "id":140  });
        data.push({ "text": "消防门电池欠压", "id": 141 });
        data.push({ "text": "消防门测试", "id":142  });
        
        data.push({ "text": "消音命令", "id":254  });
        
        
        $("#eventtype").combobox("loadData", data);
        
	} else if (node.type == commonTreeNodeType.terminalDevice 
			|| node.type == commonTreeNodeType.gprsDevice) {//设备

		$("#unitid").val("");
		$("#equipmentid").val(node.gid);
		$("#eventtype").combobox("clear");
		
		$("#selectedID").val(node.gid);
	    $("#selectedType").val(node.type);
        $("#selectedParentid").val(pp_node.gid);

		//根据设备id获取系统类型
		$.ajax({
			type : 'POST',
			url : basePath + '/dataQuery/getSystemTypebyid',
			data : {
				equipmentid : node.gid
			},
			success : function(d) {
				if (d != "") {
					 var tab = $('#dataTab').tabs('getSelected');
			         var index = $('#dataTab').tabs('getTabIndex',tab);
					//判断系统类型
					$("#systemtype").val(d);
					switch(d){
			        case '10': //电气火灾监控系统
			            $('#dataTab').tabs('getTab',"报警数据").panel('options').tab.show(); 
			            $('#dataTab').tabs('getTab',"设备故障").panel('options').tab.show(); 
			            $('#dataTab').tabs('getTab',"消息推送").panel('options').tab.show(); 
			            $('#dataTab').tabs('getTab',"用电系统当前数据").panel('options').tab.show(); 
			            $('#dataTab').tabs('getTab',"用电系统曲线数据").panel('options').tab.show(); 
			            $('#dataTab').tabs('getTab',"用电系统日冻结数据").panel('options').tab.show(); 
			            if(index==0||index==1||index==2||index==3){
			            		$('#dataTab').tabs('select',index);//根据索引选中tab
			            	}else{
			            		$('#dataTab').tabs('select',0);//根据索引选中tab
			            }
			            var data = [];
			            data.push({ "text": "所有", "id": 255 });
			            data.push({ "text": "A相过压", "id": 1 });
			            data.push({ "text": "B相过压", "id": 2 });
			            data.push({ "text": "C相过压", "id": 3 });
			            data.push({ "text": "A相欠压", "id": 4 });
			            data.push({ "text": "B相欠压", "id": 5 });
			            data.push({ "text": "C相欠压", "id": 6 });
			            data.push({ "text": "A相过流", "id": 7 });
			            data.push({ "text": "B相过流", "id": 8 });
			            data.push({ "text": "C相过流", "id": 9 });
			            data.push({ "text": "A相过载", "id": 10 });
			            data.push({ "text": "B相过载", "id": 11 });
			            data.push({ "text": "C相过载", "id": 12 });
			            data.push({ "text": "A相功率因数超限", "id": 13 });
			            data.push({ "text": "B相功率因数超限", "id": 14 });
			            data.push({ "text": "C相功率因数超限", "id": 15 });
			            data.push({ "text": "停电", "id": 16 });
			            data.push({ "text": "时钟电池欠压", "id": 17 });
				        data.push({ "text": "抄表电池欠压", "id": 18 });
			            data.push({ "text": "A相过温", "id": 50 });
			            data.push({ "text": "B相过温", "id": 51 });
			            data.push({ "text": "C相过温", "id": 52 });
			            data.push({ "text": "N相过温", "id": 53 });
			            data.push({ "text": "剩余电流超", "id": 60 });
			            data.push({ "text": "消音命令", "id":254  });
			            $("#eventtype").combobox("loadData", data);
			        	break;
			        case '11': //可燃气体报警系统
			        case '128': //烟雾监控系统
			        case '129': //消防水压监控系统
			        	var data= [];
			            if(d=='11'){
			            	//GPRS设备不支持“所有”查询
			               if(node.type != commonTreeNodeType.gprsDevice)
			                  data.push({ "text": "所有", "id": 255 });
			               
			            	data.push({ "text": "燃气报警", "id": 90});
				           // data.push({ "text": "燃气报警电池欠压", "id": 91 });
					        data.push({ "text": "燃气报警测试", "id": 92 });
					        data.push({ "text": "燃气开阀", "id": 93 });
					        data.push({ "text": "燃气关阀", "id": 94 });
					        data.push({ "text": "燃气故障", "id": 95 });
					        
			            }else if(d=='128'){
			            	data.push({ "text": "所有", "id": 255 });
			            	data.push({ "text": "烟感报警", "id": 80});
				            data.push({ "text": "烟感报警电池欠压", "id": 81 });
				            data.push({ "text": "烟感报警测试", "id": 82 });
			            }else if(d=='129'){
			            	data.push({ "text": "所有", "id": 255 });
			            	data.push({ "text": "水压过压", "id": 70});
					        data.push({ "text": "水压欠压", "id": 71 });
					        data.push({ "text": "水压监测电池欠压", "id": 72 });
					        data.push({ "text": "水压监测测试", "id": 73 });
			            }
			            $("#eventtype").combobox("loadData", data);
			            
			            $('#dataTab').tabs('getTab',"报警数据").panel('options').tab.show();
			            if(node.type == commonTreeNodeType.gprsDevice) 
			            	$('#dataTab').tabs('getTab',"消息推送").panel('options').tab.show();
			            $('#dataTab').tabs('getTab',"水气烟感系统日冻结数据").panel('options').tab.show(); 
			            if(index==0||index==4){
		            		$('#dataTab').tabs('select',index);//根据索引选中tab
		            	}else{
		            		$('#dataTab').tabs('select',0);//根据索引选中tab
		            	}
			            break;
			        case '130': //报警按钮及声光报警器系统
			        	var data= [];
			            data.push({ "text": "所有", "id": 255 });
			            data.push({ "text": "报警按钮", "id": 100 });
				        data.push({ "text": "报警按钮电池欠压", "id": 101 });
				        data.push({ "text": "报警按钮测试", "id":102  });
				        
				        data.push({ "text": "声光报警器报警", "id":110  });
				        data.push({ "text": "声光报警器电池欠压", "id":111  });
				        data.push({ "text": "声光报警器测试", "id":112  });
			            $("#eventtype").combobox("loadData", data);
			            
			            $('#dataTab').tabs('getTab',"报警数据").panel('options').tab.show(); 
			            $('#dataTab').tabs('getTab',"报警按钮及声光报警器日冻结数据").panel('options').tab.show();
			            if(index==0||index==5){
		            		$('#dataTab').tabs('select',index);//根据索引选中tab
		            	}else{
		            		$('#dataTab').tabs('select',5);//根据索引选中tab
		            	}
			            break;
			        case '131': //消防水位监控系统
			        	var data= [];
			        	data.push({ "text": "所有", "id": 255 });
				        data.push({ "text": "超水位报警", "id":120  });
				        data.push({ "text": "低水位报警", "id":121  });
				        data.push({ "text": "水位监测电池欠压", "id":122  });
				        data.push({ "text": "水位监测测试", "id":123 });
			            $("#eventtype").combobox("loadData", data);
			            
			        	$('#dataTab').tabs('getTab',"报警数据").panel('options').tab.show(); 
			            $('#dataTab').tabs('getTab',"消防水位监控系统日冻结数据").panel('options').tab.show();
			            if(index==0||index==6){
		            		$('#dataTab').tabs('select',index);//根据索引选中tab
		            	}else{
		            		$('#dataTab').tabs('select',0);//根据索引选中tab
		            	}
			            break;
			        case '18': //防火门及防火卷帘系统
			        	var data= [];
			        	data.push({ "text": "所有", "id": 255 });
			        	data.push({ "text": "消防门启动", "id":140  });
				        data.push({ "text": "消防门电池欠压", "id": 141 });
				        data.push({ "text": "消防门测试", "id":142  });
			            $("#eventtype").combobox("loadData", data);
			            
			            
		        	 	$('#dataTab').tabs('getTab',"报警数据").panel('options').tab.show();
			            $('#dataTab').tabs('getTab',"防火卷级防火门监控系统日冻结数据").panel('options').tab.show();
			            
			            if(index==0||index==7){
		            		$('#dataTab').tabs('select',index);//根据索引选中tab
		            	}else{
		            		$('#dataTab').tabs('select',0);//根据索引选中tab
		            	}
			            break;
			        case '20': //消火栓系统
			        	var data= [];
			        	data.push({ "text": "所有", "id": 255 });
				        data.push({ "text": "消防栓按钮报警", "id":130  });
				        data.push({ "text": "消防栓按钮电池欠压", "id":131  });
				        data.push({ "text": "消防栓按钮测试", "id":132  });
			            $("#eventtype").combobox("loadData", data);
			            
			        	$('#dataTab').tabs('getTab',"报警数据").panel('options').tab.show();
			            
		            	$('#dataTab').tabs('select',0);//根据索引选中tab
			            break;
			        }
				}
			}
		});
	}
}

//获取报警按钮和声光报警器状态（状态字解析）
function getAavaState(str,equipmentCode){
	var result="";
	if(equipmentCode==82){//声光报警器状态((bit0=1：报警状态 bit0=0：关闭状态) (bit1=1：电池供电)(bit1=0：市电供电))
		str = padStr(parseInt(str,16).toString(2),3);
		var bit0 = str.split("")[2];
		var bit1 = str.split("")[1];
		var bit2 = str.split("")[0];
		switch(bit0){
			case "1":
				result = result+"远程报警开</br>";
				break;
			case "0":
				result = result+"远程报警关</br>";
				break;
			default:
				break;
		}
		switch(bit1){
			case "1":
				result = result+"电池供电 </br>";
				break;
			case "0":
				result = result+"市电供电</br>";
				break;
			default:
				break;
		}
		switch(bit2){
		case "1":
			result = result+"本地报警开";
			break;
		case "0":
			result = result+"本地报警关";
			break;
		default:
			break;
	}
		return result;
	}else if(equipmentCode==61){//火灾报警按钮报警按钮状态(bit0=1:开状态 bit1=1:关状态)
		str = padStr(parseInt(str,16).toString(2),2);
		if(str.split("")[1]=="1"){
			return "开状态";
		}else if(str.split("")[0]=="1"){
			return "关状态";
		}else{
			return str;
		}
	}else if(equipmentCode==131){//防火门
		str = padStr(parseInt(str,16).toString(2),2);
		var bit0 = powerSupplyMode.split("")[1];
		var bit1 = powerSupplyMode.split("")[0];
		switch(bit0){
			case "1":
				result = result+"开状态";
				break;
			case "0":
				result = result+"关状态";
				break;
			default:
				break;
		}
		switch(bit1){
			case "1":
				result = result+"电池供电";
				break;
			case "0":
				result = result+"市电供电";
				break;
			default:
				break;
		}
		return result;
	}
	else{
		return str;
	}	
}

//告警数据明细
function alarmDataDetail(rowIndex){
	$("#DataDetail").html("");
	var content = "";
	var rows = $('#unitalarmtb').datagrid('getRows');    // get current page rows
	var row = rows[rowIndex];    // your row data
	var th = "<tr><th>项目</th><th>数据内容</th><th>单位</th></tr>"
	var th2 = "<tr><th>项目</th><th>数据内容</th></tr>"
	if(row){
			switch (row.eventrecord.eventTypeCode) {
			case 1:
	    	case 2:
	    	case 3:
	    	case 4:
	    	case 5:
	    	case 6:
	    		content = 
	    		 "<table class='bordered'>"+th+"<tr><td>终端地址</td><td>"+row.eventrecord.equipmentAddr+"</td><td></td></tr>"+
	    		 "<tr><td>发生时间</td><td>"+row.eventrecord.startTime+"</td><td></td></tr>"+
	    		 "<tr><td>起始A相电压</td><td>"+formatData(row.eventrecord.voltageData.startVoltageA)+"</td><td>V</td></tr>"+
	    		 "<tr><td>起始B相电压</td><td>"+formatData(row.eventrecord.voltageData.startVoltageB)+"</td><td>V</td></tr>"+
	    		 "<tr><td>起始C相电压</td><td>"+formatData(row.eventrecord.voltageData.startVoltageC)+"</td><td>V</td></tr>"+
	    		 "<tr><td>结束时间</td><td>"+row.eventrecord.endTime+"</td><td></td></tr>"+
	    		 "<tr><td>结束A相电压</td><td>"+formatData(row.eventrecord.voltageData.endVoltageA)+"</td><td>V</td></tr>"+
	    		 "<tr><td>结束B相电压</td><td>"+formatData(row.eventrecord.voltageData.endVoltageB)+"</td><td>V</td></tr>"+
	    		 "<tr><td>结束C相电压</td><td>"+formatData(row.eventrecord.voltageData.endVoltageC)+"</td><td>V</td></tr></table>";
				break;
			case 7:
		  	case 8:
		  	case 9:
	    		content = 
		    		 "<table class='bordered'>"+th+"<tr><td>终端地址 </td><td>"+row.eventrecord.equipmentAddr+"</td><td></td></tr>"+
		    		 "<tr><td>发生时间</td><td>"+row.eventrecord.startTime+"</td><td></td></tr>"+
		    		 "<tr><td>起始A相电流</td><td>"+formatData(row.eventrecord.currentData.startCurrentA)+"</td><td>A</td></tr>"+
		    		 "<tr><td>起始B相电流</td><td>"+formatData(row.eventrecord.currentData.startCurrentB)+"</td><td>A</td></tr>"+
		    		 "<tr><td>起始C相电流</td><td>"+formatData(row.eventrecord.currentData.startCurrentC)+"</td><td>A</td></tr>"+
		    		 "<tr><td>结束时间</td><td>"+row.eventrecord.endTime+"</td><td></td></tr>"+
		    		 "<tr><td>结束A相电流</td><td>"+formatData(row.eventrecord.currentData.endCurrentA)+"</td><td>A</td></tr>"+
		    		 "<tr><td>结束B相电流</td><td>"+formatData(row.eventrecord.currentData.endCurrentB)+"</td><td>A</td></tr>"+
		    		 "<tr><td>结束C相电流</td><td>"+formatData(row.eventrecord.currentData.endCurrentC)+"</td><td>A</td></tr></table>";
				break;
			case 10:
		  	case 11:
		  	case 12:
		  		content = 
		    		"<table class='bordered'>"+th+"<tr><td>终端地址 </td><td>"+row.eventrecord.equipmentAddr+"</td><td></td></tr>"+
		    		"<tr><td>发生时间</td><td>"+row.eventrecord.startTime+"</td><td></td></tr>"+
		    		"<tr><td>起始A相功率</td><td>"+formatData(row.eventrecord.powerData.startPowerA)+"</td><td>KW</td></tr>"+
		    		"<tr><td>起始B相功率</td><td>"+formatData(row.eventrecord.powerData.startPowerB)+"</td><td>KW</td></tr>"+
		    		"<tr><td>起始C相功率</td><td>"+formatData(row.eventrecord.powerData.startPowerC)+"</td><td>KW</td></tr>"+
		    		"<tr><td>结束时间</td><td>"+row.eventrecord.endTime+"</td><td></td></tr>"+
		    		"<tr><td>结束A相功率</td><td>"+formatData(row.eventrecord.powerData.endPowerA)+"</td><td>KW</td></tr>"+
		    		"<tr><td>结束B相功率</td><td>"+formatData(row.eventrecord.powerData.endPowerB)+"</td><td>KW</td></tr>"+
		    		"<tr><td>结束C相功率</td><td>"+formatData(row.eventrecord.powerData.endPowerC)+"</td><td>KW</td></tr></table>";
				break;
		  	case 13:
		  	case 14:
		  	case 15:
		  		content = 
		    		"<table class='bordered'>"+th2+"<tr><td>终端地址 </td><td>"+row.eventrecord.equipmentAddr+"</td></tr>"+
		    		"<tr><td>发生时间</td><td>"+row.eventrecord.startTime+"</td></tr>"+
		    		"<tr><td>起始A相功率因数</td><td>"+formatData(row.eventrecord.pfData.startPFA)+"</td></tr>"+
		    		"<tr><td>起始B相功率因数</td><td>"+formatData(row.eventrecord.pfData.startPFB)+"</td></tr>"+
		    		"<tr><td>起始C相功率因数</td><td>"+formatData(row.eventrecord.pfData.startPFC)+"</td></tr>"+
		    		"<tr><td>结束时间</td><td>"+row.eventrecord.endTime+"</td></tr>"+
		    		"<tr><td>结束A相功率因数</td><td>"+formatData(row.eventrecord.pfData.endPFA)+"</td></tr>"+
		    		"<tr><td>结束B相功率因数</td><td>"+formatData(row.eventrecord.pfData.endPFB)+"</td></tr>"+
		    		"<tr><td>结束C相功率因数</td><td>"+formatData(row.eventrecord.pfData.endPFC)+"</td></tr></table>";
				break;
			case 16:
		  		content = 
		    		"<table class='bordered'>"+th2+"<tr><td>终端地址 </td><td>"+row.eventrecord.equipmentAddr+"</td></tr>"+
		    		"<tr><td>发生时间</td><td>"+row.eventrecord.startTime+"</td></tr>"+
		    		"<tr><td>结束时间</td><td>"+row.eventrecord.endTime+"</td></tr></table>";
				break;
			case 19://控制继电器开
			case 20:
			case 21:
			case 22:
		  		content = 
		    		"<table class='bordered'>"+th2+"<tr><td>终端地址 </td><td>"+row.eventrecord.equipmentAddr+"</td></tr>"+
		    		"<tr><td>发生时间</td><td>"+row.eventrecord.startTime+"</td></tr></table>";
				break;
			case 23://遥信1变位告警
			case 24:
				var startdata="" ;
				if(row.eventrecord.stratData==1){
					startdata="开";
				}else if(row.eventrecord.stratData==0){
					startdata="合";
				}
		  		content = 
		    		"<table class='bordered'>"+th2+"<tr><td>终端地址 </td><td>"+row.eventrecord.equipmentAddr+"</td></tr>"+
		    		"<tr><td>发生时间</td><td>"+row.eventrecord.startTime+"</td></tr>"+
		    		"<tr><td>变位后的状态</td><td>"+row.eventrecord.startdata+"</td></tr></table>";
				break;
			case 50:
		  	case 51:
		  	case 52:
		  	case 53:
		  		content = 
		    		"<table class='bordered'>"+th+"<tr><td>终端地址 </td><td>"+row.eventrecord.equipmentAddr+"</td><td></td></tr>"+
		    		"<tr><td>发生时间</td><td>"+row.eventrecord.startTime+"</td><td></td></tr>"+
		    		"<tr><td>起始A相温度</td><td>"+formatData(row.eventrecord.tempData.startTempA)+"</td><td>℃</td></tr>"+
		    		"<tr><td>起始B相温度</td><td>"+formatData(row.eventrecord.tempData.startTempB)+"</td><td>℃</td></tr>"+
		    		"<tr><td>起始C相温度</td><td>"+formatData(row.eventrecord.tempData.startTempC)+"</td><td>℃</td></tr>"+
		    		"<tr><td>起始N相温度</td><td>"+formatData(row.eventrecord.tempData.startNTemp)+"</td><td>℃</td></tr>"+
		    		"<tr><td>起始终端内部温度</td><td>"+formatData(row.eventrecord.tempData.startATemp)+"</td><td>℃</td></tr>"+
		    		"<tr><td>结束时间</td><td>"+row.eventrecord.endTime+"</td><td></td></tr>"+
		    		"<tr><td>结束A相温度</td><td>"+formatData(row.eventrecord.tempData.endTempA)+"</td><td>℃</td></tr>"+
		    		"<tr><td>结束B相温度</td><td>"+formatData(row.eventrecord.tempData.endTempB)+"</td><td>℃</td></tr>"+
		    		"<tr><td>结束C相温度</td><td>"+formatData(row.eventrecord.tempData.endTempC)+"</td><td>℃</td></tr>"+
		    		"<tr><td>结束N相温度</td><td>"+formatData(row.eventrecord.tempData.endNTemp)+"</td><td>℃</td></tr>"+
		    		"<tr><td>结束终端内部温度</td><td>"+formatData(row.eventrecord.tempData.endATemp)+"</td><td>℃</td></tr></table>";
				break;
		  	case 54:
				content = 
		    		"<table class='bordered'>"+th2+"<tr><td>终端地址 </td><td>"+row.eventrecord.equipmentAddr+"</td></tr>"+
		    		"<tr><td>发生时间</td><td>"+row.eventrecord.startTime+"</td></tr>"+
		    		"<tr><td>结束时间</td><td>"+row.eventrecord.endTime+"</td></tr></table>";
				break;
			case 60:
		  		content = 
		    		"<table class='bordered'>"+th+"<tr><td>终端地址 </td><td>"+row.eventrecord.equipmentAddr+"</td><td></td></tr>"+
		    		"<tr><td>发生时间</td><td>"+row.eventrecord.startTime+"</td><td></td></tr>"+
		    		"<tr><td>起始剩余电流</td><td>"+formatData(row.eventrecord.stratData)+"</td><td>A</td></tr>"+
		    		"<tr><td>结束时间</td><td>"+row.eventrecord.endTime+"</td><td></td></tr>"+
		    		"<tr><td>结束剩余电流</td><td>"+formatData(row.eventrecord.endData)+"</td><td>A</td></tr></table>";
				break;
			case 70:
		  	case 71:
		  		content = 
		    		"<table class='bordered'>"+th+"<tr><td>终端地址 </td><td>"+row.eventrecord.equipmentAddr+"</td><td></td></tr>"+
		    		"<tr><td>发生时间</td><td>"+row.eventrecord.startTime+"</td><td></td></tr>"+
		    		"<tr><td>起始水压力值</td><td>"+formatData(row.eventrecord.stratData)+"</td><td>MPa</td></tr>"+
		    		"<tr><td>结束时间</td><td>"+row.eventrecord.endTime+"</td><td></td></tr>"+
		    		"<tr><td>结束水压力值</td><td>"+formatData(row.eventrecord.endData)+"</td><td>MPa</td></tr></table>";		
		    		break;
		  	case 73://水压监测测试
		  		content = 
		    		"<table class='bordered'>"+th+"<tr><td>终端地址 </td><td>"+row.eventrecord.equipmentAddr+"</td><td></td></tr>"+
		    		"<tr><td>发生时间</td><td>"+row.eventrecord.startTime+"</td><td></td></tr>"+
		    		"<tr><td>水压值</td><td>"+formatData(row.eventrecord.stratData)+"</td><td>MPa</td></tr>"+
		    		"<tr><td>电池电压值</td><td>"+formatData(row.eventrecord.batteryVoltage)+"</td><td>V</td></tr></table>";
		    		break;
			case 80:
				content = 
		    		"<table class='bordered'>"+th+"<tr><td>终端地址 </td><td>"+row.eventrecord.equipmentAddr+"</td><td></td></tr>"+
		    		"<tr><td>发生时间</td><td>"+row.eventrecord.startTime+"</td><td></td></tr>"+
		    		"<tr><td>起始烟雾浓度</td><td>"+formatData(row.eventrecord.stratData)+"</td><td>%</td></tr>"+
		    		"<tr><td>结束时间</td><td>"+row.eventrecord.endTime+"</td><td></td></tr>"+
		    		"<tr><td>结束烟雾浓度</td><td>"+formatData(row.eventrecord.endData)+"</td><td>%</td></tr></table>";
				break;
			case 82://烟感报警测试
				content = 
		    		"<table class='bordered'>"+th+"<tr><td>终端地址 </td><td>"+row.eventrecord.equipmentAddr+"</td><td></td></tr>"+
		    		"<tr><td>发生时间</td><td>"+row.eventrecord.startTime+"</td><td></td></tr>"+
		    		"<tr><td>烟雾浓度</td><td>"+formatData(row.eventrecord.stratData)+"</td><td>%</td></tr>"+
		    		"<tr><td>电池电压</td><td>"+formatData(row.eventrecord.batteryVoltage)+"</td><td>V</td></tr></table>";
				break;
			case 90:
				content = 
		    		"<table class='bordered'>"+th+"<tr><td>终端地址 </td><td>"+row.eventrecord.equipmentAddr+"</td><td></td></tr>"+
		    		"<tr><td>发生时间</td><td>"+row.eventrecord.startTime+"</td><td></td></tr>"+
		    		"<tr><td>起始燃气浓度</td><td>"+formatData(row.eventrecord.stratData)+"</td><td>%</td></tr>"+
		    		"<tr><td>结束时间</td><td>"+row.eventrecord.endTime+"</td><td></td></tr>"+
		    		"<tr><td>结束燃气浓度</td><td>"+formatData(row.eventrecord.endData)+"</td><td>%</td></tr></table>";
				break;
			case 92://燃气报警测试
				content = 
		    		"<table class='bordered'>"+th+"<tr><td>终端地址 </td><td>"+row.eventrecord.equipmentAddr+"</td><td></td></tr>"+
		    		"<tr><td>发生时间</td><td>"+row.eventrecord.startTime+"</td><td></td></tr>"+
		    		"<tr><td>燃气浓度</td><td>"+formatData(row.eventrecord.stratData)+"</td><td>%</td></tr></table>";
		    		/* "<tr><td>电池电压</td><td>"+formatData(row.eventrecord.batteryVoltage)+"</td></tr></table>"; */
				break;
			case 100:
		  	case 130:
		  	case 140:
				content = 
		    		"<table class='bordered'>"+th2+"<tr><td>终端地址 </td><td>"+row.eventrecord.equipmentAddr+"</td></tr>"+
		    		"<tr><td>发生时间</td><td>"+row.eventrecord.startTime+"</td></tr>"+
		    		"<tr><td>结束时间</td><td>"+row.eventrecord.endTime+"</td></tr></table>";
		    	break;
		  	case 110://声光报警器报警
		  		//未结束时不解析
		  		var endState="";
		  		if(null!=row.eventrecord.endTime && ""!=row.eventrecord.endTime){
		  			endState = getAavaState(row.eventrecord.endData,82);
		  		}
		  		
				content = 
		    		"<table class='bordered'>"+th2+"<tr><td>终端地址 </td><td>"+row.eventrecord.equipmentAddr+"</td></tr>"+
		    		"<tr><td>发生时间</td><td>"+row.eventrecord.startTime+"</td></tr>"+
		    		"<tr><td>开始报警时状态</td><td>"+getAavaState(row.eventrecord.stratData,82)+"</td></tr>"+
		    		"<tr><td>结束时间</td><td>"+row.eventrecord.endTime+"</td></tr>"+
		    		"<tr><td>结束报警时状态</td><td>"+endState+"</td></tr></table>";
		    	break;
		  	case 102://报警按钮测试
		  		content = 
		    		"<table class='bordered'>"+th+"<tr><td>终端地址 </td><td>"+row.eventrecord.equipmentAddr+"</td><td></td></tr>"+
		    		"<tr><td>发生时间</td><td>"+row.eventrecord.startTime+"</td><td></td></tr>"+
		    		"<tr><td>电池电压</td><td>"+formatData(row.eventrecord.batteryVoltage)+"</td><td>V</td></tr></table>";
		    	break;
		  	case 17:
		  	case 18:
		  	case 72:	
		  	case 81:	
		  	case 91:	
		  	case 101:
		  	case 111:
		  	case 122://水位监测电池欠压
		  	case 131:
		  	case 141:
				content = 
		    		"<table class='bordered'>"+th+"<tr><td>终端地址 </td><td>"+row.eventrecord.equipmentAddr+"</td><td></td></tr>"+
		    		"<tr><td>发生时间</td><td>"+row.eventrecord.startTime+"</td><td></td></tr>"+
		    		"<tr><td>起始电压值</td><td>"+formatData(row.eventrecord.stratData)+"</td><td>V</td></tr>"+
		    		"<tr><td>结束时间</td><td>"+row.eventrecord.endTime+"</td><td></td></tr>"+
		    		"<tr><td>结束电压值</td><td>"+formatData(row.eventrecord.endData)+"</td><td>V</td></tr></table>";
				break;
		  	case 112://声光报警器测试
		  		content = 
		    		"<table class='bordered'>"+th+"<tr><td>终端地址 </td><td>"+row.eventrecord.equipmentAddr+"</td><td></td></tr>"+
		    		"<tr><td>发生时间</td><td>"+row.eventrecord.startTime+"</td><td></td></tr>"+
		    		"<tr><td>状态</td><td>"+getAavaState(row.eventrecord.stratData,82)+"</td><td></td></tr>"+
		    		"<tr><td>电压值</td><td>"+formatData(row.eventrecord.batteryVoltage)+"</td><td>V</td></tr></table>";
				break;
		  	case 132://消防栓按钮测试
		  	case 142://消防门测试
		  		content = 
		    		"<table class='bordered'>"+th+"<tr><td>终端地址 </td><td>"+row.eventrecord.equipmentAddr+"</td><td></td></tr>"+
		    		"<tr><td>发生时间</td><td>"+row.eventrecord.startTime+"</td><td></td></tr>"+
		    		"<tr><td>状态</td><td>"+formatData(row.eventrecord.stratData)+"</td><td></td></tr>"+
		    		"<tr><td>电压值</td><td>"+formatData(row.eventrecord.batteryVoltage)+"</td><td>V</td></tr></table>";
				break;
			case 120://超水位报警
			case 121://低水位报警
				content = 
					"<table class='bordered'>"+th+"<tr><td>终端地址 </td><td>"+row.eventrecord.equipmentAddr+"</td><td></td></tr>"+
		    		"<tr><td>发生时间</td><td>"+row.eventrecord.startTime+"</td><td></td></tr>"+
		    		"<tr><td>水位高度</td><td>"+formatData(row.eventrecord.stratData)+"</td><td>米</td></tr>"+
		    		"<tr><td>结束时间</td><td>"+row.eventrecord.endTime+"</td><td></td></tr>"+
		    		"<tr><td>水位高度</td><td>"+formatData(row.eventrecord.endData)+"</td><td>米</td></tr></table>";
		  		break;	
		  	case 123://水位监测测试
		  		content = 
					"<table class='bordered'>"+th+"<tr><td>终端地址 </td><td>"+row.eventrecord.equipmentAddr+"</td><td></td></tr>"+
		    		"<tr><td>发生时间</td><td>"+row.eventrecord.startTime+"</td><td></td></tr>"+
		    		"<tr><td>水位高度</td><td>"+formatData(row.eventrecord.stratData)+"</td><td>米</td></tr>"+
		    		"<tr><td>电池电压值</td><td>"+formatData(row.eventrecord.batteryVoltage)+"</td><td>V</td></tr></table>";
		  		break;
		  	case 254://消音命令
		  		content = 
					"<table class='bordered'>"+th2+"<tr><td>终端地址 </td><td>"+row.eventrecord.equipmentAddr+"</td></tr>"+
		    		"<tr><td>时间</td><td>"+row.eventrecord.startTime+"</td></tr></table>";
		  		break;
			default:
				break;
			} 
		
		var result = "<div style='margin:0 auto'>"+content+"</div>";
		$("#DataDetail").html(result);
    	$.parser.parse( $('#w')); 
    	$("#w").window('resize',{width:310,height:"auto"});
    	$('#w').window('open').dialog('setTitle',"报警明细");
	 } 
}
	
//当前数据明细
function currentDataDetail(rowIndex){
	$("#DataDetail").html("");
	var content = "";
	var rows = $('#elecurrenttb').datagrid('getRows');    // get current page rows
	var rowData = rows[rowIndex];    // your row data
	var th = "<tr><th>项目</th><th>数据内容</th><th>单位</th></tr>"
	if(rowData){
		content = 
			"<table class='bordered'>"+th
			+"<tr><td>当前正向总电量 </td><td>"+formatData(rowData.realtimedata.positiveElectricity)+"</td><td>kWh</td></tr>"+
    		"<tr><td>当前正向A相电量</td><td>"+formatData(rowData.realtimedata.positiveElectricityA)+"</td><td>kWh</td></tr>"+
    		"<tr><td>当前正向B相电量</td><td>"+formatData(rowData.realtimedata.positiveElectricityB)+"</td><td>kWh</td></tr>"+
    		"<tr><td>当前正向C相电量 </td><td>"+formatData(rowData.realtimedata.positiveElectricityC)+"</td><td>kWh</td></tr>"+
    		"<tr><td>当前反向总电量</td><td>"+formatData(rowData.realtimedata.reverseElectricity)+"</td><td>kWh</td></tr>"+
    		"<tr><td>当前反向A相电量</td><td>"+formatData(rowData.realtimedata.reverseElectricityA)+"</td><td>kWh</td></tr>"+
    		"<tr><td>当前反向B相电量</td><td>"+formatData(rowData.realtimedata.reverseElectricityB)+"</td><td>kWh</td></tr>"+
    		"<tr><td>当前反向C相电量 </td><td>"+formatData(rowData.realtimedata.reverseElectricityC)+"</td><td>kWh</td></tr>"+
    		"<tr><td>A相电压</td><td>"+formatData(rowData.realtimedata.VA)+"</td><td>V</td></tr>"+
    		"<tr><td>B相电压</td><td>"+formatData(rowData.realtimedata.VB)+"</td><td>V</td></tr>"+
    		"<tr><td>C相电压 </td><td>"+formatData(rowData.realtimedata.VC)+"</td><td>V</td></tr>"+
    		"<tr><td>A相电流</td><td>"+formatData(rowData.realtimedata.AA)+"</td><td>A</td></tr>"+
    		"<tr><td>B相电流</td><td>"+formatData(rowData.realtimedata.AB)+"</td><td>A</td></tr>"+
    		"<tr><td>C相电流</td><td>"+formatData(rowData.realtimedata.AC)+"</td><td>A</td></tr>"+
    		"<tr><td>剩余电流 </td><td>"+formatData(rowData.realtimedata.AOver)+"</td><td>A</td></tr>"+
    		"<tr><td>总功率</td><td>"+formatData(rowData.realtimedata.Power)+"</td><td>kW</td></tr>"+
    		"<tr><td>A相功率</td><td>"+formatData(rowData.realtimedata.PowerA)+"</td><td>kW</td></tr>"+
    		"<tr><td>B相功率</td><td>"+formatData(rowData.realtimedata.PowerB)+"</td><td>kW</td></tr>"+
    		"<tr><td>C相功率</td><td>"+formatData(rowData.realtimedata.PowerC)+"</td><td>kW</td></tr>"+
    		"<tr><td>总功率因素</td><td>"+formatData(rowData.realtimedata.PF)+"</td><td></td></tr>"+
    		"<tr><td>A相功率因素</td><td>"+formatData(rowData.realtimedata.PFA)+"</td><td></td></tr>"+
    		"<tr><td>B相功率因素</td><td>"+formatData(rowData.realtimedata.PFB)+"</td><td></td></tr>"+
    		"<tr><td>C相功率因素</td><td>"+formatData(rowData.realtimedata.PFC)+"</td><td></td></tr>"+
    		"<tr><td>频率</td><td>"+formatData(rowData.realtimedata.Frequency)+"</td><td>Hz</td></tr>"+
    		"<tr><td>A相温度</td><td>"+formatData(rowData.realtimedata.tempA)+"</td><td>°C</td></tr>"+
    		"<tr><td>B相温度</td><td>"+formatData(rowData.realtimedata.tempB)+"</td><td>°C</td></tr>"+
    		"<tr><td>C相温度 </td><td>"+formatData(rowData.realtimedata.tempC)+"</td><td>°C</td></tr>"+
    		"<tr><td>零线温度</td><td>"+formatData(rowData.realtimedata.NTemp)+"</td><td>°C</td></tr>"+
    		"<tr><td>终端内部温度</td><td>"+formatData(rowData.realtimedata.ATemp)+"</td><td>°C</td></tr>"+
    		"<tr><td>内部时钟 电池电压 </td><td>"+formatData(rowData.realtimedata.inBatteryVoltage)+"</td><td>V</td></tr>"+
    		"<tr><td>外部电池电压</td><td>"+formatData(rowData.realtimedata.exBatteryVoltage)+"</td><td>V</td></tr></table>";
	} 

	var result = "<div style='margin:0 10px;height:480px;'>"+content+"</div>";
	$("#DataDetail").html(result);
	$.parser.parse( $('#w')); 
	$("#w").window('resize',{width:300,height:400});
	$('#w').window('open').dialog('setTitle',"用点系统当前数据明细");
}

//实时冻结（曲线）明细
function curveDetail(rowIndex){
	$("#DataDetail").html("");
		var content = "";
		var rows = $('#elecurvetb').datagrid('getRows');    // get current page rows
		var rowData = rows[rowIndex];    // your row data
		var th = "<tr><th>项目</th><th>数据内容</th><th>单位</th></tr>"
		if(rowData){
			content = 
				"<table class='bordered'>"+th+
				"<tr><td>冻结时间</td><td>"+rowData.freezedatamsg.freezeTime+"</td><td></td></tr>"+
				"<tr><td>当前正向总电量 </td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.positiveElectricity)+"</td><td>kWh</td></tr>"+
	    		"<tr><td>当前正向A相电量</td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.positiveElectricityA)+"</td><td>kWh</td></tr>"+
	    		"<tr><td>当前正向B相电量</td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.positiveElectricityB)+"</td><td>kWh</td></tr>"+
	    		"<tr><td>当前正向C相电量 </td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.positiveElectricityC)+"</td><td>kWh</td></tr>"+
	    		"<tr><td>当前反向总电量</td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.reverseElectricity)+"</td><td>kWh</td></tr>"+
	    		"<tr><td>当前反向A相电量</td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.reverseElectricityA)+"</td><td>kWh</td></tr>"+
	    		"<tr><td>当前反向B相电量</td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.reverseElectricityB)+"</td><td>kWh</td></tr>"+
	    		"<tr><td>当前反向C相电量 </td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.reverseElectricityC)+"</td><td>kWh</td></tr>"+
	    		"<tr><td>A相电压</td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.VA)+"</td><td>V</td></tr>"+
	    		"<tr><td>B相电压</td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.VB)+"</td><td>V</td></tr>"+
	    		"<tr><td>C相电压 </td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.VC)+"</td><td>V</td></tr>"+
	    		"<tr><td>A相电流</td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.AA)+"</td><td>A</td></tr>"+
	    		"<tr><td>B相电流</td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.AB)+"</td><td>A</td></tr>"+
	    		"<tr><td>C相电流</td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.AC)+"</td><td>A</td></tr>"+
	    		"<tr><td>剩余电流 </td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.AOver)+"</td><td>A</td></tr>"+
	    		"<tr><td>总功率</td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.Power)+"</td><td>kW</td></tr>"+
	    		"<tr><td>A相功率</td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.PowerA)+"</td><td>kW</td></tr>"+
	    		"<tr><td>B相功率</td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.PowerB)+"</td><td>kW</td></tr>"+
	    		"<tr><td>C相功率</td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.PowerC)+"</td><td>kW</td></tr>"+
	    		"<tr><td>总功率因素</td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.PF)+"</td><td></td></tr>"+
	    		"<tr><td>A相功率因素</td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.PFA)+"</td><td></td></tr>"+
	    		"<tr><td>B相功率因素</td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.PFB)+"</td><td></td></tr>"+
	    		"<tr><td>C相功率因素</td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.PFC)+"</td><td></td></tr>"+
	    		"<tr><td>频率</td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.Frequency)+"</td><td>Hz</td></tr>"+
	    		"<tr><td>A相温度</td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.tempA)+"</td><td>°C</td></tr>"+
	    		"<tr><td>B相温度</td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.tempB)+"</td><td>°C</td></tr>"+
	    		"<tr><td>C相温度 </td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.tempC)+"</td><td>°C</td></tr>"+
	    		"<tr><td>零线温度</td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.NTemp)+"</td><td>°C</td></tr>"+
	    		"<tr><td>终端内部温度</td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.ATemp)+"</td><td>°C</td></tr>"+
	    		"<tr><td>内部时钟 电池电压 </td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.inBatteryVoltage)+"</td><td>V</td></tr>"+
	    		"<tr><td>外部电池电压</td><td>"+formatData(rowData.freezedatamsg.efmsRealTimeData.exBatteryVoltage)+"</td><td>V</td></tr></table>";
		} 
	
		var result = "<div style='margin:0 10px'>"+content+"</div>";
		//$.messager.alert('用电系统曲线数据明细',result,'');
		$("#DataDetail").html(result);
    	$.parser.parse( $('#w')); 
    	$("#w").window('resize',{width:380,height:400});
    	$('#w').window('open').dialog('setTitle',"用电系统曲线数据明细");
}
	
//用电系统日冻结明细
function eleFreezeDetail(rowIndex){
	$("#DataDetail").html("");
		var content = "";
		var rows = $('#elefreezetb').datagrid('getRows');    // get current page rows
		var rowData = rows[rowIndex];    // your row data
		var th = "<tr><th>项目</th><th>数据内容</th><th>单位</th></tr>"
		if(rowData){
			content = 
				"<table class='bordered'>"+th+
				"<tr><td>冻结时间</td><td>"+rowData.freezedatamsg.freezeTime+"</td><td></td></tr>"+
				"<tr><td>当前正向总电量 </td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.positiveElectricity)+"</td><td>kWh</td></tr>"+
	    		"<tr><td>当前正向A相电量</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.positiveElectricityA)+"</td><td>kWh</td></tr>"+
	    		"<tr><td>当前正向B相电量</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.positiveElectricityB)+"</td><td>kWh</td></tr>"+
	    		"<tr><td>当前正向C相电量 </td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.positiveElectricityC)+"</td><td>kWh</td></tr>"+
	    		"<tr><td>当前反向总电量</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.reverseElectricity)+"</td><td>kWh</td></tr>"+
	    		"<tr><td>当前反向A相电量</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.reverseElectricityA)+"</td><td>kWh</td></tr>"+
	    		"<tr><td>当前反向B相电量</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.reverseElectricityB)+"</td><td>kWh</td></tr>"+
	    		"<tr><td>当前反向C相电量 </td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.reverseElectricityC)+"</td><td>kWh</td></tr>"+
	    		
	    		"<tr><td>最大A相电压</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.maxVA)+"</td><td>V</td></tr>"+
	    		"<tr><td>最大A相电压发生时间 </td><td>"+rowData.freezedatamsg.efmsFreezeData.maxVATime+"</td><td></td></tr>"+
	    		"<tr><td>最大B相电压</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.maxVB)+"</td><td>V</td></tr>"+
	    		"<tr><td>最大B相电压发生时间 </td><td>"+rowData.freezedatamsg.efmsFreezeData.maxVBTime+"</td><td></td></tr>"+
	    		"<tr><td>最大C相电压</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.maxVC)+"</td><td>V</td></tr>"+
	    		"<tr><td>最大C相电压发生时间 </td><td>"+rowData.freezedatamsg.efmsFreezeData.maxVCTime+"</td><td></td></tr>"+
	    		
	    		"<tr><td>最小A相电压</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.minVA)+"</td><td>V</td></tr>"+
	    		"<tr><td>最小A相电压发生时间 </td><td>"+rowData.freezedatamsg.efmsFreezeData.minVATime+"</td><td>V</td></tr>"+
	    		"<tr><td>最小B相电压</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.minVB)+"</td><td>V</td></tr>"+
	    		"<tr><td>最小B相电压发生时间 </td><td>"+rowData.freezedatamsg.efmsFreezeData.minVBTime+"</td><td>V</td></tr>"+
	    		"<tr><td>最小C相电压</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.minVC)+"</td><td>V</td></tr>"+
	    		"<tr><td>最小C相电压发生时间 </td><td>"+rowData.freezedatamsg.efmsFreezeData.minVCTime+"</td><td></td></tr>"+
	    		
	    		"<tr><td>最大A相电流</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.maxAA)+"</td><td>A</td></tr>"+
	    		"<tr><td>最大A相电流发生时间</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.maxAATime)+"</td><td></td></tr>"+
	    		"<tr><td>最大B相电流</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.maxAB)+"</td><td>A</td></tr>"+
	    		"<tr><td>最大B相电流发生时间</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.maxABTime)+"</td><td></td></tr>"+
	    		"<tr><td>最大C相电流</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.maxAC)+"</td><td>A</td></tr>"+
	    		"<tr><td>最大C相电流发生时间</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.maxACTime)+"</td><td></td></tr>"+
	    		"<tr><td>最大剩余电流 </td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.maxAOver)+"</td><td>A</td></tr>"+
	    		"<tr><td>最大剩余电流发生时间</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.maxAOverTime)+"</td><td></td></tr>"+
	    		
	    		"<tr><td>最小A相电流</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.minAA)+"</td><td>A</td></tr>"+
	    		"<tr><td>最小A相电流发生时间</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.minAATime)+"</td><td></td></tr>"+
	    		"<tr><td>最小B相电流</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.minAB)+"</td><td>A</td></tr>"+
	    		"<tr><td>最小B相电流发生时间</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.minABTime)+"</td><td></td></tr>"+
	    		"<tr><td>最小C相电流</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.minAC)+"</td><td>A</td></tr>"+
	    		"<tr><td>最小C相电流发生时间</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.minACTime)+"</td><td></td></tr>"+
	    		"<tr><td>最小剩余电流 </td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.minAOver)+"</td><td>A</td></tr>"+
	    		"<tr><td>最小剩余电流发生时间</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.minAOverTime)+"</td><td></td></tr>"+
	    		
	    		"<tr><td>最大总功率</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.maxPower)+"</td><td>kW</td></tr>"+
	    		"<tr><td>最大总功率发生时间</td><td>"+rowData.freezedatamsg.efmsFreezeData.maxPowerTime+"</td><td></td></tr>"+
	    		"<tr><td>最大A相功率</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.maxPowerA)+"</td><td>kW</td></tr>"+
	    		"<tr><td>最大A相功率发生时间</td><td>"+rowData.freezedatamsg.efmsFreezeData.maxPowerATime+"</td><td></td></tr>"+
	    		"<tr><td>最大B相功率</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.maxPowerB)+"</td><td>kW</td></tr>"+
	    		"<tr><td>最大B相功率发生时间</td><td>"+rowData.freezedatamsg.efmsFreezeData.maxPowerBTime+"</td><td></td></tr>"+
	    		"<tr><td>最大C相功率</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.maxPowerC)+"</td><td>kW</td></tr>"+
	    		"<tr><td>最大C相功率发生时间</td><td>"+rowData.freezedatamsg.efmsFreezeData.maxPowerCTime+"</td><td></td></tr>"+
	    		"<tr><td>最小总功率</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.minPower)+"</td><td>kW</td></tr>"+
	    		"<tr><td>最小总功率发生时间</td><td>"+rowData.freezedatamsg.efmsFreezeData.minPowerTime+"</td><td></td></tr>"+
	    		"<tr><td>最小A相功率</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.minPowerA)+"</td><td>kW</td></tr>"+
	    		"<tr><td>最小A相功率发生时间</td><td>"+rowData.freezedatamsg.efmsFreezeData.minPowerATime+"</td><td></td></tr>"+
	    		"<tr><td>最小B相功率</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.minPowerB)+"</td><td>kW</td></tr>"+
	    		"<tr><td>最小B相功率发生时间</td><td>"+rowData.freezedatamsg.efmsFreezeData.minPowerBTime+"</td><td></td></tr>"+
	    		"<tr><td>最小C相功率</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.minPowerC)+"</td><td>kW</td></tr>"+
	    		"<tr><td>最小C相功率发生时间</td><td>"+rowData.freezedatamsg.efmsFreezeData.minPowerCTime+"</td><td></td></tr>"+
	    		
	    		"<tr><td>最大总功率因素</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.maxPF)+"</td><td></td></tr>"+
	    		"<tr><td>最大总功率因素发生时间</td><td>"+rowData.freezedatamsg.efmsFreezeData.maxPFTime+"</td><td></td></tr>"+
	    		"<tr><td>最大A相功率因素</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.maxPFA)+"</td><td></td></tr>"+
	    		"<tr><td>最大A相功率因素发生时间</td><td>"+rowData.freezedatamsg.efmsFreezeData.maxPFATime+"</td><td></td></tr>"+
	    		"<tr><td>最大B相功率因素</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.maxPFB)+"</td><td></td></tr>"+
	    		"<tr><td>最大B相功率因素发生时间</td><td>"+rowData.freezedatamsg.efmsFreezeData.maxPFBTime+"</td><td></td></tr>"+
	    		"<tr><td>最大C相功率因素</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.maxPFC)+"</td><td></td></tr>"+
	    		"<tr><td>最大C相功率因素发生时间</td><td>"+rowData.freezedatamsg.efmsFreezeData.maxPFCTime+"</td><td></td></tr>"+
	    		"<tr><td>最小总功率因素</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.minPF)+"</td><td></td></tr>"+
	    		"<tr><td>最小总功率因素发生时间</td><td>"+rowData.freezedatamsg.efmsFreezeData.minPFTime+"</td><td></td></tr>"+
	    		"<tr><td>最小A相功率因素</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.minPFA)+"</td><td></td></tr>"+
	    		"<tr><td>最小A相功率因素发生时间</td><td>"+rowData.freezedatamsg.efmsFreezeData.minPFATime+"</td><td></td></tr>"+
	    		"<tr><td>最小B相功率因素</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.minPFB)+"</td><td></td></tr>"+
	    		"<tr><td>最小B相功率因素发生时间</td><td>"+rowData.freezedatamsg.efmsFreezeData.minPFBTime+"</td><td></td></tr>"+
	    		"<tr><td>最小C相功率因素</td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.minPFC)+"</td><td></td></tr>"+
	    		"<tr><td>最小C相功率因素发生时间</td><td>"+rowData.freezedatamsg.efmsFreezeData.minPFCTime+"</td><td></td></tr>"+
	    		
	    		
	    		"<tr><td>最大A相温度 </td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.maxTempA)+"</td><td>°C</td></tr>"+
	    		"<tr><td>最大A相温度发生时间</td><td>"+rowData.freezedatamsg.efmsFreezeData.maxTempATime+"</td><td></td></tr>"+
	    		"<tr><td>最大B相温度 </td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.maxTempB)+"</td><td>°C</td></tr>"+
	    		"<tr><td>最大B相温度发生时间</td><td>"+rowData.freezedatamsg.efmsFreezeData.maxTempBTime+"</td><td></td></tr>"+
	    		"<tr><td>最大C相温度 </td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.maxTempC)+"</td><td>°C</td></tr>"+
	    		"<tr><td>最大C相温度发生时间</td><td>"+rowData.freezedatamsg.efmsFreezeData.maxTempCTime+"</td><td></td></tr>"+
	    		"<tr><td>最大零线温度 </td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.maxNTemp)+"</td><td>°C</td></tr>"+
	    		"<tr><td>最大零线温度发生时间</td><td>"+rowData.freezedatamsg.efmsFreezeData.maxNTempTime+"</td><td></td></tr>"+
	    		"<tr><td>最大终端内部温度 </td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.maxATemp)+"</td><td>°C</td></tr>"+
	    		"<tr><td>最大终端内部温度发生时间</td><td>"+rowData.freezedatamsg.efmsFreezeData.maxATempTime+"</td><td></td></tr>"+
	    		
	    		"<tr><td>最小A相温度 </td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.minTempA)+"</td><td>°C</td></tr>"+
	    		"<tr><td>最小A相温度发生时间</td><td>"+rowData.freezedatamsg.efmsFreezeData.minTempATime+"</td><td></td></tr>"+
	    		"<tr><td>最小B相温度 </td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.minTempB)+"</td><td>°C</td></tr>"+
	    		"<tr><td>最小B相温度发生时间</td><td>"+rowData.freezedatamsg.efmsFreezeData.minTempBTime+"</td><td></td></tr>"+
	    		"<tr><td>最小C相温度 </td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.minTempC)+"</td><td>°C</td></tr>"+
	    		"<tr><td>最小C相温度发生时间</td><td>"+rowData.freezedatamsg.efmsFreezeData.minTempCTime+"</td><td></td></tr>"+
	    		"<tr><td>最小零线温度 </td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.minNTemp)+"</td><td>°C</td></tr>"+
	    		"<tr><td>最小零线温度发生时间</td><td>"+rowData.freezedatamsg.efmsFreezeData.minNTempTime+"</td><td></td></tr>"+
	    		"<tr><td>最小终端内部温度 </td><td>"+formatData(rowData.freezedatamsg.efmsFreezeData.minATemp)+"</td><td>°C</td></tr>"+
	    		"<tr><td>最小终端内部温度发生时间</td><td>"+rowData.freezedatamsg.efmsFreezeData.minATempTime+"</td><td></td></tr></table>";
		} 
	
		var result = "<div style='margin:0 10px;height:480px;'>"+content+"</div>";
		//$.messager.alert('用电系统日冻结数据明细',result,'');
		$("#DataDetail").html(result);
    	$.parser.parse( $('#w')); 
    	$("#w").window('resize',{width:429,height:400});
    	$('#w').window('open').dialog('setTitle',"用电系统日冻结数据明细");
}



/*查询报警数据（n=1第一次查询,n>1后续查询）*/
function QueryalarmData(n) {
	var type = $("#type").val();
	var unitid = $("#unitid").val();
	var equipmentid = $("#equipmentid").val();
	var initialSequence = $("#initialSequence").val();
	var queryCount = $("#queryCount").val();
	var eventtype = $("#eventtype").combobox("getValue");
	
	if(n==1){
		//清除列表数据
		$('#unitalarmtb').datagrid('loadData', { total: 0, rows: [] });
		totalalarmnum=0;//初始化数据个数
	}else{
		initialSequence = parseInt(initialSequence) + parseInt(totalalarmnum);
		queryCount = parseInt(queryCount) - parseInt(totalalarmnum);
	}

	if (parseInt(queryCount)>99){queryCount=99;}
	
	//判断
	if(type!=commonTreeNodeType.terminal && type!=commonTreeNodeType.terminalDevice && type!=commonTreeNodeType.gprsDevice){
	   $.messager.alert("提示", "请选择智慧监测终端或设备。","warning");
	   return false;
	}
	if(initialSequence==""||queryCount==""||eventtype==""){
		$.messager.alert("提示", "请检查输入内容。","warning");
		return false;
	}
	
	var date=(new Date()).toLocaleString( );//获取当前日期时间
	$("#result").prepend("<div style='color:red;padding:5px'>"+date+"正在查询报警数据...</div>");
	$.ajax({
		type : 'POST',
		url : basePath + '/dataQuery/queryalarmData',
		data : {
			unitid : unitid,
			equipmentid : equipmentid,
			initialSequence : initialSequence,
			queryCount : queryCount,
			eventtype:eventtype
		},
		success : function(d) {
			sentMessage(d, "查询中，请稍候...");
		}
	});
}
	
/*查询设备故障（n=1第一次查询,n>1后续查询）*/
function QueryFault(n) {
	var type = $("#type").val();
	var unitid = $("#unitid").val();
	var equipmentid = $("#equipmentid").val();

	var initialSequence = $("#faultinitialSequence").val();
	var queryCount = $("#faultqueryCount").val();
	if(n==1){
		//清除列表数据
		$('#faulttb').datagrid('loadData', { total: 0, rows: [] });
		totalfaultnum=0;//初始化数据个数
	}else{
		initialSequence = parseInt(initialSequence) + parseInt(totalfaultnum);
		queryCount = parseInt(queryCount) - parseInt(totalfaultnum);
	}
	var faulttype = $("#faulttype").combobox("getValue");
	
	if (parseInt(queryCount)>99){queryCount=99; }
	
	//判断
	if(type!=4 && type != commonTreeNodeType.terminalDevice && type != commonTreeNodeType.gprsDevice){
		$.messager.alert("提示", "请选择终端或设备。","warning");
		return false;
	}
	if(initialSequence==""||queryCount==""||faulttype==""){
		$.messager.alert("提示", "请检查输入内容。","warning");
		return false;
	}

	var date=(new Date()).toLocaleString( );//获取当前日期时间
	$("#result").prepend("<div style='color:red;padding:5px'>"+date+"正在查询设备故障数据...</div>");
	$.ajax({
		type : 'POST',
		url : basePath + '/dataQuery/queryFaultData',
		data : {
			unitid : unitid,
			equipmentid : equipmentid,
			initialSequence : initialSequence,
			queryCount : queryCount,
			faulttype:faulttype
		},
		success : function(d) {
			sentMessage(d, "查询中，请稍候...");
		}
	});
}
	
/*查询消息推送（n=1第一次查询,n>1后续查询）*/
function QueryMessage(n) {
	var type = $("#type").val();
	var unitid = $("#unitid").val();
	var equipmentid = $("#equipmentid").val();

	var initialSequence = $("#messageinitialSequence").val();
	var queryCount = $("#messagequeryCount").val();
	if(n==1){
		//清除列表数据
		$('#messagetb').datagrid('loadData', { total: 0, rows: [] });
		totalmessagenum=0;//初始化数据个数
	}else{
		initialSequence = parseInt(initialSequence) + parseInt(totalmessagenum);
		queryCount = parseInt(queryCount) - parseInt(totalmessagenum);
	}
	var messagetype = $("#messagetype").combobox("getValue");
	
	if (parseInt(queryCount)>99){queryCount=99; }
	
	//判断
	if(type!=4 && type != commonTreeNodeType.terminalDevice && type != commonTreeNodeType.gprsDevice){
		$.messager.alert("提示", "请选择终端或设备。","warning");
		return false;
	}
	if(initialSequence==""||queryCount==""||faulttype==""){
		$.messager.alert("提示", "请检查输入内容。","warning");
		return false;
	}

	var date=(new Date()).toLocaleString( );//获取当前日期时间
	$("#result").prepend("<div style='color:red;padding:5px'>"+date+"正在查询消息推送数据...</div>");
	$.ajax({
		type : 'POST',
		url : basePath + '/dataQuery/queryMessageData',
		data : {
			unitid : unitid,
			equipmentid : equipmentid,
			initialSequence : initialSequence,
			queryCount : queryCount,
			messagetype : messagetype
		},
		success : function(d) {
			sentMessage(d, "查询中，请稍候...");
		}
	});
}

/*查询电气火灾报警系统实时数据*/
function QueryRealTimeData() {
	//清除列表数据
	$('#elecurrenttb').datagrid('loadData', { total: 0, rows: [] });
	var type = $("#type").val();
	if(type != commonTreeNodeType.terminalDevice && type != commonTreeNodeType.gprsDevice){
		$.messager.alert("提示", "请选择设备。","warning");
		return false;
	}
	var equipmentid = $("#equipmentid").val();
	
	var date=(new Date()).toLocaleString( );//获取当前日期时间
	$("#result").prepend("<div style='color:red;padding:5px'>"+date+"正在查询电气火灾报警系统实时数据...</div>");
	$.ajax({
		type : 'POST',
		url : basePath + '/dataQuery/queryRealTimeData',
		data : {
			equipmentid : equipmentid
		},
		success : function(d) {
			sentMessage(d, "查询中，请稍候...");
		}
	});	
}

/*查询冻结数据*/
function queryFreezeData(freezetype) {
	var type = $("#type").val();
	if(type != commonTreeNodeType.terminalBigType 
			&& type != commonTreeNodeType.gprsBigType
			&& type != commonTreeNodeType.terminalDevice 
			&& type != commonTreeNodeType.gprsDevice){
		$.messager.alert("提示", "请选择设备或设备系统。","warning");
		return false;
	}
	
	var equipmentid = $("#equipmentid").val();
	var datanode = $("#datanode").val();
	
	var starttime, num;
	var date=(new Date()).toLocaleString( );//获取当前日期时间

	//查询条件赋值
	if (freezetype == 1) {/*查询冻结数据*/
		starttime = $("#efstarttime").val();
		num = $("#efnum").val();
		
		if(!checkFreezeFault(type,starttime,num)){
			return false;
		}
		
		//清除列表数据
		$('#elefreezetb').datagrid('loadData', { total: 0, rows: [] });
		
		$("#result").prepend("<div style='color:red;padding:5px'>"+date+","+datanode+",正在查询用电系统冻结数据...</div>");
	} else if (freezetype == 2) {/*查询曲线数据*/
		starttime = $("#ecstarttime").val();
		num = $("#ecnum").val();
		
		if(!checkFreezeFault(type,starttime,num)){
			return false;
		}
		
		//清除列表数据
		$('#elecurvetb').datagrid('loadData', { total: 0, rows: [] });
		
		$("#result").prepend("<div style='color:red;padding:5px'>"+date+","+datanode+",正在查询曲线数据...</div>");
	} else if (freezetype == 99) {//冻结类型3,4,,5
		starttime = $("#wgsstarttime").val();
		num = $("#wgsnum").val();
		
		if(!checkFreezeFault(type,starttime,num)){
			return false;
		}
			
		//获取冻结类型
		var systemtype = $("#systemtype").val();;
		if(systemtype==11){//气
			 freezetype=3;
		}else if(systemtype==128){//烟
			 freezetype=4;
		}else if(systemtype==129){//水
			 freezetype=5;
		}
	
		//清除列表数据
		$('#wgstb').datagrid('loadData', { total: 0, rows: [] });
		
		$("#result").prepend("<div style='color:red;padding:5px'>"+date+","+datanode+",正在查询水气烟感系统冻结数据...</div>");
	}else if (freezetype == 6) {//报警按钮及声光报警器
		starttime = $("#aavastarttime").val();
		num = $("#aavanum").val();
		
		if(!checkFreezeFault(type,starttime,num)){
			return false;
		}
		
		//清除列表数据
		$('#aavatb').datagrid('loadData', { total: 0, rows: [] });
		
		$("#result").prepend("<div style='color:red;padding:5px'>"+date+","+datanode+",正在查询报警按钮及声光报警器冻结数据...</div>");
	}else if (freezetype == 7) {//消防水位监控系统
		starttime = $("#flmsstarttime").val();
		num = $("#flmsnum").val();
		
		if(!checkFreezeFault(type,starttime,num)){
			return false;
		}
		
		//清除列表数据
		$('#flmstb').datagrid('loadData', { total: 0, rows: [] });
		
		$("#result").prepend("<div style='color:red;padding:5px'>"+date+","+datanode+",正在查询消防水位冻结数据...</div>");
	}else if (freezetype == 8) {//防火卷级防火门监控系统
		starttime = $("#fdmsstarttime").val();
		num = $("#fdmsnum").val();
		
		if(!checkFreezeFault(type,starttime,num)){
			return false;
		}
		
		//清除列表数据
		$('#fdmstb').datagrid('loadData', { total: 0, rows: [] });
		
		$("#result").prepend("<div style='color:red;padding:5px'>"+date+","+datanode+",正在查询防火卷级防火门监控系统冻结数据...</div>");
	}
	
	totalfreezenum=0;//初始化数据个数
	$.ajax({
		type : 'POST',
		url : basePath + '/dataQuery/queryFreezeData',
		data : {
			freezetype : freezetype,
			id : $("#selectedID").val(),
		    type : $("#selectedType").val(),
		    parentid : $("#selectedParentid").val(),
			starttime : starttime,
			num : num
		},
		success : function(d) {
			sentMessage(d, "查询中，请稍候...");
		}
	}); 
}
	
//验证查询冻结数据查询条件
function checkFreezeFault(type,starttime,num){
	if(starttime==""|| num==""){
		$.messager.alert("提示", "请检查输入内容。","warning");
		return false;
	}
	
	/* if(type==6 && num>20){
		$.messager.alert("提示", "根据系统查询冻结数据最大支持20个点数。","warning");
		return false;
	} */
	
	return true;
}
	
/*查询冻结数据（后续查询：根据返回的设备id查询）*/
function queryNextFreezeData(freezetype,lastequipmentid) {
	var equipmentid = $("#equipmentid").val();

	var starttime;
	var querycount;
	
	if(freezetype==1){
		var totalnum = $("#efnum").val();
		querycount = parseInt(totalnum) - parseInt(totalfreezenum);
	} else if(freezetype==2){
		var totalnum = $("#ecnum").val();
		querycount = parseInt(totalnum) - parseInt(totalfreezenum);
	}else if(freezetype==99){
		//获取冻结类型
		var systemtype = $("#systemtype").val();;
		if(systemtype==11){//气
			 freezetype=3;
		}else if(systemtype==128){//烟
			 freezetype=4;
		}else if(systemtype==129){//水
			 freezetype=5;
		}
		var totalnum = $("#wgsnum").val();
		querycount = parseInt(totalnum) - parseInt(totalfreezenum);
	}else if(freezetype==6){
		var totalnum = $("#aavanum").val();
		querycount = parseInt(totalnum) - parseInt(totalfreezenum);
	}else if(freezetype==7){
		var totalnum = $("#flmsnum").val();
		querycount = parseInt(totalnum) - parseInt(totalfreezenum);
	}else if(freezetype==8){
		var totalnum = $("#fdmsnum").val();
		querycount = parseInt(totalnum) - parseInt(totalfreezenum);
	}
	
	if(freezeStartTime==""){
		$.messager.alert("提示", "冻结时间为空。", "warning");
		return false;
	}

	$.ajax({
		type : 'POST',
		url : basePath + '/dataQuery/queryFreezeData',
		data : {
			freezetype : freezetype,
			id : lastequipmentid,//上次查询的设备id
		    type : commonTreeNodeType.terminalDevice,//终端设备
		    parentid : $("#selectedParentid").val(),
			starttime : freezeStartTime,
			num : querycount								
		},
		success : function(d) {
			sentMessage(d, "查询中，请稍候...");
		}
	});			 
}

    
//格式化数据，去除0
function formatData(str){
	if(null!=str&& ""!= str){
    	var result;
    	var arr = str.split('.')
    	if(arr.length==2){
    		var temp=arr[0].replace(/\b(0+)/gi,"");
    		if(temp==""){
    			result = "0."+arr[1];
    		}else if(temp=="-"){
    			result = "-0."+arr[1];//去掉前面的0
    		}else{
    			result = temp +"."+arr[1];//去掉前面的0
    		}	
    	}else{
    		result = str;
    	}
    	return result;
    }else{
		return str;
    }
} 
    
// 左补齐n位数
function padStr(str,n){
	if(str.length<n){
		for(var i=str.length;i<n;i++){
			str = "0"+str;
		}
	}else if(str.length>n){
		str = str.substring(str.length-n,str.length);
	}
	return str;
}
