package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import dao.RestaurantDAO;
import model.Restaurant;

@WebServlet("/search/db-restaurants")
public class DBSearchServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final int PAGE_SIZE = 15;
    private static final Map<String, List<String>> categoryMap = new HashMap<>();
    static {
        categoryMap.put("한식", Arrays.asList("고기/구이", "찌개/전골", "백반/국밥", "족발/보쌈", "분식", "한식 기타", "한식"));
        categoryMap.put("일식", Arrays.asList("스시/오마카세", "라멘/돈부리", "돈까스/튀김", "이자카야", "일식 기타", "일식"));
        categoryMap.put("중식", Arrays.asList("중식"));
        categoryMap.put("양식", Arrays.asList("이탈리안", "프렌치", "스테이크/바베큐", "햄버거/피자", "양식 기타", "양식"));
        categoryMap.put("아시안", Arrays.asList("태국/베트남", "인도/중동", "아시안 기타"));
        categoryMap.put("카페", Arrays.asList("카페", "베이커리/디저트"));
        categoryMap.put("주점", Arrays.asList("주점"));
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            double lat = Double.parseDouble(request.getParameter("lat"));
            double lng = Double.parseDouble(request.getParameter("lng"));
            // /search/db-restaurants 요청을 처리하는 서블릿 내부
            String excludeIdsParam = request.getParameter("excludeIds");
            List<Integer> excludeIds = new ArrayList<>();

            if (excludeIdsParam != null && !excludeIdsParam.isEmpty()) {
                String[] ids = excludeIdsParam.split(",");
                for (String id : ids) {
                    try {
                        excludeIds.add(Integer.parseInt(id.trim()));
                    } catch (NumberFormatException e) {
                        e.printStackTrace();
                        // 예외 처리
                    }
                }
            }

            // DAO로 excludeIds 리스트를 전달하여 쿼리에 반영
            // List<Restaurant> restaurants = restaurantDAO.searchByLocation(lat, lng, level, category, page, excludeIds);

            
            int level = Integer.parseInt(request.getParameter("level"));
            String category = request.getParameter("category");
            
            // [수정] page 파라미터가 null이거나 비어있을 경우 기본값 1을 사용
            String pageParam = request.getParameter("page");
            int page = (pageParam == null || pageParam.isEmpty()) ? 1 : Integer.parseInt(pageParam);

            double radiusKm = getRadiusByZoomLevel(level);
            List<String> categoryFilter = categoryMap.get(category);
            int offset = (page - 1) * PAGE_SIZE;

            RestaurantDAO dao = new RestaurantDAO();
            List<Restaurant> restaurants = dao.findNearbyRestaurantsByPage(lat, lng, radiusKm, categoryFilter, offset, PAGE_SIZE, excludeIds);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print(new Gson().toJson(restaurants));
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid parameters");
        }
    }

    private double getRadiusByZoomLevel(int level) {
        if (level <= 3) return 10;
        if (level <= 5) return 5;
        if (level <= 7) return 2;
        if (level <= 9) return 1;
        return 0.5;
    }
}

