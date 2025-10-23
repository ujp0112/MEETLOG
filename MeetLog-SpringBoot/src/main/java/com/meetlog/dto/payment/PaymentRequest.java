package com.meetlog.dto.payment;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.*;
import java.math.BigDecimal;

/**
 * 결제 요청 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PaymentRequest {
    @NotBlank(message = "결제 타입은 필수입니다")
    @Pattern(regexp = "RESERVATION|COURSE_RESERVATION", message = "결제 타입은 RESERVATION 또는 COURSE_RESERVATION이어야 합니다")
    private String paymentType;

    @NotNull(message = "참조 ID는 필수입니다")
    private Long referenceId; // reservation_id or course_reservation_id

    @NotBlank(message = "주문명은 필수입니다")
    @Size(max = 100, message = "주문명은 100자를 초과할 수 없습니다")
    private String orderName;

    @NotNull(message = "결제 금액은 필수입니다")
    @DecimalMin(value = "0.0", inclusive = false, message = "결제 금액은 0보다 커야 합니다")
    private BigDecimal amount;

    @NotBlank(message = "결제 수단은 필수입니다")
    @Pattern(regexp = "CARD|VIRTUAL_ACCOUNT|TRANSFER|MOBILE_PHONE|CULTURE_GIFT_CERTIFICATE|FOREIGN_EASY_PAY",
             message = "유효하지 않은 결제 수단입니다")
    private String paymentMethod;

    private String successUrl; // 결제 성공 시 리다이렉트 URL
    private String failUrl; // 결제 실패 시 리다이렉트 URL
}
