package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;
import service.UserService;

//@WebServlet({"/login"})
public class LoginServlet extends HttpServlet {
   private UserService userService = new UserService();

   public LoginServlet() {
   }

   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
   }

   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      request.setCharacterEncoding("UTF-8");
      String email = request.getParameter("email");
      String password = request.getParameter("password");
      String userType = request.getParameter("userType"); // "PERSONAL"로 고정되어 들어옴

      try {
         // 1. JSP가 요청한 "PERSONAL" 타입으로 우선 인증 시도
         User user = this.userService.authenticateUser(email, password, userType);

         // [논리 오류 수정] 
         // 2. 만약 PERSONAL 인증이 실패했다면, 관리자(ADMIN)일 가능성이 있으므로 ADMIN으로 재시도합니다.
         if (user == null) {
            user = this.userService.authenticateUser(email, password, "ADMIN");
         }

         if (user != null) {
            // 인증 성공
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userType", user.getUserType()); // 실제 DB의 userType (ADMIN 또는 PERSONAL)
            
            // 관리자인 경우 관리자 대시보드로, 일반 사용자는 메인으로 리다이렉트
            if ("ADMIN".equals(user.getUserType())) {
                response.sendRedirect(request.getContextPath() + "/admin");
            } else {
                response.sendRedirect(request.getContextPath() + "/main");
            }
         } else {
            // PERSONAL, ADMIN 모두 인증 실패
            request.setAttribute("errorMessage", "아이디 또는 비밀번호가 올바르지 않습니다.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
         }
      } catch (Exception var8) {
         var8.printStackTrace();
         request.setAttribute("errorMessage", "로그인 중 오류가 발생했습니다.");
         request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
      }
   }
}