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

    // 코스 업데이트
    public int updateCourse(CommunityCourse course, SqlSession session) {
        return session.update(COMMUNITY_MAPPER + ".updateCourse", course);
    }

    // 코스 ID로 경로들 삭제
    public int deleteCourseStepsByCourseId(int courseId, SqlSession session) {
        return session.delete(COMMUNITY_MAPPER + ".deleteCourseStepsByCourseId", courseId);
    }

    // 코스 ID로 단일 코스 조회
    public CommunityCourse findById(int id) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne(COMMUNITY_MAPPER + ".findById", id);
        }
    }

    // 사용자 ID로 코스 목록 조회
    public List<CommunityCourse> findByUserId(int userId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(COMMUNITY_MAPPER + ".findByUserId", userId);
        }
    }

    // 태그 관련 메서드
    public Integer findTagByName(String tagName, SqlSession session) {
        return session.selectOne(COMMUNITY_MAPPER + ".findOrCreateTag", tagName);
    }

    public int insertTag(String tagName, SqlSession session) {
        session.insert(COMMUNITY_MAPPER + ".insertTag", tagName);
        // MyBatis가 자동으로 생성한 ID를 반환하도록 설정 필요
        return session.selectOne(COMMUNITY_MAPPER + ".findOrCreateTag", tagName);
    }

    public int insertCourseTag(int courseId, int tagId, SqlSession session) {
        Map<String, Object> params = new java.util.HashMap<>();
        params.put("courseId", courseId);
        params.put("tagId", tagId);
        return session.insert(COMMUNITY_MAPPER + ".insertCourseTag", params);
    }

    public int deleteCourseTagsByCourseId(int courseId, SqlSession session) {
        return session.delete(COMMUNITY_MAPPER + ".deleteCourseTagsByCourseId", courseId);
    }
}