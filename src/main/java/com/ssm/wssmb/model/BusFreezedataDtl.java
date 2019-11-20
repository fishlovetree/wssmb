package com.ssm.wssmb.model;

public class BusFreezedataDtl {
    private Long dltid;

    private Long id;

    private String oad;

    private String oi;

    private Short attribute;

    private Short indexes;

    private Short groupindex;

    private String data;

    public Long getDltid() {
        return dltid;
    }

    public void setDltid(Long dltid) {
        this.dltid = dltid;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getOad() {
        return oad;
    }

    public void setOad(String oad) {
        this.oad = oad == null ? null : oad.trim();
    }

    public String getOi() {
        return oi;
    }

    public void setOi(String oi) {
        this.oi = oi == null ? null : oi.trim();
    }

    public Short getAttribute() {
        return attribute;
    }

    public void setAttribute(Short attribute) {
        this.attribute = attribute;
    }

    public Short getIndexes() {
        return indexes;
    }

    public void setIndexes(Short indexes) {
        this.indexes = indexes;
    }

    public Short getGroupindex() {
        return groupindex;
    }

    public void setGroupindex(Short groupindex) {
        this.groupindex = groupindex;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data == null ? null : data.trim();
    }
}