package util; // PasswordUtil과 같은 패키지에 만들면 import가 필요 없습니다.

public class GeneratePassword {
    public static void main(String[] args) {
        // 원하는 비밀번호를 여기에 입력하세요.
        String passwordToHash = "admin123";

        // 프로젝트의 PasswordUtil 클래스를 사용하여 비밀번호를 해시합니다.
        String hashedPassword = PasswordUtil.hashPassword(passwordToHash);

        // 생성된 해시 값을 콘솔에 출력합니다.
        System.out.println("생성된 암호화 비밀번호: " + hashedPassword);
    }
}