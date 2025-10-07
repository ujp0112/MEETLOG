package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

/**
 * 예약 설정 모델 클래스
 */
public class ReservationSettings {
    private int id;
    private int restaurantId;
    private boolean reservationEnabled; // 예약 기능 활성화 여부
    private boolean autoAccept; // 자동 승인 여부
    private int minPartySize; // 최소 인원수
    private int maxPartySize; // 최대 인원수
    private int advanceBookingDays; // 최대 예약 가능 일수
    private int minAdvanceHours; // 최소 예약 시간 (몇 시간 전까지)
    private LocalTime reservationStartTime; // 예약 시작 시간
    private LocalTime reservationEndTime; // 예약 종료 시간
    private List<String> availableDays; // 예약 가능 요일
    private List<String> timeSlots; // 예약 가능 시간대
    private List<String> blackoutDates; // 예약 불가 날짜
    private String blackoutDatesJson; // 예약 불가 날짜 (JSON 형태)
    private String specialNotes; // 특별 안내사항
    private boolean depositRequired;
    private BigDecimal depositAmount;
    private String depositDescription;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // 요일별 설정 필드
    private boolean mondayEnabled;
    private LocalTime mondayStart;
    private LocalTime mondayEnd;
    private boolean tuesdayEnabled;
    private LocalTime tuesdayStart;
    private LocalTime tuesdayEnd;
    private boolean wednesdayEnabled;
    private LocalTime wednesdayStart;
    private LocalTime wednesdayEnd;
    private boolean thursdayEnabled;
    private LocalTime thursdayStart;
    private LocalTime thursdayEnd;
    private boolean fridayEnabled;
    private LocalTime fridayStart;
    private LocalTime fridayEnd;
    private boolean saturdayEnabled;
    private LocalTime saturdayStart;
    private LocalTime saturdayEnd;
    private boolean sundayEnabled;
    private LocalTime sundayStart;
    private LocalTime sundayEnd;

    // 기본 생성자
    public ReservationSettings() {
        // 기본값 설정
        this.reservationEnabled = true;
        this.autoAccept = false;
        this.minPartySize = 1;
        this.maxPartySize = 10;
        this.advanceBookingDays = 30;
        this.minAdvanceHours = 2;
        this.reservationStartTime = LocalTime.of(9, 0);
        this.reservationEndTime = LocalTime.of(22, 0);
        this.depositRequired = false;
        this.depositAmount = BigDecimal.ZERO;
    }

    public ReservationSettings(int restaurantId) {
        this();
        this.restaurantId = restaurantId;
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

    public boolean isReservationEnabled() {
        return reservationEnabled;
    }

    public void setReservationEnabled(boolean reservationEnabled) {
        this.reservationEnabled = reservationEnabled;
    }

    public int getMinPartySize() {
        return minPartySize;
    }

    public void setMinPartySize(int minPartySize) {
        this.minPartySize = minPartySize;
    }

    public int getAdvanceBookingDays() {
        return advanceBookingDays;
    }

    public void setAdvanceBookingDays(int advanceBookingDays) {
        this.advanceBookingDays = advanceBookingDays;
    }

    public int getMinAdvanceHours() {
        return minAdvanceHours;
    }

    public void setMinAdvanceHours(int minAdvanceHours) {
        this.minAdvanceHours = minAdvanceHours;
    }

    public int getMaxPartySize() {
        return maxPartySize;
    }

    public void setMaxPartySize(int maxPartySize) {
        this.maxPartySize = maxPartySize;
    }

    public LocalTime getReservationStartTime() {
        return reservationStartTime;
    }

    public void setReservationStartTime(LocalTime reservationStartTime) {
        this.reservationStartTime = reservationStartTime;
    }

    public LocalTime getReservationEndTime() {
        return reservationEndTime;
    }

    public void setReservationEndTime(LocalTime reservationEndTime) {
        this.reservationEndTime = reservationEndTime;
    }

    public List<String> getAvailableDays() {
        return availableDays;
    }

    public void setAvailableDays(List<String> availableDays) {
        this.availableDays = availableDays;
    }

    public List<String> getTimeSlots() {
        return timeSlots;
    }

    public void setTimeSlots(List<String> timeSlots) {
        this.timeSlots = timeSlots;
    }

    public List<String> getBlackoutDates() {
        return blackoutDates;
    }

    public void setBlackoutDates(List<String> blackoutDates) {
        this.blackoutDates = blackoutDates;
    }

    public String getSpecialNotes() {
        return specialNotes;
    }

    public void setSpecialNotes(String specialNotes) {
        this.specialNotes = specialNotes;
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
        } else {
            this.depositAmount = BigDecimal.ZERO;
        }
    }

