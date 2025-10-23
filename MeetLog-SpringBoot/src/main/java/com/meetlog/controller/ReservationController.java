package com.meetlog.controller;

import com.meetlog.dto.reservation.*;
import com.meetlog.security.CustomUserDetails;
import com.meetlog.service.ReservationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Tag(name = "Reservation", description = "예약 API")
@RestController
@RequestMapping("/api/reservations")
@RequiredArgsConstructor
public class ReservationController {

    private final ReservationService reservationService;

    @Operation(summary = "예약 검색", description = "레스토랑, 사용자, 상태 등으로 예약을 검색합니다.")
    @GetMapping
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Map<String, Object>> searchReservations(
            @RequestParam(required = false) Long restaurantId,
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate,
            @RequestParam(required = false, defaultValue = "reservation_time") String sortBy,
            @RequestParam(required = false, defaultValue = "desc") String sortOrder,
            @RequestParam(required = false, defaultValue = "1") Integer page,
            @RequestParam(required = false, defaultValue = "10") Integer size
    ) {
        ReservationSearchRequest request = ReservationSearchRequest.builder()
                .restaurantId(restaurantId)
                .userId(userId)
                .status(status)
                .startDate(startDate)
                .endDate(endDate)
                .sortBy(sortBy)
                .sortOrder(sortOrder)
                .page(page)
                .size(size)
                .build();

        Map<String, Object> result = reservationService.searchReservations(request);
        return ResponseEntity.ok(result);
    }

    @Operation(summary = "예약 상세 조회", description = "예약 ID로 상세 정보를 조회합니다.")
    @GetMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<ReservationDto> getReservation(@PathVariable Long id) {
        ReservationDto reservation = reservationService.getReservation(id);
        return ResponseEntity.ok(reservation);
    }

    @Operation(summary = "레스토랑별 예약 목록", description = "특정 레스토랑의 예약 목록을 조회합니다.")
    @GetMapping("/restaurant/{restaurantId}")
    @PreAuthorize("hasAnyRole('BUSINESS', 'ADMIN')")
    public ResponseEntity<List<ReservationDto>> getRestaurantReservations(
            @PathVariable Long restaurantId,
            @RequestParam(required = false, defaultValue = "1") Integer page,
            @RequestParam(required = false, defaultValue = "10") Integer size
    ) {
        List<ReservationDto> reservations = reservationService.getRestaurantReservations(restaurantId, page, size);
        return ResponseEntity.ok(reservations);
    }

    @Operation(summary = "내 예약 목록", description = "현재 로그인한 사용자의 예약 목록을 조회합니다.")
    @GetMapping("/my")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<List<ReservationDto>> getMyReservations(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @RequestParam(required = false, defaultValue = "1") Integer page,
            @RequestParam(required = false, defaultValue = "10") Integer size
    ) {
        List<ReservationDto> reservations = reservationService.getUserReservations(userDetails.getUserId(), page, size);
        return ResponseEntity.ok(reservations);
    }

    @Operation(summary = "예약 가능 여부 확인", description = "특정 시간대의 예약 가능 여부를 확인합니다.")
    @GetMapping("/availability")
    public ResponseEntity<Map<String, Boolean>> checkAvailability(
            @RequestParam Long restaurantId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime reservationTime,
            @RequestParam Integer partySize
    ) {
        boolean available = reservationService.checkAvailability(restaurantId, reservationTime, partySize);
        return ResponseEntity.ok(Map.of("available", available));
    }

    @Operation(summary = "예약 생성", description = "새 예약을 생성합니다.")
    @PostMapping
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<ReservationDto> createReservation(
            @Valid @RequestBody ReservationCreateRequest request,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        ReservationDto reservation = reservationService.createReservation(request, userDetails.getUserId());
        return ResponseEntity.ok(reservation);
    }

    @Operation(summary = "예약 수정", description = "예약을 수정합니다. (예약자만 가능)")
    @PutMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<ReservationDto> updateReservation(
            @PathVariable Long id,
            @Valid @RequestBody ReservationCreateRequest request,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        ReservationDto reservation = reservationService.updateReservation(id, request, userDetails.getUserId());
        return ResponseEntity.ok(reservation);
    }

    @Operation(summary = "예약 취소", description = "예약을 취소합니다. (예약자만 가능)")
    @DeleteMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Void> cancelReservation(
            @PathVariable Long id,
            @RequestParam(required = false) String cancelReason,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        reservationService.cancelReservation(id, cancelReason, userDetails.getUserId());
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "예약 확정", description = "예약을 확정합니다. (레스토랑 소유자만 가능)")
    @PostMapping("/{id}/confirm")
    @PreAuthorize("hasAnyRole('BUSINESS', 'ADMIN')")
    public ResponseEntity<ReservationDto> confirmReservation(
            @PathVariable Long id,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        ReservationDto reservation = reservationService.confirmReservation(id, userDetails.getUserId());
        return ResponseEntity.ok(reservation);
    }

    @Operation(summary = "예약 상태 변경", description = "예약 상태를 변경합니다. (관리자만 가능)")
    @PatchMapping("/{id}/status")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> updateStatus(
            @PathVariable Long id,
            @RequestParam String status
    ) {
        reservationService.updateStatus(id, status);
        return ResponseEntity.noContent().build();
    }
}
