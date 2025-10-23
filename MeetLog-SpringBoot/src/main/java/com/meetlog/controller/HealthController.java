package com.meetlog.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * Health Check Controller
 */
@Tag(name = "Health", description = "서버 상태 확인 API")
@RestController
@RequestMapping("/health")
public class HealthController {

	@Operation(summary = "서버 상태 확인", description = "서버가 정상적으로 동작하는지 확인합니다.")
	@GetMapping
	public ResponseEntity<Map<String, Object>> healthCheck() {
		Map<String, Object> response = new HashMap<>();
		response.put("status", "UP");
		response.put("timestamp", LocalDateTime.now());
		response.put("service", "MeetLog API");
		response.put("version", "1.0.0");
		return ResponseEntity.ok(response);
	}
}
