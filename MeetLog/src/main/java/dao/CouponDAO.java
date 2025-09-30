package dao;

import java.util.List;
import model.Coupon;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;

public class CouponDAO {
    
    /**
     * 맛집별 쿠폰 조회
     */
    public List<Coupon> findByRestaurantId(int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList("CouponMapper.findByRestaurantId", restaurantId);
        } catch (Exception e) {
            System.err.println("쿠폰 조회 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 모든 활성 쿠폰 조회
     */
    public List<Coupon> findAllActive() {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList("CouponMapper.findAllActive");
        } catch (Exception e) {
            System.err.println("쿠폰 조회 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 쿠폰 추가
     */
    public int insertCoupon(Coupon coupon) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.insert("CouponMapper.insertCoupon", coupon);
            sqlSession.commit();
            return result;
        } catch (Exception e) {
            System.err.println("쿠폰 추가 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }
    
    /**
     * 쿠폰 수정
     */
    public int updateCoupon(Coupon coupon) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update("CouponMapper.updateCoupon", coupon);
            sqlSession.commit();
            return result;
        } catch (Exception e) {
            System.err.println("쿠폰 수정 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }
    
    /**
     * 쿠폰 삭제 (비활성화)
     */
    public int deleteCoupon(int couponId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update("CouponMapper.deleteCoupon", couponId);
            sqlSession.commit();
            return result;
        } catch (Exception e) {
            System.err.println("쿠폰 삭제 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * ID로 쿠폰 조회
     */
    public Coupon findById(int couponId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne("CouponMapper.findById", couponId);
        } catch (Exception e) {
            System.err.println("쿠폰 조회 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}
