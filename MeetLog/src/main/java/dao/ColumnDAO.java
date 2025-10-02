package dao;

import model.Column;
import model.Restaurant; // [추가]
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;
import java.util.Map;
import java.util.HashMap; // [추가]

public class ColumnDAO {
	private static final String NAMESPACE = "dao.ColumnDAO";

	public List<Column> findAll() {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".findAll");
		}
	}
	/**
	 * [추가] 여러 레스토랑 ID에 연결된 칼럼 목록을 조회합니다.
	 * @param restaurantIds 레스토랑 ID 리스트
	 * @return 관련 칼럼 리스트
	 */
	public List<Column> findColumnsByRestaurantIds(List<Integer> restaurantIds) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".findColumnsByRestaurantIds", restaurantIds);
		}
	}

	public List<Column> findTopColumns(int limit) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".findTopColumns", limit);
		}
	}

	public List<Column> findRecentColumns(int limit) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".findRecentColumns", limit);
		}
	}

	public Column findById(int columnId) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectOne(NAMESPACE + ".findById", columnId);
		}
	}

	public List<Column> findByUserId(int userId) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".findByUserId", userId);
		}
	}

	public List<Column> findRecentByUserId(Map<String, Object> params) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".findRecentByUserId", params);
		}
	}

	public List<Column> findRankedByRegion(String region) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".findRankedByRegion", region);
		}
	}

	public int insert(Column column) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) { // [수정] openSession() 사용
			int result = sqlSession.insert(NAMESPACE + ".insert", column);
			sqlSession.commit(); // [수정] commit
			return result;
		}
	}

	public int update(Column column) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.update(NAMESPACE + ".update", column);
		}
	}

	public int delete(int columnId) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.update(NAMESPACE + ".delete", columnId);
		}
	}

	public int incrementViews(int columnId) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.update(NAMESPACE + ".incrementViews", columnId);
		}
	}

	public int likeColumn(int columnId) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.update(NAMESPACE + ".likeColumn", columnId);
		}
	}

	public List<Column> searchColumns(Map<String, Object> searchParams) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".searchColumns", searchParams);
		}
	}
	
	// ▼▼▼ [추가] 칼럼-맛집 관계 처리를 위한 DAO 메소드들 ▼▼▼

    public List<Restaurant> findAttachedRestaurantsByColumnId(int columnId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findAttachedRestaurantsByColumnId", columnId);
        }
    }

    public void insertColumnRestaurantLinks(int columnId, List<Integer> restaurantIds) {
        if (restaurantIds == null || restaurantIds.isEmpty()) return;
        
        Map<String, Object> params = new HashMap<>();
        params.put("columnId", columnId);
        params.put("restaurantIds", restaurantIds);
        
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            sqlSession.insert(NAMESPACE + ".insertColumnRestaurantLinks", params);
            sqlSession.commit();
        }
    }

    public void deleteColumnRestaurantLinks(int columnId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            sqlSession.delete(NAMESPACE + ".deleteColumnRestaurantLinks", columnId);
            sqlSession.commit();
        }
    }
}