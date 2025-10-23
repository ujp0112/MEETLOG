package com.meetlog.service;

import com.meetlog.dto.review.*;
import com.meetlog.model.Review;
import com.meetlog.repository.ReviewRepository;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ReviewService {

    private final ReviewRepository reviewRepository;
    private final ObjectMapper objectMapper;

    /**
     * 리뷰 상세 조회
     */
    public ReviewDto getReview(Long id) {
        return reviewRepository.findDtoById(id)
                .orElseThrow(() -> new RuntimeException("Review not found"));
    }

    /**
     * 리뷰 검색
     */
    public Map<String, Object> searchReviews(ReviewSearchRequest request) {
        List<ReviewDto> reviews = reviewRepository.search(request);
        int total = reviewRepository.countSearch(request);

        Map<String, Object> result = new HashMap<>();
        result.put("reviews", reviews);
        result.put("total", total);
        result.put("page", request.getPage() != null ? request.getPage() : 1);
        result.put("size", request.getLimit());
        result.put("totalPages", (int) Math.ceil((double) total / request.getLimit()));

        return result;
    }

    /**
     * 레스토랑별 리뷰 목록
     */
    public List<ReviewDto> getRestaurantReviews(Long restaurantId, Integer page, Integer size) {
        int offset = (page - 1) * size;
        return reviewRepository.findByRestaurantId(restaurantId, offset, size);
    }

    /**
     * 사용자별 리뷰 목록
     */
    public List<ReviewDto> getUserReviews(Long userId, Integer page, Integer size) {
        int offset = (page - 1) * size;
        return reviewRepository.findByUserId(userId, offset, size);
    }

    /**
     * 리뷰 생성
     */
    @Transactional
    public ReviewDto createReview(ReviewCreateRequest request, Long userId) {
        // 중복 리뷰 체크
        if (reviewRepository.existsByUserIdAndRestaurantId(userId, request.getRestaurantId())) {
            throw new RuntimeException("You have already reviewed this restaurant");
        }

        Review review = Review.builder()
                .restaurantId(request.getRestaurantId())
                .userId(userId)
                .source("INTERNAL")
                .rating(request.getRating())
                .content(request.getContent())
                .images(convertListToJson(request.getImages()))
                .keywords(convertListToJson(request.getKeywords()))
                .likes(0)
                .isActive(true)
                .build();

        reviewRepository.insert(review);

        return reviewRepository.findDtoById(review.getId())
                .orElseThrow(() -> new RuntimeException("Failed to create review"));
    }

    /**
     * 리뷰 수정
     */
    @Transactional
    public ReviewDto updateReview(Long id, ReviewUpdateRequest request, Long userId) {
        Review review = reviewRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Review not found"));

        if (!review.isOwnedBy(userId)) {
            throw new RuntimeException("Unauthorized to update this review");
        }

        if (!review.isInternalReview()) {
            throw new RuntimeException("Cannot update external reviews");
        }

        if (request.getRating() != null) review.setRating(request.getRating());
        if (request.getContent() != null) review.setContent(request.getContent());
        if (request.getImages() != null) review.setImages(convertListToJson(request.getImages()));
        if (request.getKeywords() != null) review.setKeywords(convertListToJson(request.getKeywords()));

        reviewRepository.update(review);

        return reviewRepository.findDtoById(id)
                .orElseThrow(() -> new RuntimeException("Failed to update review"));
    }

    /**
     * 리뷰 삭제
     */
    @Transactional
    public void deleteReview(Long id, Long userId) {
        Review review = reviewRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Review not found"));

        if (!review.isOwnedBy(userId)) {
            throw new RuntimeException("Unauthorized to delete this review");
        }

        if (!review.isInternalReview()) {
            throw new RuntimeException("Cannot delete external reviews");
        }

        reviewRepository.delete(id);
    }

    /**
     * 리뷰 좋아요
     */
    @Transactional
    public void likeReview(Long id) {
        reviewRepository.incrementLikes(id);
    }

    /**
     * 리뷰 좋아요 취소
     */
    @Transactional
    public void unlikeReview(Long id) {
        reviewRepository.decrementLikes(id);
    }

    /**
     * 사업자 답글 등록/수정
     */
    @Transactional
    public ReviewDto addReply(Long id, String replyContent, Long userId) {
        Review review = reviewRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Review not found"));

        // 레스토랑 소유자 확인 필요 (추가 구현)
        reviewRepository.updateReply(id, replyContent);

        return reviewRepository.findDtoById(id)
                .orElseThrow(() -> new RuntimeException("Failed to add reply"));
    }

    /**
     * List를 JSON 문자열로 변환
     */
    private String convertListToJson(List<String> list) {
        if (list == null || list.isEmpty()) {
            return null;
        }
        try {
            return objectMapper.writeValueAsString(list);
        } catch (JsonProcessingException e) {
            throw new RuntimeException("Failed to convert list to JSON", e);
        }
    }
}
