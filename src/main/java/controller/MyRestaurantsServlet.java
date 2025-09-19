package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// Restaurant 대신 가벼운 RestaurantSummaryDTO를 사용하도록 import 수정
import model.RestaurantSummaryDTO; 
import model.User;
import service.RestaurantService;

@WebServlet("/restaurant/my")
public class MyRestaurantsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RestaurantService restaurantService = new RestaurantService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"BUSINESS".equals(user.getUserType())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "접근 권한이 없습니다.");
            return;
        }

        // ▼▼▼ 수정된 부분 ▼▼▼
        // 1. 전체 Restaurant 정보 대신, 목록에 필요한 요약 정보(DTO)만 가져옵니다.
        List<RestaurantSummaryDTO> myRestaurants = restaurantService.getRestaurantSummariesByOwnerId(user.getId());
        
        // 2. 가게 목록이 비어있더라도, JSP로 데이터를 전달합니다.
        request.setAttribute("myRestaurants", myRestaurants);
        
        // 3. '내 가게 목록' 페이지로 포워딩합니다.
        request.getRequestDispatcher("/WEB-INF/views/my-restaurants.jsp").forward(request, response);
        // ▲▲▲ 수정 완료 ▲▲▲
    }
}