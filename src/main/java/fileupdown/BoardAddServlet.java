package fileupdown;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;

import org.apache.tomcat.jakartaee.commons.io.IOUtils;

import dao.BoardDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import vo.Board;
import vo.User;

// @WebServlet은 웹애플리케이션임을 지정한다.
// @WebServlet("/add")의 "/add"는 이 웹 애플리케이션을 실행시키는 요청 URL이다.
@WebServlet("/add")
// @MultipartConfig는 multipart/form-data 요청을 처리하는 웹애플리케이션임을 지정한다.
@MultipartConfig
public class BoardAddServlet extends HttpServlet {

	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 로그인된 사용자 정보 조회
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute("loginUser");
		if (user == null) {
			throw new RuntimeException("게시글 등록은 로그인 후 사용가능한 서비스입니다.");
		}
		
		// 입력필드의 값 조회하기
		String title = request.getParameter("title");
		String content = request.getParameter("content");
		
		// 첨부파일처리하기
		// 첨부파일처리 기능을 구현된 Part 객체 획득하기
		Part part = request.getPart("upfile");
		String filename = null;
		// Part 객체의 getSize() 메소드를 실행해서 첨부파일의 업로드 여부를 체크한다.
		if (part.getSize() > 0) {
			// 업로드된 파일명 조회하기
			filename = part.getSubmittedFileName();
			// 업로드된 첨부파일을 읽어오는 InputStream 객체를 획득한다.
			InputStream in = part.getInputStream();
			
			// 업로드된 파일을 지정된 경로에 저장하기 위해서 File객체를 생성한다.
			File file = new File("C:\\eclipse\\workspace-web\\attached-file", filename);
			// 업로드된 파일을 지정된 경로에 기록하는 FileOutputStream 객체를 생성한다.
			FileOutputStream out = new FileOutputStream(file);
			
			// 업로드된 첨부파일을 읽어서 지정된 폴더에 지정된 이름으로 저장시킨다.
			IOUtils.copy(in, out);
		}
		
		Board board = new Board();
		board.setTitle(title);
		board.setContent(content);
		board.setFilename(filename);
		board.setWriter(user);
		
		BoardDao boardDao = BoardDao.getInstance();
		try {
			boardDao.insertBoard(board);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		response.sendRedirect("list.jsp?page=1");		
	}
}
