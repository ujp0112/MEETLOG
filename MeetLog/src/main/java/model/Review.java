package model;

import java.time.LocalDateTime;
import java.util.List;

public class Review {

    // reviews 테이블의 컬럼과 직접 매핑되는 필드들
    private int id;
    private int restaurantId;
    private int userId;
    private int rating;
    private String content;
    private int likes;
    private boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // 추가 평점 필드
    private int tasteRating;
    private int serviceRating;
    private int atmosphereRating;
    private int priceRating;
    
    // 방문 정보 필드
    private LocalDateTime visitDate;
    private int partySize;
    private String visitPurpose;
    
    // JSON 또는 분리된 문자열로 관리되는 필드
    private List<String> images;
    private List<String> keywords;

    // Users 테이블과 JOIN하여 가져올 데이터를 담는 필드 (DTO 역할)
    private String author; // users.nickname 값이 여기에 매핑됩니다.
    private String profileImage; // users.profile_image 값이 여기에 매핑됩니다.

    // --- Getter and Setter ---

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getLikes() {
        return likes;
    }

    public void setLikes(int likes) {
        this.likes = likes;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean isActive) {
        this.isActive = isActive;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public int getTasteRating() {
        return tasteRating;
    }

    public void setTasteRating(int tasteRating) {
        this.tasteRating = tasteRating;
    }

    public int getServiceRating() {
        return serviceRating;
    }

    public void setServiceRating(int serviceRating) {
        this.serviceRating = serviceRating;
    }

    public int getAtmosphereRating() {
        return atmosphereRating;
    }

    public void setAtmosphereRating(int atmosphereRating) {
        this.atmosphereRating = atmosphereRating;
    }

    public int getPriceRating() {
        return priceRating;
    }

    public void setPriceRating(int priceRating) {
        this.priceRating = priceRating;
    }

    public LocalDateTime getVisitDate() {
        return visitDate;
    }

    public void setVisitDate(LocalDateTime visitDate) {
        this.visitDate = visitDate;
    }

    public int getPartySize() {
        return partySize;
    }

    public void setPartySize(int partySize) {
        this.partySize = partySize;
    }

    public String getVisitPurpose() {
        return visitPurpose;
    }

    public void setVisitPurpose(String visitPurpose) {
        this.visitPurpose = visitPurpose;
    }

    public List<String> getImages() {
        return images;
    }

    public void setImages(List<String> images) {
        this.images = images;
    }

    public List<String> getKeywords() {
        return keywords;
    }

    public void setKeywords(List<String> keywords) {
        this.keywords = keywords;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getProfileImage() {
        return profileImage;
    }

    public void setProfileImage(String profileImage) {
        this.profileImage = profileImage;
    }
}