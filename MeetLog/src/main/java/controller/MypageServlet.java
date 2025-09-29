package controller;

import java.io.File;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.Date;
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
import model.UserCoupon;
import model.CommunityCourse;
import service.ColumnService;
import service.ReservationService;
import service.ReviewService;
import service.UserService;
import service.UserCouponService;
import service.CourseService;
import util.AppConfig;

// web.xml에 매핑되어 있으므로 @WebServlet은 주석 처리 또는 삭제
//@WebServlet("/mypage/*")
public class MypageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserService userService = new UserService();
    private final ReservationService reservationService = new ReservationService();
    private final ReviewService reviewService = new ReviewService();
    private final ColumnService columnService = new ColumnService();
    private final UserCouponService userCouponService = new UserCouponService();
    private final CourseService courseService = new CourseService();
    
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
                    case "/coupons":
                        handleMyCoupons(request, user.getId());
                        forwardPath = "/WEB-INF/views/my-coupons.jsp";
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
        if ("/settings".equals(pathInfo)) {
            handleSettingsPost(request, response, currentUser);
        } else if ("/coupons/use".equals(pathInfo)) {
            handleCouponUse(request, response, currentUser);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

    }

    private void handleSettingsPost(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

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

    private void handleCouponUse(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String couponIdStr = request.getParameter("couponId");
            if (couponIdStr == null || couponIdStr.trim().isEmpty()) {
                response.getWriter().write("{\"success\": false, \"message\": \"쿠폰 ID가 필요합니다.\"}");
                return;
            }

            int couponId = Integer.parseInt(couponIdStr);

            // 쿠폰 사용 가능 여부 확인
            if (!userCouponService.canUseCoupon(couponId, currentUser.getId())) {
                response.getWriter().write("{\"success\": false, \"message\": \"사용할 수 없는 쿠폰입니다.\"}");
                return;
            }

            // 쿠폰 사용 처리
            userCouponService.useCoupon(couponId);
            response.getWriter().write("{\"success\": true, \"message\": \"쿠폰이 사용되었습니다.\"}");

        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"잘못된 쿠폰 ID입니다.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"쿠폰 사용 중 오류가 발생했습니다.\"}");
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

        // 쿠폰 데이터 추가
        int totalCouponCount = userCouponService.getUserCouponCount(userId);
        int availableCouponCount = userCouponService.getAvailableCouponCount(userId);
        int usedCouponCount = totalCouponCount - availableCouponCount;

        request.setAttribute("totalCouponCount", totalCouponCount);
        request.setAttribute("availableCouponCount", availableCouponCount);
        request.setAttribute("usedCouponCount", usedCouponCount);

        // 코스 데이터 추가
        List<CommunityCourse> myCourses = courseService.getCoursesByUserId(userId);
        request.setAttribute("myCourses", myCourses);
        request.setAttribute("myCoursesCount", myCourses.size());
    }
    
    private void handleMyReservations(HttpServletRequest request, int userId) {
    	List<Reservation> reservations = reservationService.getReservationsByUserId(userId);

    	// [추가] Reservation 객체의 LocalDateTime을 Date로 변환하여 JSP에서 사용 가능하게 함
    	for (Reservation r : reservations) {
    	    if (r.getCreatedAt() != null) {
    	        // JSP에서 사용할 수 있도록 Date 객체로 변환
    	        Date createdAtAsDate = Timestamp.valueOf(r.getCreatedAt());
    	        r.setCreatedAtAsDate(createdAtAsDate); // Reservation 모델에 새로운 Date 타입 필드와 setter 추가 필요
    	    }
    	    // updatedAt, reservationTime 등 다른 LocalDateTime 필드도 동일하게 처리
    	}

    	request.setAttribute("reservations", reservations);
    }
    
    private void handleMyReviews(HttpServletRequest request, int userId) {
        request.setAttribute("reviews", reviewService.getReviewsByUserId(userId));
    }
    
    private void handleMyColumns(HttpServletRequest request, int userId) {
        List<Column> myColumns = columnService.getColumnsByUserId(userId);
        request.setAttribute("columns", myColumns);
        request.setAttribute("myColumns", myColumns);
    }

    private void handleMyCoupons(HttpServletRequest request, int userId) {
        // 전체 쿠폰 목록
        List<UserCoupon> allCoupons = userCouponService.getUserCoupons(userId);
        List<UserCoupon> availableCoupons = userCouponService.getAvailableUserCoupons(userId);
        List<UserCoupon> usedCoupons = userCouponService.getUsedUserCoupons(userId);

        // 쿠폰 개수 계산
        int totalCouponCount = userCouponService.getUserCouponCount(userId);
        int availableCouponCount = userCouponService.getAvailableCouponCount(userId);
        int usedCouponCount = totalCouponCount - availableCouponCount;

        request.setAttribute("allCoupons", allCoupons);
        request.setAttribute("availableCoupons", availableCoupons);
        request.setAttribute("usedCoupons", usedCoupons);
        request.setAttribute("totalCouponCount", totalCouponCount);
        request.setAttribute("availableCouponCount", availableCouponCount);
        request.setAttribute("usedCouponCount", usedCouponCount);
    }
}