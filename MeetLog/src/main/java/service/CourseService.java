package service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession; // SqlSession import
import util.MyBatisSqlSessionFactory;      // SqlSessionFactory import
import dao.CourseDAO;
import model.CommunityCourse;
import model.OfficialCourse;
import model.CourseStep;
import model.Paging; 

public class CourseService {
    
    private CourseDAO courseDAO = new CourseDAO();

    /**
     * [수정] 코스와 경로들을 하나의 트랜잭션으로 묶어 처리하는 메소드
     */
    public boolean createCourseWithSteps(CommunityCourse course, List<CourseStep> steps) {
        SqlSession session = MyBatisSqlSessionFactory.getSqlSession();
        try {
            // 1. 코스 정보 저장
            courseDAO.insertCourse(course, session);
            
            // 2. 방금 생성된 코스의 ID를 가져옴
            int generatedCourseId = course.getId(); 
            
            // 3. 각 경로(Step)에 코스 ID를 설정하고 순서대로 저장
            for (int i = 0; i < steps.size(); i++) {
                CourseStep step = steps.get(i);
                step.setCourseId(generatedCourseId);
                step.setOrder(i + 1);
                courseDAO.insertCourseStep(step, session);
            }

            // 4. 태그 저장
            if (course.getTags() != null && !course.getTags().isEmpty()) {
                for (String tagName : course.getTags()) {
                    if (tagName != null && !tagName.trim().isEmpty()) {
                        // 태그가 이미 존재하는지 확인
                        Integer tagId = courseDAO.findTagByName(tagName.trim(), session);
                        if (tagId == null) {
                            // 태그가 없으면 새로 생성
                            tagId = courseDAO.insertTag(tagName.trim(), session);
                        }
                        // 코스-태그 연결
                        courseDAO.insertCourseTag(generatedCourseId, tagId, session);
                    }
                }
            }

            // 5. 모든 작업이 성공하면 최종 commit
            session.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            // 5. 중간에 오류가 발생하면 모든 작업을 취소 (rollback)
            session.rollback();
            return false;
        } finally {
            // 6. 작업이 끝나면 세션을 닫아줌
            session.close();
        }
    }

    public CommunityCourse getCourseDetail(int courseId) {
        return courseDAO.findDetailById(courseId);
    }
    
    public List<CourseStep> getCourseSteps(int courseId) {
        return courseDAO.findStepsByCourseId(courseId);
    }

    /**
     * 코스 좋아요 토글 (좋아요/취소)
     */
    public boolean toggleCourseLike(int userId, int courseId) {
        SqlSession session = MyBatisSqlSessionFactory.getSqlSession();
        try {
            // 현재 좋아요 상태 확인
            Map<String, Object> params = new HashMap<>();
            params.put("userId", userId);
            params.put("courseId", courseId);
            
            Integer count = session.selectOne("mapper.CommunityCourseMapper.checkCourseLike", params);
            boolean isLiked = (count != null && count > 0);
            
            if (isLiked) {
                // 좋아요 취소
                session.delete("mapper.CommunityCourseMapper.deleteCourseLike", params);
            } else {
                // 좋아요 추가
                session.insert("mapper.CommunityCourseMapper.insertCourseLike", params);
            }
            
            session.commit();
            return !isLiked; // 새로운 상태 반환
        } catch (Exception e) {
            session.rollback();
            throw new RuntimeException("코스 좋아요 토글 처리 중 오류", e);
        } finally {
            session.close();
        }
    }

    /**
     * 코스 좋아요 개수 조회
     */
    public int getCourseLikeCount(int courseId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Integer count = session.selectOne("mapper.CommunityCourseMapper.getCourseLikeCount", courseId);
            return (count != null) ? count : 0;
        }
    }

    /**
     * 사용자의 코스 좋아요 여부 확인
     */
    public boolean isCourseLiked(int userId, int courseId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("userId", userId);
            params.put("courseId", courseId);
            
            Integer count = session.selectOne("mapper.CommunityCourseMapper.checkCourseLike", params);
            return (count != null && count > 0);
        }
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

    // --- 사용자별 코스 관리 메소드들 ---

    public List<CommunityCourse> getCoursesByUserId(int userId) {
        // 사용자가 생성한 커뮤니티 코스들을 조회
        return courseDAO.findByUserId(userId);
    }

    public List<CommunityCourse> getBookmarkedCourses(int userId) {
        // 사용자가 북마크한 코스들을 조회
        // 임시로 빈 리스트 반환 (실제 구현 필요)
        return new java.util.ArrayList<>();
    }

    public boolean toggleCourseBookmark(int userId, int courseId) {
        // 코스 북마크 토글
        // 임시로 true 반환 (실제 구현 필요)
        return true;
    }

    public boolean deleteCourse(int courseId, int userId) {
        // 코스 삭제 (권한 확인 포함)
        SqlSession session = MyBatisSqlSessionFactory.getSqlSession();
        try {
            // 1. 권한 확인 - 해당 코스의 작성자가 맞는지 확인
            CommunityCourse course = courseDAO.findById(courseId);
            if (course == null) {
                return false;
            }
            if (course.getUserId() != userId) {
                // 권한이 없음
                return false;
            }

            // 2. 코스 삭제 (CASCADE로 steps, likes 등도 자동 삭제됨)
            int result = session.delete("mapper.CommunityCourseMapper.deleteCourse", courseId);

            if (result > 0) {
                session.commit();
                return true;
            } else {
                session.rollback();
                return false;
            }
        } catch (Exception e) {
            session.rollback();
            e.printStackTrace();
            return false;
        } finally {
            session.close();
        }
    }

    public CommunityCourse getCourseById(int courseId) {
        return courseDAO.findById(courseId);
    }

    /**
     * 코스와 경로를 업데이트하는 메소드
     */
    public boolean updateCourseWithSteps(CommunityCourse course, List<CourseStep> steps) {
        SqlSession session = MyBatisSqlSessionFactory.getSqlSession();
        try {
            // 1. 코스 정보 업데이트
            courseDAO.updateCourse(course, session);

            // 2. 기존 경로들 삭제
            courseDAO.deleteCourseStepsByCourseId(course.getId(), session);

            // 3. 새로운 경로들 삽입
            for (int i = 0; i < steps.size(); i++) {
                CourseStep step = steps.get(i);
                step.setCourseId(course.getId());
                step.setOrder(i + 1);
                courseDAO.insertCourseStep(step, session);
            }

            // 4. 기존 태그들 삭제
            courseDAO.deleteCourseTagsByCourseId(course.getId(), session);

            // 5. 새로운 태그들 저장
            if (course.getTags() != null && !course.getTags().isEmpty()) {
                for (String tagName : course.getTags()) {
                    if (tagName != null && !tagName.trim().isEmpty()) {
                        // 태그가 이미 존재하는지 확인
                        Integer tagId = courseDAO.findTagByName(tagName.trim(), session);
                        if (tagId == null) {
                            // 태그가 없으면 새로 생성
                            tagId = courseDAO.insertTag(tagName.trim(), session);
                        }
                        // 코스-태그 연결
                        courseDAO.insertCourseTag(course.getId(), tagId, session);
                    }
                }
            }

            session.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            session.rollback();
            return false;
        } finally {
            session.close();
        }
    }
}
