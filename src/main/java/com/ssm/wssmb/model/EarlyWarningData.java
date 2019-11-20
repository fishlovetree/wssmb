package com.ssm.wssmb.model;

/**
 * @Description: 预警图形数据
 * @Author wys
 * @Time: 2018年1月23日
 */
public class EarlyWarningData {
	private String name;

	private Integer value;

	private String dateStr;

	public String getDateStr() {
		return dateStr;
	}

	public void setDateStr(String dateStr) {
		this.dateStr = dateStr;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer getValue() {
		return value;
	}

	public void setValue(Integer value) {
		this.value = value;
	}

	@Override
	public String toString() {
		return "EarlyWarningData [name=" + name + ", value=" + value + ", dateStr=" + dateStr + "]";
	}
	
	
}
