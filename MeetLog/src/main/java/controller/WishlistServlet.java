package controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.User;
import model.Restaurant;
import model.UserStorage;
import service.UserService;
import com.fasterxml.jackson.databind.ObjectMapper;

public class WishlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserService userService = new UserService();
    private final ObjectMapper objectMapper = new ObjectMapper();

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
                        // 모든 타입의 아이템들을 DTO로 가져옴 (코스, 칼럼, 레스토랑)
                        List<model.StorageItemDto> storageItems = userService.getStorageItemsAsDto(storageId);

                        request.setAttribute("storage", storage);
                        request.setAttribute("storageItems", storageItems);
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
        if (action != null) {
            action = action.trim();
        }
        System.out.println("[WishlistServlet] action=" + action);
        boolean isAjax = isAjaxRequest(request);

        try {
            if ("add".equalsIgnoreCase(action)) {
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

            } else if ("remove".equalsIgnoreCase(action)) {
                // 레스토랑을 위시리스트에서 제거
                int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
                userService.removeFromWishlist(user.getId(), restaurantId);
                response.sendRedirect(request.getContextPath() + "/wishlist");

            } else if ("createCollection".equalsIgnoreCase(action) || "createStorage".equalsIgnoreCase(action)) {
                // 새 저장소 생성
                String storageName = request.getParameter("name");
                if (storageName == null) {
                    storageName = request.getParameter("collectionName"); // 이전 호환성
                }
                String colorClass = request.getParameter("colorClass");
                UserStorage storage = userService.createStorageAndReturn(user.getId(), storageName, colorClass);

                if (isAjax) {
                    Map<String, Object> body = new HashMap<>();
                    if (storage != null) {
                        body.put("success", true);
                        body.put("message", "폴더가 생성되었습니다.");
                        body.put("storage", toStorageMap(storage));
                        writeJsonResponse(response, HttpServletResponse.SC_OK, body);
                    } else {
                        body.put("success", false);
                        body.put("message", "폴더 생성에 실패했습니다.");
                        writeJsonResponse(response, HttpServletResponse.SC_BAD_REQUEST, body);
                    }
                    return;
                }

                if (storage != null) {
                    response.sendRedirect(request.getContextPath() + "/wishlist");
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "폴더 생성에 실패했습니다.");
                }

            } else if ("updateStorage".equalsIgnoreCase(action)) {
                String storageIdStr = request.getParameter("storageId");
                String storageName = request.getParameter("name");
                String colorClass = request.getParameter("colorClass");

                int storageId = Integer.parseInt(storageIdStr);
                UserStorage updatedStorage = userService.updateStorage(user.getId(), storageId, storageName, colorClass);

                if (isAjax) {
                    Map<String, Object> body = new HashMap<>();
                    if (updatedStorage != null) {
                        body.put("success", true);
                        body.put("message", "폴더가 수정되었습니다.");
                        body.put("storage", toStorageMap(updatedStorage));
                        writeJsonResponse(response, HttpServletResponse.SC_OK, body);
                    } else {
                        body.put("success", false);
                        body.put("message", "폴더 수정에 실패했습니다.");
                        writeJsonResponse(response, HttpServletResponse.SC_BAD_REQUEST, body);
                    }
                    return;
                }

                if (updatedStorage != null) {
                    response.sendRedirect(request.getContextPath() + "/wishlist");
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "폴더 수정에 실패했습니다.");
                }

            } else if ("deleteStorage".equalsIgnoreCase(action)) {
                String storageIdStr = request.getParameter("storageId");
                int storageId = Integer.parseInt(storageIdStr);
                boolean deleted = userService.deleteStorage(user.getId(), storageId);

                if (isAjax) {
                    Map<String, Object> body = new HashMap<>();
                    body.put("success", deleted);
                    body.put("message", deleted ? "폴더가 삭제되었습니다." : "폴더 삭제에 실패했습니다.");
                    writeJsonResponse(response, deleted ? HttpServletResponse.SC_OK : HttpServletResponse.SC_BAD_REQUEST, body);
                    return;
                }

                if (deleted) {
                    response.sendRedirect(request.getContextPath() + "/wishlist");
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "폴더 삭제에 실패했습니다.");
                }

            } else if ("removeItem".equalsIgnoreCase(action)) {
                int storageId = Integer.parseInt(request.getParameter("storageId"));
                String itemType = request.getParameter("itemType");
                int contentId = Integer.parseInt(request.getParameter("contentId"));

                boolean removed = userService.removeItemFromStorage(user.getId(), storageId, itemType, contentId);

                if (isAjax) {
                    Map<String, Object> body = new HashMap<>();
                    body.put("success", removed);
                    body.put("message", removed ? "아이템이 삭제되었습니다." : "아이템 삭제에 실패했습니다.");
                    writeJsonResponse(response, removed ? HttpServletResponse.SC_OK : HttpServletResponse.SC_BAD_REQUEST, body);
                    return;
                }

                if (removed) {
                    response.sendRedirect(request.getContextPath() + "/wishlist");
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "아이템 삭제에 실패했습니다.");
                }

            } else {
                if (isAjax) {
                    Map<String, Object> body = new HashMap<>();
                    body.put("success", false);
                    body.put("message", "유효하지 않은 요청입니다.");
                    writeJsonResponse(response, HttpServletResponse.SC_BAD_REQUEST, body);
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                }
                }

        } catch (Exception e) {
            e.printStackTrace();
            if (isAjax) {
                Map<String, Object> body = new HashMap<>();
                body.put("success", false);
                body.put("message", "작업을 처리하는 중 오류가 발생했습니다.");
                writeJsonResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, body);
            } else {
                request.setAttribute("error", "작업을 처리하는 중 오류가 발생했습니다.");
                request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
            }
        }
    }

    private boolean isAjaxRequest(HttpServletRequest request) {
        String requestedWith = request.getHeader("X-Requested-With");
        return requestedWith != null && "XMLHttpRequest".equalsIgnoreCase(requestedWith);
    }

    private void writeJsonResponse(HttpServletResponse response, int status, Map<String, Object> body) throws IOException {
        body.putIfAbsent("status", status);
        response.setStatus(HttpServletResponse.SC_OK);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(objectMapper.writeValueAsString(body));
    }

    private Map<String, Object> toStorageMap(UserStorage storage) {
        Map<String, Object> storageMap = new HashMap<>();
        storageMap.put("id", storage.getStorageId());
        storageMap.put("name", storage.getName());
        storageMap.put("colorClass", storage.getColorClass());
        storageMap.put("userId", storage.getUserId());
        storageMap.put("itemCount", storage.getItemCount());
        return storageMap;
    }
}
