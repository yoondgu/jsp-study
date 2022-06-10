<%@page import="util.PasswordUtil"%>
<%@page import="org.apache.commons.codec.digest.DigestUtils"%>
<%@page import="vo.User"%>
<%@page import="dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	/*
		요청파라미터에서 아이디, 비밀번호를 조회해서 로그인처리를 수행합니다.
		아이디와 일치하는 사용자 정보가 존재하지 않는 경우 loginform.jsp?fail=invalid를 재요청하는 응답을 보낸다.
		비밀번호가 일치하지 않는 경우 loginform.jsp?fail=invalid를 재요청하는 응답을 보낸다.
		
		사용자인증이 완료되면 HttpSession에 "loginUser" 속성명으로 조회된 사용자 정보를 저장한다.
		
		home.jsp를 재요청하는 URL을 응답으로 보낸다.
	*/
	
	String id = request.getParameter("id");
	String password = request.getParameter("password");
	
	UserDao userDao = UserDao.getInstance();
	User user = userDao.getUserById(id);
	// 해당 아이디 사용자정보가 존재하지 않는 경우
	if (user == null) {
		response.sendRedirect("loginform.jsp?fail=invalid");
		return;
	}
	
	
	// 비밀번호 불일치 조회
	String secretPassword = PasswordUtil.generateSecretPassword(id, password);
	if (!user.getPassword().equals(secretPassword)) {
		response.sendRedirect("loginform.jsp?fail=invalid");
		return;
	}
	
	// 사용자인증 완료 시 session에 로그인 사용자 정보 저장, 응답
	session.setAttribute("loginUser", user);
	response.sendRedirect("home.jsp");
%>