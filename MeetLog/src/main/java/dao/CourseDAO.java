package dao;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;

// [필수] 필요한 모델 클래스들을 import 합니다.
import model.Course; 
import model.CommunityCourse;
import model.OfficialCourse;

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
}