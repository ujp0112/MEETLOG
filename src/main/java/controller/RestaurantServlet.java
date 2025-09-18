package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Coupon;
import model.Menu;
import model.QnA;
import model.Restaurant;
import model.Review;
import service.CouponService;
import service.MenuService;
import service.QnAService;
import service.RestaurantService;
import service.ReviewService;


public class RestaurantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private final RestaurantService restaurantService = new RestaurantService();
    private final ReviewService reviewService = new ReviewService();
    private final MenuService menuService = new MenuService();
    private final CouponService couponService = new CouponService();
    private final QnAService qnaService = new QnAService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            // [개선] /detail 로 시작하는 모든 경로를 하나의 핸들러로 처리
            if (pathInfo != null && pathInfo.startsWith("/detail")) {
                handleRestaurantDetail(request, response);
            } else if ("/search".equals(pathInfo)) {
                handleRestaurantSearch(request, response);
            } else {
                handleRestaurantList(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "요청 처리 중 오류가 발생했습니다: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }

    /**
     * [개선] 중복되던 두 개의 상세 페이지 핸들러를 하나로 통합합니다.
     * Path Variable 방식(예: /detail/1)과 Query Parameter 방식(예: /detail?id=1)을 모두 지원합니다.
     */
    private void handleRestaurantDetail(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idStr = null;
        String pathInfo = request.getPathInfo();

        // 1. Path Variable 방식에서 ID 추출
        if (pathInfo != null && pathInfo.matches("/detail/\\d+")) {
            idStr = pathInfo.substring("/detail/".length());
        }
        
        // 2. Path Variable에 ID가 없으면 Query Parameter 방식에서 ID 추출
        if (idStr == null) {
            idStr = request.getParameter("id");
        }
        
        // ID 값이 없는 경우 에러 처리
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "맛집 ID가 필요합니다.");
            return;
        }

        try {
            int restaurantId = Integer.parseInt(idStr);
            Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);

            if (restaurant == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "맛집 정보를 찾을 수 없습니다.");
                return;
            }

            // [개선] 관련 데이터를 각각의 request attribute로 설정하는 대신, Restaurant 객체에 모두 담아서 전달합니다.
            // 이는 JSP에서의 데이터 접근을 일관성 있게 만들고, 컨트롤러의 역할을 명확하게 합니다.
            List<Review> reviews = reviewService.getReviewsByRestaurantId(restaurantId);
            List<Menu> menus = menuService.getMenusByRestaurantId(restaurantId);
            List<Coupon> coupons = couponService.getCouponsByRestaurantId(restaurantId);
            List<QnA> qnas = qnaService.getQnAByRestaurantId(restaurantId);

            restaurant.setReviews(reviews);
            restaurant.setMenuList(menus);
            restaurant.setCoupons(coupons);
            restaurant.setQna(qnas);
            
            // JSP에는 모든 정보가 담긴 'restaurant' 객체 하나만 전달
            request.setAttribute("restaurant", restaurant);
            
            // JSP 파일에서는 이제 'reviews', 'menus' 대신 'restaurant.reviews', 'restaurant.menuList' 등으로 접근해야 합니다.
            request.getRequestDispatcher("/WEB-INF/views/restaurant-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 형식의 맛집 ID입니다.");
        }
    }
    
    private void handleRestaurantSearch(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String category = request.getParameter("category");
        String location = request.getParameter("location");
        String priceRange = request.getParameter("priceRange");
        String parking = request.getParameter("parking");

        List<Restaurant> results = restaurantService.searchRestaurants(keyword, category, location, priceRange, parking);

        request.setAttribute("searchResults", results);
        request.getRequestDispatcher("/WEB-INF/views/search-results.jsp").forward(request, response);
    }

    private void handleRestaurantList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Restaurant> restaurants = restaurantService.getTopRestaurants(20);
        request.setAttribute("restaurants", restaurants);
        request.getRequestDispatcher("/WEB-INF/views/restaurant-list.jsp").forward(request, response);
    }
}