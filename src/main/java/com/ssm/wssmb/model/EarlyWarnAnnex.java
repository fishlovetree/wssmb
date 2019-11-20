package com.ssm.wssmb.model;

import java.util.Arrays;

/**
 * @Description: 预警附件实体类
 * @Author 
 * @Time: 
 */
public class EarlyWarnAnnex {
	//附件id
    private Integer annexid;
    
    //预警id
    private Integer id;
    
    //附件名称
    private String annexname;
    
    //附件
    private byte[] annex;
    
    
    public EarlyWarnAnnex(){
    	super();
    }
    
    public EarlyWarnAnnex(Integer id,String annexname,byte[] annex){
    	this.id=id;
    	this.annexname=annexname;
    	this.annex=annex;
    }
    public Integer getAnnexid() {
        return annexid;
    }

    public void setAnnexid(Integer annexid) {
        this.annexid = annexid;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getAnnexname() {
        return annexname;
    }

    public void setAnnexname(String annexname) {
        this.annexname = annexname == null ? null : annexname.trim();
    }

    public byte[] getAnnex() {
        return annex;
    }

    public void setAnnex(byte[] annex) {
        this.annex = annex;
    }

	@Override
	public String toString() {
		return "EarlyWarnAnnex [annexid=" + annexid + ", id=" + id + ", annexname=" + annexname + ", annex="
				+ Arrays.toString(annex) + "]";
	}
    
    
}