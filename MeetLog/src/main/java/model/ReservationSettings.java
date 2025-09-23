package model;

import java.time.LocalTime;

/**
 * 예약 설정 모델 클래스
 */
public class ReservationSettings {
    private int settingsId;
    private int restaurantId;
    private boolean autoAccept; // 자동 승인 여부
    private int maxAdvanceDays; // 최대 예약 가능 일수
    private int minAdvanceHours; // 최소 예약 시간 (몇 시간 전까지)
    private int maxPartySize; // 최대 인원수
    private int timeSlotInterval; // 시간 간격 (분 단위)
    private String specialInstructions; // 특별 안내사항
    
    // 요일별 운영 설정
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

    public ReservationSettings() {
        // 기본값 설정
        this.autoAccept = false;
        this.maxAdvanceDays = 30;
        this.minAdvanceHours = 2;
        this.maxPartySize = 8;
        this.timeSlotInterval = 30;
        
        // 기본 운영시간 설정 (오전 11시 ~ 오후 9시)
        LocalTime defaultStart = LocalTime.of(11, 0);
        LocalTime defaultEnd = LocalTime.of(21, 0);
        
        this.mondayEnabled = true;
        this.mondayStart = defaultStart;
        this.mondayEnd = defaultEnd;
        
        this.tuesdayEnabled = true;
        this.tuesdayStart = defaultStart;
        this.tuesdayEnd = defaultEnd;
        
        this.wednesdayEnabled = true;
        this.wednesdayStart = defaultStart;
        this.wednesdayEnd = defaultEnd;
        
        this.thursdayEnabled = true;
        this.thursdayStart = defaultStart;
        this.thursdayEnd = defaultEnd;
        
        this.fridayEnabled = true;
        this.fridayStart = defaultStart;
        this.fridayEnd = defaultEnd;
        
        this.saturdayEnabled = true;
        this.saturdayStart = defaultStart;
        this.saturdayEnd = defaultEnd;
        
        this.sundayEnabled = true;
        this.sundayStart = defaultStart;
        this.sundayEnd = defaultEnd;
    }

    // Getters and Setters
    public int getSettingsId() {
        return settingsId;
    }

    public void setSettingsId(int settingsId) {
        this.settingsId = settingsId;
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
        this.maxAdvanceDays = maxAdvanceDays;
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

    public int getTimeSlotInterval() {
        return timeSlotInterval;
    }

    public void setTimeSlotInterval(int timeSlotInterval) {
        this.timeSlotInterval = timeSlotInterval;
    }

    public String getSpecialInstructions() {
        return specialInstructions;
    }

    public void setSpecialInstructions(String specialInstructions) {
        this.specialInstructions = specialInstructions;
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
}
