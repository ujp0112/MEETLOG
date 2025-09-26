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
import util.AppConfig; // AppConfig 임포트 확인

@WebServlet("/review/*")
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
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || !pathInfo.equals("/write")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/user/login");
            return;
        }

        try {
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
            request.setAttribute("errorMessage", "리뷰 등록 중 오류가 발생했습니다.");
            // 오류 발생 시, 다시 리뷰 작성 페이지로 이동하되, 어떤 음식점인지 정보를 유지합니다.
            String restaurantId = request.getParameter("restaurantId");
            if(restaurantId != null && !restaurantId.isEmpty()){
                response.sendRedirect(request.getContextPath() + "/review/write?restaurantId=" + restaurantId);
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
}