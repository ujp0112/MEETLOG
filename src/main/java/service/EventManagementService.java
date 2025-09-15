package service;

import java.util.List;
import dao.EventManagementDAO;
import model.AdminEvent;

public class EventManagementService {
    private EventManagementDAO eventDAO = new EventManagementDAO();

    /**
     * 관리자 페이지의 모든 이벤트 목록을 가져옵니다.
     * @return AdminEvent 목록
     */
    public List<AdminEvent> getAllEventsForAdmin() {
        return eventDAO.selectAllEventsForAdmin();
    }
    
    /**
     * 새로운 이벤트를 DB에 추가합니다.
     * @param event 추가할 이벤트 정보
     */
    public void addEvent(AdminEvent event) {
        // TODO: 이미지 업로드 처리 등 추가적인 비즈니스 로직이 필요하다면 여기에 구현
        eventDAO.insertEvent(event);
    }
    
    /**
     * 기존 이벤트 정보를 수정합니다.
     * @param event 수정할 이벤트 정보
     */
    public void updateEvent(AdminEvent event) {
        eventDAO.updateEvent(event);
    }
    
    /**
     * ID에 해당하는 이벤트를 삭제합니다.
     * @param eventId 삭제할 이벤트 ID
     */
    public void deleteEvent(int eventId) {
        eventDAO.deleteEvent(eventId);
    }
}