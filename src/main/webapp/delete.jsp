<%@page import="vo.Board"%>
<%@page import="dao.BoardDao"%>
<%@page import="vo.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	/*
		로그인 사용자정보를 조회해서 비로그인 상태면 게시글 상세정보를 재요청하는 url(detail.jsp?no=100)응답을 보낸다.
		
		요청파라미터에서 글번호를 조회해서 이 게시글을 상태를 삭제상태로 변경한다.
		로그인 사용자의 사용자번호와 게시글을 작성한 작성자의 사용자번호가 일치하는 경우에만 삭제상태로 변경한다. 
		
		삭제가 완료되면 게시글 목록을 재요청하는 url을 응답으로 보낸다.
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
	
	board.setDeleted("Y");
	boardDao.updateBoard(board);
	response.sendRedirect("list.jsp?page=1");
%>