package com.meetlog.dto.payment;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;

/**
 * 결제 승인 요청 DTO (Toss Payments)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PaymentApprovalRequest {
    @NotBlank(message = "결제 키는 필수입니다")
    private String paymentKey;

    @NotBlank(message = "주문 ID는 필수입니다")
    private String orderId;

    @NotNull(message = "결제 금액은 필수입니다")
    private BigDecimal amount;
}
