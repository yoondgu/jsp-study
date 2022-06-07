<%@page import="util.StringUtil"%>
<%@page import="vo.Board"%>
<%@page import="dao.BoardDao"%>
<%@page import="vo.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" errorPage="error/500.jsp"%>
<%
	
	// 로그인 유효성 검사
	User user = (User) session.getAttribute("loginUser");
	int boardNo = Integer.parseInt(request.getParameter("no"));
	int currentPage = StringUtil.stringToInt(request.getParameter("page"), 1);
	
	if (user == null) {
		response.sendRedirect("loginform.jsp?fail=deny");
		return;
	}
	
	BoardDao boardDao = BoardDao.getInstance();
	Board board = boardDao.getBoard(boardNo);

	if (board == null) {
		throw new RuntimeException("게시글이 존재하지 않습니다.");
	}
	
	if (board.getWriter().getNo() != user.getNo()) {
		throw new RuntimeException("다른 사람의 게시글을 수정할 수 없습니다.");
	}
	
	String title = request.getParameter("title");
	String content = request.getParameter("content");
	
	board.setTitle(title);
	board.setContent(content);
	
	boardDao.updateBoard(board);
	
	response.sendRedirect("detail.jsp?no=" + boardNo + "&page=" + currentPage);
%>