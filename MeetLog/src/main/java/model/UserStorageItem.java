package model;

import java.time.LocalDateTime;

/**
 * 사용자 저장소 아이템 모델 클래스
 */
public class UserStorageItem {
    private int itemId;
    private int storageId;
    private String itemType; // RESTAURANT, COURSE, COLUMN
    private int contentId; // 실제 콘텐츠의 ID
    private LocalDateTime addedAt;
    
    // 조인된 데이터
    private String contentTitle; // 콘텐츠 제목
    private String contentImage; // 콘텐츠 이미지
    private String contentDescription; // 콘텐츠 설명
    private String contentAuthor; // 콘텐츠 작성자
    private Double contentRating; // 평점 (음식점용)

    public UserStorageItem() {
    }

    public UserStorageItem(int storageId, String itemType, int contentId) {
        this.storageId = storageId;
        this.itemType = itemType;
        this.contentId = contentId;
    }

    // Getters and Setters
    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public int getStorageId() {
        return storageId;
    }

    public void setStorageId(int storageId) {
        this.storageId = storageId;
    }

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

    public LocalDateTime getAddedAt() {
        return addedAt;
    }

    public void setAddedAt(LocalDateTime addedAt) {
        this.addedAt = addedAt;
    }

    public String getContentTitle() {
        return contentTitle;
    }

    public void setContentTitle(String contentTitle) {
        this.contentTitle = contentTitle;
    }

    public String getContentImage() {
        return contentImage;
    }

    public void setContentImage(String contentImage) {
        this.contentImage = contentImage;
    }

    public String getContentDescription() {
        return contentDescription;
    }

    public void setContentDescription(String contentDescription) {
        this.contentDescription = contentDescription;
    }

    public String getContentAuthor() {
        return contentAuthor;
    }

    public void setContentAuthor(String contentAuthor) {
        this.contentAuthor = contentAuthor;
    }

    public Double getContentRating() {
        return contentRating;
    }

    public void setContentRating(Double contentRating) {
        this.contentRating = contentRating;
    }
}
