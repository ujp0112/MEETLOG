package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import util.NaverImageSearch;

@WebServlet("/search/image-proxy")
public class ImageProxyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String query = request.getParameter("query");
        
        if (query == null || query.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Query parameter is missing.\"}");
            out.flush();
            return;
        }

        // [수정] 개선된 통합 메소드를 호출하여 최적의 이미지 URL을 가져옵니다.
        String imageUrl = NaverImageSearch.searchImages(query, 1).get(0);

        out.print(new Gson().toJson(imageUrl));
        out.flush();
    }
}

