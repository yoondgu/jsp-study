<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>커뮤니티 게시판</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<jsp:include page="common/nav.jsp">
	<jsp:param name="menu" value="boxoffice" />
</jsp:include>
<div class="container">
	<div class="row">
		<div class="col">
			<h1 class="fs-5 border p-2">일자별 박스오피스 순위</h1>
		</div>
	</div>
	<div class="row">
		<div class="col">
			<form class="row row-cols-lg-auto g-3 align-items-center">
 					<div class="col-12">
   						<input type="date" class="form-control" id="date">
 					</div>
 					<div class="col-12">
   						<button type="button" class="btn btn-primary btn-sm" onclick="searchBoxOffice();">조회</button>
 					</div>
			</form>
		</div>
	</div>
	<div class="row">
		<div class="col">
			<table class="table" id="boxoffice-table">
				<colgroup>
					<col width="10%">
					<col width="*">
					<col width="10%">
					<col width="10%">
				</colgroup>
				<thead>
					<tr>
						<th>순위</th>
						<th>제목</th>
						<th>개봉일</th>
						<th>관객수</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript">
	let url= "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=f5eef3421c602c6cb7ea224104795888&targetDt=";
	
	function searchBoxOffice() {
		let dateEl = document.querySelector("input[id=date]");
		let date = dateEl.value.replaceAll("-","");
		
		let tbody = document.querySelector("#boxoffice-table tbody");
		
		let xhr = new XMLHttpRequest();
		xhr.onreadystatechange = function() {
			if (xhr.readyState === 4 && xhr.status === 200) {
				let jsonText = xhr.responseText;
				let result = JSON.parse(jsonText);
				let movies = result.boxOfficeResult.dailyBoxOfficeList;
				
				let rows = "";
				for (let i = 0; i < movies.length; i++) {
					let movie = movies[i];
					let ranking = movie.rank;
					let title = movie.movieNm;
					let openDate = movie.openDt;
					let audiAcc = movie.audiAcc;
					
					rows += "<tr>";
					rows += "<td>"+ ranking +"</td>";
					rows += "<td>"+ title +"</td>";
					rows += "<td>"+ openDate +"</td>";
					rows += "<td>"+ new Number(audiAcc).toLocaleString() +"명</td>";
					rows += "</tr>";
				}
				
				tbody.innerHTML = rows;
			}
		}
		
		xhr.open("GET", url + date);
		xhr.send();
	}
</script>
</body>
</html>