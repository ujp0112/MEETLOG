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
                List<UserCollection> collections = userService.getUserCollections(user.getId());

                request.setAttribute("wishlistRestaurants", wishlistRestaurants);
                request.setAttribute("collections", collections);
                request.getRequestDispatcher("/WEB-INF/views/wishlist.jsp").forward(request, response);

            } else if (pathInfo.startsWith("/detail/")) {
                // 위시리스트 상세 페이지
                String collectionIdStr = pathInfo.substring("/detail/".length());
                try {
                    int collectionId = Integer.parseInt(collectionIdStr);
                    UserCollection collection = userService.getUserCollection(collectionId, user.getId());

                    if (collection != null) {
                        List<Restaurant> collectionRestaurants = userService.getCollectionRestaurants(collectionId);

                        request.setAttribute("collection", collection);
                        request.setAttribute("collectionRestaurants", collectionRestaurants);
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
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
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
                // 레스토랑을 위시리스트에 추가
                int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
                String collectionIdStr = request.getParameter("collectionId");

                if (collectionIdStr != null && !collectionIdStr.isEmpty()) {
                    int collectionId = Integer.parseInt(collectionIdStr);
                    userService.addToCollection(user.getId(), restaurantId, collectionId);
                } else {
                    userService.addToWishlist(user.getId(), restaurantId);
                }

                response.sendRedirect(request.getContextPath() + "/wishlist");

            } else if ("remove".equals(action)) {
                // 레스토랑을 위시리스트에서 제거
                int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
                userService.removeFromWishlist(user.getId(), restaurantId);
                response.sendRedirect(request.getContextPath() + "/wishlist");

            } else if ("createCollection".equals(action)) {
                // 새 컬렉션 생성
                String collectionName = request.getParameter("collectionName");
                String description = request.getParameter("description");

                userService.createCollection(user.getId(), collectionName, description);
                response.sendRedirect(request.getContextPath() + "/wishlist");

            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "작업을 처리하는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
}