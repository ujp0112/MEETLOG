package dao;

import model.ReservationTableAssignment;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;

public class ReservationTableAssignmentDAO {
    private static final String NAMESPACE = "dao.ReservationTableAssignmentDAO";

    /**
     * 테이블 배정 저장
     */
    public int insert(ReservationTableAssignment assignment) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.insert(NAMESPACE + ".insert", assignment);
            session.commit();
            return result;
        }
    }

    /**
     * 예약별 배정된 테이블 조회
     */
    public ReservationTableAssignment findByReservationId(int reservationId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne(NAMESPACE + ".findByReservationId", reservationId);
        }
    }

    /**
     * 테이블별 예약 목록 조회
     */
    public List<ReservationTableAssignment> findByTableId(int tableId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(NAMESPACE + ".findByTableId", tableId);
        }
    }

    /**
     * 테이블 배정 해제
     */
    public int delete(int reservationId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.delete(NAMESPACE + ".delete", reservationId);
            session.commit();
            return result;
        }
    }
}