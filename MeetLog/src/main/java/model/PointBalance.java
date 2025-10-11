package model;

import java.time.LocalDateTime;

/**
 * 사용자 포인트 잔액 모델
 */
public class PointBalance {
    private int userId;
    private int balance;
    private LocalDateTime updatedAt;

    // 기본 생성자
    public PointBalance() {}

    // 전체 생성자
    public PointBalance(int userId, int balance, LocalDateTime updatedAt) {
        this.userId = userId;
        this.balance = balance;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getBalance() {
        return balance;
    }

    public void setBalance(int balance) {
        this.balance = balance;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "PointBalance{" +
                "userId=" + userId +
                ", balance=" + balance +
                ", updatedAt=" + updatedAt +
                '}';
    }
}
