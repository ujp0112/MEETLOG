package controller.telegram;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import dao.TgLinkDAO;
import model.TgLink;
import model.User;
import util.AppConfig;

/**
 * 텔레그램 연결 관리 서블릿
 * - 토큰 발급: POST /telegram/link (새 토큰 생성 또는 갱신)
 * - 연결 상태 조회: GET /telegram/link
 * - 연결 해제: DELETE /telegram/link
 */
@WebServlet("/telegram/link")
public class TelegramLinkServlet extends HttpServlet {
    private static final Logger log = LoggerFactory.getLogger(TelegramLinkServlet.class);
    private final TgLinkDAO tgLinkDAO = new TgLinkDAO();

    /**
     * GET: 현재 연결 상태 조회
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"로그인이 필요합니다.\"}");
            return;
        }

        User user = (User) session.getAttribute("user");
        TgLink link = tgLinkDAO.findByUserId(user.getId());

        if (link == null) {
            response.getWriter().write("{\"connected\":false}");
        } else {
            String json = String.format(
                    "{\"connected\":true,\"state\":\"%s\",\"chatId\":\"%s\"}",
                    link.getState(),
                    link.getChatId() != null ? link.getChatId() : ""
            );
            response.getWriter().write(json);
        }
    }

    /**
     * POST: 텔레그램 연결 토큰 발급
     * 반환: {"token": "...", "deepLink": "https://t.me/BOT_NAME?start=TOKEN"}
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"로그인이 필요합니다.\"}");
            return;
        }

        User user = (User) session.getAttribute("user");
        String token = UUID.randomUUID().toString().replace("-", "");

        try {
            // PENDING 상태로 토큰 발급 (기존 레코드 있으면 갱신)
            tgLinkDAO.upsertPending(user.getId(), token);

            // 텔레그램 봇 이름 가져오기
            String botName = AppConfig.getProperty("telegram.bot.name", "meetlog_bot");
            String deepLink = String.format("https://t.me/%s?start=%s", botName, token);

            log.info("텔레그램 연결 토큰 발급 완료: userId={}, token={}", user.getId(), token);

            String json = String.format(
                    "{\"success\":true,\"token\":\"%s\",\"deepLink\":\"%s\"}",
                    token, deepLink
            );
            response.getWriter().write(json);

        } catch (Exception e) {
            log.error("텔레그램 토큰 발급 실패: userId={}", user.getId(), e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"토큰 발급에 실패했습니다.\"}");
        }
    }

    /**
     * DELETE: 텔레그램 연결 해제
     */
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"로그인이 필요합니다.\"}");
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            int deleted = tgLinkDAO.deleteByUserId(user.getId());
            if (deleted > 0) {
                log.info("텔레그램 연결 해제 완료: userId={}", user.getId());
                response.getWriter().write("{\"success\":true}");
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"연결 정보가 없습니다.\"}");
            }
        } catch (Exception e) {
            log.error("텔레그램 연결 해제 실패: userId={}", user.getId(), e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"연결 해제에 실패했습니다.\"}");
        }
    }
}
