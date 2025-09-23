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

@WebServlet(urlPatterns = { "/hq/recipe", "/hq/recipe/*" })
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
	        
	        // [핵심 수정] PathInfo 대신 action 파라미터를 사용합니다.
	        String action = request.getParameter("action");

	        // API: 특정 메뉴의 상세 정보 조회 (GET /hq/recipe?action=getDetails&id=123)
	        if ("getDetails".equals(action)) {
	        	String menuIdStr = request.getParameter("id");
	            // [추가] id 파라미터가 비어있거나 null인지 확인
	            if (menuIdStr == null || menuIdStr.isEmpty()) {
	                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "메뉴 ID가 필요합니다.");
	                return;
	            }
	            long menuId = Long.parseLong(menuIdStr);
	       
	            BranchMenu menu = menuService.getMenuDetails(companyId, menuId);
	            List<MenuIngredient> ingredients = menuService.listIngredients(companyId, menuId);
	            
	            Map<String, Object> responseData = new HashMap<>();
	            responseData.put("menu", menu);
	            responseData.put("ingredients", ingredients);
	            
	            response.setContentType("application/json; charset=UTF-8");
	            response.getWriter().write(gson.toJson(responseData));
	            return; // API 응답이므로 여기서 종료
	        }
	        
	        // 기본 동작: 메뉴 목록 페이지 표시
	        List<BranchMenu> menus = menuService.listMenus(companyId, 500, 0);
	        request.setAttribute("menus", menus);
	        request.getRequestDispatcher("/WEB-INF/hq/recipe-management.jsp").forward(request, response);
	    }

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		HttpSession session = request.getSession(false);
		BusinessUser user = (session == null) ? null : (BusinessUser) session.getAttribute("businessUser");
		if (user == null) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN);
			return;
		}
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