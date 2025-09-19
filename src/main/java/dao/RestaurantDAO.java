package dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import model.Restaurant;
import util.MyBatisSqlSessionFactory;

public class RestaurantDAO {
    private static final String NAMESPACE = "restaurant";

    /**
     * 모든 음식점 조회
     */
    public List<Restaurant> findAll() {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findAll");
        }
    }

    /**
     * ID로 음식점 조회
     */
    public Restaurant findById(int id) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".findById", id);
        }
    }

    /**
     * 카테고리로 음식점 조회
     */
    public List<Restaurant> findByCategory(String category) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findByCategory", category);
        }
    }

    /**
     * 위치로 음식점 조회
     */
    public List<Restaurant> findByLocation(String location) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findByLocation", location);
        }
    }

    /**
     * 사업자 ID로 음식점 목록 조회
     */
    public List<Restaurant> findByOwnerId(int ownerId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findByOwnerId", ownerId);
        }
    }

    /**
     * 음식점 추가
     */
    public int insert(Restaurant restaurant) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.insert(NAMESPACE + ".insert", restaurant);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 음식점 추가 (트랜잭션 포함)
     */
    public int insert(Restaurant restaurant, SqlSession sqlSession) {
        return sqlSession.insert(NAMESPACE + ".insert", restaurant);
    }

    /**
     * 음식점 수정
     */
    public int update(Restaurant restaurant) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update(NAMESPACE + ".update", restaurant);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 음식점 삭제
     */
    public int delete(int id) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.delete(NAMESPACE + ".delete", id);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 고급 검색을 위한 음식점 검색
     */
    public List<Restaurant> searchRestaurants(java.util.Map<String, Object> searchParams) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".searchRestaurants", searchParams);
        }
    }
    
    /**
     * 인기 음식점 조회 (리뷰 수 기준)
     */
    public List<Restaurant> findTopRestaurants(int limit) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findTopRestaurants", limit);
        }
    }
}