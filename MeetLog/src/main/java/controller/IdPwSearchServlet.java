package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import service.UserService;

public class IdPwSearchServlet extends HttpServlet {
   private static final long serialVersionUID = 1L;
   private final UserService userService = new UserService();

   public IdPwSearchServlet() {
       super();
   }

   @Override
   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      request.getRequestDispatcher("/WEB-INF/views/idpwsearch.jsp").forward(request, response);
   }

   @Override
   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      request.setCharacterEncoding("UTF-8");
      String action = request.getParameter("action");
      
      try {
         if ("findId".equals(action)) {
            String nickname = request.getParameter("nickname");
            String foundEmail = userService.findEmailByNickname(nickname);
            if (foundEmail != null) {
               // 이메일의 일부를 마스킹 처리하여 보여주는 것이 보안상 좋습니다.
               request.setAttribute("successMessage", "회원님의 이메일은 " + maskEmail(foundEmail) + " 입니다.");
            } else {
               request.setAttribute("errorMessage", "해당 닉네임으로 등록된 계정을 찾을 수 없습니다.");
            }
         } else if ("findPw".equals(action)) {
            String email = request.getParameter("email");
            boolean success = userService.resetPassword(email);
            if (success) {
               request.setAttribute("successMessage", "임시 비밀번호가 이메일로 발송되었습니다. (실제 서비스에서는 이메일 발송, 현재는 콘솔 로그 확인)");
            } else {
               request.setAttribute("errorMessage", "해당 이메일로 등록된 계정을 찾을 수 없습니다.");
            }
         }
         request.getRequestDispatcher("/WEB-INF/views/idpwsearch.jsp").forward(request, response);
      } catch (Exception e) {
         e.printStackTrace();
         request.setAttribute("errorMessage", "처리 중 오류가 발생했습니다.");
         request.getRequestDispatcher("/WEB-INF/views/idpwsearch.jsp").forward(request, response);
      }
   }
   
   private String maskEmail(String email) {
        if (email == null || !email.contains("@")) {
            return email;
        }
        int atIndex = email.indexOf("@");
        if (atIndex <= 3) { // 아이디가 3글자 이하이면 앞 1글자만 보여줌
            return email.charAt(0) + "**" + email.substring(atIndex);
        }
        // 아이디의 앞 3글자만 보여주고 나머지는 * 처리
        return email.substring(0, 3) + "****" + email.substring(atIndex);
   }
}