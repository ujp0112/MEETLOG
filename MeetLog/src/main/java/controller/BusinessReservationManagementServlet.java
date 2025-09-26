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
            List<Restaurant> myRestaurants = restaurantService.findByOwnerId(user.getId());
            
            // 예약 서비스 초기화
            ReservationService reservationService = new ReservationService();
            
//            // 각 음식점의 예약 목록 가져오기
//            for (Restaurant restaurant : myRestaurants) {
//                List<Reservation> reservations = reservationService.getReservationsByRestaurantId(restaurant.getId());
//                // Restaurant 모델에 setReservationList 메서드가 없다면 주석 처리
//                // restaurant.setReservationList(reservations);
//            }
//            
            
         // --- ▼▼▼ [수정] 각 음식점 객체에 예약 목록을 직접 저장 ▼▼▼ ---
            for (Restaurant restaurant : myRestaurants) {
                List<Reservation> reservations = reservationService.getReservationsByRestaurantId(restaurant.getId());
                restaurant.setReservationList(reservations); // Restaurant 객체에 예약 리스트 설정
            }
            
            // 예약 통계 계산
            int totalReservations = 0;
            int pendingReservations = 0;
            int confirmedReservations = 0;
            int cancelledReservations = 0;
            
            for (Restaurant restaurant : myRestaurants) {
                List<Reservation> reservations = reservationService.getReservationsByRestaurantId(restaurant.getId());
                if (reservations != null) {
                    totalReservations += reservations.size();
                    for (Reservation reservation : reservations) {
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
    
}