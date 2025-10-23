package com.meetlog.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Reservation Entity
 * 예약 정보
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Reservation {

    private Long id;
    private Long restaurantId;
    private Long userId;
    private String restaurantName;
    private String userName;

    // 예약 정보
    private LocalDateTime reservationTime;
    private Integer partySize;

    /**
     * 예약 상태
     * PENDING: 대기 중
     * CONFIRMED: 확정
     * COMPLETED: 완료
     * CANCELLED: 취소
     */
    private String status;

    private String specialRequests;
    private String contactPhone;

    // 취소 정보
    private String cancelReason;
    private LocalDateTime cancelledAt;

    // 예약금 정보
    private Boolean depositRequired;
    private BigDecimal depositAmount;

    // 쿠폰 정보
    private Long userCouponId;
    private BigDecimal couponDiscountAmount;

    // 결제 정보
    private String paymentStatus;  // NONE, PENDING, COMPLETED, FAILED, CANCELLED
    private String paymentOrderId;
    private String paymentProvider;  // KAKAO, NAVER, CARD
    private LocalDateTime paymentApprovedAt;

    // 시스템 정보
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Helper methods
    public boolean isPending() {
        return "PENDING".equals(this.status);
    }

    public boolean isConfirmed() {
        return "CONFIRMED".equals(this.status);
    }

    public boolean isCompleted() {
        return "COMPLETED".equals(this.status);
    }

    public boolean isCancelled() {
        return "CANCELLED".equals(this.status);
    }

    public boolean canCancel() {
        return isPending() || isConfirmed();
    }

    public boolean canConfirm() {
        return isPending();
    }

    public boolean isOwnedBy(Long userId) {
        return this.userId != null && this.userId.equals(userId);
    }

    public boolean requiresPayment() {
        return depositRequired != null && depositRequired && depositAmount != null && depositAmount.compareTo(BigDecimal.ZERO) > 0;
    }

    public boolean isPaymentCompleted() {
        return "COMPLETED".equals(this.paymentStatus);
    }
}
