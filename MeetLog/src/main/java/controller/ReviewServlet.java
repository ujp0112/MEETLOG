package controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import model.Review;
import model.Restaurant;
import model.User;
import service.ReviewService;
import service.RestaurantService;
import service.FeedService;
import util.AppConfig; // AppConfig 임포트 확인

@WebServlet({"/review/*"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class ReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    // 이 상수는 이제 사용되지 않지만, 참고용으로 남겨둘 수 있습니다.
    private static final String UPLOAD_DIR_DEPRECATED = "uploads" + File.separator + "reviews";
    private ReviewService reviewService = new ReviewService();
    private RestaurantService restaurantService = new RestaurantService();
    private FeedService feedService = new FeedService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String[] pathParts = pathInfo.split("/");
        String action = pathParts.length > 1 ? pathParts[1] : "";

        switch (action) {
            case "write":
                showWriteReviewForm(request, response);
                break;
            case "edit":
                showEditReviewForm(request, response);
                break;
            case "delete":
                handleDeleteReview(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String pathInfo = request.getPathInfo();

        String[] pathParts = pathInfo != null ? pathInfo.split("/") : new String[0];
        String action = pathParts.length > 1 ? pathParts[1] : "";

        if (pathInfo == null || (!pathInfo.equals("/write") && !pathInfo.equals("/edit") && !pathInfo.equals("/delete"))) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            if ("/delete".equals(pathInfo)) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"success\": false, \"message\": \"로그인이 필요합니다.\"}");
                return;
            } else {
                response.sendRedirect(request.getContextPath() + "/user/login");
                return;
            }
        }

        if ("/write".equals(pathInfo)) {
            handleWriteReview(request, response);
        } else if ("/edit".equals(pathInfo)) {
            handleEditReview(request, response);
        } else if ("/delete".equals(pathInfo)) {
            handleDeleteReview(request, response);
        }
    }

    private void handleWriteReview(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String content = request.getParameter("content");
            String keywords = request.getParameter("keywords");

            List<String> imageFileNames = new ArrayList<>();
            Collection<Part> parts = request.getParts();

            // =================== [수정된 부분 시작] ===================
            // AppConfig를 통해 설정 파일(config.properties)에 정의된 경로를 가져옵니다.
            String uploadPath = AppConfig.getUploadPath();
            if (uploadPath == null || uploadPath.isEmpty()) {
                // 설정 파일에 경로가 없는 경우, 서버 에러를 발생시켜 문제를 인지하게 합니다.
                throw new ServletException("Upload path is not configured in config.properties.");
            }

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs(); // 폴더가 존재하지 않으면 생성합니다.
            }
            // =================== [수정된 부분 끝] =====================

            for (Part part : parts) {
                if (part.getName().equals("images") && part.getSize() > 0) {
                    String submittedFileName = part.getSubmittedFileName();
                    if (submittedFileName != null && !submittedFileName.isEmpty()) {
                        String fileExtension = submittedFileName.substring(submittedFileName.lastIndexOf("."));
                        String fileName = UUID.randomUUID().toString() + fileExtension;
                        
                        // 수정된 경로에 파일을 저장합니다.
                        part.write(uploadPath + File.separator + fileName);
                        imageFileNames.add(fileName);
                    }
                }
            }

            Review review = new Review();
            review.setUserId(user.getId());
            review.setRestaurantId(restaurantId);
            review.setRating(rating);
            review.setContent(content);
            review.setKeywords(keywords);
            review.setImages(imageFileNames);

            reviewService.addReview(review);

            response.sendRedirect(request.getContextPath() + "/restaurant/detail/" + restaurantId);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "리뷰 등록 중 오류가 발생했습니다. 입력한 내용을 확인해주세요.");

            // 사용자가 입력한 데이터를 보존하기 위해 forward 방식으로 전환합니다.
            // forward하기 전에, write-review.jsp 페이지가 렌더링되기 위해 필요한 데이터를 다시 조회하여 request에 담아줍니다.
            try {
                String restaurantIdStr = request.getParameter("restaurantId");
                if (restaurantIdStr != null && !restaurantIdStr.isEmpty()) {
                    int restaurantId = Integer.parseInt(restaurantIdStr);
                    Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
                    request.setAttribute("restaurant", restaurant);
                    if (restaurant != null) {
                        request.setAttribute("keywordCategories", getKeywordsForCategory(restaurant.getCategory()));
                    }
                }
            } catch (NumberFormatException nfe) {
                // restaurantId가 올바르지 않은 경우, 여기서 추가적인 오류 처리를 할 수 있습니다.
                // 예를 들어, 사용자를 에러 페이지로 보내거나, 홈페이지로 리다이렉트 할 수 있습니다.
                // 현재는 기존 로직과 유사하게 홈페이지로 보냅니다.
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }
            
            // 입력 데이터를 유지한 채, 리뷰 작성 페이지로 다시 포워딩합니다.
            request.getRequestDispatcher("/WEB-INF/views/write-review.jsp").forward(request, response);
        }
    }

    private void handleEditReview(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));

            // 기존 리뷰 조회해서 권한 확인
            Review existingReview = reviewService.findById(reviewId);
            if (existingReview == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "리뷰를 찾을 수 없습니다.");
                return;
            }

            if (existingReview.getUserId() != user.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "본인의 리뷰만 수정할 수 있습니다.");
                return;
            }

            int rating = Integer.parseInt(request.getParameter("rating"));
            String content = request.getParameter("content");
            String keywords = request.getParameter("keywords");

            List<String> imageFileNames = new ArrayList<>();
            Collection<Part> parts = request.getParts();

            String uploadPath = AppConfig.getUploadPath();
            if (uploadPath == null || uploadPath.isEmpty()) {
                throw new ServletException("Upload path is not configured in config.properties.");
            }

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            for (Part part : parts) {
                if (part.getName().equals("images") && part.getSize() > 0) {
                    String submittedFileName = part.getSubmittedFileName();
                    if (submittedFileName != null && !submittedFileName.isEmpty()) {
                        String fileExtension = submittedFileName.substring(submittedFileName.lastIndexOf("."));
                        String fileName = UUID.randomUUID().toString() + fileExtension;

                        part.write(uploadPath + File.separator + fileName);
                        imageFileNames.add(fileName);
                    }
                }
            }

            Review review = new Review();
            review.setId(reviewId);
            review.setUserId(user.getId());
            review.setRestaurantId(existingReview.getRestaurantId());
            review.setRating(rating);
            review.setContent(content);
            review.setKeywords(keywords);

            // 새 이미지가 업로드된 경우에만 이미지 업데이트
            if (!imageFileNames.isEmpty()) {
                review.setImages(imageFileNames);
            }

            boolean success = reviewService.updateReview(review);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/restaurant/detail/" + existingReview.getRestaurantId());
            } else {
                request.setAttribute("errorMessage", "리뷰 수정에 실패했습니다.");
                showEditReviewForm(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "리뷰 수정 중 오류가 발생했습니다.");
            String reviewId = request.getParameter("reviewId");
            if(reviewId != null && !reviewId.isEmpty()){
                response.sendRedirect(request.getContextPath() + "/review/edit?reviewId=" + reviewId);
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
        }
    }

    private void showWriteReviewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
            Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);

            if (restaurant == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "음식점 정보를 찾을 수 없습니다.");
                return;
            }

            Map<String, List<String>> keywordCategories = getKeywordsForCategory(restaurant.getCategory());

            request.setAttribute("restaurant", restaurant);
            request.setAttribute("keywordCategories", keywordCategories);
            request.getRequestDispatcher("/WEB-INF/views/write-review.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 음식점 ID입니다.");
        }
    }

    private void showEditReviewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/user/login");
            return;
        }

        try {
            User user = (User) session.getAttribute("user");
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));

            Review review = reviewService.findById(reviewId);
            if (review == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "리뷰를 찾을 수 없습니다.");
                return;
            }

            if (review.getUserId() != user.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "본인의 리뷰만 수정할 수 있습니다.");
                return;
            }

            Restaurant restaurant = restaurantService.getRestaurantById(review.getRestaurantId());
            if (restaurant == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "음식점 정보를 찾을 수 없습니다.");
                return;
            }

            Map<String, List<String>> keywordCategories = getKeywordsForCategory(restaurant.getCategory());

            request.setAttribute("review", review);
            request.setAttribute("restaurant", restaurant);
            request.setAttribute("keywordCategories", keywordCategories);
            request.getRequestDispatcher("/WEB-INF/views/edit-review.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 리뷰 ID입니다.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private Map<String, List<String>> getKeywordsForCategory(String category) {
        Map<String, List<String>> categories = new LinkedHashMap<>();
        List<String> commonPurpose = new ArrayList<>(Arrays.asList("데이트", "친구", "가족", "회식", "혼밥"));
        List<String> commonAtmosphere = new ArrayList<>(Arrays.asList("인테리어가 예뻐요", "좌석이 편해요", "조용해요", "활기찬 분위기", "뷰가 좋아요", "주차가 편해요", "접근성이 좋아요"));

        switch (category) {
            case "한식":
                categories.put("🍚 맛", Arrays.asList("음식이 맛있어요", "양이 푸짐해요", "재료가 신선해요", "밑반찬이 잘 나와요", "가성비가 좋아요", "혼밥하기 좋아요"));
                break;
            case "중식":
                categories.put("🍜 맛", Arrays.asList("음식이 맛있어요", "소스가 특별해요", "요리가 깔끔해요", "재료가 신선해요", "가성비가 좋아요", "양이 푸짐해요"));
                break;
            case "일식":
                categories.put("🍣 맛", Arrays.asList("음식이 맛있어요", "재료가 신선해요", "플레이팅이 예뻐요", "오마카세가 훌륭해요", "코스 구성이 알차요", "사케 종류가 다양해요"));
                break;
            case "양식":
                categories.put("🍝 맛", Arrays.asList("음식이 맛있어요", "재료가 신선해요", "분위기와 잘 어울려요", "소스가 특별해요", "와인과 잘 어울려요", "가성비가 좋아요"));
                break;
            case "아시안":
                categories.put("🍛 맛", Arrays.asList("음식이 맛있어요", "향신료가 매력적이에요", "현지 맛을 잘 살렸어요", "재료가 신선해요", "특별한 메뉴가 있어요"));
                break;

            case "주점":
                categories.put("🍺 맛 & 메뉴", Arrays.asList("안주가 맛있어요", "술 종류가 다양해요", "기본 안주가 좋아요", "분위기가 신나요", "가성비가 좋아요"));
                commonPurpose.add("혼술하기 좋아요");
                break;
            case "카페":
                categories.put("☕️ 맛 & 메뉴", Arrays.asList("커피가 맛있어요", "디저트가 맛있어요", "음료가 다양해요", "시그니처 메뉴가 있어요", "브런치가 맛있어요"));
                commonPurpose = new ArrayList<>(Arrays.asList("데이트", "친구", "공부/작업", "미팅"));
                break;
            default:
                categories.put("😋 맛", Arrays.asList("음식이 맛있어요", "가성비가 좋아요", "특별한 메뉴가 있어요", "양이 푸짐해요"));
                break;
        }

        categories.put("👍 목적", commonPurpose);
        categories.put("✨ 분위기 & 기타", commonAtmosphere);

        return categories;
    }

    private void handleDeleteReview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "로그인이 필요합니다.");
            return;
        }

        User user = (User) session.getAttribute("user");
        String reviewIdStr = request.getParameter("id");

        if (reviewIdStr == null || reviewIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "리뷰 ID가 필요합니다.");
            return;
        }

        try {
            int reviewId = Integer.parseInt(reviewIdStr);

            // 리뷰 소유권 확인
            Review review = reviewService.findById(reviewId);
            if (review == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "리뷰를 찾을 수 없습니다.");
                return;
            }

            if (review.getUserId() != user.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "자신의 리뷰만 삭제할 수 있습니다.");
                return;
            }

            // 리뷰 삭제
            boolean success = reviewService.deleteReview(reviewId);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"리뷰가 삭제되었습니다.\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"success\": false, \"message\": \"리뷰 삭제에 실패했습니다.\"}");
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 리뷰 ID입니다.");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\": false, \"message\": \"서버 오류가 발생했습니다.\"}");
        }
    }
}