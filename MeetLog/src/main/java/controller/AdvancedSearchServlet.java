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
import model.Column;
import service.RestaurantService;
import service.ReviewService;
import service.ReservationService;
import service.ColumnService;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;

@WebServlet("/search")
public class AdvancedSearchServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;

        String type = request.getParameter("type");
        if (type == null || type.isBlank()) {
            type = "restaurants";
        }
        boolean submitted = "true".equalsIgnoreCase(request.getParameter("submitted"));

        Map<String, Object> searchParams = new HashMap<>();
        if (user != null) {
            searchParams.put("userId", user.getId());
        }
        searchParams.put("keyword", request.getParameter("keyword"));
        searchParams.put("startDate", request.getParameter("startDate"));
        searchParams.put("endDate", request.getParameter("endDate"));

        if ("restaurants".equals(type) && submitted) {
            searchRestaurants(request, response, searchParams);
            return;
        }

        request.setAttribute("searchType", type);
        request.setAttribute("searchParams", searchParams);
        request.setAttribute("user", user);
        request.setAttribute("submitted", submitted);
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
            } else if ("columns".equals(type)) {
                searchColumns(request, response, searchParams);
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
                                   Map<String, Object> baseParams) throws ServletException, IOException {
        RestaurantService restaurantService = new RestaurantService();

        String category = request.getParameter("category");
        String location = request.getParameter("location");
        String price = request.getParameter("price");
        String parking = request.getParameter("parking");
        String sortBy = request.getParameter("sortBy");

        String pageStr = request.getParameter("page");
        int page = 1;
        if (pageStr != null && !pageStr.isBlank()) {
            try {
                page = Math.max(1, Integer.parseInt(pageStr));
            } catch (NumberFormatException ignore) {
                page = 1;
            }
        }
        int pageSize = 12;
        int offset = (page - 1) * pageSize;

        Map<String, Object> dbParams = new HashMap<>(baseParams);
        dbParams.put("category", category);
        dbParams.put("location", location);
        dbParams.put("price", price);
        dbParams.put("parking", parking);
        dbParams.put("sortBy", sortBy);
        dbParams.put("limit", pageSize);
        dbParams.put("offset", offset);

        List<Restaurant> restaurants = restaurantService.getPaginatedRestaurants(dbParams);
        int totalRestaurants = restaurantService.getRestaurantCount(dbParams);
        int totalPages = (int) Math.ceil((double) totalRestaurants / pageSize);

        Map<String, Object> viewParams = new HashMap<>();
        viewParams.put("keyword", baseParams.get("keyword"));
        viewParams.put("category", category);
        viewParams.put("location", location);
        viewParams.put("price", price);
        viewParams.put("parking", parking);
        viewParams.put("sortBy", sortBy);

        request.setAttribute("restaurants", restaurants);
        request.setAttribute("totalResults", totalRestaurants);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("searchParams", viewParams);
        request.setAttribute("searchType", "restaurants");
        request.setAttribute("submitted", true);

        request.getRequestDispatcher("/WEB-INF/views/advanced-search.jsp").forward(request, response);
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
            request.setAttribute("submitted", true);
            
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
            request.setAttribute("submitted", true);
            
            request.getRequestDispatcher("/WEB-INF/views/advanced-search.jsp").forward(request, response);
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }

    private void searchColumns(HttpServletRequest request, HttpServletResponse response,
                               Map<String, Object> searchParams) throws ServletException, IOException {
        ColumnService columnService = new ColumnService();
        List<Column> columns = columnService.searchColumns(searchParams);
        request.setAttribute("searchResults", columns);
        request.setAttribute("searchType", "columns");
        request.setAttribute("searchParams", searchParams);
        request.setAttribute("submitted", true);
        request.getRequestDispatcher("/WEB-INF/views/advanced-search.jsp").forward(request, response);
    }

}
