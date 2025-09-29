package dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import model.CourseComment;
import util.MyBatisSqlSessionFactory;

public class CourseCommentDAO {

    private static final String NAMESPACE = "dao.CourseCommentDAO";

    public List<CourseComment> findByCourseId(int courseId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(NAMESPACE + ".findByCourseId", courseId);
        }
    }

    public CourseComment findById(int commentId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne(NAMESPACE + ".findById", commentId);
        }
    }

    public int insert(CourseComment comment) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.insert(NAMESPACE + ".insert", comment);
            session.commit();
            return result;
        }
    }

    public int softDelete(int commentId, int userId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of(
                    "commentId", commentId,
                    "userId", userId
            );
            int result = session.update(NAMESPACE + ".softDelete", params);
            session.commit();
            return result;
        }
    }

    public int update(int commentId, int userId, String content) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of(
                    "commentId", commentId,
                    "userId", userId,
                    "content", content
            );
            int result = session.update(NAMESPACE + ".update", params);
            session.commit();
            return result;
        }
    }
}
