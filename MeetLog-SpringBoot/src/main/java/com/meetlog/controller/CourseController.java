package com.meetlog.controller;

import com.meetlog.dto.course.CourseCreateRequest;
import com.meetlog.dto.course.CourseDto;
import com.meetlog.dto.course.CourseSearchRequest;
import com.meetlog.security.CustomUserDetails;
import com.meetlog.service.CourseService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;
import java.util.Map;

@Tag(name = "Course", description = "코스 API")
@RestController
@RequestMapping("/api/courses")
@RequiredArgsConstructor
public class CourseController {

    private final CourseService courseService;

    @Operation(summary = "코스 검색", description = "키워드, 지역, 타입 등으로 코스를 검색합니다.")
    @GetMapping
    public ResponseEntity<Map<String, Object>> searchCourses(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String area,
            @RequestParam(required = false) String type,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) Long authorId,
            @RequestParam(required = false) Integer minPrice,
            @RequestParam(required = false) Integer maxPrice,
            @RequestParam(required = false) String tag,
            @RequestParam(required = false, defaultValue = "created_at") String sortBy,
            @RequestParam(required = false, defaultValue = "desc") String sortOrder,
            @RequestParam(required = false, defaultValue = "1") Integer page,
            @RequestParam(required = false, defaultValue = "10") Integer size,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        CourseSearchRequest request = CourseSearchRequest.builder()
                .keyword(keyword)
                .area(area)
                .type(type)
                .status(status)
                .authorId(authorId)
                .minPrice(minPrice)
                .maxPrice(maxPrice)
                .tag(tag)
                .sortBy(sortBy)
                .sortOrder(sortOrder)
                .page(page)
                .size(size)
                .build();

        Long userId = userDetails != null ? userDetails.getUserId() : null;
        Map<String, Object> result = courseService.searchCourses(request, userId);
        return ResponseEntity.ok(result);
    }

    @Operation(summary = "코스 상세 조회", description = "코스 ID로 상세 정보를 조회합니다.")
    @GetMapping("/{id}")
    public ResponseEntity<CourseDto> getCourse(
            @PathVariable Long id,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        Long userId = userDetails != null ? userDetails.getUserId() : null;
        CourseDto course = courseService.getCourse(id, userId);
        return ResponseEntity.ok(course);
    }

    @Operation(summary = "내 코스 목록", description = "현재 로그인한 사용자가 작성한 코스 목록을 조회합니다.")
    @GetMapping("/my")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<List<CourseDto>> getMyCourses(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @RequestParam(required = false, defaultValue = "1") Integer page,
            @RequestParam(required = false, defaultValue = "10") Integer size
    ) {
        List<CourseDto> courses = courseService.getMyCourses(userDetails.getUserId(), page, size);
        return ResponseEntity.ok(courses);
    }

    @Operation(summary = "코스 생성", description = "새 코스를 생성합니다.")
    @PostMapping
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<CourseDto> createCourse(
            @Valid @RequestBody CourseCreateRequest request,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        CourseDto course = courseService.createCourse(request, userDetails.getUserId());
        return ResponseEntity.ok(course);
    }

    @Operation(summary = "코스 수정", description = "코스를 수정합니다. (작성자만 가능)")
    @PutMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<CourseDto> updateCourse(
            @PathVariable Long id,
            @Valid @RequestBody CourseCreateRequest request,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        CourseDto course = courseService.updateCourse(id, request, userDetails.getUserId());
        return ResponseEntity.ok(course);
    }

    @Operation(summary = "코스 삭제", description = "코스를 삭제합니다. (작성자만 가능)")
    @DeleteMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Void> deleteCourse(
            @PathVariable Long id,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        courseService.deleteCourse(id, userDetails.getUserId());
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "코스 상태 변경", description = "코스 상태를 변경합니다. (관리자만 가능)")
    @PatchMapping("/{id}/status")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> updateStatus(
            @PathVariable Long id,
            @RequestParam String status
    ) {
        courseService.updateStatus(id, status);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "코스 좋아요", description = "코스에 좋아요를 추가합니다.")
    @PostMapping("/{id}/like")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Void> likeCourse(
            @PathVariable Long id,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        courseService.likeCourse(id, userDetails.getUserId());
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "코스 좋아요 취소", description = "코스 좋아요를 취소합니다.")
    @DeleteMapping("/{id}/like")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Void> unlikeCourse(
            @PathVariable Long id,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        courseService.unlikeCourse(id, userDetails.getUserId());
        return ResponseEntity.noContent().build();
    }
}
