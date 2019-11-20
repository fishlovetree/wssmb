package com.ssm.wssmb.model;

import java.io.Serializable;
import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

public class MbConcentrator implements Serializable {
	private static final long serialVersionUID = 1L;
	
    private Integer id;

    private String name;
    
    private String address;

    private Integer status;
    
    @DateTimeFormat(pattern="yyyy-MM-dd hh:mm:ss")
    private Date onlinetime;

    @DateTimeFormat(pattern="yyyy-MM-dd hh:mm:ss")
    private String offlinetime;
    
    private String installaddress;
    
    private String coordinate;

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

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public Date getOnlinetime() {
		return onlinetime;
	}

	public void setOnlinetime(Date onlinetime) {
		this.onlinetime = onlinetime;
	}

	public String getOfflinetime() {
		return offlinetime;
	}

	public void setOfflinetime(String offlinetime) {
		this.offlinetime = offlinetime;
	}

	public String getInstalladdress() {
		return installaddress;
	}

	public void setInstalladdress(String installaddress) {
		this.installaddress = installaddress;
	}

	public String getCoordinate() {
		return coordinate;
	}

	public void setCoordinate(String coordinate) {
		this.coordinate = coordinate;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
   
    
   
}