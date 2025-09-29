package model;

import java.time.LocalDateTime;
import java.util.Date;
import java.sql.Timestamp;

public class BusinessQnA {
    private int id;
    private int restaurantId;
    private String restaurantName;
    private int userId;
    private String userName;
    private String userEmail;
    private String question;
    private String answer;
    private String status; // PENDING, ANSWERED, CLOSED
    private boolean isOwner;
    private boolean isResolved; // 해결 완료 여부
    private boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime answeredAt;
    private LocalDateTime updatedAt;
    
    public BusinessQnA() {
        // Default constructor
    }
    
    public BusinessQnA(int restaurantId, int userId, String question) {
        this.restaurantId = restaurantId;
        this.userId = userId;
        this.question = question;
        this.status = "PENDING";
        this.isActive = true;
    }
    
    // Getters and Setters
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
    
    public String getRestaurantName() {
        return restaurantName;
    }
    
    public void setRestaurantName(String restaurantName) {
        this.restaurantName = restaurantName;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getUserName() {
        return userName;
    }
    
    public void setUserName(String userName) {
        this.userName = userName;
    }
    
    public String getUserEmail() {
        return userEmail;
    }
    
    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }
    
    public String getQuestion() {
        return question;
    }
    
    public void setQuestion(String question) {
        this.question = question;
    }
    
    public String getAnswer() {
        return answer;
    }
    
    public void setAnswer(String answer) {
        this.answer = answer;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public boolean isOwner() {
        return isOwner;
    }
    
    public void setOwner(boolean owner) {
        isOwner = owner;
    }
    
    public void setIsOwner(boolean isOwner) {
        this.isOwner = isOwner;
    }
    
    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public void setActive(boolean active) {
        isActive = active;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDateTime getAnsweredAt() {
        return answeredAt;
    }
    
    public void setAnsweredAt(LocalDateTime answeredAt) {
        this.answeredAt = answeredAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public boolean isResolved() {
        return isResolved;
    }

    public boolean getIsResolved() {
        return isResolved;
    }

    public void setResolved(boolean resolved) {
        isResolved = resolved;
    }

    public void setIsResolved(boolean resolved) {
        this.isResolved = resolved;
    }

    public Date getCreatedAtAsDate() {
        if (this.createdAt != null) {
            return Timestamp.valueOf(this.createdAt);
        }
        return null;
    }

    public Date getAnsweredAtAsDate() {
        if (this.answeredAt != null) {
            return Timestamp.valueOf(this.answeredAt);
        }
        return null;
    }
}
