package com.ssm.wssmb.model;

public class ThreeModel {
    private String modelcode;

    private String modelname;

    private String modelurl;

    private Short status;

    private String position;

    private String rotation;

    private String label;
    
    private Short modeltype;
    
    private String cameraposition;

    private String cameratarget;

    public String getModelcode() {
        return modelcode;
    }

    public void setModelcode(String modelcode) {
        this.modelcode = modelcode == null ? null : modelcode.trim();
    }

    public String getModelname() {
        return modelname;
    }

    public void setModelname(String modelname) {
        this.modelname = modelname == null ? null : modelname.trim();
    }

    public String getModelurl() {
        return modelurl;
    }

    public void setModelurl(String modelurl) {
        this.modelurl = modelurl == null ? null : modelurl.trim();
    }

    public Short getStatus() {
        return status;
    }

    public void setStatus(Short status) {
        this.status = status;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position == null ? null : position.trim();
    }

    public String getRotation() {
        return rotation;
    }

    public void setRotation(String rotation) {
        this.rotation = rotation == null ? null : rotation.trim();
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label == null ? null : label.trim();
    }
    
    public Short getModeltype() {
        return modeltype;
    }

    public void setModeltype(Short modeltype) {
        this.modeltype = modeltype;
    }
    
    public String getCameraposition() {
        return cameraposition;
    }

    public void setCameraposition(String cameraposition) {
        this.cameraposition = cameraposition == null ? null : cameraposition.trim();
    }
    
    public String getCameratarget() {
        return cameratarget;
    }

    public void setCameratarget(String cameratarget) {
        this.cameratarget = cameratarget == null ? null : cameratarget.trim();
    }
}