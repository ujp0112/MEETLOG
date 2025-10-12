package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/location-map")
public class LocationMapServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// 1. URL에서 검색어(query) 파라미터를 가져옵니다.
		String query = request.getParameter("query");

		// 2. 검색어를 JSP로 전달하기 위해 request attribute에 저장합니다.
		request.setAttribute("query", query);

		// 3. 지도를 표시할 새로운 JSP 페이지로 포워딩합니다.
		request.getRequestDispatcher("/WEB-INF/views/location-map.jsp").forward(request, response);
	}
}