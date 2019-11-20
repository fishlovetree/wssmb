package com.ssm.wssmb.model;

public class RouteVertices {
    private Integer pointnum;

    private String pointname;

    private String coordinate;

    private Short isexit;

    private Integer buildingid;
    
    private Integer partid;

    private Short status;
    
    private Integer mannum;

    public Integer getPointnum() {
        return pointnum;
    }

    public void setPointnum(Integer pointnum) {
        this.pointnum = pointnum;
    }

    public String getPointname() {
        return pointname;
    }

    public void setPointname(String pointname) {
        this.pointname = pointname == null ? null : pointname.trim();
    }

    public String getCoordinate() {
        return coordinate;
    }

    public void setCoordinate(String coordinate) {
        this.coordinate = coordinate == null ? null : coordinate.trim();
    }

    public Short getIsexit() {
        return isexit;
    }

    public void setIsexit(Short isexit) {
        this.isexit = isexit;
    }

    public Integer getBuildingid() {
        return buildingid;
    }

    public void setBuildingid(Integer buildingid) {
        this.buildingid = buildingid;
    }
    
    public Integer getPartid() {
        return partid;
    }

    public void setPartid(Integer partid) {
        this.partid = partid;
    }

    public Short getStatus() {
        return status;
    }

    public void setStatus(Short status) {
        this.status = status;
    }
    
    public Integer getMannum() {
        return mannum;
    }

    public void setMannum(Integer mannum) {
        this.mannum = mannum;
    }
}