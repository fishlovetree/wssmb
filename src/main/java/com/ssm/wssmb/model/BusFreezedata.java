package com.ssm.wssmb.model;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

public class BusFreezedata {
    private Long id;

    private String equipmentaddress;

    private Short equipmenttype;

    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")//前端时间字符串转java时间戳
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone = "GMT+8") //后台时间戳转前端时间字符串(json对象) 
    private Date freezetime;

    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")//前端时间字符串转java时间戳
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone = "GMT+8") //后台时间戳转前端时间字符串(json对象) 
    private Date readtime;

    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")//前端时间字符串转java时间戳
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone = "GMT+8") //后台时间戳转前端时间字符串(json对象) 
    private Date recodetime;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getEquipmentaddress() {
        return equipmentaddress;
    }

    public void setEquipmentaddress(String equipmentaddress) {
        this.equipmentaddress = equipmentaddress == null ? null : equipmentaddress.trim();
    }

    public Short getEquipmenttype() {
        return equipmenttype;
    }

    public void setEquipmenttype(Short equipmenttype) {
        this.equipmenttype = equipmenttype;
    }

    public Date getFreezetime() {
        return freezetime;
    }

    public void setFreezetime(Date freezetime) {
        this.freezetime = freezetime;
    }

    public Date getReadtime() {
        return readtime;
    }

    public void setReadtime(Date readtime) {
        this.readtime = readtime;
    }

    public Date getRecodetime() {
        return recodetime;
    }

    public void setRecodetime(Date recodetime) {
        this.recodetime = recodetime;
    }
}