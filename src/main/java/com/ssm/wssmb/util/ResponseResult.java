package com.ssm.wssmb.util;

import com.fasterxml.jackson.annotation.JsonProperty;

public class ResponseResult {

	 @JsonProperty("code")
	public int code;
	
	 @JsonProperty("message")
	public String message;
	
	 @JsonProperty("rows")
	public Object rows;
	 
	 @JsonProperty("total")
	 public int total;

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public Object getRows() {
		return rows;
	}

	public void setRows(Object rows) {
		this.rows = rows;
	}

	public int getTotal() {
		return total;
	}

	public void setTotal(int total) {
		this.total = total;
	}
	 
	 
}
