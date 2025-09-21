package controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.ibatis.session.SqlSession;
import model.OperatingHour;
import model.Restaurant;
import model.User;
import service.OperatingHourService;
import service.RestaurantService;
import util.MyBatisSqlSessionFactory;

public class AddRestaurantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final RestaurantService restaurantService = new RestaurantService();
    private final OperatingHourService operatingHourService = new OperatingHourService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=auth");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/views/add-restaurant.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        SqlSession sqlSession = null;
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/login?error=sessionExpired");
                return; 
            }
            User owner = (User) session.getAttribute("user");

            sqlSession = MyBatisSqlSessionFactory.getSqlSession(false);

            if (!ServletFileUpload.isMultipartContent(request)) {
                throw new Exception("폼 enctype이 multipart/form-data가 아닙니다.");
            }

            DiskFileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setHeaderEncoding("UTF-8");

            Map<String, String> formFields = new HashMap<>();
            FileItem imageFileItem = null;

            List<FileItem> formItems = upload.parseRequest(request);

            for (FileItem item : formItems) {
                if (item.isFormField()) {
                    formFields.put(item.getFieldName(), item.getString("UTF-8"));
                } else {
                    if ("restaurantImage".equals(item.getFieldName()) && item.getSize() > 0) {
                        imageFileItem = item;
                    }
                }
            }

            Restaurant restaurant = new Restaurant();
            restaurant.setOwnerId(owner.getId());
            restaurant.setName(formFields.get("name"));
            restaurant.setCategory(formFields.get("category"));
            restaurant.setLocation(formFields.get("location"));
            
            String baseAddress = formFields.getOrDefault("address", "");
            String detailAddress = formFields.getOrDefault("detail_address", "");
            restaurant.setAddress((baseAddress + " " + detailAddress).trim());
            
            restaurant.setJibunAddress(formFields.get("jibun_address"));
            restaurant.setPhone(formFields.get("phone"));
            restaurant.setDescription(formFields.get("description"));
            restaurant.setHours(formFields.get("hours"));
            restaurant.setParking(formFields.get("parking") != null && formFields.get("parking").equals("true"));

            try {
                restaurant.setLatitude(Double.parseDouble(formFields.get("latitude")));
                restaurant.setLongitude(Double.parseDouble(formFields.get("longitude")));
            } catch (Exception e) {
                restaurant.setLatitude(0.0);
                restaurant.setLongitude(0.0);
            }

            if (imageFileItem != null) {
                String uploadPath = getServletContext().getRealPath("/uploads");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                String fileName = UUID.randomUUID().toString() + "_" + imageFileItem.getName();
                File storeFile = new File(uploadPath, fileName);
                imageFileItem.write(storeFile);
                restaurant.setImage("uploads/" + fileName);
            }
            
            // 이 서비스 메소드는 내부적으로 DAO의 'insert'를 호출합니다.
            restaurantService.addRestaurant(sqlSession, restaurant);
            
            int newRestaurantId = restaurant.getId();
            
            if (newRestaurantId == 0) {
                throw new Exception("가게 ID를 받아오지 못했습니다. RestaurantMapper.xml의 <insert> 태그에 useGeneratedKeys=\"true\"와 keyProperty=\"id\" 속성이 올바르게 설정되었는지 확인하세요.");
            }

            List<OperatingHour> hoursList = new ArrayList<>();
            for (int i = 1; i <= 7; i++) {
                if (formFields.get("is_closed_" + i) != null) continue;
                
                int slotIndex = 1;
                while (true) {
                    String openTimeStr = formFields.get("day_" + i + "_open_" + slotIndex);
                    String closeTimeStr = formFields.get("day_" + i + "_close_" + slotIndex);
                    if (openTimeStr == null || closeTimeStr == null || openTimeStr.isEmpty() || closeTimeStr.isEmpty()) break;
                    
                    OperatingHour oh = new OperatingHour();
                    oh.setRestaurantId(newRestaurantId);
                    oh.setDayOfWeek(i);
                    oh.setOpeningTime(LocalTime.parse(openTimeStr));
                    oh.setClosingTime(LocalTime.parse(closeTimeStr));
                    hoursList.add(oh);
                    slotIndex++;
                }
            }
            
            if (!hoursList.isEmpty()) {
                operatingHourService.addOperatingHours(sqlSession, hoursList);
            }
            
            sqlSession.commit();
            response.sendRedirect(request.getContextPath() + "/business/restaurants");

        } catch (Exception e) {
            if (sqlSession != null) sqlSession.rollback();
            response.setContentType("text/plain; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("오류가 발생했습니다:");
            e.printStackTrace(out);
        } finally {
            if (sqlSession != null) sqlSession.close();
        }
    }
}