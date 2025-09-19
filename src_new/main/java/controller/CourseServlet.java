package controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.fasterxml.jackson.databind.ObjectMapper;

import model.CommunityCourse;
import model.OfficialCourse;
import model.Paging; 
import model.User;
import model.CourseStep;
import model.Restaurant;
import service.CourseService; 
import service.RestaurantService;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 15
)
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

            if (path == null || path.equals("/")) {
                showCourseList(request, response);
            } else if (path.equals("/detail")) {
                showCourseDetail(request, response);
            } else if (path.equals("/create")) {
                showCreateCourseForm(request, response);
            } else if (path.equals("/search-places")) { 
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
    
    private void handleSearchPlaces(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String keyword = request.getParameter("keyword");
        List<Restaurant> results = restaurantService.searchRestaurants(keyword);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(objectMapper.writeValueAsString(results));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        String path = request.getPathInfo();
        if ("/create".equals(path)) {
            handleCreateCourseSubmit(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void handleCreateCourseSubmit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        try {
            String title = request.getParameter("title");
            String tags = request.getParameter("tags");
            Part filePart = request.getPart("thumbnail");
            String fileName = filePart.getSubmittedFileName();
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();
            String filePath = uploadPath + File.separator + fileName;
            filePart.write(filePath);
            String previewImageUrl = "uploads/" + fileName;
            List<CourseStep> steps = new ArrayList<>();
            int stepIndex = 1;
            while (true) {
                String stepName = request.getParameter("step_name_" + stepIndex);
                if (stepName == null) break;
                CourseStep step = new CourseStep();
                step.setName(stepName);
                step.setType(request.getParameter("step_type_" + stepIndex));
                step.setTime(Integer.parseInt(request.getParameter("step_time_" + stepIndex)));
                step.setCost(Integer.parseInt(request.getParameter("step_cost_" + stepIndex)));
                steps.add(step);
                stepIndex++;
            }
            CommunityCourse course = new CommunityCourse();
            course.setUserId(user.getId());
            course.setTitle(title);
            course.setPreviewImage(previewImageUrl);
            boolean success = courseService.createCourseWithSteps(course, steps);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/course/detail?id=" + course.getId());
            } else {
                throw new Exception("코스 등록 실패");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "코스 등록 중 오류 발생");
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
    
    // [수정] 코스 상세 정보를 보여주는 메소드
    private void showCourseDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int courseId = 0;
        try {
            courseId = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "유효하지 않은 코스 ID입니다.");
            return;
        }
        
        // 1. 코스 기본 정보 가져오기
        CommunityCourse course = courseService.getCourseDetail(courseId);
        
        // 2. [추가] 코스에 포함된 개별 경로(steps) 목록 가져오기
        List<CourseStep> steps = courseService.getCourseSteps(courseId);
        
        // 3. JSP로 두 가지 데이터를 모두 전달
        request.setAttribute("course", course);
        request.setAttribute("steps", steps); // <-- 이 부분이 추가되었습니다.
        
        request.getRequestDispatcher("/WEB-INF/views/course-detail.jsp").forward(request, response);
    }
}