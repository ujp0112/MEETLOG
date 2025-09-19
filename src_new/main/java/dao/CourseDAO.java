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

    public CommunityCourse findDetailById(int id) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne(COMMUNITY_MAPPER + ".findDetailById", id);
        }
    }

    /**
     * [추가] 특정 코스 ID에 해당하는 모든 경로(steps) 목록을 조회하는 메소드
     * @param courseId 코스 ID
     * @return 해당 코스의 경로 목록
     */
    public List<CourseStep> findStepsByCourseId(int courseId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            // CommunityCourseMapper.xml에 findStepsByCourseId 라는 id의 select 쿼리가 있어야 합니다.
            return session.selectList(COMMUNITY_MAPPER + ".findStepsByCourseId", courseId);
        }
    }

    public int insertCourse(CommunityCourse course) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.insert(COMMUNITY_MAPPER + ".insertCourse", course);
            if (result > 0) {
                session.commit();
            }
            return result;
        }
    }
    
    public int insertCourseStep(CourseStep step) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.insert(COMMUNITY_MAPPER + ".insertCourseStep", step);
            if (result > 0) {
                session.commit();
            }
            return result;
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