package controller;

import java.io.IOException;
import java.util.Collections;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Restaurant;

@WebServlet("/searchRestaurant/external-detail")
public class ExternalRestaurantDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 1. URL 파라미터로부터 가게 정보를 받아옵니다.
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String category = request.getParameter("category");
        String latitudeStr = request.getParameter("lat");
        String longitudeStr = request.getParameter("lng");

        // 2. 받은 정보를 Restaurant 객체에 담습니다.
        // 이 객체는 DB에 저장된 것이 아닌, 외부 API 정보로 임시 생성된 것입니다.
        Restaurant restaurant = new Restaurant();
        restaurant.setName(name);
        restaurant.setAddress(address);
        restaurant.setPhone(phone);
        restaurant.setCategory(category);
        
        try {
            if (latitudeStr != null && !latitudeStr.isEmpty()) {
                restaurant.setLatitude(Double.parseDouble(latitudeStr));
            }
            if (longitudeStr != null && !longitudeStr.isEmpty()) {
                restaurant.setLongitude(Double.parseDouble(longitudeStr));
            }
        } catch (NumberFormatException e) {
            System.err.println("Invalid coordinate format: " + e.getMessage());
            // 기본값 또는 오류 처리
            restaurant.setLatitude(37.566826); // 기본 위치: 서울 시청
            restaurant.setLongitude(126.9786567);
        }
        
        // 3. isExternal 플래그를 true로 설정하여 JSP에서 구분할 수 있도록 합니다.
        // 이 플래그를 이용해 JSP에서는 리뷰, Q&A 등 DB 데이터가 필요한 섹션을 숨깁니다.
        request.setAttribute("isExternal", true);
        request.setAttribute("restaurant", restaurant);
        
        // 4. 빈 리스트를 설정하여 JSTL 오류를 방지합니다.
        request.setAttribute("operatingHours", Collections.emptyList());
        request.setAttribute("menus", Collections.emptyList());
        request.setAttribute("reviews", Collections.emptyList());
        request.setAttribute("qnas", Collections.emptyList());
        request.setAttribute("coupons", Collections.emptyList());


        // 5. restaurant-detail.jsp로 포워딩하여 화면을 렌더링합니다.
        request.getRequestDispatcher("/WEB-INF/views/restaurant-detail.jsp").forward(request, response);
    }
}
