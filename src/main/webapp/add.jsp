<%@page import="dao.BoardDao"%>
<%@page import="vo.Board"%>
<%@page import="vo.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 로그인 여부 확인
	User user = (User) session.getAttribute("loginUser");
	if (user == null) {
		response.sendRedirect("loginform.jsp?fail=deny");
		return;
	}
	
	// 게시글 입력정보 조회
	String title = request.getParameter("title");
	String content = request.getParameter("content");
	
	Board board = new Board();
	board.setWriterNo(user.getNo());
	board.setTitle(title);
	board.setContent(content);
	
	BoardDao boardDao = BoardDao.getInstance();
	boardDao.insertBoard(board);
	
	response.sendRedirect("list.jsp?page=1");
%>