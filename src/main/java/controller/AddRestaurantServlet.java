package controller;

import java.io.File;
import java.io.IOException;
<<<<<<< HEAD
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

=======
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
>>>>>>> 0964c5034709fc22f4307bc36d412f3659e9c08d
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
<<<<<<< HEAD

import org.apache.ibatis.session.SqlSession;

import model.OperatingHour;
=======
>>>>>>> 0964c5034709fc22f4307bc36d412f3659e9c08d
import model.Restaurant;
import model.User;
import service.OperatingHourService;
import service.RestaurantService;
import util.MyBatisSqlSessionFactory;

<<<<<<< HEAD
@WebServlet("/business/restaurants/add")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 100   // 100 MB
=======
@WebServlet("/restaurant/add")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
>>>>>>> 0964c5034709fc22f4307bc36d412f3659e9c08d
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

<<<<<<< HEAD
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
=======
        // 폼에서 받은 데이터로 Restaurant 객체 생성
        Restaurant restaurant = new Restaurant();
        restaurant.setName(request.getParameter("name"));
        restaurant.setCategory(request.getParameter("category"));
        restaurant.setLocation(request.getParameter("location"));
        restaurant.setAddress(request.getParameter("address"));
        restaurant.setPhone(request.getParameter("phone"));
        restaurant.setHours(request.getParameter("hours"));
        restaurant.setDescription(request.getParameter("description"));
        // owner_id를 현재 로그인한 사용자의 id로 설정
        restaurant.setOwnerId(user.getId());
        
        // 이미지 파일 처리
        try {
            Part imagePart = request.getPart("image");
            if (imagePart != null && imagePart.getSize() > 0) {
                String fileName = getFileName(imagePart);
                if (fileName != null && !fileName.isEmpty()) {
                    // 이미지 저장 경로 설정
                    String uploadPath = getServletContext().getRealPath("/WEB-INF/img/restaurants");
                    Path uploadDir = Paths.get(uploadPath);
                    
                    // 디렉토리가 없으면 생성
                    if (!Files.exists(uploadDir)) {
                        Files.createDirectories(uploadDir);
                    }
                    
                    // 고유한 파일명 생성
                    String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                    Path filePath = uploadDir.resolve(uniqueFileName);
                    
                    // 파일 저장
                    try (InputStream fileContent = imagePart.getInputStream()) {
                        Files.copy(fileContent, filePath, StandardCopyOption.REPLACE_EXISTING);
                    }
                    
                    // 데이터베이스에 저장할 경로 설정
                    restaurant.setImagePath("/WEB-INF/img/restaurants/" + uniqueFileName);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "이미지 업로드 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/add-restaurant.jsp").forward(request, response);
            return;
        }

        // 서비스를 통해 데이터베이스에 저장
        if (restaurantService.addRestaurant(restaurant)) {
            // ▼▼▼ 성공 시 '내 가게 목록'으로 이동하는 부분 ▼▼▼
            response.sendRedirect(request.getContextPath() + "/restaurant/my");
        } else {
            // 실패 시 에러 메시지와 함께 다시 등록 폼으로
            request.setAttribute("errorMessage", "가게 등록 중 오류가 발생했습니다.");
>>>>>>> 0964c5034709fc22f4307bc36d412f3659e9c08d
            request.getRequestDispatcher("/WEB-INF/views/add-restaurant.jsp").forward(request, response);
        } finally {
            if(sqlSession != null) sqlSession.close();
        }
    }
    
    /**
     * Part에서 파일명을 추출하는 헬퍼 메서드
     */
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition != null) {
            String[] tokens = contentDisposition.split(";");
            for (String token : tokens) {
                if (token.trim().startsWith("filename")) {
                    return token.substring(token.indexOf("=") + 2, token.length() - 1);
                }
            }
        }
        return null;
    }
}