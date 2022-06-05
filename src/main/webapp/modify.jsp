<%@page import="vo.Board"%>
<%@page import="dao.BoardDao"%>
<%@page import="vo.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	/*
	로그인 사용자정보를 조회해서 비로그인 상태면 게시글 상세정보를 재요청하는 url(detail.jsp?no=100)응답을 보낸다.
	
	요청파라미터에서 글번호, 제목, 내용을 조회한다.
	글번호에 해당하는 게시글의 정보를 조회한다.
	요청파라미터에서 조회된 제목과 내용을 게시글 정보를 변경한 다음 테이블에 반영한다.
	로그인 사용자의 사용자번호와 게시글을 작성한 작성자의 사용자번호가 일치하는 경우에만 수정작업을 수행한다.
	
	삭제가 완료되면 게시글 상세화면을 재요청하는 url을 응답으로 보낸다.
	*/
	
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
	
	String title = request.getParameter("title");
	String content = request.getParameter("content");
	
	board.setTitle(title);
	board.setContent(content);
	
	boardDao.updateBoard(board);
	
	response.sendRedirect("list.jsp?page=1");
%>