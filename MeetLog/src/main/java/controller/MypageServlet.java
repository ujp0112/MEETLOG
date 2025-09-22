package controller;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import model.Column;
import model.Reservation;
import model.Review;
import model.User;
import service.ColumnService;
import service.ReservationService;
import service.ReviewService;
import service.UserService;
import util.AppConfig;

// web.xml에 매핑되어 있으므로 @WebServlet은 주석 처리 또는 삭제
//@WebServlet("/mypage/*")
public class MypageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserService userService = new UserService();
    private final ReservationService reservationService = new ReservationService();
    private final ReviewService reviewService = new ReviewService();
    private final ColumnService columnService = new ColumnService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirectUrl=" + request.getRequestURI());
            return;
        }
        
        User user = (User) session.getAttribute("user");
        request.setAttribute("user", user);
        
        try {
            String forwardPath = null;
            if (pathInfo == null || pathInfo.equals("/")) {
                handleMyPageMain(request, user.getId()); 
                forwardPath = "/WEB-INF/views/mypage.jsp";
            } else {
                switch (pathInfo) {
                    case "/reservations":
                        handleMyReservations(request, user.getId()); 
                        forwardPath = "/WEB-INF/views/my-reservations.jsp";
                        break;
                    case "/reviews":
                        handleMyReviews(request, user.getId()); 
                        forwardPath = "/WEB-INF/views/my-reviews.jsp";
                        break;
                    case "/columns":
                        handleMyColumns(request, user.getId()); 
                        forwardPath = "/WEB-INF/views/my-columns.jsp";
                        break;
                    case "/settings":
                        forwardPath = "/WEB-INF/views/settings.jsp";
                        break;
                    default:
                        response.sendError(HttpServletResponse.SC_NOT_FOUND);
                        return;
                }
            }
            request.getRequestDispatcher(forwardPath).forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "페이지 처리 중 오류가 발생했습니다: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");

        String pathInfo = request.getPathInfo();
        if (!"/settings".equals(pathInfo)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        try {
            DiskFileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setHeaderEncoding("UTF-8");

            Map<String, String> formFields = new HashMap<>();
            FileItem imageFileItem = null;

            List<FileItem> formItems = upload.parseRequest(request);

            for (FileItem item : formItems) {
                if (item.isFormField()) {
                    formFields.put(item.getFieldName(), item.getString("UTF-8"));
                } else {
                    if ("profileImage".equals(item.getFieldName()) && item.getSize() > 0) {
                        imageFileItem = item;
                    }
                }
            }

            String action = formFields.get("action");

            if ("updateProfile".equals(action)) {
                handleUpdateProfile(session, currentUser, formFields, imageFileItem);
            } else if ("changePassword".equals(action)) {
                handleChangePassword(session, currentUser, formFields);
            }

            response.sendRedirect(request.getContextPath() + "/mypage/settings");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "요청 처리 중 오류가 발생했습니다: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/mypage/settings");
        }
    }

    private void handleUpdateProfile(HttpSession session, User user, Map<String, String> formFields, FileItem imageFileItem) throws Exception {
        String newNickname = formFields.get("nickname");
        String imageFileName = formFields.get("existingProfileImage"); // 기본값은 기존 이미지 파일명

        if (imageFileItem != null) {
            String uploadPath = AppConfig.getUploadPath();
            if (uploadPath == null || uploadPath.isEmpty()) {
                throw new Exception("업로드 경로가 설정되지 않았습니다.");
            }
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            String originalFileName = new File(imageFileItem.getName()).getName();
            imageFileName = UUID.randomUUID().toString() + "_" + originalFileName;
            
            File storeFile = new File(uploadPath, imageFileName);
            imageFileItem.write(storeFile);
        }

        user.setNickname(newNickname);
        user.setProfileImage(imageFileName);

        boolean success = userService.updateProfile(user.getId(), newNickname, imageFileName);

        if (success) {
            session.setAttribute("user", user); // 세션 정보 최신화
            session.setAttribute("successMessage", "프로필이 성공적으로 수정되었습니다.");
        } else {
            session.setAttribute("errorMessage", "프로필 수정 중 오류가 발생했습니다.");
        }
    }

    private void handleChangePassword(HttpSession session, User user, Map<String, String> formFields) {
        String currentPassword = formFields.get("currentPassword");
        String newPassword = formFields.get("newPassword");
        String confirmPassword = formFields.get("confirmPassword");

        if (newPassword == null || !newPassword.equals(confirmPassword)) {
            session.setAttribute("errorMessage", "새 비밀번호가 일치하지 않습니다.");
            return;
        }
        
        boolean success = userService.changePassword(user.getId(), currentPassword, newPassword);
        
        if (success) {
            session.setAttribute("successMessage", "비밀번호가 성공적으로 변경되었습니다.");
        } else {
            session.setAttribute("errorMessage", "현재 비밀번호가 올바르지 않거나 오류가 발생했습니다.");
        }
    }
    
    // --- 기존의 doGet 헬퍼 메소드들은 그대로 유지 ---
    private void handleMyPageMain(HttpServletRequest request, int userId) {
        // request.setAttribute("recentReservations", reservationService.getRecentReservations(userId, 3));
        // request.setAttribute("recentReviews", reviewService.getRecentReviews(userId, 3));
        // request.setAttribute("recentColumns", columnService.getRecentColumns(userId, 3));
        
        // 전체 목록을 가져오는 것으로 변경 (mypage.jsp 구조에 맞춤)
        request.setAttribute("myReviews", reviewService.getReviewsByUserId(userId));
        request.setAttribute("myColumns", columnService.getColumnsByUserId(userId));
        request.setAttribute("myReservations", reservationService.getReservationsByUserId(userId));
    }
    
    private void handleMyReservations(HttpServletRequest request, int userId) {
        request.setAttribute("reservations", reservationService.getReservationsByUserId(userId));
    }
    
    private void handleMyReviews(HttpServletRequest request, int userId) {
        request.setAttribute("reviews", reviewService.getReviewsByUserId(userId));
    }
    
    private void handleMyColumns(HttpServletRequest request, int userId) {
        request.setAttribute("columns", columnService.getColumnsByUserId(userId));
    }
}