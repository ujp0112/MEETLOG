package dao;

import model.PointBalance;
import model.PointTransaction;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 포인트 데이터 액세스 객체
 */
public class PointDAO {

    /**
     * 사용자 포인트 잔액 조회
     */
    public PointBalance getBalance(int userId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne("mapper.PointMapper.getBalance", userId);
        }
    }

    /**
     * 포인트 계정 초기화 (잔액 0으로)
     */
    public void initBalance(int userId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            session.insert("mapper.PointMapper.initBalance", userId);
            session.commit();
        }
    }

    /**
     * 포인트 잔액 업데이트 (원자적 연산)
     *
     * @param userId 사용자 ID
     * @param changeAmount 변경 금액 (양수: 적립, 음수: 차감)
     * @return 영향받은 행 수 (0이면 실패)
     */
    public int updateBalance(int userId, int changeAmount) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("userId", userId);
            params.put("changeAmount", changeAmount);

            int result = session.update("mapper.PointMapper.updateBalance", params);
            session.commit();
            return result;
        }
    }

    /**
     * 포인트 차감 (잔액 체크 포함)
     *
     * @param userId 사용자 ID
     * @param changeAmount 차감 금액
     * @param minBalance 최소 잔액 (차감 전 잔액이 이보다 작으면 실패)
     * @return 영향받은 행 수 (0이면 실패)
     */
    public int redeemBalance(int userId, int changeAmount, int minBalance) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("userId", userId);
            params.put("changeAmount", changeAmount);
            params.put("minBalance", minBalance);

            int result = session.update("mapper.PointMapper.redeemBalance", params);
            session.commit();
            return result;
        }
    }

    /**
     * 포인트 거래 내역 삽입
     */
    public void insertTransaction(PointTransaction transaction) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            session.insert("mapper.PointMapper.insertTransaction", transaction);
            session.commit();
        }
    }

    /**
     * 사용자의 포인트 거래 내역 조회
     *
     * @param userId 사용자 ID
     * @param type 거래 유형 필터 (null이면 전체)
     * @param offset 시작 위치
     * @param limit 조회 개수
     * @return 거래 내역 리스트
     */
    public List<PointTransaction> findTransactions(int userId, String type, int offset, int limit) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("userId", userId);
            params.put("type", type);
            params.put("offset", offset);
            params.put("limit", limit);

            return session.selectList("mapper.PointMapper.findTransactions", params);
        }
    }

    /**
     * 만료 예정 포인트 합계 조회
     *
     * @param userId 사용자 ID
     * @param beforeDate 기준 날짜 (이전에 만료되는 포인트)
     * @return 만료 예정 포인트 합계
     */
    public int sumExpiringPoints(int userId, LocalDate beforeDate) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("userId", userId);
            params.put("beforeDate", beforeDate);

            Integer sum = session.selectOne("mapper.PointMapper.sumExpiringPoints", params);
            return sum != null ? sum : 0;
        }
    }
}
