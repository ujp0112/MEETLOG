package erpController;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import erpDto.MenuToggle;
import erpService.BranchService;
import model.BusinessUser;
import com.google.gson.Gson; // Gson 임포트 추가
import erpDto.BranchMenu;    // BranchMenu DTO 임포트 추가
import java.util.Map;       // Map 임포트 추가
import java.util.HashMap;   // HashMap 임포트 추가

@WebServlet(name = "BranchMenuServlet", urlPatterns = { "/branch/menus", "/branch/menus/*" })
public class BranchMenuServlet extends HttpServlet {

	private BranchService branchService;
	private final Gson gson = new Gson();
	
	@Override
	public void init() throws ServletException {
		branchService = new BranchService();
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// ✅ 로그인 세션 키는 authUser
		HttpSession session = req.getSession(false);
		BusinessUser user = (session == null) ? null : (BusinessUser) session.getAttribute("businessUser");
		if (user == null) {
			resp.sendError(401);
			return;
		}
		long companyId = user.getCompanyId();
		long branchId = user.getUserId();

		String pi = req.getPathInfo(); // null, "/", "/list", "/{id}/ingredients"
		if (pi == null || "/".equals(pi)) {
			req.getRequestDispatcher("/WEB-INF/branch/menu.jsp").forward(req, resp);
			return;
		}

		if ("/list".equals(pi)) {
			String q = req.getParameter("q");
			List<Map<String, Object>> rows = branchService.listMenusForBranch(companyId, branchId, q);
			resp.setContentType("application/json; charset=UTF-8");
			PrintWriter out = resp.getWriter();
			out.write('[');
			for (int i = 0; i < rows.size(); i++) {
				Map<String, Object> m = rows.get(i);
				if (i > 0)
					out.write(',');
				out.write('{');
				out.write("\"id\":" + m.get("id"));
				out.write(",\"name\":\"" + esc((String) m.get("name")) + "\"");
				out.write(",\"price\":" + m.get("price"));
				out.write(",\"imgPath\":\"" + esc(nvl((String) m.get("imgPath"))) + "\"");
				out.write(",\"enabled\":\"" + ("Y".equals(m.get("enabled")) ? "Y" : "N") + "\"");
				out.write('}');
			}
			out.write(']');
			return;
		}

		Matcher m = Pattern.compile("^/(\\d+)/ingredients$").matcher(pi == null ? "" : pi);
        if (m.find()) {
            long menuId = Long.parseLong(m.group(1));

            // [수정] 1. 재료 목록과 함께 메뉴 상세 정보(레시피 포함)도 조회
            List<Map<String, Object>> ingredients = branchService.listMenuIngredientsByMenu(companyId, menuId);
            BranchMenu menu = branchService.getMenuDetails(companyId, menuId); // getMenuDetails는 이전 구현에서 이미 존재

            // [수정] 2. Map을 사용하여 재료와 레시피를 함께 담아 JSON으로 변환
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("ingredients", ingredients);
            responseData.put("recipe", menu != null ? menu.getRecipe() : null);

            resp.setContentType("application/json; charset=UTF-8");
            resp.getWriter().write(gson.toJson(responseData)); // Gson을 사용해 응답
            return;
        }

		resp.sendError(404);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession(false);
		BusinessUser user = (session == null) ? null : (BusinessUser) session.getAttribute("businessUser");
		if (user == null) {
			resp.sendError(401);
			return;
		}
		long companyId = user.getCompanyId();
		long branchId = user.getUserId();

		String pi = req.getPathInfo(); // e.g. "/123/toggle"
		Matcher m = Pattern.compile("^/(\\d+)/toggle$").matcher(pi == null ? "" : pi);
		if (m.find()) {
			long menuId = Long.parseLong(m.group(1));
			String enabled = req.getParameter("enabled"); // "Y" | "N"
			if (!"Y".equals(enabled) && !"N".equals(enabled))
				enabled = "N";

			MenuToggle t = new MenuToggle();
			t.setCompanyId(companyId);
			t.setBranchId(branchId);
			t.setMenuId(menuId);
			t.setEnabled(enabled);

			branchService.upsertBranchMenuToggle(t);

			resp.setStatus(204); // No Content
			return;
		}

		resp.sendError(404);
	}

	private static String esc(String s) {
		if (s == null)
			return "";
		return s.replace("\\", "\\\\").replace("\"", "\\\"");
	}

	private static String nvl(String s) {
		return s == null ? "" : s;
	}
}
