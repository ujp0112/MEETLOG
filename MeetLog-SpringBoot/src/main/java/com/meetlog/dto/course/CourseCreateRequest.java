package com.meetlog.dto.course;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.Valid;
import javax.validation.constraints.*;
import java.math.BigDecimal;
import java.util.List;

/**
 * 코스 생성 요청 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CourseCreateRequest {
    @NotBlank(message = "제목은 필수입니다")
    @Size(max = 255, message = "제목은 255자를 초과할 수 없습니다")
    private String title;

    @Size(max = 2000, message = "설명은 2000자를 초과할 수 없습니다")
    private String description;

    @Size(max = 100, message = "지역은 100자를 초과할 수 없습니다")
    private String area;

    @Size(max = 100, message = "소요 시간은 100자를 초과할 수 없습니다")
    private String duration;

    @Min(value = 0, message = "가격은 0 이상이어야 합니다")
    private Integer price;

    @Min(value = 0, message = "최대 참가자 수는 0 이상이어야 합니다")
    private Integer maxParticipants;

    @NotNull(message = "타입은 필수입니다")
    @Pattern(regexp = "OFFICIAL|COMMUNITY", message = "타입은 OFFICIAL 또는 COMMUNITY여야 합니다")
    private String type;

    private String previewImage;

    @NotEmpty(message = "최소 1개 이상의 단계가 필요합니다")
    @Valid
    private List<CourseStepCreateRequest> steps;

    private List<String> tags;

    /**
     * 코스 단계 생성 요청
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class CourseStepCreateRequest {
        @NotNull(message = "단계 순서는 필수입니다")
        @Min(value = 0, message = "단계 순서는 0 이상이어야 합니다")
        private Integer stepOrder;

        private String stepType;

        @Size(max = 10, message = "이모지는 10자를 초과할 수 없습니다")
        private String emoji;

        @NotBlank(message = "장소명은 필수입니다")
        @Size(max = 255, message = "장소명은 255자를 초과할 수 없습니다")
        private String name;

        @NotNull(message = "위도는 필수입니다")
        @DecimalMin(value = "-90.0", message = "위도는 -90 이상이어야 합니다")
        @DecimalMax(value = "90.0", message = "위도는 90 이하여야 합니다")
        private BigDecimal latitude;

        @NotNull(message = "경도는 필수입니다")
        @DecimalMin(value = "-180.0", message = "경도는 -180 이상이어야 합니다")
        @DecimalMax(value = "180.0", message = "경도는 180 이하여야 합니다")
        private BigDecimal longitude;

        @Size(max = 500, message = "주소는 500자를 초과할 수 없습니다")
        private String address;

        @Size(max = 2000, message = "설명은 2000자를 초과할 수 없습니다")
        private String description;

        private String image;

        @Min(value = 0, message = "소요 시간은 0 이상이어야 합니다")
        private Integer time;

        @Min(value = 0, message = "비용은 0 이상이어야 합니다")
        private Integer cost;
    }
}
