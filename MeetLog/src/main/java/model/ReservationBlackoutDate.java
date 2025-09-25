package model;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 예약 불가 날짜 모델 클래스
 */
public class ReservationBlackoutDate {
    private int id;
    private int restaurantId;
    private LocalDate blackoutDate;
    private String reason;
    private boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // 조인용 필드
    private String restaurantName;

    public ReservationBlackoutDate() {
        this.isActive = true;
    }

    public ReservationBlackoutDate(int restaurantId, LocalDate blackoutDate, String reason) {
        this();
        this.restaurantId = restaurantId;
        this.blackoutDate = blackoutDate;
        this.reason = reason;
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

    public LocalDate getBlackoutDate() {
        return blackoutDate;
    }

    public void setBlackoutDate(LocalDate blackoutDate) {
        // 과거 날짜는 설정할 수 없도록 검증
        if (blackoutDate != null && !blackoutDate.isBefore(LocalDate.now())) {
            this.blackoutDate = blackoutDate;
        }
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
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

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getRestaurantName() {
        return restaurantName;
    }

    public void setRestaurantName(String restaurantName) {
        this.restaurantName = restaurantName;
    }

    /**
     * 유효한 블랙아웃 날짜인지 검증
     */
    public boolean isValidBlackoutDate() {
        return blackoutDate != null && !blackoutDate.isBefore(LocalDate.now());
    }

    /**
     * 과거 날짜인지 확인
     */
    public boolean isPastDate() {
        return blackoutDate != null && blackoutDate.isBefore(LocalDate.now());
    }

    /**
     * 오늘 날짜인지 확인
     */
    public boolean isToday() {
        return blackoutDate != null && blackoutDate.equals(LocalDate.now());
    }

    /**
     * 미래 날짜인지 확인
     */
    public boolean isFutureDate() {
        return blackoutDate != null && blackoutDate.isAfter(LocalDate.now());
    }

    @Override
    public String toString() {
        return "ReservationBlackoutDate{" +
                "id=" + id +
                ", restaurantId=" + restaurantId +
                ", blackoutDate=" + blackoutDate +
                ", reason='" + reason + '\'' +
                ", isActive=" + isActive +
                '}';
    }
}