package filter;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import util.SecurityUtils;

/**
 * 보안 필터 - XSS 방지, CSRF 보호, 브루트 포스 방지 등
 */
@WebFilter("/*")
public class SecurityFilter implements Filter {

    // CSRF 보호가 필요한 경로들
    private static final List<String> CSRF_PROTECTED_PATHS = Arrays.asList(
        "/user/register", "/user/login", "/user/update",
        "/business/register", "/business/update",
        "/reservation/create", "/reservation/update",
        "/review/create", "/review/update",
        "/qna/create", "/qna/reply"
    );

    // 브루트 포스 보호가 필요한 경로들
    private static final List<String> BRUTE_FORCE_PROTECTED_PATHS = Arrays.asList(
        "/user/login", "/business/login", "/admin/login"
    );

    // 정적 리소스 경로들 (필터링 제외)
    private static final List<String> STATIC_RESOURCE_PATHS = Arrays.asList(
        "/css/", "/js/", "/img/", "/uploads/", "/favicon.ico"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 필터 초기화
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());

        // 정적 리소스는 필터링 건너뛰기
        if (isStaticResource(path)) {
            chain.doFilter(request, response);
            return;
        }

        try {
            // 1. 보안 헤더 설정
            setSecurityHeaders(httpResponse);

            // 2. XSS 방지 - 요청 파라미터 sanitization
            HttpServletRequest sanitizedRequest = new XSSRequestWrapper(httpRequest);

            // 3. 브루트 포스 공격 방지
            if (shouldCheckBruteForce(path) && isBruteForceBlocked(httpRequest)) {
                httpResponse.setStatus(429); // Too Many Requests
                httpResponse.getWriter().write("{\"success\": false, \"message\": \"너무 많은 시도로 인해 일시적으로 차단되었습니다. 15분 후 다시 시도해주세요.\"}");
                return;
            }

            // 4. CSRF 보호
            if (shouldCheckCSRF(path, httpRequest.getMethod()) && !validateCSRF(httpRequest)) {
                httpResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
                httpResponse.getWriter().write("{\"success\": false, \"message\": \"잘못된 요청입니다. 페이지를 새로고침하고 다시 시도해주세요.\"}");
                return;
            }

            // 5. 세션 보안 강화
            secureSession(httpRequest);

            // 정상 처리 계속
            chain.doFilter(sanitizedRequest, response);

        } catch (Exception e) {
            e.printStackTrace();
            httpResponse.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            httpResponse.getWriter().write("{\"success\": false, \"message\": \"서버 오류가 발생했습니다.\"}");
        }
    }

    @Override
    public void destroy() {
        // 필터 소멸 시 정리 작업
    }

    /**
     * 보안 헤더 설정
     */
    private void setSecurityHeaders(HttpServletResponse response) {
        // XSS 보호
        response.setHeader("X-Content-Type-Options", "nosniff");
        response.setHeader("X-Frame-Options", "DENY");
        response.setHeader("X-XSS-Protection", "1; mode=block");

        // HTTPS 강제 (프로덕션에서)
        // response.setHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains");

        // 콘텐츠 보안 정책
        response.setHeader("Content-Security-Policy",
            "default-src 'self'; " +
            "script-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://cdnjs.cloudflare.com https://cdn.tailwindcss.com; " +
            "style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://cdnjs.cloudflare.com https://fonts.googleapis.com; " +
            "img-src 'self' data: https:; " +
            "font-src 'self' https://cdnjs.cloudflare.com https://fonts.gstatic.com"
        );

        // 캐시 제어
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
    }

    /**
     * 정적 리소스 경로 체크
     */
    private boolean isStaticResource(String path) {
        return STATIC_RESOURCE_PATHS.stream().anyMatch(path::startsWith);
    }

    /**
     * 브루트 포스 보호 대상 경로 체크
     */
    private boolean shouldCheckBruteForce(String path) {
        return BRUTE_FORCE_PROTECTED_PATHS.stream().anyMatch(path::startsWith);
    }

    /**
     * 브루트 포스 공격 차단 여부 체크
     */
    private boolean isBruteForceBlocked(HttpServletRequest request) {
        String clientIP = SecurityUtils.getClientIP(request);
        return SecurityUtils.BruteForceProtection.isBlocked(clientIP);
    }

    /**
     * CSRF 보호 대상 체크
     */
    private boolean shouldCheckCSRF(String path, String method) {
        // POST, PUT, DELETE 요청만 CSRF 보호
        if (!"POST".equalsIgnoreCase(method) &&
            !"PUT".equalsIgnoreCase(method) &&
            !"DELETE".equalsIgnoreCase(method)) {
            return false;
        }

        return CSRF_PROTECTED_PATHS.stream().anyMatch(path::startsWith);
    }

    /**
     * CSRF 토큰 검증
     */
    private boolean validateCSRF(HttpServletRequest request) {
        // AJAX 요청의 경우 헤더에서도 토큰 확인
        String contentType = request.getContentType();
        if (contentType != null && contentType.contains("application/json")) {
            String headerToken = request.getHeader("X-CSRF-Token");
            if (headerToken != null) {
                HttpSession session = request.getSession(false);
                if (session != null) {
                    String sessionToken = (String) session.getAttribute("CSRF_TOKEN");
                    return headerToken.equals(sessionToken);
                }
            }
        }

        // 일반 폼 요청의 경우
        return SecurityUtils.validateCSRFToken(request);
    }

    /**
     * 세션 보안 강화
     */
    private void secureSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            // 세션 하이재킹 방지 - IP 주소 검증
            String currentIP = SecurityUtils.getClientIP(request);
            String sessionIP = (String) session.getAttribute("SESSION_IP");

            if (sessionIP == null) {
                session.setAttribute("SESSION_IP", currentIP);
            } else if (!sessionIP.equals(currentIP)) {
                // IP 주소가 변경된 경우 세션 무효화
                session.invalidate();
                return;
            }

            // 세션 타임아웃 설정 (30분)
            session.setMaxInactiveInterval(30 * 60);

            // CSRF 토큰이 없는 경우 생성
            if (session.getAttribute("CSRF_TOKEN") == null) {
                SecurityUtils.setCSRFToken(session);
            }
        }
    }

    /**
     * XSS 방지를 위한 요청 래퍼 클래스
     */
    private static class XSSRequestWrapper extends javax.servlet.http.HttpServletRequestWrapper {

        public XSSRequestWrapper(HttpServletRequest request) {
            super(request);
        }

        @Override
        public String getParameter(String name) {
            String value = super.getParameter(name);
            return SecurityUtils.sanitizeXSS(value);
        }

        @Override
        public String[] getParameterValues(String name) {
            String[] values = super.getParameterValues(name);
            if (values == null) return null;

            String[] sanitizedValues = new String[values.length];
            for (int i = 0; i < values.length; i++) {
                sanitizedValues[i] = SecurityUtils.sanitizeXSS(values[i]);
            }
            return sanitizedValues;
        }

        @Override
        public String getHeader(String name) {
            String value = super.getHeader(name);
            return SecurityUtils.sanitizeXSS(value);
        }
    }
}