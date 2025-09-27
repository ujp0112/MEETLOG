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

import com.fasterxml.jackson.databind.ObjectMapper;

import model.CommunityCourse;
import model.OfficialCourse;
import model.Paging;
import model.User;
import model.CourseStep;
import model.Restaurant;
import service.CourseService;
import service.FeedService;
import service.RestaurantService;
import util.AppConfig;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 15
)
@WebServlet("/course/*")
public class CourseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private CourseService courseService = new CourseService();
    private RestaurantService restaurantService = new RestaurantService();
    private ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String path = request.getPathInfo();

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
        String path = request.getPathInfo();
        if ("/create".equals(path)) {
            handleCreateCourseSubmit(request, response);
        } else if ("/edit".equals(path)) {
            handleUpdateCourse(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
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
                savedFilePath = "uploads/course_thumbnails/" + uniqueFileName;
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
                steps.add(step);
                stepIndex++;
            }
            
            CommunityCourse course = new CommunityCourse();
            course.setUserId(user.getId());
            course.setTitle(formFields.get("title"));
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
        List<CourseStep> steps = courseService.getCourseSteps(courseId);
        
        request.setAttribute("course", course);
        request.setAttribute("steps", steps);

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
            String imageFileName = existingCourse.getThumbnail(); // 기존 이미지 유지
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

            // 코스 정보 업데이트
            existingCourse.setTitle(formFields.get("title"));
            existingCourse.setDescription(formFields.get("description"));
            existingCourse.setThumbnail(imageFileName);

            // 경로 정보 파싱
            String stepsJsonStr = formFields.get("steps");
            List<CourseStep> steps = new ArrayList<>();
            if (stepsJsonStr != null && !stepsJsonStr.trim().isEmpty()) {
                CourseStep[] stepsArray = objectMapper.readValue(stepsJsonStr, CourseStep[].class);
                for (CourseStep step : stepsArray) {
                    steps.add(step);
                }
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
}