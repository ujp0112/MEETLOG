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
import util.AppConfig;

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
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=sessionExpired");
            return; 
        }
        User owner = (User) session.getAttribute("user");

        Restaurant restaurant = new Restaurant();
        List<OperatingHour> hoursList = new ArrayList<>();
        Map<String, String> formFields = new HashMap<>();
        String imagePath = null;

        if (ServletFileUpload.isMultipartContent(request)) {
            DiskFileItemFactory factory = new DiskFileItemFactory();
            factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setHeaderEncoding("UTF-8");

            try {
                List<FileItem> formItems = upload.parseRequest(request);

                if (formItems != null && !formItems.isEmpty()) {
                    for (FileItem item : formItems) {
                        if (item.isFormField()) {
                            formFields.put(item.getFieldName(), item.getString("UTF-8"));
                        } else {
                            String fileName = new File(item.getName()).getName();
                            if (fileName != null && !fileName.isEmpty()) {
                                String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
                                String uploadPath = AppConfig.getUploadPath();
                                File uploadDir = new File(uploadPath);
                                if (!uploadDir.exists()) uploadDir.mkdirs();
                                File storeFile = new File(uploadPath + File.separator + uniqueFileName);
                                item.write(storeFile);
                                imagePath = "images/" + uniqueFileName;
                            }
                        }
                    }
                }

                restaurant.setName(formFields.get("name"));
                restaurant.setAddress(formFields.get("address"));
                restaurant.setPhone(formFields.get("tel"));
                restaurant.setDescription(formFields.get("description"));
                restaurant.setCategory(formFields.get("category"));
                restaurant.setOwnerId(owner.getId());
                if (imagePath != null) {
                    restaurant.setImageUrl(imagePath);
                }

                // Operating hours processing
                for (int i = 0; i < 7; i++) { // 7 days a week
                    String day = formFields.get("days[" + i + "]");
                    String openTimeStr = formFields.get("open_times[" + i + "]");
                    String closeTimeStr = formFields.get("close_times[" + i + "]");

                    if (day != null && openTimeStr != null && !openTimeStr.isEmpty() && closeTimeStr != null && !closeTimeStr.isEmpty()) {
                        OperatingHour oh = new OperatingHour();
                        oh.setDayOfWeek(i + 1); // Assuming days[0] is Monday (1)
                        try {
                            oh.setOpeningTime(LocalTime.parse(openTimeStr));
                            oh.setClosingTime(LocalTime.parse(closeTimeStr));
                            hoursList.add(oh);
                        } catch (DateTimeParseException e) {
                            e.printStackTrace();
                        }
                    }
                }

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "요청 처리 중 오류가 발생했습니다: " + e.getMessage());
                request.getRequestDispatcher("/WEB-INF/views/add-restaurant.jsp").forward(request, response);
                return;
            }
        }

        try {
            boolean success = restaurantService.createRestaurant(restaurant, hoursList);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/business/restaurants?status=add_success");
            } else {
                throw new Exception("가게 및 영업시간 등록에 실패했습니다.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('오류가 발생했습니다: " + e.getMessage().replace("'", "\\'") + "'); history.back();</script>");
        }
    }
}