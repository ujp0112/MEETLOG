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
        request.setCharacterEncoding("UTF-8");
        String keyword = request.getParameter("keyword");
        String category = request.getParameter("category"); // [추가] 카테고리 파라미터 받기

        request.setAttribute("keyword", keyword);
        request.setAttribute("category", category); // [추가] 카테고리 값을 JSP로 전달

        request.getRequestDispatcher("/WEB-INF/views/search-map.jsp").forward(request, response);
    }
}
