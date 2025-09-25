package service;

import dao.ColumnDAO;
import model.Column;
import java.util.List;
import java.util.Map; // [추가]
import java.util.HashMap; // [추가]

public class ColumnService {
	private ColumnDAO columnDAO = new ColumnDAO();

    public List<Column> getAllColumns() {
        return columnDAO.findAll();
    }

    public boolean createColumn(Column column) {
        return this.addColumn(column);
    }
	
	public List<Column> getTopColumns(int limit) {
		return columnDAO.findTopColumns(limit);
	}

    // --- [수정된 메서드] ---
    // MypageServlet이 (userId, limit) 2개를 보내므로, 파라미터를 2개 받도록 수정
	public List<Column> getRecentColumns(int userId, int limit) {
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("limit", limit);
        // 새로 추가한 DAO 메서드 호출
		return columnDAO.findRecentByUserId(params);
	}
    // --- [수정 끝] ---

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

	public List<Column> searchColumns(Map<String, Object> searchParams) {
		return columnDAO.searchColumns(searchParams);
	}
}