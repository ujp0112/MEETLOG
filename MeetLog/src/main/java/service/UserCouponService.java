package service;

import dao.UserCouponDAO;
import model.UserCoupon;

import java.util.List;

/**
 * 사용자 쿠폰 서비스
 */
public class UserCouponService {
    private final UserCouponDAO userCouponDAO = new UserCouponDAO();

    /**
     * 사용자의 모든 쿠폰 조회
     */
    public List<UserCoupon> getUserCoupons(int userId) {
        return userCouponDAO.getUserCoupons(userId);
    }

    /**
     * 사용자의 사용 가능한 쿠폰 조회
     */
    public List<UserCoupon> getAvailableUserCoupons(int userId) {
        return userCouponDAO.getAvailableUserCoupons(userId);
    }

    /**
     * 사용자의 사용한 쿠폰 조회
     */
    public List<UserCoupon> getUsedUserCoupons(int userId) {
        return userCouponDAO.getUsedUserCoupons(userId);
    }

    /**
     * 사용자 쿠폰 개수 조회
     */
    public int getUserCouponCount(int userId) {
        return userCouponDAO.getUserCouponCount(userId);
    }

    /**
     * 사용 가능한 쿠폰 개수 조회
     */
    public int getAvailableCouponCount(int userId) {
        return userCouponDAO.getAvailableCouponCount(userId);
    }

    /**
     * 사용자에게 쿠폰 지급
     */
    public void giveCouponToUser(int userId, int couponId) {
        userCouponDAO.giveCouponToUser(userId, couponId);
    }

    /**
     * 쿠폰 사용 처리
     */
    public void useCoupon(int userCouponId) {
        userCouponDAO.useCoupon(userCouponId);
    }

    /**
     * 쿠폰 사용 가능 여부 확인
     */
    public boolean canUseCoupon(int userCouponId, int userId) {
        List<UserCoupon> availableCoupons = getAvailableUserCoupons(userId);
        return availableCoupons.stream()
                .anyMatch(coupon -> coupon.getId() == userCouponId && !coupon.isUsed());
    }
}