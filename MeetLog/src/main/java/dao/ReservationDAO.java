package dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import model.Reservation;
import util.MyBatisSqlSessionFactory;

public class ReservationDAO {
	private static final String NAMESPACE = "dao.ReservationDAO";
	private static final Logger log = LoggerFactory.getLogger(ReservationDAO.class);

	public List<Reservation> findByRestaurantId(int restaurantId) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".findByRestaurantId", restaurantId);
		}
	}

	public Reservation findById(int reservationId) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectOne(NAMESPACE + ".findById", reservationId);
		}
	}

	public List<Reservation> findByUserId(int userId) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".findByUserId", userId);
		}
	}

	public List<Reservation> findRecentByUserId(Map<String, Object> params) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".findRecentByUserId", params);
		}
	}

	public int updateStatus(int reservationId, String status, SqlSession sqlSession) {
		java.util.Map<String, Object> params = new java.util.HashMap<>();
		params.put("id", reservationId);
		params.put("status", status);
		return sqlSession.update(NAMESPACE + ".updateStatus", params);
	}

	public int updateCancellation(int reservationId, String cancelReason, java.time.LocalDateTime cancelledAt,
			SqlSession sqlSession) {
		java.util.Map<String, Object> params = new java.util.HashMap<>();
		params.put("id", reservationId);
		params.put("status", "CANCELLED");
		params.put("cancelReason", cancelReason);
		params.put("cancelledAt", cancelledAt);
		return sqlSession.update(NAMESPACE + ".updateCancellation", params);
	}

	public int delete(int reservationId, SqlSession sqlSession) {
		return sqlSession.delete(NAMESPACE + ".delete", reservationId);
	}

	public List<Reservation> findTodayReservations(int restaurantId) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".findTodayReservations", restaurantId);
		}
	}

	public Object getReservationStats(int restaurantId) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectOne(NAMESPACE + ".getReservationStats", restaurantId);
		}
	}

	public List<Reservation> searchReservations(java.util.Map<String, Object> searchParams) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".searchReservations", searchParams);
		}
	}

	public int insert(Reservation reservation, SqlSession sqlSession) {
		log.debug("Inserting reservation data: {}", reservation);
		return sqlSession.insert(NAMESPACE + ".insert", reservation);
	}

	public int updatePaymentInfo(int reservationId, String paymentStatus, String paymentOrderId, String paymentProvider,
			java.time.LocalDateTime paidAt, java.math.BigDecimal depositAmount, boolean depositRequired) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			java.util.Map<String, Object> params = new java.util.HashMap<>();
			params.put("id", reservationId);
			params.put("paymentStatus", paymentStatus);
			params.put("paymentOrderId", paymentOrderId);
			params.put("paymentProvider", paymentProvider);
			params.put("paymentApprovedAt", paidAt);
			params.put("depositAmount", depositAmount);
			params.put("depositRequired", depositRequired);
			int result = sqlSession.update(NAMESPACE + ".updatePaymentInfo", params);
			sqlSession.commit();
			return result;
		}
	}
}
