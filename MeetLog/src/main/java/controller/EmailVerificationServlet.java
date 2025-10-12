package controller;

import java.io.IOException;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import service.UserService;
import util.EmailUtil;

public class EmailVerificationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger log = LoggerFactory.getLogger(EmailVerificationServlet.class);
    private final UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"message\":\"이메일을 입력해주세요.\"}");
            return;
        }

        if (userService.isEmailExists(email)) {
            log.warn("이메일 인증 시도 실패: 이메일 중복 (email={})", email);
            response.setStatus(HttpServletResponse.SC_CONFLICT);
            response.getWriter().write("{\"message\":\"이미 사용 중인 이메일입니다.\"}");
            return;
        }

        // 6자리 인증 코드 생성
        String verificationCode = String.format("%06d", new Random().nextInt(999999));

        HttpSession session = request.getSession();
        session.setAttribute("verificationCode", verificationCode);
        session.setAttribute("verificationEmail", email);
        // 세션 유효시간 5분으로 설정
        session.setMaxInactiveInterval(5 * 60); 

        String subject = "[MEET LOG] 회원가입 인증번호 안내";
        String body = "MEET LOG 회원가입을 위한 인증번호는 [" + verificationCode + "] 입니다.\n"
                    + "인증번호를 5분 내에 입력해주세요.";

        // EmailUtil을 사용하여 비동기 이메일 발송
        EmailUtil.sendEmail(email, subject, body);
        log.info("이메일 인증번호 발송: email={}, code={}", email, verificationCode);

        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write("{\"message\":\"인증번호가 발송되었습니다. 5분 내에 입력해주세요.\"}");
    }
}