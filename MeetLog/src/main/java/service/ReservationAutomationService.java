package service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import dao.ReservationBlackoutDateDAO;
import dao.RestaurantTableDAO;
import dao.ReservationNotificationDAO;
import model.Reservation;
import model.ReservationBlackoutDate;
import model.RestaurantTable;
import model.ReservationNotification;

/**
 * 예약 시스템 자동화 서비스
 * - 자동 승인/거부
 * - 알림 발송
 * - 테이블 배정
 * - 블랙아웃 날짜 관리
 */
public class ReservationAutomationService {

    private final ReservationService reservationService = new ReservationService();
    private final ReservationBlackoutDateDAO blackoutDateDAO = new ReservationBlackoutDateDAO();
    private final RestaurantTableDAO tableDAO = new RestaurantTableDAO();
    private final ReservationNotificationDAO notificationDAO = new ReservationNotificationDAO();

    /**
     * 새 예약에 대한 자동 처리
     */
    public void processNewReservation(Reservation reservation) {
        try {
            // 1. 블랙아웃 날짜 확인
            if (isBlackoutDate(reservation)) {
                autoRejectReservation(reservation, "예약 불가 날짜입니다.");
                return;
            }

            // 2. 테이블 가용성 확인
            List<RestaurantTable> availableTables = findAvailableTables(reservation);
            if (availableTables.isEmpty()) {
                autoRejectReservation(reservation, "해당 시간에 이용 가능한 테이블이 없습니다.");
                return;
            }

            // 3. 자동 승인 설정 확인
            if (isAutoApprovalEnabled(reservation.getRestaurantId())) {
                // 최적 테이블 배정
                RestaurantTable optimalTable = selectOptimalTable(availableTables, reservation.getPartySize());

                if (optimalTable != null) {
                    assignTableToReservation(reservation.getId(), optimalTable.getId());
                    autoApproveReservation(reservation);
                } else {
                    // 테이블 배정 실패
                    autoRejectReservation(reservation, "테이블 배정에 실패했습니다.");
                }
            } else {
                // 수동 승인 대기
                sendPendingNotification(reservation);
            }

        } catch (Exception e) {
            e.printStackTrace();
            // 오류 발생 시 수동 처리를 위해 대기 상태로 유지
            sendErrorNotification(reservation, "예약 처리 중 오류가 발생했습니다.");
        }
    }

    /**
     * 블랙아웃 날짜 확인
     */
    private boolean isBlackoutDate(Reservation reservation) {
        LocalDate reservationDate = reservation.getReservationTime().toLocalDate();
        return blackoutDateDAO.isBlackoutDate(reservation.getRestaurantId(), reservationDate);
    }

    /**
     * 이용 가능한 테이블 목록 조회
     */
    private List<RestaurantTable> findAvailableTables(Reservation reservation) {
        return tableDAO.findAvailableByDateTime(
            reservation.getRestaurantId(),
            reservation.getReservationTime(),
            reservation.getPartySize()
        );
    }

    /**
     * 자동 승인 설정 확인
     */
    private boolean isAutoApprovalEnabled(int restaurantId) {
        // TODO: 음식점 예약 설정에서 자동 승인 여부 확인
        // 현재는 기본값으로 false 반환
        return false;
    }

    /**
     * 최적 테이블 선택
     */
    private RestaurantTable selectOptimalTable(List<RestaurantTable> availableTables, int partySize) {
        // 1순위: 정확히 맞는 인원수
        for (RestaurantTable table : availableTables) {
            if (table.getCapacity() == partySize) {
                return table;
            }
        }

        // 2순위: 최소 여유 인원 (1-2명 여유)
        RestaurantTable bestFit = null;
        int minExcess = Integer.MAX_VALUE;

        for (RestaurantTable table : availableTables) {
            if (table.getCapacity() >= partySize) {
                int excess = table.getCapacity() - partySize;
                if (excess < minExcess) {
                    minExcess = excess;
                    bestFit = table;
                }
            }
        }

        return bestFit;
    }

