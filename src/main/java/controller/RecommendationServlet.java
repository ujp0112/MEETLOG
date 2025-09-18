package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.RestaurantRecommendation;
import model.User;
import service.RecommendationService;

/**
 * 개인화 추천 시스템을 위한 서블릿
 * 다양한 추천 알고리즘을 제공합니다.
 */

public class RecommendationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private RecommendationService recommendationService = new RecommendationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        try {
            if (user == null) {
                // 로그인하지 않은 사용자는 인기 맛집 추천
                handlePopularRecommendations(request, response);
            } else {
                // 로그인한 사용자는 개인화 추천
                switch (pathInfo) {
                    case "/personalized":
                        handlePersonalizedRecommendations(request, response, user);
                        break;
                    case "/collaborative":
                        handleCollaborativeRecommendations(request, response, user);
                        break;
                    case "/content-based":
                        handleContentBasedRecommendations(request, response, user);
                        break;
                    case "/hybrid":
                        handleHybridRecommendations(request, response, user);
                        break;
                    case "/analyze-preferences":
                        handleAnalyzePreferences(request, response, user);
                        break;
                    default:
                        handlePersonalizedRecommendations(request, response, user);
                        break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "추천 시스템 처리 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            if ("/analyze-preferences".equals(pathInfo)) {
                // 사용자 취향 분석 요청
                recommendationService.analyzeUserPreferences(user.getId());
                response.getWriter().write("{\"status\":\"success\",\"message\":\"취향 분석이 완료되었습니다.\"}");
                response.setContentType("application/json");
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"status\":\"error\",\"message\":\"처리 중 오류가 발생했습니다.\"}");
            response.setContentType("application/json");
        }
    }

    /**
     * 개인화 추천 (하이브리드 방식)
     */
    private void handlePersonalizedRecommendations(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        int limit = getLimitParameter(request, 6);
        
        // 사용자 취향 분석 (백그라운드에서 실행)
        try {
            recommendationService.analyzeUserPreferences(user.getId());
        } catch (Exception e) {
            // 분석 실패해도 추천은 계속 진행
            e.printStackTrace();
        }
        
        // 하이브리드 추천 실행
        List<RestaurantRecommendation> recommendations = recommendationService.getHybridRecommendations(user.getId(), limit);
        
        request.setAttribute("recommendations", recommendations);
        request.setAttribute("recommendationType", "personalized");
        request.setAttribute("title", "나만의 맞춤 추천");
        
        request.getRequestDispatcher("/WEB-INF/views/recommendation-results.jsp").forward(request, response);
    }

    /**
     * 협업 필터링 추천
     */
    private void handleCollaborativeRecommendations(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        int limit = getLimitParameter(request, 6);
        List<RestaurantRecommendation> recommendations = recommendationService.getCollaborativeRecommendations(user.getId(), limit);
        
        request.setAttribute("recommendations", recommendations);
        request.setAttribute("recommendationType", "collaborative");
        request.setAttribute("title", "비슷한 취향의 사용자들이 좋아한 맛집");
        
        request.getRequestDispatcher("/WEB-INF/views/recommendation-results.jsp").forward(request, response);
    }

    /**
     * 콘텐츠 기반 추천
     */
    private void handleContentBasedRecommendations(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        String restaurantIdStr = request.getParameter("restaurantId");
        int limit = getLimitParameter(request, 6);
        
        if (restaurantIdStr == null) {
            // 특정 맛집이 없으면 사용자 취향 기반 추천
            List<RestaurantRecommendation> recommendations = recommendationService.getPreferenceBasedRecommendations(user.getId(), limit);
            request.setAttribute("recommendations", recommendations);
            request.setAttribute("recommendationType", "preference-based");
            request.setAttribute("title", "당신의 취향에 맞는 맛집");
        } else {
            // 특정 맛집과 비슷한 맛집 추천
            int restaurantId = Integer.parseInt(restaurantIdStr);
            List<RestaurantRecommendation> recommendations = recommendationService.getContentBasedRecommendations(restaurantId, limit);
            request.setAttribute("recommendations", recommendations);
            request.setAttribute("recommendationType", "content-based");
            request.setAttribute("title", "이 맛집과 비슷한 맛집들");
        }
        
        request.getRequestDispatcher("/WEB-INF/views/recommendation-results.jsp").forward(request, response);
    }

    /**
     * 하이브리드 추천
     */
    private void handleHybridRecommendations(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        int limit = getLimitParameter(request, 6);
        List<RestaurantRecommendation> recommendations = recommendationService.getHybridRecommendations(user.getId(), limit);
        
        request.setAttribute("recommendations", recommendations);
        request.setAttribute("recommendationType", "hybrid");
        request.setAttribute("title", "AI가 추천하는 맞춤 맛집");
        
        request.getRequestDispatcher("/WEB-INF/views/recommendation-results.jsp").forward(request, response);
    }

    /**
     * 인기 맛집 추천 (로그인하지 않은 사용자용)
     */
    private void handlePopularRecommendations(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int limit = getLimitParameter(request, 6);
        List<RestaurantRecommendation> recommendations = recommendationService.getFallbackRecommendations(limit);
        
        request.setAttribute("recommendations", recommendations);
        request.setAttribute("recommendationType", "popular");
        request.setAttribute("title", "인기 맛집");
        
        request.getRequestDispatcher("/WEB-INF/views/recommendation-results.jsp").forward(request, response);
    }

    /**
     * 사용자 취향 분석
     */
    private void handleAnalyzePreferences(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        try {
            recommendationService.analyzeUserPreferences(user.getId());
            request.setAttribute("successMessage", "취향 분석이 완료되었습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "취향 분석 중 오류가 발생했습니다.");
        }
        
        request.getRequestDispatcher("/WEB-INF/views/mypage.jsp").forward(request, response);
    }

    /**
     * limit 파라미터 추출 (기본값 6)
     */
    private int getLimitParameter(HttpServletRequest request, int defaultValue) {
        String limitStr = request.getParameter("limit");
        if (limitStr != null && !limitStr.trim().isEmpty()) {
            try {
                return Integer.parseInt(limitStr);
            } catch (NumberFormatException e) {
                return defaultValue;
            }
        }
        return defaultValue;
    }
}
