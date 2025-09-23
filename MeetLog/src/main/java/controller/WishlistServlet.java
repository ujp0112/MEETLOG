package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.User;
import model.UserStorage;
import model.UserStorageItem;
import service.UserStorageService;

@WebServlet("/wishlist/*")
public class WishlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserStorageService userStorageService = new UserStorageService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // 찜 목록 메인 페이지 (저장소 목록)
                showStorageList(request, response, user.getId());
            } else if (pathInfo.startsWith("/storage/")) {
                // 특정 저장소 상세 보기
                String storageIdStr = pathInfo.substring("/storage/".length());
                int storageId = Integer.parseInt(storageIdStr);
                showStorageDetail(request, response, user.getId(), storageId);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "찜 목록을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "createStorage":
                    createStorage(request, response, user.getId());
                    break;
                case "updateStorage":
                    updateStorage(request, response, user.getId());
                    break;
                case "deleteStorage":
                    deleteStorage(request, response, user.getId());
                    break;
                case "addItem":
                    addItem(request, response, user.getId());
                    break;
                case "removeItem":
                    removeItem(request, response, user.getId());
                    break;
                case "toggleWishlist":
                    toggleWishlist(request, response, user.getId());
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void showStorageList(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        List<UserStorage> storages = userStorageService.getUserStorages(userId);
        
        request.setAttribute("storages", storages);
        request.getRequestDispatcher("/WEB-INF/views/wishlist.jsp").forward(request, response);
    }
    
    private void showStorageDetail(HttpServletRequest request, HttpServletResponse response, int userId, int storageId) 
            throws ServletException, IOException {
        UserStorage storage = userStorageService.getStorageById(storageId);
        
        if (storage == null || storage.getUserId() != userId) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        List<UserStorageItem> items = userStorageService.getStorageItems(storageId);
        
        request.setAttribute("storage", storage);
        request.setAttribute("items", items);
        request.getRequestDispatcher("/WEB-INF/views/wishlist-detail.jsp").forward(request, response);
    }
    
    private void createStorage(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws IOException {
        String name = request.getParameter("name");
        String colorClass = request.getParameter("colorClass");
        
        if (name == null || name.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "저장소 이름을 입력해주세요.");
            return;
        }
        
        UserStorage storage = new UserStorage(userId, name.trim(), colorClass);
        
        if (userStorageService.createStorage(storage)) {
            response.sendRedirect(request.getContextPath() + "/wishlist");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "저장소 생성에 실패했습니다.");
        }
    }
    
    private void updateStorage(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws IOException {
        String storageIdStr = request.getParameter("storageId");
        String name = request.getParameter("name");
        String colorClass = request.getParameter("colorClass");
        
        if (storageIdStr == null || name == null || name.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        int storageId = Integer.parseInt(storageIdStr);
        UserStorage storage = userStorageService.getStorageById(storageId);
        
        if (storage == null || storage.getUserId() != userId) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        storage.setName(name.trim());
        storage.setColorClass(colorClass);
        
        if (userStorageService.updateStorage(storage)) {
            response.sendRedirect(request.getContextPath() + "/wishlist");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void deleteStorage(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws IOException {
        String storageIdStr = request.getParameter("storageId");
        
        if (storageIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        int storageId = Integer.parseInt(storageIdStr);
        UserStorage storage = userStorageService.getStorageById(storageId);
        
        if (storage == null || storage.getUserId() != userId) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        if (userStorageService.deleteStorage(storageId)) {
            response.sendRedirect(request.getContextPath() + "/wishlist");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void addItem(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws IOException {
        String storageIdStr = request.getParameter("storageId");
        String itemType = request.getParameter("itemType");
        String contentIdStr = request.getParameter("contentId");
        
        if (storageIdStr == null || itemType == null || contentIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        int storageId = Integer.parseInt(storageIdStr);
        int contentId = Integer.parseInt(contentIdStr);
        
        UserStorage storage = userStorageService.getStorageById(storageId);
        
        if (storage == null || storage.getUserId() != userId) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        if (userStorageService.addToStorage(storageId, itemType, contentId)) {
            response.getWriter().write("{\"success\": true}");
        } else {
            response.getWriter().write("{\"success\": false}");
        }
    }
    
    private void removeItem(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws IOException {
        String storageIdStr = request.getParameter("storageId");
        String itemType = request.getParameter("itemType");
        String contentIdStr = request.getParameter("contentId");
        
        if (storageIdStr == null || itemType == null || contentIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        int storageId = Integer.parseInt(storageIdStr);
        int contentId = Integer.parseInt(contentIdStr);
        
        UserStorage storage = userStorageService.getStorageById(storageId);
        
        if (storage == null || storage.getUserId() != userId) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        if (userStorageService.removeFromStorage(storageId, itemType, contentId)) {
            response.getWriter().write("{\"success\": true}");
        } else {
            response.getWriter().write("{\"success\": false}");
        }
    }
    
    private void toggleWishlist(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws IOException {
        String itemType = request.getParameter("itemType");
        String contentIdStr = request.getParameter("contentId");
        
        if (itemType == null || contentIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        int contentId = Integer.parseInt(contentIdStr);
        
        UserStorage defaultStorage = userStorageService.getOrCreateDefaultStorage(userId);
        boolean isInWishlist = userStorageService.isItemInStorage(defaultStorage.getStorageId(), itemType, contentId);
        
        boolean success;
        if (isInWishlist) {
            success = userStorageService.removeFromWishlist(userId, itemType, contentId);
        } else {
            success = userStorageService.addToWishlist(userId, itemType, contentId);
        }
        
        response.setContentType("application/json");
        response.getWriter().write("{\"success\": " + success + ", \"isInWishlist\": " + !isInWishlist + "}");
    }
}
