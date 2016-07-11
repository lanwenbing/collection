package com.collections.controller;

import java.util.List;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.collections.model.ContentModel;
import com.collections.model.ControllerResult;
import com.collections.model.TypeModel;
import com.collections.service.ContentService;

@Controller  
@RequestMapping("/manage")
public class ManagementController{
	

	@Autowired
	private ContentService contentService;
	
	private static Logger logger = Logger.getLogger(ManagementController.class);
	
	@RequestMapping("/init")
	public String init(HttpServletRequest request) {
		List<TypeModel> types = contentService.queryTypes();
		request.setAttribute("types", types);
		return "getcatalogformanagement";
	}
	
	@RequestMapping(value="/getcatalog", method=RequestMethod.POST)   
	@ResponseBody
	public ControllerResult<List<ContentModel>> getCatalog(HttpServletRequest request,HttpServletResponse response) {
		
		Integer type = request.getParameter("type")!=null&&request.getParameter("type")!=""&&request.getParameter("type")!="none"?Integer.valueOf(request.getParameter("type")):0;
		String desc = (String) request.getParameter("desc");
		Integer numInOnePage = Integer.valueOf(request.getParameter("numInOnePage")!=null?request.getParameter("numInOnePage"):"5");
		Integer currentPageNum = Integer.valueOf(request.getParameter("currentPageNum")!=null?request.getParameter("currentPageNum"):"1");
		ControllerResult<List<ContentModel>> catalog = contentService.searchCatalog(type, desc, numInOnePage, currentPageNum);
		catalog.setStatus(200);
		catalog.setDescription("");
		return catalog;
	}
	
	@RequestMapping("/articlemanagement/{id}")
	public String searchContent(@PathVariable("id") Integer id,HttpServletRequest request) {
		List<TypeModel> types = contentService.queryTypes();
		request.setAttribute("types", types);
		if(id==0){
			return "articlemanagement";
		}
		ContentModel content = contentService.searchContent(id);
		request.setAttribute("content", content);
		
		return "articlemanagement";
	}
	
	@RequestMapping(value="/articlemanagement/createOrUpdate/{id}", method=RequestMethod.POST)
	@ResponseBody
	public ControllerResult<ContentModel> createOrUpdate(@PathVariable("id") Integer id,HttpServletRequest request) {

		String title = (String) request.getParameter("title");
		String keywords = (String) request.getParameter("keywords");
		Integer typeId = Integer.valueOf((String)request.getParameter("type"));
		String content = (String) request.getParameter("content");
		ContentModel model = new ContentModel();
		model.setTitle(title);
		model.setContent(content);
		model.setKeywords(keywords);
		model.setId(id);
		model.setTypeId(typeId);
		Integer resultId = contentService.saveOrUpdateContent(model);
		
		ControllerResult<ContentModel> result = new ControllerResult<ContentModel>();
		if(resultId!=null){
			result.setContent(model);
			result.setStatus(200);
		}else{
			result.setStatus(100);
		}
		
		return result;
	}
	
}
