package controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
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

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonNull;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializer;

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
    private static final DateTimeFormatter EXPORT_TIMESTAMP_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss");

    private final UserService userService = new UserService();
    private final ReservationService reservationService = new ReservationService();
    private final ReviewService reviewService = new ReviewService();
    private final ColumnService columnService = new ColumnService();
    private final UserCouponService userCouponService = new UserCouponService();
    private final CourseService courseService = new CourseService();
    private final Gson gson = new GsonBuilder()
            .registerTypeAdapter(LocalDateTime.class, (JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) ->
                    src == null ? JsonNull.INSTANCE : new JsonPrimitive(src.format(EXPORT_TIMESTAMP_FORMAT)))
            .registerTypeAdapter(LocalDate.class, (JsonSerializer<LocalDate>) (src, typeOfSrc, context) ->
                    src == null ? JsonNull.INSTANCE : new JsonPrimitive(src.toString()))
            .registerTypeAdapter(Timestamp.class, (JsonSerializer<Timestamp>) (src, typeOfSrc, context) ->
                    src == null ? JsonNull.INSTANCE : new JsonPrimitive(src.toLocalDateTime().format(EXPORT_TIMESTAMP_FORMAT)))
            .setPrettyPrinting()
            .create();
    
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
                    case "/settings/export":
                        handleExportUserData(response, user);
                        return;
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
            if (ServletFileUpload.isMultipartContent(request)) {
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
                return;
            }

            String action = request.getParameter("action");
            if ("exportData".equals(action)) {
                handleExportUserData(response, currentUser);
                return;
            } else if ("deleteAccount".equals(action)) {
                handleDeleteAccount(request, response, session, currentUser);
                return;
            } else if ("changePassword".equals(action)) {
                // 일반 폼으로 전송된 비밀번호 변경 처리
                Map<String, String> formFields = new HashMap<>();
                formFields.put("currentPassword", request.getParameter("currentPassword"));
                formFields.put("newPassword", request.getParameter("newPassword"));
                formFields.put("confirmPassword", request.getParameter("confirmPassword"));
                handleChangePassword(session, currentUser, formFields);
                response.sendRedirect(request.getContextPath() + "/mypage/settings");
                return;
            }

            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "지원하지 않는 요청입니다.");

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

    private void handleExportUserData(HttpServletResponse response, User user) throws IOException {
        User latestUser = userService.getUserById(user.getId());
        if (latestUser == null) {
            latestUser = user;
        }

        Map<String, Object> exportPayload = new LinkedHashMap<>();
        exportPayload.put("generatedAt", LocalDateTime.now().format(EXPORT_TIMESTAMP_FORMAT));
        exportPayload.put("user", buildUserProfile(latestUser));
        exportPayload.put("reservations", reservationService.getReservationsByUserId(latestUser.getId()));
        exportPayload.put("reviews", reviewService.getReviewsByUserId(latestUser.getId()));
        exportPayload.put("columns", columnService.getColumnsByUserId(latestUser.getId()));
        exportPayload.put("courses", courseService.getCoursesByUserId(latestUser.getId()));
        exportPayload.put("coupons", userCouponService.getUserCoupons(latestUser.getId()));

        Map<String, Object> counts = new LinkedHashMap<>();
        counts.put("reservations", ((List<?>) exportPayload.get("reservations")).size());
        counts.put("reviews", ((List<?>) exportPayload.get("reviews")).size());
        counts.put("columns", ((List<?>) exportPayload.get("columns")).size());
        counts.put("courses", ((List<?>) exportPayload.get("courses")).size());
        counts.put("coupons", ((List<?>) exportPayload.get("coupons")).size());
        exportPayload.put("counts", counts);

        String fileName = String.format("meetlog-export-%s.json",
                LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));

        response.setContentType("application/json; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        try (PrintWriter writer = response.getWriter()) {
            writer.write(gson.toJson(exportPayload));
        }
    }

    private Map<String, Object> buildUserProfile(User user) {
        Map<String, Object> profile = new LinkedHashMap<>();
        profile.put("id", user.getId());
        profile.put("nickname", user.getNickname());
        profile.put("email", user.getEmail());
        profile.put("phone", user.getPhone());
        profile.put("userType", user.getUserType());
        profile.put("level", user.getLevel());
        profile.put("name", user.getName());
        profile.put("address", user.getAddress());
        profile.put("createdAt", user.getCreatedAt() != null ? user.getCreatedAt().format(EXPORT_TIMESTAMP_FORMAT) : null);
        profile.put("updatedAt", user.getUpdatedAt() != null ? user.getUpdatedAt().format(EXPORT_TIMESTAMP_FORMAT) : null);
        profile.put("socialProvider", user.getSocialProvider());
        profile.put("socialId", user.getSocialId());
        profile.put("profileImage", user.getProfileImage());
        profile.put("followerCount", user.getFollowerCount());
        profile.put("followingCount", user.getFollowingCount());
        profile.put("active", user.isActive());
        return profile;
    }

    private void handleDeleteAccount(HttpServletRequest request, HttpServletResponse response, HttpSession session,
            User currentUser) throws IOException {

        response.setContentType("application/json; charset=UTF-8");

        PrintWriter writer = response.getWriter();
        try {
            boolean success = userService.deleteUser(currentUser.getId());
            if (success) {
                String redirectUrl = request.getContextPath() + "/";
                session.invalidate();
                writer.write(gson.toJson(Map.of(
                        "success", Boolean.TRUE,
                        "redirect", redirectUrl)));
            } else {
                writer.write(gson.toJson(Map.of(
                        "success", Boolean.FALSE,
                        "message", "계정 삭제에 실패했습니다.")));
            }
        } catch (Exception e) {
            e.printStackTrace();
            writer.write(gson.toJson(Map.of(
                    "success", Boolean.FALSE,
                    "message", "계정 삭제 중 오류가 발생했습니다.")));
        } finally {
            writer.flush();
        }
    }
}
