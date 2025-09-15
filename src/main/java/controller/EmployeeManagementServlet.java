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

@WebServlet("/admin/employee-management")
public class EmployeeManagementServlet extends HttpServlet {
    
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
            
            List<Employee> employees = createSampleEmployees();
            request.setAttribute("employees", employees);
            
            request.getRequestDispatcher("/WEB-INF/views/admin-employee-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "직원 목록을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private List<Employee> createSampleEmployees() {
        List<Employee> employees = new ArrayList<>();
        
        Employee employee1 = new Employee();
        employee1.setId(1);
        employee1.setName("김직원");
        employee1.setPosition("매니저");
        employee1.setBranch("강남점");
        employee1.setStatus("ACTIVE");
        employees.add(employee1);
        
        return employees;
    }
    
    public static class Employee {
        private int id;
        private String name;
        private String position;
        private String branch;
        private String status;
        
        // Getters and Setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public String getPosition() { return position; }
        public void setPosition(String position) { this.position = position; }
        public String getBranch() { return branch; }
        public void setBranch(String branch) { this.branch = branch; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
    }
}
