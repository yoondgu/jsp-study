<%@page import="vo.User"%>
<%@page import="vo.Board"%>
<%@page import="dao.BoardDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	
	int boardNo = Integer.parseInt(request.getParameter("no"));
	BoardDao boardDao = BoardDao.getInstance();
	
	Board board = boardDao.getBoard(boardNo);

	if (board == null) {
		response.sendRedirect("list.jsp?fail=invalid");
		return;
	}
	
	// 작성자와 사용자가 같을 경우 조회수를 올리지 않는다.
	User user = (User) session.getAttribute("loginUser");
	if (user != null && board.getWriterNo() == user.getNo()) {
		response.sendRedirect("detail.jsp?no=" + boardNo);
		return;
	}
	
	board.setViewCount(board.getViewCount() + 1);
	boardDao.updateBoard(board);
	
	response.sendRedirect("detail.jsp?no=" + boardNo);
%>