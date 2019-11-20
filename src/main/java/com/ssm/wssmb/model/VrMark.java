package com.ssm.wssmb.model;

public class VrMark {
    private Integer markid;

    private Integer imgid;

    private Short marktype;

    private String longitude;

    private String latitude;

    private String icon;
    
    private String remark;
    
    private Integer gid;

    public Integer getMarkid() {
        return markid;
    }

    public void setMarkid(Integer markid) {
        this.markid = markid;
    }

    public Integer getImgid() {
        return imgid;
    }

    public void setImgid(Integer imgid) {
        this.imgid = imgid;
    }

    public Short getMarktype() {
        return marktype;
    }

    public void setMarktype(Short marktype) {
        this.marktype = marktype;
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

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon == null ? null : icon.trim();
    }
    
    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark == null ? null : remark.trim();
    }
    
    public Integer getGid() {
        return gid;
    }

    public void setGid(Integer gid) {
        this.gid = gid;
    }
}