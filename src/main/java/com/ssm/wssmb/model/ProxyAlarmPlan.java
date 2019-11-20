package com.ssm.wssmb.model;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

public class ProxyAlarmPlan {
    private Integer id;

    private Integer proxyid;

    private Integer almenathreshold;

    private Integer mandatary;

    private Integer fepconfig;

    private Integer dialerconfig;

    private Integer dialernum;

    private String dialermodel;

    private String soundcontent;

    private Integer soundplaytime;

    private Integer dialmode;

    private Integer smsconfig;

    private Integer smsnum;

    private String smsmodel;

    private String smscontent;

    private Integer smsmode;

    private Integer status;

    private Integer compactor;

    @DateTimeFormat(pattern="yyyy-MM-dd")
    private Date compilationtime;
    
    private String organizationname;
    
    private String organizationcode;
    
    private String username;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getProxyid() {
        return proxyid;
    }

    public void setProxyid(Integer proxyid) {
        this.proxyid = proxyid;
    }

    public Integer getAlmenathreshold() {
        return almenathreshold;
    }

    public void setAlmenathreshold(Integer almenathreshold) {
        this.almenathreshold = almenathreshold;
    }

    public Integer getMandatary() {
        return mandatary;
    }

    public void setMandatary(Integer mandatary) {
        this.mandatary = mandatary;
    }

    public Integer getFepconfig() {
        return fepconfig;
    }

    public void setFepconfig(Integer fepconfig) {
        this.fepconfig = fepconfig;
    }

    public Integer getDialerconfig() {
        return dialerconfig;
    }

    public void setDialerconfig(Integer dialerconfig) {
        this.dialerconfig = dialerconfig;
    }

    public Integer getDialernum() {
        return dialernum;
    }

    public void setDialernum(Integer dialernum) {
        this.dialernum = dialernum;
    }

    public String getDialermodel() {
        return dialermodel;
    }

    public void setDialermodel(String dialermodel) {
        this.dialermodel = dialermodel == null ? null : dialermodel.trim();
    }

    public String getSoundcontent() {
        return soundcontent;
    }

    public void setSoundcontent(String soundcontent) {
        this.soundcontent = soundcontent == null ? null : soundcontent.trim();
    }

    public Integer getSoundplaytime() {
        return soundplaytime;
    }

    public void setSoundplaytime(Integer soundplaytime) {
        this.soundplaytime = soundplaytime;
    }

    public Integer getDialmode() {
        return dialmode;
    }

    public void setDialmode(Integer dialmode) {
        this.dialmode = dialmode;
    }

    public Integer getSmsconfig() {
        return smsconfig;
    }

    public void setSmsconfig(Integer smsconfig) {
        this.smsconfig = smsconfig;
    }

    public Integer getSmsnum() {
        return smsnum;
    }

    public void setSmsnum(Integer smsnum) {
        this.smsnum = smsnum;
    }

    public String getSmsmodel() {
        return smsmodel;
    }

    public void setSmsmodel(String smsmodel) {
        this.smsmodel = smsmodel == null ? null : smsmodel.trim();
    }

    public String getSmscontent() {
        return smscontent;
    }

    public void setSmscontent(String smscontent) {
        this.smscontent = smscontent == null ? null : smscontent.trim();
    }

    public Integer getSmsmode() {
        return smsmode;
    }

    public void setSmsmode(Integer smsmode) {
        this.smsmode = smsmode;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Integer getCompactor() {
        return compactor;
    }

    public void setCompactor(Integer compactor) {
        this.compactor = compactor;
    }

    public Date getCompilationtime() {
        return compilationtime;
    }

    public void setCompilationtime(Date compilationtime) {
        this.compilationtime = compilationtime;
    }

	public String getOrganizationname() {
		return organizationname;
	}

	public void setOrganizationname(String organizationname) {
		this.organizationname = organizationname;
	}

	public String getOrganizationcode() {
		return organizationcode;
	}

	public void setOrganizationcode(String organizationcode) {
		this.organizationcode = organizationcode;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}
}