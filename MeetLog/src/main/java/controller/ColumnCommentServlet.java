package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import model.User;
import model.ColumnComment;
import service.ColumnCommentService;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import com.google.gson.Gson;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/column/comment/*")
public class ColumnCommentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ColumnCommentService columnCommentService = new ColumnCommentService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.startsWith("/list/")) {
            // 칼럼별 댓글 목록 조회
            String columnIdStr = pathInfo.substring(6);
            try {
                int columnId = Integer.parseInt(columnIdStr);
                List<ColumnComment> comments = columnCommentService.getCommentsByColumnId(columnId);

                response.setContentType("application/json; charset=UTF-8");
                PrintWriter out = response.getWriter();
                out.print(gson.toJson(comments));
                out.flush();

            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            out.print(gson.toJson(result));
            return;
        }

        User user = (User) session.getAttribute("user");

        // 폼 데이터 받기
        String columnIdStr = request.getParameter("columnId");
        String content = request.getParameter("content");

        System.out.println("DEBUG: columnIdStr = " + columnIdStr);
        System.out.println("DEBUG: content = " + content);

        // 유효성 검사
        if (columnIdStr == null || columnIdStr.trim().isEmpty() ||
            content == null || content.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "칼럼 ID와 댓글 내용을 모두 입력해주세요. columnId=" + columnIdStr + ", content=" + content);
            out.print(gson.toJson(result));
            return;
        }

        try {
            int columnId = Integer.parseInt(columnIdStr);

            // 칼럼 댓글 객체 생성
            ColumnComment comment = new ColumnComment();
            comment.setColumnId(columnId);
            comment.setUserId(user.getId());
            comment.setAuthor(user.getNickname());
            comment.setContent(content.trim());
            comment.setProfileImage(user.getProfileImage());

            // 댓글 저장
            boolean success = columnCommentService.addColumnComment(comment);

            if (success) {
                result.put("success", true);
                result.put("message", "댓글이 등록되었습니다.");
                result.put("commentId", comment.getId()); // 새로 생성된 댓글 ID만 반환
            } else {
                result.put("success", false);
                result.put("message", "댓글 등록에 실패했습니다.");
            }

        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "잘못된 칼럼 ID입니다.");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "댓글 등록 중 오류가 발생했습니다.");
        }

        out.print(gson.toJson(result));
        out.flush();
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            out.print(gson.toJson(result));
            return;
        }

        User user = (User) session.getAttribute("user");
        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.startsWith("/delete/")) {
            String commentIdStr = pathInfo.substring(8);
            try {
                int commentId = Integer.parseInt(commentIdStr);

                // 댓글 작성자 확인
                ColumnComment comment = columnCommentService.getCommentById(commentId);
                if (comment == null) {
                    result.put("success", false);
                    result.put("message", "댓글을 찾을 수 없습니다.");
                } else if (comment.getUserId() != user.getId()) {
                    result.put("success", false);
                    result.put("message", "본인이 작성한 댓글만 삭제할 수 있습니다.");
                } else {
                    boolean success = columnCommentService.deleteColumnComment(commentId);
                    if (success) {
                        result.put("success", true);
                        result.put("message", "댓글이 삭제되었습니다.");
                    } else {
                        result.put("success", false);
                        result.put("message", "댓글 삭제에 실패했습니다.");
                    }
                }

            } catch (NumberFormatException e) {
                result.put("success", false);
                result.put("message", "잘못된 댓글 ID입니다.");
            }
        } else {
            result.put("success", false);
            result.put("message", "잘못된 요청입니다.");
        }

        out.print(gson.toJson(result));
        out.flush();
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            out.print(gson.toJson(result));
            return;
        }

        User user = (User) session.getAttribute("user");

        // JSON 데이터 읽기
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = request.getReader().readLine()) != null) {
            sb.append(line);
        }

        try {
            System.out.println("DEBUG PUT: 받은 JSON 데이터 = " + sb.toString());

            Map<String, Object> jsonData = gson.fromJson(sb.toString(), Map.class);
            int commentId = ((Double) jsonData.get("commentId")).intValue();
            String newContent = (String) jsonData.get("content");

            System.out.println("DEBUG PUT: commentId = " + commentId + ", newContent = " + newContent);

            if (newContent == null || newContent.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "댓글 내용을 입력해주세요.");
                out.print(gson.toJson(result));
                return;
            }

            // 기존 댓글 확인 및 권한 체크
            ColumnComment existingComment = columnCommentService.getCommentById(commentId);
            if (existingComment == null) {
                result.put("success", false);
                result.put("message", "댓글을 찾을 수 없습니다.");
                out.print(gson.toJson(result));
                return;
            }

            if (existingComment.getUserId() != user.getId()) {
                result.put("success", false);
                result.put("message", "자신의 댓글만 수정할 수 있습니다.");
                out.print(gson.toJson(result));
                return;
            }

            // 댓글 수정
            existingComment.setContent(newContent.trim());
            boolean success = columnCommentService.updateColumnComment(existingComment);

            System.out.println("DEBUG PUT: 수정 결과 = " + success);

            if (success) {
                result.put("success", true);
                result.put("message", "댓글이 수정되었습니다.");
                result.put("commentId", commentId);
                result.put("content", newContent.trim());
                result.put("updatedAt", "방금 전");
                System.out.println("DEBUG PUT: 성공 응답 준비 완료");
            } else {
                result.put("success", false);
                result.put("message", "댓글 수정에 실패했습니다.");
                System.out.println("DEBUG PUT: 실패 응답 준비 완료");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "댓글 수정 중 오류가 발생했습니다.");
        }

        String jsonResponse = gson.toJson(result);
        System.out.println("DEBUG PUT: 최종 JSON 응답 = " + jsonResponse);

        out.print(jsonResponse);
        out.flush();
    }
}