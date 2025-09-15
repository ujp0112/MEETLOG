package util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public class PasswordUtil {
	private static final String ALGORITHM = "SHA-256";
	private static final int SALT_LENGTH = 16;

	public static String hashPassword(String password) {
		try {
			SecureRandom random = new SecureRandom();
			byte[] salt = new byte[SALT_LENGTH];
			random.nextBytes(salt);

			MessageDigest md = MessageDigest.getInstance(ALGORITHM);
			md.update(salt);
			byte[] hashedPassword = md.digest(password.getBytes());

			byte[] combined = new byte[salt.length + hashedPassword.length];
			System.arraycopy(salt, 0, combined, 0, salt.length);
			System.arraycopy(hashedPassword, 0, combined, salt.length, hashedPassword.length);

			return Base64.getEncoder().encodeToString(combined);
		} catch (NoSuchAlgorithmException e) {
			throw new RuntimeException("해시 알고리즘을 찾을 수 없습니다.", e);
		}
	}

	public static boolean verifyPassword(String password, String hashedPassword) {
		try {
			byte[] combined = Base64.getDecoder().decode(hashedPassword);

			byte[] salt = new byte[SALT_LENGTH];
			System.arraycopy(combined, 0, salt, 0, SALT_LENGTH);

			MessageDigest md = MessageDigest.getInstance(ALGORITHM);
			md.update(salt);
			byte[] hashedInput = md.digest(password.getBytes());

			byte[] storedHash = new byte[combined.length - SALT_LENGTH];
			System.arraycopy(combined, SALT_LENGTH, storedHash, 0, storedHash.length);

			return MessageDigest.isEqual(hashedInput, storedHash);
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

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