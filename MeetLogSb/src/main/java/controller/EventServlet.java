package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Event;
import service.EventService; // Service 계층 사용

public class EventServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // [수정] EventService 객체 생성
    private EventService eventService = new EventService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/list")) {
                handleEventList(request, response);
            } else if (pathInfo.equals("/detail")) {
                handleEventDetail(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "요청 처리 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private void handleEventList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // [수정] Service를 통해 DB에서 분류된 이벤트 목록을 가져옴
        List<List<Event>> categorizedEvents = eventService.getCategorizedEvents();
        
        request.setAttribute("ongoingEvents", categorizedEvents.get(0));
        request.setAttribute("finishedEvents", categorizedEvents.get(1));
        
        request.getRequestDispatcher("/WEB-INF/views/event-list.jsp").forward(request, response);
    }
    
    private void handleEventDetail(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int eventId = Integer.parseInt(request.getParameter("id"));
        
        // [수정] Service를 통해 DB에서 특정 이벤트 정보를 가져옴
        Event event = eventService.getEventById(eventId);

        if (event == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "해당 이벤트를 찾을 수 없습니다.");
            return;
        }

        request.setAttribute("event", event);
        request.getRequestDispatcher("/WEB-INF/views/event-detail.jsp").forward(request, response);
    }
}