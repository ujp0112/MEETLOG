package util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Objects;

public class PasswordUtil {

    private static final String CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    private static final SecureRandom RANDOM = new SecureRandom();
    private static final int DEFAULT_TEMP_PASSWORD_LENGTH = 8;

    /**
     * 지정된 길이의 임시 비밀번호를 생성합니다.
     * @param length 생성할 비밀번호의 길이
     * @return 생성된 임시 비밀번호
     */
    public static String generateTemporaryPassword(int length) { // FindAccountServlet에서 사용
        StringBuilder password = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            password.append(CHARACTERS.charAt(RANDOM.nextInt(CHARACTERS.length())));
        }
        return password.toString();
    }
    
    /**
     * 기본 길이(8자)의 임시 비밀번호를 생성합니다. (기존 UserService와의 호환성을 위해 유지)
     * @return 생성된 임시 비밀번호
     */
    public static String generateTempPassword() { // 기존 UserService에서 사용
        return generateTemporaryPassword(DEFAULT_TEMP_PASSWORD_LENGTH);
    }

    /**
     * 비밀번호를 SHA-256으로 해싱합니다. (실제 서비스에서는 BCrypt 권장)
     * @param password 해싱할 원본 비밀번호
     * @return 해싱된 비밀번호 문자열
     */
    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            // SHA-256은 기본 알고리즘이므로 이 예외가 발생할 가능성은 거의 없습니다.
            // 하지만 발생 시, 시스템이 더 이상 동작할 수 없음을 의미하므로 RuntimeException으로 처리합니다.
            throw new RuntimeException("SHA-256 hashing algorithm not found", e);
        }
    }
    
    /**
     * 입력된 비밀번호와 해싱된 비밀번호가 일치하는지 확인합니다.
     */
    public static boolean verifyPassword(String rawPassword, String hashedPassword) {
        String newHashedPassword = hashPassword(rawPassword);
        return Objects.equals(newHashedPassword, hashedPassword);
    }
}