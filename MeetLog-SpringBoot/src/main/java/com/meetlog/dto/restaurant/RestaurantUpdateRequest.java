package com.meetlog.dto.restaurant;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RestaurantUpdateRequest {
    @Size(min = 2, max = 100, message = "레스토랑 이름은 2-100자 이내여야 합니다.")
    private String name;

    private String category;

    @Size(max = 1000, message = "설명은 1000자 이내여야 합니다.")
    private String description;

    private String address;

    private String addressDetail;

    private Double latitude;

    private Double longitude;

    @Pattern(regexp = "^\\d{2,3}-\\d{3,4}-\\d{4}$", message = "올바른 전화번호 형식이 아닙니다.")
    private String phone;

    private String operatingHours;

    @Min(value = 1, message = "가격대는 1-4 사이여야 합니다.")
    @Max(value = 4, message = "가격대는 1-4 사이여야 합니다.")
    private Integer priceRange;

    private String imageUrl;

    private String menuInfo;

    private String facilities;

    private String parkingInfo;

    @Min(value = 1, message = "수용 인원은 최소 1명 이상이어야 합니다.")
    private Integer capacity;

    private String status;
}
