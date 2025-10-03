package dao;

import model.CourseReservation;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CourseReservationDAO {
    private static final String NAMESPACE = "mapper.CourseReservationMapper";

    public List<CourseReservation> selectAllReservations() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(NAMESPACE + ".selectAllReservations");
        }
    }

    public List<CourseReservation> selectReservationsByStatus(String status) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(NAMESPACE + ".selectReservationsByStatus", status);
        }
    }

    public List<CourseReservation> selectReservationsByCourse(int courseId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(NAMESPACE + ".selectReservationsByCourse", courseId);
        }
    }

    public CourseReservation selectReservationById(int reservationId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne(NAMESPACE + ".selectReservationById", reservationId);
        }
    }

    public int updateReservationStatus(int reservationId, String status) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("reservationId", reservationId);
            params.put("status", status);
            int result = session.update(NAMESPACE + ".updateReservationStatus", params);
            session.commit();
            return result;
        }
    }

    public Map<String, Integer> getReservationStatistics() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne(NAMESPACE + ".getReservationStatistics");
        }
    }
}
