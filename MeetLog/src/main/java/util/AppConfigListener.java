package util;

import java.io.InputStream;
import java.util.Properties;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class AppConfigListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // ServletContext 객체를 가져옵니다.
        ServletContext context = sce.getServletContext();
        Properties props = new Properties();

        // resources 폴더의 api.properties 파일을 읽어옵니다.
        try (InputStream input = getClass().getClassLoader().getResourceAsStream("api.properties")) {
            if (input == null) {
                System.out.println("Sorry, unable to find api.properties");
                return;
            }
            props.load(input);

            // 프로퍼티 파일에서 API 키를 읽어옵니다.
            String apiKey = props.getProperty("tinymce.api.key");

            // ServletContext에 API 키를 저장합니다.
            // 이제 애플리케이션의 모든 JSP와 서블릿에서 이 값에 접근할 수 있습니다.
            context.setAttribute("TINYMCE_API_KEY", apiKey);
            
            System.out.println("TinyMCE API Key loaded successfully into ServletContext.");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // 애플리케이션 종료 시 실행되는 코드 (현재는 필요 없음)
    }
}