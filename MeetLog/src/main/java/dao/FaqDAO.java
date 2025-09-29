package dao;

import model.Faq;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;

import java.util.List;
import java.util.HashMap;
import java.util.Map;

public class FaqDAO {

    public List<Faq> findAll() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList("FaqMapper.findAll");
        }
    }

    public List<Faq> findByCategory(String category) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList("FaqMapper.findByCategory", category);
        }
    }

    public List<Faq> findActiveOrdered() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList("FaqMapper.findActiveOrdered");
        }
    }

    public Faq findById(int id) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne("FaqMapper.findById", id);
        }
    }

    public int insert(Faq faq) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.insert("FaqMapper.insert", faq);
            session.commit();
            return result;
        }
    }

    public int update(Faq faq) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.update("FaqMapper.update", faq);
            session.commit();
            return result;
        }
    }

    public int delete(int id) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.delete("FaqMapper.delete", id);
            session.commit();
            return result;
        }
    }

    public int updateActiveStatus(int id, boolean isActive) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("id", id);
            params.put("isActive", isActive);
            int result = session.update("FaqMapper.updateActiveStatus", params);
            session.commit();
            return result;
        }
    }

    public List<String> findDistinctCategories() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList("FaqMapper.findDistinctCategories");
        }
    }
}