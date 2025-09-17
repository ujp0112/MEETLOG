package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import service.UserService;

@WebServlet({"/idpwsearch"})
public class IdPwSearchServlet extends HttpServlet {
   private UserService userService = new UserService();

   public IdPwSearchServlet() {
   }

   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      request.getRequestDispatcher("/WEB-INF/views/idpwsearch.jsp").forward(request, response);
   }

   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      request.setCharacterEncoding("UTF-8");
      String action = request.getParameter("action");
      String email = request.getParameter("email");
      String nickname = request.getParameter("nickname");

      try {
         if ("findId".equals(action)) {
            String foundEmail = this.userService.findEmailByNickname(nickname);
            if (foundEmail != null) {
               request.setAttribute("successMessage", "찾은 이메일: " + foundEmail);
            } else {
               request.setAttribute("errorMessage", "해당 닉네임으로 등록된 계정을 찾을 수 없습니다.");
            }
         } else if ("findPw".equals(action)) {
            boolean success = this.userService.resetPassword(email);
            if (success) {
               request.setAttribute("successMessage", "임시 비밀번호가 이메일로 발송되었습니다. (콘솔 로그 확인)");
            } else {
               request.setAttribute("errorMessage", "해당 이메일로 등록된 계정을 찾을 수 없습니다.");
            }
         }

         request.getRequestDispatcher("/WEB-INF/views/idpwsearch.jsp").forward(request, response);
      } catch (Exception var7) {
         var7.printStackTrace();
         request.setAttribute("errorMessage", "처리 중 오류가 발생했습니다.");
         request.getRequestDispatcher("/WEB-INF/views/idpwsearch.jsp").forward(request, response);
      }
   }
}