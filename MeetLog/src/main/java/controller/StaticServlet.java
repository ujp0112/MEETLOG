package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/static/*")
public class StaticServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // 메인 페이지 - 정적 데이터로 표시
            request.getRequestDispatcher("/WEB-INF/views/main-static.jsp").forward(request, response);
        } else if (pathInfo.equals("/restaurant-detail")) {
            // 맛집 상세 페이지 - 정적 데이터로 표시
            request.getRequestDispatcher("/WEB-INF/views/restaurant-detail-static.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
