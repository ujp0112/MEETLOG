package com.meetlog.dto.reservation;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Reservation DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReservationDto {

    private Long id;
    private Long restaurantId;
    private String restaurantName;
    private String restaurantAddress;
    private String restaurantPhone;
    private Long userId;
    private String userName;
    private String userEmail;
    private String userPhone;

    // 예약 정보
    private LocalDateTime reservationTime;
    private Integer partySize;
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
    private String paymentStatus;
    private String paymentOrderId;
    private String paymentProvider;
    private LocalDateTime paymentApprovedAt;

    // 시스템 정보
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
