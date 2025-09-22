package service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import dao.CourseDAO;

// [필수] 필요한 모델 클래스들을 import 합니다.
import model.Course;
import model.CommunityCourse;
import model.OfficialCourse;
import model.Paging;
import model.CourseStep; 

/**
 * 사용자용 코스 서비스 (신규 JSP에 맞게 수정됨)
 */
public class CourseService {
    
    private CourseDAO courseDAO = new CourseDAO(); // DAO 객체

    /**
     * @deprecated 이전 버전의 서블릿에서 사용되던 메서드입니다.
     */
    @Deprecated
    public List<Course> searchCourses(Map<String, Object> params) {
        // ... (이전 코드와 동일) ...
        return courseDAO.searchCourses(params); 
    }

    // --- (이하 새로운 메서드들) ---

    /**
     * 1. (새로 추가) 커뮤니티 코스 목록 (페이징 적용됨)
     */
    public List<CommunityCourse> getCommunityCourses(String query, String area, int page) {
        
        // 페이징 처리를 위한 Map 생성
        Map<String, Object> params = new HashMap<>();
        params.put("query", query);
        params.put("area", area);
        
        // Paging 객체 생성
        Paging paging = getCommunityCoursePaging(query, area, page);
        
        // SQL의 OFFSET, LIMIT 값을 Map에 추가
        params.put("offset", paging.getOffset());
        params.put("itemsPerPage", paging.getItemsPerPage());
        
        // DAO의 새 메서드 호출
        return courseDAO.selectCommunityCourses(params);
    }

    /**
     * 2. (새로 추가) 커뮤니티 코스용 페이지네이션 객체 생성
     */
    public Paging getCommunityCoursePaging(String query, String area, int page) {
        
        Map<String, Object> params = new HashMap<>();
        params.put("query", query);
        params.put("area", area);

        // DAO의 새 메서드를 호출하여 전체 개수 확인
        int totalCount = courseDAO.countCommunityCourses(params);
        
        int itemsPerPage = 6; // JSP 디자인에 6개씩 표시
        int pagesPerBlock = 5; // 하단에 표시할 페이지 번호 개수
        
        // Paging 객체를 생성하여 반환
        return new Paging(totalCount, itemsPerPage, page, pagesPerBlock);
    }

    /**
     * 3. (새로 추가) 추천 코스(운영자) 목록
     */
    public List<OfficialCourse> getOfficialCourses() {
        // DAO의 새 메서드 호출
        return courseDAO.selectOfficialCourses();
    }

    /**
     * 4. (새로 추가) 코스 상세 정보 조회
     */
    public CommunityCourse getCourseDetail(int courseId) {
        return courseDAO.selectCourseDetail(courseId);
    }

    /**
     * 5. (새로 추가) 코스 단계 목록 조회
     */
    public List<CourseStep> getCourseSteps(int courseId) {
        return courseDAO.selectCourseSteps(courseId);
    }

    /**
     * 6. (새로 추가) 코스와 단계를 함께 생성
     */
    public boolean createCourseWithSteps(CommunityCourse course, List<CourseStep> steps) {
        return courseDAO.insertCourseWithSteps(course, steps);
    }
}