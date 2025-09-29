package dao;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.session.SqlSession;
import model.User;
import util.MyBatisSqlSessionFactory;

public class ReviewLikeDAO {
	private static final String NAMESPACE = "dao.ReviewLikeMapper";

	public int isLikedByUser(Map<String, Object> params) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectOne(NAMESPACE + ".isLikedByUser", params);
		}
	}

	public List<User> findUsersWhoLikedReview(int reviewId) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".findUsersWhoLikedReview", reviewId);
		}
	}

	public void insertLike(SqlSession session, Map<String, Object> params) {
		session.insert(NAMESPACE + ".insertLike", params);
	}

	public void deleteLike(SqlSession session, Map<String, Object> params) {
		session.delete(NAMESPACE + ".deleteLike", params);
	}
}