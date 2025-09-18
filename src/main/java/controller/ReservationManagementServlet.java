package controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import model.User;


public class ReservationManagementServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            if (user == null || !"BUSINESS".equals(user.getUserType())) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            
            // 비즈니스 사용자가 음식점과 연결되어 있는지 확인
            if (user.getRestaurantId() == null) {
                response.sendRedirect(request.getContextPath() + "/business/register");
                return;
            }
            
            List<Reservation> reservations = createSampleReservations();
            request.setAttribute("reservations", reservations);
            
            request.getRequestDispatcher("/WEB-INF/views/business-reservation-management.jsp").forward(request, response);
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
        reservation1.setReservationTime("2025-09-15 19:00");
        reservation1.setPartySize(4);
        reservation1.setStatus("CONFIRMED");
        reservations.add(reservation1);
        
        Reservation reservation2 = new Reservation();
        reservation2.setId(2);
        reservation2.setCustomerName("이고객");
        reservation2.setRestaurantName("고미정");
        reservation2.setReservationTime("2025-09-16 18:30");
        reservation2.setPartySize(2);
        reservation2.setStatus("PENDING");
        reservations.add(reservation2);
        
        Reservation reservation3 = new Reservation();
        reservation3.setId(3);
        reservation3.setCustomerName("박손님");
        reservation3.setRestaurantName("고미정");
        reservation3.setReservationTime("2025-09-17 20:00");
        reservation3.setPartySize(6);
        reservation3.setStatus("COMPLETED");
        reservations.add(reservation3);
        
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
