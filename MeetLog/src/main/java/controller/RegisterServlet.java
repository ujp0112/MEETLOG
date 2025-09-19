package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.User;
import model.BusinessUser;
import service.UserService;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type = request.getParameter("type");
        if ("business".equals(type)) {
            request.getRequestDispatcher("/WEB-INF/views/business-register.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String userType = request.getParameter("userType");

        if ("BUSINESS".equals(userType)) {
            handleBusinessRegister(request, response);
        } else {
            handlePersonalRegister(request, response);
        }
    }

    private void handlePersonalRegister(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String nickname = request.getParameter("nickname");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (password == null || !password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "비밀번호가 일치하지 않습니다.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }
        if (userService.isEmailExists(email)) {
            request.setAttribute("errorMessage", "이미 사용 중인 이메일입니다.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }
        if (userService.isNicknameExists(nickname)) {
            request.setAttribute("errorMessage", "이미 사용 중인 닉네임입니다.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        User user = new User(email, nickname, password, "PERSONAL");
        if (userService.registerUser(user)) {
            response.sendRedirect(request.getContextPath() + "/login?register=success");
        } else {
            request.setAttribute("errorMessage", "회원가입 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }

    private void handleBusinessRegister(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String businessName = request.getParameter("businessName");
        String ownerName = request.getParameter("ownerName");
        String businessNumber = request.getParameter("businessNumber");

        if (userService.isEmailExists(email)) {
            request.setAttribute("errorMessage", "이미 사용 중인 이메일입니다.");
            request.getRequestDispatcher("/WEB-INF/views/business-register.jsp").forward(request, response);
            return;
        }
        
        User user = new User(email, businessName, password, "BUSINESS");
        
        BusinessUser businessUser = new BusinessUser();
        businessUser.setBusinessName(businessName);
        businessUser.setOwnerName(ownerName);
        businessUser.setBusinessNumber(businessNumber);

        if (userService.registerBusinessUser(user, businessUser)) {
            response.sendRedirect(request.getContextPath() + "/login?register=success");
        } else {
            request.setAttribute("errorMessage", "사업자 등록 중 오류가 발생했습니다. 다시 시도해주세요.");
            request.getRequestDispatcher("/WEB-INF/views/business-register.jsp").forward(request, response);
        }
    }
}