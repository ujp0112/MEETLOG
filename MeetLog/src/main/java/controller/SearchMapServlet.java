package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/searchRestaurant")
public class SearchMapServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 요청 파라미터에서 검색 키워드를 가져옵니다.
        request.setCharacterEncoding("UTF-8");
        String keyword = request.getParameter("keyword");

        // 2. 검색 키워드를 request attribute에 저장하여 JSP로 전달합니다.
        request.setAttribute("keyword", keyword);

        // 3. 검색 결과를 보여줄 JSP 페이지로 포워딩합니다.
        request.getRequestDispatcher("/WEB-INF/views/search-map.jsp").forward(request, response);
    }
}
