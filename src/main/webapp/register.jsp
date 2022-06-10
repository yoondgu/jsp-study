<%@page import="util.PasswordUtil"%>
<%@page import="org.apache.commons.codec.digest.DigestUtils"%>
<%@page import="vo.User"%>
<%@page import="dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	/*
		요청파라미터에서 아이디, 비밀번호, 이름, 이메일을 조회한다.
		아이디로 사용자정보를 조회했을 때 사용자정보가 존재하면 registerform.jsp?fail=id&id=hong를 재요청하는 응답을 보낸다.
		이메일로 사용자정보를 조회했을 때 사용자정보가 존재하면 registerform.jsp?fail=email&email=hong@gmail.com를 재요청하는 응답을 보낸다.
		
		사용자정보를 저장한다.
		
		회원가입이 완료되면, complete.jsp를 재요청하는 응답을 보낸다.
	*/
	
	// UserDao 객체 획득
	UserDao userDao = UserDao.getInstance();

	// 아이디 중복 검사
	String id = request.getParameter("id");
	if (userDao.getUserById(id) != null) {
		response.sendRedirect("registerform.jsp?fail=id&id=" + id);
		return;
	}
	
	// 이메일 중복 검사
	String email = request.getParameter("email");
	if (userDao.getUserByEmail(email) != null) {
		response.sendRedirect("registerform.jsp?fail=email&email=" + email);
		return;
	}
	
	// 요청파라미터에서 나머지 회원가입 입력정보 조회하기
	String secretPassword = PasswordUtil.generateSecretPassword(id, request.getParameter("password"));
	String name = request.getParameter("name");

	// 중복 검사 완료 시 사용자 정보 저장, 회원가입 완료
	User user = new User();
	user.setId(id);
	user.setPassword(secretPassword);
	user.setName(name);
	user.setEmail(email);
	
	userDao.insertUser(user);
	
	response.sendRedirect("complete.jsp");
%>