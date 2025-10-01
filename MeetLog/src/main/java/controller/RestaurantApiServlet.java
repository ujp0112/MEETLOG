package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import model.Restaurant;
import service.RestaurantService;

@WebServlet("/api/restaurant/*")
public class RestaurantApiServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private final RestaurantService restaurantService = new RestaurantService();
	private final Gson gson = new Gson();

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String pathInfo = request.getPathInfo();
		if ("/find-or-create".equals(pathInfo)) {
			handleFindOrCreate(request, response);
		} else {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
		}
	}

	// controller/RestaurantApiServlet.java

	// ...

	private void handleFindOrCreate(HttpServletRequest request, HttpServletResponse response) throws IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		try {
			String kakaoPlaceId = request.getParameter("kakaoPlaceId");
			String name = request.getParameter("name");
			String address = request.getParameter("address");
			String phone = request.getParameter("phone");
			String category = request.getParameter("category");
			String location = request.getParameter("location"); // [추가] location 파라미터 받기

			double lat = parseDoubleParameter(request.getParameter("lat"));
			double lng = parseDoubleParameter(request.getParameter("lng"));

			Restaurant restaurant = restaurantService.findRestaurantByKakaoPlaceId(kakaoPlaceId);

			if (restaurant == null) {
				Restaurant newRestaurant = new Restaurant();
				newRestaurant.setKakaoPlaceId(kakaoPlaceId);
				newRestaurant.setName(name);
				newRestaurant.setAddress(address);
				newRestaurant.setPhone(phone);
				newRestaurant.setCategory(category);
				newRestaurant.setLocation(location); // [추가] location 값 설정
				newRestaurant.setLatitude(lat);
				newRestaurant.setLongitude(lng);

				restaurant = restaurantService.createRestaurantAndReturn(newRestaurant);
			}

			response.getWriter().write(gson.toJson(restaurant));

		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"error\": \"서버 처리 중 오류가 발생했습니다.\"}");
		}
	}

	/**
	 * [추가] 문자열 파라미터를 안전하게 Double로 변환하는 헬퍼 메서드
	 * 
	 * @param param 변환할 문자열
	 * @return 변환된 double 값 (실패 시 0.0)
	 */
	private double parseDoubleParameter(String param) {
		if (param == null || param.trim().isEmpty()) {
			return 0.0;
		}
		try {
			return Double.parseDouble(param);
		} catch (NumberFormatException e) {
			return 0.0;
		}
	}
}