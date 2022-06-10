<%@page import="com.google.gson.Gson"%>
<%@page import="vo.Category"%>
<%@page import="java.util.List"%>
<%@page import="dao.CategoryDao"%>
<%@page import="util.StringUtil"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%
	int groupNo = StringUtil.stringToInt(request.getParameter("groupNo"));
	
	CategoryDao categoryDao = CategoryDao.getInstance();
	List<Category> subCategoryList = categoryDao.getSubCategoryListByGroupNo(groupNo);
	
	Gson gson = new Gson();
	String jsonText = gson.toJson(subCategoryList);
	
	out.write(jsonText);
%>