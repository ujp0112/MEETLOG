package dao;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import model.UserVectorRecord;
import util.MyBatisSqlSessionFactory;

/**
 * 사용자 리뷰 벡터 캐시 테이블 DAO.
 */
public class UserVectorDAO {

    public UserVectorRecord findByUserId(int userId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne("UserVectorMapper.findByUserId", userId);
        }
    }

    public void markProcessing(int userId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            session.insert("UserVectorMapper.markProcessing", userId);
            session.commit();
        }
    }

    public void saveVector(int userId, String vectorJson) {
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("vectorJson", vectorJson);
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            session.insert("UserVectorMapper.upsertVector", params);
            session.commit();
        }
    }

    public void markEmpty(int userId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            session.insert("UserVectorMapper.markEmpty", userId);
            session.commit();
        }
    }

    public void markFailure(int userId, String errorMessage) {
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("error", errorMessage);
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            session.insert("UserVectorMapper.markFailure", params);
            session.commit();
        }
    }
}

