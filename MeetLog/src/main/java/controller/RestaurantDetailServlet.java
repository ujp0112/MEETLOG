package controller;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Coupon;
import model.Menu;
import model.OperatingHour;
import model.QnA;
import model.Restaurant;
import model.Review;
import model.User;
import service.CouponService;
import service.MenuService;
import service.OperatingHourService;
import service.QnAService;
import service.RestaurantService;
import service.ReviewService;

@WebServlet("/restaurant/detail/*")
public class RestaurantDetailServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final Logger logger = Logger.getLogger(RestaurantDetailServlet.class.getName());

	private RestaurantService restaurantService = new RestaurantService();
	private MenuService menuService = new MenuService();
	private ReviewService reviewService = new ReviewService();
	private CouponService couponService = new CouponService();
	private QnAService qnaService = new QnAService();
	private OperatingHourService operatingHourService = new OperatingHourService();

	private int extractRestaurantId(String pathInfo) throws NumberFormatException {
		if (pathInfo == null || pathInfo.length() <= 1) {
			throw new NumberFormatException("pathInfo가 null이거나 비어있음");
		}

		// "/11" -> "11" 추출
		String idString = pathInfo.substring(1);

		// 숫자만 허용
		if (!idString.matches("\\d+")) {
			throw new NumberFormatException("ID가 숫자가 아님: " + idString);
		}

		return Integer.parseInt(idString);
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		logger.info("RestaurantDetailServlet 요청 처리 시작");

		String pathInfo = request.getPathInfo();
		logger.info("RestaurantDetailServlet 요청 처리 시작 - pathInfo: " + pathInfo);

		try {
			int restaurantId = extractRestaurantId(pathInfo);

			Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
			if (restaurant == null) {
				logger.warning("ID에 해당하는 레스토랑을 찾을 수 없음: " + restaurantId);
				response.sendError(HttpServletResponse.SC_NOT_FOUND, "해당 레스토랑 정보를 찾을 수 없습니다.");
				return;
			}

			List<Menu> menus = menuService.getMenusByRestaurantId(restaurantId);
			List<Review> reviews = reviewService.getReviewsByRestaurantId(restaurantId);
			List<Coupon> coupons = couponService.getCouponsByRestaurantId(restaurantId);
			List<QnA> qnas = qnaService.getQnAsByRestaurantId(restaurantId);
			List<OperatingHour> operatingHours = operatingHourService.getOperatingHoursByRestaurantId(restaurantId);

			boolean isOwner = checkIfOwner(request, restaurant);

			// ======================== [ ✨ 수정된 부분 시작 ✨ ] ========================

			// JSP 뷰를 위한 리뷰 데이터 가공
			List<Review> reviewsForJsp = new ArrayList<>();
			for (Review review : reviews) {
				Map<String, Object> reviewData = new HashMap<>();

				// 기존 리뷰의 모든 정보를 Map에 복사
//				reviewData.put(review);
				reviewsForJsp.add(review);

				// LocalDateTime을 java.util.Date 객체로 변환하여 저장
				if (review.getCreatedAt() != null) {
					Date createdAtAsDate = java.sql.Timestamp.valueOf(review.getCreatedAt());
					reviewData.put("createdAt", createdAtAsDate);
				} else {
					reviewData.put("createdAt", null);
				}

				
			}

			// 기존 reviews 대신 가공된 reviewsForJsp를 setRequestAttributes에 전달
			setRequestAttributes(request, restaurant, menus, reviewsForJsp, coupons, qnas, operatingHours, isOwner);

			request.getRequestDispatcher("/WEB-INF/views/restaurant-detail.jsp").forward(request, response);
			logger.info("레스토랑 상세 페이지로 성공적으로 포워딩: " + restaurant.getName());

		} catch (NumberFormatException e) {
			logger.log(Level.WARNING, "올바르지 않은 맛집 ID 형식입니다. 파라미터 값: " + request.getParameter("id"), e);
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 맛집 ID 형식입니다.");
		} catch (Exception e) {
			logger.log(Level.SEVERE, "레스토랑 상세 정보 조회 중 심각한 오류 발생", e);
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "서버 내부 오류가 발생했습니다.");
		}
	}

	private boolean checkIfOwner(HttpServletRequest request, Restaurant restaurant) {
		try {
			HttpSession session = request.getSession(false);
			if (session == null || session.getAttribute("user") == null) {
				return false;
			}

			User user = (User) session.getAttribute("user");
			boolean isOwner = user.getId() == restaurant.getOwnerId() && "BUSINESS".equals(user.getUserType());

			logger.info("소유자 확인 - 사용자 ID: " + user.getId() + ", 소유자 ID: " + restaurant.getOwnerId() + ", 소유자 여부: "
					+ isOwner);
			return isOwner;

		} catch (Exception e) {
			logger.log(Level.WARNING, "소유자 확인 중 오류", e);
			return false;
		}
	}

	private void setRequestAttributes(HttpServletRequest request, Restaurant restaurant, List<Menu> menus,
			List<Review> reviews, List<Coupon> coupons, List<QnA> qnas, List<OperatingHour> operatingHours,
			boolean isOwner) {

		request.setAttribute("restaurant", restaurant);
		request.setAttribute("menus", menus);
		request.setAttribute("reviews", reviews);
		request.setAttribute("coupons", coupons);
		request.setAttribute("qnas", qnas);
		request.setAttribute("operatingHours", operatingHours);
		request.setAttribute("isOwner", isOwner);

		request.setAttribute("menuCount", menus.size());
		request.setAttribute("reviewCount", reviews.size());
		request.setAttribute("couponCount", coupons.size());
		request.setAttribute("qnaCount", qnas.size());

		logger.info("Request 속성 설정 완료 - 메뉴: " + menus.size() + ", 리뷰: " + reviews.size());
	}
}