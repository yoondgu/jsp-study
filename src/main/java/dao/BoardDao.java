package dao;

import java.sql.SQLException;
import java.util.List;

import helper.DaoHelper;
import vo.Board;
import vo.BoardLikeUser;
import vo.User;

public class BoardDao {

	private static BoardDao instance = new BoardDao();
	private BoardDao() {}
	public static BoardDao getInstance() {
		return instance;
	}
	
	private DaoHelper daoHelper = DaoHelper.getInstance();
	
	// 게시물 추천인 이름 조회하기
	public List<String> getLikeUserNames(int boardNo) throws SQLException {
		String sql = "select u.user_name "
				+ "from sample_board_like_users l, sample_board_users u "
				+ "where l.board_no = ? "
				+ "and l.user_no = u.user_no "
				+ "order by u.user_name";
		
		return daoHelper.selectList(sql, rs -> {
			return rs.getString("user_name");
		}, boardNo);
	}
	
	// 게시물 추천인 정보 조회하기
	public BoardLikeUser getBoardLikeUser(int boardNo, int userNo) throws SQLException {
		String sql = "select l.board_no, l.user_no "
				+ "from sample_board_like_users l "
				+ "where l.board_no = ? "
				+ "and l.user_no = ? ";
		
		return daoHelper.selectOne(sql, rs -> {
			BoardLikeUser likeUser = new BoardLikeUser();
			likeUser.setBoardNo(rs.getInt("board_no"));
			likeUser.setUserNo(rs.getInt("user_no"));
			return likeUser;
		}, boardNo, userNo);
	}
	
	// 전체 데이터 행 수 조회하기
	public int getTotalRowCount() throws SQLException {
		String sql = "select count(*) cnt "
				+ "from sample_boards "
				+ "where board_deleted = 'N' ";
		
		return daoHelper.selectOne(sql, rs -> {
			return rs.getInt("cnt");
		});
	}
	
	// 범위로 게시물 조회하기 (board_deleted는 'N')
	public List<Board> getBoards(int beginIndex, int endIndex) throws SQLException {
		String sql = "SELECT B.BOARD_NO, B.BOARD_TITLE, B.WRITER_NO, U.USER_NAME, B.BOARD_CONTENT, B.BOARD_VIEW_COUNT, B.BOARD_LIKE_COUNT, B.BOARD_CREATED_DATE "
				+ "FROM (SELECT ROW_NUMBER() OVER (ORDER BY BOARD_NO DESC) ROW_NUMBER, "
				+ "        BOARD_NO, BOARD_TITLE, WRITER_NO, BOARD_CONTENT, BOARD_VIEW_COUNT, BOARD_LIKE_COUNT, BOARD_CREATED_DATE "
				+ "        FROM SAMPLE_BOARDS "
				+ "        WHERE BOARD_DELETED = 'N') B, SAMPLE_BOARD_USERS U "
				+ "WHERE B.WRITER_NO = U.USER_NO "
				+ "AND ROW_NUMBER >= ? AND ROW_NUMBER <= ?";
		

		return daoHelper.selectList(sql, rs -> {
			Board board = new Board();
			board.setNo(rs.getInt("board_no"));
			board.setTitle(rs.getString("board_title"));
			
			User user = new User();
			user.setNo(rs.getInt("writer_no"));
			user.setName(rs.getString("user_name"));
			board.setWriter(user);
			
			board.setContent(rs.getString("board_content"));
			board.setViewCount(rs.getInt("board_view_count"));
			board.setLikeCount(rs.getInt("board_like_count"));
			board.setCreatedDate(rs.getDate("board_created_date"));
			board.setDeleted("N");
			return board;
		}, beginIndex, endIndex);
	}
	
	// 번호로 게시물 정보 조회하기
	public Board getBoard(int no) throws SQLException {
		String sql =  "SELECT B.BOARD_NO, B.BOARD_TITLE, B.WRITER_NO, U.USER_NAME, B.BOARD_CONTENT, B.BOARD_VIEW_COUNT, B.BOARD_LIKE_COUNT, B.BOARD_CREATED_DATE, B.BOARD_FILE_NAME "
				+ "FROM SAMPLE_BOARDS B, SAMPLE_BOARD_USERS U "
				+ "WHERE B.BOARD_NO = ? "
				+ "AND B.WRITER_NO = U.USER_NO ";
		

		return daoHelper.selectOne(sql, rs -> {
			Board board = new Board();
			board.setNo(rs.getInt("board_no"));
			board.setTitle(rs.getString("board_title"));
			
			User user = new User();
			user.setNo(rs.getInt("writer_no"));
			user.setName(rs.getString("user_name"));
			board.setWriter(user);
			
			board.setContent(rs.getString("board_content"));
			board.setViewCount(rs.getInt("board_view_count"));
			board.setLikeCount(rs.getInt("board_like_count"));
			board.setCreatedDate(rs.getDate("board_created_date"));
			board.setFilename(rs.getString("board_file_name"));
			board.setDeleted("N");
			return board;
		}, no);
	}
	
	// 게시물 등록하기
	public void insertBoard(Board board) throws SQLException {
		String sql = "insert into sample_boards "
				+ "(board_no, board_title, writer_no, board_content, board_file_name) "
				+ "values "
				+ "(sample_boards_seq.nextval, ?, ?, ?, ?) ";
		
		daoHelper.insert(sql, board.getTitle(), board.getWriter().getNo(), board.getContent(), board.getFilename());
	}

	
	// 게시물 수정하기 (삭제할 때는 deleted = 'Y')
	public void updateBoard(Board board) throws SQLException {
		String sql = "update sample_boards "
				+ "set "
				+ "		board_title = ?, "
				+ "		board_content = ?, "
				+ "		board_view_count = ?, "
				+ "		board_like_count = ?,"
				+ "		board_deleted = ?, "
				+ "		board_updated_date = sysdate "
				+ "where board_no = ? ";
		
		daoHelper.update(sql, board.getTitle(), board.getContent(), board.getViewCount(), board.getLikeCount(), board.getDeleted(), board.getNo());
	}
	
	// 추천인 저장하기
	public void insertBoardLikeUser(int boardNo, int userNo) throws SQLException {
		String sql = "insert into sample_board_like_users (board_no, user_no) "
				+ "values (?, ?)";
		
		daoHelper.insert(sql, boardNo, userNo);
	}
}
