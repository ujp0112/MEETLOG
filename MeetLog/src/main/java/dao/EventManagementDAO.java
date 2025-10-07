package dao;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import model.AdminEvent;
import util.MyBatisSqlSessionFactory;

public class EventManagementDAO {
    private static final String NAMESPACE = "mapper.EventManagementMapper.";

    /**
     * 관리자용 모든 이벤트 목록을 DB에서 조회합니다.
     * @return AdminEvent 목록
     */
    public List<AdminEvent> selectAllEventsForAdmin() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(NAMESPACE + "selectAllEventsForAdmin");
        }
    }
    
    /**
     * 새로운 이벤트를 DB에 삽입합니다.
     * @param event 삽입할 이벤트 객체
     */
    public void insertEvent(AdminEvent event) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            session.insert(NAMESPACE + "insertEvent", event);
            session.commit();
        }
    }

    /**
     * 이벤트 정보를 DB에서 수정합니다.
     * @param event 수정할 이벤트 객체
     */
    public void updateEvent(AdminEvent event) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            session.update(NAMESPACE + "updateEvent", event);
            session.commit();
        }
    }
    
    /**
     * 이벤트를 DB에서 삭제합니다.
     * @param eventId 삭제할 이벤트 ID
     */
    public void deleteEvent(int eventId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            session.delete(NAMESPACE + "deleteEvent", eventId);
            session.commit();
        }
    }
}
