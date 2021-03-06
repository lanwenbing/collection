<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<% 
String path = request.getContextPath(); 
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/"; 
pageContext.setAttribute("basePath",basePath); 
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>文章搜索</title>
<link href="${basePath}css/bootstrap-3.3.6/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="${basePath}css/getcatalog.css" media="screen">
<script src="${basePath}js/jquery/jquery.min.js"></script>
</head>
<body>
<div class="add"><a href="${basePath}manage/articlemanagement/0.do">添加文章</a></div>
<div class="title">文章搜索</div>
<div class="introduction center">
	<form class="navbar-form" role="search" action="${basePath}manage/getcatalog.do" id="submit_form">
	  <div class="form-group">
	    <div class="input-group"> 
		  <input type="text" class="form-control" placeholder="搜索" name="desc" value="${desc}" id="desc">         
		  <div class="input-group-btn">
	        <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" >
		     <span id="typedesc">类型&nbsp;&nbsp;&nbsp;</span><span class="caret"></span>         
	        </button>
	        <input type="hidden" id="typeid" name="type" value="${type}">
	        <ul class="dropdown-menu pull-right">
	        	<li><a href="javascript:void(0);" onclick="changeType('none','类型&nbsp;&nbsp;&nbsp;' );">类型&nbsp;&nbsp;&nbsp;</a></li>
	        	<c:forEach var="type" items="${types}">
	          		<li><a href="javascript:void(0);" onclick="changeType('${type.id}', '${type.desc}');" id="${type.id}">${type.desc}</a></li>
	          	</c:forEach>
	        </ul>
	      </div>
	    </div>
    	<%-- <input type="text" class="form-control" placeholder="每页篇数" name="numInOnePage" value="${result.numInOnePage}" id="numInOnePage" onchange="changePage();"> --%>
	  </div>
	  <button type="button" class="btn btn-default" onclick="getCatalog(1);">提交</button>
	</form>
</div>
<div class="subcontent">
	<div>
		<table class="table table-striped table-bordered" id="contenttable">
		<thead id="thead">
			<tr>
				<th class='col-left col-sm-1'>序号</th>
				<th class='col-left col-sm-2'>logo</th>
				<th class='col-left col-sm-3'>标题</th>
				<th class='col-left col-sm-3'>关键字</th>
				<th class='col-left col-sm-3'>编辑</th>
			</tr>
		</thead>
		<tbody id="tbody"></tbody>
		</table>
	</div>
	<nav class="center">
	  <ul class="pagination" id="pagination"></ul>
	</nav>
