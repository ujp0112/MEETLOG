package com.meetlog.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Payment 엔티티
 * 결제 정보를 저장하는 별도 테이블
 * 예약(Reservation) 또는 코스 예약(Course Reservation)과 연결
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Payment {
    private Long id;
    private String paymentType; // RESERVATION, COURSE_RESERVATION
    private Long referenceId; // reservation_id or course_reservation_id
    private Long userId;

    // 결제 정보
    private String orderId; // 주문 ID (고유 식별자)
    private String orderName; // 주문명
    private BigDecimal amount; // 결제 금액
    private String currency; // 통화 (KRW, USD 등)

    // 결제 수단
    private String paymentMethod; // CARD, VIRTUAL_ACCOUNT, TRANSFER, MOBILE_PHONE, CULTURE_GIFT_CERTIFICATE, FOREIGN_EASY_PAY
    private String provider; // TOSS, KAKAO, NAVER 등

    // 결제 상태
    private String status; // READY, IN_PROGRESS, DONE, CANCELED, PARTIAL_CANCELED, ABORTED, EXPIRED
    private String paymentKey; // 결제 승인 키 (PG사 제공)

    // 승인/취소 정보
    private LocalDateTime requestedAt; // 결제 요청 시각
    private LocalDateTime approvedAt; // 결제 승인 시각
    private LocalDateTime canceledAt; // 결제 취소 시각
    private String cancelReason; // 취소 사유

    // 환불 정보
    private BigDecimal refundAmount; // 환불 금액
    private String refundStatus; // NONE, PARTIAL, FULL

    // 메타 정보
    private String rawResponse; // PG사 응답 원본 (JSON)
    private String failReason; // 실패 사유
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Helper methods
    public boolean isReady() {
        return "READY".equals(status);
    }

    public boolean isInProgress() {
        return "IN_PROGRESS".equals(status);
    }

    public boolean isDone() {
        return "DONE".equals(status);
    }

    public boolean isCanceled() {
        return "CANCELED".equals(status) || "PARTIAL_CANCELED".equals(status);
    }

    public boolean isExpired() {
        return "EXPIRED".equals(status);
    }

    public boolean isAborted() {
        return "ABORTED".equals(status);
    }

    public boolean canCancel() {
        return isDone() && !"FULL".equals(refundStatus);
    }

    public boolean isPartialRefund() {
        return "PARTIAL".equals(refundStatus);
    }

    public boolean isFullRefund() {
        return "FULL".equals(refundStatus);
    }

    public boolean isCardPayment() {
        return "CARD".equals(paymentMethod);
    }

    public boolean isVirtualAccount() {
        return "VIRTUAL_ACCOUNT".equals(paymentMethod);
    }

    public boolean requiresApproval() {
        return isReady() || isInProgress();
    }

    public String getStatusText() {
        switch (status) {
            case "READY":
                return "결제 대기";
            case "IN_PROGRESS":
                return "결제 진행 중";
            case "DONE":
                return "결제 완료";
            case "CANCELED":
                return "결제 취소";
            case "PARTIAL_CANCELED":
                return "부분 취소";
            case "ABORTED":
                return "결제 중단";
            case "EXPIRED":
                return "결제 만료";
            default:
                return status;
        }
    }

    public String getMethodText() {
        switch (paymentMethod) {
            case "CARD":
                return "카드";
            case "VIRTUAL_ACCOUNT":
                return "가상계좌";
            case "TRANSFER":
                return "계좌이체";
            case "MOBILE_PHONE":
                return "휴대폰";
            case "CULTURE_GIFT_CERTIFICATE":
                return "문화상품권";
            case "FOREIGN_EASY_PAY":
                return "간편결제";
            default:
                return paymentMethod;
        }
    }
}
