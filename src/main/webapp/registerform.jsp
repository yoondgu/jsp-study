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
	<jsp:param name="name" value="register"/>
</jsp:include>
<div class="container mb-5">
	<div class="row">
		<div class="col">
			<h1 class="fs-4 border p-2">회원가입 폼</h1>
		</div>
	</div>
	<div class="row">
		<div class="col">
		<%
			String fail = request.getParameter("fail");
			if ("id".equals(fail)) {
				String id = request.getParameter("id");
		%>
			<!--
				동일한 아이디로 가입된 사용자가 있는 경우 아래 내용을 출력한다.
			-->
			<div class="alert alert-danger">
				<strong>회원가입 실패</strong> [<%=id %>]은 이미 사용중인 아이디 입니다.
			</div>
		<%
			} else if ("email".equals(fail)) {
				String email = request.getParameter("email");
		%>
			<!--
				동일한 이메일로 가입된 사용자가 있는 경우 아래 내용을 출력한다.
			-->
			<div class="alert alert-danger">
				<strong>회원가입 실패</strong> [<%=email %>]은 이미 사용중인 이메일입니다.
			</div>
		<%
			}
		%>
			<p>아이디, 비밀번호, 이름, 이메일을 입력하세요</p>
			<form class="border bg-light p-3" method="post" action="register.jsp" onsubmit="return submitRegisterForm();">
				<div class="row g-3">
					<div class="col-6">
						<label class="form-label">아이디</label>
						<input type="text" class="form-control" name="id" onkeyup="idCheck();">
						<div id="id-helper" class="form-text"></div>
					</div>
					<div class="col-6">
						<label class="form-label">비밀번호</label>
						<input type="password" class="form-control" name="password">
					</div>
					<div class="col-6">
						<label class="form-label">이름</label>
						<input type="text" class="form-control" name="name">
					</div>
					<div class="col-6">
						<label class="form-label">이메일</label>
						<input type="text" class="form-control" name="email" onkeyup="emailCheck();">
						<div id="email-helper" class="form-text"></div>
					</div>
					<div class="col-12 text-end">
						<a href="home.jsp" class="btn btn-secondary">취소</a>
						<button type="submit" class="btn btn-primary">회원가입</button>
					</div>
				</div>
			</form>
		</div>
	</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript">
	let isIdChecked = false;
	let isEmailChecked = false;
	
	function idCheck() {
		let idValue = document.querySelector("input[name=id]").value;
		let idHelperEl = document.getElementById("id-helper");
		
		let classList = idHelperEl.classList;
		classList.remove("text-danger","text-success");
		
		if (idValue === "") {
			classList.add("text-danger");
			idHelperEl.textContent = "아이디는 필수 입력값입니다.";
			isIdChecked = false;
			return;
		}
		
		if (idValue.length < 3) {
			classList.add("text-danger");
			idHelperEl.textContent = "아이디는 3글자 이상 20글자 이하여야 합니다.";
			isIdChecked = false;
			return;
		}
		
		if (idValue.length > 20) {
			classList.add("text-danger");
			idHelperEl.textContent = "아이디는 3글자 이상 20글자 이하여야 합니다.";
			isIdChecked = false;
			return;
		}
		
		// ajax로 아이디 중복체크하기
		let xhr = new XMLHttpRequest();
		
		xhr.onreadystatechange = function() {
			if (xhr.readyState === 4 && xhr.status === 200) {
				let jsonText = xhr.responseText;
				let result = JSON.parse(jsonText);
				console.log(result.exist);
				if (result.exist) {
					classList.add("text-danger");
					idHelperEl.textContent = "사용할 수 없는 아이디입니다.";
					isIdChecked = false;
					return;
				} else {
					classList.add("text-success");
					idHelperEl.textContent = "사용가능한 아이디입니다.";
					isIdChecked = true;
				}
			}
		}
		
		xhr.open("GET", "idcheck.jsp?id=" + idValue);
		xhr.send();
	}
	
	function emailCheck() {
		let emailValue = document.querySelector("input[name=email]").value;
		let emailHelperEl = document.getElementById("email-helper");
		
		let classList = emailHelperEl.classList;
		classList.remove("text-danger","text-success");
		
		if (emailValue === "") {
			classList.add("text-danger");
			emailHelperEl.textContent = "이메일은 필수 입력값입니다.";
			isEmailChecked = false;
			return;
		}
		
		// 이메일 규정 체크
		
		// ajax로 이메일 중복체크하기
		let xhr = new XMLHttpRequest();
		
		xhr.onreadystatechange = function() {
			if (xhr.readyState === 4 && xhr.status === 200) {
				let jsonText = xhr.responseText;
				let result = JSON.parse(jsonText);
				console.log(result.exist);
				if (result.exist) {
					classList.add("text-danger");
					emailHelperEl.textContent = "사용할 수 없는 이메일입니다.";
					isEmailChecked = false;
					return;
				} else {
					classList.add("text-success");
					emailHelperEl.textContent = "사용가능한 이메일입니다.";
					isEmailChecked = true;
				}
			}
		}
		
		xhr.open("GET", "emailcheck.jsp?email=" + emailValue);
		xhr.send();		
	}
	
	function submitRegisterForm() {
		
		let idField = document.querySelector("input[name=id]");
		if (idField.value === '') {
			alert("아이디는 필수입력값입니다.");
			idField.focus();
			return false; // 폼입력값이 제출되지 않는다.
		}
		
		if (!isIdChecked) {
			alert("유효한 아이디가 아닙니다.");
			idField.focus();
			return false;
		}
		
		let passwordField = document.querySelector("input[name=password]");
		if (passwordField.value === '') {
			alert("비밀번호는 필수입력값입니다.");
			passwordField.focus();
			return false;
		}
		
		
		let nameField = document.querySelector("input[name=name]");
		if (nameField.value === '') {
			alert("이름은 필수입력값입니다.");
			nameField.focus();
			return false;
		}
		
		let emailField = document.querySelector("input[name=email]");
		if (emailField.value === '') {
			alert("이메일은 필수입력값입니다.");
			emailField.focus();
			return false;
		}
		
		if (!isEmailChecked) {
			alert("유효한 이메일이 아닙니다.");
			emailField.focus();
			return false;
		}
		return true;
	}
</script>
</body>
</html>