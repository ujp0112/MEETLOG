package com.meetlog.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * Course 엔티티
 * 데이터베이스 courses 테이블과 매핑
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Course {
    private Long courseId;
    private String title;
    private String description;
    private String area;
    private String duration;
    private Integer price;
    private Integer maxParticipants;
    private String status; // PENDING, ACTIVE, COMPLETED, CANCELLED
    private LocalDateTime createdAt;
    private String type; // OFFICIAL, COMMUNITY
    private String previewImage;
    private Long authorId;

    // Helper methods
    public boolean isActive() {
        return "ACTIVE".equals(status);
    }

    public boolean isPending() {
        return "PENDING".equals(status);
    }

    public boolean isOfficialCourse() {
        return "OFFICIAL".equals(type);
    }

    public boolean isCommunityCourse() {
        return "COMMUNITY".equals(type);
    }

    public boolean isOwnedBy(Long userId) {
        return authorId != null && authorId.equals(userId);
    }

    public boolean canEdit(Long userId) {
        return isOwnedBy(userId) && (isPending() || isActive());
    }

    public boolean canCancel() {
        return isPending() || isActive();
    }

    public String getTypeText() {
        return "OFFICIAL".equals(type) ? "공식 코스" : "커뮤니티 코스";
    }

    public String getStatusText() {
        switch (status) {
            case "PENDING":
                return "대기 중";
            case "ACTIVE":
                return "활성";
            case "COMPLETED":
                return "완료";
            case "CANCELLED":
                return "취소";
            default:
                return status;
        }
    }

    public boolean isFree() {
        return price == null || price == 0;
    }

    public boolean hasLimit() {
        return maxParticipants != null && maxParticipants > 0;
    }
}
