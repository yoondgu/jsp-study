package dao;

import java.sql.SQLException;

import helper.DaoHelper;
import vo.User;

public class UserDao {

	private static UserDao instance = new UserDao();
	private UserDao() {}
	public static UserDao getInstance() {
		return instance;
	}
	
	private DaoHelper daoHelper = DaoHelper.getInstance();
	
	public User getUserByNo(int userNo) throws SQLException {
		String sql = "select user_no, user_id, user_password, user_name, user_email, user_created_date "
				+ "from sample_board_users "
				+ "where user_no = ? ";

		// 아래 두번째 매개변수의 람다식은 rs를 가지고 원하는 객체로 만들어 반환하는 추상메소드를 구현하는 식이라고 보면 된다.
		return daoHelper.selectOne(sql, rs -> {
			User user = new User();
			user.setNo(rs.getInt("user_no"));
			user.setId(rs.getString("user_id"));
			user.setPassword(rs.getString("user_password"));
			user.setName(rs.getString("user_name"));
			user.setEmail(rs.getString("user_email"));
			user.setCreatedDate(rs.getDate("user_created_date"));
			return user;
		}, userNo);
	}
	
	public User getUserById(String id) throws SQLException {
		String sql = "select user_no, user_id, user_password, user_name, user_email, user_created_date "
				+ "from sample_board_users "
				+ "where user_id = ? ";
		
		return daoHelper.selectOne(sql, rs -> {
			User user = new User();
			user.setNo(rs.getInt("user_no"));
			user.setId(rs.getString("user_id"));
			user.setPassword(rs.getString("user_password"));
			user.setName(rs.getString("user_name"));
			user.setEmail(rs.getString("user_email"));
			user.setCreatedDate(rs.getDate("user_created_date"));
			return user;
		}, id);
	}
	
	public User getUserByEmail(String email) throws SQLException {
		String sql = "select user_no, user_id, user_password, user_name, user_email, user_created_date "
				+ "from sample_board_users "
				+ "where user_email = ? ";
		
		return daoHelper.selectOne(sql, rs -> {
			User user = new User();
			user.setNo(rs.getInt("user_no"));
			user.setId(rs.getString("user_id"));
			user.setPassword(rs.getString("user_password"));
			user.setName(rs.getString("user_name"));
			user.setEmail(rs.getString("user_email"));
			user.setCreatedDate(rs.getDate("user_created_date"));
			return user;
		}, email);
	}
	
	public void insertUser(User user) throws SQLException {
		String sql = "insert into sample_board_users "
				+ "(user_no, user_id, user_password, user_name, user_email) "
				+ "values "
				+ "(sample_boardusers_seq.nextval, ?, ?, ?, ?) ";

		daoHelper.insert(sql, user.getId(), user.getPassword(), user.getName(), user.getEmail());
	}
	
}
