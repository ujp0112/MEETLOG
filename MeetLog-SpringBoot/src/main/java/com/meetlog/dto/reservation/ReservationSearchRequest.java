package com.meetlog.dto.reservation;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * Reservation Search Request DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReservationSearchRequest {

    private Long restaurantId;
    private Long userId;
    private String status;
    private LocalDateTime startDate;
    private LocalDateTime endDate;

    // 정렬
    private String sortBy;  // reservation_time, created_at
    private String sortOrder;  // asc, desc

    // 페이징
    private Integer page;
    private Integer size;

    // Computed fields
    public Integer getOffset() {
        if (page == null || size == null) return 0;
        return (page - 1) * size;
    }

    public Integer getLimit() {
        return size != null ? size : 10;
    }
}
