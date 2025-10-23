package com.meetlog.dto.payment;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Toss Payments API 응답 DTO
 * 실제 PG사 응답을 매핑
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
public class TossPaymentResponse {
    private String mId; // 가맹점 ID
    private String version; // Payment 객체 버전
    private String paymentKey; // 결제 키
    private String orderId; // 주문 ID
    private String orderName; // 주문명
    private String currency; // 통화
    private String method; // 결제 수단
    private BigDecimal totalAmount; // 총 결제 금액
    private BigDecimal balanceAmount; // 취소 가능 금액
    private String status; // 결제 상태
    private LocalDateTime requestedAt; // 결제 요청 시각
    private LocalDateTime approvedAt; // 결제 승인 시각
    private Boolean useEscrow; // 에스크로 사용 여부
    private Boolean cultureExpense; // 문화비 지출 여부

    // 카드 정보
    private Card card;

    // 가상계좌 정보
    private VirtualAccount virtualAccount;

    // 환불 정보
    private Cancels cancels;

    // 실패 정보
    private Failure failure;

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Card {
        private String company; // 카드사
        private String number; // 카드 번호 (마스킹)
        private Integer installmentPlanMonths; // 할부 개월 수
        private String approveNo; // 승인 번호
        private String cardType; // 카드 타입 (신용/체크)
        private String ownerType; // 개인/법인
        private String acquireStatus; // 매입 상태
    }

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class VirtualAccount {
        private String accountType; // 계좌 타입
        private String accountNumber; // 계좌 번호
        private String bankCode; // 은행 코드
        private String customerName; // 입금자명
        private LocalDateTime dueDate; // 입금 기한
        private String refundStatus; // 환불 상태
        private Boolean expired; // 만료 여부
        private String settlementStatus; // 정산 상태
    }

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Cancels {
        private BigDecimal cancelAmount; // 취소 금액
        private String cancelReason; // 취소 사유
        private BigDecimal taxFreeAmount; // 면세 금액
        private LocalDateTime canceledAt; // 취소 일시
        private String transactionKey; // 거래 키
    }

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Failure {
        private String code; // 오류 코드
        private String message; // 오류 메시지
    }
}
