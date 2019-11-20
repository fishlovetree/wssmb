package com.ssm.wssmb.util;

public enum TreeType{
	Organization("组织机构树", 1), 
	Region("区域树", 2),
	MeasureFile("表箱",3),
	Concentrator("集中器",4),
	Terminal("终端",5),
	Ammeter("电表",6);

    private String name ;
    private int index ;
     
    private TreeType(String name , int index ){
        this.name = name ;
        this.index = index ;
    }
     
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public int getIndex() {
        return index;
    }
    public void setIndex(int index) {
        this.index = index;
    }
}