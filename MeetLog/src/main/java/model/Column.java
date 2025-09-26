package model;

import java.sql.Timestamp;
import java.util.List;

public class Column {
    private int id;
    private int userId;
    private String author;
    private String profileImage;
    private String title;
    private String content;
    private String image;
    private List<String> tags;
    private int likes;
    private int views;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private boolean isActive;
    
    // 두 버전의 필드를 모두 포함하여 병합
    private transient String summary; // JSP 뷰에서 요약문을 담기 위한 임시 필드
    private User user;                // 작성자 정보를 담기 위한 객체 필드

    public Column() {
    }

    public Column(int userId, String author, String title, String content) {
        this.userId = userId;
        this.author = author;
        this.title = title;
        this.content = content;
    }

    // --- 모든 Getters and Setters ---

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

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public List<String> getTags() {
        return tags;
    }

    public void setTags(List<String> tags) {
        this.tags = tags;
    }

    public int getLikes() {
        return likes;
    }

    public void setLikes(int likes) {
        this.likes = likes;
    }

    // JSP 호환성을 위한 별칭 메서드
    public int getLikeCount() {
        return likes;
    }

    public void setLikeCount(int likeCount) {
        this.likes = likeCount;
    }

    public int getViews() {
        return views;
    }

    public void setViews(int views) {
        this.views = views;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}