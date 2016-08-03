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
<title>
<sitemesh:write property='title' />
</title>
<sitemesh:write property='head' />
<link rel="stylesheet" href="${basePath}css/ai.css" media="screen">
<link rel="stylesheet" href="${basePath}js/dojo/dijit/themes/claro/claro.css" media="screen">
<link href="${basePath}css/bootstrap-3.3.6/css/bootstrap.min.css" rel="stylesheet">
<script src="${basePath}css/bootstrap-3.3.6/js/bootstrap.min.js"></script>
<script type="text/javascript">
var dojoConfig = {
	    async: true,
	    parseOnLoad:true,
	    baseUrl: '${basePath}js/dojo',
	    packages: [
	        'dojo',
	        'dijit',
	        'dojox'
	    ]
	};
</script>
<script src="${basePath}js/dojo/dojo/dojo.js"></script>
<script src="${basePath}js/util.js"></script>
<script type="text/javascript">
	require(["dojo/parser", "dijit/layout/BorderContainer", "dijit/layout/TabContainer",
	         "dijit/layout/ContentPane"]);
</script>
</head>
<body  class="claro">
	<div class="headbar">
	</div>	
	<div class="content">
		 <sitemesh:write property='body' />
	</div>
	<div class="footer">
		<div class="navis">
			
		</div>
	</div>
</body>
</html>