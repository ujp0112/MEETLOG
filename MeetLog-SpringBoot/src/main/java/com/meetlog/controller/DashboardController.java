package com.meetlog.controller;

import com.meetlog.dto.dashboard.AdminDashboardDto;
import com.meetlog.dto.dashboard.BusinessDashboardDto;
import com.meetlog.security.CustomUserDetails;
import com.meetlog.service.AdminDashboardService;
import com.meetlog.service.BusinessDashboardService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@Tag(name = "Dashboard", description = "대시보드 API")
@RestController
@RequestMapping("/api/dashboard")
@RequiredArgsConstructor
public class DashboardController {

    private final AdminDashboardService adminDashboardService;
    private final BusinessDashboardService businessDashboardService;

    @Operation(summary = "관리자 대시보드", description = "관리자 전용 대시보드 통계를 조회합니다.")
    @GetMapping("/admin")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<AdminDashboardDto> getAdminDashboard() {
        AdminDashboardDto dashboard = adminDashboardService.getAdminDashboard();
        return ResponseEntity.ok(dashboard);
    }

    @Operation(summary = "비즈니스 대시보드", description = "레스토랑 사업자 대시보드 통계를 조회합니다.")
    @GetMapping("/business/{restaurantId}")
    @PreAuthorize("hasAnyRole('BUSINESS', 'ADMIN')")
    public ResponseEntity<BusinessDashboardDto> getBusinessDashboard(
            @PathVariable Long restaurantId,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        BusinessDashboardDto dashboard = businessDashboardService.getBusinessDashboard(
                restaurantId,
                userDetails.getUserId()
        );
        return ResponseEntity.ok(dashboard);
    }
}
