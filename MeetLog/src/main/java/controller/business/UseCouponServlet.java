package controller.business;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import model.User;
import service.UserCouponService;

@WebServlet("/business/reservation/use-coupon")
public class UseCouponServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserCouponService userCouponService = new UserCouponService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 권한 확인
        if (user == null || !"BUSINESS".equals(user.getUserType())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            // 파라미터 받기
            String userCouponIdStr = request.getParameter("userCouponId");

            if (userCouponIdStr == null || userCouponIdStr.isEmpty()) {
                session.setAttribute("errorMessage", "쿠폰 정보가 없습니다.");
                response.sendRedirect(request.getContextPath() + "/business/reservation-management");
                return;
            }

            int userCouponId = Integer.parseInt(userCouponIdStr);

            // 쿠폰 사용 처리 (단순 버전 사용)
            userCouponService.useCoupon(userCouponId);
            session.setAttribute("successMessage", "쿠폰이 성공적으로 사용 처리되었습니다.");

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "잘못된 요청입니다.");
            e.printStackTrace();
        } catch (Exception e) {
            session.setAttribute("errorMessage", "쿠폰 사용 처리 중 오류가 발생했습니다: " + e.getMessage());
            e.printStackTrace();
        }

        // 예약 관리 페이지로 리다이렉트
        response.sendRedirect(request.getContextPath() + "/business/reservation-management");
    }
}
