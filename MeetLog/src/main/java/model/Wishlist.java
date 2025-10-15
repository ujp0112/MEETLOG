package model;

import java.time.LocalDateTime;

/**
 * 찜 목록을 나타내는 모델 클래스
 */
public class Wishlist {
    private int id;
    private int userId;
    private int restaurantId;
    private LocalDateTime createdAt;

    public Wishlist() {
    }

    public Wishlist(int userId, int restaurantId) {
        this.userId = userId;
        this.restaurantId = restaurantId;
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

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
