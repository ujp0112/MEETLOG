package util;

import java.util.Properties;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;

import javax.mail.internet.MimeMessage;

public class EmailUtil {

    // 이메일 발송을 위한 비동기 스레드 풀 (애플리케이션 생명주기 동안 유지)
    private static final ExecutorService emailExecutor = Executors.newFixedThreadPool(2);

    /**
     * 이메일을 발송하는 메소드. 실제 이메일 발송과 콘솔 로깅을 모두 수행합니다.
     * @param to 수신자 이메일 주소
     * @param subject 제목
     * @param body 내용
     */
    public static void sendEmail(String to, String subject, String body) {
        // --- 1. 디버깅을 위한 동기적 로그 출력 ---
        System.out.println("--- 이메일 발송 시뮬레이션 ---");
        System.out.println("수신자: " + to);
        System.out.println("제목: " + subject);
        System.out.println("내용:\n" + body);
        System.out.println("--------------------------");

        // --- 2. 실제 이메일 발송은 비동기로 처리하여 웹 응답 속도 향상 ---
        emailExecutor.submit(() -> {
            try {
                final String host = AppConfigListener.getApiKey("mail.smtp.host");
                final String port = AppConfigListener.getApiKey("mail.smtp.port");
                final String username = AppConfigListener.getApiKey("mail.smtp.username");
                final String password = AppConfigListener.getApiKey("mail.smtp.password");

                // 설정 값 유효성 검증 강화
                if (host == null || host.isEmpty() || port == null || port.isEmpty() ||
                    username == null || username.isEmpty() || "여기에_사용할_Gmail계정을_입력하세요".equals(username) ||
                    password == null || password.isEmpty() || "여기에_Gmail_앱비밀번호를_입력하세요".equals(password)) {
                    System.err.println("EmailUtil: SMTP 설정이 api.properties에 올바르게 설정되지 않았습니다. 실제 이메일 발송을 건너뜁니다.");
                    return;
                }

                Properties props = new Properties();
                props.put("mail.smtp.host", host);
                props.put("mail.smtp.port", port);
                props.put("mail.smtp.auth", AppConfigListener.getApiKey("mail.smtp.auth"));
                props.put("mail.smtp.starttls.enable", AppConfigListener.getApiKey("mail.smtp.starttls.enable"));

                Session session = Session.getInstance(props, new Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(username, password);
                    }
                });

                MimeMessage message = new MimeMessage(session);
                // [개선] 발신자 이름("MEET LOG") 설정
                message.setFrom(new InternetAddress(username, "MEET LOG"));
                message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
                message.setSubject(subject, "UTF-8");
                message.setText(body, "UTF-8");

                Transport.send(message);
                System.out.println("EmailUtil: 실제 이메일이 성공적으로 발송되었습니다. (수신자: " + to + ")");

            } catch (Exception e) {
                System.err.println("EmailUtil: 비동기 이메일 발송 중 오류가 발생했습니다.");
                e.printStackTrace();
            }
        });
    }

    /**
     * 애플리케이션 종료 시 스레드 풀을 안전하게 종료합니다.
     * (ServletContextListener의 contextDestroyed에서 호출해주면 좋습니다.)
     */
    public static void shutdown() {
        emailExecutor.shutdown();
    }
}