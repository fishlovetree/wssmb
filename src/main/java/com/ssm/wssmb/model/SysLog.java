package com.ssm.wssmb.model;

import java.util.Date;

public class SysLog {
    private Integer logid;

    private Integer userid;

    private String ip;

    private String title;

    private String content;

    private Integer opertype;

    private Date intime;
    
    private String username;
    
    private String operatename;
    
	public String getOperatename() {
		return operatename;
	}

	public void setOperatename(String operatename) {
		this.operatename = operatename;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public Integer getLogid() {
        return logid;
    }

    public void setLogid(Integer logid) {
        this.logid = logid;
    }

    public Integer getUserid() {
        return userid;
    }

    public void setUserid(Integer userid) {
        this.userid = userid;
    }

    public String getIp() {
        return ip;
    }

    public void setIp(String ip) {
        this.ip = ip == null ? null : ip.trim();
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title == null ? null : title.trim();
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content == null ? null : content.trim();
    }

    public Integer getOpertype() {
        return opertype;
    }

    public void setOpertype(Integer opertype) {
        this.opertype = opertype;
    }

    public Date getIntime() {
        return intime;
    }

    public void setIntime(Date intime) {
        this.intime = intime;
    }

	@Override
	public String toString() {
		return "SysLog [logid=" + logid + ", userid=" + userid + ", ip=" + ip + ", title=" + title + ", content="
				+ content + ", opertype=" + opertype + ", intime=" + intime + ", username=" + username
				+ ", operatename=" + operatename + "]";
	}
      
}