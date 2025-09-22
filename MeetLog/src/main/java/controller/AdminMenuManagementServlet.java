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

@WebServlet("/admin/menu-management")
public class AdminMenuManagementServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            String adminId = (String) session.getAttribute("adminId");
            
            if (adminId == null) {
                response.sendRedirect(request.getContextPath() + "/admin/login");
                return;
            }
            
            List<Menu> menus = createSampleMenus();
            request.setAttribute("menus", menus);
            
            request.getRequestDispatcher("/WEB-INF/views/admin-menu-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "메뉴 목록을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private List<Menu> createSampleMenus() {
        List<Menu> menus = new ArrayList<>();
        
        Menu menu1 = new Menu();
        menu1.setId(1);
        menu1.setName("김치찌개");
        menu1.setPrice(8000);
        menu1.setCategory("한식");
        menu1.setDescription("얼큰한 김치찌개");
        menus.add(menu1);
        
        return menus;
    }
    
    public static class Menu {
        private int id;
        private String name;
        private int price;
        private String category;
        private String description;
        
        // Getters and Setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public int getPrice() { return price; }
        public void setPrice(int price) { this.price = price; }
        public String getCategory() { return category; }
        public void setCategory(String category) { this.category = category; }
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
    }
}