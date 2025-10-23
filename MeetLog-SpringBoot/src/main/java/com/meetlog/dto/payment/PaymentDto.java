package com.meetlog.dto.payment;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Payment 응답 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PaymentDto {
    private Long id;
    private String paymentType;
    private Long referenceId;
    private Long userId;

    // 결제 정보
    private String orderId;
    private String orderName;
    private BigDecimal amount;
    private String currency;

    // 결제 수단
    private String paymentMethod;
    private String provider;

    // 결제 상태
    private String status;
    private String paymentKey;

    // 승인/취소 정보
    private LocalDateTime requestedAt;
    private LocalDateTime approvedAt;
    private LocalDateTime canceledAt;
    private String cancelReason;

    // 환불 정보
    private BigDecimal refundAmount;
    private String refundStatus;

    // 실패 정보
    private String failReason;

    // 메타 정보
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // 사용자 정보
    private String userName;
    private String userEmail;
}
