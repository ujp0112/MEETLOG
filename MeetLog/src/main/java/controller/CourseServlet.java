package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// [필수] Paging과 Course 모델 클래스를 import 해야 합니다.
import model.CommunityCourse;
import model.OfficialCourse;
import model.Paging; 
import service.CourseService; 

/**
 * '추천코스' 페이지(/course) 요청을 처리하는 서블릿 (새로운 JSP 디자인에 맞게 수정됨)
 */
public class CourseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private CourseService courseService = new CourseService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // --- 1. 파라미터 받기 ---
            
            // "모두의 코스" (커뮤니티) 검색 파라미터
            String query = request.getParameter("query");
            String area = request.getParameter("area");
            
            // "모두의 코스" (커뮤니티) 페이지네이션 파라미터
            int page = 1; // 기본 1페이지
            if (request.getParameter("page") != null && !request.getParameter("page").isEmpty()) {
                try {
                    page = Integer.parseInt(request.getParameter("page"));
                } catch (NumberFormatException e) {
                    System.out.println("Invalid page number parameter. Defaulting to 1.");
                    page = 1; // 숫자가 아닌 값이 들어오면 1로 초기화
                }
            }

            // --- 2. Service 호출 ---
            // (이 3개의 메서드는 CourseService에 새로 추가되어야 합니다)
            
            // 2-1. "모두의 코스" (커뮤니티) 목록 (페이징 적용)
            List<CommunityCourse> communityCourses = courseService.getCommunityCourses(query, area, page);
            
            // 2-2. "모두의 코스" (커뮤니티) 페이징 정보
            Paging paging = courseService.getCommunityCoursePaging(query, area, page);
            
            // 2-3. "오늘의 추천코스" (운영자) 목록
            List<OfficialCourse> officialCourses = courseService.getOfficialCourses();

            // --- 3. JSP로 모든 데이터 전달 ---
            request.setAttribute("communityCourses", communityCourses);
            request.setAttribute("paging", paging); // 페이지네이션 객체
            request.setAttribute("officialCourses", officialCourses);
            
            request.setAttribute("query", query);
            request.setAttribute("area", area);

            // --- 4. JSP 페이지로 포워딩 ---
            request.getRequestDispatcher("/WEB-INF/views/course-recommendation.jsp").forward(request, response);
        
        } catch (Exception e) {
            e.printStackTrace(); // 콘솔에 에러 로그 출력
            // [!] 에러 페이지로 포워딩하는 것이 좋습니다.
            request.setAttribute("errorMessage", "코스 목록을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); // POST 한글 깨짐 방지
        doGet(request, response);
    }
}