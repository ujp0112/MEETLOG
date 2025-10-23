package com.meetlog.repository;

import com.meetlog.dto.reservation.ReservationDto;
import com.meetlog.dto.reservation.ReservationSearchRequest;
import com.meetlog.model.Reservation;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Mapper
public interface ReservationRepository {

    /**
     * 예약 조회 (엔티티)
     */
    Optional<Reservation> findById(@Param("id") Long id);

    /**
     * 예약 조회 (DTO)
     */
    Optional<ReservationDto> findDtoById(@Param("id") Long id);

    /**
     * 예약 검색
     */
    List<ReservationDto> search(ReservationSearchRequest request);

    /**
     * 검색 결과 개수
     */
    int countSearch(ReservationSearchRequest request);

    /**
     * 레스토랑별 예약 목록
     */
    List<ReservationDto> findByRestaurantId(@Param("restaurantId") Long restaurantId,
                                             @Param("offset") Integer offset,
                                             @Param("limit") Integer limit);

    /**
     * 사용자별 예약 목록
     */
    List<ReservationDto> findByUserId(@Param("userId") Long userId,
                                       @Param("offset") Integer offset,
                                       @Param("limit") Integer limit);

    /**
     * 특정 시간대 예약 확인 (가용성 체크)
     */
    int countByRestaurantAndTime(@Param("restaurantId") Long restaurantId,
                                  @Param("reservationTime") LocalDateTime reservationTime);

    /**
     * 예약 생성
     */
    void insert(Reservation reservation);

    /**
     * 예약 수정
     */
    void update(Reservation reservation);

    /**
     * 예약 삭제
     */
    void delete(@Param("id") Long id);

    /**
     * 예약 상태 변경
     */
    void updateStatus(@Param("id") Long id, @Param("status") String status);

    /**
     * 예약 취소
     */
    void cancel(@Param("id") Long id,
                @Param("cancelReason") String cancelReason,
                @Param("cancelledAt") LocalDateTime cancelledAt);

    /**
     * 예약 확정
     */
    void confirm(@Param("id") Long id);

    /**
     * 결제 정보 업데이트
     */
    void updatePayment(@Param("id") Long id,
                       @Param("paymentStatus") String paymentStatus,
                       @Param("paymentOrderId") String paymentOrderId,
                       @Param("paymentProvider") String paymentProvider,
                       @Param("paymentApprovedAt") LocalDateTime paymentApprovedAt);
}
