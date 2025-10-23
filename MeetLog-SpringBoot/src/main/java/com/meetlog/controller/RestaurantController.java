package com.meetlog.controller;

import com.meetlog.dto.restaurant.*;
import com.meetlog.security.CustomUserDetails;
import com.meetlog.service.RestaurantService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;
import java.util.Map;

@Tag(name = "Restaurant", description = "레스토랑 API")
@RestController
@RequestMapping("/api/restaurants")
@RequiredArgsConstructor
public class RestaurantController {

    private final RestaurantService restaurantService;

    @Operation(summary = "레스토랑 검색", description = "키워드, 카테고리, 지역 등으로 레스토랑을 검색합니다.")
    @GetMapping
    public ResponseEntity<Map<String, Object>> searchRestaurants(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String address,
            @RequestParam(required = false) Integer priceRange,
            @RequestParam(required = false) Integer minCapacity,
            @RequestParam(required = false, defaultValue = "name") String sortBy,
            @RequestParam(required = false, defaultValue = "asc") String sortOrder,
            @RequestParam(required = false, defaultValue = "1") Integer page,
            @RequestParam(required = false, defaultValue = "10") Integer size
    ) {
        RestaurantSearchRequest request = RestaurantSearchRequest.builder()
                .keyword(keyword)
                .category(category)
                .address(address)
                .priceRange(priceRange)
                .minCapacity(minCapacity)
                .sortBy(sortBy)
                .sortOrder(sortOrder)
                .page(page)
                .size(size)
                .build();

        Map<String, Object> result = restaurantService.searchRestaurants(request);
        return ResponseEntity.ok(result);
    }

    @Operation(summary = "레스토랑 상세 조회", description = "레스토랑 ID로 상세 정보를 조회합니다.")
    @GetMapping("/{restaurantId}")
    public ResponseEntity<RestaurantDto> getRestaurant(@PathVariable Long restaurantId) {
        RestaurantDto restaurant = restaurantService.getRestaurant(restaurantId);
        return ResponseEntity.ok(restaurant);
    }

    @Operation(summary = "내 레스토랑 목록", description = "현재 로그인한 사업자의 레스토랑 목록을 조회합니다.")
    @GetMapping("/my")
    @PreAuthorize("hasAnyRole('BUSINESS', 'ADMIN')")
    public ResponseEntity<List<RestaurantDto>> getMyRestaurants(
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        List<RestaurantDto> restaurants = restaurantService.getMyRestaurants(userDetails.getUserId());
        return ResponseEntity.ok(restaurants);
    }

    @Operation(summary = "레스토랑 등록", description = "새 레스토랑을 등록합니다. (사업자만 가능)")
    @PostMapping
    @PreAuthorize("hasAnyRole('BUSINESS', 'ADMIN')")
    public ResponseEntity<RestaurantDto> createRestaurant(
            @Valid @RequestBody RestaurantCreateRequest request,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        RestaurantDto restaurant = restaurantService.createRestaurant(request, userDetails.getUserId());
        return ResponseEntity.ok(restaurant);
    }

    @Operation(summary = "레스토랑 수정", description = "레스토랑 정보를 수정합니다. (소유자만 가능)")
    @PutMapping("/{restaurantId}")
    @PreAuthorize("hasAnyRole('BUSINESS', 'ADMIN')")
    public ResponseEntity<RestaurantDto> updateRestaurant(
            @PathVariable Long restaurantId,
            @Valid @RequestBody RestaurantUpdateRequest request,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        RestaurantDto restaurant = restaurantService.updateRestaurant(restaurantId, request, userDetails.getUserId());
        return ResponseEntity.ok(restaurant);
    }

    @Operation(summary = "레스토랑 삭제", description = "레스토랑을 삭제합니다. (소유자만 가능)")
    @DeleteMapping("/{restaurantId}")
    @PreAuthorize("hasAnyRole('BUSINESS', 'ADMIN')")
    public ResponseEntity<Void> deleteRestaurant(
            @PathVariable Long restaurantId,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        restaurantService.deleteRestaurant(restaurantId, userDetails.getUserId());
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "레스토랑 상태 변경", description = "레스토랑 상태를 변경합니다. (소유자만 가능)")
    @PatchMapping("/{restaurantId}/status")
    @PreAuthorize("hasAnyRole('BUSINESS', 'ADMIN')")
    public ResponseEntity<Void> updateStatus(
            @PathVariable Long restaurantId,
            @RequestParam String status,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        restaurantService.updateStatus(restaurantId, status, userDetails.getUserId());
        return ResponseEntity.noContent().build();
    }
}
