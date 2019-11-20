package com.ssm.wssmb.model;

import java.io.Serializable;
import java.util.List;

public class TreeNode implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private String id;

    private Integer gid;

    private String name;

    private String text;
    
    private Integer type;
    
    private String parentid;
    
    private Integer parenttype; 
    
    private String state;
    
    private String iconCls;
    
    private boolean checked;
    
    public String getIconCls() {
		return iconCls;
	}

	public void setIconCls(String iconCls) {
		this.iconCls = iconCls;
	}

	private List<TreeNode> children;
    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }
    
    public Integer getGid() {
        return gid;
    }

    public void setGid(Integer gid) {
        this.gid = gid;
    }
    
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
    
    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }
    
    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }
    
    public String getParentid() {
		return parentid;
	}

	public void setParentid(String parentid) {
		this.parentid = parentid;
	}

	public Integer getParenttype() {
		return parenttype;
	}

	public void setParenttype(Integer parenttype) {
		this.parenttype = parenttype;
	}

	public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }
    
    public boolean isChecked() {
		return checked;
	}

	public void setChecked(boolean checked) {
		this.checked = checked;
	}

	public List<TreeNode> getChildren() {
        return children;
    }

    public void setChildren(List<TreeNode> children) {
        this.children = children;
    }

	@Override
	public String toString() {
		return "TreeNode [id=" + id + ", gid=" + gid + ", name=" + name + ", text=" + text + ", type=" + type
				+ ", parentid=" + parentid + ", parenttype=" + parenttype + ", state=" + state + ", iconCls=" + iconCls
				+ ", checked=" + checked + ", children=" + children + "]";
	}
    
    
}
