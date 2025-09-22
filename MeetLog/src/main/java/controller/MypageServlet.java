package controller;

import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

import model.Column;
import model.Reservation;
import model.Review;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class MypageServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // 마이페이지 메인
            handleMyPageMain(request, response);
        } else if (pathInfo.equals("/reservations")) {
            // 내 예약 목록
            handleMyReservations(request, response);
        } else if (pathInfo.equals("/reviews")) {
            // 내 리뷰 목록
            handleMyReviews(request, response);
        } else if (pathInfo.equals("/columns")) {
            // 내 칼럼 목록
            handleMyColumns(request, response);
        } else if (pathInfo.equals("/settings")) {
            // 설정
            handleSettings(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    private void handleMyPageMain(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            // 사용자 정보 설정
            request.setAttribute("user", user);
            
            // 샘플 데이터
            List<Reservation> recentReservations = createSampleReservations();
            List<Review> recentReviews = createSampleReviews();
            List<Column> recentColumns = createSampleColumns();
            
            request.setAttribute("recentReservations", recentReservations);
            request.setAttribute("recentReviews", recentReviews);
            request.setAttribute("recentColumns", recentColumns);
            
            request.getRequestDispatcher("/WEB-INF/views/mypage.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "마이페이지를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private void handleMyReservations(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            List<Reservation> reservations = createSampleReservations();
            request.setAttribute("reservations", reservations);
            request.getRequestDispatcher("/WEB-INF/views/my-reservations.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "예약 목록을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private void handleMyReviews(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            List<Review> reviews = createSampleReviews();
            request.setAttribute("reviews", reviews);
            request.getRequestDispatcher("/WEB-INF/views/my-reviews.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "리뷰 목록을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private void handleMyColumns(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            List<Column> columns = createSampleColumns();
            request.setAttribute("columns", columns);
            request.getRequestDispatcher("/WEB-INF/views/my-columns.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "칼럼 목록을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private void handleSettings(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            request.getRequestDispatcher("/WEB-INF/views/settings.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "설정 페이지를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private List<Reservation> createSampleReservations() {
        List<Reservation> reservations = new ArrayList<>();
        
        Reservation reservation1 = new Reservation();
        reservation1.setId(1);
        reservation1.setRestaurantName("고미정");
        // reservation1.setReservationDate("2025-09-15");
        // reservation1.setReservationTime("19:00");
        reservation1.setPartySize(4);
        reservation1.setStatus("CONFIRMED");
        reservations.add(reservation1);
        
        return reservations;
    }
    
    private List<Review> createSampleReviews() {
        List<Review> reviews = new ArrayList<>();
        
        Review review1 = new Review();
        review1.setId(1);
        // review1.setRestaurantName("고미정");
        review1.setContent("정말 맛있어요!");
        review1.setRating(5);
        // review1.setCreatedAt("2025-09-14");
        reviews.add(review1);
        
        return reviews;
    }
    
    private List<Column> createSampleColumns() {
        List<Column> columns = new ArrayList<>();
        
        Column column1 = new Column();
        column1.setId(1);
        column1.setTitle("강남 맛집 베스트 5");
        column1.setAuthor("작성자");
        // column1.setCreatedAt("2025-09-10");
        columns.add(column1);
        
        return columns;
    }
}