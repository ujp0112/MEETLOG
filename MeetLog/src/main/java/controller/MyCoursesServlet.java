package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.User;
import model.Course;
import model.CommunityCourse;
import service.CourseService;

public class MyCoursesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
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

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // 내 코스 목록 페이지
                List<CommunityCourse> myCourses = courseService.getCoursesByUserId(user.getId());
                List<CommunityCourse> bookmarkedCourses = courseService.getBookmarkedCourses(user.getId());

                request.setAttribute("myCourses", myCourses);
                request.setAttribute("bookmarkedCourses", bookmarkedCourses);
                request.getRequestDispatcher("/WEB-INF/views/my-courses.jsp").forward(request, response);

            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "코스를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
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

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        try {
            if ("bookmark".equals(action)) {
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                courseService.toggleCourseBookmark(user.getId(), courseId);
                response.sendRedirect(request.getContextPath() + "/my-courses");

            } else if ("delete".equals(action)) {
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                courseService.deleteCourse(courseId, user.getId());
                response.sendRedirect(request.getContextPath() + "/my-courses");

            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "작업을 처리하는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
}