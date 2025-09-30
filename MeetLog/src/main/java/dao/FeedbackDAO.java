package dao;

import model.Feedback;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;

import java.util.List;

public class FeedbackDAO {

    public List<Feedback> findAll() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList("FeedbackMapper.findAll");
        }
    }

    public Feedback findById(int id) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne("FeedbackMapper.findById", id);
        }
    }

    public List<Feedback> findByRating(int rating) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList("FeedbackMapper.findByRating", rating);
        }
    }

    public int insert(Feedback feedback) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.insert("FeedbackMapper.insert", feedback);
            session.commit();
            return result;
        }
    }

    public int delete(int id) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.delete("FeedbackMapper.delete", id);
            session.commit();
            return result;
        }
    }

    public int countTotal() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne("FeedbackMapper.countTotal");
        }
    }

    public double getAverageRating() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Double avg = session.selectOne("FeedbackMapper.getAverageRating");
            return avg != null ? avg : 0.0;
        }
    }
}