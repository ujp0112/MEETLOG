package controller;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import model.Menu;
import model.User;
import service.MenuService;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class AddMenuServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MenuService menuService = new MenuService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // URL에서 음식점 ID 추출
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.length() <= 1) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "음식점 ID가 필요합니다.");
            return;
        }

        try {
            int restaurantId = Integer.parseInt(pathInfo.substring(1).split("/")[0]);
            
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

            request.setAttribute("restaurantId", restaurantId);
            request.getRequestDispatcher("/WEB-INF/views/add-menu.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "유효하지 않은 음식점 ID입니다.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // URL에서 음식점 ID 추출
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.length() <= 1) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "음식점 ID가 필요합니다.");
            return;
        }

        try {
            int restaurantId = Integer.parseInt(pathInfo.substring(1).split("/")[0]);
            
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
                    String uploadPath = getServletContext().getRealPath("/uploads/menus");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    
                    // 파일 저장
                    String filePath = uploadPath + File.separator + uniqueFileName;
                    filePart.write(filePath);
                    savedFilePath = "uploads/menus/" + uniqueFileName;
                }
            }

            // 메뉴 정보 설정
            Menu menu = new Menu();
            menu.setRestaurantId(restaurantId);
            menu.setName(request.getParameter("name"));
            menu.setDescription(request.getParameter("description"));
            menu.setPrice(request.getParameter("price"));
            menu.setPopular(Boolean.parseBoolean(request.getParameter("popular")));
            if (savedFilePath != null) {
                menu.setImage(savedFilePath);
            }
            
            // 메뉴 저장
            boolean success = menuService.addMenu(menu);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/business/restaurants/" + restaurantId + "/menus");
            } else {
                request.setAttribute("error", "메뉴 추가에 실패했습니다.");
                request.getRequestDispatcher("/WEB-INF/views/add-menu.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "유효하지 않은 음식점 ID입니다.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "메뉴 추가 중 오류가 발생했습니다: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/add-menu.jsp").forward(request, response);
        }
    }
}