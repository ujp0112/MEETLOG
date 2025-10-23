package com.meetlog.dto.course;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 코스 검색 요청 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CourseSearchRequest {
    private String keyword; // 제목, 설명에서 검색
    private String area; // 지역 필터
    private String type; // OFFICIAL, COMMUNITY
    private String status; // PENDING, ACTIVE, COMPLETED, CANCELLED
    private Long authorId; // 작성자 필터
    private Integer minPrice; // 최소 가격
    private Integer maxPrice; // 최대 가격
    private String tag; // 태그 필터
    private String sortBy; // created_at, price, title
    private String sortOrder; // asc, desc
    private Integer page;
    private Integer size;
}
