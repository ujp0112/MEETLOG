package controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
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

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import com.google.gson.Gson;
import com.fasterxml.jackson.databind.ObjectMapper;

import model.CommunityCourse;
import model.OfficialCourse;
import model.Paging;
import model.User;
import model.CourseStep;
import model.Restaurant;
import model.UserStorage;
import service.CourseCommentService;
import service.CourseService;
import service.FeedService;
import service.RestaurantService;
import service.UserStorageService;
import util.AppConfig;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 15
)
@WebServlet(urlPatterns = {"/course", "/course/*", "/api/courses/*"})
public class CourseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private CourseService courseService = new CourseService();
    private RestaurantService restaurantService = new RestaurantService();
    private UserStorageService userStorageService = new UserStorageService();
    private CourseCommentService courseCommentService = new CourseCommentService();
    private ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = normalizePath(request.getPathInfo());
        System.out.println("[CourseServlet][GET] path=" + path);
        try {

            if (path == null || path.equals("/") || "/list".equals(path)) {
                showCourseList(request, response);
            } else if ("/detail".equals(path)) {
                showCourseDetail(request, response);
            } else if ("/create".equals(path)) {
                showCreateCourseForm(request, response);
            } else if ("/edit".equals(path)) {
                showEditCourseForm(request, response);
            } else if ("/delete".equals(path)) {
                handleDeleteCourse(request, response);
            } else if ("/search-places".equals(path)) {
                handleSearchPlaces(request, response);
            } else if ("/like".equals(path)) {
                handleCourseLike(request, response);
            } else if ("/wishlist".equals(path)) {
                handleCourseWishlist(request, response);
            } else if ("/storages".equals(path)) {
                handleGetUserStorages(request, response);
            } else if ("/steps".equals(path)) {
                handleGetCourseSteps(request, response);
                return;
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "페이지 처리 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String path = normalizePath(request.getPathInfo());
        System.out.println("[CourseServlet][POST] path=" + path);
        if ("/create".equals(path)) {
            handleCreateCourseSubmit(request, response);
        } else if ("/edit".equals(path)) {
            handleUpdateCourse(request, response);
        } else if ("/wishlist".equals(path)) {
            handleCourseWishlist(request, response);
        } else if ("/storages".equals(path)) {
            handleCreateUserStorage(request, response);
        } else if ("/like".equals(path)) {
            handleCourseLike(request, response);
        } else if ("/comment".equals(path)) {
            handleAddCourseComment(request, response);
        } else if ("/comment/delete".equals(path)) {
            handleDeleteCourseComment(request, response);
        } else if ("/comment/update".equals(path)) {
            handleUpdateCourseComment(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    private void writeJson(HttpServletResponse response, int status, Map<String, Object> body) throws IOException {
        response.setStatus(status);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(objectMapper.writeValueAsString(body));
    }

    private String normalizePath(String path) {
        if (path == null) {
            return null;
        }
        if (path.length() == 0) {
            return "/";
        }

        String normalized = path;

        // strip out any matrix parameters (e.g., ;jsessionid=...)
        int semicolonIndex = normalized.indexOf(';');
        if (semicolonIndex != -1) {
            normalized = normalized.substring(0, semicolonIndex);
        }

        // remove trailing slashes (except when path is just "/")
        while (normalized.endsWith("/") && normalized.length() > 1) {
            normalized = normalized.substring(0, normalized.length() - 1);
        }
        return normalized;
    }

    private void handleSearchPlaces(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String keyword = request.getParameter("keyword");
        Map<String, Object> params = new HashMap<>();
        params.put("keyword", keyword);
        List<Restaurant> results = restaurantService.searchRestaurants(params);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(objectMapper.writeValueAsString(results));
    }

    private void handleCreateCourseSubmit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
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
                    if ("thumbnail".equals(item.getFieldName()) && item.getSize() > 0) {
                        imageFileItem = item;
                    }
                }
            }

            String savedFilePath = null;
            if (imageFileItem != null) {
                String uploadPath = AppConfig.getUploadPath();
                 if (uploadPath == null || uploadPath.isEmpty()) {
                    throw new Exception("업로드 경로가 설정되지 않았습니다.");
                }
                File uploadDir = new File(uploadPath, "course_thumbnails");
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String originalFileName = new File(imageFileItem.getName()).getName();
                String uniqueFileName = UUID.randomUUID().toString() + "_" + originalFileName;
                File storeFile = new File(uploadDir, uniqueFileName);
                imageFileItem.write(storeFile);
                savedFilePath = "course_thumbnails/" + uniqueFileName;
            }

            List<CourseStep> steps = new ArrayList<>();
            int stepIndex = 1;
            while (true) {
                String stepName = formFields.get("step_name_" + stepIndex);
                if (stepName == null) break;

                CourseStep step = new CourseStep();
                step.setName(stepName);
                step.setType(formFields.get("step_type_" + stepIndex));
                step.setTime(Integer.parseInt(formFields.get("step_time_" + stepIndex)));
                step.setCost(Integer.parseInt(formFields.get("step_cost_" + stepIndex)));

                // 위치 정보 추가
                String latStr = formFields.get("step_latitude_" + stepIndex);
                String lngStr = formFields.get("step_longitude_" + stepIndex);
                String address = formFields.get("step_address_" + stepIndex);

                if (latStr != null && !latStr.isEmpty()) {
                    step.setLatitude(Double.parseDouble(latStr));
                }
                if (lngStr != null && !lngStr.isEmpty()) {
                    step.setLongitude(Double.parseDouble(lngStr));
                }
                if (address != null) {
                    step.setAddress(address);
                }

                steps.add(step);
                stepIndex++;
            }
            
            CommunityCourse course = new CommunityCourse();
            course.setUserId(user.getId());
            course.setTitle(formFields.get("title"));
            course.setDescription(formFields.get("description"));
            String tagsString = formFields.get("tags");
            if (tagsString != null && !tagsString.isEmpty()) {
                course.setTags(java.util.Arrays.asList(tagsString.split("\\s*,\\s*")));
            }
            course.setPreviewImage(savedFilePath);
            
            boolean success = courseService.createCourseWithSteps(course, steps);
            
            if (success) {
                // 피드 아이템 생성
                try {
                    FeedService feedService = new FeedService();
                    feedService.createSimpleCourseFeedItem(user.getId(), course.getId());
                    System.out.println("DEBUG: 코스 피드 아이템 생성 완료 - 코스 ID: " + course.getId());
                } catch (Exception e) {
                    System.err.println("피드 아이템 생성 실패: " + e.getMessage());
                    e.printStackTrace();
                    // 피드 아이템 생성 실패는 코스 작성을 막지 않음
                }
                
                response.sendRedirect(request.getContextPath() + "/course/detail?id=" + course.getId());
            } else {
                throw new Exception("코스 등록 실패");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "코스 등록 중 오류 발생: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/create-course.jsp").forward(request, response);
        }
    }

    private void showCreateCourseForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirectURL=/course/create");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/views/create-course.jsp").forward(request, response);
    }

    private void showCourseList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = request.getParameter("query");
        String area = request.getParameter("area");
        int page = 1;
        if (request.getParameter("page") != null && !request.getParameter("page").isEmpty()) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) { page = 1; }
        }
        
        List<CommunityCourse> communityCourses = courseService.getCommunityCourses(query, area, page);
        Paging paging = courseService.getCommunityCoursePaging(query, area, page);
        List<OfficialCourse> officialCourses = courseService.getOfficialCourses();
        
        request.setAttribute("communityCourses", communityCourses);
        request.setAttribute("paging", paging);
        request.setAttribute("officialCourses", officialCourses);
        request.setAttribute("query", query);
        request.setAttribute("area", area);
        
        request.getRequestDispatcher("/WEB-INF/views/course-recommendation.jsp").forward(request, response);
    }
    
    private void showCourseDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int courseId = 0;
        try {
            courseId = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "유효하지 않은 코스 ID입니다.");
            return;
        }
        
        CommunityCourse course = courseService.getCourseDetail(courseId);
        if (course == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "코스를 찾을 수 없습니다.");
            return;
        }

        List<CourseStep> steps = courseService.getCourseSteps(courseId);
        if (steps == null) {
            steps = java.util.Collections.emptyList();
        }

        // 최신 좋아요 수 반영 (상세 조회 쿼리에 포함됐더라도 서버에서 한 번 더 보정)
        try {
            course.setLikes(courseService.getCourseLikeCount(courseId));
        } catch (Exception e) {
            System.err.println("코스 좋아요 수 조회 실패: " + e.getMessage());
        }
        
        // 현재 사용자의 좋아요 상태 및 찜 상태 확인
        HttpSession session = request.getSession(false);
        boolean isLiked = false;
        boolean isWishlisted = false;
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            isLiked = courseService.isCourseLiked(user.getId(), courseId);

            // 사용자의 기본 저장소에 코스가 있는지 확인
            try {
                var defaultStorage = userStorageService.getOrCreateDefaultStorage(user.getId());
                if (defaultStorage != null) {
                    isWishlisted = userStorageService.isItemInStorage(defaultStorage.getStorageId(), "COURSE", courseId);
                }
            } catch (Exception e) {
                System.err.println("찜 상태 확인 중 오류: " + e.getMessage());
            }
        }

        List<model.CourseComment> comments = courseCommentService.getCommentsByCourse(courseId);

        request.setAttribute("course", course);
        request.setAttribute("steps", steps);
        request.setAttribute("isLiked", isLiked);
        request.setAttribute("isWishlisted", isWishlisted);
        request.setAttribute("courseComments", comments);
        request.setAttribute("courseCommentCount", comments.size());

        request.getRequestDispatcher("/WEB-INF/views/course-detail.jsp").forward(request, response);
    }

    private void showEditCourseForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String courseIdStr = request.getParameter("id");
        if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "코스 ID가 필요합니다.");
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdStr);
            CommunityCourse course = courseService.getCourseById(courseId);

            if (course == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "코스를 찾을 수 없습니다.");
                return;
            }

            User user = (User) session.getAttribute("user");
            if (course.getUserId() != user.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "자신의 코스만 수정할 수 있습니다.");
                return;
            }

            // 코스 경로들 조회
            List<CourseStep> steps = courseService.getCourseSteps(courseId);

            request.setAttribute("course", course);
            request.setAttribute("steps", steps);
            request.setAttribute("isEditMode", true);
            request.getRequestDispatcher("/WEB-INF/views/create-course.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 코스 ID입니다.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void handleUpdateCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
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
                    if ("thumbnail".equals(item.getFieldName()) && item.getSize() > 0) {
                        imageFileItem = item;
                    }
                }
            }

            String courseIdStr = formFields.get("courseId");
            if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "코스 ID가 필요합니다.");
                return;
            }

            int courseId = Integer.parseInt(courseIdStr);
            CommunityCourse existingCourse = courseService.getCourseById(courseId);

            if (existingCourse == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "코스를 찾을 수 없습니다.");
                return;
            }

            User user = (User) session.getAttribute("user");
            if (existingCourse.getUserId() != user.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "자신의 코스만 수정할 수 있습니다.");
                return;
            }

            // 이미지 처리
            String savedFilePath = existingCourse.getPreviewImage(); // 기존 이미지 유지
            if (imageFileItem != null) {
                String uploadPath = AppConfig.getUploadPath();
                if (uploadPath == null || uploadPath.isEmpty()) {
                    throw new Exception("업로드 경로가 설정되지 않았습니다.");
                }

                File uploadDir = new File(uploadPath, "course_thumbnails");
                if (!uploadDir.exists()) uploadDir.mkdirs();

                String originalFileName = new File(imageFileItem.getName()).getName();
                String uniqueFileName = UUID.randomUUID().toString() + "_" + originalFileName;
                File storeFile = new File(uploadDir, uniqueFileName);
                imageFileItem.write(storeFile);
                savedFilePath = "course_thumbnails/" + uniqueFileName;
            }

            // 경로 정보 파싱 (formData 방식)
            List<CourseStep> steps = new ArrayList<>();
            int stepIndex = 1;
            while (true) {
                String stepName = formFields.get("step_name_" + stepIndex);
                if (stepName == null) break;

                CourseStep step = new CourseStep();
                step.setName(stepName);
                step.setType(formFields.get("step_type_" + stepIndex));
                step.setTime(Integer.parseInt(formFields.get("step_time_" + stepIndex)));
                step.setCost(Integer.parseInt(formFields.get("step_cost_" + stepIndex)));

                // 위치 정보 추가
                String latStr = formFields.get("step_latitude_" + stepIndex);
                String lngStr = formFields.get("step_longitude_" + stepIndex);
                String address = formFields.get("step_address_" + stepIndex);

                if (latStr != null && !latStr.isEmpty()) {
                    step.setLatitude(Double.parseDouble(latStr));
                }
                if (lngStr != null && !lngStr.isEmpty()) {
                    step.setLongitude(Double.parseDouble(lngStr));
                }
                if (address != null) {
                    step.setAddress(address);
                }

                steps.add(step);
                stepIndex++;
            }

            // 코스 정보 업데이트
            existingCourse.setTitle(formFields.get("title"));
            existingCourse.setDescription(formFields.get("description"));
            existingCourse.setPreviewImage(savedFilePath);

            // 태그 처리
            String tagsString = formFields.get("tags");
            if (tagsString != null && !tagsString.isEmpty()) {
                existingCourse.setTags(java.util.Arrays.asList(tagsString.split("\\s*,\\s*")));
            } else {
                existingCourse.setTags(new ArrayList<>());
            }

            boolean success = courseService.updateCourseWithSteps(existingCourse, steps);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/course/detail?id=" + courseId);
            } else {
                request.setAttribute("errorMessage", "코스 수정에 실패했습니다.");
                request.setAttribute("course", existingCourse);
                request.setAttribute("isEditMode", true);
                request.getRequestDispatcher("/WEB-INF/views/create-course.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 코스 ID입니다.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "오류가 발생했습니다: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/create-course.jsp").forward(request, response);
        }
    }

    private void handleDeleteCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "로그인이 필요합니다.");
            return;
        }

        User user = (User) session.getAttribute("user");
        String courseIdStr = request.getParameter("id");

        if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "코스 ID가 필요합니다.");
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdStr);

            // 코스 소유권 확인
            CommunityCourse course = courseService.getCourseById(courseId);
            if (course == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "코스를 찾을 수 없습니다.");
                return;
            }

            if (course.getUserId() != user.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "자신의 코스만 삭제할 수 있습니다.");
                return;
            }

            // 코스 삭제
            boolean success = courseService.deleteCourse(courseId, user.getId());

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"코스가 삭제되었습니다.\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"success\": false, \"message\": \"코스 삭제에 실패했습니다.\"}");
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 코스 ID입니다.");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\": false, \"message\": \"서버 오류가 발생했습니다.\"}");
        }
    }

    private void handleCourseLike(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            writeJson(response, HttpServletResponse.SC_UNAUTHORIZED, Map.of(
                    "success", false,
                    "message", "로그인이 필요합니다."
            ));
            return;
        }

        User user = (User) session.getAttribute("user");
        
        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            boolean isLiked = courseService.toggleCourseLike(user.getId(), courseId);
            int likeCount = courseService.getCourseLikeCount(courseId);
            
            writeJson(response, HttpServletResponse.SC_OK, Map.of(
                    "success", true,
                    "isLiked", isLiked,
                    "likeCount", likeCount
            ));
        } catch (NumberFormatException e) {
            writeJson(response, HttpServletResponse.SC_BAD_REQUEST, Map.of(
                    "success", false,
                    "message", "잘못된 코스 ID입니다."
            ));
        } catch (Exception e) {
            e.printStackTrace();
            writeJson(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, Map.of(
                    "success", false,
                    "message", "서버 오류가 발생했습니다."
            ));
        }
    }

    /**
     * 코스 찜하기/찜 해제 처리
     */
    private void handleCourseWishlist(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("DEBUG: handleCourseWishlist 메서드 호출됨");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("DEBUG: 로그인되지 않은 사용자");
            writeJson(response, HttpServletResponse.SC_UNAUTHORIZED, Map.of(
                    "success", false,
                    "message", "로그인이 필요합니다."
            ));
            return;
        }

        User user = (User) session.getAttribute("user");
        System.out.println("DEBUG: 사용자 ID: " + user.getId());

        try {
            String courseIdParam = request.getParameter("courseId");
            String action = request.getParameter("action");
            if (action != null) {
                action = action.trim().toLowerCase();
            }
            String storageIdParam = request.getParameter("storageId");

            System.out.println("DEBUG: courseId 파라미터: " + courseIdParam);
            System.out.println("DEBUG: action 파라미터: " + action);
            System.out.println("DEBUG: storageId 파라미터: " + storageIdParam);

            if (courseIdParam == null || courseIdParam.trim().isEmpty()) {
                System.out.println("DEBUG: courseId 파라미터 누락");
                writeJson(response, HttpServletResponse.SC_BAD_REQUEST, Map.of(
                        "success", false,
                        "message", "코스 ID가 누락되었습니다."
                ));
                return;
            }

            int courseId = Integer.parseInt(courseIdParam.trim());

            boolean success = false;
            boolean isWishlisted = false;

            if ("add".equals(action)) {
                System.out.println("DEBUG: 찜 추가 시도 - 사용자: " + user.getId() + ", 코스: " + courseId);

                if (storageIdParam != null && !storageIdParam.trim().isEmpty()) {
                    // 특정 저장소에 추가
                    int storageId = Integer.parseInt(storageIdParam);
                    System.out.println("DEBUG: 특정 저장소에 추가 - 저장소 ID: " + storageId);
                    success = userStorageService.addToStorage(storageId, "COURSE", courseId);
                } else {
                    // 기본 저장소에 추가
                    System.out.println("DEBUG: 기본 저장소에 추가");
                    success = userStorageService.addToWishlist(user.getId(), "COURSE", courseId);
                }

                isWishlisted = true;
                System.out.println("DEBUG: 찜 추가 결과: " + success);
            } else if ("remove".equals(action)) {
                System.out.println("DEBUG: 찜 제거 시도 - 사용자: " + user.getId() + ", 코스: " + courseId);
                success = userStorageService.removeFromWishlist(user.getId(), "COURSE", courseId);
                isWishlisted = false;
                System.out.println("DEBUG: 찜 제거 결과: " + success);
            } else {
                System.out.println("DEBUG: 유효하지 않은 액션: " + action);
                writeJson(response, HttpServletResponse.SC_BAD_REQUEST, Map.of(
                        "success", false,
                        "message", "유효하지 않은 액션입니다."
                ));
                return;
            }

            if (success) {
                Map<String, Object> body = new HashMap<>();
                body.put("success", true);
                body.put("isWishlisted", isWishlisted);
                body.put("message", isWishlisted ? "찜 목록에 추가되었습니다." : "찜 목록에서 제거되었습니다.");
                writeJson(response, HttpServletResponse.SC_OK, body);
            } else {
                System.out.println("DEBUG: 찜 처리 실패");
                writeJson(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, Map.of(
                        "success", false,
                        "message", "찜 처리에 실패했습니다."
                ));
            }

        } catch (NumberFormatException e) {
            System.out.println("DEBUG: 숫자 형식 오류: " + e.getMessage());
            writeJson(response, HttpServletResponse.SC_BAD_REQUEST, Map.of(
                    "success", false,
                    "message", "잘못된 요청입니다."
            ));
        } catch (Exception e) {
            System.out.println("DEBUG: 예외 발생: " + e.getMessage());
            e.printStackTrace();
            writeJson(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, Map.of(
                    "success", false,
                    "message", "서버 오류가 발생했습니다."
            ));
        }
    }

    /**
     * 사용자의 저장소 목록을 JSON으로 반환
     */
    private void handleGetUserStorages(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            writeJson(response, HttpServletResponse.SC_UNAUTHORIZED, Map.of(
                    "success", false,
                    "message", "로그인이 필요합니다."
            ));
            return;
        }

        try {
            User user = (User) session.getAttribute("user");
            List<model.UserStorage> storages = userStorageService.getUserStorages(user.getId());

            // JSON 형태로 변환할 데이터 준비
            List<Map<String, Object>> storageList = new ArrayList<>();
            for (model.UserStorage storage : storages) {
                Map<String, Object> storageMap = new HashMap<>();
                storageMap.put("id", storage.getStorageId());
                storageMap.put("name", storage.getName());
                storageMap.put("colorClass", storage.getColorClass());
                storageMap.put("itemCount", storage.getItemCount());
                storageList.add(storageMap);
            }

            writeJson(response, HttpServletResponse.SC_OK, Map.of(
                    "success", true,
                    "storages", storageList
            ));

        } catch (Exception e) {
            e.printStackTrace();
            writeJson(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, Map.of(
                    "success", false,
                    "message", "저장소 목록을 가져오는데 실패했습니다."
            ));
        }
    }

    /**
     * 사용자의 저장소를 새로 생성
     */
    private void handleCreateUserStorage(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            writeJson(response, HttpServletResponse.SC_UNAUTHORIZED, Map.of(
                    "success", false,
                    "message", "로그인이 필요합니다."
            ));
            return;
        }

        User user = (User) session.getAttribute("user");
        String name = request.getParameter("name");
        String colorClass = request.getParameter("colorClass");

        if (name == null || name.trim().isEmpty()) {
            writeJson(response, HttpServletResponse.SC_BAD_REQUEST, Map.of(
                    "success", false,
                    "message", "폴더 이름을 입력해주세요."
            ));
            return;
        }

        if (colorClass == null || colorClass.trim().isEmpty()) {
            colorClass = "bg-blue-100";
        }

        try {
            UserStorage storage = new UserStorage(user.getId(), name.trim(), colorClass.trim());
            boolean created = userStorageService.createStorage(storage);

            if (created) {
                Map<String, Object> storageMap = new HashMap<>();
                storageMap.put("id", storage.getStorageId());
                storageMap.put("name", storage.getName());
                storageMap.put("colorClass", storage.getColorClass());
                storageMap.put("itemCount", 0);

                writeJson(response, HttpServletResponse.SC_OK, Map.of(
                        "success", true,
                        "storage", storageMap
                ));
            } else {
                writeJson(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, Map.of(
                        "success", false,
                        "message", "폴더 생성에 실패했습니다."
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
            writeJson(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, Map.of(
                    "success", false,
                    "message", "폴더 생성 중 오류가 발생했습니다."
            ));
        }
    }

    private void handleAddCourseComment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            writeJson(response, HttpServletResponse.SC_UNAUTHORIZED, Map.of(
                    "success", false,
                    "message", "로그인이 필요합니다."
            ));
            return;
        }

        User user = (User) session.getAttribute("user");
        String courseIdParam = request.getParameter("courseId");
        String content = request.getParameter("content");

        if (courseIdParam == null || courseIdParam.trim().isEmpty()) {
            writeJson(response, HttpServletResponse.SC_BAD_REQUEST, Map.of(
                    "success", false,
                    "message", "코스 ID가 필요합니다."
            ));
            return;
        }

        if (content == null || content.trim().isEmpty()) {
            writeJson(response, HttpServletResponse.SC_BAD_REQUEST, Map.of(
                    "success", false,
                    "message", "댓글 내용을 입력해주세요."
            ));
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdParam.trim());
            var savedComment = courseCommentService.addComment(courseId, user.getId(), content.trim());
            if (savedComment != null) {
                Map<String, Object> commentData = new HashMap<>();
                commentData.put("id", savedComment.getId());
                commentData.put("courseId", savedComment.getCourseId());
                commentData.put("userId", savedComment.getUserId());
                commentData.put("nickname", savedComment.getNickname());
                commentData.put("profileImage", savedComment.getProfileImage());
                commentData.put("content", savedComment.getContent());
                commentData.put("createdAt", savedComment.getCreatedAtFormatted());

                Map<String, Object> body = new HashMap<>();
                body.put("success", true);
                body.put("message", "댓글이 등록되었습니다.");
                body.put("comment", commentData);

                writeJson(response, HttpServletResponse.SC_OK, body);
            } else {
                writeJson(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, Map.of(
                        "success", false,
                        "message", "댓글 저장에 실패했습니다."
                ));
            }
        } catch (NumberFormatException e) {
            writeJson(response, HttpServletResponse.SC_BAD_REQUEST, Map.of(
                    "success", false,
                    "message", "잘못된 코스 ID입니다."
            ));
        } catch (Exception e) {
            e.printStackTrace();
            writeJson(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, Map.of(
                    "success", false,
                    "message", "댓글 등록 중 오류가 발생했습니다."
            ));
        }
    }

    private void handleDeleteCourseComment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            writeJson(response, HttpServletResponse.SC_UNAUTHORIZED, Map.of(
                    "success", false,
                    "message", "로그인이 필요합니다."
            ));
            return;
        }

        User user = (User) session.getAttribute("user");
        String commentIdParam = request.getParameter("commentId");

        if (commentIdParam == null || commentIdParam.trim().isEmpty()) {
            writeJson(response, HttpServletResponse.SC_BAD_REQUEST, Map.of(
                    "success", false,
                    "message", "댓글 ID가 필요합니다."
            ));
            return;
        }

        try {
            int commentId = Integer.parseInt(commentIdParam.trim());
            boolean deleted = courseCommentService.deleteComment(commentId, user.getId());
            if (deleted) {
                writeJson(response, HttpServletResponse.SC_OK, Map.of(
                        "success", true,
                        "message", "댓글이 삭제되었습니다."
                ));
            } else {
                writeJson(response, HttpServletResponse.SC_FORBIDDEN, Map.of(
                        "success", false,
                        "message", "댓글을 삭제할 수 없습니다."
                ));
            }
        } catch (NumberFormatException e) {
            writeJson(response, HttpServletResponse.SC_BAD_REQUEST, Map.of(
                    "success", false,
                    "message", "잘못된 댓글 ID입니다."
            ));
        } catch (Exception e) {
            e.printStackTrace();
            writeJson(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, Map.of(
                    "success", false,
                    "message", "댓글 삭제 중 오류가 발생했습니다."
            ));
        }
    }

    private void handleUpdateCourseComment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            writeJson(response, HttpServletResponse.SC_UNAUTHORIZED, Map.of(
                    "success", false,
                    "message", "로그인이 필요합니다."
            ));
            return;
        }

        User user = (User) session.getAttribute("user");
        String commentIdParam = request.getParameter("commentId");
        String content = request.getParameter("content");

        if (commentIdParam == null || commentIdParam.trim().isEmpty()) {
            writeJson(response, HttpServletResponse.SC_BAD_REQUEST, Map.of(
                    "success", false,
                    "message", "댓글 ID가 필요합니다."
            ));
            return;
        }

        if (content == null || content.trim().isEmpty()) {
            writeJson(response, HttpServletResponse.SC_BAD_REQUEST, Map.of(
                    "success", false,
                    "message", "댓글 내용을 입력해주세요."
            ));
            return;
        }

        try {
            int commentId = Integer.parseInt(commentIdParam.trim());
            boolean updated = courseCommentService.updateComment(commentId, user.getId(), content.trim());
            if (updated) {
                writeJson(response, HttpServletResponse.SC_OK, Map.of(
                        "success", true,
                        "message", "댓글이 수정되었습니다."
                ));
            } else {
                writeJson(response, HttpServletResponse.SC_FORBIDDEN, Map.of(
                        "success", false,
                        "message", "댓글을 수정할 수 없습니다."
                ));
            }
        } catch (NumberFormatException e) {
            writeJson(response, HttpServletResponse.SC_BAD_REQUEST, Map.of(
                    "success", false,
                    "message", "잘못된 댓글 ID입니다."
            ));
        } catch (Exception e) {
            e.printStackTrace();
            writeJson(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, Map.of(
                    "success", false,
                    "message", "댓글 수정 중 오류가 발생했습니다."
            ));
        }
    }
    
    /**
     * [추가] 특정 코스의 모든 지점(Step) 목록을 JSON으로 반환합니다.
     */
    private void handleGetCourseSteps(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String courseIdStr = request.getParameter("courseId");
        if (courseIdStr == null || courseIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "courseId is required.");
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdStr);
            List<CourseStep> steps = courseService.getCourseSteps(courseId);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            // ObjectMapper 대신 Gson을 사용하여 간단하게 처리 (또는 ObjectMapper를 사용하도록 통일)
            response.getWriter().write(new Gson().toJson(steps));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid courseId format.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "서버 오류가 발생했습니다.");
        }
    }
}
