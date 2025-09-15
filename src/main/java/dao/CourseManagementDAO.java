package dao;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import model.AdminCourse;
import util.MyBatisSqlSessionFactory;

public class CourseManagementDAO {
    private static final String NAMESPACE = "mapper.CourseManagementMapper.";

    /**
     * 관리자용 모든 코스 목록을 DB에서 조회합니다.
     * @return AdminCourse 목록
     */
    public List<AdminCourse> selectAllCoursesForAdmin() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(NAMESPACE + "selectAllCoursesForAdmin");
        }
    }
    
    /**
     * 새로운 코스를 DB에 삽입합니다.
     * @param course 삽입할 코스 객체
     */
    public void insertCourse(AdminCourse course) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            session.insert(NAMESPACE + "insertCourse", course);
        }
    }

    /**
     * 코스 정보를 DB에서 수정합니다.
     * @param course 수정할 코스 객체
     */
    public void updateCourse(AdminCourse course) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            session.update(NAMESPACE + "updateCourse", course);
        }
    }
    
    /**
     * 코스를 DB에서 삭제합니다.
     * @param courseId 삭제할 코스 ID
     */
    public void deleteCourse(int courseId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            session.delete(NAMESPACE + "deleteCourse", courseId);
        }
    }
}