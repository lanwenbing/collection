package com.collections.model;

import java.io.Serializable;

public class BaseControllerResult implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -8840390753603675418L;
	private Integer status; 
	private String description;
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	
	
	
}
