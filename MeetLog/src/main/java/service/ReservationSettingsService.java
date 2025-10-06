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
		if (settings == null)
			return false;
		if (settings.getRestaurantId() <= 0)
			return false;
		if (settings.getMinPartySize() <= 0)
			return false;
		if (settings.getMaxPartySize() < settings.getMinPartySize())
			return false;
		if (settings.getAdvanceBookingDays() < 0)
			return false;
		if (settings.getMinAdvanceHours() < 0)
			return false;
		return true;
	}

	public boolean validateReservationSettings(ReservationSettingsNew settings) {
		if (settings == null) {
			return false;
		}

		java.util.List<String> errors = new java.util.ArrayList<>();

		if (settings.getRestaurantId() <= 0) {
			errors.add("restaurantId");
		}

		if (settings.getMaxAdvanceDays() < 1 || settings.getMaxAdvanceDays() > 365) {
			errors.add("maxAdvanceDays 범위(1-365)");
		}

		if (settings.getMinAdvanceHours() < 0 || settings.getMinAdvanceHours() > 168) {
			errors.add("minAdvanceHours 범위(0-168)");
		}

		if (settings.getMaxPartySize() < 1 || settings.getMaxPartySize() > 50) {
			errors.add("maxPartySize 범위(1-50)");
		}

		int slotInterval = settings.getTimeSlotInterval();
		if (slotInterval != 15 && slotInterval != 30 && slotInterval != 60) {
			errors.add("허용되지 않은 timeSlotInterval");
		}

		if (settings.isDepositRequired()) {
			if (settings.getDepositAmount() == null
					|| settings.getDepositAmount().compareTo(java.math.BigDecimal.ZERO) <= 0) {
				errors.add("보증금이 필요하지만 depositAmount가 유효하지 않음");
			}
		} else if (settings.getDepositAmount() != null
				&& settings.getDepositAmount().compareTo(java.math.BigDecimal.ZERO) > 0) {
			errors.add("depositRequired가 false인 경우 depositAmount는 0이어야 함");
		}

		if (settings.isAllowWaitingList()) {
			if (settings.getMaxWaitingList() <= 0 || settings.getMaxWaitingList() > 20) {
				errors.add("대기자 허용 시 maxWaitingList는 1-20 범위여야 함");
			}
		} else if (settings.getMaxWaitingList() > 0) {
			errors.add("대기자 미허용 상태에서 maxWaitingList가 0보다 큼");
		}

		boolean hasEnabledOperatingHours = false;
		if (settings.getOperatingHours() != null) {
			for (model.ReservationOperatingHours hours : settings.getOperatingHours()) {
				if (hours == null) {
					errors.add("operatingHours 항목이 null");
					continue;
				}
				if (hours.isEnabled()) {
					hasEnabledOperatingHours = true;
				}
				if (!hours.isValidOperatingHours()) {
					errors.add("유효하지 않은 operatingHours: " + hours.getDayOfWeek());
				}
			}
		}

		if (!hasEnabledOperatingHours) {
			errors.add("활성화된 운영시간이 최소 한 개 필요");
		}

		if (settings.getBlackoutDates() != null) {
			java.util.Set<java.time.LocalDate> uniqueDates = new java.util.HashSet<>();
			for (model.ReservationBlackoutDate blackoutDate : settings.getBlackoutDates()) {
				if (blackoutDate == null) {
					errors.add("blackoutDates 항목이 null");
					continue;
				}
				if (!blackoutDate.isValidBlackoutDate()) {
					errors.add("유효하지 않은 blackoutDate: " + blackoutDate.getBlackoutDate());
				}
				if (blackoutDate.getBlackoutDate() != null
						&& !uniqueDates.add(blackoutDate.getBlackoutDate())) {
					errors.add("중복된 blackoutDate: " + blackoutDate.getBlackoutDate());
				}
			}
		}

		if (!errors.isEmpty()) {
			System.err.println("ReservationSettingsNew 검증 실패: " + String.join(", ", errors));
			return false;
		}

		return true;
	}
}
