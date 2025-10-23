package com.meetlog.repository;

import com.meetlog.dto.review.ReviewDto;
import com.meetlog.dto.review.ReviewSearchRequest;
import com.meetlog.model.Review;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Optional;

@Mapper
public interface ReviewRepository {

    /**
     * 리뷰 조회 (엔티티)
     */
    Optional<Review> findById(@Param("id") Long id);

    /**
     * 리뷰 조회 (DTO)
     */
    Optional<ReviewDto> findDtoById(@Param("id") Long id);

    /**
     * 리뷰 검색
     */
    List<ReviewDto> search(ReviewSearchRequest request);

    /**
     * 검색 결과 개수
     */
    int countSearch(ReviewSearchRequest request);

    /**
     * 레스토랑별 리뷰 목록
     */
    List<ReviewDto> findByRestaurantId(@Param("restaurantId") Long restaurantId,
                                        @Param("offset") Integer offset,
                                        @Param("limit") Integer limit);

    /**
     * 사용자별 리뷰 목록
     */
    List<ReviewDto> findByUserId(@Param("userId") Long userId,
                                  @Param("offset") Integer offset,
                                  @Param("limit") Integer limit);

    /**
     * 리뷰 생성
     */
    void insert(Review review);

    /**
     * 리뷰 수정
     */
    void update(Review review);

    /**
     * 리뷰 삭제
     */
    void delete(@Param("id") Long id);

    /**
     * 리뷰 활성 상태 변경
     */
    void updateIsActive(@Param("id") Long id, @Param("isActive") Boolean isActive);

    /**
     * 좋아요 수 증가
     */
    void incrementLikes(@Param("id") Long id);

    /**
     * 좋아요 수 감소
     */
    void decrementLikes(@Param("id") Long id);

    /**
     * 사업자 답글 등록/수정
     */
    void updateReply(@Param("id") Long id, @Param("replyContent") String replyContent);

    /**
     * 사용자가 해당 레스토랑에 리뷰를 작성했는지 확인
     */
    boolean existsByUserIdAndRestaurantId(@Param("userId") Long userId,
                                            @Param("restaurantId") Long restaurantId);
}
