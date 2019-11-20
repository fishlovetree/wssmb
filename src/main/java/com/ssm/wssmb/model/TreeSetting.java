package com.ssm.wssmb.model;

/**
 * 树节点收起配置
 * @author hxl
 *
 */
public class TreeSetting {
	
	private String code;

    private String nodeid;
    
    private Integer treetype;

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getNodeid() {
		return nodeid;
	}

	public void setNodeid(String nodeid) {
		this.nodeid = nodeid;
	}

	public Integer getTreetype() {
		return treetype;
	}

	public void setTreetype(Integer treetype) {
		this.treetype = treetype;
	}
}
