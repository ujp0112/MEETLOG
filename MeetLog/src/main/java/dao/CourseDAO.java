package dao;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;

import model.CommunityCourse;
import model.OfficialCourse;
import model.CourseStep;
import model.Course;

public class CourseDAO {
    
    private static final String COMMUNITY_MAPPER = "mapper.CommunityCourseMapper";
    private static final String OFFICIAL_MAPPER = "mapper.OfficialCourseMapper";

    // --- 트랜잭션 참가를 위한 메소드들 ---
    public int insertCourse(CommunityCourse course, SqlSession session) {
        return session.insert(COMMUNITY_MAPPER + ".insertCourse", course);
    }
    
    public int insertCourseStep(CourseStep step, SqlSession session) {
        return session.insert(COMMUNITY_MAPPER + ".insertCourseStep", step);
    }
    // --- ---

    public CommunityCourse findDetailById(int id) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne(COMMUNITY_MAPPER + ".findDetailById", id);
        }
    }

    public List<CourseStep> findStepsByCourseId(int courseId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(COMMUNITY_MAPPER + ".findStepsByCourseId", courseId);
        }
    }

    public List<CommunityCourse> selectCommunityCourses(Map<String, Object> params) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(COMMUNITY_MAPPER + ".selectCommunityCourses", params);
        }
    }

    public int countCommunityCourses(Map<String, Object> params) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Integer count = session.selectOne(COMMUNITY_MAPPER + ".countCommunityCourses", params);
            return (count == null) ? 0 : count;
        }
    }

    public List<OfficialCourse> selectOfficialCourses() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(OFFICIAL_MAPPER + ".selectOfficialCourses");
        }
    }
    
    /**
     * 사용자가 작성한 코스 목록 조회 (페이징)
     */
    public List<Course> getCoursesByAuthor(Map<String, Object> params) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList("dao.CourseDAO.getCoursesByAuthor", params);
        }
    }
    
    /**
     * 사용자가 작성한 코스 개수 조회
     */
    public int getCourseCountByAuthor(int authorId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Integer count = session.selectOne("dao.CourseDAO.getCourseCountByAuthor", authorId);
            return count != null ? count : 0;
        }
    }
    
    /**
     * 코스 ID로 코스 조회
     */
    public Course getCourseById(int courseId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne("dao.CourseDAO.getCourseById", courseId);
        }
    }
    
    /**
     * 코스 공개/비공개 토글
     */
    public int toggleCoursePublic(int courseId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.update("dao.CourseDAO.toggleCoursePublic", courseId);
            session.commit();
            return result;
        }
    }
    
    /**
     * 코스 삭제
     */
    public int deleteCourse(int courseId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.delete("dao.CourseDAO.deleteCourse", courseId);
            session.commit();
            return result;
        }
    }
    
    /**
     * 특정 사용자의 최근 코스 조회 (피드용)
     */
    public List<Course> getRecentCoursesByUser(int userId, int limit) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new java.util.HashMap<>();
            params.put("userId", userId);
            params.put("limit", limit);
            return session.selectList("dao.CourseDAO.getRecentCoursesByUser", params);
        }
    }
    
    /**
     * 특정 사용자의 코스 개수 조회 (피드용)
     */
    public int getCourseCountByUser(int userId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Integer count = session.selectOne("dao.CourseDAO.getCourseCountByUser", userId);
            return count != null ? count : 0;
        }
    }
}