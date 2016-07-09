package com.collections.service;

import java.util.List;

import com.collections.model.ContentModel;
import com.collections.model.ControllerResult;
import com.collections.model.TypeModel;

public interface ContentService {

	public ContentModel searchContent(Integer id);

	public ControllerResult searchCatalog(Integer type, String desc, Integer numInOnePage, Integer currentPageNum);
	
	public List<TypeModel> queryTypes();
	
	public Integer saveOrUpdateContent(ContentModel model);

}
