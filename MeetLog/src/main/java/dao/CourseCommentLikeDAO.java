package dao;

import java.util.Map;
import org.apache.ibatis.session.SqlSession;

public class CourseCommentLikeDAO {

    private static final String NAMESPACE = "dao.CourseCommentLikeDAO";

    public Integer checkLike(SqlSession session, Map<String, Object> params) {
        return session.selectOne(NAMESPACE + ".checkLike", params);
    }

    public int addLike(SqlSession session, Map<String, Object> params) {
        return session.insert(NAMESPACE + ".addLike", params);
    }

    public int removeLike(SqlSession session, Map<String, Object> params) {
        return session.delete(NAMESPACE + ".removeLike", params);
    }

    // SqlSession을 외부에서 관리하지 않는 경우를 위한 편의 메소드들
    public Integer checkLike(Map<String, Object> params) {
        try (SqlSession session = util.MyBatisSqlSessionFactory.getSqlSession()) {
            return checkLike(session, params);
        }
    }

    public int addLike(Map<String, Object> params) {
        try (SqlSession session = util.MyBatisSqlSessionFactory.getSqlSession()) {
            int result = addLike(session, params);
            session.commit();
            return result;
        }
    }

    public int removeLike(Map<String, Object> params) {
        try (SqlSession session = util.MyBatisSqlSessionFactory.getSqlSession()) {
            int result = removeLike(session, params);
            session.commit();
            return result;
        }
    }
}

