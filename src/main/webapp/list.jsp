<%@page import="vo.Pagination"%>
<%@page import="dao.UserDao"%>
<%@page import="vo.Board"%>
<%@page import="dao.BoardDao"%>
<%@page import="java.util.List"%>
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
	<jsp:param name="name" value="board"/>
</jsp:include>
<div class="container">
	<div class="row">
		<div class="col">
			<h1 class="fs-4 border p-2">게시글 목록</h1>
		</div>
	</div>
	<div class="row">
		<div class="col">
				<%
			String fail = request.getParameter("fail");
		
			if ("invalid".equals(fail)) {
		%>
			<!--
				잘못된 URL로 접근했을 경우 아래 내용을 출력한다.
			-->
			<div class="alert alert-danger">
				<strong>접근 오류</strong> 유효하지 않은 요청입니다.
			</div>
		<%
			} else if ("deny".equals(fail)) {
		%>
			<div class="alert alert-danger">
				<strong>접근 제한</strong> 해당 기능에 대한 권한이 없습니다.
			</div>
		<%
			}
		%>
		<!--
			요청파라미터에서 요청한 페이지 번호를 조회하고, 페이지번호에 맞는 목록을 출력한다.
			페이징처리에 필요한 작업을 수행한다.
		-->
		<%
			User user = (User) session.getAttribute("loginUser");
			
			// 페이지 데이터 조회 설정
			BoardDao boardDao = BoardDao.getInstance();
			int currentPage = Integer.parseInt(request.getParameter("page"));
			int totalRowCount = boardDao.getTotalRowCount();
			
			// 페이징을 위한 값들을 계산하는 pagination 객체 생성
			// 한 화면에 표시할 데이터 개수의 기본값: 5, 화면에 표시할 페이지 번호 개수의 기본값: 5
			Pagination pagination = new Pagination(totalRowCount, currentPage);
			// init() 메소드는 총 페이지 번호 수, 데이터 조회 범위, 페이지 출력 범위 등을 계산해 멤버변수에 저장한다.
			// totalRowCount가 0일 경우 즉시 메소드를 종료시킨다. (값이 모두 0인 상태로 남음 -> 아무것도 조회되지 않는다.)
			pagination.init(); 
			
			int totalPages = pagination.getTotalPages();
			int beginIndex = pagination.getBeginIndex();
			int endIndex = pagination.getEndIndex();
			int beginPage = pagination.getBeginPage();
			int endPage = pagination.getEndPage();
			
			// 현재 페이지의 데이터 조회하기
			List<Board> boards = boardDao.getBoards(beginIndex, endIndex);

			%>
			<p>
				게시글 목록을 확인하세요
				<!-- 
					비로그인 상태에서는 아래 새 글쓰기 버튼을 비활성화한다.
					class 속성에 disabled를 추가하면 비활성화된다.
				--> 
				<a href="form.jsp" class="btn btn-primary btn-sm float-end <%=user==null ? "disabled" : "" %>" >새 글쓰기</a>
			<p>
			
			<table class="table">
				<colgroup>
					<col width="5%">
					<col width="%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
				</colgroup>
				<thead>
					<tr>
						<th>번호</th>
						<th>제목</th>
						<th>작성자</th>
						<th>조회수</th>
						<th>추천수</th>
						<th>등록일</th>
					</tr>
				</thead>
				<tbody class="table-group-divider">
				<%
					UserDao userDao = UserDao.getInstance();
					for (Board board : boards) {
						User writer = userDao.getUserByNo(board.getWriterNo()); // board의 멤버변수 writer 타입을 User로 해도된다.
				%>
					<tr>
						<td><%=board.getNo() %></td>
						<td><a href="view.jsp?no=<%=board.getNo() %>"><%=board.getTitle() %></a></td>
						<td><%=writer.getName() %></td>
						<td><%=board.getViewCount() %></td>
						<td><%=board.getLikeCount() %></td>
						<td><%=board.getCreatedDate() %></td>
					</tr>
				<%
					}
				%>
				</tbody>
			</table>
		</div>
	</div>
	<div class="row">
		<div class="col">
			<!--  
				요청한 페이지번호에 맞는 페이지번호를 출력한다.
				요청한 페이지번호와 일치하는 페이지번호는 하이라이트 시킨다.
				요청한 페이지가 1페이지인 경우 이전 버튼을 비활성화 시킨다.
				요청한 페이지가 맨 마지막 페이지인 경우 다음 버튼을 비활성화 시킨다. 
			-->
			<nav>
				<ul class="pagination justify-content-center">
					<li class="page-item">
						<a class="page-link <%=currentPage <= 1 ? "disabled" : "" %>" href="list.jsp?page=<%=currentPage -1 %>">이전</a>
					</li>
				<%
					for (int num = beginPage; num <= endPage; num++) {
				%>
					<li class="page-item">
						<a class="page-link <%=currentPage==num ? "active" : "" %>" href="list.jsp?page=<%=num %>"><%=num %></a>
					</li>
				<%
					}
				%>
					<li class="page-item">
						<a class="page-link <%=currentPage == totalPages ? "disabled" : "" %>" href="list.jsp?page=<%=currentPage +1 %>">다음</a>
					</li>
				</ul>
			</nav>
		</div>
	</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>