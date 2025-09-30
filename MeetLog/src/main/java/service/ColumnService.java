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
	
	public List<Column> getRankedColumnsByRegion(String region) {
	    // [보완] 내용이 너무 길 경우 요약문을 만들어주는 로직 추가
	    List<Column> columns = columnDAO.findRankedByRegion(region);
	    for (Column column : columns) {
	        String content = column.getContent();
	        // HTML 태그 제거 및 100자로 요약
	        String plainText = content.replaceAll("<[^>]*>", "");
	        if (plainText.length() > 100) {
	            column.setContent(plainText.substring(0, 100) + "...");
	        } else {
	            column.setContent(plainText);
	        }
	    }
	    return columns;
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