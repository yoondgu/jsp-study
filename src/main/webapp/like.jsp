<%@page import="util.StringUtil"%>
<%@page import="vo.Board"%>
<%@page import="dao.BoardDao"%>
<%@page import="vo.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" errorPage="error/500.jsp"%>
<%
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
	
	if (user.getNo() == board.getWriter().getNo() || boardDao.getBoardLikeUser(boardNo, user.getNo())!=null) {
		throw new RuntimeException("게시글의 작성자 또는 이미 추천한 사용자입니다.");
	}
	
	// 추천인 정보 저장
	boardDao.insertBoardLikeUser(boardNo, user.getNo());
	
	// board 추천수 변경시키기
	board.setLikeCount(board.getLikeCount() + 1);
	boardDao.updateBoard(board);
	
	response.sendRedirect("detail.jsp?no="+boardNo+"&page="+currentPage);
%>