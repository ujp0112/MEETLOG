// src/main/java/util/AppConfigListener.java (최종 수정본)
package util;

import java.io.InputStream;
import java.util.Properties;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class AppConfigListener implements ServletContextListener {
    // Properties 객체를 static으로 선언하여 클래스 레벨에서 공유합니다.
    private static Properties properties = new Properties();
    private boolean isLoaded = false;
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("웹 애플리케이션 시작: api.properties 로딩을 시작합니다...");
        ServletContext context = sce.getServletContext();
        
        // 클래스패스 루트에서 api.properties 파일을 찾습니다.
        try (InputStream input = getClass().getClassLoader().getResourceAsStream("api.properties")) {
            if (input == null) {
                System.err.println("CRITICAL ERROR: api.properties 파일을 찾을 수 없습니다.");
                return;
            }
            // 프로퍼티 파일의 내용을 static properties 객체에 로드합니다.
            properties.load(input);
            System.out.println("api.properties 로딩 성공!");
            isLoaded = true;
            
            // --- 기존 기능 유지: JSP에서 사용할 키들을 ServletContext에 저장 ---
            context.setAttribute("TINYMCE_API_KEY", properties.getProperty("tinymce.api.key"));
            context.setAttribute("KAKAO_API_KEY", properties.getProperty("kakao.api.key"));
            context.setAttribute("GOOGLE_API_KEY", properties.getProperty("GOOGLE_API_KEY"));
            
            System.out.println("API 키들이 ServletContext에 성공적으로 저장되었습니다.");

        } catch (Exception e) {
            System.err.println("api.properties 파일 로딩 중 심각한 오류가 발생했습니다.");
            e.printStackTrace();
        }
    }

    /**
     * 다른 자바 클래스에서 API 키를 쉽게 가져갈 수 있도록 public static 메소드를 제공합니다.
     * @param keyName api.properties 파일의 키(key) 이름
     * @return 키에 해당하는 값(value)
     */
    public static String getApiKey(String keyName) {
        return properties.getProperty(keyName);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // 웹 애플리케이션 종료 시 Properties 객체를 비웁니다.
        properties.clear();
        System.out.println("웹 애플리케이션 종료: 로드된 API 속성을 모두 제거했습니다.");
    }
}