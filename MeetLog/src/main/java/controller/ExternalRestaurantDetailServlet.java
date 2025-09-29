package controller;

import java.io.IOException;
import java.util.Collections;
import java.util.List; // [추가] List 임포트
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Restaurant;
import util.NaverImageSearch; // [추가] NaverImageSearch 유틸리티 임포트

@WebServlet("/searchRestaurant/external-detail")
public class ExternalRestaurantDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String category = request.getParameter("category");
        String latitudeStr = request.getParameter("lat");
        String longitudeStr = request.getParameter("lng");

        Restaurant restaurant = new Restaurant();
        restaurant.setName(name);
        restaurant.setAddress(address);
        restaurant.setPhone(phone);
        restaurant.setCategory(category);
        
     // ▼▼▼ [수정] 주소 문자열에서 location (시/군/구) 정보 추출 로직 추가 ▼▼▼
        if (address != null && !address.isEmpty()) {
            String[] addressParts = address.split(" ");
            if (addressParts.length >= 2) {
                // 주소의 첫 두 부분을 location으로 설정 (예: "서울 중구")
                String location = addressParts[0] + " " + addressParts[1];
                restaurant.setLocation(location);
            } else {
                // 주소가 한 단어일 경우 그대로 사용
                restaurant.setLocation(address);
            }
        }
        // ▲▲▲ [수정] 로직 끝 ▲▲▲
        
        try {
            if (latitudeStr != null && !latitudeStr.isEmpty()) {
                restaurant.setLatitude(Double.parseDouble(latitudeStr));
            }
            if (longitudeStr != null && !longitudeStr.isEmpty()) {
                restaurant.setLongitude(Double.parseDouble(longitudeStr));
            }
        } catch (NumberFormatException e) {
            System.err.println("Invalid coordinate format: " + e.getMessage());
            restaurant.setLatitude(37.566826);
            restaurant.setLongitude(126.9786567);
        }
        
        // ▼▼▼ [수정] Naver 이미지 검색 로직 추가 ▼▼▼
        String[] addressParts = address.split(" ");
        String searchQuery = name;
        if (addressParts.length > 1) {
            searchQuery += " " + addressParts[0] + " " + addressParts[1];
        }
        
        List<String> externalImages = NaverImageSearch.searchImages(searchQuery, 10);
        
        request.setAttribute("isExternal", true);
        request.setAttribute("restaurant", restaurant);
        request.setAttribute("externalImages", externalImages); // [추가] 이미지 목록 전달

        request.setAttribute("operatingHours", Collections.emptyList());
        request.setAttribute("menus", Collections.emptyList());
        request.setAttribute("reviews", Collections.emptyList());
        request.setAttribute("qnas", Collections.emptyList());
        request.setAttribute("coupons", Collections.emptyList());

        request.getRequestDispatcher("/WEB-INF/views/restaurant-detail.jsp").forward(request, response);
    }
}
