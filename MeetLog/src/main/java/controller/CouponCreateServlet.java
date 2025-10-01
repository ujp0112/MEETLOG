package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.util.List;
import java.util.Objects;

import model.Coupon;
import model.Restaurant;
import model.User;
import service.CouponService;
import service.RestaurantService;

public class CouponCreateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final CouponService couponService = new CouponService();
    private final RestaurantService restaurantService = new RestaurantService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = null;
        User user = null;
        List<Restaurant> ownedRestaurants = null;
        Restaurant selectedRestaurant = null;

        try {
            session = request.getSession(false);
            user = (session != null) ? (User) session.getAttribute("user") : null;
            
            if (user == null || !"BUSINESS".equals(user.getUserType())) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            ownedRestaurants = restaurantService.getRestaurantsByOwnerId(user.getId());
            if (ownedRestaurants == null || ownedRestaurants.isEmpty()) {
                request.setAttribute("errorMessage", "등록된 매장이 없어 쿠폰을 생성할 수 없습니다.");
                request.getRequestDispatcher("/WEB-INF/views/coupon-create.jsp").forward(request, response);
                return;
            }

            selectedRestaurant = resolveRestaurant(request.getParameter("restaurantId"), ownedRestaurants);

            request.setAttribute("ownedRestaurants", ownedRestaurants);
            request.setAttribute("selectedRestaurant", selectedRestaurant);
            request.getRequestDispatcher("/WEB-INF/views/coupon-create.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "쿠폰 생성 페이지 로딩 중 오류가 발생했습니다: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = null;
        User user = null;
        List<Restaurant> ownedRestaurants = null;
        Restaurant selectedRestaurant = null;

        try {
            session = request.getSession(false);
            user = (session != null) ? (User) session.getAttribute("user") : null;
            
            if (user == null || !"BUSINESS".equals(user.getUserType())) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            ownedRestaurants = restaurantService.getRestaurantsByOwnerId(user.getId());
            if (ownedRestaurants == null || ownedRestaurants.isEmpty()) {
                request.setAttribute("errorMessage", "등록된 매장이 없어 쿠폰을 생성할 수 없습니다.");
                request.getRequestDispatcher("/WEB-INF/views/coupon-create.jsp").forward(request, response);
                return;
            }

            String couponName = request.getParameter("couponName");
            String validFrom = request.getParameter("validFrom");
            String validTo = request.getParameter("validTo");
            String description = request.getParameter("description");
            String discountType = request.getParameter("discountType");
            String discountValue = request.getParameter("discountValue");
            String minOrderAmount = request.getParameter("minOrderAmount");
            String usageLimit = request.getParameter("usageLimit");
            String perUserLimit = request.getParameter("perUserLimit");
            selectedRestaurant = resolveRestaurant(request.getParameter("restaurantId"), ownedRestaurants);

            Coupon coupon = new Coupon();
            coupon.setTitle(couponName);
            coupon.setDescription(description);
            coupon.setValidity(buildValidityPeriod(validFrom, validTo));
            coupon.setRestaurantId(selectedRestaurant.getId());
            coupon.setActive(true);

            // 새 필드 설정
            coupon.setDiscountType(discountType);
            if (discountValue != null && !discountValue.trim().isEmpty()) {
                coupon.setDiscountValue(Integer.parseInt(discountValue));
            }
            if (minOrderAmount != null && !minOrderAmount.trim().isEmpty()) {
                coupon.setMinOrderAmount(Integer.parseInt(minOrderAmount));
            }
            if (validFrom != null && !validFrom.trim().isEmpty()) {
                coupon.setValidFrom(java.sql.Date.valueOf(validFrom));
            }
            if (validTo != null && !validTo.trim().isEmpty()) {
                coupon.setValidTo(java.sql.Date.valueOf(validTo));
            }
            if (usageLimit != null && !usageLimit.trim().isEmpty()) {
                coupon.setUsageLimit(Integer.parseInt(usageLimit));
            }
            if (perUserLimit != null && !perUserLimit.trim().isEmpty()) {
                coupon.setPerUserLimit(Integer.parseInt(perUserLimit));
            }

            boolean created = couponService.addCoupon(coupon);
            if (created) {
                if (session != null) {
                    session.setAttribute("couponSuccessMessage", "쿠폰이 성공적으로 생성되었습니다!");
                }
                response.sendRedirect(request.getContextPath() + "/coupon-management");
                return;
            }
            request.setAttribute("errorMessage", "쿠폰 생성 중 오류가 발생했습니다. 다시 시도해주세요.");
            request.setAttribute("ownedRestaurants", ownedRestaurants);
            request.setAttribute("selectedRestaurant", selectedRestaurant);
            request.getRequestDispatcher("/WEB-INF/views/coupon-create.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "쿠폰 생성 중 오류가 발생했습니다: " + e.getMessage());

            if (user != null && (ownedRestaurants == null || ownedRestaurants.isEmpty())) {
                ownedRestaurants = restaurantService.getRestaurantsByOwnerId(user.getId());
            }
            if (selectedRestaurant == null && ownedRestaurants != null && !ownedRestaurants.isEmpty()) {
                selectedRestaurant = ownedRestaurants.get(0);
            }
            request.setAttribute("ownedRestaurants", ownedRestaurants);
            request.setAttribute("selectedRestaurant", selectedRestaurant);

            request.getRequestDispatcher("/WEB-INF/views/coupon-create.jsp").forward(request, response);
        }
    }

    private String buildValidityPeriod(String validFrom, String validTo) {
        if (validFrom == null && validTo == null) {
            return null;
        }

        if (validFrom == null) {
            return validTo;
        }

        if (validTo == null || validFrom.equals(validTo)) {
            return validFrom;
        }

        return validFrom + " ~ " + validTo;
    }

    private Restaurant resolveRestaurant(String restaurantIdParam, List<Restaurant> ownedRestaurants) {
        if (ownedRestaurants == null || ownedRestaurants.isEmpty()) {
            return null;
        }

        if (restaurantIdParam != null) {
            try {
                int requestedId = Integer.parseInt(restaurantIdParam);
                return ownedRestaurants.stream()
                        .filter(Objects::nonNull)
                        .filter(r -> r.getId() == requestedId)
                        .findFirst()
                        .orElse(ownedRestaurants.get(0));
            } catch (NumberFormatException ignored) {
            }
        }

        return ownedRestaurants.get(0);
    }
}
