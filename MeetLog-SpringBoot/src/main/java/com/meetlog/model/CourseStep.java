package com.meetlog.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * CourseStep 엔티티
 * 데이터베이스 course_steps 테이블과 매핑
 * 코스의 각 단계(장소)를 나타냄
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CourseStep {
    private Long stepId;
    private Long courseId;
    private Integer stepOrder;
    private String stepType;
    private String emoji;
    private String name;
    private BigDecimal latitude;
    private BigDecimal longitude;
    private String address;
    private String description;
    private String image;
    private Integer time; // 소요 시간 (분)
    private Integer cost; // 예상 비용 (원)

    // Helper methods
    public boolean hasLocation() {
        return latitude != null && longitude != null;
    }

    public boolean hasAddress() {
        return address != null && !address.isBlank();
    }

    public boolean hasImage() {
        return image != null && !image.isBlank();
    }

    public boolean isFree() {
        return cost == null || cost == 0;
    }

    public boolean hasTime() {
        return time != null && time > 0;
    }

    public String getTimeText() {
        if (time == null || time == 0) return "";
        if (time < 60) return time + "분";
        int hours = time / 60;
        int minutes = time % 60;
        if (minutes == 0) return hours + "시간";
        return hours + "시간 " + minutes + "분";
    }

    public String getCostText() {
        if (cost == null || cost == 0) return "무료";
        if (cost >= 10000) {
            return String.format("%,d만원", cost / 10000);
        }
        return String.format("%,d원", cost);
    }

    public boolean isValid() {
        return name != null && !name.isBlank() && hasLocation();
    }
}
