package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.BusinessUser;
import model.User;
import service.UserService;

public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserService userService = new UserService();

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
        
        // 입력값 검증
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "이메일을 입력해주세요.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }
        if (nickname == null || nickname.trim().isEmpty()) {
            request.setAttribute("errorMessage", "닉네임을 입력해주세요.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }
        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "비밀번호를 입력해주세요.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }
        if (password.length() < 6) {
            request.setAttribute("errorMessage", "비밀번호는 6자 이상이어야 합니다.");
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

        User user = new User();
        user.setEmail(email);
        user.setNickname(nickname);
        user.setPassword(password);
        user.setUserType("PERSONAL");
        
        try {
            if (userService.registerUser(user)) {
                response.sendRedirect(request.getContextPath() + "/login?register=success");
            } else {
                request.setAttribute("errorMessage", "회원가입 중 오류가 발생했습니다.");
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "회원가입 처리 중 시스템 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }

    private void handleBusinessRegister(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String hqIdentifier = request.getParameter("hqId");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String businessName = request.getParameter("businessName");
        String ownerName = request.getParameter("ownerName");
        String businessNumber = request.getParameter("businessNumber");

        // 입력값 검증
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "이메일을 입력해주세요.");
            request.getRequestDispatcher("/WEB-INF/views/business-register.jsp").forward(request, response);
            return;
        }
        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "비밀번호를 입력해주세요.");
            request.getRequestDispatcher("/WEB-INF/views/business-register.jsp").forward(request, response);
            return;
        }
        if (password.length() < 6) {
            request.setAttribute("errorMessage", "비밀번호는 6자 이상이어야 합니다.");
            request.getRequestDispatcher("/WEB-INF/views/business-register.jsp").forward(request, response);
            return;
        }
        if (businessName == null || businessName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "사업자명을 입력해주세요.");
            request.getRequestDispatcher("/WEB-INF/views/business-register.jsp").forward(request, response);
            return;
        }
        if (ownerName == null || ownerName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "대표자명을 입력해주세요.");
            request.getRequestDispatcher("/WEB-INF/views/business-register.jsp").forward(request, response);
            return;
        }

        if (userService.isEmailExists(email)) {
            request.setAttribute("errorMessage", "이미 사용 중인 이메일입니다.");
            request.getRequestDispatcher("/WEB-INF/views/business-register.jsp").forward(request, response);
            return;
        }
        if (userService.isNicknameExists(businessName)) {
            request.setAttribute("errorMessage", "이미 사용 중인 상호명(닉네임)입니다.");
            request.getRequestDispatcher("/WEB-INF/views/business-register.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setEmail(email);
        user.setNickname(businessName);
        user.setPassword(password);
        user.setUserType("BUSINESS");

        BusinessUser businessUser = new BusinessUser();
        businessUser.setBusinessName(businessName);
        businessUser.setOwnerName(ownerName);
        businessUser.setBusinessNumber(businessNumber);

        try {
            if (hqIdentifier == null || hqIdentifier.isEmpty()) {
                businessUser.setRole("HQ");
                businessUser.setStatus("ACTIVE");
                if (userService.registerHqUser(user, businessUser)) {
                    response.sendRedirect(request.getContextPath() + "/login?register=success");
                } else { throw new Exception("본사 회원 등록 실패"); }
            } else {
                BusinessUser hqUser = userService.findHqUserByIdentifier(hqIdentifier);
                if (hqUser == null) {
                    request.setAttribute("errorMessage", "존재하지 않는 본사 ID 또는 이메일입니다.");
                    request.getRequestDispatcher("/WEB-INF/views/business-register.jsp").forward(request, response);
                    return;
                }
                businessUser.setRole("BRANCH");
                businessUser.setStatus("PENDING");
                businessUser.setCompanyId(hqUser.getCompanyId());
                if (userService.registerBranchUser(user, businessUser)) {
                    response.sendRedirect(request.getContextPath() + "/login?register=pending");
                } else { throw new Exception("지점 회원 등록 실패"); }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "사업자 등록 처리 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/business-register.jsp").forward(request, response);
        }
    }
}