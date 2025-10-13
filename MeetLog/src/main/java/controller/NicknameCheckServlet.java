package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import service.UserService;

@WebServlet("/check-nickname")
public class NicknameCheckServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger log = LoggerFactory.getLogger(NicknameCheckServlet.class);
    private final UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String nickname = request.getParameter("nickname");

        if (nickname == null || nickname.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"message\":\"닉네임을 입력해주세요.\"}");
            return;
        }

        if (userService.isNicknameExists(nickname)) {
            log.warn("닉네임 중복 확인 실패: 닉네임 중복 (nickname={})", nickname);
            response.setStatus(HttpServletResponse.SC_CONFLICT);
            response.getWriter().write("{\"message\":\"이미 사용 중인 닉네임입니다.\"}");
            return;
        }

        log.info("닉네임 사용 가능: nickname={}", nickname);
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write("{\"message\":\"사용 가능한 닉네임입니다.\"}");
    }
}