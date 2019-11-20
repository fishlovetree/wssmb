package com.ssm.wssmb.model;

public class RoutePath {
    private Integer pathid;

    private String pathname;

    private Integer sourcenum;

    private Integer targetnum;

    private Float pathcost;

    private Short isclosed;

    private String coordinates;

    private Short status;
    
    private Integer buildingid;
    
    private Integer partid;

    public Integer getPathid() {
        return pathid;
    }

    public void setPathid(Integer pathid) {
        this.pathid = pathid;
    }

    public String getPathname() {
        return pathname;
    }

    public void setPathname(String pathname) {
        this.pathname = pathname == null ? null : pathname.trim();
    }

    public Integer getSourcenum() {
        return sourcenum;
    }

    public void setSourcenum(Integer sourcenum) {
        this.sourcenum = sourcenum;
    }

    public Integer getTargetnum() {
        return targetnum;
    }

    public void setTargetnum(Integer targetnum) {
        this.targetnum = targetnum;
    }

    public Float getPathcost() {
        return pathcost;
    }

    public void setPathcost(Float pathcost) {
        this.pathcost = pathcost;
    }

    public Short getIsclosed() {
        return isclosed;
    }

    public void setIsclosed(Short isclosed) {
        this.isclosed = isclosed;
    }

    public String getCoordinates() {
        return coordinates;
    }

    public void setCoordinates(String coordinates) {
        this.coordinates = coordinates == null ? null : coordinates.trim();
    }

    public Short getStatus() {
        return status;
    }

    public void setStatus(Short status) {
        this.status = status;
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
}