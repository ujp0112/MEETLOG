package controller;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

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
import util.LocalDateTimeAdapter; // Gson이 LocalDate를 처리하기 위한 유틸리티 클래스

/**
 * 레스토랑 상세 정보를 조회하고 표시하는 서블릿 (JSON 처리 기능 추가)
 */
@WebServlet("/restaurant/detail/*")
public class RestaurantDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(RestaurantDetailServlet.class.getName());
    
    private final RestaurantService restaurantService = new RestaurantService();
    private final MenuService menuService = new MenuService();
    private final ReviewService reviewService = new ReviewService();
    private final CouponService couponService = new CouponService();
    private final QnAService qnaService = new QnAService();
    private final OperatingHourService operatingHourService = new OperatingHourService();
    
    // Gson 객체를 한 번만 생성하여 재사용 (LocalDate 타입을 처리하도록 설정)
    private final Gson gson = new GsonBuilder()
            .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
            .create();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        logger.info("RestaurantDetailServlet 요청 처리 시작 - pathInfo: " + pathInfo);
        
        try {
            // URL에서 음식점 ID 추출 및 검증
            int restaurantId = extractRestaurantId(pathInfo);
            if (restaurantId <= 0) {
                logger.warning("유효하지 않은 레스토랑 ID: " + restaurantId);
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "유효하지 않은 음식점 ID입니다.");
                return;
            }
            
            logger.info("레스토랑 상세 정보 조회 시작 - ID: " + restaurantId);
            
            // 레스토랑 정보와 추가 이미지를 한 번에 조회
            Restaurant restaurant = restaurantService.getRestaurantDetailById(restaurantId);
            if (restaurant == null) {
                logger.warning("레스토랑을 찾을 수 없음 - ID: " + restaurantId);
                request.setAttribute("restaurant", null);
                request.getRequestDispatcher("/WEB-INF/views/restaurant-detail.jsp").forward(request, response);
                return;
            }
            logger.info("레스토랑 정보 조회 완료 - 이름: " + restaurant.getName());
            
            // 관련 데이터들을 안전하게 조회
            List<Menu> menus = safeGetMenus(restaurantId);
            List<Review> reviews = safeGetReviews(restaurantId);
            List<Coupon> coupons = safeGetCoupons(restaurantId);
            List<QnA> qnas = safeGetQnAs(restaurantId);
            List<OperatingHour> operatingHours = safeGetOperatingHours(restaurantId);
            
            // 사용자 권한 확인 (사장님 여부)
            boolean isOwner = checkOwnership(request, restaurant);
            
            // 리뷰 목록을 JSON 문자열로 변환
            String reviewsJson = gson.toJson(reviews);
            
            // 조회된 모든 데이터를 request에 설정
            setRequestAttributes(request, restaurant, menus, reviews, coupons, qnas, operatingHours, isOwner, reviewsJson);
            
            logger.info("레스토랑 상세 정보 조회 완료 - restaurant-detail.jsp로 포워딩");
            request.getRequestDispatcher("/WEB-INF/views/restaurant-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "레스토랑 ID 파싱 오류: " + pathInfo, e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "올바르지 않은 음식점 ID 형식입니다.");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "RestaurantDetailServlet 처리 중 예상치 못한 오류", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "서버 오류가 발생했습니다.");
        }
    }
    
    private int extractRestaurantId(String pathInfo) throws NumberFormatException {
        if (pathInfo == null || pathInfo.length() <= 1) {
            throw new NumberFormatException("pathInfo가 null이거나 비어있음");
        }
        String idString = pathInfo.substring(1);
        if (!idString.matches("\\d+")) {
            throw new NumberFormatException("ID가 숫자가 아님: " + idString);
        }
        return Integer.parseInt(idString);
    }

    private List<Menu> safeGetMenus(int restaurantId) {
        try {
            List<Menu> menus = menuService.getMenusByRestaurantId(restaurantId);
            logger.info("메뉴 " + (menus != null ? menus.size() : 0) + "개 조회 완료");
            return menus != null ? menus : Collections.emptyList();
        } catch (Exception e) {
            logger.log(Level.WARNING, "메뉴 조회 중 오류", e);
            return Collections.emptyList();
        }
    }

    private List<Review> safeGetReviews(int restaurantId) {
        try {
            List<Review> reviews = reviewService.getReviewsByRestaurantId(restaurantId);
            logger.info("리뷰 " + (reviews != null ? reviews.size() : 0) + "개 조회 완료");
            return reviews != null ? reviews : Collections.emptyList();
        } catch (Exception e) {
            logger.log(Level.WARNING, "리뷰 조회 중 오류", e);
            return Collections.emptyList();
        }
    }
    
    private List<Coupon> safeGetCoupons(int restaurantId) {
        try {
            List<Coupon> coupons = couponService.getCouponsByRestaurantId(restaurantId);
            logger.info("쿠폰 " + (coupons != null ? coupons.size() : 0) + "개 조회 완료");
            return coupons != null ? coupons : Collections.emptyList();
        } catch (Exception e) {
            logger.log(Level.WARNING, "쿠폰 조회 중 오류", e);
            return Collections.emptyList();
        }
    }

    private List<QnA> safeGetQnAs(int restaurantId) {
        try {
            List<QnA> qnas = qnaService.getQnAsByRestaurantId(restaurantId);
            logger.info("Q&A " + (qnas != null ? qnas.size() : 0) + "개 조회 완료");
            return qnas != null ? qnas : Collections.emptyList();
        } catch (Exception e) {
            logger.log(Level.WARNING, "Q&A 조회 중 오류", e);
            return Collections.emptyList();
        }
    }

    private List<OperatingHour> safeGetOperatingHours(int restaurantId) {
        try {
            List<OperatingHour> hours = operatingHourService.getOperatingHoursByRestaurantId(restaurantId);
            logger.info("운영시간 " + (hours != null ? hours.size() : 0) + "개 조회 완료");
            return hours != null ? hours : Collections.emptyList();
        } catch (Exception e) {
            logger.log(Level.WARNING, "운영시간 조회 중 오류", e);
            return Collections.emptyList();
        }
    }

    private boolean checkOwnership(HttpServletRequest request, Restaurant restaurant) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            return false;
        }
        User user = (User) session.getAttribute("user");
        boolean isOwner = "BUSINESS".equals(user.getUserType()) && user.getId() == restaurant.getOwnerId();
        logger.info("소유자 확인 - 사용자 ID: " + user.getId() + ", 소유자 ID: " + restaurant.getOwnerId() + ", 소유자 여부: " + isOwner);
        return isOwner;
    }
    
    private void setRequestAttributes(HttpServletRequest request, Restaurant r, 
            List<Menu> m, List<Review> rev, List<Coupon> c, 
            List<QnA> q, List<OperatingHour> oh, boolean owner, String reviewsJson) {
        
        request.setAttribute("restaurant", r);
        request.setAttribute("menus", m);
        request.setAttribute("reviews", rev);
        request.setAttribute("coupons", c);
        request.setAttribute("qnas", q);
        request.setAttribute("operatingHours", oh);
        request.setAttribute("isOwner", owner);
        request.setAttribute("reviewsJson", reviewsJson); // JavaScript에서 사용할 JSON 데이터
        
        logger.info("Request 속성 설정 완료 - 메뉴: " + m.size() + ", 리뷰: " + rev.size());
    }
}