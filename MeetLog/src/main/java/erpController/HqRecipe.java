package erpController;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.BusinessUser;

/**
 * Servlet implementation class HqRecipe
 */
@WebServlet("/hq/recipe")
public class HqRecipe extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public HqRecipe() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");

	    HttpSession session = request.getSession(false);
	    BusinessUser user = (session == null) ? null : (BusinessUser) session.getAttribute("businessUser");
	    if (user == null) { response.sendRedirect(request.getContextPath()+"/login.jsp"); return; }

	    long companyId = user.getCompanyId();
//	    List<Material> materials = materialService.listByCompany(companyId);
//	    request.setAttribute("materials", materials);

	    request.getRequestDispatcher("/WEB-INF/hq/recipe-management.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
