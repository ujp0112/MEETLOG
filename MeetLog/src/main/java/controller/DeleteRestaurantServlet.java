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
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"BUSINESS".equals(user.getUserType())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "로그인이 필요하거나 권한이 없습니다.");
            return;
        }

        try {
            int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
            Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);

            // [보안] 삭제하려는 가게가 존재하고, 현재 로그인한 사용자가 가게 주인이 맞는지 반드시 확인
            if (restaurant != null && restaurant.getOwnerId() == user.getId()) {
                restaurantService.deleteRestaurant(restaurantId);
                // 삭제 성공 시 '내 가게 목록'으로 이동
                response.sendRedirect(request.getContextPath() + "/business/restaurants");
            } else {
                // 주인이 아니거나 가게가 없는 경우
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "삭제 권한이 없습니다.");
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