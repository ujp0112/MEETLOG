package service;

import model.ReservationSettings;
import model.ReservationSettingsNew;
import dao.ReservationSettingsDAO;

public class ReservationSettingsService {
    private ReservationSettingsDAO reservationDAO = new ReservationSettingsDAO();

    /**
     * 음식점별 예약 설정 조회 (Map으로 반환)
     */
    public java.util.Map<String, Object> getReservationSettings(int restaurantId) {
        try {
            return reservationDAO.findByRestaurantId(restaurantId);
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
            // blackout dates를 JSON 문자열로 변환
            if (settings.getBlackoutDates() != null && !settings.getBlackoutDates().isEmpty()) {
                String json = "[" + String.join(",",
                    settings.getBlackoutDates().stream()
                        .map(date -> "\"" + date + "\"")
                        .toArray(String[]::new)) + "]";
                settings.setBlackoutDatesJson(json);
            }

            // 기존 설정 확인
            java.util.Map<String, Object> existingSettings = reservationDAO.findByRestaurantId(settings.getRestaurantId());

            int result;
            if (existingSettings != null && existingSettings.get("id") != null) {
                // 기존 설정이 있으면 업데이트
                settings.setId((Integer) existingSettings.get("id"));
                result = reservationDAO.update(settings);
            } else {
                // 새 설정 등록
                result = reservationDAO.insert(settings);
            }

            return result > 0;
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
     * 예약 설정 유효성 검증 (임시로 기본 검증만 수행)
     */
    public boolean validateReservationSettings(ReservationSettings settings) {
        if (settings == null) return false;
        if (settings.getRestaurantId() <= 0) return false;
        // TODO: ReservationSettingsNew에 맞게 유효성 검증 로직 수정 필요
        return true;
    }
}