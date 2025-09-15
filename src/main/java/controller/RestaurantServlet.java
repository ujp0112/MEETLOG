package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Restaurant;
import model.Review;
import model.Menu;
import service.RestaurantService;
import service.ReviewService;
import service.MenuService;

// [아키텍처 오류 수정] 기존 JDBC 서블릿을 삭제하고 Service 계층을 사용하는 컨트롤러로 변경합니다.
// ColumnServlet처럼 와일드카드 매핑을 사용하도록 수정합니다.
//@WebServlet("/restaurant/*") 
public class RestaurantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private RestaurantService restaurantService = new RestaurantService();
    private ReviewService reviewService = new ReviewService();
    private MenuService menuService = new MenuService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo != null && pathInfo.startsWith("/detail/")) {
                // 맛집 상세 페이지 요청 (예: /restaurant/detail/1)
                handleRestaurantDetail(request, response, pathInfo);
            } else if ("/search".equals(pathInfo)) {
                 // 맛집 검색 결과 요청
                 handleRestaurantSearch(request, response);
            } else {
                // 기본 맛집 목록 페이지 요청 (예: /restaurant 또는 /restaurant/)
                handleRestaurantList(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "맛집 페이지 처리 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }

    private void handleRestaurantDetail(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws ServletException, IOException {
        try {
            int restaurantId = Integer.parseInt(pathInfo.substring("/detail/".length()));
            
            Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
            
            if (restaurant == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "맛집 정보를 찾을 수 없습니다.");
                return;
            }

            // 상세 페이지에서 맛집 정보, 리뷰 목록, 메뉴 목록을 함께 표시
            List<Review> reviews = reviewService.getReviewsByRestaurantId(restaurantId);
            List<Menu> menus = menuService.getMenusByRestaurantId(restaurantId);

            request.setAttribute("restaurant", restaurant);
            request.setAttribute("reviews", reviews);
            request.setAttribute("menus", menus);
            
            request.getRequestDispatcher("/WEB-INF/views/restaurant-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 맛집 ID입니다.");
        }
    }
    
    private void handleRestaurantSearch(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 검색 파라미터 수집
        String keyword = request.getParameter("keyword");
        String category = request.getParameter("category");
        String location = request.getParameter("location");
        String priceRange = request.getParameter("priceRange");
        String parking = request.getParameter("parking");

        // Service를 통해 검색
        List<Restaurant> results = restaurantService.searchRestaurants(keyword, category, location, priceRange, parking);

        request.setAttribute("searchResults", results); // JSP에서 사용할 이름
        request.getRequestDispatcher("/WEB-INF/views/search-results.jsp").forward(request, response);
    }

    private void handleRestaurantList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 기본 목록: Top 20 (혹은 페이징 로직이 적용된 전체 목록)
        List<Restaurant> restaurants = restaurantService.getTopRestaurants(20); 
        request.setAttribute("restaurants", restaurants);
        request.getRequestDispatcher("/WEB-INF/views/restaurant-list.jsp").forward(request, response);
    }
}