package controller;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Review;
import model.Restaurant;
import model.User;
import service.ReviewService;
import service.RestaurantService;

// [아키텍처 오류 수정] 기존 JDBC 서블릿을 삭제하고 Service 계층을 사용하는 컨트롤러로 변경합니다.
//@WebServlet("/review/*")
public class ReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private ReviewService reviewService = new ReviewService();
    private RestaurantService restaurantService = new RestaurantService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if ("/write".equals(pathInfo)) {
                // 리뷰 작성 폼 페이지로 이동
                handleReviewWriteForm(request, response);
            } else {
                // 기본 경로는 전체 리뷰 목록 페이지
                handleReviewList(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "리뷰 페이지 처리 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String pathInfo = request.getPathInfo();

        if ("/write".equals(pathInfo)) {
            // 리뷰 작성 폼 제출 처리
            handleReviewWriteSubmit(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void handleReviewWriteForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 리뷰 작성 폼을 보여주려면, 대상 식당 정보가 필요합니다.
        try {
            int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
            Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
            if (restaurant != null) {
                request.setAttribute("restaurant", restaurant);
                request.getRequestDispatcher("/WEB-INF/views/write-review.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "식당 정보 없음");
            }
        } catch (NumberFormatException e) {
             response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 식당 ID");
        }
    }
    
    private void handleReviewList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 전체 리뷰 목록 (기존 JDBC doGet 대체)
        List<Review> reviews = reviewService.getRecentReviews(50); // 최근 50개
        request.setAttribute("reviews", reviews);
        request.getRequestDispatcher("/WEB-INF/views/review-list.jsp").forward(request, response);
    }
    
    private void handleReviewWriteSubmit(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int restaurantId = 0;
        try {
            restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String content = request.getParameter("content");
            String keywordsInput = request.getParameter("keywords");

            List<String> keywordsList = null;
            if (keywordsInput != null && !keywordsInput.trim().isEmpty()) {
                 keywordsList = Arrays.stream(keywordsInput.split(","))
                                      .map(String::trim)
                                      .filter(tag -> !tag.isEmpty())
                                      .collect(Collectors.toList());
            }

            Review review = new Review();
            review.setRestaurantId(restaurantId);
            review.setUserId(user.getId());
            review.setAuthor(user.getNickname());
            review.setAuthorImage(user.getProfileImage());
            review.setRating(rating);
            review.setContent(content);
            review.setKeywords(keywordsList); // 키워드 리스트 설정

            if (reviewService.addReview(review)) {
                // 리뷰 등록 성공 시, 해당 맛집 상세 페이지로 리다이렉트
                response.sendRedirect(request.getContextPath() + "/restaurant/detail/" + restaurantId);
            } else {
                throw new Exception("리뷰 등록 실패 (DB insert 실패)");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "리뷰 등록 실패");
            // 폼으로 다시 보내기 위해 식당 정보 다시 로드
            Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
            request.setAttribute("restaurant", restaurant);
            request.getRequestDispatcher("/WEB-INF/views/write-review.jsp").forward(request, response);
        }
    }
}