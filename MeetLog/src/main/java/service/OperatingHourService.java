package service;

import dao.OperatingHourDAO;
import model.OperatingHour;
import java.util.List;

public class OperatingHourService {
	private OperatingHourDAO operatingHourDAO = new OperatingHourDAO();

	public List<OperatingHour> getOperatingHoursByRestaurantId(int restaurantId) {
		return operatingHourDAO.findByRestaurantId(restaurantId);
	}
}