package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.User;
import model.Restaurant;
import model.UserCollection;
import model.UserStorage;
import service.UserService;

public class WishlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirectUrl=" + request.getRequestURI());
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // 위시리스트 메인 페이지
                List<Restaurant> wishlistRestaurants = userService.getWishlistRestaurants(user.getId());
                List<UserStorage> storages = userService.getUserStorages(user.getId());

                request.setAttribute("wishlistRestaurants", wishlistRestaurants);
                request.setAttribute("storages", storages);
                request.getRequestDispatcher("/WEB-INF/views/wishlist.jsp").forward(request, response);

            } else if (pathInfo.startsWith("/storage/")) {
                // 저장소 상세 페이지
                String storageIdStr = pathInfo.substring("/storage/".length());
                try {
                    int storageId = Integer.parseInt(storageIdStr);
                    UserStorage storage = userService.getUserStorage(storageId, user.getId());

                    if (storage != null) {
                        List<Restaurant> storageRestaurants = userService.getStorageRestaurants(storageId);

                        request.setAttribute("storage", storage);
                        request.setAttribute("storageRestaurants", storageRestaurants);
                        request.getRequestDispatcher("/WEB-INF/views/wishlist-detail.jsp").forward(request, response);
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    }
                } catch (NumberFormatException e) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                }

            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "위시리스트를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                // 레스토랑을 저장소에 추가
                int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
                String storageIdStr = request.getParameter("storageId");

                if (storageIdStr != null && !storageIdStr.isEmpty()) {
                    int storageId = Integer.parseInt(storageIdStr);
                    userService.addToStorage(user.getId(), restaurantId, storageId);
                } else {
                    userService.addToWishlist(user.getId(), restaurantId);
                }

                response.sendRedirect(request.getContextPath() + "/wishlist");

            } else if ("remove".equals(action)) {
                // 레스토랑을 위시리스트에서 제거
                int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
                userService.removeFromWishlist(user.getId(), restaurantId);
                response.sendRedirect(request.getContextPath() + "/wishlist");

            } else if ("createCollection".equals(action) || "createStorage".equals(action)) {
                // 새 저장소 생성
                String storageName = request.getParameter("name");
                if (storageName == null) {
                    storageName = request.getParameter("collectionName"); // 이전 호환성
                }
                String colorClass = request.getParameter("colorClass");

                userService.createStorage(user.getId(), storageName, colorClass);
                response.sendRedirect(request.getContextPath() + "/wishlist");

            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "작업을 처리하는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
}