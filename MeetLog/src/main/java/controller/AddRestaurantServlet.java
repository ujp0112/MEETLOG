package controller;

import java.io.File;
import java.io.IOException;
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

import model.OperatingHour;
import model.Restaurant;
import model.User;
import service.OperatingHourService;
import service.RestaurantService;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;

@WebServlet("/business/restaurants/add")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class AddRestaurantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final RestaurantService restaurantService = new RestaurantService();
    private final OperatingHourService operatingHourService = new OperatingHourService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 세션 확인
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"BUSINESS".equals(user.getUserType())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "접근 권한이 없습니다.");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/add-restaurant.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 세션 확인
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"BUSINESS".equals(user.getUserType())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "접근 권한이 없습니다.");
            return;
        }

        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisSqlSessionFactory.getSqlSession(false);

            // 파일 업로드 처리
            String savedFilePath = null;
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = filePart.getSubmittedFileName();
                if (fileName != null && !fileName.isEmpty()) {
                    // 고유한 파일명 생성
                    String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                    String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
                    
                    // 업로드 디렉토리 생성
                    String uploadPath = getServletContext().getRealPath("/uploads/restaurants");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    
                    // 파일 저장
                    String filePath = uploadPath + File.separator + uniqueFileName;
                    filePart.write(filePath);
                    savedFilePath = "uploads/restaurants/" + uniqueFileName;
                }
            }

            // Restaurant 객체 생성
            Restaurant restaurant = new Restaurant();
            restaurant.setName(request.getParameter("name"));
            restaurant.setCategory(request.getParameter("category"));
            restaurant.setLocation(request.getParameter("location"));
            restaurant.setAddress(request.getParameter("address"));
            restaurant.setPhone(request.getParameter("phone"));
            restaurant.setDescription(request.getParameter("description"));
            restaurant.setOwnerId(user.getId());
            if (savedFilePath != null) {
                restaurant.setImage(savedFilePath);
                restaurant.setImageUrl(savedFilePath);
            }

            // 음식점 저장
            int restaurantId = restaurantService.addRestaurant(sqlSession, restaurant);

            // 운영시간 처리
            String[] days = {"monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"};
            List<OperatingHour> hours = new ArrayList<>();
            
            for (String day : days) {
                String openTime = request.getParameter(day + "_open");
                String closeTime = request.getParameter(day + "_close");
                String isClosed = request.getParameter(day + "_closed");
                
                if (isClosed == null && openTime != null && !openTime.isEmpty() && closeTime != null && !closeTime.isEmpty()) {
                    OperatingHour hour = new OperatingHour();
                    hour.setRestaurantId(restaurantId);
                    hour.setDayOfWeek(getDayOfWeekNumber(day));
                    hour.setOpeningTime(java.time.LocalTime.parse(openTime));
                    hour.setClosingTime(java.time.LocalTime.parse(closeTime));
                    hours.add(hour);
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
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }
    
    private int getDayOfWeekNumber(String day) {
        switch (day) {
            case "monday": return 1;
            case "tuesday": return 2;
            case "wednesday": return 3;
            case "thursday": return 4;
            case "friday": return 5;
            case "saturday": return 6;
            case "sunday": return 7;
            default: return 1;
        }
    }
}