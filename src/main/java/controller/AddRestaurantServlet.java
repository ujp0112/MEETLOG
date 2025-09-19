package controller;

import java.io.File;
import java.io.IOException;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import org.apache.ibatis.session.SqlSession;

import model.OperatingHour;
import model.Restaurant;
import model.User;
import service.OperatingHourService;
import service.RestaurantService;
import util.MyBatisSqlSessionFactory;

@WebServlet("/business/restaurants/add")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 100   // 100 MB
)
public class AddRestaurantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final RestaurantService restaurantService = new RestaurantService();
    private final OperatingHourService operatingHourService = new OperatingHourService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/add-restaurant.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"BUSINESS".equals(user.getUserType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisSqlSessionFactory.getSqlSession(false); 
            
            Part filePart = request.getPart("restaurantImage");
            String savedFilePath = null;
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = filePart.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("/uploads/restaurant_images");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                
                String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
                filePart.write(uploadPath + File.separator + uniqueFileName);
                savedFilePath = "uploads/restaurant_images/" + uniqueFileName;
            }

            Restaurant restaurant = new Restaurant();
            restaurant.setOwnerId(user.getId());
            restaurant.setName(request.getParameter("name"));
            restaurant.setCategory(request.getParameter("category"));
            restaurant.setLocation(request.getParameter("location"));
            
            String roadAddress = request.getParameter("address") != null ? request.getParameter("address") : "";
            String detailAddress = request.getParameter("detail_address") != null ? request.getParameter("detail_address") : "";
            restaurant.setAddress(roadAddress + " " + detailAddress);
            
            restaurant.setPhone(request.getParameter("phone"));
            restaurant.setHours(request.getParameter("hours"));
            restaurant.setDescription(request.getParameter("description"));
            restaurant.setParking(Boolean.parseBoolean(request.getParameter("parking")));
            if (savedFilePath != null) restaurant.setImage(savedFilePath);
            
            String latParam = request.getParameter("latitude");
            if (latParam != null && !latParam.isEmpty()) restaurant.setLatitude(Double.parseDouble(latParam));
            String lonParam = request.getParameter("longitude");
            if (lonParam != null && !lonParam.isEmpty()) restaurant.setLongitude(Double.parseDouble(lonParam));
            
            restaurantService.addRestaurant(sqlSession, restaurant);
            int newRestaurantId = restaurant.getId();

            List<OperatingHour> hours = new ArrayList<>();
            for (int i = 1; i <= 7; i++) {
                if (request.getParameter("is_closed_" + i) != null) continue;
                
                int slotIndex = 1;
                while (true) {
                    String openTimeStr = request.getParameter("day_" + i + "_open_" + slotIndex);
                    String closeTimeStr = request.getParameter("day_" + i + "_close_" + slotIndex);

                    if (openTimeStr == null || closeTimeStr == null || openTimeStr.isEmpty() || closeTimeStr.isEmpty()) {
                        break;
                    }

                    try {
                        OperatingHour oh = new OperatingHour();
                        oh.setRestaurantId(newRestaurantId);
                        oh.setDayOfWeek(i);
                        oh.setOpeningTime(LocalTime.parse(openTimeStr));
                        oh.setClosingTime(LocalTime.parse(closeTimeStr));
                        hours.add(oh);
                    } catch (DateTimeParseException e) {
                        System.err.println("시간 파싱 오류: " + openTimeStr + ", " + closeTimeStr);
                    }
                    slotIndex++;
                }
            }
            
            if (!hours.isEmpty()) {
                operatingHourService.addOperatingHours(sqlSession, hours);
            }

            sqlSession.commit();
            response.sendRedirect(request.getContextPath() + "/business/restaurants");

        } catch(Exception e) {
            e.printStackTrace();
            if (sqlSession != null) sqlSession.rollback();
            
            request.setAttribute("errorMessage", "가게 등록 중 오류가 발생했습니다. 다시 시도해주세요.");
            request.getRequestDispatcher("/WEB-INF/views/add-restaurant.jsp").forward(request, response);
        } finally {
            if(sqlSession != null) sqlSession.close();
        }
    }
}