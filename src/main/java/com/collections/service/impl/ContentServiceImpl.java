package com.collections.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.collections.dao.ContentDao;
import com.collections.model.ContentModel;
import com.collections.model.ControllerResult;
import com.collections.model.TypeModel;
import com.collections.service.ContentService;

@Service
public class ContentServiceImpl implements ContentService {

	@Autowired
	private ContentDao contentDao;

	public ContentModel searchContent(Integer id) {

		ContentModel content = contentDao.queryContent(id);
		
		return content;

	}

	public ControllerResult<List<ContentModel>> searchCatalog(Integer type, String desc, Integer numInOnePage, Integer currentPageNum) {

		List<ContentModel> list = new ArrayList<ContentModel>();
		Integer startFrom = (currentPageNum-1)*numInOnePage;
		list = contentDao.queryCatalog(type, desc, startFrom, numInOnePage);
		ControllerResult<List<ContentModel>> result = new ControllerResult<List<ContentModel>>();
		result.setContent(list);
		result.setNumInOnePage(numInOnePage);
		result.setCurrentPageNum(currentPageNum);
		int catalogTotalCount = contentDao.catalogTotalCount(type, desc);
		Integer allPageNum = catalogTotalCount%numInOnePage==0?catalogTotalCount/numInOnePage:catalogTotalCount/numInOnePage+1;
		result.setAllPageNum(allPageNum);
		return result;

	}

	public List<TypeModel> queryTypes() {
		List<TypeModel> types = contentDao.queryTypes();
		return types;
	}

	public Integer saveOrUpdateContent(ContentModel model) {
		Integer id = null;
		if(model.getId()!=null)
			id = contentDao.updateContent(model);
		else
			id = contentDao.saveContent(model);
		return id;
	}


}
