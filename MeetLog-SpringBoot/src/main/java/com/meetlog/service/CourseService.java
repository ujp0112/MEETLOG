package com.meetlog.service;

import com.meetlog.dto.course.CourseCreateRequest;
import com.meetlog.dto.course.CourseDto;
import com.meetlog.dto.course.CourseSearchRequest;
import com.meetlog.dto.course.CourseStepDto;
import com.meetlog.model.Course;
import com.meetlog.model.CourseStep;
import com.meetlog.repository.CourseRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Course Service
 * 코스 관련 비즈니스 로직
 */
@Service
@RequiredArgsConstructor
public class CourseService {

    private final CourseRepository courseRepository;

    /**
     * 코스 검색
     */
    @Transactional(readOnly = true)
    public Map<String, Object> searchCourses(CourseSearchRequest request, Long userId) {
        // 페이징 처리
        int page = (request.getPage() != null && request.getPage() > 0) ? request.getPage() : 1;
        int size = (request.getSize() != null && request.getSize() > 0) ? request.getSize() : 10;
        int offset = (page - 1) * size;

        request.setPage(offset);
        request.setSize(size);

        // 검색 실행
        List<CourseDto> courses = courseRepository.search(request, userId);

        // 각 코스의 단계와 태그 로드
        for (CourseDto course : courses) {
            List<CourseStep> steps = courseRepository.findStepsByCourseId(course.getCourseId());
            course.setSteps(steps.stream()
                    .map(this::convertToStepDto)
                    .collect(Collectors.toList()));

            List<String> tags = courseRepository.findTagsByCourseId(course.getCourseId());
            course.setTags(tags);
        }

        int totalCount = courseRepository.countSearch(request);
        int totalPages = (int) Math.ceil((double) totalCount / size);

        Map<String, Object> result = new HashMap<>();
        result.put("courses", courses);
        result.put("currentPage", page);
        result.put("totalPages", totalPages);
        result.put("totalCount", totalCount);
        result.put("pageSize", size);

        return result;
    }

    /**
     * 코스 상세 조회
     */
    @Transactional(readOnly = true)
    public CourseDto getCourse(Long id, Long userId) {
        CourseDto course = courseRepository.findDtoById(id, userId);
        if (course == null) {
            throw new RuntimeException("Course not found");
        }

        // 단계 로드
        List<CourseStep> steps = courseRepository.findStepsByCourseId(id);
        course.setSteps(steps.stream()
                .map(this::convertToStepDto)
                .collect(Collectors.toList()));

        // 태그 로드
        List<String> tags = courseRepository.findTagsByCourseId(id);
        course.setTags(tags);

        return course;
    }

    /**
     * 내 코스 목록 조회
     */
    @Transactional(readOnly = true)
    public List<CourseDto> getMyCourses(Long userId, int page, int size) {
        int offset = (page - 1) * size;
        List<Course> courses = courseRepository.findByAuthorId(userId, offset, size);

        return courses.stream()
                .map(c -> getCourse(c.getCourseId(), userId))
                .collect(Collectors.toList());
    }

    /**
     * 코스 생성
     */
    @Transactional
    public CourseDto createCourse(CourseCreateRequest request, Long userId) {
        // 코스 엔티티 생성
        Course course = Course.builder()
                .title(request.getTitle())
                .description(request.getDescription())
                .area(request.getArea())
                .duration(request.getDuration())
                .price(request.getPrice())
                .maxParticipants(request.getMaxParticipants())
                .status("PENDING")
                .type(request.getType())
                .previewImage(request.getPreviewImage())
                .authorId(userId)
                .build();

        // 코스 저장
        courseRepository.insert(course);
        Long courseId = course.getCourseId();

        // 단계 저장
        if (request.getSteps() != null && !request.getSteps().isEmpty()) {
            for (CourseCreateRequest.CourseStepCreateRequest stepReq : request.getSteps()) {
                CourseStep step = CourseStep.builder()
                        .courseId(courseId)
                        .stepOrder(stepReq.getStepOrder())
                        .stepType(stepReq.getStepType())
                        .emoji(stepReq.getEmoji())
                        .name(stepReq.getName())
                        .latitude(stepReq.getLatitude())
                        .longitude(stepReq.getLongitude())
                        .address(stepReq.getAddress())
                        .description(stepReq.getDescription())
                        .image(stepReq.getImage())
                        .time(stepReq.getTime())
                        .cost(stepReq.getCost())
                        .build();
                courseRepository.insertStep(step);
            }
        }

        // 태그 저장
        if (request.getTags() != null && !request.getTags().isEmpty()) {
            for (String tagName : request.getTags()) {
                Long tagId = courseRepository.findOrCreateTag(tagName);
                if (tagId == null) {
                    courseRepository.insertTag(tagName);
                    tagId = courseRepository.findOrCreateTag(tagName);
                }
                courseRepository.linkTag(courseId, tagId);
            }
        }

        return getCourse(courseId, userId);
    }

