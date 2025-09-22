package dao;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;

// [필수] 필요한 모델 클래스들을 import 합니다.
import model.Course; 
import model.CommunityCourse;
import model.OfficialCourse;
import model.CourseStep;

/**
 * 사용자용 코스 DAO (새로운 JSP 디자인에 맞게 수정됨)
 */
public class CourseDAO {
    
    // [수정] 네임스페이스를 3개로 분리 (관리를 위해)
    private static final String LEGACY_MAPPER = "mapper.CourseMapper"; // 기존
    private static final String COMMUNITY_MAPPER = "mapper.CommunityCourseMapper"; // 신규
    private static final String OFFICIAL_MAPPER = "mapper.OfficialCourseMapper"; // 신규

    /**
     * @deprecated 이전 버전의 단순 검색 메서드
     */
    @Deprecated
    public List<Course> searchCourses(Map<String, Object> params) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(LEGACY_MAPPER + ".searchCourses", params);
        }
    }

    // --- (이하 새로운 메서드들) ---

    /**
     * 1. (신규) 커뮤니티 코스 목록 (페이징 적용됨)
     */
    public List<CommunityCourse> selectCommunityCourses(Map<String, Object> params) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(COMMUNITY_MAPPER + ".selectCommunityCourses", params);
        }
    }

    /**
     * 2. (신규) 커뮤니티 코스 전체 개수 (페이징용)
     */
    public int countCommunityCourses(Map<String, Object> params) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Integer count = session.selectOne(COMMUNITY_MAPPER + ".countCommunityCourses", params);
            return (count == null) ? 0 : count; // Null 체크
        }
    }

    /**
     * 3. (신규) 추천 코스(운영자) 목록
     */
    public List<OfficialCourse> selectOfficialCourses() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(OFFICIAL_MAPPER + ".selectOfficialCourses");
        }
    }

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

    // --- CourseService에서 필요한 메서드들 ---
    
    /**
     * 코스 상세 정보 조회 (CourseService.getCourseDetail에서 사용)
     */
    public CommunityCourse selectCourseDetail(int courseId) {
        return findDetailById(courseId);
    }

    /**
     * 코스 단계 목록 조회 (CourseService.getCourseSteps에서 사용)
     */
    public List<CourseStep> selectCourseSteps(int courseId) {
        return findStepsByCourseId(courseId);
    }

    /**
     * 코스와 단계를 함께 생성 (트랜잭션 포함)
     */
    public boolean insertCourseWithSteps(CommunityCourse course, List<CourseStep> steps) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            try {
                // 1. 코스 먼저 생성
                int courseResult = insertCourse(course, session);
                if (courseResult <= 0) {
                    return false;
                }

                // 2. 생성된 코스의 ID를 가져와서 각 단계에 설정
                int courseId = course.getId();
                for (int i = 0; i < steps.size(); i++) {
                    CourseStep step = steps.get(i);
                    step.setCourseId(courseId);
                    step.setOrder(i + 1); // 순서 설정
                    
                    int stepResult = insertCourseStep(step, session);
                    if (stepResult <= 0) {
                        return false;
                    }
                }

                // 3. 모든 작업이 성공하면 커밋
                session.commit();
                return true;
            } catch (Exception e) {
                // 오류 발생 시 롤백
                session.rollback();
                e.printStackTrace();
                return false;
            }
        }
    }
}