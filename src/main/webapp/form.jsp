<%@page import="vo.Category"%>
<%@page import="java.util.List"%>
<%@page import="dao.CategoryDao"%>
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
<%
	// 로그인 유효성 검사
	User user = (User) session.getAttribute("loginUser");
	
	if (user == null) {
		response.sendRedirect("loginform.jsp?fail=deny");
		return;
	}
%>
<div class="container">
	<div class="row">
		<div class="col">
			<h1 class="fs-4 border p-2">게시글 등록 폼</h1>
		</div>
	</div>
	<div class="row">
	<%
		CategoryDao categoryDao = CategoryDao.getInstance();
		List<Category> topCategoryList = categoryDao.getTopCategoryList();
	%>
		<div class="col">
			<p>제목과 내용을 입력하세요. <p>
			<form class="row g-3 border bg-light mx-1 " method="post" action="add.jsp" enctype="multipart/form-data" onsubmit="return submitBoardForm()">
				<div class="col-6">
					<label class="form-label">대분류</label>
					<select class="form-select" id="top-category-combobox" onchange="refreshSubCategories();">
						<option value="" selected="selected" disabled="disabled">선택하세요</option>
					<%
						for (Category category : topCategoryList) {
					%>
						<option value="<%=category.getNo() %>"><%=category.getName() %></option>
					<%
						}
					%>
					</select>
				</div>
				<div class="col-6">
					<label class="form-label">소분류</label>
					<select class="form-select" name="categoryNo">
						<option value="" selected="selected" disabled="disabled">선택하세요</option>
					</select>
				</div>
				<div class="mb-3">
					<label class="form-label">제목</label>
					<input type="text" class="form-control" name="title" />
				</div>
				<div class="mb-3">
					<label class="form-label">내용</label>
					<textarea rows="10" class="form-control" name="content"></textarea>
				</div>
				<div class="mb-3">
					<label class="form-label">첨부파일</label>
					<input type="file" class="form-control" name="upfile" />
				</div>
				<div class="text-end">
					<a href="list.jsp?page=1" class="btn btn-secondary">취소</a>
					<button type="submit" class="btn btn-primary">등록</button>
				</div>
			</form>
		</div>
	</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript">
	function refreshSubCategories() {
		let groupNo = document.getElementById("top-category-combobox").value;
		let xhr = new XMLHttpRequest();
		
		xhr.onreadystatechange = function() {
			if (xhr.readyState === 4 && xhr.status === 200) {
				// 응답에서 받아온 소분류 카테고리를 뿌린다.
				let jsonText = xhr.responseText;
				let categories = JSON.parse(jsonText);
				
				let combobox = document.querySelector("select[name=categoryNo]"); // name=value형식으로 값을 보내기 때문에 소분류 option태그에는 id대신 name을 사용했다.
				let options = "";
				for (let category of categories) {
					options += '<option value="' + category.no + '">' + category.name + '</option>'
				}
				combobox.innerHTML = options;
			}
		}
		
		xhr.open("GET", "categories.jsp?groupNo=" + groupNo); // 요청을 보내 소분류 카테고리를 받아온다.
		xhr.send();
	}

	function submitBoardForm() {
		let titleField = document.querySelector("input[name=title]");
		if (titleField.value === '') {
			alert("제목은 필수입력값입니다.");
			titleField.focus();
			return false;
		}
		let contentField = document.querySelector("textarea[name=content]");
		if (contentField.value === '') {
			alert("내용은 필수입력값입니다.");
			contentField.focus();
			return false;
		}
		return true;
	}
</script>
</body>
</html>