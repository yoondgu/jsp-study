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
	<jsp:param name="name" value="login"/>
</jsp:include>
<div class="container mb-5">
	<div class="row">
		<div class="col">
			<h1 class="fs-4 border p-2">로그인 폼</h1>
		</div>
	</div>
	<div class="row">
		<div class="col-6">
		<%
			String fail = request.getParameter("fail");
		
			if ("invalid".equals(fail)) {
		%>
			<!--
				아이디 혹은 비밀번호가 일치하지 않는 경우 아래 내용이 출력된다.
			-->
			<div class="alert alert-danger">
				<strong>로그인 실패</strong> 아이디 혹은 비밀번호가 올바르지 않습니다.
			</div>
		<%
			} else if ("deny".equals(fail)) {
		%>
			<div class="alert alert-danger">
				<strong>접근 제한</strong> 로그인이 필요한 기능입니다.
			</div>
		<%
			}
		%>
			<p>아이디, 비밀번호를 입력하세요</p>
			<form class="border bg-light p-3" method="post" action="login.jsp">
				<div class="mb-3">
					<label class="form-label">아이디</label>
					<input type="text" class="form-control" name="id">
				</div>
				<div class="mb-3">
					<label class="form-label">비밀번호</label>
					<input type="password" class="form-control" name="password">
				</div>
				<div class="text-end">
					<a href="home.jsp" class="btn btn-secondary">취소</a>
					<button type="submit" class="btn btn-primary">로그인</button>
				</div>
			</form>
		</div>
	</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>