package util;

import java.io.InputStream;
import java.util.Properties;

/**
 * config.properties 파일의 설정을 읽어와서 애플리케이션 전체에서 사용할 수 있도록 제공하는 클래스
 */
public class AppConfig {
    private static final Properties properties = new Properties();

    // 클래스가 메모리에 로드될 때 딱 한 번만 실행되는 static 블록
    static {
        try (InputStream input = AppConfig.class.getClassLoader().getResourceAsStream("config.properties")) {
            if (input == null) {
                System.out.println("ERROR: config.properties 파일을 찾을 수 없습니다.");
            }
            properties.load(input); // 설정 파일의 내용을 읽어옴
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 설정 파일에서 'upload.path' 키에 해당하는 값을 반환합니다.
     * @return 이미지를 업로드할 폴더의 실제 경로
     */
    public static String getUploadPath() {
        return properties.getProperty("upload.path");
    }
}