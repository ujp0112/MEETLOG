package dao;

import model.Collection;
import model.Restaurant;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;
import java.util.Map;

/**
 * 맛집 컬렉션 시스템을 위한 DAO 클래스
 */
public class CollectionDAO {
    private static final String NAMESPACE = "dao.CollectionDAO";

    /**
     * 컬렉션 생성
     */
    public int createCollection(Collection collection) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.insert(NAMESPACE + ".createCollection", collection);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 컬렉션 수정
     */
    public int updateCollection(Collection collection) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update(NAMESPACE + ".updateCollection", collection);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 컬렉션 삭제
     */
    public int deleteCollection(int collectionId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update(NAMESPACE + ".deleteCollection", collectionId);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 사용자의 컬렉션 목록 조회
     */
    public List<Collection> getUserCollections(int userId, int limit, int offset) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("userId", userId, "limit", limit, "offset", offset);
            return sqlSession.selectList(NAMESPACE + ".getUserCollections", params);
        }
    }

    /**
     * 공개 컬렉션 목록 조회
     */
    public List<Collection> getPublicCollections(int limit, int offset) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("limit", limit, "offset", offset);
            return sqlSession.selectList(NAMESPACE + ".getPublicCollections", params);
        }
    }

    /**
     * 컬렉션 상세 조회
     */
    public Collection getCollectionById(int collectionId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".getCollectionById", collectionId);
        }
    }

    /**
     * 컬렉션에 맛집 추가
     */
    public int addRestaurantToCollection(int collectionId, int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("collectionId", collectionId, "restaurantId", restaurantId);
            int result = sqlSession.insert(NAMESPACE + ".addRestaurantToCollection", params);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 컬렉션에서 맛집 제거
     */
    public int removeRestaurantFromCollection(int collectionId, int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("collectionId", collectionId, "restaurantId", restaurantId);
            int result = sqlSession.delete(NAMESPACE + ".removeRestaurantFromCollection", params);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 컬렉션의 맛집 목록 조회
     */
    public List<Restaurant> getCollectionRestaurants(int collectionId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".getCollectionRestaurants", collectionId);
        }
    }

    /**
     * 컬렉션 좋아요
     */
    public int likeCollection(int collectionId, int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("collectionId", collectionId, "userId", userId);
            int result = sqlSession.insert(NAMESPACE + ".likeCollection", params);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 컬렉션 좋아요 취소
     */
    public int unlikeCollection(int collectionId, int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("collectionId", collectionId, "userId", userId);
            int result = sqlSession.delete(NAMESPACE + ".unlikeCollection", params);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 컬렉션 좋아요 여부 확인
     */
    public boolean isCollectionLiked(int collectionId, int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("collectionId", collectionId, "userId", userId);
            Integer count = sqlSession.selectOne(NAMESPACE + ".isCollectionLiked", params);
            return count != null && count > 0;
        }
    }

    /**
     * 인기 컬렉션 조회
     */
    public List<Collection> getPopularCollections(int limit) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".getPopularCollections", limit);
        }
    }
}
