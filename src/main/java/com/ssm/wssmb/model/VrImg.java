package com.ssm.wssmb.model;

public class VrImg {
    private Integer imgid;

    private Integer customerid;

    private String imgname;

    private String longitude;

    private String latitude;

    private String remark;

    private Integer sequence;
    
    private Integer originzoom;
    
    private Integer destinzoom;
    
    private String originlongitude;
    
    private String originlatitude;

    public Integer getImgid() {
        return imgid;
    }

    public void setImgid(Integer imgid) {
        this.imgid = imgid;
    }

    public Integer getCustomerid() {
        return customerid;
    }

    public void setCustomerid(Integer customerid) {
        this.customerid = customerid;
    }

    public String getImgname() {
        return imgname;
    }

    public void setImgname(String imgname) {
        this.imgname = imgname == null ? null : imgname.trim();
    }

    public String getLongitude() {
        return longitude;
    }

    public void setLongitude(String longitude) {
        this.longitude = longitude == null ? null : longitude.trim();
    }

    public String getLatitude() {
        return latitude;
    }

    public void setLatitude(String latitude) {
        this.latitude = latitude == null ? null : latitude.trim();
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark == null ? null : remark.trim();
    }
    
    public Integer getSequence() {
        return sequence;
    }

    public void setSequence(Integer sequence) {
        this.sequence = sequence;
    }
    
    public Integer getOriginzoom() {
        return originzoom;
    }

    public void setOriginzoom(Integer originzoom) {
        this.originzoom = originzoom;
    }
    
    public Integer getDestinzoom() {
        return destinzoom;
    }

    public void setDestinzoom(Integer destinzoom) {
        this.destinzoom = destinzoom;
    }
    
    public String getOriginlongitude() {
        return originlongitude;
    }

    public void setOriginlongitude(String originlongitude) {
        this.originlongitude = originlongitude == null ? null : originlongitude.trim();
    }
    
    public String getOriginlatitude() {
        return originlatitude;
    }

    public void setOriginlatitude(String originlatitude) {
        this.originlatitude = originlatitude == null ? null : originlatitude.trim();
    }
}