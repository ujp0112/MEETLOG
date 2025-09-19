package controller;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import model.Restaurant;
import model.User;
import service.RestaurantService;

@WebServlet("/restaurant/add")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class AddRestaurantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RestaurantService restaurantService = new RestaurantService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 가게 등록 폼 페이지를 보여줍니다.
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
            request.getRequestDispatcher("/WEB-INF/views/add-restaurant.jsp").forward(request, response);
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