<%@page import="vo.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>커뮤니티 게시판</title>
<link href="favicon.ico" rel="icon" type="image/x-icon" />
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<jsp:include page="common/nav.jsp">
	<jsp:param name="name" value="home"/>
</jsp:include>
<div class="container">
	<div class="p-5 mb-4 bg-light rounded-3">
		<div class="container-fluid py-3">
			<h1 class="display-5 fw-bold">커뮤니티 게시판</h1>
			<p class="fs-4">회원가입, 로그인, 게시글 조회/등록/수정/삭제, 리뷰 조회/등록/수정/삭제 기능을 제공하는 <br/>웹 애플리케이션 입니다.</p>
			
		<%
			User user = (User) session.getAttribute("loginUser");
			if (user == null) {
		%>
			<!-- 
				로그인이 완료되면 아래 링크는 출력하지 않는다. 
			-->			
			<a href="loginform.jsp" class="btn btn-primary btn-lg">로그인</a>
			<a href="registerform.jsp" class="btn btn-outline-primary btn-lg">회원가입</a>
		<%
			}
		%>
		</div>
	</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>