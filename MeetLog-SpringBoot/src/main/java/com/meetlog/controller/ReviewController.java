package com.meetlog.controller;

import com.meetlog.dto.review.*;
import com.meetlog.security.CustomUserDetails;
import com.meetlog.service.ReviewService;
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

@Tag(name = "Review", description = "리뷰 API")
@RestController
@RequestMapping("/api/reviews")
@RequiredArgsConstructor
public class ReviewController {

    private final ReviewService reviewService;

    @Operation(summary = "리뷰 검색", description = "레스토랑, 사용자, 평점 등으로 리뷰를 검색합니다.")
    @GetMapping
    public ResponseEntity<Map<String, Object>> searchReviews(
            @RequestParam(required = false) Long restaurantId,
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) Integer minRating,
            @RequestParam(required = false) Integer maxRating,
            @RequestParam(required = false) String source,
            @RequestParam(required = false) Boolean isActive,
            @RequestParam(required = false, defaultValue = "created_at") String sortBy,
            @RequestParam(required = false, defaultValue = "desc") String sortOrder,
            @RequestParam(required = false, defaultValue = "1") Integer page,
            @RequestParam(required = false, defaultValue = "10") Integer size
    ) {
        ReviewSearchRequest request = ReviewSearchRequest.builder()
                .restaurantId(restaurantId)
                .userId(userId)
                .minRating(minRating)
                .maxRating(maxRating)
                .source(source)
                .isActive(isActive)
                .sortBy(sortBy)
                .sortOrder(sortOrder)
                .page(page)
                .size(size)
                .build();

        Map<String, Object> result = reviewService.searchReviews(request);
        return ResponseEntity.ok(result);
    }

    @Operation(summary = "리뷰 상세 조회", description = "리뷰 ID로 상세 정보를 조회합니다.")
    @GetMapping("/{id}")
    public ResponseEntity<ReviewDto> getReview(@PathVariable Long id) {
        ReviewDto review = reviewService.getReview(id);
        return ResponseEntity.ok(review);
    }

    @Operation(summary = "레스토랑별 리뷰 목록", description = "특정 레스토랑의 리뷰 목록을 조회합니다.")
    @GetMapping("/restaurant/{restaurantId}")
    public ResponseEntity<List<ReviewDto>> getRestaurantReviews(
            @PathVariable Long restaurantId,
            @RequestParam(required = false, defaultValue = "1") Integer page,
            @RequestParam(required = false, defaultValue = "10") Integer size
    ) {
        List<ReviewDto> reviews = reviewService.getRestaurantReviews(restaurantId, page, size);
        return ResponseEntity.ok(reviews);
    }

    @Operation(summary = "내 리뷰 목록", description = "현재 로그인한 사용자의 리뷰 목록을 조회합니다.")
    @GetMapping("/my")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<List<ReviewDto>> getMyReviews(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @RequestParam(required = false, defaultValue = "1") Integer page,
            @RequestParam(required = false, defaultValue = "10") Integer size
    ) {
        List<ReviewDto> reviews = reviewService.getUserReviews(userDetails.getUserId(), page, size);
        return ResponseEntity.ok(reviews);
    }

    @Operation(summary = "리뷰 작성", description = "새 리뷰를 작성합니다.")
    @PostMapping
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<ReviewDto> createReview(
            @Valid @RequestBody ReviewCreateRequest request,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        ReviewDto review = reviewService.createReview(request, userDetails.getUserId());
        return ResponseEntity.ok(review);
    }

    @Operation(summary = "리뷰 수정", description = "리뷰를 수정합니다. (작성자만 가능)")
    @PutMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<ReviewDto> updateReview(
            @PathVariable Long id,
            @Valid @RequestBody ReviewUpdateRequest request,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        ReviewDto review = reviewService.updateReview(id, request, userDetails.getUserId());
        return ResponseEntity.ok(review);
    }

    @Operation(summary = "리뷰 삭제", description = "리뷰를 삭제합니다. (작성자만 가능)")
    @DeleteMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Void> deleteReview(
            @PathVariable Long id,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        reviewService.deleteReview(id, userDetails.getUserId());
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "리뷰 좋아요", description = "리뷰에 좋아요를 누릅니다.")
    @PostMapping("/{id}/like")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Void> likeReview(@PathVariable Long id) {
        reviewService.likeReview(id);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "리뷰 좋아요 취소", description = "리뷰 좋아요를 취소합니다.")
    @DeleteMapping("/{id}/like")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Void> unlikeReview(@PathVariable Long id) {
        reviewService.unlikeReview(id);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "사업자 답글 등록/수정", description = "리뷰에 사업자 답글을 등록하거나 수정합니다. (레스토랑 소유자만 가능)")
    @PostMapping("/{id}/reply")
    @PreAuthorize("hasAnyRole('BUSINESS', 'ADMIN')")
    public ResponseEntity<ReviewDto> addReply(
            @PathVariable Long id,
            @RequestParam String replyContent,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        ReviewDto review = reviewService.addReply(id, replyContent, userDetails.getUserId());
        return ResponseEntity.ok(review);
    }
}
