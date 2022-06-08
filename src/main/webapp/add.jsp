<%@page import="util.MultipartRequest"%>
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
	MultipartRequest mr = new MultipartRequest(request, "C:\\eclipse\\workspace-web\\attached-file");
	String title = mr.getParameter("title");
	String content = mr.getParameter("content");
	String filename = mr.getFilename("upfile");
	
	Board board = new Board();
	board.setWriter(user);
	board.setTitle(title);
	board.setContent(content);
	board.setFilename(filename);
	
	BoardDao boardDao = BoardDao.getInstance();
	boardDao.insertBoard(board);
	
	response.sendRedirect("list.jsp?page=1");
%>