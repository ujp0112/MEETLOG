package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/test")
public class TestServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<html><head><title>DB 연결 테스트</title></head><body>");
        out.println("<h1>데이터베이스 연결 테스트</h1>");
        
        try {
            // 드라이버 로드 테스트
            out.println("<h2>1. 드라이버 로드 테스트</h2>");
            try {
                Class.forName("org.mariadb.jdbc.Driver");
                out.println("<p style='color: green;'>✅ MariaDB 드라이버 로드 성공</p>");
            } catch (ClassNotFoundException e) {
                out.println("<p style='color: red;'>❌ MariaDB 드라이버 로드 실패: " + e.getMessage() + "</p>");
            }
            
            // MyBatis 설정 테스트
            out.println("<h2>2. MyBatis 설정 테스트</h2>");
            try {
                util.MyBatisSqlSessionFactory.getSqlSession();
                out.println("<p style='color: green;'>✅ MyBatis SqlSession 생성 성공</p>");
            } catch (Exception e) {
                out.println("<p style='color: red;'>❌ MyBatis SqlSession 생성 실패: " + e.getMessage() + "</p>");
            }
            
            out.println("<h2>3. 서버 정보</h2>");
            out.println("<p>서버 시간: " + new java.util.Date() + "</p>");
            out.println("<p>Java 버전: " + System.getProperty("java.version") + "</p>");
            out.println("<p>서블릿 컨텍스트: " + request.getServletContext().getContextPath() + "</p>");
            
        } catch (Exception e) {
            out.println("<p style='color: red;'>❌ 테스트 중 오류 발생: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
        
        out.println("</body></html>");
    }
}
