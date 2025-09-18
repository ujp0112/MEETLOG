package controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;


public class ReservationManagementServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            String adminId = (String) session.getAttribute("adminId");
            
            if (adminId == null) {
                response.sendRedirect(request.getContextPath() + "/admin/login");
                return;
            }
            
            List<Reservation> reservations = createSampleReservations();
            request.setAttribute("reservations", reservations);
            
            request.getRequestDispatcher("/WEB-INF/views/admin-reservation-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "예약 목록을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private List<Reservation> createSampleReservations() {
        List<Reservation> reservations = new ArrayList<>();
        
        Reservation reservation1 = new Reservation();
        reservation1.setId(1);
        reservation1.setCustomerName("김예약");
        reservation1.setRestaurantName("고미정");
        reservation1.setReservationDate("2025-09-15");
        reservation1.setReservationTime("19:00");
        reservation1.setPartySize(4);
        reservation1.setStatus("CONFIRMED");
        reservations.add(reservation1);
        
        return reservations;
    }
    
    public static class Reservation {
        private int id;
        private String customerName;
        private String restaurantName;
        private String reservationDate;
        private String reservationTime;
        private int partySize;
        private String status;
        
        // Getters and Setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getCustomerName() { return customerName; }
        public void setCustomerName(String customerName) { this.customerName = customerName; }
        public String getRestaurantName() { return restaurantName; }
        public void setRestaurantName(String restaurantName) { this.restaurantName = restaurantName; }
        public String getReservationDate() { return reservationDate; }
        public void setReservationDate(String reservationDate) { this.reservationDate = reservationDate; }
        public String getReservationTime() { return reservationTime; }
        public void setReservationTime(String reservationTime) { this.reservationTime = reservationTime; }
        public int getPartySize() { return partySize; }
        public void setPartySize(int partySize) { this.partySize = partySize; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
    }
}
