package service;

import dao.EmployeeDAO;
import model.Employee;

import java.util.List;

public class EmployeeService {
    private final EmployeeDAO employeeDAO = new EmployeeDAO();

    public List<Employee> getAllEmployees() {
        return employeeDAO.findAll();
    }

    public List<Employee> getEmployeesByStatus(String status) {
        return employeeDAO.findByStatus(status);
    }

    public Employee getEmployeeById(int id) {
        return employeeDAO.findById(id);
    }

    public boolean createEmployee(Employee employee) {
        try {
            return employeeDAO.insert(employee) > 0;
        } catch (Exception e) {
            System.out.println("ERROR: Employee 생성 실패 - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateEmployee(Employee employee) {
        try {
            return employeeDAO.update(employee) > 0;
        } catch (Exception e) {
            System.out.println("ERROR: Employee 수정 실패 - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateEmployeeStatus(int id, String status) {
        try {
            return employeeDAO.updateStatus(id, status) > 0;
        } catch (Exception e) {
            System.out.println("ERROR: Employee 상태 변경 실패 - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteEmployee(int id) {
        try {
            return employeeDAO.delete(id) > 0;
        } catch (Exception e) {
            System.out.println("ERROR: Employee 삭제 실패 - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public int getTotalEmployeeCount() {
        try {
            return employeeDAO.countTotal();
        } catch (Exception e) {
            System.out.println("ERROR: Employee 총 개수 조회 실패 - " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    public int getEmployeeCountByStatus(String status) {
        try {
            return employeeDAO.countByStatus(status);
        } catch (Exception e) {
            System.out.println("ERROR: Employee 상태별 개수 조회 실패 - " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }
}