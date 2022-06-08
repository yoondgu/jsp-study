package download;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.sql.SQLException;

import org.apache.tomcat.jakartaee.commons.io.IOUtils;

import dao.BoardDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.StringUtil;
import vo.Board;

@WebServlet("/download")
public class FileDownloadServlet extends HttpServlet {
	private final String saveDirectory = "C:\\eclipse\\workspace-web\\attached-file"; // 파일 저장 경로

	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		try {
			int boardNo = StringUtil.stringToInt(request.getParameter("no"));
			
			BoardDao boardDao = BoardDao.getInstance();
			Board board = boardDao.getBoard(boardNo);
			if (board == null) {
				throw new RuntimeException("게시글 정보가 존재하지 않습니다.");
			}
			
			String filename = board.getFilename();
			System.out.println("첨부파일명: " + filename);
			if (filename == null) {
				throw new RuntimeException("파일 정보가 존재하지 않습니다.");
			}
			
			response.setContentType("application/octect-stream"); // 알수없는 바이너리타입의 데이터를 가져올 때 지정
			response.setHeader("Content-Disposition", "attachment; filename=" + URLEncoder.encode(filename, "utf-8")); 
			
			FileInputStream in = new FileInputStream(new File(saveDirectory, filename));
			OutputStream out = response.getOutputStream();
			
			IOUtils.copy(in, out);
			
		} catch (SQLException e) {
			throw new ServletException(e);
		}
		
	}
}
