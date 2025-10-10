package util;

public class EmailUtil {

    /**
     * 이메일을 발송하는 메소드 (실제 구현에서는 JavaMail API 등을 사용)
     * 여기서는 테스트를 위해 콘솔에 출력합니다.
     * @param to 수신자 이메일 주소
     * @param subject 제목
     * @param body 내용
     */
    public static void sendEmail(String to, String subject, String body) {
        System.out.println("--- 이메일 발송 시뮬레이션 ---");
        System.out.println("수신자: " + to);
        System.out.println("제목: " + subject);
        System.out.println("내용:\n" + body);
        System.out.println("--------------------------");
    }
}