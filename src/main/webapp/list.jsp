<%@page import="util.StringUtil"%>
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
		<!-- 페이지 번호 클릭, 행 개수 선택, 검색어 입력을 통해 요청객체로부터 전달받는 값들을 가져온다. -->
		<!--
			요청파라미터에서 요청한 페이지 번호를 조회하고, 페이지번호에 맞는 목록을 출력한다.
			페이징처리에 필요한 작업을 수행한다.
		-->
		<%
			// 요청 파라미터 값 획득
			int currentPage = StringUtil.stringToInt(request.getParameter("page"), 1);
			int rows = StringUtil.stringToInt(request.getParameter("rows"), 5);
			String keyword = StringUtil.nullToBlank(request.getParameter("keyword")); // 입력값이 없으면 null 대신 ""을 반환한다.
			
			// 페이지 데이터 조회 설정
			BoardDao boardDao = BoardDao.getInstance();
			// 	keyword의 값 blank여부에 따라 데이터 개수도 다르다. 
			int totalRowCount = 0;
			if (keyword.isBlank()) {
				totalRowCount = boardDao.getTotalRowCount();
			} else {
				totalRowCount = boardDao.getTotalRowCount(keyword);
			}
			
			// 페이징을 위한 값들을 계산하는 pagination 객체 생성
			// 한 화면에 표시할 데이터 개수: rows, 화면에 표시할 페이지 번호 개수의 기본값: 5
			Pagination pagination = new Pagination(rows, totalRowCount, currentPage);
			// init() 메소드는 총 페이지 번호 수, 데이터 조회 범위, 페이지 출력 범위 등을 계산해 멤버변수에 저장한다.
			// totalRowCount가 0일 경우 즉시 메소드를 종료시킨다. (값이 모두 0인 상태로 남음 -> 아무것도 조회되지 않는다.)
			pagination.init(); 
			
			int totalPages = pagination.getTotalPages();
			int beginIndex = pagination.getBeginIndex();
			int endIndex = pagination.getEndIndex();
			int beginPage = pagination.getBeginPage();
			int endPage = pagination.getEndPage();
			
			// 현재 페이지의 데이터 조회하기, 만약 keyword.isblank가 false이면 keyword로 검색해서 조회한다.
			List<Board> boards = null;
			if (keyword.isBlank()) {
				boards = boardDao.getBoards(beginIndex, endIndex);
			} else {
				boards = boardDao.getBoards(keyword, beginIndex, endIndex);
			}
			%>
			<p>
				게시글 목록을 확인하세요
			</p>
			<!-- changeRows()함수 실행으로 화면을 띄웠을 때 요청파라미터로 온 rows의 값이 유지되도록 한다.
				* selected 속성은 불리언값을 가지므로, selected="selected"처럼 쓰지 않는다. selected 속성명만 적으면 true로 읽힌다. -->
			<select class="form-control form-control-sm w-25 float-end" name="rows" onchange="changeRows();">
				<option value="5" <%=rows == 5 ? "selected" : "" %>>5개씩 보기</option>
				<option value="10" <%=rows == 10 ? "selected" : "" %>>10개씩 보기</option>
				<option value="15" <%=rows == 15 ? "selected" : "" %>>15개씩 보기</option>
			</select>
			<table class="table">
				<colgroup>
					<col width="5%">
					<col width="10%">
					<col width="%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
				</colgroup>
				<thead>
					<tr>
						<th>번호</th>
						<th>카테고리</th>
						<th>제목</th>
						<th>작성자</th>
						<th>조회수</th>
						<th>추천수</th>
						<th>등록일</th>
					</tr>
				</thead>
				<tbody class="table-group-divider">
				<%
					for (Board board : boards) {
				%>
					<tr>
						<td><%=board.getNo() %></td>
						<td><%=board.getCategory().getName() %></td>
						<td><a href="detail.jsp?no=<%=board.getNo() %>&page=<%=currentPage %>"><%=board.getTitle() %></a></td>
						<td><%=board.getWriter().getName() %></td>
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
		<div class="col-4">
				<!-- 
					비로그인 상태에서는 아래 새 글쓰기 버튼을 비활성화한다.
					class 속성에 disabled를 추가하면 비활성화된다.
				--> 
			<%
				User user = (User) session.getAttribute("loginUser");
			%>
				<a href="form.jsp" class="btn btn-primary btn-sm <%=user==null ? "disabled" : "" %>" >새 글쓰기</a>		
		</div>
		<div class="col-4">
			<!--  
				요청한 페이지번호에 맞는 페이지번호를 출력한다.
				요청한 페이지번호와 일치하는 페이지번호는 하이라이트 시킨다.
				요청한 페이지가 1페이지인 경우 이전 버튼을 비활성화 시킨다.
				요청한 페이지가 맨 마지막 페이지인 경우 다음 버튼을 비활성화 시킨다. 
			-->
			<nav>
				<ul class="pagination justify-content-center">
					<li class="page-item">
						<a class="page-link <%=currentPage <= 1 ? "disabled" : "" %>"href="javascript:clickPageNo(<%=currentPage - 1 %>)">이전</a>
					</li>
				<%
					for (int num = beginPage; num <= endPage; num++) {
				%>
					<li class="page-item">
						<a class="page-link <%=currentPage==num ? "active" : "" %>" href="javascript:clickPageNo(<%=num %>)"><%=num %></a>
					</li>
				<%
					}
				%>
					<li class="page-item">
						<a class="page-link <%=currentPage == totalPages ? "disabled" : "" %>"href="javascript:clickPageNo(<%=currentPage + 1 %>)">다음</a>
					</li>
				</ul>
			</nav>
		</div>
		<div class="col-4">
			<form id="search-form" class="row g-3" method="get" action="list.jsp">
				<input type="hidden" name="page" />
				<input type="hidden" name="rows" />
				<div class="col-9">
					<!-- 이전에 입력했던 값을 value에 담아둬서 다음 요청에도 유지되게 한다. -->
					<input class="form-control" type="text" name="keyword" value="<%=keyword %>" placeholder="검색어를 입력하세요."/>
				</div>
				<div class="col-3">
					<button type="button" class="btn btn-outline-primary" onclick="searchKeyword();">검색</button>
				</div>
			</form>
		</div>
	</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript">

	// search-form 입력폼에서 버튼을 누르면 실행된다.
	// page, rows 값도 전달해주어야 하기 때문에 해당 정보들이 hidden 상태인 input태그의 value값으로 설정되어있다.
	// 그 태그의 page, rows의 값을 설정해준 뒤 submit 메소드로 입력폼을 전송한다.
	function searchKeyword() {
		document.querySelector("#search-form input[name=page]").value = 1; // 검색어 입력 시 1번 페이지부터 보여준다.
		document.querySelector("#search-form input[name=rows]").value = document.querySelector("select[name=rows]").value; // 현재 선택된 조회 행 개수로 설정한다.
		// 값들을 모두 설정했으면 입력폼태그의 submit 메소드를 실행해서 값들을 서버로 요청한다.
		// 요청 URL: localhost/board/list.jsp?page=1&rows=(획득한값)&keyword=(폼입력값)
		let form = document.querySelector("#search-form");
		form.submit();
	}
	
	// select 콤보박스에서 값이 변경되면 실행된다.
	// searchKeyword와 마찬가지로 search-form 입력폼을 통해 서버로 요청한다.
	// 폼 태그의 page, keyword 값들도 설정한 뒤 함께 전달해준다.
	function changeRows() {
		document.querySelector("#search-form input[name=page]").value = 1; // 행 개수 변경 시 1번 페이지부터 보여준다.
		document.querySelector("#search-form input[name=rows]").value = document.querySelector("select[name=rows]").value; // 현재 선택된 조회 행 개수로 설정한다.
		// keyword 값도 함께 전달된다. jsp에서 값이 null이면 blank가 되도록 설정되어 있다. 
		
		// 값들을 모두 설정했으면 입력폼태그의 submit 메소드를 실행해서 값들을 서버로 요청한다.
		// 요청 URL: localhost/board/list.jsp?page=1&rows=(획득한값)&keyword=(폼입력값)
		let form = document.querySelector("#search-form");
		form.submit();
	}
	
	// 페이지번호 a태그를 클릭하면 실행된다.
	// search-form 입력폼을 통해 서버로 요청한다.
	// page 값은 함수를 통해 전달받고, 폼 태그의 rows, keyword 값들도 설정한 뒤 함께 전달해준다.
	// a태그에서 href="javascript:스크립트에서 정의된 함수명" 으로 작성하면 스크립트의 함수를 실행시킨다.
	function clickPageNo(pageNo) {
		document.querySelector("#search-form input[name=page]").value = pageNo;
		document.querySelector("#search-form input[name=rows]").value = document.querySelector("select[name=rows]").value; // 현재 선택된 조회 행 개수로 설정한다.
		// keyword 값도 함께 전달된다. jsp에서 값이 null이면 blank가 되도록 설정되어 있다. 
		// 값들을 모두 설정했으면 입력폼태그의 submit 메소드를 실행해서 값들을 서버로 요청한다.
		// 요청 URL: localhost/board/list.jsp?page=1&rows=(획득한값)&keyword=(폼입력값)
		let form = document.querySelector("#search-form");
		form.submit();
	}
	
</script>
</body>
</html>