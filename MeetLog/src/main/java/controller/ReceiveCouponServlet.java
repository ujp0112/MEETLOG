package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import dao.CouponDAO;
import dao.UserCouponDAO;
import model.Coupon;
import model.User;
import service.UserCouponService;

/**
 * 사용자가 쿠폰을 받는 API 엔드포인트
 */
@WebServlet("/coupon/receive")
public class ReceiveCouponServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserCouponService userCouponService = new UserCouponService();
    private final CouponDAO couponDAO = new CouponDAO();
    private final UserCouponDAO userCouponDAO = new UserCouponDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        JsonObject jsonResponse = new JsonObject();

        try {
            // 1. 세션에서 사용자 정보 가져오기
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "로그인이 필요합니다.");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            User user = (User) session.getAttribute("user");
            int userId = user.getId();

            // 2. 쿠폰 ID 파라미터 받기
            String couponIdStr = request.getParameter("couponId");
            if (couponIdStr == null || couponIdStr.isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "쿠폰 ID가 필요합니다.");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            int couponId = Integer.parseInt(couponIdStr);

            // 3. 쿠폰이 존재하고 활성화되어 있는지 확인
            Coupon coupon = couponDAO.findById(couponId);
            if (coupon == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "존재하지 않는 쿠폰입니다.");
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            if (!coupon.isActive()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "비활성화된 쿠폰입니다.");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            // 4. 쿠폰이 만료되었는지 확인
            if (coupon.isExpired()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "만료된 쿠폰입니다.");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            // 5. 사용 횟수 제한 확인
            if (coupon.getUsageLimit() != null && coupon.getUsageCount() >= coupon.getUsageLimit()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "쿠폰이 모두 소진되었습니다.");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            // 6. 사용자 1인당 받을 수 있는 횟수 제한 확인 (perUserLimit)
            if (coupon.getPerUserLimit() != null) {
                int userReceivedCount = userCouponDAO.countUserReceivedCoupon(userId, couponId);
                if (userReceivedCount >= coupon.getPerUserLimit()) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "1인당 받을 수 있는 쿠폰 개수를 초과했습니다.");
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write(gson.toJson(jsonResponse));
                    return;
                }
            }

            // 7. 쿠폰 지급
            userCouponService.giveCouponToUser(userId, couponId);

            // 8. 성공 응답
            jsonResponse.addProperty("success", true);
            jsonResponse.addProperty("message", "쿠폰을 성공적으로 받았습니다!");
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(gson.toJson(jsonResponse));

        } catch (NumberFormatException e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "잘못된 쿠폰 ID 형식입니다.");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(jsonResponse));
        } catch (Exception e) {
            System.err.println("쿠폰 받기 처리 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "쿠폰 받기 처리 중 오류가 발생했습니다.");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(jsonResponse));
        }
    }
}
