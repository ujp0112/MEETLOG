package controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Restaurant;
import model.Review;
import model.Menu;
import model.Coupon;
import model.QnA;
import model.OperatingHour;
import service.RestaurantService;
import service.ReviewService;
import service.MenuService;
import service.CouponService;
import service.QnAService;
import service.OperatingHourService;

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
			if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/list")) {
				handleRestaurantList(request, response);
			} else if (pathInfo.equals("/search")) {
				handleRestaurantSearch(request, response);
			} else {
				// /123 같은 형태의 경로에서 숫자 ID를 추출
				String restaurantIdStr = pathInfo.substring(1);
				int restaurantId = Integer.parseInt(restaurantIdStr);
				fetchDetailDataAndForward(request, response, restaurantId);
			}
		} catch (NumberFormatException e) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 맛집 ID 형식입니다.");
		}
	}

	private void fetchDetailDataAndForward(HttpServletRequest request, HttpServletResponse response, int restaurantId)
			throws ServletException, IOException {
        Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
        if (restaurant == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "맛집 정보를 찾을 수 없습니다.");
            return;
        }
        
        List<Review> reviews = reviewService.getReviewsByRestaurantId(restaurantId);
        List<Menu> menus = menuService.getMenusByRestaurantId(restaurantId);
        List<Coupon> coupons = couponService.getCouponsByRestaurantId(restaurantId);
        List<QnA> qnas = qnaService.getQnAsByRestaurantId(restaurantId); // <- 수정된 메서드 이름 호출
        List<OperatingHour> operatingHours = operatingHourService.getOperatingHoursByRestaurantId(restaurantId);
        
        request.setAttribute("restaurant", restaurant);
        request.setAttribute("reviews", reviews);
        request.setAttribute("menus", menus);
        request.setAttribute("coupons", coupons);
        request.setAttribute("qnas", qnas);
        request.setAttribute("operatingHours", operatingHours);
        
        request.getRequestDispatcher("/WEB-INF/views/restaurant-detail.jsp").forward(request, response);
    }

	private void handleRestaurantSearch(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String keyword = request.getParameter("keyword");
		String category = request.getParameter("category");
		String location = request.getParameter("location");
		String priceRange = request.getParameter("priceRange");
		String parking = request.getParameter("parking");
		
		// <- 모든 파라미터를 받는 수정된 서비스 메서드 호출
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