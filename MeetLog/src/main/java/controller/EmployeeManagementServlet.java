package controller;

import model.Employee;
import service.EmployeeService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import util.AdminSessionUtils;

public class EmployeeManagementServlet extends HttpServlet {
    private final EmployeeService employeeService = new EmployeeService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if (AdminSessionUtils.requireAdmin(request, response) == null) {
                return;
            }

            List<Employee> employees = employeeService.getAllEmployees();
            request.setAttribute("employees", employees);

            request.getRequestDispatcher("/WEB-INF/views/admin-employee-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "직원 목록을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if (AdminSessionUtils.getAdminUser(request) == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"success\": false, \"message\": \"관리자 권한이 필요합니다.\"}");
                return;
            }

            String action = request.getParameter("action");
            if (action == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"Action이 필요합니다.\"}");
                return;
            }

            response.setContentType("application/json; charset=UTF-8");

            switch (action) {
                case "create":
                    handleCreateEmployee(request, response);
                    break;
                case "update":
                    handleUpdateEmployee(request, response);
                    break;
                case "delete":
                    handleDeleteEmployee(request, response);
                    break;
                case "updateStatus":
                    handleUpdateStatus(request, response);
                    break;
                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"success\": false, \"message\": \"지원하지 않는 액션입니다.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"서버 오류가 발생했습니다.\"}");
        }
    }

    private void handleCreateEmployee(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String name = request.getParameter("name");
        String position = request.getParameter("position");
        String branch = request.getParameter("branch");

        if (name == null || position == null || branch == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"필수 항목을 입력해주세요.\"}");
            return;
        }

        Employee employee = new Employee(name, position, branch);
        boolean success = employeeService.createEmployee(employee);

        if (success) {
            response.getWriter().write("{\"success\": true, \"message\": \"직원이 생성되었습니다.\"}");
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"직원 생성에 실패했습니다.\"}");
        }
    }

    private void handleUpdateEmployee(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String position = request.getParameter("position");
            String branch = request.getParameter("branch");
            String status = request.getParameter("status");

            if (name == null || position == null || branch == null || status == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"필수 항목을 입력해주세요.\"}");
                return;
            }

            Employee employee = new Employee();
            employee.setId(id);
            employee.setName(name);
            employee.setPosition(position);
            employee.setBranch(branch);
            employee.setStatus(status);

            boolean success = employeeService.updateEmployee(employee);

            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"직원 정보가 수정되었습니다.\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"success\": false, \"message\": \"직원 정보 수정에 실패했습니다.\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"올바른 ID를 입력해주세요.\"}");
        }
    }

    private void handleDeleteEmployee(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean success = employeeService.deleteEmployee(id);

            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"직원이 삭제되었습니다.\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"success\": false, \"message\": \"직원 삭제에 실패했습니다.\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"올바른 ID를 입력해주세요.\"}");
        }
    }

    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");

            if (status == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"상태를 입력해주세요.\"}");
                return;
            }

            boolean success = employeeService.updateEmployeeStatus(id, status);

            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"직원 상태가 변경되었습니다.\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"success\": false, \"message\": \"직원 상태 변경에 실패했습니다.\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"올바른 ID를 입력해주세요.\"}");
        }
    }
}