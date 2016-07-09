<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<%@ taglib uri="http://ckeditor.com" prefix="ckeditor" %>
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
<title>文章编辑</title>
<script src="${basePath}js/ckeditor/ckeditor.js"></script>
<style type="text/css">
.message{
	color:red;
}
</style>
</head>
<body>
<div class="title">
	<label>文章编辑</label>
</div>
<div class="subcontent">
	<div id="message" class="message"></div>
	<form action ="${basePath}manage/articlemanagement/createOrUpdate/${content.id}.do" method="post" id="submit_form">
	  <fieldset>
	    <div class="form-group">
	      <label for="disabledTextInput">文章标题：</label>
	      <input type="text" class="form-control" id="title" value="<c:out value='${content.title}'/>">
	    </div>
	    <div class="form-group">
	      <label for="disabledTextInput">关键字：</label>
	      <input type="text"  class="form-control" id="keywords" value="<c:out value='${content.keywords}'/>">
	    </div>
	    <div class="form-group">
	      <label for="disabledSelect">类型：</label>
	      <select  class="form-control" id="type" >
	      	<option>请选择</option>
	      	<c:forEach var="type" items="${types}">
          		<option value="${type.id}" <c:if test='${content.typeId == type.id}'>selected='selected'</c:if>>${type.desc}</option>
          	</c:forEach>
	      </select>
	    </div>
	    <div class="form-group">
	      <label for="disabledTextInput">文章内容：</label>
	      <textarea name="editor" id="editor" rows="10" cols="80">
                <c:out value="${content.content}"/>
            </textarea>
	    </div>
	    <button type="submit" class="btn btn-primary">提交</button>
	  </fieldset>
	</form>
	<ckeditor:replace replace="editor1" basePath="/ckeditor/" />
</div>
<script>
    CKEDITOR.replace( 'editor' ,
        {filebrowserBrowseUrl : '/browser/browse.php',
         filebrowserImageBrowseUrl : '${basePath}upload/uploadImg.do?type=Images',
         filebrowserUploadUrl : '/uploader/upload.php',
         filebrowserImageUploadUrl : '${basePath}upload/uploadImg.do?type=Images'}
    );
    CKEDITOR.config.width='600';
    CKEDITOR.config.height='100';
    
    require(["dojo/dom", "dojo/on", "dojo/request", "dojo/dom-form", "dojo/json"],
    	    function(dom, on, request, domForm, JSON){

    	        var form = dom.byId('submit_form');
    	        var titleDom = dom.byId('title');
    	        var keywordsDom = dom.byId('keywords');
    	        var typeDom = dom.byId('type');
    	        var message = dom.byId('message');
    	        // Attach the onsubmit event handler of the form
    	        on(form, "submit", function(evt){

    	            // prevent the page from navigating after submit
    	            evt.stopPropagation();
    	            evt.preventDefault();
    	            var content = CKEDITOR.instances.editor.getData();
    	            title = titleDom.value;
        	        keywords = keywordsDom.value;
        	        type = typeDom.value;
    	            // Post the data to the server
    	            request.post("${basePath}manage/articlemanagement/createOrUpdate/${content.id}.do", {
    	                // Send the username and password
    	                data: {
    	                	content:content,
    	                	title:title,
    	                	keywords:keywords,
    	                	type:type
    	                },
    	                handleAs: "json"
    	            }).then(function(response){
    	            	if(response.status == 200){
    	            		message.innerHTML = "添加成功！";
    	                };
    	            });
    	        });
    	    }
    	);
</script>
</body>
</html>