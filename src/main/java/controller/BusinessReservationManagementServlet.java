package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import model.User;
import model.Restaurant;
import model.Reservation;
import service.RestaurantService;
import service.ReservationService;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;

@WebServlet("/business/reservation-management")
public class BusinessReservationManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        SqlSession sqlSession = null;
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            if (user == null || !"BUSINESS".equals(user.getUserType())) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            
            sqlSession = MyBatisSqlSessionFactory.getSqlSession();
            
            // 비즈니스 사용자의 음식점 목록 가져오기
            RestaurantService restaurantService = new RestaurantService();
            List<Restaurant> myRestaurants = restaurantService.getRestaurantsByOwnerId(user.getId());
            
            // 예약 서비스 초기화
            ReservationService reservationService = new ReservationService();
            
            // 각 음식점의 예약 목록 가져오기
            for (Restaurant restaurant : myRestaurants) {
                List<Reservation> reservations = reservationService.getReservationsByRestaurantId(restaurant.getId());
                restaurant.setReservationList(reservations);
            }
            
            // 예약 통계 계산
            int totalReservations = 0;
            int pendingReservations = 0;
            int confirmedReservations = 0;
            int cancelledReservations = 0;
            
            for (Restaurant restaurant : myRestaurants) {
                if (restaurant.getReservationList() != null) {
                    totalReservations += restaurant.getReservationList().size();
                    for (Reservation reservation : restaurant.getReservationList()) {
                        switch (reservation.getStatus()) {
                            case "PENDING":
                                pendingReservations++;
                                break;
                            case "CONFIRMED":
                                confirmedReservations++;
                                break;
                            case "CANCELLED":
                                cancelledReservations++;
                                break;
                        }
                    }
                }
            }
            
            request.setAttribute("myRestaurants", myRestaurants);
            request.setAttribute("totalReservations", totalReservations);
            request.setAttribute("pendingReservations", pendingReservations);
            request.setAttribute("confirmedReservations", confirmedReservations);
            request.setAttribute("cancelledReservations", cancelledReservations);
            request.getRequestDispatcher("/WEB-INF/views/business/reservation-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "예약 관리 페이지를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }
    
    private List<Reservation> createSampleReservations() {
        List<Reservation> reservations = new ArrayList<>();
        
        Reservation reservation1 = new Reservation();
        reservation1.setId(1);
        reservation1.setRestaurantName("고미정");
        reservation1.setCustomerName("김고객");
        reservation1.setCustomerPhone("010-1234-5678");
        reservation1.setReservationDate("2025-09-20");
        reservation1.setReservationTime("19:00");
        reservation1.setPartySize(4);
        reservation1.setStatus("PENDING");
        reservation1.setSpecialRequests("창가 자리 부탁드립니다");
        reservations.add(reservation1);
        
        Reservation reservation2 = new Reservation();
        reservation2.setId(2);
        reservation2.setRestaurantName("고미정");
        reservation2.setCustomerName("이고객");
        reservation2.setCustomerPhone("010-9876-5432");
        reservation2.setReservationDate("2025-09-20");
        reservation2.setReservationTime("20:30");
        reservation2.setPartySize(2);
        reservation2.setStatus("CONFIRMED");
        reservation2.setSpecialRequests("");
        reservations.add(reservation2);
        
        return reservations;
    }
    
    // 예약 클래스
    public static class Reservation {
        private int id;
        private String restaurantName;
        private String customerName;
        private String customerPhone;
        private String reservationDate;
        private String reservationTime;
        private int partySize;
        private String status;
        private String specialRequests;
        
        // Getters and Setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getRestaurantName() { return restaurantName; }
        public void setRestaurantName(String restaurantName) { this.restaurantName = restaurantName; }
        public String getCustomerName() { return customerName; }
        public void setCustomerName(String customerName) { this.customerName = customerName; }
        public String getCustomerPhone() { return customerPhone; }
        public void setCustomerPhone(String customerPhone) { this.customerPhone = customerPhone; }
        public String getReservationDate() { return reservationDate; }
        public void setReservationDate(String reservationDate) { this.reservationDate = reservationDate; }
        public String getReservationTime() { return reservationTime; }
        public void setReservationTime(String reservationTime) { this.reservationTime = reservationTime; }
        public int getPartySize() { return partySize; }
        public void setPartySize(int partySize) { this.partySize = partySize; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        public String getSpecialRequests() { return specialRequests; }
        public void setSpecialRequests(String specialRequests) { this.specialRequests = specialRequests; }
    }
}