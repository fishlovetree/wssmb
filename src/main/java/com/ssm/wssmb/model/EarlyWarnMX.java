package com.ssm.wssmb.model;

/**
 * @Description: 预警数据详情实体类
 * @Author wys
 * @Time: 2018年2月5日
 */
public class EarlyWarnMX {
	//id
    private Integer mxid;
    
    //预警id
    private Integer id;
    
    //事件数据类型  1:事件发送时数据  2: 事件结束时数据
    private Short eventdatatype;
    
    //数据项序号排序（按规约顺序排序）
    private Short itemnumber;
    
    //数据项内容
    private String eventdata;
    
    //事件类型id
    private Integer alarmtype;
    
    //用传报警控制柜通讯协议
    private Integer accprotocol;

    public Integer getMxid() {
        return mxid;
    }

    public void setMxid(Integer mxid) {
        this.mxid = mxid;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Short getEventdatatype() {
        return eventdatatype;
    }

    public void setEventdatatype(Short eventdatatype) {
        this.eventdatatype = eventdatatype;
    }

    public Short getItemnumber() {
        return itemnumber;
    }

    public void setItemnumber(Short itemnumber) {
        this.itemnumber = itemnumber;
    }

    public String getEventdata() {
        return eventdata;
    }

    public void setEventdata(String eventdata) {
        this.eventdata = eventdata == null ? null : eventdata.trim();
    }

	public Integer getAlarmtype() {
		return alarmtype;
	}

	public void setAlarmtype(Integer alarmtype) {
		this.alarmtype = alarmtype;
	}

	public Integer getAccprotocol() {
		return accprotocol;
	}

	public void setAccprotocol(Integer accprotocol) {
		this.accprotocol = accprotocol;
	}
}