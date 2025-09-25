package controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
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

@WebServlet("/business/restaurants/update")
public class UpdateRestaurantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final RestaurantService restaurantService = new RestaurantService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // --- [수정] ---
        // JSP에서 AJAX로 요청하므로, 오류 발생 시 스크립트 대신 JSON으로 응답합니다.
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User owner = (session != null) ? (User) session.getAttribute("user") : null;

        if (owner == null || !"BUSINESS".equals(owner.getUserType())) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("{\"success\": false, \"message\": \"세션이 만료되었거나 권한이 없습니다.\"}");
            return;
        }

        try {
            if (!ServletFileUpload.isMultipartContent(request)) {
                throw new Exception("폼 enctype이 multipart/form-data가 아닙니다.");
            }

            Map<String, String> formFields = new HashMap<>();
            List<FileItem> imageFileItems = new ArrayList<>();

            DiskFileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setHeaderEncoding("UTF-8");
            List<FileItem> formItems = upload.parseRequest(request);
            boolean isFirstImage = true;

            for (FileItem item : formItems) {
                if (item.isFormField()) {
                    formFields.put(item.getFieldName(), item.getString("UTF-8"));
                } else if ("restaurantImage".equals(item.getFieldName()) && item.getSize() > 0) {
                    imageFileItems.add(item);
                }
            }

            // --- Restaurant 객체 채우기 ---
            Restaurant restaurant = new Restaurant();
            int restaurantId = Integer.parseInt(formFields.get("restaurantId"));
            restaurant.setId(restaurantId);
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
//            restaurant.setImage(mainImageFileName);
            restaurant.setBreakTimeText(formFields.get("break_time_text"));
            
         // --- [수정] 최종 이미지 목록 결정 로직 ---
            // 1. 새로 업로드된 이미지 파일명 목록 생성
            List<String> newImageFileNames = new ArrayList<>();
            String uploadPath = AppConfig.getUploadPath();
            for (FileItem item : imageFileItems) {
                String originalFileName = new File(item.getName()).getName();
                String uniqueFileName = UUID.randomUUID().toString() + "_" + originalFileName;
                File storeFile = new File(uploadPath, uniqueFileName);
                item.write(storeFile);
                newImageFileNames.add(uniqueFileName);
            }

            // 2. 삭제되지 않고 남아있는 기존 이미지 목록 가져오기
            String[] existingImages = formFields.getOrDefault("existingImages", "").split(",");
            List<String> remainingImages = new ArrayList<>();
            // split 결과로 ""가 들어가는 경우를 방지
            if (existingImages.length > 0 && !existingImages[0].isEmpty()) {
                remainingImages.addAll(Arrays.asList(existingImages));
            }

            // 3. 최종 대표/추가 이미지 결정
            String finalMainImage = null;
            if (!newImageFileNames.isEmpty()) {
                finalMainImage = newImageFileNames.remove(0);
            } else if (!remainingImages.isEmpty()) {
                finalMainImage = remainingImages.remove(0);
            }
            restaurant.setImage(finalMainImage);

            List<String> finalAdditionalImages = new ArrayList<>(newImageFileNames);
            finalAdditionalImages.addAll(remainingImages);
            
            String[] filesToDeleteArr = formFields.getOrDefault("filesToDelete", "").split(",");
            List<String> filesToDelete = new ArrayList<>();
            if (filesToDeleteArr.length > 0 && !filesToDeleteArr[0].isEmpty()) {
                filesToDelete.addAll(Arrays.asList(filesToDeleteArr));
            }
            
            List<String> operatingDaysList = new ArrayList<>();
            List<String> operatingTimesList = new ArrayList<>();
            String[] dayNames = {"월", "화", "수", "목", "금", "토", "일"};
            
            for (int i = 1; i <= 7; i++) {
                if (formFields.get("main_is_closed_" + i) == null) {
                    // select 값을 변환한 hidden input 값을 가져옴
                    String openTime = formFields.get("main_day_" + i + "_open_1");
                    String closeTime = formFields.get("main_day_" + i + "_close_1");
                    
                    if (openTime != null && !openTime.isEmpty() && closeTime != null && !closeTime.isEmpty()) {
                        operatingDaysList.add(dayNames[i-1]);
                        operatingTimesList.add(openTime + "~" + closeTime);
                    }
                }
            }
            restaurant.setOperatingDays(String.join(",", operatingDaysList));
            restaurant.setOperatingTimesText(String.join(",", operatingTimesList));

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
            boolean success = restaurantService.updateRestaurant(restaurant, finalAdditionalImages, filesToDelete, hoursList);

            if (success) {
            	response.setStatus(HttpServletResponse.SC_OK);
            	response.getWriter().write("{\"success\": true}");
            } else {
            	response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "가게 등록에 실패했습니다.");
//                throw new Exception("가게 등록에 실패했습니다. 서비스 로직을 확인해주세요.");
            }

        } catch (Exception e) {
            // 오류 발생 시 사용자에게 메시지 표시
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>");
            out.println("alert('오류가 발생했습니다: " + e.getMessage().replace("'", "\\'").replace("\n", "\\n") + "');");
            out.println("history.back();");
            out.println("</script>");
            response.getWriter().write("{\"success\": false, \"message\": \"서버 오류가 발생했습니다: " + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }
}