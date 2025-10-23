package com.meetlog.repository;

import com.meetlog.dto.course.CourseDto;
import com.meetlog.dto.course.CourseSearchRequest;
import com.meetlog.model.Course;
import com.meetlog.model.CourseStep;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * Course Repository Interface
 * MyBatis 매퍼와 연동
 */
@Mapper
public interface CourseRepository {

    // Course CRUD
    Course findById(@Param("id") Long id);
    CourseDto findDtoById(@Param("id") Long id, @Param("userId") Long userId);
    List<CourseDto> search(@Param("request") CourseSearchRequest request, @Param("userId") Long userId);
    int countSearch(@Param("request") CourseSearchRequest request);
    int insert(Course course);
    int update(Course course);
    int delete(@Param("id") Long id);
    int updateStatus(@Param("id") Long id, @Param("status") String status);
    List<Course> findByAuthorId(@Param("authorId") Long authorId, @Param("page") int page, @Param("size") int size);

    // CourseStep CRUD
    CourseStep findStepById(@Param("stepId") Long stepId);
    List<CourseStep> findStepsByCourseId(@Param("courseId") Long courseId);
    int insertStep(CourseStep step);
    int updateStep(CourseStep step);
    int deleteStep(@Param("stepId") Long stepId);
    int deleteStepsByCourseId(@Param("courseId") Long courseId);

    // Tags
    List<String> findTagsByCourseId(@Param("courseId") Long courseId);
    Long findOrCreateTag(@Param("name") String name);
    int insertTag(@Param("name") String name);
    int linkTag(@Param("courseId") Long courseId, @Param("tagId") Long tagId);
    int unlinkTags(@Param("courseId") Long courseId);

    // Likes
    int countLikes(@Param("courseId") Long courseId);
    boolean isLikedByUser(@Param("courseId") Long courseId, @Param("userId") Long userId);
    int insertLike(@Param("courseId") Long courseId, @Param("userId") Long userId);
    int deleteLike(@Param("courseId") Long courseId, @Param("userId") Long userId);

    // Statistics
    int countReservations(@Param("courseId") Long courseId);
    int countComments(@Param("courseId") Long courseId);
}
