package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import model.User;
import model.Restaurant;
import model.Review;
import model.Reservation;
import service.RestaurantService;
import service.ReviewService;
import service.ReservationService;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;

@WebServlet("/export")
public class ExportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String type = request.getParameter("type");
        String format = request.getParameter("format");
        
        if (type == null || format == null) {
            response.sendRedirect(request.getContextPath() + "/business/dashboard");
            return;
        }
        
        try {
            if ("restaurants".equals(type)) {
                exportRestaurants(user, response, format);
            } else if ("reviews".equals(type)) {
                exportReviews(user, response, format);
            } else if ("reservations".equals(type)) {
                exportReservations(user, response, format);
            } else {
                response.sendRedirect(request.getContextPath() + "/business/dashboard");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/business/dashboard?error=export_failed");
        }
    }
    
    private void exportRestaurants(User user, HttpServletResponse response, String format) 
            throws IOException {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisSqlSessionFactory.getSqlSession();
            RestaurantService restaurantService = new RestaurantService();
            List<Restaurant> restaurants = restaurantService.getRestaurantsByOwnerId(user.getId());
            
            if ("csv".equals(format)) {
                exportRestaurantsCSV(restaurants, response);
            } else if ("excel".equals(format)) {
                exportRestaurantsExcel(restaurants, response);
            }
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }
    
    private void exportReviews(User user, HttpServletResponse response, String format) 
            throws IOException {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisSqlSessionFactory.getSqlSession();
            ReviewService reviewService = new ReviewService();
            List<Review> reviews = reviewService.getRecentReviewsByOwnerId(user.getId(), 1000);
            
            if ("csv".equals(format)) {
                exportReviewsCSV(reviews, response);
            } else if ("excel".equals(format)) {
                exportReviewsExcel(reviews, response);
            }
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }
    
    private void exportReservations(User user, HttpServletResponse response, String format) 
            throws IOException {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisSqlSessionFactory.getSqlSession();
            RestaurantService restaurantService = new RestaurantService();
            ReservationService reservationService = new ReservationService();
            
            List<Restaurant> restaurants = restaurantService.getRestaurantsByOwnerId(user.getId());
            List<Reservation> allReservations = new java.util.ArrayList<>();
            
            for (Restaurant restaurant : restaurants) {
                List<Reservation> reservations = reservationService.getReservationsByRestaurantId(restaurant.getId());
                allReservations.addAll(reservations);
            }
            
            if ("csv".equals(format)) {
                exportReservationsCSV(allReservations, response);
            } else if ("excel".equals(format)) {
                exportReservationsExcel(allReservations, response);
            }
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }
    
    private void exportRestaurantsCSV(List<Restaurant> restaurants, HttpServletResponse response) 
            throws IOException {
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=restaurants.csv");
        
        PrintWriter writer = response.getWriter();
        writer.println("ID,이름,카테고리,지역,주소,전화번호,영업시간,설명,평점,리뷰수,좋아요수,등록일");
        
        for (Restaurant restaurant : restaurants) {
            writer.printf("%d,\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",%.1f,%d,%d,%s%n",
                restaurant.getId(),
                restaurant.getName(),
                restaurant.getCategory(),
                restaurant.getLocation(),
                restaurant.getAddress(),
                restaurant.getPhone(),
                restaurant.getHours(),
                restaurant.getDescription(),
                restaurant.getRating(),
                restaurant.getReviewCount(),
                restaurant.getLikes(),
                restaurant.getCreatedAt()
            );
        }
    }
    
    private void exportReviewsCSV(List<Review> reviews, HttpServletResponse response) 
            throws IOException {
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=reviews.csv");
        
        PrintWriter writer = response.getWriter();
        writer.println("ID,음식점명,작성자,평점,내용,맛평점,서비스평점,분위기평점,가격평점,좋아요수,작성일");
        
        for (Review review : reviews) {
            writer.printf("%d,\"%s\",\"%s\",%d,\"%s\",%d,%d,%d,%d,%d,%s%n",
                review.getId(),
                review.getRestaurantName(),
                review.getAuthor(),
                review.getRating(),
                review.getContent(),
                review.getTasteRating(),
                review.getServiceRating(),
                review.getAtmosphereRating(),
                review.getPriceRating(),
                review.getLikes(),
                review.getCreatedAt()
            );
        }
    }
    
    private void exportReservationsCSV(List<Reservation> reservations, HttpServletResponse response) 
            throws IOException {
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=reservations.csv");
        
        PrintWriter writer = response.getWriter();
        writer.println("ID,음식점명,고객명,고객연락처,예약일,예약시간,인원,특별요청,상태,예약일시");
        
        for (Reservation reservation : reservations) {
            writer.printf("%d,\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",%d,\"%s\",\"%s\",%s%n",
                reservation.getId(),
                reservation.getRestaurantName(),
                reservation.getCustomerName(),
                reservation.getCustomerPhone(),
                reservation.getReservationDate(),
                reservation.getReservationTime(),
                reservation.getPartySize(),
                reservation.getSpecialRequests(),
                reservation.getStatus(),
                reservation.getCreatedAt()
            );
        }
    }
    
    private void exportRestaurantsExcel(List<Restaurant> restaurants, HttpServletResponse response) 
            throws IOException {
        // Excel 내보내기는 Apache POI 라이브러리가 필요합니다
        // 현재는 CSV로 대체합니다
        exportRestaurantsCSV(restaurants, response);
    }
    
    private void exportReviewsExcel(List<Review> reviews, HttpServletResponse response) 
            throws IOException {
        // Excel 내보내기는 Apache POI 라이브러리가 필요합니다
        // 현재는 CSV로 대체합니다
        exportReviewsCSV(reviews, response);
    }
    
    private void exportReservationsExcel(List<Reservation> reservations, HttpServletResponse response) 
            throws IOException {
        // Excel 내보내기는 Apache POI 라이브러리가 필요합니다
        // 현재는 CSV로 대체합니다
        exportReservationsCSV(reservations, response);
    }
}
