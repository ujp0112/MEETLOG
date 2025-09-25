package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Restaurant;
import model.User;
import service.RestaurantService;

@WebServlet("/business/restaurants/delete")
public class DeleteRestaurantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RestaurantService restaurantService = new RestaurantService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 응답을 JSON으로 설정
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"BUSINESS".equals(user.getUserType())) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("{\"success\": false, \"message\": \"로그인이 필요하거나 권한이 없습니다.\"}");
            return;
        }

        try {
            int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
            Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);

            if (restaurant != null && restaurant.getOwnerId() == user.getId()) {
                boolean success = restaurantService.deleteRestaurant(restaurantId);
                if (success) {
                    // 성공 시 JSON 응답
                    response.getWriter().write("{\"success\": true}");
                } else {
                    throw new Exception("서비스에서 삭제 처리가 실패했습니다.");
                }
            } else {
                // 권한 없음
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("{\"success\": false, \"message\": \"삭제 권한이 없습니다.\"}");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 가게 ID입니다.");
        } catch (Exception e) {
            e.printStackTrace();
            // 에러 페이지나 다른 처리
            response.sendRedirect(request.getContextPath() + "/business/dashboard?id=" + request.getParameter("restaurantId") + "&error=true");
        }
    }
}