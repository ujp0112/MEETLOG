package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 예약 설정 모델 클래스 (새 버전)
 * 데이터베이스 구조에 맞게 재설계된 버전
 */
public class ReservationSettingsNew {
    private int id;
    private int restaurantId;
    private boolean autoAccept;
    private int maxAdvanceDays;
    private int minAdvanceHours;
    private int maxPartySize;
    private int timeSlotInterval;
    private String specialInstructions;
    private boolean depositRequired;
    private BigDecimal depositAmount;
    private boolean allowWaitingList;
    private int maxWaitingList;
    private boolean sendSmsConfirmation;
    private boolean penaltyForNoshow;
    private boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // 관련 데이터 (조인된 데이터)
    private List<ReservationOperatingHours> operatingHours;
    private List<ReservationBlackoutDate> blackoutDates;
    private String restaurantName; // 조인용

    public ReservationSettingsNew() {
        // 안전한 기본값 설정
        this.autoAccept = false;
        this.maxAdvanceDays = 30;
        this.minAdvanceHours = 2;
        this.maxPartySize = 8;
        this.timeSlotInterval = 30;
        this.depositRequired = false;
        this.depositAmount = BigDecimal.ZERO;
        this.allowWaitingList = false;
        this.maxWaitingList = 5;
        this.sendSmsConfirmation = true;
        this.penaltyForNoshow = false;
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

    public boolean isAutoAccept() {
        return autoAccept;
    }

    public void setAutoAccept(boolean autoAccept) {
        this.autoAccept = autoAccept;
    }

    public int getMaxAdvanceDays() {
        return maxAdvanceDays;
    }

    public void setMaxAdvanceDays(int maxAdvanceDays) {
        if (maxAdvanceDays > 0 && maxAdvanceDays <= 365) {
            this.maxAdvanceDays = maxAdvanceDays;
        }
    }

    public int getMinAdvanceHours() {
        return minAdvanceHours;
    }

    public void setMinAdvanceHours(int minAdvanceHours) {
        if (minAdvanceHours >= 0 && minAdvanceHours <= 168) {
            this.minAdvanceHours = minAdvanceHours;
        }
    }

    public int getMaxPartySize() {
        return maxPartySize;
    }

    public void setMaxPartySize(int maxPartySize) {
        if (maxPartySize > 0 && maxPartySize <= 50) {
            this.maxPartySize = maxPartySize;
        }
    }

    public int getTimeSlotInterval() {
        return timeSlotInterval;
    }

    public void setTimeSlotInterval(int timeSlotInterval) {
        // 15, 30, 60분만 허용
        if (timeSlotInterval == 15 || timeSlotInterval == 30 || timeSlotInterval == 60) {
            this.timeSlotInterval = timeSlotInterval;
        }
    }

    public String getSpecialInstructions() {
        return specialInstructions;
    }

    public void setSpecialInstructions(String specialInstructions) {
        this.specialInstructions = specialInstructions;
    }

    public boolean isDepositRequired() {
        return depositRequired;
    }

    public void setDepositRequired(boolean depositRequired) {
        this.depositRequired = depositRequired;
    }

    public BigDecimal getDepositAmount() {
        return depositAmount;
    }

    public void setDepositAmount(BigDecimal depositAmount) {
        if (depositAmount != null && depositAmount.compareTo(BigDecimal.ZERO) >= 0) {
            this.depositAmount = depositAmount;
        }
    }

    public boolean isAllowWaitingList() {
        return allowWaitingList;
    }

    public void setAllowWaitingList(boolean allowWaitingList) {
        this.allowWaitingList = allowWaitingList;
    }

    public int getMaxWaitingList() {
        return maxWaitingList;
    }

    public void setMaxWaitingList(int maxWaitingList) {
        if (maxWaitingList >= 0 && maxWaitingList <= 20) {
            this.maxWaitingList = maxWaitingList;
        }
    }

    public boolean isSendSmsConfirmation() {
        return sendSmsConfirmation;
    }

    public void setSendSmsConfirmation(boolean sendSmsConfirmation) {
        this.sendSmsConfirmation = sendSmsConfirmation;
    }

    public boolean isPenaltyForNoshow() {
        return penaltyForNoshow;
    }

    public void setPenaltyForNoshow(boolean penaltyForNoshow) {
        this.penaltyForNoshow = penaltyForNoshow;
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

    public List<ReservationOperatingHours> getOperatingHours() {
        return operatingHours;
    }

    public void setOperatingHours(List<ReservationOperatingHours> operatingHours) {
        this.operatingHours = operatingHours;
    }

    public List<ReservationBlackoutDate> getBlackoutDates() {
        return blackoutDates;
    }

    public void setBlackoutDates(List<ReservationBlackoutDate> blackoutDates) {
        this.blackoutDates = blackoutDates;
    }

    public String getRestaurantName() {
        return restaurantName;
    }

    public void setRestaurantName(String restaurantName) {
        this.restaurantName = restaurantName;
    }

    @Override
    public String toString() {
        return "ReservationSettingsNew{" +
                "id=" + id +
                ", restaurantId=" + restaurantId +
                ", autoAccept=" + autoAccept +
                ", maxAdvanceDays=" + maxAdvanceDays +
                ", minAdvanceHours=" + minAdvanceHours +
                ", maxPartySize=" + maxPartySize +
                ", timeSlotInterval=" + timeSlotInterval +
                ", isActive=" + isActive +
                '}';
    }
}