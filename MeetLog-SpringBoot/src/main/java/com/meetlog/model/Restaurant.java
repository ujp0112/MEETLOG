package com.meetlog.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Restaurant {
    private Long restaurantId;
    private Long ownerId;
    private String name;
    private String category;
    private String description;
    private String address;
    private String addressDetail;
    private Double latitude;
    private Double longitude;
    private String phone;
    private String operatingHours;
    private Integer priceRange;
    private String imageUrl;
    private String menuInfo;
    private String facilities;
    private String parkingInfo;
    private Integer capacity;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Helper methods
    public boolean isActive() {
        return "ACTIVE".equals(this.status);
    }

    public boolean isOwnedBy(Long userId) {
        return this.ownerId != null && this.ownerId.equals(userId);
    }

    public String getPriceRangeText() {
        if (priceRange == null) return "미정";
        switch (priceRange) {
            case 1: return "1만원 이하";
            case 2: return "1-2만원";
            case 3: return "2-3만원";
            case 4: return "3만원 이상";
            default: return "미정";
        }
    }
}
