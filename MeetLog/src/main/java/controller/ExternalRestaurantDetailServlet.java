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
import util.GooglePlacesUtil; // [수정] GooglePlacesUtil만 사용

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
        
        // ▼▼▼ [수정] Google Places API 연동 (이미지 포함) ▼▼▼
        String placeId = GooglePlacesUtil.findPlaceId(name, restaurant.getLatitude(), restaurant.getLongitude());
        if (placeId != null) {
            // placeId로 상세 정보를 가져와 restaurant 객체를 업데이트합니다.
            GooglePlacesUtil.getPlaceDetails(placeId, restaurant);
        }
        // ▲▲▲ [수정] Google Places API 연동 끝 ▲▲▲
        
        request.setAttribute("isExternal", true);
        request.setAttribute("restaurant", restaurant);
        // [수정] externalImages는 restaurant 객체 안의 additionalImages를 사용하므로 별도 전달 필요 없음
        // request.setAttribute("externalImages", restaurant.getAdditionalImages());
        request.setAttribute("operatingHours", Collections.emptyList());
        request.setAttribute("menus", Collections.emptyList()); // 외부 맛집은 메뉴 정보 없음
        // [제거] reviews 정보는 restaurant 객체 안에 포함되어 있으므로 별도 전달 필요 없음
        // request.setAttribute("reviews", Collections.emptyList());
        request.setAttribute("qnas", Collections.emptyList());
        request.setAttribute("coupons", Collections.emptyList());

        request.getRequestDispatcher("/WEB-INF/views/restaurant-detail.jsp").forward(request, response);
    }
}
