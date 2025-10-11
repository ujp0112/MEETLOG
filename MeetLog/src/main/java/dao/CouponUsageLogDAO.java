package dao;

import java.math.BigDecimal;
import java.util.List;
import model.CouponUsageLog;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;

/**
 * 쿠폰 사용 로그 DAO
 */
public class CouponUsageLogDAO {

    /**
     * 쿠폰 사용 로그 추가
     *
     * @param userCouponId 사용자 쿠폰 ID
     * @param reservationId 예약 ID
     * @param action 액션 (USE, ROLLBACK)
     * @param discountAmount 할인 금액
     * @return 추가된 행 수
     */
    public int insertLog(int userCouponId, Integer reservationId, String action, BigDecimal discountAmount) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            CouponUsageLog log = new CouponUsageLog(userCouponId, reservationId, action, discountAmount);
            int result = sqlSession.insert("CouponUsageLogMapper.insertLog", log);
            sqlSession.commit();
            return result;
        } catch (Exception e) {
            System.err.println("쿠폰 사용 로그 추가 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * 특정 사용자 쿠폰의 로그 조회
     *
     * @param userCouponId 사용자 쿠폰 ID
     * @return 로그 리스트
     */
    public List<CouponUsageLog> findByUserCouponId(int userCouponId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList("CouponUsageLogMapper.findByUserCouponId", userCouponId);
        } catch (Exception e) {
            System.err.println("쿠폰 사용 로그 조회 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 특정 예약의 쿠폰 사용 로그 조회
     *
     * @param reservationId 예약 ID
     * @return 로그 리스트
     */
    public List<CouponUsageLog> findByReservationId(int reservationId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList("CouponUsageLogMapper.findByReservationId", reservationId);
        } catch (Exception e) {
            System.err.println("쿠폰 사용 로그 조회 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}
