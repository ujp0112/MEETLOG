package service;

import java.util.List;
import dao.CourseReservationManagementDAO;
import model.AdminCourseReservation;

public class CourseReservationManagementService {
    private CourseReservationManagementDAO reservationDAO = new CourseReservationManagementDAO();

    /**
     * 관리자 페이지의 모든 코스 예약 목록을 가져옵니다.
     * @return AdminCourseReservation 목록
     */
    public List<AdminCourseReservation> getAllReservationsForAdmin() {
        return reservationDAO.selectAllReservationsForAdmin();
    }
    
    /**
     * 특정 예약의 상태를 변경합니다.
     * @param reservationId 상태를 변경할 예약 ID
     * @param newStatus 새로운 상태 ("CONFIRMED", "CANCELLED", "COMPLETED")
     */
    public void updateReservationStatus(int reservationId, String newStatus) {
        if (newStatus == null || !List.of("CONFIRMED", "CANCELLED", "COMPLETED").contains(newStatus)) {
            throw new IllegalArgumentException("유효하지 않은 예약 상태입니다.");
        }
        reservationDAO.updateReservationStatus(reservationId, newStatus);
    }
}