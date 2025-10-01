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
		request.setCharacterEncoding("UTF-8"); // [추가] POST 요청에 대한 인코딩 설정

		String pathInfo = request.getPathInfo();
		if ("/find-or-create".equals(pathInfo)) {
			handleFindOrCreate(request, response);
		} else {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
		}
	}

	private void handleFindOrCreate(HttpServletRequest request, HttpServletResponse response) throws IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		try {
			// 1. 프론트엔드에서 전송된 파라미터 수신
			String kakaoPlaceId = request.getParameter("kakaoPlaceId");
			String name = request.getParameter("name");
			String address = request.getParameter("address");
			String phone = request.getParameter("phone");
			String category = request.getParameter("category");
			String location = request.getParameter("location");

			double lat = parseDoubleParameter(request.getParameter("lat"));
			double lng = parseDoubleParameter(request.getParameter("lng"));

			// [수정] Restaurant 객체를 먼저 생성하고 서비스 레이어에 전달
			Restaurant restaurantData = new Restaurant();
			restaurantData.setKakaoPlaceId(kakaoPlaceId);
			restaurantData.setName(name);
			restaurantData.setAddress(address);
			restaurantData.setPhone(phone);
			restaurantData.setCategory(category);
			restaurantData.setLocation(location);
			restaurantData.setLatitude(lat);
			restaurantData.setLongitude(lng);

			// [수정] 서비스의 findOrCreateRestaurant 메서드 호출
			Restaurant restaurant = restaurantService.findOrCreateRestaurant(restaurantData);

			// 4. 최종 결과(찾았거나 새로 생성한 맛집 정보)를 JSON으로 응답
			response.getWriter().write(gson.toJson(restaurant));

		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"error\": \"서버 처리 중 오류가 발생했습니다.\"}");
		}
	}

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