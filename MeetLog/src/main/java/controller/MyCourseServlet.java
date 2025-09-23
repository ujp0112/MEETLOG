package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.User;
import model.Course;
import service.CourseService;

@WebServlet("/my-courses")
public class MyCourseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CourseService courseService = new CourseService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // 페이징 파라미터
            String pageStr = request.getParameter("page");
            int page = (pageStr == null || pageStr.isEmpty()) ? 1 : Integer.parseInt(pageStr);
            int pageSize = 12; // 한 페이지에 보여줄 코스 수
            int offset = (page - 1) * pageSize;
            
            // 내가 만든 코스 목록 조회
            List<Course> courses = courseService.getCoursesByAuthor(user.getId(), pageSize, offset);
            
            // 총 코스 수 (페이징용)
            int totalCourses = courseService.getCourseCountByAuthor(user.getId());
            int totalPages = (int) Math.ceil((double) totalCourses / pageSize);
            
            // 데이터 설정
            request.setAttribute("courses", courses);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalCourses", totalCourses);
            
            request.getRequestDispatcher("/WEB-INF/views/my-courses.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "내 코스 목록을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("delete".equals(action)) {
                deleteCourse(request, response, user.getId());
            } else if ("togglePublic".equals(action)) {
                toggleCoursePublic(request, response, user.getId());
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void deleteCourse(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws IOException {
        String courseIdStr = request.getParameter("courseId");
        
        if (courseIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        int courseId = Integer.parseInt(courseIdStr);
        
        // 코스 소유자 확인
        Course course = courseService.getCourseById(courseId);
        if (course == null || course.getAuthorId() != userId) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        if (courseService.deleteCourse(courseId)) {
            response.sendRedirect(request.getContextPath() + "/my-courses?deleted=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/my-courses?error=delete_failed");
        }
    }
    
    private void toggleCoursePublic(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws IOException {
        String courseIdStr = request.getParameter("courseId");
        
        if (courseIdStr == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"코스 ID가 필요합니다.\"}");
            return;
        }
        
        int courseId = Integer.parseInt(courseIdStr);
        
        // 코스 소유자 확인
        Course course = courseService.getCourseById(courseId);
        if (course == null || course.getAuthorId() != userId) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("{\"success\": false, \"message\": \"권한이 없습니다.\"}");
            return;
        }
        
        boolean success = courseService.toggleCoursePublic(courseId);
        boolean newPublicStatus = !course.isPublic();
        
        response.setContentType("application/json");
        response.getWriter().write(String.format(
            "{\"success\": %b, \"isPublic\": %b}", 
            success, newPublicStatus
        ));
    }
}
