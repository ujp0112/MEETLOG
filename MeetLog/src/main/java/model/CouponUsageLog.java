package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * 쿠폰 사용 로그 모델
 * coupon_usage_logs 테이블과 매핑
 */
public class CouponUsageLog {
    private int id;
    private int userCouponId;
    private Integer reservationId;
    private String action;  // USE, ROLLBACK
    private BigDecimal discountAmount;
    private Timestamp createdAt;

    public CouponUsageLog() {}

    public CouponUsageLog(int userCouponId, Integer reservationId, String action, BigDecimal discountAmount) {
        this.userCouponId = userCouponId;
        this.reservationId = reservationId;
        this.action = action;
        this.discountAmount = discountAmount;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserCouponId() {
        return userCouponId;
    }

    public void setUserCouponId(int userCouponId) {
        this.userCouponId = userCouponId;
    }

    public Integer getReservationId() {
        return reservationId;
    }

    public void setReservationId(Integer reservationId) {
        this.reservationId = reservationId;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "CouponUsageLog{" +
                "id=" + id +
                ", userCouponId=" + userCouponId +
                ", reservationId=" + reservationId +
                ", action='" + action + '\'' +
                ", discountAmount=" + discountAmount +
                ", createdAt=" + createdAt +
                '}';
    }
}
