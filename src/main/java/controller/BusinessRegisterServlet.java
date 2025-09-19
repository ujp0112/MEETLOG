package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.User;
import model.Restaurant;
import service.UserService;
import service.RestaurantService;
import util.PasswordUtil;

public class BusinessRegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService = new UserService();
    private RestaurantService restaurantService = new RestaurantService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/business-register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String businessName = request.getParameter("businessName");
        String ownerName = request.getParameter("ownerName");
        String businessNumber = request.getParameter("businessNumber");
        String category = request.getParameter("category");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // 비밀번호 확인
        if (password == null || !password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "비밀번호가 일치하지 않습니다.");
            request.getRequestDispatcher("/WEB-INF/views/business-register.jsp").forward(request, response);
            return;
        }

        // 이메일 중복 확인
        if (userService.isEmailExists(email)) {
            request.setAttribute("errorMessage", "이미 사용 중인 이메일입니다.");
            request.getRequestDispatcher("/WEB-INF/views/business-register.jsp").forward(request, response);
            return;
        }

        // 사업자 등록 처리
        try {
            // 1. 사용자 먼저 생성
            User user = new User();
            user.setEmail(email);
            user.setPassword(PasswordUtil.hashPassword(password));
            user.setUserType("BUSINESS");
            user.setNickname(businessName);
            
            if (!userService.registerUser(user)) {
                request.setAttribute("errorMessage", "사용자 등록에 실패했습니다.");
                request.getRequestDispatcher("/WEB-INF/views/business-register.jsp").forward(request, response);
                return;
            }
            
            // 2. 생성된 사용자 ID 가져오기
            User createdUser = userService.findByEmail(email);
            int userId = createdUser.getId();
            
            // 3. 음식점 생성
            Restaurant restaurant = new Restaurant();
            restaurant.setOwnerId(userId);
            restaurant.setName(businessName);
            restaurant.setCategory(category);
            restaurant.setAddress(address);
            restaurant.setPhone(phone);
            restaurant.setDescription(ownerName + "님이 운영하는 " + category + " 전문점입니다.");
            restaurant.setActive(true);
            
            boolean restaurantCreated = restaurantService.createRestaurant(restaurant);
            if (!restaurantCreated) {
                request.setAttribute("errorMessage", "음식점 등록에 실패했습니다.");
                request.getRequestDispatcher("/WEB-INF/views/business-register.jsp").forward(request, response);
                return;
            }
            
            // 4. 생성된 음식점의 ID를 가져와서 사용자와 연결
            Restaurant createdRestaurant = restaurantService.findByOwnerId(userId).get(0);
            int restaurantId = createdRestaurant.getId();
            
            // 5. 사용자에 음식점 ID 설정
            createdUser.setRestaurantId(restaurantId);
            userService.updateUser(createdUser);
            
            // 사업자 등록 성공 시 로그인 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/login?register=success&type=business");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "사업자 등록 중 오류가 발생했습니다: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/business-register.jsp").forward(request, response);
        }
    }
}
