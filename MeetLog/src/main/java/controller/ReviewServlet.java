package controller;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import model.Review;
import model.Restaurant;
import model.User;
import service.ReviewService;
import service.RestaurantService;

@WebServlet("/review/*")
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
                handleReviewWriteForm(request, response);
            } else {
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
            handleReviewWriteSubmitWithUpload(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void handleReviewWriteForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
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
        List<Review> reviews = reviewService.getRecentReviews(50);
        request.setAttribute("reviews", reviews);
        request.getRequestDispatcher("/WEB-INF/views/review-list.jsp").forward(request, response);
    }
    
    private void handleReviewWriteSubmitWithUpload(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int restaurantId = 0;
        Review review = new Review();
        List<String> imageList = new ArrayList<>();
        
        ServletContext context = getServletContext();
        String uploadPath = context.getRealPath("/uploads/reviews");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        DiskFileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);

        try {
            List<FileItem> items = upload.parseRequest(request);
            for (FileItem item : items) {
                if (item.isFormField()) {
                    String fieldName = item.getFieldName();
                    String fieldValue = item.getString(StandardCharsets.UTF_8.name());
                    
                    switch (fieldName) {
                        case "restaurantId":
                            restaurantId = Integer.parseInt(fieldValue);
                            review.setRestaurantId(restaurantId);
                            break;
                        case "rating":
                            review.setRating(Integer.parseInt(fieldValue));
                            break;
                        case "content":
                            review.setContent(fieldValue);
                            break;
                        case "tasteRating": review.setTasteRating(Integer.parseInt(fieldValue)); break;
                        case "serviceRating": review.setServiceRating(Integer.parseInt(fieldValue)); break;
                        case "atmosphereRating": review.setAtmosphereRating(Integer.parseInt(fieldValue)); break;
                        case "priceRating": review.setPriceRating(Integer.parseInt(fieldValue)); break;
                        case "visitDate": review.setVisitDate(fieldValue); break;
                        case "partySize": review.setPartySize(Integer.parseInt(fieldValue)); break;
                        case "visitPurpose": review.setVisitPurpose(fieldValue); break;
                    }
                } else {
                    String originalFileName = item.getName();
                    if (originalFileName != null && !originalFileName.isEmpty()) {
                        String extension = originalFileName.substring(originalFileName.lastIndexOf("."));
                        String savedFileName = UUID.randomUUID().toString() + extension;
                        File savedFile = new File(uploadDir, savedFileName);
                        item.write(savedFile);
                        imageList.add(savedFileName);
                    }
                }
            }
            
            review.setUserId(user.getId());
            review.setImages(imageList);

            double avg = (review.getTasteRating() + review.getServiceRating() + review.getAtmosphereRating() + review.getPriceRating()) / 4.0;
            int finalRating = (int) Math.round(avg);
            review.setRating(finalRating);

            if (reviewService.addReview(review)) {
                response.sendRedirect(request.getContextPath() + "/restaurant/detail/" + restaurantId);
            } else {
                throw new Exception("DB insert 실패");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "리뷰 등록 중 오류가 발생했습니다: " + e.getMessage());
            Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
            request.setAttribute("restaurant", restaurant);
            request.getRequestDispatcher("/WEB-INF/views/write-review.jsp").forward(request, response);
        }
    }
}