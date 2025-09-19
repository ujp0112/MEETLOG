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

@WebServlet("/business/restaurants/add")
public class AddRestaurantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RestaurantService restaurantService = new RestaurantService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 가게 등록 폼 페이지를 보여줍니다.
        request.getRequestDispatcher("/WEB-INF/views/add-restaurant.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"BUSINESS".equals(user.getUserType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 폼에서 받은 데이터로 Restaurant 객체 생성
        Restaurant restaurant = new Restaurant();
        restaurant.setName(request.getParameter("name"));
        restaurant.setCategory(request.getParameter("category"));
        restaurant.setLocation(request.getParameter("location"));
        restaurant.setAddress(request.getParameter("address"));
        restaurant.setPhone(request.getParameter("phone"));
        restaurant.setHours(request.getParameter("hours"));
        restaurant.setDescription(request.getParameter("description"));
        // owner_id를 현재 로그인한 사용자의 id로 설정
        restaurant.setOwnerId(user.getId());

        // 서비스를 통해 데이터베이스에 저장
        if (restaurantService.addRestaurant(restaurant)) {
            // ▼▼▼ 성공 시 '내 가게 목록'으로 이동하는 부분 ▼▼▼
            response.sendRedirect(request.getContextPath() + "/business/restaurants");
        } else {
            // 실패 시 에러 메시지와 함께 다시 등록 폼으로
            request.setAttribute("errorMessage", "가게 등록 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/add-restaurant.jsp").forward(request, response);
        }
    }
}