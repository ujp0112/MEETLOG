package dao;

import model.Employee;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;

import java.util.List;
import java.util.HashMap;
import java.util.Map;

public class EmployeeDAO {

    public List<Employee> findAll() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList("EmployeeMapper.findAll");
        }
    }

    public List<Employee> findByStatus(String status) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList("EmployeeMapper.findByStatus", status);
        }
    }

    public Employee findById(int id) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne("EmployeeMapper.findById", id);
        }
    }

    public int insert(Employee employee) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.insert("EmployeeMapper.insert", employee);
            session.commit();
            return result;
        }
    }

    public int update(Employee employee) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.update("EmployeeMapper.update", employee);
            session.commit();
            return result;
        }
    }

    public int updateStatus(int id, String status) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("id", id);
            params.put("status", status);
            int result = session.update("EmployeeMapper.updateStatus", params);
            session.commit();
            return result;
        }
    }

    public int delete(int id) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.delete("EmployeeMapper.delete", id);
            session.commit();
            return result;
        }
    }

    public int countTotal() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne("EmployeeMapper.countTotal");
        }
    }

    public int countByStatus(String status) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne("EmployeeMapper.countByStatus", status);
        }
    }
}