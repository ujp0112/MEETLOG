package service;

import java.util.Collections;
import java.util.List;
import dao.CouponDAO;
import model.Coupon;

public class CouponService {
    private CouponDAO couponDAO = new CouponDAO();
    
    /**
     * 맛집별 쿠폰 조회
     */
    public List<Coupon> getCouponsByRestaurantId(int restaurantId) {
        try {
            List<Coupon> coupons = couponDAO.findByRestaurantId(restaurantId);
            return coupons != null ? coupons : Collections.emptyList();
        } catch (Exception e) {
            System.err.println("맛집별 쿠폰 조회 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return Collections.emptyList();
        }
    }
    
    /**
     * 모든 활성 쿠폰 조회
     */
    public List<Coupon> getAllActiveCoupons() {
        try {
            List<Coupon> coupons = couponDAO.findAllActive();
            return coupons != null ? coupons : Collections.emptyList();
        } catch (Exception e) {
            System.err.println("활성 쿠폰 조회 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return Collections.emptyList();
        }
    }
    
    /**
     * 쿠폰 추가
     */
    public boolean addCoupon(Coupon coupon) {
        try {
            int result = couponDAO.insertCoupon(coupon);
            return result > 0;
        } catch (Exception e) {
            System.err.println("쿠폰 추가 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 쿠폰 수정
     */
    public boolean updateCoupon(Coupon coupon) {
        try {
            int result = couponDAO.updateCoupon(coupon);
            return result > 0;
        } catch (Exception e) {
            System.err.println("쿠폰 수정 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 쿠폰 삭제
     */
    public boolean deleteCoupon(int couponId) {
        try {
            int result = couponDAO.deleteCoupon(couponId);
            return result > 0;
        } catch (Exception e) {
            System.err.println("쿠폰 삭제 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * ID로 쿠폰 조회
     */
    public Coupon getCouponById(int couponId) {
        try {
            return couponDAO.findById(couponId);
        } catch (Exception e) {
            System.err.println("쿠폰 조회 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 쿠폰 비활성화
     */
    public boolean deactivateCoupon(int couponId) {
        try {
            int result = couponDAO.deleteCoupon(couponId);
            return result > 0;
        } catch (Exception e) {
            System.err.println("쿠폰 비활성화 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
