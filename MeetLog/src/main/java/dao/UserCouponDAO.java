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
}