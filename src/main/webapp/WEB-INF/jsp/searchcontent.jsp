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
<title><c:out value="${content.title}"/></title>
<link href="${basePath}css/bootstrap-3.3.6/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="/ai//css/algorithm.css" media="screen">
</head>
<body>
<div class="title"><c:out value="${content.title}" escapeXml="false"/></div>
<div class="subcontent">
	<div>
		<c:out value="${content.content}" escapeXml="false"/>
	</div>
</div>
</body>
</html>