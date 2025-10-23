package com.meetlog.dto.course;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Course 응답 DTO
 * 코스 정보와 단계(steps)를 포함
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CourseDto {
    private Long courseId;
    private String title;
    private String description;
    private String area;
    private String duration;
    private Integer price;
    private Integer maxParticipants;
    private String status;
    private LocalDateTime createdAt;
    private String type;
    private String previewImage;
    private Long authorId;

    // 추가 정보
    private String authorName;
    private String authorNickname;
    private Integer likesCount;
    private Integer commentsCount;
    private Integer reservationsCount;
    private Boolean isLiked; // 현재 사용자가 좋아요를 눌렀는지

    // 코스 단계 목록
    private List<CourseStepDto> steps;

    // 태그 목록
    private List<String> tags;
}
