package com.ssm.wssmb.model;

public class Region {
    private Integer id;

    private String name;

    private Integer parentid;

    private Short status;

    private String shortname;
    
    private Integer leveltype;
    
    private String citycode;
    
    private String zipcode;
    
    private String mergername;
    
    private String lng;
    
    private String lat;
    
    private String pinyin;
    
    private String regionname;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer getParentid() {
		return parentid;
	}

	public void setParentid(Integer parentid) {
		this.parentid = parentid;
	}

	public Short getStatus() {
		return status;
	}

	public void setStatus(Short status) {
		this.status = status;
	}

	public String getShortname() {
		return shortname;
	}

	public void setShortname(String shortname) {
		this.shortname = shortname;
	}

	public Integer getLeveltype() {
		return leveltype;
	}

	public void setLeveltype(Integer leveltype) {
		this.leveltype = leveltype;
	}

	public String getCitycode() {
		return citycode;
	}

	public void setCitycode(String citycode) {
		this.citycode = citycode;
	}

	public String getZipcode() {
		return zipcode;
	}

	public void setZipcode(String zipcode) {
		this.zipcode = zipcode;
	}

	public String getMergername() {
		return mergername;
	}

	public void setMergername(String mergername) {
		this.mergername = mergername;
	}

	public String getLng() {
		return lng;
	}

	public void setLng(String lng) {
		this.lng = lng;
	}

	public String getLat() {
		return lat;
	}

	public void setLat(String lat) {
		this.lat = lat;
	}

	public String getPinyin() {
		return pinyin;
	}

	public void setPinyin(String pinyin) {
		this.pinyin = pinyin;
	}

	public String getRegionname() {
		return regionname;
	}

	public void setRegionname(String regionname) {
		this.regionname = regionname;
	}

	@Override
	public String toString() {
		return "Region [id=" + id + ", name=" + name + ", parentid=" + parentid + ", status=" + status + ", shortname="
				+ shortname + ", leveltype=" + leveltype + ", citycode=" + citycode + ", zipcode=" + zipcode
				+ ", mergername=" + mergername + ", lng=" + lng + ", lat=" + lat + ", pinyin=" + pinyin
				+ ", regionname=" + regionname + "]";
	}
	
	
}