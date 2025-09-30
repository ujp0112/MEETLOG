package dao;

import model.Inquiry;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;

import java.util.List;
import java.util.HashMap;
import java.util.Map;

public class InquiryDAO {

    public List<Inquiry> findAll() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList("InquiryMapper.findAll");
        }
    }

    public List<Inquiry> findByStatus(String status) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList("InquiryMapper.findByStatus", status);
        }
    }

    public Inquiry findById(int id) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne("InquiryMapper.findById", id);
        }
    }

    public int insert(Inquiry inquiry) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.insert("InquiryMapper.insert", inquiry);
            session.commit();
            return result;
        }
    }

    public int update(Inquiry inquiry) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.update("InquiryMapper.update", inquiry);
            session.commit();
            return result;
        }
    }

    public int updateStatus(int id, String status) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("id", id);
            params.put("status", status);
            int result = session.update("InquiryMapper.updateStatus", params);
            session.commit();
            return result;
        }
    }

    public int updateReply(int id, String reply, String status) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("id", id);
            params.put("reply", reply);
            params.put("status", status);
            int result = session.update("InquiryMapper.updateReply", params);
            session.commit();
            return result;
        }
    }

    public int delete(int id) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.delete("InquiryMapper.delete", id);
            session.commit();
            return result;
        }
    }

    public int countTotal() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne("InquiryMapper.countTotal");
        }
    }

    public int countByStatus(String status) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne("InquiryMapper.countByStatus", status);
        }
    }
}