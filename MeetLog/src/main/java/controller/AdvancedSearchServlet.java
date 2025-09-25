package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import model.User;
import model.Restaurant;
import model.Review;
import model.Reservation;
import service.RestaurantService;
import service.ReviewService;
import service.ReservationService;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;

@WebServlet("/search")
public class AdvancedSearchServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 로그인하지 않아도 검색 페이지는 접근 가능하게 변경
        String type = request.getParameter("type");
        if (type == null) {
            type = "restaurants";
        }

        request.setAttribute("searchType", type);
        request.setAttribute("user", user); // 사용자 정보를 JSP에 전달 (null일 수 있음)
        request.getRequestDispatcher("/WEB-INF/views/advanced-search.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        String type = request.getParameter("type");

        // 개인 정보가 필요한 검색(리뷰, 예약)은 로그인 필수
        if (("reviews".equals(type) || "reservations".equals(type)) && user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Map<String, Object> searchParams = new HashMap<>();

        // 공통 검색 파라미터
        if (user != null) {
            searchParams.put("userId", user.getId());
        }
        searchParams.put("keyword", request.getParameter("keyword"));
        searchParams.put("startDate", request.getParameter("startDate"));
        searchParams.put("endDate", request.getParameter("endDate"));

        try {
            if ("restaurants".equals(type)) {
                searchRestaurants(request, response, searchParams);
            } else if ("reviews".equals(type)) {
                searchReviews(request, response, searchParams);
            } else if ("reservations".equals(type)) {
                searchReservations(request, response, searchParams);
            } else {
                response.sendRedirect(request.getContextPath() + "/search");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "검색 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private void searchRestaurants(HttpServletRequest request, HttpServletResponse response, 
                                 Map<String, Object> searchParams) throws ServletException, IOException {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisSqlSessionFactory.getSqlSession();
            RestaurantService restaurantService = new RestaurantService();
            
            // 추가 검색 파라미터
            searchParams.put("category", request.getParameter("category"));
            searchParams.put("location", request.getParameter("location"));
            searchParams.put("minRating", request.getParameter("minRating"));
            searchParams.put("maxRating", request.getParameter("maxRating"));
            
            List<Restaurant> restaurants = restaurantService.searchRestaurants(searchParams);
            
            request.setAttribute("searchResults", restaurants);
            request.setAttribute("searchType", "restaurants");
            request.setAttribute("searchParams", searchParams);
            
            request.getRequestDispatcher("/WEB-INF/views/advanced-search.jsp").forward(request, response);
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }
    
    private void searchReviews(HttpServletRequest request, HttpServletResponse response, 
                             Map<String, Object> searchParams) throws ServletException, IOException {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisSqlSessionFactory.getSqlSession();
            ReviewService reviewService = new ReviewService();
            
            // 추가 검색 파라미터
            searchParams.put("minRating", request.getParameter("minRating"));
            searchParams.put("maxRating", request.getParameter("maxRating"));
            searchParams.put("restaurantId", request.getParameter("restaurantId"));
            
            List<Review> reviews = reviewService.searchReviews(searchParams);
            
            request.setAttribute("searchResults", reviews);
            request.setAttribute("searchType", "reviews");
            request.setAttribute("searchParams", searchParams);
            
            request.getRequestDispatcher("/WEB-INF/views/advanced-search.jsp").forward(request, response);
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }
    
    private void searchReservations(HttpServletRequest request, HttpServletResponse response, 
                                  Map<String, Object> searchParams) throws ServletException, IOException {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisSqlSessionFactory.getSqlSession();
            ReservationService reservationService = new ReservationService();
            
            // 추가 검색 파라미터
            searchParams.put("status", request.getParameter("status"));
            searchParams.put("restaurantId", request.getParameter("restaurantId"));
            searchParams.put("customerName", request.getParameter("customerName"));
            
            List<Reservation> reservations = reservationService.searchReservations(searchParams);
            
            request.setAttribute("searchResults", reservations);
            request.setAttribute("searchType", "reservations");
            request.setAttribute("searchParams", searchParams);
            
            request.getRequestDispatcher("/WEB-INF/views/advanced-search.jsp").forward(request, response);
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }

}
