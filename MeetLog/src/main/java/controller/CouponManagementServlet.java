package controller;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Coupon;
import model.Restaurant;
import model.User;
import service.CouponService;
import service.RestaurantService;

public class CouponManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final CouponService couponService = new CouponService();
    private final RestaurantService restaurantService = new RestaurantService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;
            
            if (user == null || !"BUSINESS".equals(user.getUserType())) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            List<Restaurant> ownedRestaurants = restaurantService.getRestaurantsByOwnerId(user.getId());
            if (ownedRestaurants == null || ownedRestaurants.isEmpty()) {
                request.setAttribute("totalCoupons", 0);
                request.setAttribute("activeCoupons", 0);
                request.setAttribute("expiredCoupons", 0);
                request.setAttribute("usedCoupons", 0);
                request.setAttribute("coupons", Collections.emptyList());
                request.setAttribute("errorMessage", "등록된 매장 정보가 없어 쿠폰을 불러올 수 없습니다.");
                request.getRequestDispatcher("/WEB-INF/views/coupon-management.jsp").forward(request, response);
                return;
            }

            int selectedRestaurantId = resolveRestaurantId(request.getParameter("restaurantId"), ownedRestaurants);
            Restaurant selectedRestaurant = ownedRestaurants.stream()
                    .filter(Objects::nonNull)
                    .filter(r -> r.getId() == selectedRestaurantId)
                    .findFirst()
                    .orElse(ownedRestaurants.get(0));

            List<Coupon> coupons = couponService.getCouponsByRestaurantId(selectedRestaurant.getId());

            int totalCoupons = coupons.size();
            int activeCoupons = (int) coupons.stream()
                    .filter(Objects::nonNull)
                    .filter(Coupon::isActive)
                    .count();
            int expiredCoupons = totalCoupons - activeCoupons;

            // TODO: 향후 사용 통계를 위한 별도 추적 필드가 추가되면 실제 사용량을 계산하도록 수정
            int usedCoupons = 0;

            if (session != null) {
                String successMessage = (String) session.getAttribute("couponSuccessMessage");
                if (successMessage != null) {
                    request.setAttribute("successMessage", successMessage);
                    session.removeAttribute("couponSuccessMessage");
                }

                String errorMessage = (String) session.getAttribute("couponErrorMessage");
                if (errorMessage != null) {
                    request.setAttribute("errorMessage", errorMessage);
                    session.removeAttribute("couponErrorMessage");
                }
            }

            request.setAttribute("totalCoupons", totalCoupons);
            request.setAttribute("activeCoupons", activeCoupons);
            request.setAttribute("expiredCoupons", expiredCoupons);
            request.setAttribute("usedCoupons", usedCoupons);
            request.setAttribute("coupons", coupons);
            request.setAttribute("ownedRestaurants", ownedRestaurants);
            request.setAttribute("selectedRestaurant", selectedRestaurant);

            request.getRequestDispatcher("/WEB-INF/views/coupon-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "쿠폰 관리 페이지 로딩 중 오류가 발생했습니다: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;

            if (user == null || !"BUSINESS".equals(user.getUserType())) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            String action = request.getParameter("action");
            String couponIdParam = request.getParameter("couponId");
            String restaurantIdParam = request.getParameter("restaurantId");

            if (action == null || couponIdParam == null) {
                session.setAttribute("couponErrorMessage", "잘못된 요청입니다.");
                response.sendRedirect(request.getContextPath() + "/coupon/management" +
                        (restaurantIdParam != null ? "?restaurantId=" + restaurantIdParam : ""));
                return;
            }

            int couponId = Integer.parseInt(couponIdParam);

            // 쿠폰 소유자 확인
            Coupon coupon = couponService.getCouponById(couponId);
            if (coupon == null) {
                session.setAttribute("couponErrorMessage", "쿠폰을 찾을 수 없습니다.");
                response.sendRedirect(request.getContextPath() + "/coupon/management" +
                        (restaurantIdParam != null ? "?restaurantId=" + restaurantIdParam : ""));
                return;
            }

            // 소유자 권한 확인
            List<Restaurant> ownedRestaurants = restaurantService.getRestaurantsByOwnerId(user.getId());
            boolean isOwner = ownedRestaurants.stream()
                    .anyMatch(r -> r.getId() == coupon.getRestaurantId());

            if (!isOwner) {
                session.setAttribute("couponErrorMessage", "해당 쿠폰에 대한 권한이 없습니다.");
                response.sendRedirect(request.getContextPath() + "/coupon/management" +
                        (restaurantIdParam != null ? "?restaurantId=" + restaurantIdParam : ""));
                return;
            }

            switch (action) {
                case "deactivate":
                    boolean deactivateSuccess = couponService.deactivateCoupon(couponId);
                    if (deactivateSuccess) {
                        session.setAttribute("couponSuccessMessage", "쿠폰이 비활성화되었습니다.");
                    } else {
                        session.setAttribute("couponErrorMessage", "쿠폰 비활성화에 실패했습니다.");
                    }
                    break;

                case "update":
                    String title = request.getParameter("title");
                    String description = request.getParameter("description");
                    String validity = request.getParameter("validity");

                    if (title == null || title.trim().isEmpty()) {
                        session.setAttribute("couponErrorMessage", "쿠폰 제목은 필수입니다.");
                        response.sendRedirect(request.getContextPath() + "/coupon/management" +
                                (restaurantIdParam != null ? "?restaurantId=" + restaurantIdParam : ""));
                        return;
                    }

                    coupon.setTitle(title.trim());
                    coupon.setDescription(description != null ? description.trim() : "");
                    coupon.setValidity(validity != null ? validity.trim() : "");

                    boolean updateSuccess = couponService.updateCoupon(coupon);
                    if (updateSuccess) {
                        session.setAttribute("couponSuccessMessage", "쿠폰이 수정되었습니다.");
                    } else {
                        session.setAttribute("couponErrorMessage", "쿠폰 수정에 실패했습니다.");
                    }
                    break;

                default:
                    session.setAttribute("couponErrorMessage", "알 수 없는 작업입니다.");
            }

            response.sendRedirect(request.getContextPath() + "/coupon/management" +
                    (restaurantIdParam != null ? "?restaurantId=" + restaurantIdParam : ""));

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.setAttribute("couponErrorMessage", "잘못된 쿠폰 ID입니다.");
            }
            response.sendRedirect(request.getContextPath() + "/coupon/management");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "쿠폰 관리 중 오류가 발생했습니다: " + e.getMessage());
        }
    }

    private int resolveRestaurantId(String restaurantIdParam, List<Restaurant> ownedRestaurants) {
        if (restaurantIdParam != null) {
            try {
                int requestedId = Integer.parseInt(restaurantIdParam);
                Optional<Restaurant> match = ownedRestaurants.stream()
                        .filter(Objects::nonNull)
                        .filter(r -> r.getId() == requestedId)
                        .findFirst();
                if (match.isPresent()) {
                    return match.get().getId();
                }
            } catch (NumberFormatException ignored) {
            }
        }
        return ownedRestaurants.get(0).getId();
    }
}
