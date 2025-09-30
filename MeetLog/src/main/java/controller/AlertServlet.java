package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import model.Alert;

@WebServlet("/alert")
public class AlertServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");
            
            if (userId == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            List<Alert> alerts = createSampleAlerts();
            request.setAttribute("alerts", alerts);
            
            request.getRequestDispatcher("/WEB-INF/views/alert.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "알림을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private List<Alert> createSampleAlerts() {
        List<Alert> alerts = new ArrayList<>();

        // 샘플 알림 데이터 생성
        Alert alert1 = new Alert();
        alert1.setId(1);
        alert1.setContent("<span class='font-bold'>새로운 리뷰</span>가 등록되었습니다. 고미정에 대한 리뷰를 확인해보세요.");
        alert1.setCreatedAt(java.sql.Timestamp.valueOf(java.time.LocalDateTime.now().minusMinutes(10)));
        alert1.setRead(false);
        alerts.add(alert1);

        Alert alert2 = new Alert();
        alert2.setId(2);
        alert2.setContent("<span class='font-bold'>예약 확정</span>: 파스타 팩토리 예약이 확정되었습니다. (2025-09-16 19:00)");
        alert2.setCreatedAt(java.sql.Timestamp.valueOf(java.time.LocalDateTime.now().minusHours(1)));
        alert2.setRead(true);
        alerts.add(alert2);

        Alert alert3 = new Alert();
        alert3.setId(3);
        alert3.setContent("<span class='font-bold'>칼럼 추천</span>: '강남 맛집 베스트 5' 칼럼이 추천 목록에 등록되었습니다.");
        alert3.setCreatedAt(java.sql.Timestamp.valueOf(java.time.LocalDateTime.now().minusHours(5)));
        alert3.setRead(false);
        alerts.add(alert3);

        return alerts;
    }
}
