package erpController;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;


public class BranchManagementServlet extends HttpServlet {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

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
            
            // 지점 목록 데이터
            List<Branch> branches = createSampleBranches();
            request.setAttribute("branches", branches);
            
            request.getRequestDispatcher("/WEB-INF/views/admin-branch-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "지점 목록을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        try {
            HttpSession session = request.getSession();
            String adminId = (String) session.getAttribute("adminId");
            
            if (adminId == null) {
                response.sendRedirect(request.getContextPath() + "/admin/login");
                return;
            }
            
            String action = request.getParameter("action");
            
            if ("add".equals(action)) {
                // 지점 추가 처리
                request.setAttribute("successMessage", "지점이 추가되었습니다.");
            } else if ("update".equals(action)) {
                // 지점 수정 처리
                request.setAttribute("successMessage", "지점이 수정되었습니다.");
            } else if ("delete".equals(action)) {
                // 지점 삭제 처리
                request.setAttribute("successMessage", "지점이 삭제되었습니다.");
            } else if ("activate".equals(action)) {
                // 지점 활성화 처리
                request.setAttribute("successMessage", "지점이 활성화되었습니다.");
            } else if ("deactivate".equals(action)) {
                // 지점 비활성화 처리
                request.setAttribute("successMessage", "지점이 비활성화되었습니다.");
            }
            
            // 지점 목록 다시 로드
            doGet(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "지점 관리 중 오류가 발생했습니다.");
            doGet(request, response);
        }
    }
    
    private List<Branch> createSampleBranches() {
        List<Branch> branches = new ArrayList<>();
        
        Branch branch1 = new Branch();
        branch1.setId(1);
        branch1.setName("강남점");
        branch1.setAddress("서울시 강남구 테헤란로 123");
        branch1.setPhone("02-1234-5678");
        branch1.setManager("김지점장");
        branch1.setStatus("ACTIVE");
        branch1.setCreatedAt("2025-01-15");
        branch1.setEmployeeCount(15);
        branch1.setMonthlyRevenue(50000000);
        branches.add(branch1);
        
        Branch branch2 = new Branch();
        branch2.setId(2);
        branch2.setName("홍대점");
        branch2.setAddress("서울시 마포구 와우산로 456");
        branch2.setPhone("02-2345-6789");
        branch2.setManager("이지점장");
        branch2.setStatus("ACTIVE");
        branch2.setCreatedAt("2025-03-20");
        branch2.setEmployeeCount(12);
        branch2.setMonthlyRevenue(35000000);
        branches.add(branch2);
        
        Branch branch3 = new Branch();
        branch3.setId(3);
        branch3.setName("여의도점");
        branch3.setAddress("서울시 영등포구 여의대로 789");
        branch3.setPhone("02-3456-7890");
        branch3.setManager("박지점장");
        branch3.setStatus("PENDING");
        branch3.setCreatedAt("2025-09-01");
        branch3.setEmployeeCount(0);
        branch3.setMonthlyRevenue(0);
        branches.add(branch3);
        
        return branches;
    }
    
    // 지점 클래스
    public static class Branch {
        private int id;
        private String name;
        private String address;
        private String phone;
        private String manager;
        private String status;
        private String createdAt;
        private int employeeCount;
        private int monthlyRevenue;
        
        // Getters and Setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public String getAddress() { return address; }
        public void setAddress(String address) { this.address = address; }
        public String getPhone() { return phone; }
        public void setPhone(String phone) { this.phone = phone; }
        public String getManager() { return manager; }
        public void setManager(String manager) { this.manager = manager; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        public String getCreatedAt() { return createdAt; }
        public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
        public int getEmployeeCount() { return employeeCount; }
        public void setEmployeeCount(int employeeCount) { this.employeeCount = employeeCount; }
        public int getMonthlyRevenue() { return monthlyRevenue; }
        public void setMonthlyRevenue(int monthlyRevenue) { this.monthlyRevenue = monthlyRevenue; }
    }
}