    /**
     * 테이블 배정
     */
    private void assignTableToReservation(int reservationId, int tableId) {
        // TODO: reservation_tables 테이블에 예약-테이블 연결 정보 저장
        // 현재는 로그만 출력
        System.out.println("테이블 배정: 예약 ID " + reservationId + " -> 테이블 ID " + tableId);
    }

    /**
     * 예약 자동 승인
     */
    private void autoApproveReservation(Reservation reservation) {
        boolean success = reservationService.updateReservationStatus(reservation.getId(), "CONFIRMED");

        if (success) {
            // 승인 알림 발송
            sendApprovalNotification(reservation);

            // 리마인더 알림 예약 (예약 시간 1시간 전)
            scheduleReminderNotification(reservation);

            System.out.println("예약 자동 승인 완료: " + reservation.getId());
        }
    }

    /**
     * 예약 자동 거부
     */
    private void autoRejectReservation(Reservation reservation, String reason) {
        boolean success = reservationService.updateReservationStatus(reservation.getId(), "CANCELLED");

        if (success) {
            // 거부 알림 발송
            sendRejectionNotification(reservation, reason);
            System.out.println("예약 자동 거부 완료: " + reservation.getId() + ", 사유: " + reason);
        }
    }

    /**
     * 승인 알림 발송
     */
    private void sendApprovalNotification(Reservation reservation) {
        String message = String.format(
            "[%s] 예약이 승인되었습니다. 날짜: %s, 인원: %d명",
            reservation.getRestaurantName(),
            reservation.getReservationTime().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")),
            reservation.getPartySize()
        );

        sendNotification(reservation, ReservationNotification.NotificationType.SMS, message);
    }

    /**
     * 거부 알림 발송
     */
    private void sendRejectionNotification(Reservation reservation, String reason) {
        String message = String.format(
            "[%s] 예약이 거부되었습니다. 사유: %s",
            reservation.getRestaurantName(),
            reason
        );

        sendNotification(reservation, ReservationNotification.NotificationType.SMS, message);
    }

    /**
     * 대기 알림 발송
     */
    private void sendPendingNotification(Reservation reservation) {
        String message = String.format(
            "[%s] 예약 신청이 접수되었습니다. 승인 여부를 확인하시기 바랍니다.",
            reservation.getRestaurantName()
        );

        sendNotification(reservation, ReservationNotification.NotificationType.SMS, message);
    }

    /**
     * 오류 알림 발송
     */
    private void sendErrorNotification(Reservation reservation, String errorMessage) {
        String message = String.format(
            "[%s] %s 고객센터로 문의하시기 바랍니다.",
            reservation.getRestaurantName(),
            errorMessage
        );

        sendNotification(reservation, ReservationNotification.NotificationType.SMS, message);
    }

    /**
     * 리마인더 알림 예약
     */
    private void scheduleReminderNotification(Reservation reservation) {
        // 예약 시간 1시간 전 알림
        LocalDateTime reminderTime = reservation.getReservationTime().minusHours(1);

        // 현재 시간보다 미래인 경우에만 리마인더 설정
        if (reminderTime.isAfter(LocalDateTime.now())) {
            String message = String.format(
                "[%s] 1시간 후 예약 시간입니다. 날짜: %s, 인원: %d명",
                reservation.getRestaurantName(),
                reservation.getReservationTime().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")),
                reservation.getPartySize()
            );

            // TODO: 스케줄러를 통한 지연 발송 구현
            // 현재는 즉시 알림 등록만 수행
            ReservationNotification reminderNotification = new ReservationNotification(
                reservation.getId(),
                ReservationNotification.NotificationType.SMS,
                reservation.getContactPhone(),
                message
            );

            notificationDAO.insert(reminderNotification);
            System.out.println("리마인더 알림 예약 완료: " + reminderTime);
        }
    }

    /**
     * 공통 알림 발송 메서드
     */
    private void sendNotification(Reservation reservation,
                                ReservationNotification.NotificationType type,
                                String message) {

        String recipient = getRecipientByType(reservation, type);
        if (recipient != null) {
            ReservationNotification notification = new ReservationNotification(
                reservation.getId(), type, recipient, message);

            notificationDAO.insert(notification);
        }
    }

