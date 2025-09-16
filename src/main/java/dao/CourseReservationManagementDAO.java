package dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.session.SqlSession;
import model.AdminCourseReservation;
import util.MyBatisSqlSessionFactory;

public class CourseReservationManagementDAO {
    private static final String NAMESPACE = "mapper.CourseReservationManagementMapper.";

    /**
     * 관리자용 모든 코스 예약 목록을 DB에서 조회합니다.
     * @return AdminCourseReservation 목록
     */
    public List<AdminCourseReservation> selectAllReservationsForAdmin() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(NAMESPACE + "selectAllReservationsForAdmin");
        }
    }
    
    /**
     * 특정 예약의 상태를 DB에서 수정합니다.
     * @param reservationId 수정할 예약 ID
     * @param newStatus 새로운 상태 값
     */
    public void updateReservationStatus(int reservationId, String newStatus) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("id", reservationId);
            params.put("status", newStatus);
            session.update(NAMESPACE + "updateReservationStatus", params);
        }
    }
}