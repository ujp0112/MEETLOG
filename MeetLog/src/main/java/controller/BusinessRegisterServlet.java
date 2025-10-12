package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponse;

import model.BusinessUser;
import model.Restaurant;
import model.User;
import model.Company;
import service.BusinessUserService;
import service.UserService;
import util.PasswordUtil;

public class BusinessRegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserService userService = new UserService();
    private final BusinessUserService businessUserService = new BusinessUserService();

    // doGet 메서드는 변경 없습니다.
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/business-register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String userType = request.getParameter("userType");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String businessName = request.getParameter("businessName");
        String ownerName = request.getParameter("ownerName");
        String businessNumber = request.getParameter("businessNumber");
        String category = request.getParameter("category");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String description = request.getParameter("description");
        String verificationCode = request.getParameter("verificationCode");

        // 세션에서 인증 정보 가져오기
        Object sessionCodeObj = request.getSession().getAttribute("verificationCode");
        Object sessionEmailObj = request.getSession().getAttribute("verificationEmail");

        if (sessionCodeObj == null || sessionEmailObj == null ||
            !sessionEmailObj.toString().equals(email) || !sessionCodeObj.toString().equals(verificationCode)) {
            request.setAttribute("errorMessage", "이메일 인증 정보가 올바르지 않습니다. 다시 시도해주세요.");
            request.getRequestDispatcher("/WEB-INF/views/business-register.jsp").forward(request, response);
            return;
        }

        if (password == null || !password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "비밀번호가 일치하지 않습니다.");
            request.getRequestDispatcher("/WEB-INF/views/business-register.jsp").forward(request, response);
            return;
        }
        
        // EmailVerificationServlet에서 이미 중복 검사를 하지만, 최종 제출 시 한 번 더 확인
        if (userService.isEmailExists(email)) {
            request.setAttribute("errorMessage", "이미 사용 중인 이메일입니다.");
            request.getRequestDispatcher("/WEB-INF/views/business-register.jsp").forward(request, response);
            return;
        }
        
        try {
            User user = new User();
            user.setEmail(email);
            user.setNickname(businessName);
            user.setPassword(password);
            user.setUserType("BUSINESS");
            user.setName(ownerName);
            user.setPhone(phone);
            user.setAddress(address);
            user.setActive(true); 

            Restaurant restaurant = new Restaurant();
            restaurant.setName(businessName);
            restaurant.setCategory(category);
            restaurant.setAddress(address);
            restaurant.setPhone(phone);
            restaurant.setDescription(description);
            // ▼▼▼ [최종 수정] 누락되었던 location 값 설정 ▼▼▼
            restaurant.setLocation(address); // 주소 값을 지역 정보로 우선 사용

            if ("BUSINESS_HQ".equals(userType)) {
                Company company = new Company();
                company.setName(businessName);
                handleHqRegister(user, businessName, ownerName, businessNumber, restaurant, company);
            } else if ("BUSINESS_BRANCH".equals(userType)) {
                handleBranchRegister(request, user, businessName, ownerName, businessNumber, restaurant);
            } else if ("BUSINESS_INDIVIDUAL".equals(userType)) {
            	Company company = new Company();
                company.setName(businessName);
                handleIndividualRegister(user, businessName, ownerName, businessNumber, restaurant, company);
            } else {
                throw new ServletException("잘못된 회원 유형입니다.");
            }

            // 회원가입 성공 시 세션의 인증 정보 제거
            request.getSession().removeAttribute("verificationCode");
            request.getSession().removeAttribute("verificationEmail");

            response.sendRedirect(request.getContextPath() + "/login?register=success");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "회원가입 처리 중 오류가 발생했습니다: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/business-register.jsp").forward(request, response);
        }
    }

    private void handleHqRegister(User user, String businessName, String ownerName, String businessNumber, Restaurant restaurant, Company company) throws Exception {
        BusinessUser businessUser = new BusinessUser();
        businessUser.setBusinessName(businessName);
        businessUser.setOwnerName(ownerName);
        businessUser.setBusinessNumber(businessNumber);
        businessUser.setRole("HQ");
        businessUser.setStatus("APPROVED");
        
        businessUserService.registerHqUser(user, businessUser, restaurant, company);
    }

    private void handleBranchRegister(HttpServletRequest request, User user, String businessName, String ownerName, String businessNumber, Restaurant restaurant) throws Exception {
        String hqIdentifier = request.getParameter("hqId");
        if (hqIdentifier == null || hqIdentifier.trim().isEmpty()) {
            throw new Exception("본사 식별자(이메일 또는 ID)를 입력해주세요.");
        }

        BusinessUser hqInfo = businessUserService.findHqByIdentifier(hqIdentifier);
        if (hqInfo == null) {
            throw new Exception("존재하지 않는 본사입니다. 본사 식별자를 다시 확인해주세요.");
        }

        BusinessUser businessUser = new BusinessUser();
        businessUser.setBusinessName(businessName);
        businessUser.setOwnerName(ownerName);
        businessUser.setBusinessNumber(businessNumber);
        businessUser.setRole("BRANCH");
        businessUser.setStatus("PENDING");
        businessUser.setCompanyId(hqInfo.getCompanyId());
        
        businessUserService.registerBranchUser(user, businessUser, restaurant);
    }
    
    private void handleIndividualRegister(User user, String businessName, String ownerName, String businessNumber, Restaurant restaurant, Company company) throws Exception {
        BusinessUser businessUser = new BusinessUser();
        businessUser.setBusinessName(businessName);
        businessUser.setOwnerName(ownerName);
        businessUser.setBusinessNumber(businessNumber);
        businessUser.setRole("INDIVIDUAL");
        businessUser.setStatus("APPROVED");
        
        businessUserService.registerIndividualUser(user, businessUser, restaurant, company);
    }
}