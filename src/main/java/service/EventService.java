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
        Date today = new Date();

        for (Event event : allEvents) {
            // 이벤트 종료일이 오늘보다 이후이면 진행중인 이벤트
            if (event.getEndDate().after(today)) {
                ongoingEvents.add(event);
            } else {
                finishedEvents.add(event);
            }
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