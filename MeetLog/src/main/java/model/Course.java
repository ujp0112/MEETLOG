package model;

import java.time.LocalDateTime;

/**
 * course-recommendation.jsp (사용자 화면)에서 사용할 코스 모델 클래스입니다.
 * AdminCourse와는 별도로 사용자 화면에 필요한 정보(아이콘, 평점 등)를 담습니다.
 */
public class Course {

    private int id;
    private int courseId; // 코스 ID (별칭)
    private String icon = "🎓"; // JSP에서 아이콘을 사용하므로 기본값 설정
    private String title;
    private String description;
    private String duration;
    private int price;
    private double rating; // 평균 평점
    private int authorId; // 코스 작성자 ID
    private String previewImage; // 미리보기 이미지
    private LocalDateTime createdAt; // 생성 시간
    private boolean isPublic = true; // 공개 여부
    private int restaurantCount = 0; // 포함된 음식점 수
    private int likeCount = 0; // 좋아요 수

    // --- Getters and Setters ---
    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
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

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
        this.id = courseId; // id와 courseId 동기화
    }

    public int getAuthorId() {
        return authorId;
    }

    public void setAuthorId(int authorId) {
        this.authorId = authorId;
    }

    public String getPreviewImage() {
        return previewImage;
    }

    public void setPreviewImage(String previewImage) {
        this.previewImage = previewImage;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isPublic() {
        return isPublic;
    }

    public void setPublic(boolean isPublic) {
        this.isPublic = isPublic;
    }

    public int getRestaurantCount() {
        return restaurantCount;
    }

    public void setRestaurantCount(int restaurantCount) {
        this.restaurantCount = restaurantCount;
    }

    public int getLikeCount() {
        return likeCount;
    }

    public void setLikeCount(int likeCount) {
        this.likeCount = likeCount;
    }
}