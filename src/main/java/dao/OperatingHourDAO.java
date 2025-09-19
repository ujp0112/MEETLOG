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
}