</div>
<script type="text/javascript">
	getCatalog(1);
	var lastPageNum = 0;
	function changeType(id,desc){
		require(["dojo/dom"],
			    function(dom){
		var typeid = dom.byId('typeid');
	    var typedesc = dom.byId('typedesc');
	    typeid.value = id;
	    typedesc.innerHTML = desc ;
		}); 
	}
	function changePage(){
		lastPageNum = 0;
	}
	function getCatalog(currentPageNum){
		if(currentPageNum<=0)
			currentPageNum=1;
	    require(["dojo/dom", "dojo/on", "dojo/request", "dojo/dom-construct", "dojo/json"],
	    	    function(dom, on, request, domConstruct, JSON){

	    	        var form = dom.byId('submit_form');
	    	        var desc = dom.byId('desc').value;
	    	        var typeid = dom.byId('typeid').value;
	    	       /*  var numInOnePage = dom.byId('numInOnePage').value; */
	    	        var numInOnePage = 10;
    	            // Post the data to the server
    	            request.post("${basePath}manage/getcatalog.do", {
    	                data: {
    	                	currentPageNum:currentPageNum,
    	                	desc:desc,
    	                	type:typeid,
    	                	numInOnePage:numInOnePage
    	                },
    	                handleAs: "json"
    	            }).then(function(response){
    	            	if(response.status==200){
    	            		var list = response.content;
    	            		var pagination = dom.byId('pagination');
    	            		var tbody = dom.byId("tbody");
	    	            		domConstruct.empty("tbody");
	    	            		for(var i=0;i<list.length;i++){
	    	            			if(list[i].imageDir!=""&&list[i].imageDir!=undefined){
	    	            				domConstruct.create("tr", {
				    	                    innerHTML: "<td class='col-left col-sm-1'>"+list[i].id+"</td><td class='col-left col-sm-1'><img src="+"${basePath}"+list[i].imageDir+" height='30' width='30'></td><td class='col-left col-sm-4'>"+list[i].title+"</td><td class='col-left col-sm-4'>"+list[i].keywords+"</td><td class='col-left col-sm-4'><a href='${basePath}manage/articlemanagement/"+list[i].id+".do'>"+list[i].title+"</a></td>"
				    	                }, tbody);
	    	            			}else{
				    	                domConstruct.create("tr", {
				    	                    innerHTML: "<td class='col-left col-sm-1'>"+list[i].id+"</td><td class='col-left col-sm-1'></td><td class='col-left col-sm-4'>"+list[i].title+"</td><td class='col-left col-sm-4'>"+list[i].keywords+"</td><td class='col-left col-sm-4'><a href='${basePath}manage/articlemanagement/"+list[i].id+".do'>"+list[i].title+"</a></td>"
				    	                }, tbody);
	    	            			}
	    	            		}
	    	            		if(lastPageNum!=0&&response.allPageNum-response.currentPageNum<=1){
	    	            		}else{
	    	            			domConstruct.empty("pagination");
		    	            		if(response.currentPageNum-1>0){
		    	            			var num = response.currentPageNum-1;
		    	            			domConstruct.create("li", {
				    	                    innerHTML: "<a href='javascript:void(0);' aria-label='Previous' onclick='getCatalog("+num+");'><span aria-hidden='true'>&laquo;</span></a>"
				    	                }, pagination);
		    	            		}else{
		    	            			domConstruct.create("li", {
				    	                    innerHTML: "<a href='javascript:void(0);' aria-label='Previous' onclick='getCatalog("+response.currentPageNum+");'><span aria-hidden='true'>&laquo;</span></a>"
				    	                }, pagination);
		    	            		}
		    	            		domConstruct.create("li", {
			    	                    innerHTML: "<a href='javascript:void(0);' aria-label='Previous' onclick='getCatalog("+response.currentPageNum+");'><span aria-hidden='true'>"+response.currentPageNum+"</span></a>"
			    	                }, pagination);
		    	            		if(response.allPageNum>=response.currentPageNum+1){
		    	            			var num = response.currentPageNum+1;
		    	            			domConstruct.create("li", {
		    	    	                    innerHTML: "<a href='javascript:void(0);' onclick='getCatalog("+num+");'><span aria-hidden='true'>"+num+"</span></a>"
		    	    	                }, pagination);
		    	            		}
		    	            		if(response.allPageNum>=response.currentPageNum+2){
		    	            			var num = response.currentPageNum+2;
		    	            			domConstruct.create("li", {
		    	    	                    innerHTML: "<a href='javascript:void(0);' onclick='getCatalog("+num+");'><span aria-hidden='true'>"+num+"</span></a>"
		    	    	                }, pagination);
		    	            		}
		    	            		if(response.allPageNum>=response.currentPageNum+3){
		    	            			var num = response.currentPageNum+3;
		    	            			domConstruct.create("li", {
		    	    	                    innerHTML: "<a href='javascript:void(0);' onclick='getCatalog("+num+");'><span aria-hidden='true'>"+num+"</span></a>"
		    	    	                }, pagination);
		    	            		}
		    	            		if(response.currentPageNum == response.allPageNum || response.currentPageNum+1 == response.allPageNum||response.currentPageNum+2 == response.allPageNum || response.currentPageNum+3 == response.allPageNum){
		    	            			lastPageNum = response.allPageNum;
		    	            		}else{
		    	            			lastPageNum = response.currentPageNum+1;
		    	            		}
		    	            		domConstruct.create("li", {
			    	                    innerHTML: "<a href='javascript:void(0);' aria-label='Next' onclick='getCatalog("+lastPageNum+");'><span aria-hidden='true'>&raquo;</span></a>"
			    	                }, pagination);
	    	            		}
    	            		}
    	            },function(error){
    	            	console.log("An error occurred: " + error);
    	            });
	    	    }
	    	);
	}
</script>
</body>
</html>