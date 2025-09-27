package model;

import java.time.LocalDateTime;

/**
 * 저장소 아이템 표시용 DTO
 * 다양한 타입(Restaurant, Course, Column)의 아이템을 통합해서 표시하기 위한 클래스
 */
public class StorageItemDto {
    private String itemType; // RESTAURANT, COURSE, COLUMN
    private int contentId;
    private String title;
    private String description;
    private String imageUrl;
    private String linkUrl;
    private String authorName;
    private LocalDateTime createdAt;
    private String additionalInfo; // 평점, 좋아요 수 등 추가 정보

    public StorageItemDto() {}

    public StorageItemDto(String itemType, int contentId, String title, String description, String imageUrl, String linkUrl) {
        this.itemType = itemType;
        this.contentId = contentId;
        this.title = title;
        this.description = description;
        this.imageUrl = imageUrl;
        this.linkUrl = linkUrl;
    }

    // Getters and Setters
    public String getItemType() {
        return itemType;
    }

    public void setItemType(String itemType) {
        this.itemType = itemType;
    }

    public int getContentId() {
        return contentId;
    }

    public void setContentId(int contentId) {
        this.contentId = contentId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getLinkUrl() {
        return linkUrl;
    }

    public void setLinkUrl(String linkUrl) {
        this.linkUrl = linkUrl;
    }

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getAdditionalInfo() {
        return additionalInfo;
    }

    public void setAdditionalInfo(String additionalInfo) {
        this.additionalInfo = additionalInfo;
    }
}