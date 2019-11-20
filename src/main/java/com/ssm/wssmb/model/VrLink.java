package com.ssm.wssmb.model;

public class VrLink {
    private Integer linkid;

    private Integer fromimg;

    private Integer toimg;

    private String longitude;

    private String latitude;

    private Short linktype;
    
    private String remark;

    public Integer getLinkid() {
        return linkid;
    }

    public void setLinkid(Integer linkid) {
        this.linkid = linkid;
    }

    public Integer getFromimg() {
        return fromimg;
    }

    public void setFromimg(Integer fromimg) {
        this.fromimg = fromimg;
    }

    public Integer getToimg() {
        return toimg;
    }

    public void setToimg(Integer toimg) {
        this.toimg = toimg;
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

    public Short getLinktype() {
        return linktype;
    }

    public void setLinktype(Short linktype) {
        this.linktype = linktype;
    }
    
    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark == null ? null : remark.trim();
    }
}