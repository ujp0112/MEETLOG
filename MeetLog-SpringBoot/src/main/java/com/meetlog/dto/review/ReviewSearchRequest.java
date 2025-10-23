package com.meetlog.dto.review;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Review Search Request DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReviewSearchRequest {

    private Long restaurantId;
    private Long userId;
    private Integer minRating;
    private Integer maxRating;
    private String source;  // INTERNAL, GOOGLE, KAKAO
    private Boolean isActive;

    // 정렬
    private String sortBy;  // created_at, rating, likes
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
