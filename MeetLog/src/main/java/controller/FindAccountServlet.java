package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.UserDAO;
import model.User;
import util.EmailUtil;
import util.PasswordUtil;

@WebServlet("/find-account")
public class FindAccountServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    	// TODO Auto-generated method stub
    	req.getRequestDispatcher("/WEB-INF/views/idpwsearch.jsp").forward(req, resp);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("findId".equals(action)) {
            findId(request, response);
        } else if ("findPw".equals(action)) {
            findPw(request, response);
        } else {
            request.setAttribute("errorMessage", "잘못된 요청입니다.");
            request.getRequestDispatcher("/WEB-INF/views/idpwsearch.jsp").forward(request, response);
        }
    }

    private void findId(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nickname = request.getParameter("nickname");
        User user = userDAO.findByNickname(nickname);

        if (user != null) {
            String email = user.getEmail();
            // 이메일 마스킹 (예: user@example.com -> us**@example.com)
            String maskedEmail = email.replaceAll("(?<=.{2}).(?=[^@]*?@)", "*");
            request.setAttribute("successMessage", "회원님의 아이디(이메일)는 " + maskedEmail + " 입니다.");
        } else {
            request.setAttribute("errorMessage", "해당 닉네임으로 가입된 회원을 찾을 수 없습니다.");
        }
        request.getRequestDispatcher("/WEB-INF/views/idpwsearch.jsp").forward(request, response);
    }

    private void findPw(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        User user = userDAO.findByEmail(email);

        if (user != null) {
            try {
                // 1. 임시 비밀번호 생성
                String tempPassword = PasswordUtil.generateTemporaryPassword(8);
                
                // 2. 비밀번호 해싱 (실제 프로덕션에서는 BCrypt와 같은 강력한 해시 사용)
                String hashedPassword = PasswordUtil.hashPassword(tempPassword);

                // 3. DB에 해시된 임시 비밀번호로 업데이트
                int result = userDAO.updatePassword(user.getId(), hashedPassword);

                if (result > 0) {
                    // 4. 사용자에게 이메일 발송
                    String subject = "[MEET LOG] 임시 비밀번호 발급 안내";
                    String body = "안녕하세요, " + user.getNickname() + "님.\n\n"
                                + "요청하신 임시 비밀번호는 다음과 같습니다.\n"
                                + "임시 비밀번호: " + tempPassword + "\n\n"
                                + "로그인 후 반드시 비밀번호를 변경해주시기 바랍니다.\n";
                    
                    EmailUtil.sendEmail(user.getEmail(), subject, body);

                    request.setAttribute("successMessage", "가입하신 이메일로 임시 비밀번호를 발송했습니다. 로그인 후 비밀번호를 변경해주세요.");
                } else {
                    throw new Exception("데이터베이스 업데이트에 실패했습니다.");
                }

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "비밀번호 재설정 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
            }
        } else {
            request.setAttribute("errorMessage", "해당 이메일로 가입된 회원을 찾을 수 없습니다.");
        }
        request.getRequestDispatcher("/WEB-INF/views/idpwsearch.jsp").forward(request, response);
    }
}