package controller;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.AdminEvent;
import model.User;
import service.EventManagementService; // Service 계층 사용

public class EventManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // [수정] EventManagementService 객체 생성
    private EventManagementService eventService = new EventManagementService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User adminUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (adminUser == null || !"ADMIN".equals(adminUser.getUserType())) {
            response.sendRedirect(request.getContextPath() + "/main");
            return;
        }
        
        // [수정] Service를 통해 DB에서 실제 이벤트 목록을 가져옴
        List<AdminEvent> events = eventService.getAllEventsForAdmin();
        request.setAttribute("events", events);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/event-management.jsp").forward(request, response);
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
                    // JSP 폼에서 넘어온 데이터를 AdminEvent 객체로 만듦
                    AdminEvent newEvent = new AdminEvent();
                    newEvent.setTitle(request.getParameter("title"));
                    newEvent.setDescription(request.getParameter("description"));
                    // 날짜 형식 변환
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    newEvent.setStartDate(sdf.parse(request.getParameter("startDate")));
                    newEvent.setEndDate(sdf.parse(request.getParameter("endDate")));
                    
                    eventService.addEvent(newEvent); // Service를 통해 DB에 추가
                    request.setAttribute("successMessage", "새 이벤트가 성공적으로 등록되었습니다.");
                    break;
                    
                case "update":
                    AdminEvent updateEvent = new AdminEvent();
                    updateEvent.setId(Integer.parseInt(request.getParameter("id")));
                    updateEvent.setTitle(request.getParameter("title"));
                    // ... (수정에 필요한 모든 파라미터를 받아와서 객체에 설정)
                    
                    eventService.updateEvent(updateEvent); // Service를 통해 DB 수정
                    request.setAttribute("successMessage", "이벤트 정보가 수정되었습니다.");
                    break;
                    
                case "delete":
                    int eventId = Integer.parseInt(request.getParameter("id"));
                    eventService.deleteEvent(eventId); // Service를 통해 DB 삭제
                    request.setAttribute("successMessage", "이벤트가 삭제되었습니다.");
                    break;
                    
                default:
                    request.setAttribute("errorMessage", "알 수 없는 요청입니다.");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "작업 처리 중 오류가 발생했습니다: " + e.getMessage());
        }
        
        doGet(request, response); // 작업 완료 후 목록 페이지 새로고침
    }
}