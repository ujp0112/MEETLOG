package model;

import java.util.Date;

/**
 * 사용자 활동 모델
 * 리뷰 작성, 맛집 방문, 팔로우 등의 사용자 활동을 추적
 */
public class UserActivity {
    private int id;
    private int userId;
    private String activityType;    // review, visit, follow, like, etc.
    private String description;     // 활동 설명
    private Date createdAt;
    private int relatedEntityId;    // 관련된 엔티티 ID (restaurant_id, review_id 등)
    private String icon;            // UI에서 사용할 아이콘

    // 기본 생성자
    public UserActivity() {}

    // 생성자
    public UserActivity(int userId, String activityType, String description) {
        this.userId = userId;
        this.activityType = activityType;
        this.description = description;
        this.createdAt = new Date();
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getActivityType() {
        return activityType;
    }

    public void setActivityType(String activityType) {
        this.activityType = activityType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public int getRelatedEntityId() {
        return relatedEntityId;
    }

    public void setRelatedEntityId(int relatedEntityId) {
        this.relatedEntityId = relatedEntityId;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    /**
     * 활동 타입에 따른 기본 아이콘 반환
     */
    public String getDefaultIcon() {
        switch (activityType) {
            case "review": return "⭐";
            case "visit": return "📍";
            case "follow": return "👥";
            case "like": return "❤️";
            case "course": return "🗺️";
            default: return "📝";
        }
    }

    /**
     * 상대적 시간 반환 (예: "2시간 전")
     */
    public String getRelativeTime() {
        if (createdAt == null) return "";

        long diff = System.currentTimeMillis() - createdAt.getTime();
        long minutes = diff / (60 * 1000);
        long hours = diff / (60 * 60 * 1000);
        long days = diff / (24 * 60 * 60 * 1000);

        if (minutes < 1) {
            return "방금 전";
        } else if (minutes < 60) {
            return minutes + "분 전";
        } else if (hours < 24) {
            return hours + "시간 전";
        } else if (days < 7) {
            return days + "일 전";
        } else {
            return days / 7 + "주 전";
        }
    }

    @Override
    public String toString() {
        return "UserActivity{" +
                "id=" + id +
                ", userId=" + userId +
                ", activityType='" + activityType + '\'' +
                ", description='" + description + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}