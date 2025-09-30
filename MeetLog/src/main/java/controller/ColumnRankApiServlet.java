package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import model.Column;
import service.ColumnService;

//@WebServlet("/api/columns/rank")
public class ColumnRankApiServlet extends HttpServlet {

    private final ColumnService columnService = new ColumnService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. 요청에서 지역명(검색어) 가져오기
        String region = req.getParameter("region");

        if (region == null || region.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Region parameter is missing\"}");
            return;
        }

        // 2. 서비스를 통해 랭킹 데이터 조회
        List<Column> rankedColumns = columnService.getRankedColumnsByRegion(region);

        // 3. 프론트엔드(JSP)에서 필요한 데이터 형식으로 가공 (DTO 역할)
        List<Map<String, Object>> result = new ArrayList<>();
        for (Column col : rankedColumns) {
            Map<String, Object> columnData = new HashMap<>();
            columnData.put("id", col.getId());
            columnData.put("title", col.getTitle());
            columnData.put("contentSnippet", col.getContent()); // 서비스에서 요약된 내용
            columnData.put("authorNickname", col.getAuthor()); // author 필드에 닉네임이 담겨있음
            result.add(columnData);
        }

        // 4. 가공된 데이터를 JSON 형태로 변환하여 응답
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(gson.toJson(result));
    }
}