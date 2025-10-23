package com.meetlog.dto.course;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * CourseStep DTO
 * 코스의 각 단계(장소) 정보
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CourseStepDto {
    private Long stepId;
    private Long courseId;
    private Integer stepOrder;
    private String stepType;
    private String emoji;
    private String name;
    private BigDecimal latitude;
    private BigDecimal longitude;
    private String address;
    private String description;
    private String image;
    private Integer time; // 소요 시간 (분)
    private Integer cost; // 예상 비용 (원)
}
