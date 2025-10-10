package controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.time.format.DateTimeFormatter;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

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
import service.FollowService;
import service.MenuService;
import service.OperatingHourService;
import service.QnAService;
import service.ReservationSettingsService; // [ ✨ 1. ReservationSettingsService 임포트 ✨ ]
import service.RestaurantService;
import service.ReviewCommentService;
import service.ReviewLikeService;
import service.ReviewService;

@WebServlet("/restaurant/detail/*")
public class RestaurantDetailServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final Logger logger = Logger.getLogger(RestaurantDetailServlet.class.getName());

	// --- 서비스 객체들을 클래스 멤버 변수로 초기화 ---
	private final RestaurantService restaurantService = new RestaurantService();
	private final MenuService menuService = new MenuService();
	private final ReviewService reviewService = new ReviewService();
	private final CouponService couponService = new CouponService();
	private final QnAService qnaService = new QnAService();
	private final OperatingHourService operatingHourService = new OperatingHourService();
	private final ReviewLikeService reviewLikeService = new ReviewLikeService();
	private final FollowService followService = new FollowService();
	private final ReviewCommentService reviewCommentService = new ReviewCommentService();
	// [ ✨ 2. ReservationSettingsService를 멤버 변수로 추가 ✨ ]
	private final ReservationSettingsService reservationSettingsService = new ReservationSettingsService();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			String pathInfo = request.getPathInfo();
			if (pathInfo == null || pathInfo.equals("/")) {
				response.sendError(HttpServletResponse.SC_BAD_REQUEST, "맛집 ID가 필요합니다.");
				return;
			}
			int restaurantId = Integer.parseInt(pathInfo.substring(1));

			HttpSession session = request.getSession(false);
			User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
			int currentUserId = (currentUser != null) ? currentUser.getId() : 0;

			Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
			if (restaurant == null) {
				response.sendError(HttpServletResponse.SC_NOT_FOUND, "해당 맛집을 찾을 수 없습니다.");
				return;
			}

			if (restaurant.getKakaoPlaceId() != null && !restaurant.getKakaoPlaceId().isEmpty()) {
				String redirectUrl = String.format(
						"%s/searchRestaurant/external-detail?name=%s&address=%s&phone=%s&category=%s&lat=%s&lng=%s",
						request.getContextPath(), URLEncoder.encode(restaurant.getName(), "UTF-8"),
						URLEncoder.encode(restaurant.getAddress(), "UTF-8"),
						URLEncoder.encode(restaurant.getPhone() != null ? restaurant.getPhone() : "", "UTF-8"),
						URLEncoder.encode(restaurant.getCategory() != null ? restaurant.getCategory() : "", "UTF-8"),
						restaurant.getLatitude(), restaurant.getLongitude());
				response.sendRedirect(redirectUrl);
				return;
			}

			// 내부 맛집 상세 정보 조회
			request.setAttribute("isExternal", false);
			List<Menu> menus = menuService.getMenusByRestaurantId(restaurantId);
			List<Review> reviews = reviewService.getReviewsByRestaurantId(restaurantId, currentUserId);
			List<Coupon> coupons = couponService.getCouponsByRestaurantId(restaurantId);
			List<QnA> qnas = qnaService.getQnAsByRestaurantId(restaurantId);
			List<OperatingHour> operatingHours = operatingHourService.getOperatingHoursByRestaurantId(restaurantId);

			// [ ✨ 3. 예약 설정을 조회하는 핵심 코드 ✨ ]
			Map<String, Object> reservationSettings = reservationSettingsService.getReservationSettings(restaurantId);

			boolean isOwner = checkIfOwner(currentUser, restaurant);

			// [ ✨ 4. 불필요하고 잘못된 timeSlots 계산 로직을 완전히 삭제합니다 ✨ ]
			// (기존 operatingHours 기반 로직 제거)

			Restaurant restaurantWithImages = restaurantService.getRestaurantDetailById(restaurantId);
			if (restaurantWithImages != null) {
				restaurant.setAdditionalImages(restaurantWithImages.getAdditionalImages());
			}

			// [ ✨ 5. setRequestAttributes 호출 시 reservationSettings를 전달하도록 수정 ✨ ]
			setRequestAttributes(request, restaurant, menus, reviews, coupons, qnas, operatingHours, isOwner,
					reservationSettings);

			request.getRequestDispatcher("/WEB-INF/views/restaurant-detail.jsp").forward(request, response);

		} catch (NumberFormatException e) {
			logger.log(Level.WARNING, "올바르지 않은 맛집 ID 형식입니다.", e);
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 맛집 ID 형식입니다.");
		} catch (Exception e) {
			logger.log(Level.SEVERE, "레스토랑 상세 정보 조회 중 심각한 오류 발생", e);
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "서버 내부 오류가 발생했습니다.");
		}
	}

	private boolean checkIfOwner(User currentUser, Restaurant restaurant) {
		if (currentUser == null || restaurant == null || restaurant.getOwnerId() == null) {
			return false;
		}
		return currentUser.getId() == restaurant.getOwnerId().intValue()
				&& "BUSINESS".equals(currentUser.getUserType());
	}

	// [ ✨ 6. setRequestAttributes 메소드 시그니처에 Map<String, Object> reservationSettings
	// 추가 ✨ ]
	private void setRequestAttributes(HttpServletRequest request, Restaurant restaurant, List<Menu> menus,
			List<Review> reviews, List<Coupon> coupons, List<QnA> qnas, List<OperatingHour> operatingHours,
			boolean isOwner, Map<String, Object> reservationSettings) {

		request.setAttribute("restaurant", restaurant);
		request.setAttribute("menus", menus);
		request.setAttribute("reviews", reviews);
		request.setAttribute("coupons", coupons);
		request.setAttribute("qnas", qnas);
		request.setAttribute("operatingHours", operatingHours); // 이 부분은 영업시간 표시에 필요하므로 유지합니다.
		request.setAttribute("isOwner", isOwner);

		// 영업시간 데이터를 JSP에서 사용하기 편한 Map 형태로 가공
		Map<String, String> operatingHoursByDay = new LinkedHashMap<>();
		String[] days = { "월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일" };
		for (int i = 0; i < days.length; i++) {
			final int dayOfWeek = i + 1;
			String dayName = days[i];

			String hours = operatingHours.stream().filter(oh -> oh.getDayOfWeek() == dayOfWeek).findFirst()
					.map(oh -> oh.getOpeningTime().format(DateTimeFormatter.ofPattern("HH:mm")) + " - "
							+ oh.getClosingTime().format(DateTimeFormatter.ofPattern("HH:mm")))
					.orElse("휴무일");

			operatingHoursByDay.put(dayName, hours);
		}
		request.setAttribute("operatingHoursByDay", operatingHoursByDay);

		// [ ✨ 7. 조회된 예약 설정 정보를 JSP로 최종 전달 ✨ ]
		request.setAttribute("reservationSettings", reservationSettings);
	}
}