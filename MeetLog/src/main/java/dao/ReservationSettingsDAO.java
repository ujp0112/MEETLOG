package dao;

import model.ReservationSettings;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.Map;

public class ReservationSettingsDAO {
    private static final String NAMESPACE = "dao.ReservationSettingsDAO";

    /**
     * 음식점별 예약 설정 조회
     */
    public ReservationSettings findByRestaurantId(int restaurantId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne(NAMESPACE + ".findByRestaurantId", restaurantId);
        }
    }

    /**
     * 예약 설정 등록
     */
    public int insert(ReservationSettings settings) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.insert(NAMESPACE + ".insert", settings);
            session.commit();
            return result;
        }
    }

    /**
     * 예약 설정 업데이트
     */
    public int update(ReservationSettings settings) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.update(NAMESPACE + ".update", settings);
            session.commit();
            return result;
        }
    }

    /**
     * 예약 설정 업데이트 (트랜잭션 포함)
     */
    public int update(ReservationSettings settings, SqlSession session) {
        return session.update(NAMESPACE + ".update", settings);
    }

    /**
     * 예약 활성화/비활성화 상태 변경
     */
    public int updateReservationEnabled(int restaurantId, boolean enabled) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of(
                "restaurantId", restaurantId,
                "enabled", enabled
            );
            int result = session.update(NAMESPACE + ".updateReservationEnabled", params);
            session.commit();
            return result;
        }
    }

    /**
     * 자동 승인 설정 변경
     */
    public int updateAutoAccept(int restaurantId, boolean autoAccept) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of(
                "restaurantId", restaurantId,
                "autoAccept", autoAccept
            );
            int result = session.update(NAMESPACE + ".updateAutoAccept", params);
            session.commit();
            return result;
        }
    }

    /**
     * 예약 설정 삭제
     */
    public int delete(int restaurantId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.delete(NAMESPACE + ".delete", restaurantId);
            session.commit();
            return result;
        }
    }

    /**
     * 예약 설정 삭제 (트랜잭션 포함)
     */
    public int delete(int restaurantId, SqlSession session) {
        return session.delete(NAMESPACE + ".delete", restaurantId);
    }
}