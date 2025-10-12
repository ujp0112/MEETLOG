package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/map-redirect")
public class MapRedirectServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// 1. URL 파라미터에서 'location' 값을 가져옵니다.
		String location = request.getParameter("location");

		// 2. JSP로 값을 전달하기 위해 request attribute에 저장합니다.
		request.setAttribute("location", location);

		// 3. 리다이렉트 로직을 처리할 JSP로 포워딩합니다.
		request.getRequestDispatcher("/WEB-INF/views/map-redirect.jsp").forward(request, response);
	}
}