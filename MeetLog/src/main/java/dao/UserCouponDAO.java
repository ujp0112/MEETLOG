package dao;

import model.UserCoupon;
import util.MyBatisSqlSessionFactory;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

/**
 * 사용자 쿠폰 데이터 액세스 객체
 */
public class UserCouponDAO {

    /**
     * 사용자의 모든 쿠폰 조회 (쿠폰 정보와 음식점 정보 포함)
     */
    public List<UserCoupon> getUserCoupons(int userId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList("dao.UserCouponDAO.getUserCoupons", userId);
        }
    }

    /**
     * 사용자의 사용 가능한 쿠폰 조회
     */
    public List<UserCoupon> getAvailableUserCoupons(int userId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList("dao.UserCouponDAO.getAvailableUserCoupons", userId);
        }
    }

    /**
     * 사용자의 사용한 쿠폰 조회
     */
    public List<UserCoupon> getUsedUserCoupons(int userId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList("dao.UserCouponDAO.getUsedUserCoupons", userId);
        }
    }

    /**
     * 사용자 쿠폰 개수 조회
     */
    public int getUserCouponCount(int userId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Integer count = session.selectOne("dao.UserCouponDAO.getUserCouponCount", userId);
            return count != null ? count : 0;
        }
    }

    /**
     * 사용 가능한 쿠폰 개수 조회
     */
    public int getAvailableCouponCount(int userId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Integer count = session.selectOne("dao.UserCouponDAO.getAvailableCouponCount", userId);
            return count != null ? count : 0;
        }
    }

    /**
     * 사용자에게 쿠폰 지급
     */
    public void giveCouponToUser(int userId, int couponId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            UserCoupon userCoupon = new UserCoupon();
            userCoupon.setUserId(userId);
            userCoupon.setCouponId(couponId);

            session.insert("dao.UserCouponDAO.giveCouponToUser", userCoupon);
            session.commit();
        }
    }

    /**
     * 쿠폰 사용 처리
     */
    public void useCoupon(int userCouponId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            session.update("dao.UserCouponDAO.useCoupon", userCouponId);
            session.commit();
        }
    }

    /**
     * 쿠폰 롤백 처리 (예약 취소 시)
     * is_used = false, used_at = NULL로 되돌림
     */
    public void rollbackCoupon(int userCouponId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            session.update("dao.UserCouponDAO.rollbackCoupon", userCouponId);
            session.commit();
        }
    }

    /**
     * ID로 사용자 쿠폰 조회
     */
    public UserCoupon findById(int userCouponId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne("dao.UserCouponDAO.findById", userCouponId);
        }
    }

    /**
     * 사용자가 특정 쿠폰을 받은 횟수 조회 (per_user_limit 검증용)
     */
    public int countUserCouponByCouponId(int userId, int couponId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            java.util.Map<String, Integer> params = new java.util.HashMap<>();
            params.put("userId", userId);
            params.put("couponId", couponId);
            Integer count = session.selectOne("dao.UserCouponDAO.countUserCouponByCouponId", params);
            return count != null ? count : 0;
        }
    }

    /**
     * 사용자가 이미 특정 쿠폰을 받았는지 확인
     */
    public boolean hasUserReceivedCoupon(int userId, int couponId) {
        return countUserReceivedCoupon(userId, couponId) > 0;
    }

    /**
     * 사용자가 특정 쿠폰을 받은 횟수 조회
     */
    public int countUserReceivedCoupon(int userId, int couponId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            java.util.Map<String, Integer> params = new java.util.HashMap<>();
            params.put("userId", userId);
            params.put("couponId", couponId);
            Integer count = session.selectOne("dao.UserCouponDAO.countUserCouponByCouponId", params);
            return count != null ? count : 0;
        }
    }
}