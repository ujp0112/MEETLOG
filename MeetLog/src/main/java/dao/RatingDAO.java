package dao;

import model.RatingDistribution;
import model.DetailedRatings;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;

public class RatingDAO {
    
    /**
     * 맛집별 평점 분포 조회
     */
    public RatingDistribution findRatingDistributionByRestaurantId(int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne("RatingMapper.findRatingDistributionByRestaurantId", restaurantId);
        } catch (Exception e) {
            System.err.println("평점 분포 조회 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 맛집별 상세 평점 조회
     */
    public DetailedRatings findDetailedRatingsByRestaurantId(int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne("RatingMapper.findDetailedRatingsByRestaurantId", restaurantId);
        } catch (Exception e) {
            System.err.println("상세 평점 조회 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 평점 분포 추가
     */
    public int insertRatingDistribution(RatingDistribution ratingDistribution) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.insert("RatingMapper.insertRatingDistribution", ratingDistribution);
            sqlSession.commit();
            return result;
        } catch (Exception e) {
            System.err.println("평점 분포 추가 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }
    
    /**
     * 상세 평점 추가
     */
    public int insertDetailedRatings(DetailedRatings detailedRatings) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.insert("RatingMapper.insertDetailedRatings", detailedRatings);
            sqlSession.commit();
            return result;
        } catch (Exception e) {
            System.err.println("상세 평점 추가 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }
}
