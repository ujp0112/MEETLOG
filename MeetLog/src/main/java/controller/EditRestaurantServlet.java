package controller;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.TypeAdapter;
import com.google.gson.stream.JsonReader;
import com.google.gson.stream.JsonWriter;

import dao.OperatingHourDAO;
import model.OperatingHour;
import model.Restaurant;
import model.User;
import service.OperatingHourService;
import service.RestaurantService;

@WebServlet("/business/restaurants/edit")
public class EditRestaurantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RestaurantService restaurantService = new RestaurantService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        OperatingHourService operatingHourService = new OperatingHourService();
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"BUSINESS".equals(user.getUserType())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "로그인이 필요하거나 권한이 없습니다.");
            return;
        }

        // LocalTime과 LocalDateTime을 위한 커스텀 Gson 객체 생성
        Gson gson = new GsonBuilder()
            .registerTypeAdapter(LocalTime.class, new TypeAdapter<LocalTime>() {
                private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");
                @Override
                public void write(JsonWriter out, LocalTime value) throws IOException {
                    out.value(value != null ? value.format(formatter) : null);
                }
                @Override
                public LocalTime read(JsonReader in) throws IOException {
                    return LocalTime.parse(in.nextString(), formatter);
                }
            })
            .registerTypeAdapter(LocalDateTime.class, new TypeAdapter<LocalDateTime>() {
                private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                @Override
                public void write(JsonWriter out, LocalDateTime value) throws IOException {
                    out.value(value != null ? value.format(formatter) : null);
                }
                @Override
                public LocalDateTime read(JsonReader in) throws IOException {
                    return LocalDateTime.parse(in.nextString(), formatter);
                }
            })
            .create();

        try {
            int restaurantId = Integer.parseInt(request.getParameter("id"));
            OperatingHourDAO operatingDAO = new OperatingHourDAO();
            // [중요] 추가 이미지까지 모두 가져오는 findDetailById 사용
            Restaurant restaurant1 = restaurantService.getRestaurantDetailById(restaurantId);
            Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
            restaurant.setAdditionalImages(restaurant1.getAdditionalImages());
            String restaurantJson = gson.toJson(restaurant);
            List<OperatingHour> operatingHours = operatingHourService.findByRestaurantId(restaurantId);
            String operatingHoursJson = gson.toJson(operatingHours);
            
            // [권한 체크] 가게가 존재하고, 현재 로그인한 사용자가 가게 주인인지 확인
            if (restaurant != null && restaurant.getOwnerId() == user.getId()) {
            	request.setAttribute("restaurantJson", restaurantJson);
            	request.setAttribute("operatingHoursJson", operatingHoursJson);
                request.setAttribute("restaurant", restaurant);
                request.setAttribute("isEditMode", true); // 수정 모드임을 JSP에 알림
                request.getRequestDispatcher("/WEB-INF/views/add-restaurant.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "수정 권한이 없습니다.");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 가게 ID입니다.");
        }
    }
}