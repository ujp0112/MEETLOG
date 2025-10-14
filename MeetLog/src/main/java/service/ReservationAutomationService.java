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
import model.User;
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
    private final UserService userService = new UserService();

    /**
     * 새 예약에 대한 자동 처리
     */
    public void processNewReservation(Reservation reservation) {
        System.out.println("\n[DEBUG] ======================================================");
        System.out.println("[DEBUG] processNewReservation 시작: " + reservation);
        try {
            // 1. 블랙아웃 날짜 확인
            boolean isBlackout = isBlackoutDate(reservation);
            System.out.println("[DEBUG] 1. 블랙아웃 날짜 확인 결과: " + isBlackout);
            if (isBlackout) {
                autoRejectReservation(reservation, "예약 불가 날짜입니다.");
                return;
            }

            // 2. 테이블 가용성 확인
            List<RestaurantTable> availableTables = findAvailableTables(reservation);
            System.out.println("[DEBUG] 2. 이용 가능 테이블 수: " + availableTables.size());
            if (availableTables.isEmpty()) {
                autoRejectReservation(reservation, "해당 시간에 이용 가능한 테이블이 없습니다.");
                return;
            }

            // 3. 자동 승인 설정 확인
            boolean autoApprovalEnabled = isAutoApprovalEnabled(reservation.getRestaurantId());
            System.out.println("[DEBUG] 3. 자동 승인 설정 확인 결과: " + autoApprovalEnabled);
            if (autoApprovalEnabled) {
                // 최적 테이블 배정
                RestaurantTable optimalTable = selectOptimalTable(availableTables, reservation.getPartySize());
                System.out.println("[DEBUG] 4. 최적 테이블 배정 결과: " + (optimalTable != null ? "테이블 ID " + optimalTable.getId() : "배정 실패"));

                if (optimalTable != null) {
                    assignTableToReservation(reservation.getId(), optimalTable.getId());
                    System.out.println("[DEBUG] -> autoApproveReservation 호출");
                    autoApproveReservation(reservation);
                } else {
                    // 테이블 배정 실패
                    System.out.println("[DEBUG] -> autoRejectReservation 호출 (테이블 배정 실패)");
                    autoRejectReservation(reservation, "테이블 배정에 실패했습니다.");
                }
            } else {
                // 수동 승인 대기
                System.out.println("[DEBUG] -> sendPendingNotification 호출 (수동 승인 대기)");
                sendPendingNotification(reservation);
            }

        } catch (Exception e) {
            e.printStackTrace();
            // 오류 발생 시 수동 처리를 위해 대기 상태로 유지
            sendErrorNotification(reservation, "예약 처리 중 오류가 발생했습니다.");
        } finally {
            System.out.println("[DEBUG] processNewReservation 종료");
            System.out.println("[DEBUG] ======================================================\n");
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
        System.out.println("[DEBUG] isAutoApprovalEnabled 호출: restaurantId=" + restaurantId);
        try {
            dao.ReservationSettingsDAO settingsDAO = new dao.ReservationSettingsDAO();
            Map<String, Object> settings = settingsDAO.findByRestaurantId(restaurantId);
            System.out.println("[DEBUG] DB에서 조회된 설정: " + settings);

            if (settings != null && settings.containsKey("auto_accept")) {
                Object autoAccept = settings.get("auto_accept");
                System.out.println("[DEBUG] 'auto_accept' 키의 값: " + autoAccept + " (타입: " + (autoAccept != null ? autoAccept.getClass().getName() : "null") + ")");
                if (autoAccept instanceof Boolean) {
                    return (Boolean) autoAccept;
                } else if (autoAccept instanceof Integer) {
                    return ((Integer) autoAccept) == 1;
                } else if (autoAccept instanceof java.math.BigDecimal) { // TINYINT(1)이 BigDecimal로 반환될 경우 대비
                    return ((java.math.BigDecimal) autoAccept).intValue() == 1;
                }
            }

            // 설정이 없으면 기본값 false (수동 승인)
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            // 오류 발생 시 안전하게 수동 승인
            return false;
        }
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
        try {
            dao.ReservationTableAssignmentDAO assignmentDAO = new dao.ReservationTableAssignmentDAO();
            model.ReservationTableAssignment assignment = new model.ReservationTableAssignment();

            assignment.setReservationId(reservationId);
            assignment.setTableId(tableId);
            assignment.setAssignedAt(LocalDateTime.now());

            int result = assignmentDAO.insert(assignment);

            if (result > 0) {
                System.out.println("테이블 배정 완료: 예약 ID " + reservationId + " -> 테이블 ID " + tableId);
            } else {
                System.err.println("테이블 배정 실패: 예약 ID " + reservationId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("테이블 배정 중 오류 발생: " + e.getMessage());
        }
    }

    /**
     * 예약 자동 승인
     */
    private void autoApproveReservation(Reservation reservation) {
        // reservationService.updateReservationStatus가 호출되면 내부적으로 이메일 발송 로직(sendConfirmationEmail)이 실행됩니다.
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
        // 1. 이메일 발송 시도
        try {
            User user = userService.getUserById(reservation.getUserId());
            if (user != null && user.getEmail() != null && !user.getEmail().isEmpty()) {
                String subject = String.format("[%s] 예약이 자동으로 확정되었습니다.", reservation.getRestaurantName());
                String emailBody = String.format(
                    "안녕하세요, %s님.\n\n요청하신 예약이 자동으로 승인되었습니다.\n\n- 식당: %s\n- 예약 시간: %s\n- 인원: %d명\n\nMEETLOG를 이용해주셔서 감사합니다.",
                    user.getNickname(), reservation.getRestaurantName(), reservation.getReservationTime().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")), reservation.getPartySize()
                );
                util.EmailUtil.sendEmail(user.getEmail(), subject, emailBody);
                System.out.println("자동 승인 이메일 발송 시도: " + user.getEmail());
            } else {
                System.out.println("자동 승인 이메일 발송 스킵: 사용자 이메일 정보 없음 (userId=" + reservation.getUserId() + ")");
            }
        } catch (Exception e) {
            System.err.println("예약 자동 승인 이메일 발송 중 오류 발생: reservationId=" + reservation.getId());
            e.printStackTrace();
        }

        // 2. SMS 발송 시도 (이메일 발송 성공 여부와 관계없이 실행)
        try {
            String smsMessage = String.format(
                "[%s] 예약이 자동으로 승인되었습니다. 날짜: %s, 인원: %d명. 자세한 내용은 앱 또는 이메일을 확인해주세요.",
                reservation.getRestaurantName(),
                reservation.getReservationTime().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")),
                reservation.getPartySize()
            );
            sendNotification(reservation, ReservationNotification.NotificationType.SMS, smsMessage);
            System.out.println("자동 승인 SMS 발송 시도: " + reservation.getContactPhone());
        } catch (Exception e) {
            System.err.println("예약 자동 승인 SMS 발송 중 오류 발생: reservationId=" + reservation.getId());
            e.printStackTrace();
        }
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

            // 예약된 시간에 발송할 알림 등록 (상태: SCHEDULED)
            ReservationNotification reminderNotification = new ReservationNotification(
                reservation.getId(),
                ReservationNotification.NotificationType.SMS,
                reservation.getContactPhone(),
                message
            );

            reminderNotification.setScheduledTime(reminderTime);
            reminderNotification.setStatus(ReservationNotification.NotificationStatus.SCHEDULED); // 예약된 상태

            notificationDAO.insert(reminderNotification);
            System.out.println("리마인더 알림 예약 완료: " + reminderTime);

            // 참고: 실제 발송은 별도의 스케줄러 배치 작업에서 처리
            // 예: NotificationSchedulerService가 주기적으로 scheduled_time이 현재 시간보다 이전인
            // SCHEDULED 상태의 알림을 찾아 발송하고 상태를 SENT로 업데이트
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
            dao.ReservationSettingsDAO settingsDAO = new dao.ReservationSettingsDAO();
            Map<String, Object> existingSettings = settingsDAO.findByRestaurantId(restaurantId);

            model.ReservationSettings reservationSettings = new model.ReservationSettings();
            reservationSettings.setRestaurantId(restaurantId);

            // 기존 설정이 있으면 ID 설정
            if (existingSettings != null && existingSettings.containsKey("id")) {
                reservationSettings.setId((Integer) existingSettings.get("id"));
            }

            // 설정 값 업데이트
            if (settings.containsKey("autoAccept")) {
                reservationSettings.setAutoAccept((Boolean) settings.get("autoAccept"));
            }
            if (settings.containsKey("minPartySize")) {
                reservationSettings.setMinPartySize((Integer) settings.get("minPartySize"));
            }
            if (settings.containsKey("maxPartySize")) {
                reservationSettings.setMaxPartySize((Integer) settings.get("maxPartySize"));
            }
            if (settings.containsKey("advanceBookingDays")) {
                reservationSettings.setAdvanceBookingDays((Integer) settings.get("advanceBookingDays"));
            }
            if (settings.containsKey("minAdvanceHours")) {
                reservationSettings.setMinAdvanceHours((Integer) settings.get("minAdvanceHours"));
            }

            // DB 저장
            int result;
            if (reservationSettings.getId() > 0) {
                result = settingsDAO.update(reservationSettings);
            } else {
                result = settingsDAO.insert(reservationSettings);
            }

            if (result > 0) {
                System.out.println("자동화 설정 업데이트 완료: 음식점 ID " + restaurantId);
                return true;
            }

            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}