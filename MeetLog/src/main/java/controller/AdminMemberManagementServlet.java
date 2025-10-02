package controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

import java.util.List;

import model.User;
import service.UserService;
import util.AdminSessionUtils;

public class AdminMemberManagementServlet extends HttpServlet {

    private final UserService userService = new UserService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            User adminUser = AdminSessionUtils.requireAdmin(request, response);
            if (adminUser == null) {
                return;
            }

            List<User> users = userService.getAllUsersIncludingInactive();
            request.setAttribute("users", users);
            
            request.getRequestDispatcher("/WEB-INF/views/admin-member-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "회원 목록을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        try {
            User adminUser = AdminSessionUtils.requireAdmin(request, response);
            if (adminUser == null) {
                return;
            }
            
            String action = request.getParameter("action");
            String memberIdParam = request.getParameter("memberId");

            if (action != null && memberIdParam != null) {
                try {
                    int memberId = Integer.parseInt(memberIdParam);
                    switch (action) {
                        case "suspend":
                            userService.deactivateUser(memberId);
                            request.setAttribute("successMessage", "회원이 정지되었습니다.");
                            break;
                        case "activate":
                            userService.activateUser(memberId);
                            request.setAttribute("successMessage", "회원이 활성화되었습니다.");
                            break;
                        case "delete":
                            userService.deleteUser(memberId);
                            request.setAttribute("successMessage", "회원이 삭제되었습니다.");
                            break;
                        default:
                            request.setAttribute("errorMessage", "알 수 없는 작업입니다.");
                    }
                } catch (NumberFormatException ex) {
                    request.setAttribute("errorMessage", "잘못된 회원 ID입니다.");
                }
            }

            doGet(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "회원 관리 중 오류가 발생했습니다.");
            doGet(request, response);
        }
    }
}
