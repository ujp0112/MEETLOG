package service;

import dao.OperatingHourDAO;
import model.OperatingHour;
import org.apache.ibatis.session.SqlSession;
import java.util.List;

public class OperatingHourService {
	private final OperatingHourDAO operatingHourDAO = new OperatingHourDAO();

	public List<OperatingHour> getOperatingHoursByRestaurantId(int restaurantId) {
		return operatingHourDAO.findByRestaurantId(restaurantId);
	}
	
	/**
	 * 여러 개의 영업시간 정보를 한 번에 등록합니다.
	 */
	public void addOperatingHours(SqlSession sqlSession, List<OperatingHour> hours) {
        // [수정] 원래 DAO에 있던 insertList를 호출하도록 변경
        operatingHourDAO.insertList(sqlSession, hours);
    }
}