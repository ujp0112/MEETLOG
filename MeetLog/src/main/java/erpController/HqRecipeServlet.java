package erpController;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.google.gson.Gson;
import erpDto.BranchMenu;
import erpDto.MenuIngredient;
import erpService.BranchMenuService;
import model.BusinessUser;

@WebServlet(urlPatterns = {"/hq/recipe", "/hq/recipe/*"})
public class HqRecipeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final BranchMenuService menuService = new BranchMenuService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        BusinessUser user = (session == null) ? null : (BusinessUser) session.getAttribute("businessUser");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
        long companyId = user.getCompanyId();
        
        String pathInfo = request.getPathInfo();

        // API: 특정 메뉴의 상세 정보 (재료 + 레시피) 조회 (GET /hq/recipe/{id})
        if (pathInfo != null && pathInfo.matches("/\\d+")) {
            long menuId = Long.parseLong(pathInfo.substring(1));
            
            BranchMenu menu = menuService.getMenuDetails(companyId, menuId);
            List<MenuIngredient> ingredients = menuService.listIngredients(companyId, menuId);
            
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("menu", menu);
            responseData.put("ingredients", ingredients);
            
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write(gson.toJson(responseData));
            return;
        }
        
        // 기본: 메뉴 목록 페이지
        List<BranchMenu> menus = menuService.listMenus(companyId, 500, 0); // 페이징 미적용
        request.setAttribute("menus", menus);
        request.getRequestDispatcher("/WEB-INF/hq/recipe-management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        BusinessUser user = (session == null) ? null : (BusinessUser) session.getAttribute("businessUser");
        if (user == null) { response.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
        long companyId = user.getCompanyId();
        
        long menuId = Long.parseLong(request.getParameter("menuId"));
        String recipe = request.getParameter("recipe");
        
        try {
            menuService.updateRecipe(companyId, menuId, recipe);
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"OK\"}");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "레시피 저장에 실패했습니다.");
        }
    }
}