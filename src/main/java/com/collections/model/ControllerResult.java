package com.collections.model;

import java.io.Serializable;

public class ControllerResult<T> extends BaseControllerResult implements Serializable{

	
	/**
	 * 
	 */
	private static final long serialVersionUID = -2282171672263161608L;
	private T content;
	private int allPageNum;
	private int currentPageNum;
	private int numInOnePage;

	public T getContent() {
		return content;
	}

	public void setContent(T content) {
		this.content = content;
	}

	public int getAllPageNum() {
		return allPageNum;
	}

	public void setAllPageNum(int allPageNum) {
		this.allPageNum = allPageNum;
	}

	public int getCurrentPageNum() {
		return currentPageNum;
	}

	public void setCurrentPageNum(int currentPageNum) {
		this.currentPageNum = currentPageNum;
	}

	public int getNumInOnePage() {
		return numInOnePage;
	}

	public void setNumInOnePage(int numInOnePage) {
		this.numInOnePage = numInOnePage;
	}

}
