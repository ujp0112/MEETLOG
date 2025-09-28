package service;

import model.ReservationSettings;
import dao.ReservationSettingsDAO;

public class ReservationSettingsService {
    private ReservationSettingsDAO reservationDAO = new ReservationSettingsDAO();

    /**
     * 음식점별 예약 설정 조회
     */
    public ReservationSettings getReservationSettings(int restaurantId) {
        try {
            ReservationSettings settings = reservationDAO.findByRestaurantId(restaurantId);

            // 설정이 없으면 기본 설정 생성
            if (settings == null) {
                settings = new ReservationSettings(restaurantId);
                if (reservationDAO.insert(settings) > 0) {
                    return reservationDAO.findByRestaurantId(restaurantId);
                }
            }

            return settings;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 예약 설정 저장/업데이트
     */
    public boolean saveReservationSettings(ReservationSettings settings) {
        try {
            // 유효성 검증
            if (!validateReservationSettings(settings)) {
                return false;
            }

            // 기존 설정이 있는지 확인
            ReservationSettings existing = reservationDAO.findByRestaurantId(settings.getRestaurantId());

            if (existing == null) {
                // 새로 생성
                return reservationDAO.insert(settings) > 0;
            } else {
                // 기존 설정 업데이트
                settings.setId(existing.getId());
                return reservationDAO.update(settings) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 예약 기능 활성화/비활성화
     */
    public boolean toggleReservationEnabled(int restaurantId, boolean enabled) {
        try {
            return reservationDAO.updateReservationEnabled(restaurantId, enabled) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 자동 승인 설정 변경
     */
    public boolean updateAutoAccept(int restaurantId, boolean autoAccept) {
        try {
            return reservationDAO.updateAutoAccept(restaurantId, autoAccept) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 예약 설정 삭제
     */
    public boolean deleteReservationSettings(int restaurantId) {
        try {
            return reservationDAO.delete(restaurantId) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 예약 설정 유효성 검증
     */
    public boolean validateReservationSettings(ReservationSettings settings) {
        if (settings == null) return false;
        if (settings.getRestaurantId() <= 0) return false;
        if (settings.getMinPartySize() <= 0 || settings.getMaxPartySize() <= 0) return false;
        if (settings.getMinPartySize() > settings.getMaxPartySize()) return false;
        if (settings.getAdvanceBookingDays() <= 0) return false;
        if (settings.getMinAdvanceHours() < 0) return false;

        // 시간 검증
        if (settings.getReservationStartTime() != null && settings.getReservationEndTime() != null) {
            if (settings.getReservationStartTime().isAfter(settings.getReservationEndTime())) {
                return false;
            }
        }

        return true;
    }
}