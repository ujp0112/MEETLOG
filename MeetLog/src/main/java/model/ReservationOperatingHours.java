package model;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.time.LocalDateTime;

/**
 * 예약 운영시간 모델 클래스
 */
public class ReservationOperatingHours {
    private int id;
    private int settingsId;
    private DayOfWeek dayOfWeek;
    private boolean isEnabled;
    private LocalTime startTime;
    private LocalTime endTime;
    private LocalTime breakStartTime;
    private LocalTime breakEndTime;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public ReservationOperatingHours() {
        // 기본값 설정
        this.isEnabled = true;
        this.startTime = LocalTime.of(11, 0); // 오전 11시
        this.endTime = LocalTime.of(21, 0);   // 오후 9시
    }

    public ReservationOperatingHours(int settingsId, DayOfWeek dayOfWeek) {
        this();
        this.settingsId = settingsId;
        this.dayOfWeek = dayOfWeek;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getSettingsId() {
        return settingsId;
    }

    public void setSettingsId(int settingsId) {
        this.settingsId = settingsId;
    }

    public DayOfWeek getDayOfWeek() {
        return dayOfWeek;
    }

    public void setDayOfWeek(DayOfWeek dayOfWeek) {
        this.dayOfWeek = dayOfWeek;
    }

    public String getDayOfWeekString() {
        return dayOfWeek != null ? dayOfWeek.name() : null;
    }

    public void setDayOfWeekString(String dayOfWeekString) {
        if (dayOfWeekString != null && !dayOfWeekString.trim().isEmpty()) {
            try {
                this.dayOfWeek = DayOfWeek.valueOf(dayOfWeekString.toUpperCase());
            } catch (IllegalArgumentException e) {
                // 잘못된 요일명인 경우 기본값으로 월요일 설정
                this.dayOfWeek = DayOfWeek.MONDAY;
            }
        }
    }

    public boolean isEnabled() {
        return isEnabled;
    }

    public void setEnabled(boolean enabled) {
        isEnabled = enabled;
    }

    public LocalTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalTime startTime) {
        this.startTime = startTime;
    }

    public LocalTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalTime endTime) {
        // 종료시간이 시작시간보다 늦은지 검증
        if (this.startTime != null && endTime != null && endTime.isAfter(this.startTime)) {
            this.endTime = endTime;
        } else if (this.startTime == null) {
            this.endTime = endTime;
        }
    }

    public LocalTime getBreakStartTime() {
        return breakStartTime;
    }

    public void setBreakStartTime(LocalTime breakStartTime) {
        this.breakStartTime = breakStartTime;
    }

    public LocalTime getBreakEndTime() {
        return breakEndTime;
    }

    public void setBreakEndTime(LocalTime breakEndTime) {
        // 브레이크 종료시간이 시작시간보다 늦은지 검증
        if (this.breakStartTime != null && breakEndTime != null && breakEndTime.isAfter(this.breakStartTime)) {
            this.breakEndTime = breakEndTime;
        } else if (this.breakStartTime == null) {
            this.breakEndTime = breakEndTime;
        }
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

    /**
     * 브레이크 타임이 설정되어 있는지 확인
     */
    public boolean hasBreakTime() {
        return breakStartTime != null && breakEndTime != null;
    }

    /**
     * 유효한 운영시간인지 검증
     */
    public boolean isValidOperatingHours() {
        if (!isEnabled) {
            return true; // 비활성화된 경우 유효함
        }

        if (startTime == null || endTime == null) {
            return false;
        }

        if (!endTime.isAfter(startTime)) {
            return false;
        }

        // 브레이크 타임이 있는 경우 검증
        if (hasBreakTime()) {
            return breakEndTime.isAfter(breakStartTime) &&
                   breakStartTime.isAfter(startTime) &&
                   breakEndTime.isBefore(endTime);
        }

        return true;
    }

    /**
     * 요일을 한글로 반환
     */
    public String getDayOfWeekKorean() {
        if (dayOfWeek == null) return "";

        switch (dayOfWeek) {
            case MONDAY: return "월요일";
            case TUESDAY: return "화요일";
            case WEDNESDAY: return "수요일";
            case THURSDAY: return "목요일";
            case FRIDAY: return "금요일";
            case SATURDAY: return "토요일";
            case SUNDAY: return "일요일";
            default: return "";
        }
    }

    @Override
    public String toString() {
        return "ReservationOperatingHours{" +
                "id=" + id +
                ", settingsId=" + settingsId +
                ", dayOfWeek=" + dayOfWeek +
                ", isEnabled=" + isEnabled +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", breakStartTime=" + breakStartTime +
                ", breakEndTime=" + breakEndTime +
                '}';
    }
}