    /**
     * 코스 수정
     */
    @Transactional
    public CourseDto updateCourse(Long id, CourseCreateRequest request, Long userId) {
        Course course = courseRepository.findById(id);
        if (course == null) {
            throw new RuntimeException("Course not found");
        }

        // 권한 체크
        if (!course.canEdit(userId)) {
            throw new RuntimeException("No permission to edit this course");
        }

        // 코스 정보 업데이트
        course.setTitle(request.getTitle());
        course.setDescription(request.getDescription());
        course.setArea(request.getArea());
        course.setDuration(request.getDuration());
        course.setPrice(request.getPrice());
        course.setMaxParticipants(request.getMaxParticipants());
        course.setType(request.getType());
        course.setPreviewImage(request.getPreviewImage());

        courseRepository.update(course);

        // 기존 단계 삭제 후 재생성
        courseRepository.deleteStepsByCourseId(id);
        if (request.getSteps() != null && !request.getSteps().isEmpty()) {
            for (CourseCreateRequest.CourseStepCreateRequest stepReq : request.getSteps()) {
                CourseStep step = CourseStep.builder()
                        .courseId(id)
                        .stepOrder(stepReq.getStepOrder())
                        .stepType(stepReq.getStepType())
                        .emoji(stepReq.getEmoji())
                        .name(stepReq.getName())
                        .latitude(stepReq.getLatitude())
                        .longitude(stepReq.getLongitude())
                        .address(stepReq.getAddress())
                        .description(stepReq.getDescription())
                        .image(stepReq.getImage())
                        .time(stepReq.getTime())
                        .cost(stepReq.getCost())
                        .build();
                courseRepository.insertStep(step);
            }
        }

        // 기존 태그 연결 삭제 후 재생성
        courseRepository.unlinkTags(id);
        if (request.getTags() != null && !request.getTags().isEmpty()) {
            for (String tagName : request.getTags()) {
                Long tagId = courseRepository.findOrCreateTag(tagName);
                if (tagId == null) {
                    courseRepository.insertTag(tagName);
                    tagId = courseRepository.findOrCreateTag(tagName);
                }
                courseRepository.linkTag(id, tagId);
            }
        }

        return getCourse(id, userId);
    }

    /**
     * 코스 삭제
     */
    @Transactional
    public void deleteCourse(Long id, Long userId) {
        Course course = courseRepository.findById(id);
        if (course == null) {
            throw new RuntimeException("Course not found");
        }

        // 권한 체크
        if (!course.isOwnedBy(userId)) {
            throw new RuntimeException("No permission to delete this course");
        }

        courseRepository.delete(id);
    }

    /**
     * 코스 상태 변경
     */
    @Transactional
    public void updateStatus(Long id, String status) {
        Course course = courseRepository.findById(id);
        if (course == null) {
            throw new RuntimeException("Course not found");
        }

        courseRepository.updateStatus(id, status);
    }

    /**
     * 코스 좋아요
     */
    @Transactional
    public void likeCourse(Long id, Long userId) {
        Course course = courseRepository.findById(id);
        if (course == null) {
            throw new RuntimeException("Course not found");
        }

        boolean alreadyLiked = courseRepository.isLikedByUser(id, userId);
        if (alreadyLiked) {
            throw new RuntimeException("Already liked");
        }

        courseRepository.insertLike(id, userId);
    }

    /**
     * 코스 좋아요 취소
     */
    @Transactional
    public void unlikeCourse(Long id, Long userId) {
        Course course = courseRepository.findById(id);
        if (course == null) {
            throw new RuntimeException("Course not found");
        }

        boolean liked = courseRepository.isLikedByUser(id, userId);
        if (!liked) {
            throw new RuntimeException("Not liked yet");
        }

        courseRepository.deleteLike(id, userId);
    }

    /**
     * CourseStep 엔티티를 DTO로 변환
     */
    private CourseStepDto convertToStepDto(CourseStep step) {
        return CourseStepDto.builder()
                .stepId(step.getStepId())
                .courseId(step.getCourseId())
                .stepOrder(step.getStepOrder())
                .stepType(step.getStepType())
                .emoji(step.getEmoji())
                .name(step.getName())
                .latitude(step.getLatitude())
                .longitude(step.getLongitude())
                .address(step.getAddress())
                .description(step.getDescription())
                .image(step.getImage())
                .time(step.getTime())
                .cost(step.getCost())
                .build();
    }
}
