package util;

import java.io.InputStream;
import java.util.Properties;
import javax.servlet.ServletContext;

public class ApiKeyLoader {
    private static Properties properties = new Properties();
    private static boolean isLoaded = false;

    // 서블릿에서 키를 한번만 로드하기 위한 메소드
    public static void load(ServletContext context) {
        if (isLoaded) return;
        try (InputStream input = context.getResourceAsStream("/WEB-INF/api.properties")) {
            if (input == null) {
                throw new RuntimeException("api.properties 파일을 찾을 수 없습니다.");
            }
            properties.load(input);
            isLoaded = true;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("API 키 로딩 실패", e);
        }
    }

    // JSP 등에서 키를 가져오는 메소드
    public static String getApiKey(String keyName) {
        return properties.getProperty(keyName);
    }
}