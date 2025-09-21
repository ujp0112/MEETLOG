package dao;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;

import model.CommunityCourse;
import model.OfficialCourse;
import model.CourseStep;

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
}