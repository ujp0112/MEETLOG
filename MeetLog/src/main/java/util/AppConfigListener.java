package util;

import java.io.InputStream;
import java.util.Properties;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class AppConfigListener implements ServletContextListener {
    private static Properties properties = new Properties();
    private static boolean isLoaded = false;
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();
        

        try (InputStream input = getClass().getClassLoader().getResourceAsStream("api.properties")) {
            if (input == null) {
                System.out.println("ERROR: api.properties 파일을 찾을 수 없습니다.");
                return;
            }
            properties.load(input);
            isLoaded = true;
            // [수정] 두 개의 키를 모두 로드합니다.
            String tinymceKey = properties.getProperty("tinymce.api.key");
            String kakaoKey = properties.getProperty("kakao.api.key");

            // ServletContext에 두 키를 모두 저장합니다.
            context.setAttribute("TINYMCE_API_KEY", tinymceKey);
            context.setAttribute("KAKAO_API_KEY", kakaoKey);
            
            System.out.println("API Keys (TinyMCE, Kakao, Naver) have been loaded into ServletContext.");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public static String getApiKey(String keyName) {
        return properties.getProperty(keyName);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) { }
}