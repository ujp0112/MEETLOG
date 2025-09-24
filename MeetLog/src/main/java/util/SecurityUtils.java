package util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * 보안 관련 유틸리티 클래스
 * XSS 방지, CSRF 보호, 입력 검증, 암호화 등을 담당
 */
public class SecurityUtils {

    private static final SecureRandom secureRandom = new SecureRandom();

    // 정규식 패턴들
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
        "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$"
    );

    private static final Pattern PHONE_PATTERN = Pattern.compile(
        "^01[0-9]-?[0-9]{3,4}-?[0-9]{4}$"
    );

    private static final Pattern PASSWORD_PATTERN = Pattern.compile(
        "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,20}$"
    );

    // XSS 방지를 위한 위험한 태그 및 스크립트 패턴
    private static final String[] XSS_PATTERNS = {
        "<script", "</script>", "javascript:", "onload=", "onerror=", "onclick=",
        "onmouseover=", "onfocus=", "onblur=", "onchange=", "onsubmit=",
        "eval\\(", "alert\\(", "confirm\\(", "prompt\\(", "document.cookie",
        "document.write", "window.location", "location.href"
    };

    /**
     * XSS 공격 방지를 위한 문자열 sanitization
     */
    public static String sanitizeXSS(String input) {
        if (input == null) return null;

        String sanitized = input;

        // HTML 특수문자 이스케이프
        sanitized = sanitized.replace("&", "&amp;");
        sanitized = sanitized.replace("<", "&lt;");
        sanitized = sanitized.replace(">", "&gt;");
        sanitized = sanitized.replace("\"", "&quot;");
        sanitized = sanitized.replace("'", "&#x27;");
        sanitized = sanitized.replace("/", "&#x2F;");

        // 위험한 패턴 제거
        for (String pattern : XSS_PATTERNS) {
            sanitized = sanitized.replaceAll("(?i)" + pattern, "");
        }

        return sanitized;
    }

    /**
     * SQL Injection 방지를 위한 문자열 sanitization
     */
    public static String sanitizeSQL(String input) {
        if (input == null) return null;

        String sanitized = input;

        // SQL 예약어 및 위험한 문자 제거
        sanitized = sanitized.replaceAll("(?i)(union|select|insert|update|delete|drop|create|alter|exec|execute)", "");
        sanitized = sanitized.replace("'", "''"); // 싱글 쿼트 이스케이프
        sanitized = sanitized.replace("--", ""); // SQL 주석 제거
        sanitized = sanitized.replace("/*", "").replace("*/", ""); // SQL 블록 주석 제거

        return sanitized;
    }

    /**
     * CSRF 토큰 생성
     */
    public static String generateCSRFToken() {
        byte[] randomBytes = new byte[32];
        secureRandom.nextBytes(randomBytes);
        return Base64.getEncoder().encodeToString(randomBytes);
    }

    /**
     * 세션에 CSRF 토큰 저장
     */
    public static void setCSRFToken(HttpSession session) {
        String token = generateCSRFToken();
        session.setAttribute("CSRF_TOKEN", token);
    }

    /**
     * CSRF 토큰 검증
     */
    public static boolean validateCSRFToken(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;

        String sessionToken = (String) session.getAttribute("CSRF_TOKEN");
        String requestToken = request.getParameter("csrfToken");

        if (sessionToken == null || requestToken == null) return false;

        return sessionToken.equals(requestToken);
    }

    /**
     * 이메일 주소 검증
     */
    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) return false;
        return EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    /**
     * 전화번호 검증
     */
    public static boolean isValidPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) return false;
        return PHONE_PATTERN.matcher(phone.replaceAll("[\\s-]", "")).matches();
    }

    /**
     * 비밀번호 강도 검증
     */
    public static boolean isValidPassword(String password) {
        if (password == null) return false;
        return PASSWORD_PATTERN.matcher(password).matches();
    }

    /**
     * 사업자 등록번호 검증
     */
    public static boolean isValidBusinessNumber(String businessNumber) {
        if (businessNumber == null) return false;

        String cleanNumber = businessNumber.replaceAll("[\\s-]", "");
        if (cleanNumber.length() != 10) return false;

        // 사업자등록번호 체크섬 검증
        try {
            int[] digits = new int[10];
            for (int i = 0; i < 10; i++) {
                digits[i] = Integer.parseInt(cleanNumber.substring(i, i + 1));
            }

            int[] multipliers = {1, 3, 7, 1, 3, 7, 1, 3, 5};
            int sum = 0;

            for (int i = 0; i < 9; i++) {
                sum += digits[i] * multipliers[i];
            }

            sum += (digits[8] * 5) / 10;
            int checkDigit = (10 - (sum % 10)) % 10;

            return checkDigit == digits[9];
        } catch (NumberFormatException e) {
            return false;
        }
    }

    /**
     * 문자열 길이 검증
     */
    public static boolean isValidLength(String input, int minLength, int maxLength) {
        if (input == null) return minLength == 0;
        return input.length() >= minLength && input.length() <= maxLength;
    }

    /**
     * 숫자 범위 검증
     */
    public static boolean isValidRange(int value, int min, int max) {
        return value >= min && value <= max;
    }

    /**
     * 파일 확장자 검증
     */
    public static boolean isValidFileExtension(String fileName, String[] allowedExtensions) {
        if (fileName == null || allowedExtensions == null) return false;

        String extension = getFileExtension(fileName);
        if (extension == null) return false;

        for (String allowed : allowedExtensions) {
            if (extension.equalsIgnoreCase(allowed)) {
                return true;
            }
        }
        return false;
    }

    /**
     * 파일 확장자 추출
     */
    public static String getFileExtension(String fileName) {
        if (fileName == null || fileName.isEmpty()) return null;

        int lastDotIndex = fileName.lastIndexOf(".");
        if (lastDotIndex == -1 || lastDotIndex == fileName.length() - 1) {
            return null;
        }

        return fileName.substring(lastDotIndex + 1);
    }

    /**
     * 비밀번호 해시화 (SHA-256 + Salt)
     */
    public static String hashPassword(String password, String salt) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt.getBytes());
            byte[] hashedPassword = md.digest(password.getBytes());

            StringBuilder hexString = new StringBuilder();
            for (byte b : hashedPassword) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();

        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 알고리즘을 찾을 수 없습니다.", e);
        }
    }

    /**
     * 랜덤 Salt 생성
     */
    public static String generateSalt() {
        byte[] saltBytes = new byte[16];
        secureRandom.nextBytes(saltBytes);
        return Base64.getEncoder().encodeToString(saltBytes);
    }

    /**
     * IP 주소 추출
     */
    public static String getClientIP(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");

        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }

        // 여러 IP가 있는 경우 첫 번째 IP 사용
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }

        return ip;
    }

    /**
     * User-Agent 정보 추출
     */
    public static String getUserAgent(HttpServletRequest request) {
        return request.getHeader("User-Agent");
    }

    /**
     * 브루트 포스 공격 방지를 위한 시도 횟수 체크
     */
    public static class BruteForceProtection {
        private static final java.util.Map<String, AttemptInfo> attemptMap =
            new java.util.concurrent.ConcurrentHashMap<>();

        private static final int MAX_ATTEMPTS = 5;
        private static final long LOCKOUT_TIME = 15 * 60 * 1000; // 15분

        public static boolean isBlocked(String identifier) {
            AttemptInfo info = attemptMap.get(identifier);
            if (info == null) return false;

            if (info.attempts >= MAX_ATTEMPTS) {
                long elapsed = System.currentTimeMillis() - info.lastAttempt;
                if (elapsed < LOCKOUT_TIME) {
                    return true;
                } else {
                    // 락아웃 시간 만료, 정보 초기화
                    attemptMap.remove(identifier);
                    return false;
                }
            }
            return false;
        }

        public static void recordFailedAttempt(String identifier) {
            AttemptInfo info = attemptMap.computeIfAbsent(identifier, k -> new AttemptInfo());
            info.attempts++;
            info.lastAttempt = System.currentTimeMillis();
        }

        public static void recordSuccessfulAttempt(String identifier) {
            attemptMap.remove(identifier);
        }

        private static class AttemptInfo {
            int attempts = 0;
            long lastAttempt = System.currentTimeMillis();
        }
    }

    /**
     * 데이터 검증 결과 클래스
     */
    public static class ValidationResult {
        private boolean valid;
        private String errorMessage;

        public ValidationResult(boolean valid, String errorMessage) {
            this.valid = valid;
            this.errorMessage = errorMessage;
        }

        public static ValidationResult success() {
            return new ValidationResult(true, null);
        }

        public static ValidationResult failure(String message) {
            return new ValidationResult(false, message);
        }

        public boolean isValid() { return valid; }
        public String getErrorMessage() { return errorMessage; }
    }

    /**
     * 종합적인 사용자 입력 검증
     */
    public static ValidationResult validateUserInput(String name, String email, String phone, String password) {
        // 이름 검증
        if (!isValidLength(name, 2, 20)) {
            return ValidationResult.failure("이름은 2-20자 사이여야 합니다.");
        }

        // 이메일 검증
        if (!isValidEmail(email)) {
            return ValidationResult.failure("올바른 이메일 형식이 아닙니다.");
        }

        // 전화번호 검증
        if (phone != null && !phone.trim().isEmpty() && !isValidPhone(phone)) {
            return ValidationResult.failure("올바른 전화번호 형식이 아닙니다.");
        }

        // 비밀번호 검증
        if (password != null && !isValidPassword(password)) {
            return ValidationResult.failure("비밀번호는 8-20자, 대소문자, 숫자, 특수문자를 각각 1개 이상 포함해야 합니다.");
        }

        return ValidationResult.success();
    }
}