package service;

import dao.CouponDAO;
import dao.UserCouponDAO;
import model.Coupon;
import model.UserCoupon;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Date;
import java.util.List;

/**
 * 사용자 쿠폰 서비스
 */
public class UserCouponService {
    private final UserCouponDAO userCouponDAO = new UserCouponDAO();
    private final CouponDAO couponDAO = new CouponDAO();

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
     * 쿠폰 사용 처리 (단순 버전)
     */
    public void useCoupon(int userCouponId) {
        userCouponDAO.useCoupon(userCouponId);
    }

    /**
     * 쿠폰 사용 처리 (예약 ID 및 할인 금액 포함)
     * 결제 성공 시 호출되어 쿠폰을 사용 처리하고 사용 로그를 기록합니다.
     *
     * @param userCouponId 사용자 쿠폰 ID
     * @param reservationId 예약 ID
     * @param discountAmount 할인 금액
     * @return 성공 여부
     */
    public boolean useCoupon(int userCouponId, int reservationId, BigDecimal discountAmount) {
        try {
            // 1. 사용자 쿠폰 조회
            UserCoupon userCoupon = userCouponDAO.findById(userCouponId);
            if (userCoupon == null) {
                return false;
            }

            // 2. 쿠폰을 사용 상태로 변경 (is_used = true, used_at = NOW())
            userCouponDAO.useCoupon(userCouponId);

            // 3. 쿠폰 사용 로그 기록 (coupon_usage_logs 테이블)
            // TODO: CouponUsageLogDAO 추가 필요 (현재는 생략)
            // couponUsageLogDAO.insertLog(userCouponId, reservationId, "USE", discountAmount);

            // 4. 원본 쿠폰의 usage_count 증가
            int couponId = userCoupon.getCouponId();
            int updateCount = couponDAO.incrementUsageCount(couponId);

            return updateCount > 0;

        } catch (Exception e) {
            System.err.println("쿠폰 사용 처리 실패: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 쿠폰 사용 가능 여부 확인
     */
    public boolean canUseCoupon(int userCouponId, int userId) {
        List<UserCoupon> availableCoupons = getAvailableUserCoupons(userId);
        return availableCoupons.stream()
                .anyMatch(coupon -> coupon.getId() == userCouponId && !coupon.isUsed());
    }

    /**
     * 쿠폰 사용 가능 여부를 검증하는 포괄적인 메서드
     * 구현 계획서 2.3.2에 명시된 모든 검증 항목을 포함
     *
     * @param userCouponId 사용자 쿠폰 ID
     * @param userId 사용자 ID
     * @param orderAmount 주문 금액
     * @return 검증 결과 객체
     */
    public CouponValidationResult validateCouponUsable(int userCouponId, int userId, BigDecimal orderAmount) {
        // 1. 사용자 쿠폰 조회
        UserCoupon userCoupon = userCouponDAO.findById(userCouponId);
        if (userCoupon == null) {
            return new CouponValidationResult(false, "쿠폰을 찾을 수 없습니다.");
        }

        // 2. 보안 체크: 세션 userId == user_coupons.user_id
        if (userCoupon.getUserId() != userId) {
            return new CouponValidationResult(false, "다른 사용자의 쿠폰은 사용할 수 없습니다.");
        }

        // 3. 이미 사용된 쿠폰인지 확인
        if (userCoupon.isUsed()) {
            return new CouponValidationResult(false, "이미 사용된 쿠폰입니다.");
        }

        // 4. 쿠폰 정보 조회
        Coupon coupon = couponDAO.findById(userCoupon.getCouponId());
        if (coupon == null) {
            return new CouponValidationResult(false, "쿠폰 정보를 찾을 수 없습니다.");
        }

        // 5. 쿠폰 활성 상태 확인
        if (!coupon.isActive()) {
            return new CouponValidationResult(false, "비활성화된 쿠폰입니다.");
        }

        // 6. 유효 기간 확인 (valid_from <= NOW() <= valid_to)
        Date now = new Date();
        if (coupon.getValidFrom() != null && now.before(coupon.getValidFrom())) {
            return new CouponValidationResult(false, "아직 사용할 수 없는 쿠폰입니다.");
        }
        if (coupon.getValidTo() != null && now.after(coupon.getValidTo())) {
            return new CouponValidationResult(false, "만료된 쿠폰입니다.");
        }

        // 7. 사용 횟수 제한 확인 (usage_count < usage_limit)
        if (coupon.getUsageLimit() != null && coupon.getUsageCount() >= coupon.getUsageLimit()) {
            return new CouponValidationResult(false, "쿠폰 사용 한도가 초과되었습니다.");
        }

        // 8. 최소 주문 금액 확인
        if (coupon.getMinOrderAmount() != null) {
            BigDecimal minAmount = new BigDecimal(coupon.getMinOrderAmount());
            if (orderAmount.compareTo(minAmount) < 0) {
                return new CouponValidationResult(false,
                    String.format("최소 주문 금액 %s원 이상이어야 합니다.", coupon.getMinOrderAmount()));
            }
        }

        // 모든 검증 통과
        return new CouponValidationResult(true, "사용 가능한 쿠폰입니다.", coupon);
    }

    /**
     * 쿠폰 할인 금액 계산
     *
     * @param coupon 쿠폰 정보
     * @param orderAmount 주문 금액
     * @return 할인 금액
     */
    public BigDecimal calculateDiscount(Coupon coupon, BigDecimal orderAmount) {
        if (coupon == null || coupon.getDiscountValue() == null) {
            return BigDecimal.ZERO;
        }

        BigDecimal discount = BigDecimal.ZERO;
        String discountType = coupon.getDiscountType();

        if ("FIXED".equalsIgnoreCase(discountType)) {
            // 고정 금액 할인
            discount = new BigDecimal(coupon.getDiscountValue());
        } else if ("PERCENTAGE".equalsIgnoreCase(discountType) || "PERCENT".equalsIgnoreCase(discountType)) {
            // 퍼센트 할인
            BigDecimal percentage = new BigDecimal(coupon.getDiscountValue());
            discount = orderAmount.multiply(percentage).divide(new BigDecimal(100), 2, RoundingMode.DOWN);

            // 최대 할인 금액 제한이 있는 경우
            if (coupon.getMinOrderAmount() != null) { // 주의: 필드명 확인 필요 (maxDiscountAmount가 있어야 함)
                // TODO: Coupon 모델에 maxDiscountAmount 필드 추가 필요
                // BigDecimal maxDiscount = new BigDecimal(coupon.getMaxDiscountAmount());
                // discount = discount.min(maxDiscount);
            }
        }

        // 할인 금액이 주문 금액을 초과할 수 없음
        return discount.min(orderAmount).setScale(2, RoundingMode.DOWN);
    }

    /**
     * 쿠폰 검증 결과 클래스
     */
    public static class CouponValidationResult {
        private final boolean valid;
        private final String message;
        private final Coupon coupon;

        public CouponValidationResult(boolean valid, String message) {
            this(valid, message, null);
        }

        public CouponValidationResult(boolean valid, String message, Coupon coupon) {
            this.valid = valid;
            this.message = message;
            this.coupon = coupon;
        }

        public boolean isValid() {
            return valid;
        }

        public String getMessage() {
            return message;
        }

        public Coupon getCoupon() {
            return coupon;
        }
    }
}