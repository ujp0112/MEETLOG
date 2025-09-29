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
        String category = request.getParameter("category");

        request.setAttribute("keyword", keyword);
        request.setAttribute("category", category);
        
        // [수정] search-map.jsp 에서는 page 파라미터를 사용하지 않으므로, 이 라인은 제거해도 무방합니다.
        // request.setAttribute("page", 1); 

        request.getRequestDispatcher("/WEB-INF/views/search-map.jsp").forward(request, response);
    }
}

