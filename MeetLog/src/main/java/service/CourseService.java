package service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import dao.CourseDAO;

import model.CommunityCourse;
import model.OfficialCourse;
import model.CourseStep;
import model.Paging; 

public class CourseService {
    
    private CourseDAO courseDAO = new CourseDAO();

    public boolean createCourseWithSteps(CommunityCourse course, List<CourseStep> steps) {
        int courseResult = courseDAO.insertCourse(course);
        
        if (courseResult > 0) {
            int generatedCourseId = course.getId();
            
            for (int i = 0; i < steps.size(); i++) {
                CourseStep step = steps.get(i);
                step.setCourseId(generatedCourseId);
                step.setOrder(i + 1); // 순서 설정
                courseDAO.insertCourseStep(step);
            }
            return true;
        }
        return false;
    }

    public CommunityCourse getCourseDetail(int courseId) {
        return courseDAO.findDetailById(courseId);
    }
    
    /**
     * [추가] 특정 코스의 경로(steps) 목록을 조회하는 서비스 메소드
     * @param courseId 코스 ID
     * @return 해당 코스의 경로 목록
     */
    public List<CourseStep> getCourseSteps(int courseId) {
        return courseDAO.findStepsByCourseId(courseId);
    }

    public List<CommunityCourse> getCommunityCourses(String query, String area, int page) {
        Map<String, Object> params = new HashMap<>();
        params.put("query", query);
        params.put("area", area);
        
        Paging paging = getCommunityCoursePaging(query, area, page);
        
        params.put("offset", paging.getOffset());
        params.put("itemsPerPage", paging.getItemsPerPage());
        
        return courseDAO.selectCommunityCourses(params);
    }

    public Paging getCommunityCoursePaging(String query, String area, int page) {
        Map<String, Object> params = new HashMap<>();
        params.put("query", query);
        params.put("area", area);

        int totalCount = courseDAO.countCommunityCourses(params);
        int itemsPerPage = 6;
        int pagesPerBlock = 5;
        
        return new Paging(totalCount, itemsPerPage, page, pagesPerBlock);
    }

    public List<OfficialCourse> getOfficialCourses() {
        return courseDAO.selectOfficialCourses();
    }
}