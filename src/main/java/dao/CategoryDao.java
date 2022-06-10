package dao;

import java.sql.SQLException;
import java.util.List;

import helper.DaoHelper;
import vo.Category;

public class CategoryDao {

	private static CategoryDao instance = new CategoryDao();
	private CategoryDao() {}
	public static CategoryDao getInstance() {
		return instance;
	}
	
	DaoHelper daoHelper = DaoHelper.getInstance();
	
	public List<Category> getTopCategoryList() throws SQLException {
		String sql = "select category_no, category_name, category_group_no "
					+ "from sample_board_categories "
					+ "where category_group_no is null "
					+ "order by category_no ";
		
		return daoHelper.selectList(sql, rs -> {
			Category category = new Category();
			category.setNo(rs.getInt("category_no"));
			category.setName(rs.getString("category_name"));
			category.setGroupNo(rs.getInt("category_group_no"));
			return category;
		});
	}
	
	public List<Category> getSubCategoryListByGroupNo(int groupNo) throws SQLException {
		String sql = "select category_no, category_name, category_group_no "
				+ "from sample_board_categories "
				+ "where category_group_no = ? "
				+ "order by category_no ";
		
		return daoHelper.selectList(sql, rs -> {
			Category category = new Category();
			category.setNo(rs.getInt("category_no"));
			category.setName(rs.getString("category_name"));
			category.setGroupNo(rs.getInt("category_group_no"));
			return category;
		}, groupNo);
	}
	
}
