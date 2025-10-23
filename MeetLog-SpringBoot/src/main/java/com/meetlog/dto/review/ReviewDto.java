package com.meetlog.dto.review;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Review DTO
 * 리뷰 정보 + 사용자 정보
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReviewDto {

    private Long id;
    private Long restaurantId;
    private String restaurantName;
    private Long userId;
    private String userName;
    private String userNickname;
    private String userProfileImage;

    // 리뷰 출처
    private String source;

    // 외부 리뷰 정보
    private String externalReviewId;
    private String externalAuthorName;
    private String externalProfileImage;
    private LocalDateTime externalCreatedAt;

    // 리뷰 내용
    private Integer rating;
    private String content;
    private List<String> images;
    private List<String> keywords;
    private Integer likes;

    // 상태
    private Boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // 사업자 답글
    private String replyContent;
    private LocalDateTime replyCreatedAt;

    // 사용자가 좋아요를 눌렀는지 여부 (선택)
    private Boolean isLikedByCurrentUser;
}