    public String getDepositDescription() {
        return depositDescription;
    }

    public void setDepositDescription(String depositDescription) {
        this.depositDescription = depositDescription;
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

    // 요일별 설정 Getters and Setters
    public boolean isMondayEnabled() { return mondayEnabled; }
    public void setMondayEnabled(boolean mondayEnabled) { this.mondayEnabled = mondayEnabled; }
    public LocalTime getMondayStart() { return mondayStart; }
    public void setMondayStart(LocalTime mondayStart) { this.mondayStart = mondayStart; }
    public LocalTime getMondayEnd() { return mondayEnd; }
    public void setMondayEnd(LocalTime mondayEnd) { this.mondayEnd = mondayEnd; }

    public boolean isTuesdayEnabled() { return tuesdayEnabled; }
    public void setTuesdayEnabled(boolean tuesdayEnabled) { this.tuesdayEnabled = tuesdayEnabled; }
    public LocalTime getTuesdayStart() { return tuesdayStart; }
    public void setTuesdayStart(LocalTime tuesdayStart) { this.tuesdayStart = tuesdayStart; }
    public LocalTime getTuesdayEnd() { return tuesdayEnd; }
    public void setTuesdayEnd(LocalTime tuesdayEnd) { this.tuesdayEnd = tuesdayEnd; }

    public boolean isWednesdayEnabled() { return wednesdayEnabled; }
    public void setWednesdayEnabled(boolean wednesdayEnabled) { this.wednesdayEnabled = wednesdayEnabled; }
    public LocalTime getWednesdayStart() { return wednesdayStart; }
    public void setWednesdayStart(LocalTime wednesdayStart) { this.wednesdayStart = wednesdayStart; }
    public LocalTime getWednesdayEnd() { return wednesdayEnd; }
    public void setWednesdayEnd(LocalTime wednesdayEnd) { this.wednesdayEnd = wednesdayEnd; }

    public boolean isThursdayEnabled() { return thursdayEnabled; }
    public void setThursdayEnabled(boolean thursdayEnabled) { this.thursdayEnabled = thursdayEnabled; }
    public LocalTime getThursdayStart() { return thursdayStart; }
    public void setThursdayStart(LocalTime thursdayStart) { this.thursdayStart = thursdayStart; }
    public LocalTime getThursdayEnd() { return thursdayEnd; }
    public void setThursdayEnd(LocalTime thursdayEnd) { this.thursdayEnd = thursdayEnd; }

    public boolean isFridayEnabled() { return fridayEnabled; }
    public void setFridayEnabled(boolean fridayEnabled) { this.fridayEnabled = fridayEnabled; }
    public LocalTime getFridayStart() { return fridayStart; }
    public void setFridayStart(LocalTime fridayStart) { this.fridayStart = fridayStart; }
    public LocalTime getFridayEnd() { return fridayEnd; }
    public void setFridayEnd(LocalTime fridayEnd) { this.fridayEnd = fridayEnd; }

    public boolean isSaturdayEnabled() { return saturdayEnabled; }
    public void setSaturdayEnabled(boolean saturdayEnabled) { this.saturdayEnabled = saturdayEnabled; }
    public LocalTime getSaturdayStart() { return saturdayStart; }
    public void setSaturdayStart(LocalTime saturdayStart) { this.saturdayStart = saturdayStart; }
    public LocalTime getSaturdayEnd() { return saturdayEnd; }
    public void setSaturdayEnd(LocalTime saturdayEnd) { this.saturdayEnd = saturdayEnd; }

    public boolean isSundayEnabled() { return sundayEnabled; }
    public void setSundayEnabled(boolean sundayEnabled) { this.sundayEnabled = sundayEnabled; }
    public LocalTime getSundayStart() { return sundayStart; }
    public void setSundayStart(LocalTime sundayStart) { this.sundayStart = sundayStart; }
    public LocalTime getSundayEnd() { return sundayEnd; }
    public void setSundayEnd(LocalTime sundayEnd) { this.sundayEnd = sundayEnd; }

    public String getBlackoutDatesJson() { return blackoutDatesJson; }
    public void setBlackoutDatesJson(String blackoutDatesJson) { this.blackoutDatesJson = blackoutDatesJson; }
}
