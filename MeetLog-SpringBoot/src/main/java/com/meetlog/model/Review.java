package com.meetlog.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * Review Entity
 * 레스토랑 리뷰 정보
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Review {

    private Long id;
    private Long restaurantId;
    private Long userId;

    /**
     * 리뷰 출처
     * INTERNAL: 내부 작성 리뷰
     * GOOGLE: 구글 리뷰
     * KAKAO: 카카오 리뷰
     */
    private String source;

    // 외부 리뷰 정보 (Google, Kakao)
    private String externalReviewId;
    private String externalAuthorName;
    private String externalProfileImage;
    private LocalDateTime externalCreatedAt;
    private String externalRawJson;

    // 리뷰 내용
    private Integer rating;  // 1-5
    private String content;
    private String images;  // JSON array
    private String keywords;  // JSON array
    private Integer likes;

    // 상태 관리
    private Boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // 사업자 답글
    private String replyContent;
    private LocalDateTime replyCreatedAt;

    // Helper methods
    public boolean isInternalReview() {
        return "INTERNAL".equals(this.source);
    }

    public boolean isExternalReview() {
        return "GOOGLE".equals(this.source) || "KAKAO".equals(this.source);
    }

    public boolean hasReply() {
        return this.replyContent != null && !this.replyContent.isEmpty();
    }

    public boolean isOwnedBy(Long userId) {
        return this.userId != null && this.userId.equals(userId);
    }
}
