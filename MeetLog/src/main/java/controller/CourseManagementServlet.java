package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.AdminCourse;
import model.User;
import service.CourseManagementService; // Service 계층 사용

public class CourseManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private CourseManagementService courseService = new CourseManagementService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User adminUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (adminUser == null || !"ADMIN".equals(adminUser.getUserType())) {
            response.sendRedirect(request.getContextPath() + "/main");
            return;
        }
        
        List<AdminCourse> courses = courseService.getAllCoursesForAdmin();
        request.setAttribute("courses", courses);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/course-management.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        User adminUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (adminUser == null || !"ADMIN".equals(adminUser.getUserType())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "권한이 없습니다.");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "add":
                    AdminCourse newCourse = new AdminCourse();
                    newCourse.setTitle(request.getParameter("title"));
                    newCourse.setDescription(request.getParameter("description"));
                    newCourse.setArea(request.getParameter("area"));
                    newCourse.setDuration(request.getParameter("duration"));
                    newCourse.setPrice(Integer.parseInt(request.getParameter("price")));
                    newCourse.setMaxParticipants(Integer.parseInt(request.getParameter("maxParticipants")));
                    
                    courseService.addCourse(newCourse);
                    request.setAttribute("successMessage", "새 코스가 성공적으로 등록되었습니다.");
                    break;
                    
                case "update":
                    AdminCourse updateCourse = new AdminCourse();
                    updateCourse.setId(Integer.parseInt(request.getParameter("id")));
                    // ... (수정에 필요한 모든 파라미터를 받아와서 객체에 설정)
                    
                    courseService.updateCourse(updateCourse);
                    request.setAttribute("successMessage", "코스 정보가 수정되었습니다.");
                    break;
                    
                case "delete":
                    int courseId = Integer.parseInt(request.getParameter("id"));
                    courseService.deleteCourse(courseId);
                    request.setAttribute("successMessage", "코스가 삭제되었습니다.");
                    break;
                    
                default:
                    request.setAttribute("errorMessage", "알 수 없는 요청입니다.");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "작업 처리 중 오류가 발생했습니다: " + e.getMessage());
        }
        
        doGet(request, response);
    }
}