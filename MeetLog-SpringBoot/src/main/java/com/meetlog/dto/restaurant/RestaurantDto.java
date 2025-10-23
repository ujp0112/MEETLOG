package com.meetlog.dto.restaurant;

import com.meetlog.model.Restaurant;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RestaurantDto {
    private Long restaurantId;
    private Long ownerId;
    private String ownerName;
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
    private String priceRangeText;
    private String imageUrl;
    private String menuInfo;
    private String facilities;
    private String parkingInfo;
    private Integer capacity;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private Double averageRating;
    private Integer reviewCount;

    public static RestaurantDto from(Restaurant restaurant) {
        return RestaurantDto.builder()
                .restaurantId(restaurant.getRestaurantId())
                .ownerId(restaurant.getOwnerId())
                .name(restaurant.getName())
                .category(restaurant.getCategory())
                .description(restaurant.getDescription())
                .address(restaurant.getAddress())
                .addressDetail(restaurant.getAddressDetail())
                .latitude(restaurant.getLatitude())
                .longitude(restaurant.getLongitude())
                .phone(restaurant.getPhone())
                .operatingHours(restaurant.getOperatingHours())
                .priceRange(restaurant.getPriceRange())
                .priceRangeText(restaurant.getPriceRangeText())
                .imageUrl(restaurant.getImageUrl())
                .menuInfo(restaurant.getMenuInfo())
                .facilities(restaurant.getFacilities())
                .parkingInfo(restaurant.getParkingInfo())
                .capacity(restaurant.getCapacity())
                .status(restaurant.getStatus())
                .createdAt(restaurant.getCreatedAt())
                .updatedAt(restaurant.getUpdatedAt())
                .build();
    }
}
