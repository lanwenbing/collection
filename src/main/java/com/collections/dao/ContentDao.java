package com.collections.dao;

import java.util.List;

import com.collections.model.ContentModel;
import com.collections.model.TypeModel;

public interface ContentDao {

	public ContentModel queryContent(Integer id);

	public List<ContentModel> queryCatalog(Integer type, String desc, Integer startFrom, Integer numInOnePage);
	
	public List<TypeModel> queryTypes();
	public int catalogTotalCount(Integer type, String desc);
	
	public int saveContent(ContentModel model);
	
	public int updateContent(ContentModel model);
}
