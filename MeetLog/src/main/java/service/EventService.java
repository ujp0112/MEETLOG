package service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import dao.EventDAO;
import model.Event;

public class EventService {
    private EventDAO eventDAO = new EventDAO();

    /**
     * 모든 이벤트 목록을 가져와 진행중/종료된 이벤트로 분류합니다.
     * @return 진행중인 이벤트 목록과 종료된 이벤트 목록을 담은 List 배열 (인덱스 0: 진행중, 인덱스 1: 종료)
     */
    public List<List<Event>> getCategorizedEvents() {
        List<Event> allEvents = eventDAO.selectAllEvents();
        
        List<Event> ongoingEvents = new ArrayList<>();
        List<Event> finishedEvents = new ArrayList<>();
        Date today = new Date(); // 오늘 날짜

        for (Event event : allEvents) {
            
            // === 💥 여기가 수정된 부분 ===
            // event.getEndDate()가 NULL일 수 있으므로 널 체크 추가
            Date endDate = event.getEndDate();
            
            // 1. 종료일이 NULL이거나 (상시 이벤트)
            // 2. 종료일이 오늘보다 이후이면 (아직 진행중)
            if (endDate == null || endDate.after(today)) {
                ongoingEvents.add(event);
            } else {
                // 종료일이 오늘이거나 오늘 이전이면 '종료된 이벤트'
                finishedEvents.add(event);
            }
            // === 💥 수정 끝 ===
        }
        
        List<List<Event>> categorizedEvents = new ArrayList<>();
        categorizedEvents.add(ongoingEvents);
        categorizedEvents.add(finishedEvents);
        
        return categorizedEvents;
    }
    
    /**
     * ID로 특정 이벤트 정보를 가져옵니다.
     * @param eventId 이벤트 ID
     * @return Event 객체
     */
    public Event getEventById(int eventId) {
        return eventDAO.selectEventById(eventId);
    }
}