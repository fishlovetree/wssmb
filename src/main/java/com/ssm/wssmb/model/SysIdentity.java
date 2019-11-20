package com.ssm.wssmb.model;

public class SysIdentity {
    private String identityname;

    private String identitydescribing;

    private Long identityvalue;

    public String getIdentityname() {
        return identityname;
    }

    public void setIdentityname(String identityname) {
        this.identityname = identityname == null ? null : identityname.trim();
    }

    public String getIdentitydescribing() {
        return identitydescribing;
    }

    public void setIdentitydescribing(String identitydescribing) {
        this.identitydescribing = identitydescribing == null ? null : identitydescribing.trim();
    }

    public Long getIdentityvalue() {
        return identityvalue;
    }

    public void setIdentityvalue(Long identityvalue) {
        this.identityvalue = identityvalue;
    }
}