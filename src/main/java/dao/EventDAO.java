package dao;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import model.Event;
import util.MyBatisSqlSessionFactory;

public class EventDAO {
    private static final String NAMESPACE = "mapper.EventMapper.";

    /**
     * 모든 이벤트 목록을 DB에서 조회합니다.
     * @return 이벤트 목록
     */
    public List<Event> selectAllEvents() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(NAMESPACE + "selectAllEvents");
        }
    }

    /**
     * ID에 해당하는 이벤트를 DB에서 조회합니다.
     * @param eventId 이벤트 ID
     * @return 이벤트 객체
     */
    public Event selectEventById(int eventId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne(NAMESPACE + "selectEventById", eventId);
        }
    }
}