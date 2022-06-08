<%@page import="com.google.gson.Gson"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="vo.User"%>
<%@page import="dao.UserDao"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%
	String userEmail = request.getParameter("email");

	UserDao userDao = UserDao.getInstance();
	User user = userDao.getUserByEmail(userEmail);
	
	Map<String, Boolean> result = new HashMap<>();
	
	if (user != null) {
		result.put("exist", true);
	} else {
		result.put("exist", false);
	}
	
	Gson gson = new Gson();
	String jsonText = gson.toJson(result);
	out.write(jsonText);
%>