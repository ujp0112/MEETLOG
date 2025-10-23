package com.meetlog.dto.reservation;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.*;
import java.time.LocalDateTime;

/**
 * Reservation Create Request DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReservationCreateRequest {

    @NotNull(message = "레스토랑 ID는 필수입니다.")
    private Long restaurantId;

    @NotNull(message = "예약 시간은 필수입니다.")
    @Future(message = "예약 시간은 현재 시간 이후여야 합니다.")
    private LocalDateTime reservationTime;

    @NotNull(message = "인원 수는 필수입니다.")
    @Min(value = 1, message = "최소 1명 이상이어야 합니다.")
    @Max(value = 50, message = "최대 50명까지 예약 가능합니다.")
    private Integer partySize;

    @Size(max = 500, message = "요청 사항은 500자 이하여야 합니다.")
    private String specialRequests;

    @Pattern(regexp = "^01[0-9]-?[0-9]{3,4}-?[0-9]{4}$", message = "올바른 전화번호 형식이 아닙니다.")
    private String contactPhone;

    private Long userCouponId;
}
