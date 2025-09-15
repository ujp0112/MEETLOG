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

    public Reservation getReservationById(int reservationId) {
        return reservationDAO.findById(reservationId);
    }

    public boolean createReservation(Reservation reservation) {
        // (핵심 수정!) int 결과를 boolean으로 변환
        return reservationDAO.insert(reservation) > 0;
    }

    public boolean cancelReservation(int reservationId) {
        Map<String, Object> params = new HashMap<>();
        params.put("id", reservationId);
        params.put("status", "CANCELLED");
        // (핵심 수정!) int 결과를 boolean으로 변환
        return reservationDAO.updateStatus(params) > 0;
    }

    public boolean updateReservationStatus(int reservationId, String status) {
        Map<String, Object> params = new HashMap<>();
        params.put("id", reservationId);
        params.put("status", status);
        // (핵심 수정!) int 결과를 boolean으로 변환
        return reservationDAO.updateStatus(params) > 0;
    }
}