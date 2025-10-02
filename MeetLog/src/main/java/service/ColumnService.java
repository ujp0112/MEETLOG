package service;

import dao.ColumnDAO;
import util.StringUtil; // StringUtil 임포트
import model.Column;
import model.Restaurant; // [추가]
import java.util.List;
import java.util.Map;
import java.util.HashMap;

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

	// ▼▼▼ [추가 및 수정] 칼럼과 맛집을 함께 처리하는 서비스 메소드 ▼▼▼

	/**
	 * 칼럼과 첨부된 맛집 목록을 함께 생성합니다.
	 */
	public boolean createColumnWithRestaurants(Column column, List<Integer> restaurantIds) {
		// 1. 칼럼 자체를 먼저 DB에 삽입합니다.
		// (useGeneratedKeys="true" 설정으로 인해 insert 후 column 객체에 id가 채워집니다)
		if (columnDAO.insert(column) > 0) {
			// 2. 성공적으로 삽입되었다면, 해당 칼럼의 ID와 맛집 ID 목록을 연결 테이블에 삽입합니다.
			if (restaurantIds != null && !restaurantIds.isEmpty()) {
				columnDAO.insertColumnRestaurantLinks(column.getId(), restaurantIds);
			}
			return true;
		}
		return false;
	}

	/**
	 * 칼럼과 첨부된 맛집 목록을 함께 수정합니다.
	 */
	public boolean updateColumnWithRestaurants(Column column, List<Integer> restaurantIds) {
		// 1. 칼럼 정보 자체를 업데이트합니다.
		if (columnDAO.update(column) > 0) {
			// 2. 기존의 칼럼-맛집 연결 정보를 모두 삭제합니다.
			columnDAO.deleteColumnRestaurantLinks(column.getId());
			// 3. 새로운 맛집 ID 목록으로 연결 정보를 다시 삽입합니다.
			if (restaurantIds != null && !restaurantIds.isEmpty()) {
				columnDAO.insertColumnRestaurantLinks(column.getId(), restaurantIds);
			}
			return true;
		}
		return false;
	}

	/**
	 * [추가] 여러 레스토랑 ID에 연결된 칼럼 목록을 조회합니다.
	 */
	public List<Column> getColumnsByRestaurantIds(List<Integer> restaurantIds) {
		if (restaurantIds == null || restaurantIds.isEmpty()) {
			return List.of();
		}
		List<Column> columns = columnDAO.findColumnsByRestaurantIds(restaurantIds);
		for (Column column : columns) {
			String summary = StringUtil.stripHtmlAndTruncate(column.getContent(), 100);
			column.setContent(summary);
		}
		return columns;
	}

	/**
	 * [추가] 특정 칼럼에 첨부된 맛집 목록을 조회합니다.
	 */
	public List<Restaurant> getAttachedRestaurantsByColumnId(int columnId) {
		return columnDAO.findAttachedRestaurantsByColumnId(columnId);
	}
}