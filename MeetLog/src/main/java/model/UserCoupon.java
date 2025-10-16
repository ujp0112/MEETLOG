package model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * 사용자가 받은 쿠폰 정보 모델
 */
public class UserCoupon {
    private int id;
    private int userId;
    private int couponId;
    private LocalDateTime receivedAt;
    private LocalDateTime usedAt;
    private boolean isUsed;

    // 조인된 쿠폰 정보
    private String title;
    private String description;
    private String validity;
    private String restaurantName;

    // 기본 생성자
    public UserCoupon() {}

    // 전체 생성자
    public UserCoupon(int id, int userId, int couponId, LocalDateTime receivedAt,
                     LocalDateTime usedAt, boolean isUsed, String title,
                     String description, String validity, String restaurantName) {
        this.id = id;
        this.userId = userId;
        this.couponId = couponId;
        this.receivedAt = receivedAt;
        this.usedAt = usedAt;
        this.isUsed = isUsed;
        this.title = title;
        this.description = description;
        this.validity = validity;
        this.restaurantName = restaurantName;
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

    public int getCouponId() {
        return couponId;
    }

    public void setCouponId(int couponId) {
        this.couponId = couponId;
    }

    public LocalDateTime getReceivedAt() {
        return receivedAt;
    }

    public void setReceivedAt(LocalDateTime receivedAt) {
        this.receivedAt = receivedAt;
    }

    public LocalDateTime getUsedAt() {
        return usedAt;
    }

    public void setUsedAt(LocalDateTime usedAt) {
        this.usedAt = usedAt;
    }

    public boolean isUsed() {
        return isUsed;
    }

    public void setUsed(boolean isUsed) {
        this.isUsed = isUsed;
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

    public String getValidity() {
        return validity;
    }

    public void setValidity(String validity) {
        this.validity = validity;
    }

    public String getRestaurantName() {
        return restaurantName;
    }

    public void setRestaurantName(String restaurantName) {
        this.restaurantName = restaurantName;
    }

    /**
     * 받은 날짜를 포맷된 문자열로 반환 (yyyy-MM-dd)
     */
    public String getFormattedReceivedAt() {
        if (receivedAt == null) {
            return "";
        }
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        return receivedAt.format(formatter);
    }

    /**
     * 사용 날짜를 포맷된 문자열로 반환 (yyyy-MM-dd)
     */
    public String getFormattedUsedAt() {
        if (usedAt == null) {
            return "";
        }
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        return usedAt.format(formatter);
    }
}