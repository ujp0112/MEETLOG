package util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public class PasswordUtil {
	private static final String ALGORITHM = "SHA-256";
	private static final int SALT_LENGTH = 16;

	/**
	 * 비밀번호와 Salt를 결합하여 SHA-256 해시를 생성하고 Base64로 인코딩합니다.
	 * 
	 * @param password 평문 비밀번호
	 * @return Salt가 포함된 Base64 인코딩 해시 문자열
	 */
	public static String hashPassword(String password) {
		if (password == null || password.trim().isEmpty()) {
			throw new IllegalArgumentException("비밀번호는 null이거나 비어있을 수 없습니다.");
		}

		try {
			SecureRandom random = new SecureRandom();
			byte[] salt = new byte[SALT_LENGTH];
			random.nextBytes(salt);

			MessageDigest md = MessageDigest.getInstance(ALGORITHM);
			md.update(salt);

			// 👇 [수정] 인코딩 방식을 UTF-8로 명시
			byte[] hashedPassword = md.digest(password.getBytes(StandardCharsets.UTF_8));

			byte[] combined = new byte[salt.length + hashedPassword.length];
			System.arraycopy(salt, 0, combined, 0, salt.length);
			System.arraycopy(hashedPassword, 0, combined, salt.length, hashedPassword.length);

			return Base64.getEncoder().encodeToString(combined);
		} catch (NoSuchAlgorithmException e) {
			throw new RuntimeException("SHA-256 해시 알고리즘을 찾을 수 없습니다.", e);
		}
	}

	/**
	 * 입력된 평문 비밀번호와 저장된 해시를 비교하여 일치 여부를 확인합니다.
	 * 
	 * @param plainPassword  사용자가 입력한 평문 비밀번호
	 * @param hashedPassword 데이터베이스에 저장된 해시 문자열
	 * @return 비밀번호 일치 여부 (true/false)
	 */
	public static boolean verifyPassword(String plainPassword, String hashedPassword) {
		if (plainPassword == null || plainPassword.trim().isEmpty() || hashedPassword == null
				|| hashedPassword.trim().isEmpty()) {
			return false;
		}

		try {
			byte[] combined = Base64.getDecoder().decode(hashedPassword);

			if (combined.length < SALT_LENGTH) {
				return false; // 해시 길이가 Salt 길이보다 짧으면 유효하지 않음
			}

			byte[] salt = new byte[SALT_LENGTH];
			System.arraycopy(combined, 0, salt, 0, SALT_LENGTH);

			byte[] storedHash = new byte[combined.length - SALT_LENGTH];
			System.arraycopy(combined, SALT_LENGTH, storedHash, 0, storedHash.length);

			MessageDigest md = MessageDigest.getInstance(ALGORITHM);
			md.update(salt);

			// 👇 [수정] 인코딩 방식을 UTF-8로 명시 (hashPassword와 동일하게)
			byte[] hashedInput = md.digest(plainPassword.getBytes(StandardCharsets.UTF_8));

			return MessageDigest.isEqual(hashedInput, storedHash);
		} catch (Exception e) {
			return false;
		}
	}

	/**
	 * 임시 비밀번호를 생성합니다.
	 * 
	 * @return 8자리의 랜덤 문자열
	 */
	public static String generateTempPassword() {
		String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
		SecureRandom random = new SecureRandom();
		StringBuilder password = new StringBuilder(8);
		for (int i = 0; i < 8; i++) {
			password.append(chars.charAt(random.nextInt(chars.length())));
		}
		return password.toString();
	}
}