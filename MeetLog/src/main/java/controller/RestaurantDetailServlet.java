package controller;

import java.io.IOException;
import java.util.Collections; // [ ✨ 1. Collections 임포트 추가 ✨ ]
import java.util.ArrayList; // [ ✨ 2. ArrayList 임포트 추가 ✨ ]
import java.time.LocalDate; // [ ✨ 3. java.time.* 임포트 추가 ✨ ]
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.FollowDAO;
import model.Coupon;
import model.Menu;
import model.OperatingHour;
import model.QnA;
import model.Restaurant;
import model.Review;
import model.ReviewComment;
import model.User;
import service.CouponService;
import service.FollowService;
import service.MenuService;
import service.OperatingHourService;
import service.QnAService;
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

            // --- 데이터베이스 조회 ---
            Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
            if (restaurant == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "해당 맛집을 찾을 수 없습니다.");
                return;
            }
            List<Menu> menus = menuService.getMenusByRestaurantId(restaurantId);
            // 현재 로그인한 사용자의 ID를 전달하여 리뷰별 '좋아요' 여부를 함께 조회
            List<Review> reviews = reviewService.getReviewsByRestaurantId(restaurantId, currentUserId); 
            List<Coupon> coupons = couponService.getCouponsByRestaurantId(restaurantId);
            List<QnA> qnas = qnaService.getQnAsByRestaurantId(restaurantId);
            List<OperatingHour> operatingHours = operatingHourService.getOperatingHoursByRestaurantId(restaurantId);

            boolean isOwner = checkIfOwner(currentUser, restaurant);
            
            // =================================================================
            // [ ✨✨ 핵심 수정 부분 ✨✨ ]
            // JSP에 있던 예약 시간 생성 로직을 서블릿으로 이동
            // =================================================================
            List<String> timeSlots = new ArrayList<>();
            if (operatingHours != null && !operatingHours.isEmpty()) {
                int todayDayOfWeek = LocalDate.now().getDayOfWeek().getValue(); // 오늘 요일 (월=1, ..., 일=7)

                for (OperatingHour oh : operatingHours) {
                    // 오늘 요일과 일치하는 운영 시간 정보를 찾음
                    if (oh.getDayOfWeek() == todayDayOfWeek && oh.getOpeningTime() != null && oh.getClosingTime() != null) {
                        LocalTime startTime = oh.getOpeningTime();
                        // 예약은 마감 30분 전까지만 가능하다고 가정
                        LocalTime endTime = oh.getClosingTime().minusMinutes(30); 
                        LocalTime currentTime = startTime;

                        // 시작 시간부터 종료 시간까지 30분 간격으로 시간 슬롯 생성
                        while (!currentTime.isAfter(endTime)) {
                            timeSlots.add(currentTime.format(DateTimeFormatter.ofPattern("HH:mm")));
                            currentTime = currentTime.plusMinutes(30);
                        }
                        // 해당 요일의 시간표를 찾았으므로 반복 중단
                        break; 
                    }
                }
            }
            Collections.sort(timeSlots); // 시간 순으로 정렬
            request.setAttribute("timeSlots", timeSlots); // 생성된 시간 목록을 request에 추가
            // =================================================================
            Restaurant restaurant1 = restaurantService.getRestaurantDetailById(restaurantId);
            restaurant.setAdditionalImages(restaurant1.getAdditionalImages());

            setRequestAttributes(request, restaurant, menus, reviews, coupons, qnas, operatingHours, isOwner);
            request.getRequestDispatcher("/WEB-INF/views/restaurant-detail.jsp").forward(request, response);

			if (restaurant == null) {
				logger.warning("ID에 해당하는 레스토랑을 찾을 수 없음: " + restaurantId);
				response.sendError(HttpServletResponse.SC_NOT_FOUND, "해당 레스토랑 정보를 찾을 수 없습니다.");
				return;
			}
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "올바르지 않은 맛집 ID 형식입니다.", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 맛집 ID 형식입니다.");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "레스토랑 상세 정보 조회 중 심각한 오류 발생", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "서버 내부 오류가 발생했습니다.");
        }
    }

    private boolean checkIfOwner(User currentUser, Restaurant restaurant) {
        if (currentUser == null || restaurant == null) {
            return false;
        }
        return currentUser.getId() == restaurant.getOwnerId() && "BUSINESS".equals(currentUser.getUserType());
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
    }
}