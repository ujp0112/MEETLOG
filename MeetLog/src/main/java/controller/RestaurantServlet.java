package controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

/**
 * 맛집 관련 요청을 처리하는 서블릿
 * - /restaurant/list : 맛집 목록 조회 (검색/필터/페이징 포함)
 * - /restaurant/detail?id={id} : 맛집 상세 정보 조회
 * - /restaurant/{id} : 맛집 상세 정보 조회 (RESTful URL)
 */
@WebServlet("/restaurant/*")
public class RestaurantServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private RestaurantService restaurantService = new RestaurantService();
	private ReviewService reviewService = new ReviewService();
	private MenuService menuService = new MenuService();
	private CouponService couponService = new CouponService();
	private QnAService qnaService = new QnAService();
	private OperatingHourService operatingHourService = new OperatingHourService();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
	    String pathInfo = request.getPathInfo();

	    try {
            // 목록 조회 (/restaurant/ 또는 /restaurant/list)
	        if (pathInfo == null || pathInfo.equals("/") || "/list".equals(pathInfo)) {
	            handleRestaurantList(request, response);
            
            // 상세 조회 (/restaurant/detail?id=123 또는 /restaurant/123)
	        } else {
                String restaurantIdStr = null;
                if ("/detail".equals(pathInfo)) {
                    // 파라미터에서 ID 추출: /restaurant/detail?id=123
                    restaurantIdStr = request.getParameter("id");
                } else {
                    // 경로에서 ID 추출: /restaurant/123
                    restaurantIdStr = pathInfo.substring(1);
                }

                if (restaurantIdStr == null || restaurantIdStr.isEmpty()) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "맛집 ID가 필요합니다.");
                    return;
                }
	            
	            int restaurantId = Integer.parseInt(restaurantIdStr);
	            fetchDetailDataAndForward(request, response, restaurantId);
	        }
	    } catch (NumberFormatException e) {
	        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 맛집 ID 형식입니다.");
	    }
	}

	/**
	 * 맛집 목록 조회, 검색, 필터링, 페이징을 모두 처리하는 통합 메소드
	 */
	private void handleRestaurantList(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		// 1. 요청 파라미터(필터 조건 및 페이지 번호) 가져오기
		String keyword = request.getParameter("keyword");
		String category = request.getParameter("category");
		String location = request.getParameter("location");
		String price = request.getParameter("price");
		String parking = request.getParameter("parking");
		String sortBy = request.getParameter("sortBy");
		String pageStr = request.getParameter("page");
		
		int page = (pageStr == null || pageStr.isEmpty()) ? 1 : Integer.parseInt(pageStr);
		int pageSize = 12; // 한 페이지에 보여주는 맛집 갯수
		int offset = (page - 1) * pageSize;

		// 2. 서비스 메소드에 전달할 파라미터 맵(Map) 생성
		Map<String, Object> params = new HashMap<>();
		params.put("keyword", keyword);
		params.put("category", category);
		params.put("location", location);
		params.put("price", price);
		params.put("parking", parking);
		params.put("sortBy", sortBy);
		params.put("limit", pageSize);
		params.put("offset", offset);

		// 3. 서비스 레이어를 통해 데이터 조회
		List<Restaurant> restaurants = restaurantService.getPaginatedRestaurants(params);
		int totalRestaurants = restaurantService.getRestaurantCount(params);
		
		// 4. 전체 페이지 수 계산
		int totalPages = (int) Math.ceil((double) totalRestaurants / pageSize);

		// 5. 조회된 데이터를 JSP로 전달하기 위해 request 객체에 저장
		request.setAttribute("restaurants", restaurants);
		request.setAttribute("currentPage", page);
		request.setAttribute("totalPages", totalPages);
		
		// 6. 사용자가 선택한 필터 값을 JSP에 다시 전달 (검색창의 상태를 유지하기 위함)
		request.setAttribute("selectedKeyword", keyword);
		request.setAttribute("selectedCategory", category);
		request.setAttribute("selectedLocation", location);
		request.setAttribute("selectedPrice", price);
		request.setAttribute("selectedParking", parking);
		request.setAttribute("selectedSortBy", sortBy);
		
		// 7. restaurant-list.jsp로 포워딩
		request.getRequestDispatcher("/WEB-INF/views/restaurant-list.jsp").forward(request, response);
	}
    
	/**
	 * 특정 맛집의 상세 정보 및 관련 데이터(리뷰, 메뉴 등)를 조회하고 JSP로 전달하는 메소드
	 */
	private void fetchDetailDataAndForward(HttpServletRequest request, HttpServletResponse response, int restaurantId)
			throws ServletException, IOException {
        Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
        if (restaurant == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "맛집 정보를 찾을 수 없습니다.");
            return;
        }
        
        // 맛집과 관련된 모든 정보(리뷰, 메뉴, 쿠폰 등)를 조회
        List<Review> reviews = reviewService.getReviewsByRestaurantId(restaurantId);
        List<Menu> menus = menuService.getMenusByRestaurantId(restaurantId);
        List<Coupon> coupons = couponService.getCouponsByRestaurantId(restaurantId);
        List<QnA> qnas = qnaService.getQnAsByRestaurantId(restaurantId);
        List<OperatingHour> operatingHours = operatingHourService.getOperatingHoursByRestaurantId(restaurantId);
        
        // 조회된 모든 데이터를 request 객체에 저장
        request.setAttribute("restaurant", restaurant);
        request.setAttribute("reviews", reviews);
        request.setAttribute("menus", menus);
        request.setAttribute("coupons", coupons);
        request.setAttribute("qnas", qnas);
        request.setAttribute("operatingHours", operatingHours);
        
        // restaurant-detail.jsp로 포워딩
        request.getRequestDispatcher("/WEB-INF/views/restaurant-detail.jsp").forward(request, response);
    }
}