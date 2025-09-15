package service;

import java.util.List;
import dao.CourseManagementDAO;
import model.AdminCourse;

public class CourseManagementService {
    private CourseManagementDAO courseDAO = new CourseManagementDAO();

    /**
     * 관리자 페이지의 모든 코스 목록을 가져옵니다.
     * @return AdminCourse 목록
     */
    public List<AdminCourse> getAllCoursesForAdmin() {
        return courseDAO.selectAllCoursesForAdmin();
    }
    
    /**
     * 새로운 코스를 DB에 추가합니다.
     * @param course 추가할 코스 정보
     */
    public void addCourse(AdminCourse course) {
        courseDAO.insertCourse(course);
    }
    
    /**
     * 기존 코스 정보를 수정합니다.
     * @param course 수정할 코스 정보
     */
    public void updateCourse(AdminCourse course) {
        courseDAO.updateCourse(course);
    }
    
    /**
     * ID에 해당하는 코스를 삭제합니다.
     * @param courseId 삭제할 코스 ID
     */
    public void deleteCourse(int courseId) {
        courseDAO.deleteCourse(courseId);
    }
}