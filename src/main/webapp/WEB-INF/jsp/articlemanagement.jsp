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
<link href="${basePath}js/jquery/css/jquery.fileupload.css" rel="stylesheet">
<link href="${basePath}js/jquery/css/jquery.fileupload-ui.css" rel="stylesheet">
<script src="${basePath}js/jquery/jquery.min.js"></script>
<script src="${basePath}css/bootstrap-3.3.6/js/bootstrap.min.js"></script>
<script src="${basePath}js/ckeditor/ckeditor.js"></script>
<!-- The jQuery UI widget factory, can be omitted if jQuery UI is already included -->
<script src="${basePath}js/jquery/vendor/jquery.ui.widget.js"></script>
<!-- The Load Image plugin is included for the preview images and image resizing functionality -->
<script src="//blueimp.github.io/JavaScript-Load-Image/js/load-image.all.min.js"></script>
<!-- The Canvas to Blob plugin is included for image resizing functionality -->
<script src="//blueimp.github.io/JavaScript-Canvas-to-Blob/js/canvas-to-blob.min.js"></script>
<!-- The Iframe Transport is required for browsers without support for XHR file uploads -->
<script src="${basePath}js/jquery/jquery.iframe-transport.js"></script>
<!-- The basic File Upload plugin -->
<script src="${basePath}js/jquery/jquery.fileupload.js"></script>
<!-- The File Upload processing plugin -->
<script src="${basePath}js/jquery/jquery.fileupload-process.js"></script>
<!-- The File Upload image preview & resize plugin -->
<script src="${basePath}js/jquery/jquery.fileupload-image.js"></script>
<!-- The File Upload audio preview plugin -->
<script src="${basePath}js/jquery/jquery.fileupload-audio.js"></script>
<!-- The File Upload video preview plugin -->
<script src="${basePath}js/jquery/jquery.fileupload-video.js"></script>
<!-- The File Upload validation plugin -->
<script src="${basePath}js/jquery/jquery.fileupload-validate.js"></script>
<style type="text/css">
.message{
	color:red;
}

</style>
</head>
<body>
<div class="container">
<div class="title">
	<label>文章编辑</label>
</div>
<div class="subcontent">
	<div id="message" class="message"></div>
	<form  method="post" id="submit_form">
	  <fieldset>
	  	<div class="form-group">
	      <label for="disabledTextInput">文章logo：</label>
	      <div>
	      	<div class="row fileupload-buttonbar">
			    <span class="btn btn-success fileinput-button">
			        <i class="glyphicon glyphicon-plus"></i>
			        <span>Add file</span>
			        <!-- The file input field used as target for the file upload widget -->
			        <input id="fileupload" type="file" name="files[]" multiple>
			    </span>
		    </div>
		    <br>
		    <!-- The global progress bar -->
		    <!-- <div id="progress" class="progress">
		        <div class="progress-bar progress-bar-success"></div>
		    </div> -->
		    <!-- The container for the uploaded files -->
		    <div id="files" class="files">
		    	<c:if test="${content.imageDir!=''&&content.imageDir!=null}" >
		    		<img src="${basePath}${content.imageDir}" height='100' width='100'>
		    		<br/><br/>
		    	</c:if>
		    </div>
	    </div>
	    </div>
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
	</div>
</div>
<script>
	var imageDir = "${content.imageDir}";
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
    	                	type:type,
    	                	imageDir:imageDir
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

    /*jslint unparam: true, regexp: true */
    /*global window, $ */
    $(function () {
        'use strict';
        // Change this to the location of your server-side upload handler:
        var url = '${basePath}upload/uploadTitleImag.do';
        var uploadButton = $('<button/>')
            .addClass('btn btn-primary')
            .prop('disabled', true)
            .text('Processing...')
            .on('click', function () {
                var $this = $(this),
                    data = $this.data();
                $this
                    .off('click')
                    .text('Abort')
                    .on('click', function () {
                        $this.remove();
                        data.abort();
                    });
                data.submit().always(function () {
                    $this.remove();
                });
            });
        $('#fileupload').fileupload({
            url: url,
            dataType: 'json',
            autoUpload: false,
            acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i,
            maxFileSize: 999000,
            // Enable image resizing, except for Android and Opera,
            // which actually support image resizing, but fail to
            // send Blob objects via XHR requests:
            disableImageResize: /Android(?!.*Chrome)|Opera/
                .test(window.navigator.userAgent),
            previewMaxWidth: 100,
            previewMaxHeight: 100,
            previewCrop: true
        }).on('fileuploadadd', function (e, data) {
        	$("#files").html("");
            data.context = $('<div/>').appendTo('#files');
            $.each(data.files, function (index, file) {
                var node = $('<p/>')
                        .append($('<span/>').text(file.name));
                if (!index) {
                    node
                        .append('<br>')
                        .append(uploadButton.clone(true).data(data));
                }
                node.appendTo(data.context);
            });
        }).on('fileuploadprocessalways', function (e, data) {
            var index = data.index,
                file = data.files[index],
                node = $(data.context.children()[index]);
            if (file.preview) {
                node
                    .prepend('<br>')
                    .prepend(file.preview);
            }
            if (file.error) {
                node
                    .append('<br>')
                    .append($('<span class="text-danger"/>').text(file.error));
            }
            if (index + 1 === data.files.length) {
                data.context.find('button')
                    .text('Upload')
                    .prop('disabled', !!data.files.error);
            }
        }).on('fileuploadprogressall', function (e, data) {
           /*  var progress = parseInt(data.loaded / data.total * 100, 10);
            $('#progress .progress-bar').css(
                'width',
                progress + '%'
            ); */
        }).on('fileuploaddone', function (e, data) {
            $.each(data.result, function (index, file) {
                if (file.url) {
                    var link = $('<a>')
                        .attr('target', '_blank')
                        .prop('href', '${basePath}'+file.url);
                    $(data.context.children()[index])
                        .wrap(link);
                    imageDir = file.url;
                } else if (file.error) {
                    var error = $('<span class="text-danger"/>').text(file.error);
                    $(data.context.children()[index])
                        .append('<br>')
                        .append(error);
                }
            });
        }).on('fileuploadfail', function (e, data) {
            $.each(data.files, function (index) {
                var error = $('<span class="text-danger"/>').text('File upload failed.');
                $(data.context.children()[index])
                    .append('<br>')
                    .append(error);
            });
        }).prop('disabled', !$.support.fileInput)
            .parent().addClass($.support.fileInput ? undefined : 'disabled');
    });
</script>

</body>
</html>