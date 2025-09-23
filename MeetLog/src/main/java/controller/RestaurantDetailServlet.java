package controller;

import java.io.IOException;
import java.util.List;
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
import service.MenuService;
import service.OperatingHourService;
import service.QnAService;
import service.RestaurantService;
import service.ReviewService;

/**
 * 레스토랑 상세 정보를 조회하고 표시하는 서블릿
 * - /restaurant/detail/{id} : 레스토랑 상세 페이지
 * - 레스토랑 정보, 메뉴, 리뷰, 쿠폰, Q&A, 운영시간 등 모든 관련 데이터 제공
 */
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
            
            // 레스토랑 기본 정보 조회
            Restaurant restaurant = restaurantService.getRestaurantDetailById(restaurantId);
            if (restaurant == null) {
                logger.warning("레스토랑을 찾을 수 없음 - ID: " + restaurantId);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "음식점을 찾을 수 없습니다.");
                return;
            }
            
            logger.info("레스토랑 정보 조회 완료 - 이름: " + restaurant.getName());
            
            // 관련 데이터들을 안전하게 조회
            List<Menu> menus = safeGetMenus(restaurantId);
            List<Review> reviews = safeGetReviews(restaurantId);
            List<Coupon> coupons = safeGetCoupons(restaurantId);
            List<QnA> qnas = safeGetQnAs(restaurantId);
            List<OperatingHour> operatingHours = safeGetOperatingHours(restaurantId);
            
            // 사용자 권한 확인
            boolean isOwner = checkOwnership(request, restaurant);
            
            // 데이터를 request에 설정
            setRequestAttributes(request, restaurant, menus, reviews, coupons, qnas, operatingHours, isOwner);
            
            logger.info("레스토랑 상세 정보 조회 완료 - restaurant-detail.jsp로 포워딩");
            request.getRequestDispatcher("/WEB-INF/views/restaurant-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "레스토랑 ID 파싱 오류", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "올바르지 않은 음식점 ID 형식입니다.");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "RestaurantDetailServlet 처리 중 예상치 못한 오류", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "서버 오류가 발생했습니다.");
        }
    }
    
    /**
     * pathInfo에서 레스토랑 ID 추출
     */
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
    
    /**
     * 메뉴 목록 안전 조회
     */
    private List<Menu> safeGetMenus(int restaurantId) {
        try {
            List<Menu> menus = menuService.getMenusByRestaurantId(restaurantId);
            if (menus == null) menus = new java.util.ArrayList<>();
            logger.info("메뉴 " + menus.size() + "개 조회 완료");
            return menus;
        } catch (Exception e) {
            logger.log(Level.WARNING, "메뉴 조회 중 오류", e);
            return new java.util.ArrayList<>();
        }
    }
    
    /**
     * 리뷰 목록 안전 조회
     */
    private List<Review> safeGetReviews(int restaurantId) {
        try {
            List<Review> reviews = reviewService.getReviewsByRestaurantId(restaurantId);
            if (reviews == null) reviews = new java.util.ArrayList<>();
            logger.info("리뷰 " + reviews.size() + "개 조회 완료");
            return reviews;
        } catch (Exception e) {
            logger.log(Level.WARNING, "리뷰 조회 중 오류", e);
            return new java.util.ArrayList<>();
        }
    }
    
    /**
     * 쿠폰 목록 안전 조회
     */
    private List<Coupon> safeGetCoupons(int restaurantId) {
        try {
            List<Coupon> coupons = couponService.getCouponsByRestaurantId(restaurantId);
            if (coupons == null) coupons = new java.util.ArrayList<>();
            logger.info("쿠폰 " + coupons.size() + "개 조회 완료");
            return coupons;
        } catch (Exception e) {
            logger.log(Level.WARNING, "쿠폰 조회 중 오류", e);
            return new java.util.ArrayList<>();
        }
    }
    
    /**
     * Q&A 목록 안전 조회
     */
    private List<QnA> safeGetQnAs(int restaurantId) {
        try {
            List<QnA> qnas = qnaService.getQnAsByRestaurantId(restaurantId);
            if (qnas == null) qnas = new java.util.ArrayList<>();
            logger.info("Q&A " + qnas.size() + "개 조회 완료");
            return qnas;
        } catch (Exception e) {
            logger.log(Level.WARNING, "Q&A 조회 중 오류", e);
            return new java.util.ArrayList<>();
        }
    }
    
    /**
     * 운영시간 목록 안전 조회
     */
    private List<OperatingHour> safeGetOperatingHours(int restaurantId) {
        try {
            List<OperatingHour> operatingHours = operatingHourService.getOperatingHoursByRestaurantId(restaurantId);
            if (operatingHours == null) operatingHours = new java.util.ArrayList<>();
            logger.info("운영시간 " + operatingHours.size() + "개 조회 완료");
            return operatingHours;
        } catch (Exception e) {
            logger.log(Level.WARNING, "운영시간 조회 중 오류", e);
            return new java.util.ArrayList<>();
        }
    }
    
    /**
     * 사용자가 레스토랑 소유자인지 확인
     */
    private boolean checkOwnership(HttpServletRequest request, Restaurant restaurant) {
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                return false;
            }
            
            User user = (User) session.getAttribute("user");
            boolean isOwner = user.getId() == restaurant.getOwnerId() && "BUSINESS".equals(user.getUserType());
            
            logger.info("소유자 확인 - 사용자 ID: " + user.getId() + ", 소유자 ID: " + restaurant.getOwnerId() + ", 소유자 여부: " + isOwner);
            return isOwner;
            
        } catch (Exception e) {
            logger.log(Level.WARNING, "소유자 확인 중 오류", e);
            return false;
        }
    }
    
    /**
     * request에 모든 속성 설정
     */
    private void setRequestAttributes(HttpServletRequest request, Restaurant restaurant, 
            List<Menu> menus, List<Review> reviews, List<Coupon> coupons, 
            List<QnA> qnas, List<OperatingHour> operatingHours, boolean isOwner) {
        
        request.setAttribute("restaurant", restaurant);
        request.setAttribute("menus", menus);
        request.setAttribute("reviews", reviews);
        request.setAttribute("coupons", coupons);
        request.setAttribute("qnas", qnas);
        request.setAttribute("operatingHours", operatingHours);
        request.setAttribute("isOwner", isOwner);
        
        // 통계 정보 추가
        request.setAttribute("menuCount", menus.size());
        request.setAttribute("reviewCount", reviews.size());
        request.setAttribute("couponCount", coupons.size());
        request.setAttribute("qnaCount", qnas.size());
        
        logger.info("Request 속성 설정 완료 - 메뉴: " + menus.size() + ", 리뷰: " + reviews.size() + 
                   ", 쿠폰: " + coupons.size() + ", Q&A: " + qnas.size());
    }
}
