package com.meetlog.service;

import com.meetlog.dto.reservation.*;
import com.meetlog.model.Reservation;
import com.meetlog.model.Restaurant;
import com.meetlog.model.User;
import com.meetlog.repository.ReservationRepository;
import com.meetlog.repository.RestaurantRepository;
import com.meetlog.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ReservationService {

    private final ReservationRepository reservationRepository;
    private final RestaurantRepository restaurantRepository;
    private final UserRepository userRepository;

    /**
     * 예약 상세 조회
     */
    public ReservationDto getReservation(Long id) {
        return reservationRepository.findDtoById(id)
                .orElseThrow(() -> new RuntimeException("Reservation not found"));
    }

    /**
     * 예약 검색
     */
    public Map<String, Object> searchReservations(ReservationSearchRequest request) {
        List<ReservationDto> reservations = reservationRepository.search(request);
        int total = reservationRepository.countSearch(request);

        Map<String, Object> result = new HashMap<>();
        result.put("reservations", reservations);
        result.put("total", total);
        result.put("page", request.getPage() != null ? request.getPage() : 1);
        result.put("size", request.getLimit());
        result.put("totalPages", (int) Math.ceil((double) total / request.getLimit()));

        return result;
    }

    /**
     * 레스토랑별 예약 목록
     */
    public List<ReservationDto> getRestaurantReservations(Long restaurantId, Integer page, Integer size) {
        int offset = (page - 1) * size;
        return reservationRepository.findByRestaurantId(restaurantId, offset, size);
    }

    /**
     * 사용자별 예약 목록
     */
    public List<ReservationDto> getUserReservations(Long userId, Integer page, Integer size) {
        int offset = (page - 1) * size;
        return reservationRepository.findByUserId(userId, offset, size);
    }

    /**
     * 예약 가능 여부 확인
     */
    public boolean checkAvailability(Long restaurantId, LocalDateTime reservationTime, Integer partySize) {
        // 레스토랑 존재 및 수용 인원 확인
        Restaurant restaurant = restaurantRepository.findById(restaurantId)
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));

        if (restaurant.getCapacity() != null && partySize > restaurant.getCapacity()) {
            return false;
        }

        // 동일 시간대 예약 확인 (간단한 체크, 실제로는 더 복잡한 로직 필요)
        int existingReservations = reservationRepository.countByRestaurantAndTime(restaurantId, reservationTime);

        // 예시: 동일 시간대에 최대 5개 예약만 허용
        return existingReservations < 5;
    }

    /**
     * 예약 생성
     */
    @Transactional
    public ReservationDto createReservation(ReservationCreateRequest request, Long userId) {
        // 레스토랑 및 사용자 정보 조회
        Restaurant restaurant = restaurantRepository.findById(request.getRestaurantId())
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        // 예약 가능 여부 확인
        if (!checkAvailability(request.getRestaurantId(), request.getReservationTime(), request.getPartySize())) {
            throw new RuntimeException("Reservation not available for the selected time");
        }

        // 예약 생성
        Reservation reservation = Reservation.builder()
                .restaurantId(request.getRestaurantId())
                .userId(userId)
                .restaurantName(restaurant.getName())
                .userName(user.getName())
                .reservationTime(request.getReservationTime())
                .partySize(request.getPartySize())
                .status("PENDING")
                .specialRequests(request.getSpecialRequests())
                .contactPhone(request.getContactPhone() != null ? request.getContactPhone() : user.getPhone())
                .depositRequired(false)
                .depositAmount(BigDecimal.ZERO)
                .userCouponId(request.getUserCouponId())
                .couponDiscountAmount(BigDecimal.ZERO)
                .paymentStatus("NONE")
                .build();

        reservationRepository.insert(reservation);

        return reservationRepository.findDtoById(reservation.getId())
                .orElseThrow(() -> new RuntimeException("Failed to create reservation"));
    }

    /**
     * 예약 수정
     */
    @Transactional
    public ReservationDto updateReservation(Long id, ReservationCreateRequest request, Long userId) {
        Reservation reservation = reservationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Reservation not found"));

        if (!reservation.isOwnedBy(userId)) {
            throw new RuntimeException("Unauthorized to update this reservation");
        }

        if (!reservation.canCancel()) {
            throw new RuntimeException("Cannot update reservation in current status");
        }

        // 예약 정보 업데이트
        reservation.setReservationTime(request.getReservationTime());
        reservation.setPartySize(request.getPartySize());
        reservation.setSpecialRequests(request.getSpecialRequests());
        if (request.getContactPhone() != null) {
            reservation.setContactPhone(request.getContactPhone());
        }

        reservationRepository.update(reservation);

        return reservationRepository.findDtoById(id)
                .orElseThrow(() -> new RuntimeException("Failed to update reservation"));
    }

    /**
     * 예약 취소
     */
    @Transactional
    public void cancelReservation(Long id, String cancelReason, Long userId) {
        Reservation reservation = reservationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Reservation not found"));

        if (!reservation.isOwnedBy(userId)) {
            throw new RuntimeException("Unauthorized to cancel this reservation");
        }

        if (!reservation.canCancel()) {
            throw new RuntimeException("Cannot cancel reservation in current status");
        }

        reservationRepository.cancel(id, cancelReason, LocalDateTime.now());
    }

    /**
     * 예약 확정 (사업자용)
     */
    @Transactional
    public ReservationDto confirmReservation(Long id, Long ownerId) {
        Reservation reservation = reservationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Reservation not found"));

        // 레스토랑 소유자 확인
        Restaurant restaurant = restaurantRepository.findById(reservation.getRestaurantId())
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));

        if (!restaurant.isOwnedBy(ownerId)) {
            throw new RuntimeException("Unauthorized to confirm this reservation");
        }

        if (!reservation.canConfirm()) {
            throw new RuntimeException("Cannot confirm reservation in current status");
        }

        reservationRepository.confirm(id);

        return reservationRepository.findDtoById(id)
                .orElseThrow(() -> new RuntimeException("Failed to confirm reservation"));
    }

    /**
     * 예약 상태 변경
     */
    @Transactional
    public void updateStatus(Long id, String status) {
        reservationRepository.updateStatus(id, status);
    }

    /**
     * 결제 정보 업데이트
     */
    @Transactional
    public void updatePayment(Long id, String paymentStatus, String paymentOrderId,
                               String paymentProvider, LocalDateTime paymentApprovedAt) {
        reservationRepository.updatePayment(id, paymentStatus, paymentOrderId,
                paymentProvider, paymentApprovedAt);
    }
}
