package service;

import dao.ColumnDAO;
import model.Column;
import java.util.List;

public class ColumnService {
	private ColumnDAO columnDAO = new ColumnDAO();

    /**
     * [신규] 서블릿이 호출할 모든 칼럼 조회 서비스
     */
    public List<Column> getAllColumns() {
        return columnDAO.findAll();
    }

    /**
     * [신규] 서블릿이 호출할 칼럼 생성 서비스
     */
    public boolean createColumn(Column column) {
        // 기존 addColumn을 호출하도록 연결
        return this.addColumn(column);
    }
	
    // --- 기존 코드는 그대로 유지 ---
	public List<Column> getTopColumns(int limit) {
		return columnDAO.findTopColumns(limit);
	}

	public List<Column> getRecentColumns(int limit) {
		return columnDAO.findRecentColumns(limit);
	}

	public List<Column> getColumnsByUserId(int userId) {
		return columnDAO.findByUserId(userId);
	}

	public Column getColumnById(int columnId) {
		return columnDAO.findById(columnId);
	}

	public boolean addColumn(Column column) {
		return columnDAO.insert(column) > 0;
	}

	public boolean updateColumn(Column column) {
		return columnDAO.update(column) > 0;
	}

	public boolean deleteColumn(int columnId) {
		return columnDAO.delete(columnId) > 0;
	}

	public boolean incrementViews(int columnId) {
		return columnDAO.incrementViews(columnId) > 0;
	}

	public boolean likeColumn(int columnId) {
		return columnDAO.likeColumn(columnId) > 0;
	}
}