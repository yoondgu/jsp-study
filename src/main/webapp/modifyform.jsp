<%@page import="vo.Board"%>
<%@page import="vo.User"%>
<%@page import="dao.BoardDao"%>
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
	<jsp:param name="name" value="board"/>
</jsp:include>
<div class="container">
	<div class="row">
		<div class="col">
			<h1 class="fs-4 border p-2">게시글 등록 폼</h1>
		</div>
	</div>
	<div class="row">
		<div class="col">
		<%
			// 로그인 유효성 검사
			User user = (User) session.getAttribute("loginUser");
			int boardNo = Integer.parseInt(request.getParameter("no"));
			
			if (user == null) {
				response.sendRedirect("loginform.jsp?fail=deny");
				return;
			}
			
			BoardDao boardDao = BoardDao.getInstance();
			Board board = boardDao.getBoard(boardNo);
	
			if (board == null) {
				response.sendRedirect("list.jsp?page=1&fail=invalid");
				return;
			}
			
			if (board.getWriterNo() != user.getNo()) {
				response.sendRedirect("list.jsp?page=1&fail=deny");
				return;
			}
			
		%>
			<p>제목과 내용을 입력하세요. <p>
			<form class="border bg-light p-3" method="post" action="modify.jsp">
				<input type="hidden" name="no" value="<%=boardNo %>" />
				<div class="mb-3">
					<label class="form-label">제목</label>
					<input type="text" class="form-control" name="title" value="<%=board.getTitle() %>"/>
				</div>
				<div class="mb-3">
					<label class="form-label">내용</label>
					<textarea rows="10" class="form-control" name="content"><%=board.getContent() %></textarea>
				</div>
				<div class="text-end">
					<a href="detail.jsp?no=<%=boardNo %>" class="btn btn-secondary">취소</a>
					<button type="submit" class="btn btn-primary">수정</button>
				</div>
			</form>
		</div>
	</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>