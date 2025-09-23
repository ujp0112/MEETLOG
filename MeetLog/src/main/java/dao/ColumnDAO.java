package dao;

import model.Column;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;
import java.util.Map;

public class ColumnDAO {
	private static final String NAMESPACE = "dao.ColumnDAO";

    public List<Column> findAll() {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findAll");
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

	public int insert(Column column) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.insert(NAMESPACE + ".insert", column);
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
	
	/**
	 * 특정 사용자의 최근 칼럼 조회 (피드용)
	 */
	public List<Column> getRecentColumnsByUser(int userId, int limit) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			Map<String, Object> params = new java.util.HashMap<>();
			params.put("userId", userId);
			params.put("limit", limit);
			return sqlSession.selectList(NAMESPACE + ".getRecentColumnsByUser", params);
		}
	}
	
	/**
	 * 특정 사용자의 칼럼 개수 조회 (피드용)
	 */
	public int getColumnCountByUser(int userId) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			Integer count = sqlSession.selectOne(NAMESPACE + ".getColumnCountByUser", userId);
			return count != null ? count : 0;
		}
	}
}