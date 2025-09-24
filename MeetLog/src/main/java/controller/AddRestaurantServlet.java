package controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import model.OperatingHour;
import model.Restaurant;
import model.User;
import service.RestaurantService;
import util.AppConfig;

public class AddRestaurantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final RestaurantService restaurantService = new RestaurantService();

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

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/login?error=sessionExpired");
                return;
            }
            User owner = (User) session.getAttribute("user");

            if (!ServletFileUpload.isMultipartContent(request)) {
                throw new Exception("폼 enctype이 multipart/form-data가 아닙니다.");
            }

            // --- 변수 초기화 ---
            Map<String, String> formFields = new HashMap<>();
            String mainImageFileName = null;
            List<String> additionalImageFileNames = new ArrayList<>();

            // --- 파일 및 폼 데이터 파싱 ---
            DiskFileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setHeaderEncoding("UTF-8");

            List<FileItem> formItems = upload.parseRequest(request);
            boolean isFirstImage = true;

            for (FileItem item : formItems) {
                if (item.isFormField()) {
                    formFields.put(item.getFieldName(), item.getString("UTF-8"));
                } else if ("restaurantImage".equals(item.getFieldName()) && item.getSize() > 0) {
                    String originalFileName = new File(item.getName()).getName();
                    String uniqueFileName = UUID.randomUUID().toString() + "_" + originalFileName;

                    String uploadPath = AppConfig.getUploadPath();
                    if (uploadPath == null || uploadPath.isEmpty()) {
                        throw new Exception("업로드 경로(upload.path)가 config.properties에 설정되지 않았습니다.");
                    }
                    File storeFile = new File(uploadPath, uniqueFileName);
                    item.write(storeFile);

                    if (isFirstImage) {
                        mainImageFileName = uniqueFileName;
                        isFirstImage = false;
                    } else {
                        additionalImageFileNames.add(uniqueFileName);
                    }
                }
            }

            // --- Restaurant 객체 채우기 ---
            Restaurant restaurant = new Restaurant();
            restaurant.setOwnerId(owner.getId());
            restaurant.setName(formFields.get("name"));
            restaurant.setCategory(formFields.get("category"));
            restaurant.setLocation(formFields.get("location"));
            restaurant.setPhone(formFields.get("phone"));
            restaurant.setDescription(formFields.get("description"));

            String baseAddress = formFields.getOrDefault("address", "");
            String detailAddress = formFields.getOrDefault("detail_address", "");
            restaurant.setAddress((baseAddress + " " + detailAddress).trim());
            restaurant.setJibunAddress(formFields.get("jibun_address"));

            restaurant.setParking("true".equals(formFields.get("parking")));
            restaurant.setImage(mainImageFileName);

            try {
                restaurant.setLatitude(Double.parseDouble(formFields.get("latitude")));
                restaurant.setLongitude(Double.parseDouble(formFields.get("longitude")));
            } catch (NumberFormatException | NullPointerException e) {
                restaurant.setLatitude(0.0);
                restaurant.setLongitude(0.0);
            }

            // --- OperatingHour 리스트 채우기 ---
            List<OperatingHour> hoursList = new ArrayList<>();
            for (int i = 1; i <= 7; i++) { // 1:월요일, ..., 7:일요일
                if (formFields.get("is_closed_" + i) != null) continue;

                int slotIndex = 1;
                while (true) {
                    String openTimeStr = formFields.get("day_" + i + "_open_" + slotIndex);
                    String closeTimeStr = formFields.get("day_" + i + "_close_" + slotIndex);

                    if (openTimeStr == null || closeTimeStr == null || openTimeStr.isEmpty() || closeTimeStr.isEmpty())
                        break;

                    OperatingHour oh = new OperatingHour();
                    oh.setDayOfWeek(i);
                    oh.setOpeningTime(LocalTime.parse(openTimeStr));
                    oh.setClosingTime(LocalTime.parse(closeTimeStr));
                    hoursList.add(oh);
                    slotIndex++;
                }
            }

            // --- 서비스 호출 ---
            // 참고: RestaurantService의 addRestaurant 메서드가 추가 이미지 목록을 처리하도록 수정되어야 합니다.
            // boolean success = restaurantService.addRestaurant(restaurant, additionalImageFileNames, hoursList);
            boolean success = restaurantService.addRestaurant(restaurant, additionalImageFileNames, hoursList);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/business/restaurants");
            } else {
                throw new Exception("가게 등록에 실패했습니다. 서비스 로직을 확인해주세요.");
            }

        } catch (Exception e) {
            // 오류 발생 시 사용자에게 메시지 표시
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>");
            out.println("alert('오류가 발생했습니다: " + e.getMessage().replace("'", "\\'").replace("\n", "\\n") + "');");
            out.println("history.back();");
            out.println("</script>");
            e.printStackTrace();
        }
    }
}