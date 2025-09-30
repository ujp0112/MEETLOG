package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Collections;
import java.util.Map;
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

        // NaverImageSearch 유틸리티의 개선된 메소드를 호출하여 최적의 이미지를 찾습니다.
        String imageUrl = NaverImageSearch.findBestImage(query);

        // [수정] 결과를 {"imageUrl": "..."} 형태의 JSON 객체로 응답합니다.
        Map<String, String> responseData = Collections.singletonMap("imageUrl", imageUrl);
        out.print(new Gson().toJson(responseData));
        out.flush();
    }
}