    /**
     * 알림 타입별 수신자 정보 조회
     */
    private String getRecipientByType(Reservation reservation, ReservationNotification.NotificationType type) {
        switch (type) {
            case SMS:
                return reservation.getContactPhone();
            case EMAIL:
                // TODO: 예약 정보에서 이메일 조회
                return null;
            case PUSH:
                return String.valueOf(reservation.getUserId());
            default:
                return null;
        }
    }

    /**
     * 대량 블랙아웃 날짜 추가 (연휴, 정기휴무 등)
     */
    public int addBulkBlackoutDates(int restaurantId, List<LocalDate> dates, String reason) {
        List<ReservationBlackoutDate> blackoutDates = new ArrayList<>();

        for (LocalDate date : dates) {
            // 중복 체크
            if (!blackoutDateDAO.isBlackoutDate(restaurantId, date)) {
                blackoutDates.add(new ReservationBlackoutDate(restaurantId, date, reason));
            }
        }

        return blackoutDateDAO.insertBatch(blackoutDates);
    }

    /**
     * 과거 블랙아웃 날짜 정리
     */
    public int cleanupPastBlackoutDates(int restaurantId) {
        return blackoutDateDAO.deactivatePastDates(restaurantId);
    }

    /**
     * 테이블 최적화 추천
     */
    public List<Map<String, Object>> getTableOptimizationRecommendations(int restaurantId) {
        List<Map<String, Object>> recommendations = new ArrayList<>();

        // 테이블 통계 조회
        Map<String, Object> tableStats = tableDAO.getTableStats(restaurantId);

        // 추천 로직 (예시)
        if (tableStats != null) {
            int totalTables = (Integer) tableStats.get("total_tables");
            int activeTables = (Integer) tableStats.get("active_tables");

            if (activeTables < totalTables * 0.8) {
                Map<String, Object> recommendation = new HashMap<>();
                recommendation.put("type", "ACTIVATE_TABLES");
                recommendation.put("message", "비활성화된 테이블이 많습니다. 활성화를 검토해보세요.");
                recommendation.put("priority", "MEDIUM");
                recommendations.add(recommendation);
            }

            // 추가 추천 사항들...
        }

        return recommendations;
    }

    /**
     * 예약 통계 기반 인사이트 제공
     */
    public Map<String, Object> getReservationInsights(int restaurantId, int days) {
        Map<String, Object> insights = new HashMap<>();

        try {
            // 예약 통계 조회
            ReservationService.ReservationStats stats = reservationService.getReservationStats(restaurantId);

            if (stats != null) {
                // 승인율 계산
                double approvalRate = 0.0;
                int totalRequests = stats.getTotalReservations();
                if (totalRequests > 0) {
                    approvalRate = (double) stats.getConfirmedReservations() / totalRequests * 100;
                }

                insights.put("approvalRate", Math.round(approvalRate * 100.0) / 100.0);
                insights.put("totalReservations", totalRequests);
                insights.put("pendingReservations", stats.getPendingReservations());
                insights.put("cancelledReservations", stats.getCancelledReservations());

                // 인사이트 메시지 생성
                List<String> messages = new ArrayList<>();

                if (approvalRate < 70) {
                    messages.add("예약 승인율이 낮습니다. 예약 정책을 검토해보세요.");
                }

                if (stats.getPendingReservations() > 10) {
                    messages.add("대기 중인 예약이 많습니다. 빠른 처리가 필요합니다.");
                }

                insights.put("messages", messages);
            }

        } catch (Exception e) {
            e.printStackTrace();
            insights.put("error", "통계 조회 중 오류가 발생했습니다.");
        }

        return insights;
    }

    /**
     * 자동화 설정 업데이트
     */
    public boolean updateAutomationSettings(int restaurantId, Map<String, Object> settings) {
        try {
            // TODO: 음식점별 자동화 설정 저장
            // 현재는 로그만 출력
            System.out.println("자동화 설정 업데이트: 음식점 ID " + restaurantId);
            settings.forEach((key, value) -> System.out.println(key + ": " + value));

            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}