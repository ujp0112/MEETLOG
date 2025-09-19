package service;

import dao.ReservationDAO;
import model.Reservation;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class ReservationService {
    private ReservationDAO reservationDAO = new ReservationDAO();

    public List<Reservation> getReservationsByUserId(int userId) {
        return reservationDAO.findByUserId(userId);
    }

    // [추가] MypageServlet의 '최근 예약'을 위한 메서드
    public List<Reservation> getRecentReservations(int userId, int limit) {
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("limit", limit);
        // ReservationMapper.xml에 새로 추가한 쿼리(findRecentByUserId)를 호출합니다.
        // (ReservationDAO 인터페이스에도 이 메서드 선언이 필요합니다)
        return reservationDAO.findRecentByUserId(params); 
    }

    public Reservation getReservationById(int reservationId) {
        return reservationDAO.findById(reservationId);
    }

    public boolean createReservation(Reservation reservation) {
        return reservationDAO.insert(reservation) > 0;
    }

    public boolean cancelReservation(int reservationId) {
        Map<String, Object> params = new HashMap<>();
        params.put("id", reservationId);
        params.put("status", "CANCELLED");
        return reservationDAO.updateStatus(params) > 0;
    }

    public boolean updateReservationStatus(int reservationId, String status) {
        Map<String, Object> params = new HashMap<>();
        params.put("id", reservationId);
        params.put("status", status);
        return reservationDAO.updateStatus(params) > 0;
    }
}