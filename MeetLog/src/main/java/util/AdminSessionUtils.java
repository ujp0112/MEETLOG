package util;

import model.User;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 공통 관리자 세션 유틸리티.
 * 필터가 적용되지 않은 곳에서도 일관된 권한 체크를 제공하기 위해 사용합니다.
 */
public final class AdminSessionUtils {

    private AdminSessionUtils() {
        // 유틸 클래스이므로 인스턴스화 금지
    }

    /**
     * 현재 세션에서 관리자 권한을 확인하고, 없으면 로그인 페이지로 리다이렉트합니다.
     *
     * @return 관리자 사용자 객체, 권한이 없으면 {@code null}
     */
    public static User requireAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User adminUser = getAdminUser(request);
        if (adminUser == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
        }
        return adminUser;
    }

    public static User getAdminUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        User adminUser = (User) session.getAttribute("user");
        if (adminUser == null || adminUser.getUserType() == null || !"ADMIN".equals(adminUser.getUserType())) {
            return null;
        }
        return adminUser;
    }
}
