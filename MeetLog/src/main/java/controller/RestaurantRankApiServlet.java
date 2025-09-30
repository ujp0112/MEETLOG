package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import dao.RestaurantDAO;
import model.Restaurant;

/**
 * Servlet implementation class RestaurantRankApiServlet
 */
//@WebServlet("/api/restaurants/rank")
public class RestaurantRankApiServlet extends HttpServlet {

	private final RestaurantDAO restaurantDao = new RestaurantDAO();
	// JSON 변환을 위한 Gson 라이브러리. pom.xml에 추가 필요
	private final Gson gson = new Gson();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// 1. 요청 파라미터에서 지역명(검색어) 가져오기
		String region = req.getParameter("region");

		if (region == null || region.trim().isEmpty()) {
			resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			resp.getWriter().write("{\"error\":\"Region parameter is missing\"}");
			return;
		}

		// 2. DAO를 통해 DB에서 해당 지역의 맛집 랭킹 조회
		// (getRankedByRegion 메소드는 아래에서 새로 만듭니다)
		List<Restaurant> rankedRestaurants = restaurantDao.getRankedByRegion(region);

		// 3. 조회된 데이터를 JSON 형태로 변환하여 응답
		resp.setContentType("application/json");
		resp.setCharacterEncoding("UTF-8");
		resp.getWriter().write(gson.toJson(rankedRestaurants));
	}
}
