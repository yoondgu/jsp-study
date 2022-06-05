<%@page import="vo.BoardLikeUser"%>
<%@page import="java.util.List"%>
<%@page import="vo.User"%>
<%@page import="vo.BoardDetailDto"%>
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
<style>
	.btn.btn-sx {--bs-btn-padding-y: .175rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .75rem;}
</style>
</head>
<body>
<jsp:include page="common/nav.jsp">
	<jsp:param name="name" value="board"/>
</jsp:include>
<div class="container">
	<div class="row">
		<div class="col">
			<h1 class="fs-4 border p-2">게시글 보기</h1>
		</div>
	</div>
	<div class="row">
		<div class="col">
		<%
			// 추천 오류 발생 시
			String fail = request.getParameter("fail");
			if ("deny".equals(fail)) {
		%>
			<div class="alert alert-danger">
				<strong>접근 제한</strong> 해당 기능에 대한 권한이 없습니다.
			</div>
		<%				
			}
		%>
		<!--
			요청파라미터에서 게시글 번호를 조회하고, 게시글 번호에 맞는 글 정보를 조회해서 출력한다.
		-->
		<%
			// 로그인 정보 조회
			User user = (User) session.getAttribute("loginUser");
			
			// 요청한 게시글 정보 조회
			int boardNo = Integer.parseInt(request.getParameter("no"));
			BoardDao boardDao = BoardDao.getInstance();
			
			// 게시글 정보 조회
			BoardDetailDto board = boardDao.getBoardDetailByNo(boardNo);
		%>
			<p>게시글 정보를 확인하세요.<p>
			
			<table class="table table-bordered">
				<colgroup>
					<col width="10%">
					<col width="40%">
					<col width="10%">
					<col width="40%">
				</colgroup>
				<tbody>
					<tr>
						<th class="table-light text-center">제목</th>
						<td colspan="3"><%=board.getTitle() %></td>
					</tr>
					<tr>
						<th class="table-light text-center">조회수</th>
						<td><%=board.getViewCount() %></td>
						<td class="table-light text-center">추천수</td>
						<td><%=board.getLikeCount() %> 
							<!--  
								이 버튼을 클릭하면 이 글을 추천한 사용자 리스트를 표시하는 모달창이 표시됩니다.
							-->
							<button type="button" class="btn btn-outline-primary btn-sx" data-bs-toggle="modal" data-bs-target="#modal-like-users">
								상세보기
							</button>
						</td>
					</tr>
					<tr>
						<th class="table-light text-center">작성자</th>
						<td><%=board.getWriter() %></td>
						<td class="table-light text-center">등록일</td>
						<td><%=board.getCreatedDate() %></td>
					</tr>
					<tr>
						<th class="table-light text-center">내용</th>
						<td colspan="3"><%=board.getContent() %></td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	<div class="row">
		<div class="col">
			<!--  
				비로그인 상태일 때 아래 버튼은 전부 비활성화한다.
				수정/삭제 버튼은 작성자의 사용자번호와 로그인한 사용자의 사용자 번호가 동일할 때만 활성화한다.
				추천 버튼은 작성자의 사용자번호와 로그인한 사용자의 사용자 번호가 다를 때만 활성화한다.
				로그인한 사용자가 이 게시글에 대해서 좋아요를 등록한 경우 추천 버튼을 비활성화한다. 
			-->
		<%
			if (user == null) {
		%>
			<a href="modifyform.jsp?no=<%=boardNo %>" class="btn btn-secondary disabled">수정</a>
			<a href="delete.jsp?no=<%=boardNo %>" class="btn btn-secondary disabled">삭제</a>
			<a href="like.jsp?no=<%=boardNo %>" class="btn btn-secondary float-end disabled">추천</a>
		<%
			} else {
		%>
			<a href="modifyform.jsp?no=<%=boardNo %>" class="btn <%=user.getNo() != board.getWriterNo()? "btn-secondary disabled" : "btn-warning" %>">수정</a>
			<a href="delete.jsp?no=<%=boardNo %>" class="btn <%=user.getNo() != board.getWriterNo()? "btn-secondary disabled" : "btn-danger" %>">삭제</a>
			<a href="like.jsp?no=<%=boardNo %>" class="btn float-end <%=user.getNo() == board.getWriterNo() || boardDao.getBoardLikeUser(boardNo, user.getNo())!=null ? "btn-secondary disabled" : "btn-success" %>">추천</a>
		<%
			}
		%>
		</div>
	</div>
	<!--  
		이 게시글에 추천한 사용자를 표시하는 모달창
	-->
	<div class="modal fade" id="modal-like-users" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">이 글을 추천한 사용자</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
				<!--  
					이 게시글에 좋아요를 클릭한 사용자명을 아래에 표시합니다.
				-->
				<%
					List<String> likeUserNames = boardDao.getLikeUserNames(boardNo);
				
					if (likeUserNames.isEmpty()) {
				%>
					<span>이 게시글을 추천한 사용자가 없습니다.</span>
				<%
					} else {
					
						for (String name : likeUserNames) {
				%>
					<span class="badge text-bg-secondary p-2"><%=name %></span>
				<%
						}
					}
				%>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">확인</button>
				</div>
			</div>
		</div>
	</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>