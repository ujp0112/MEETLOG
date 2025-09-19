package service;

import dao.OperatingHourDAO;
import model.OperatingHour;
import java.util.List;
import org.apache.ibatis.session.SqlSession;

public class OperatingHourService {
	private OperatingHourDAO operatingHourDAO = new OperatingHourDAO();

	public List<OperatingHour> getOperatingHoursByRestaurantId(int restaurantId) {
		return operatingHourDAO.findByRestaurantId(restaurantId);
	}

	public void addOperatingHours(SqlSession sqlSession, List<OperatingHour> hours) {
		operatingHourDAO.insertBatch(sqlSession, hours);
	}

	public List<OperatingHour> findByRestaurantId(int restaurantId) {
		return operatingHourDAO.findByRestaurantId(restaurantId);
	}
}