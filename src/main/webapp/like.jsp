<%@page import="vo.Board"%>
<%@page import="dao.BoardDao"%>
<%@page import="vo.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
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
	
	if (user.getNo() == board.getWriterNo() || boardDao.getBoardLikeUser(boardNo, user.getNo())!=null) {
		response.sendRedirect("detail.jsp?no="+boardNo+"&fail=deny");
		return;
	}
	
	// 추천인 정보 저장
	boardDao.insertBoardLikeUser(boardNo, user.getNo());
	
	// board 추천수 변경시키기
	board.setLikeCount(board.getLikeCount() + 1);
	boardDao.updateBoard(board);
	
	response.sendRedirect("detail.jsp?no="+boardNo);
%>