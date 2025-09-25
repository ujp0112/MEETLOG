package service;

import dao.ReservationSettingsDAO;
import model.ReservationSettingsNew;
import model.ReservationOperatingHours;
import model.ReservationBlackoutDate;
import model.RestaurantTable;

import java.time.LocalDate;
import java.util.List;

/**
 * 예약 설정 서비스 클래스
 * 비즈니스 로직과 유효성 검증을 담당
 */
public class ReservationSettingsService {

    private final ReservationSettingsDAO reservationSettingsDAO = new ReservationSettingsDAO();

    /**
     * 음식점의 예약 설정 조회
     * 설정이 없으면 기본 설정을 생성
     */
    public ReservationSettingsNew getOrCreateReservationSettings(int restaurantId) {
        try {
            ReservationSettingsNew settings = reservationSettingsDAO.getByRestaurantId(restaurantId);

            if (settings == null) {
                // 설정이 없으면 기본 설정 생성
                settings = new ReservationSettingsNew();
                settings.setRestaurantId(restaurantId);

                boolean created = reservationSettingsDAO.create(settings);
                if (created) {
                    // 생성 후 다시 조회하여 ID 포함된 객체 반환
                    settings = reservationSettingsDAO.getByRestaurantId(restaurantId);
                }
            }

            // 관련 데이터도 함께 로드
            if (settings != null) {
                settings.setOperatingHours(getOperatingHours(settings.getId()));
                settings.setBlackoutDates(getBlackoutDates(restaurantId));
            }

            return settings;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 예약 설정 수정
     */
    public boolean updateReservationSettings(ReservationSettingsNew settings) {
        try {
            if (settings == null || settings.getId() <= 0) {
                return false;
            }

            // 유효성 검증
            if (!isValidSettings(settings)) {
                return false;
            }

            return reservationSettingsDAO.update(settings);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 운영시간 조회
     */
    public List<ReservationOperatingHours> getOperatingHours(int settingsId) {
        try {
            return reservationSettingsDAO.getOperatingHours(settingsId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 운영시간 업데이트
     */
    public boolean updateOperatingHours(List<ReservationOperatingHours> operatingHoursList) {
        try {
            if (operatingHoursList == null || operatingHoursList.isEmpty()) {
                return false;
            }

            // 각 운영시간의 유효성 검증
            for (ReservationOperatingHours hours : operatingHoursList) {
                if (!hours.isValidOperatingHours()) {
                    return false;
                }
            }

            return reservationSettingsDAO.updateOperatingHours(operatingHoursList);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 예약 불가 날짜 조회
     */
    public List<ReservationBlackoutDate> getBlackoutDates(int restaurantId) {
        try {
            return reservationSettingsDAO.getBlackoutDates(restaurantId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 예약 불가 날짜 추가
     */
    public boolean addBlackoutDate(int restaurantId, LocalDate date, String reason) {
        try {
            if (date == null || date.isBefore(LocalDate.now())) {
                return false;
            }

            ReservationBlackoutDate blackoutDate = new ReservationBlackoutDate(restaurantId, date, reason);
            return reservationSettingsDAO.addBlackoutDate(blackoutDate);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 예약 불가 날짜 제거
     */
    public boolean removeBlackoutDate(int blackoutDateId) {
        try {
            return reservationSettingsDAO.removeBlackoutDate(blackoutDateId);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 테이블 목록 조회
     */
    public List<RestaurantTable> getRestaurantTables(int restaurantId) {
        try {
            return reservationSettingsDAO.getTables(restaurantId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 테이블 추가
     */
    public boolean addRestaurantTable(RestaurantTable table) {
        try {
            if (table == null || !table.isValidTable()) {
                return false;
            }

            return reservationSettingsDAO.addTable(table);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 테이블 수정
     */
    public boolean updateRestaurantTable(RestaurantTable table) {
        try {
            if (table == null || !table.isValidTable()) {
                return false;
            }

            return reservationSettingsDAO.updateTable(table);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 테이블 삭제
     */
    public boolean deleteRestaurantTable(int tableId) {
        try {
            return reservationSettingsDAO.deleteTable(tableId);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 예약 설정 유효성 검증
     */
    private boolean isValidSettings(ReservationSettingsNew settings) {
        if (settings.getMaxAdvanceDays() <= 0 || settings.getMaxAdvanceDays() > 365) {
            return false;
        }

        if (settings.getMinAdvanceHours() < 0 || settings.getMinAdvanceHours() > 168) {
            return false;
        }

        if (settings.getMaxPartySize() <= 0 || settings.getMaxPartySize() > 50) {
            return false;
        }

        if (settings.getTimeSlotInterval() != 15 &&
            settings.getTimeSlotInterval() != 30 &&
            settings.getTimeSlotInterval() != 60) {
            return false;
        }

        if (settings.getMaxWaitingList() < 0 || settings.getMaxWaitingList() > 20) {
            return false;
        }

        if (settings.getDepositAmount() != null &&
            settings.getDepositAmount().compareTo(java.math.BigDecimal.ZERO) < 0) {
            return false;
        }

        return true;
    }

    /**
     * 특정 날짜가 예약 불가 날짜인지 확인
     */
    public boolean isBlackoutDate(int restaurantId, LocalDate date) {
        try {
            List<ReservationBlackoutDate> blackoutDates = getBlackoutDates(restaurantId);

            if (blackoutDates != null) {
                for (ReservationBlackoutDate blackoutDate : blackoutDates) {
                    if (blackoutDate.getBlackoutDate().equals(date)) {
                        return true;
                    }
                }
            }

            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return true; // 오류 발생 시 안전하게 예약 불가로 처리
        }
    }

    /**
     * 특정 요일의 운영 여부 확인
     */
    public boolean isOperatingDay(int settingsId, java.time.DayOfWeek dayOfWeek) {
        try {
            List<ReservationOperatingHours> operatingHours = getOperatingHours(settingsId);

            if (operatingHours != null) {
                for (ReservationOperatingHours hours : operatingHours) {
                    if (hours.getDayOfWeek().equals(dayOfWeek)) {
                        return hours.isEnabled();
                    }
                }
            }

            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}