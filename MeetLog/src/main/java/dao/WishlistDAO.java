package dao;

import model.Restaurant;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;
import java.util.Map;

/**
 * 찜 시스템을 위한 DAO 클래스
 */
public class WishlistDAO {
    private static final String NAMESPACE = "dao.WishlistDAO";

    /**
     * 찜하기 추가
     */
    public int addWishlist(int userId, int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("userId", userId, "restaurantId", restaurantId);
            int result = sqlSession.insert(NAMESPACE + ".addWishlist", params);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 찜하기 삭제
     */
    public int removeWishlist(int userId, int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("userId", userId, "restaurantId", restaurantId);
            int result = sqlSession.delete(NAMESPACE + ".removeWishlist", params);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 찜 여부 확인
     */
    public boolean isWishlisted(int userId, int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("userId", userId, "restaurantId", restaurantId);
            Boolean result = sqlSession.selectOne(NAMESPACE + ".isWishlisted", params);
            return result != null && result;
        }
    }

    /**
     * 사용자의 찜 목록 조회
     */
    public List<Restaurant> getUserWishlists(int userId, int limit, int offset) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("userId", userId, "limit", limit, "offset", offset);
            return sqlSession.selectList(NAMESPACE + ".getUserWishlists", params);
        }
    }

    /**
     * 레스토랑의 찜 개수 조회
     */
    public int getWishlistCount(int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Integer count = sqlSession.selectOne(NAMESPACE + ".getWishlistCount", restaurantId);
            return count != null ? count : 0;
        }
    }

    /**
     * 사용자의 총 찜 개수 조회
     */
    public int getUserWishlistCount(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Integer count = sqlSession.selectOne(NAMESPACE + ".getUserWishlistCount", userId);
            return count != null ? count : 0;
        }
    }
}
