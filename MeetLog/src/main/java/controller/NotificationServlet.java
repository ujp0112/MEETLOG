package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.User;
import model.Notification;
import service.NotificationService;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;

@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        SqlSession sqlSession = null;
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            
            sqlSession = MyBatisSqlSessionFactory.getSqlSession();
            NotificationService notificationService = new NotificationService();
            
            // 사용자의 알림 목록 가져오기
            List<Notification> notifications = notificationService.getNotificationsByUserId(user.getId());
            
            // 읽지 않은 알림 수 계산
            long unreadCount = notifications.stream()
                .filter(n -> !n.isRead())
                .count();
            
            request.setAttribute("notifications", notifications);
            request.setAttribute("unreadCount", unreadCount);
            
            request.getRequestDispatcher("/WEB-INF/views/notifications.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "알림을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("markAsRead".equals(action)) {
            markAsRead(request, response);
        } else if ("markAllAsRead".equals(action)) {
            markAllAsRead(request, response);
        } else if ("delete".equals(action)) {
            deleteNotification(request, response);
        }
    }
    
    private void markAsRead(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int notificationId = Integer.parseInt(request.getParameter("notificationId"));
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            
            NotificationService notificationService = new NotificationService();
            boolean success = notificationService.markAsRead(notificationId, user.getId());
            
            if (success) {
                response.getWriter().write("{\"success\": true}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"알림을 읽음 처리할 수 없습니다.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"오류가 발생했습니다.\"}");
        }
    }
    
    private void markAllAsRead(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            
            NotificationService notificationService = new NotificationService();
            boolean success = notificationService.markAllAsRead(user.getId());
            
            if (success) {
                response.getWriter().write("{\"success\": true}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"알림을 읽음 처리할 수 없습니다.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"오류가 발생했습니다.\"}");
        }
    }
    
    private void deleteNotification(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int notificationId = Integer.parseInt(request.getParameter("notificationId"));
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            
            NotificationService notificationService = new NotificationService();
            boolean success = notificationService.deleteNotification(notificationId, user.getId());
            
            if (success) {
                response.getWriter().write("{\"success\": true}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"알림을 삭제할 수 없습니다.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"오류가 발생했습니다.\"}");
        }
    }
}
