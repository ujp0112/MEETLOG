package com.meetlog.dto.payment;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.DecimalMin;
import javax.validation.constraints.NotBlank;
import java.math.BigDecimal;

/**
 * 결제 취소 요청 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PaymentCancelRequest {
    @NotBlank(message = "취소 사유는 필수입니다")
    private String cancelReason;

    @DecimalMin(value = "0.0", inclusive = false, message = "취소 금액은 0보다 커야 합니다")
    private BigDecimal cancelAmount; // null이면 전액 취소
}
