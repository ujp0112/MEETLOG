package dao;

import model.OperatingHour;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;

public class OperatingHourDAO {
	private static final String NAMESPACE = "dao.OperatingHourDAO";

	public List<OperatingHour> findByRestaurantId(int restaurantId) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".findByRestaurantId", restaurantId);
		}
	}

	/**
	 * 트랜잭션 관리를 위해 SqlSession을 외부에서 받아 처리하는 메소드
	 */
	public void insertList(SqlSession sqlSession, List<OperatingHour> hours) {
		if (hours != null && !hours.isEmpty()) {
			// OperatingHourMapper.xml의 id="insertList"를 호출합니다.
			sqlSession.insert(NAMESPACE + ".insertList", hours);
		}
	}

	public void deleteOperatingHoursByRestaurantId(SqlSession sqlSession, int restaurantId) {
		// OperatingHourMapper.xml의 id="insertList"를 호출합니다.
		sqlSession.delete(NAMESPACE + ".deleteOperatingHoursByRestaurantId", restaurantId);

	}
}