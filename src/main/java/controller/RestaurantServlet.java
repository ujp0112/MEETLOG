package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Coupon;
import model.Menu;
import model.OperatingHour;
import model.QnA;
import model.Restaurant;
import model.Review;
import service.CouponService;
import service.MenuService;
import service.OperatingHourService;
import service.QnAService;
import service.RestaurantService;
import service.ReviewService;

@WebServlet("/restaurant/*")
public class RestaurantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private final RestaurantService restaurantService = new RestaurantService();
    private final ReviewService reviewService = new ReviewService();
    private final MenuService menuService = new MenuService();
    private final CouponService couponService = new CouponService();
    private final QnAService qnaService = new QnAService();
    private final OperatingHourService operatingHourService = new OperatingHourService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo != null && pathInfo.startsWith("/detail/")) {
                handleRestaurantDetail(request, response, pathInfo);
            } else if ("/detail".equals(pathInfo)) {
                handleRestaurantDetailById(request, response);
            } else if ("/search".equals(pathInfo)) {
                handleRestaurantSearch(request, response);
            } else {
                handleRestaurantList(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "맛집 페이지 처리 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }

    /**
     * 중복 로직을 처리하기 위한 공통 메소드입니다. ID를 기반으로 맛집 상세 페이지에 필요한 모든 데이터를 조회하고 JSP로 전달합니다.
     */
    private void fetchDetailDataAndForward(HttpServletRequest request, HttpServletResponse response, int restaurantId)
            throws ServletException, IOException {

        Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
        if (restaurant == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "맛집 정보를 찾을 수 없습니다.");
            return;
        }

        // 맛집 상세 페이지에 필요한 모든 정보를 각 서비스에서 가져옵니다.
        List<Review> reviews = reviewService.getReviewsByRestaurantId(restaurantId);
        List<Menu> menus = menuService.getMenusByRestaurantId(restaurantId);
        List<Coupon> coupons = couponService.getCouponsByRestaurantId(restaurantId);
        List<QnA> qnas = qnaService.getQnAByRestaurantId(restaurantId);
        // [핵심] 해당 맛집의 모든 운영 시간 정보를 가져옵니다.
        List<OperatingHour> operatingHours = operatingHourService.getOperatingHoursByRestaurantId(restaurantId);

        // 조회된 모든 정보를 request 객체에 담습니다.
        request.setAttribute("restaurant", restaurant);
        request.setAttribute("reviews", reviews);
        request.setAttribute("menus", menus);
        request.setAttribute("coupons", coupons);
        request.setAttribute("qnas", qnas);
        // [핵심] 운영 시간 정보도 request에 담아 JSP로 전달합니다.
        request.setAttribute("operatingHours", operatingHours);

        // 최종적으로 JSP 페이지로 포워딩합니다.
        request.getRequestDispatcher("/WEB-INF/views/restaurant-detail.jsp").forward(request, response);
    }

    private void handleRestaurantDetail(HttpServletRequest request, HttpServletResponse response, String pathInfo)
            throws ServletException, IOException {
        try {
            // URL 경로에서 ID를 추출합니다. (예: /restaurant/detail/71 -> 71)
            int restaurantId = Integer.parseInt(pathInfo.substring("/detail/".length()));
            fetchDetailDataAndForward(request, response, restaurantId);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 맛집 ID 형식입니다.");
        }
    }

    private void handleRestaurantDetailById(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // URL 파라미터에서 ID를 추출합니다. (예: /restaurant/detail?id=71 -> 71)
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "맛집 ID가 필요합니다.");
                return;
            }
            int restaurantId = Integer.parseInt(idParam);
            fetchDetailDataAndForward(request, response, restaurantId);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 맛집 ID 형식입니다.");
        }
    }
    
    private void handleRestaurantSearch(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String category = request.getParameter("category");
        String location = request.getParameter("location");
        String priceRange = request.getParameter("priceRange");
        String parking = request.getParameter("parking");

        // 검색 파라미터를 Map으로 구성
        java.util.Map<String, Object> searchParams = new java.util.HashMap<>();
        if (keyword != null && !keyword.trim().isEmpty()) searchParams.put("keyword", keyword);
        if (category != null && !category.trim().isEmpty()) searchParams.put("category", category);
        if (location != null && !location.trim().isEmpty()) searchParams.put("location", location);
        if (priceRange != null && !priceRange.trim().isEmpty()) searchParams.put("priceRange", priceRange);
        if (parking != null && !parking.trim().isEmpty()) searchParams.put("parking", parking);

        List<Restaurant> results = restaurantService.searchRestaurants(searchParams);

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