package util;

import java.io.InputStream;
import java.util.Properties;

public class AppConfig {
    private static Properties properties = new Properties();

    static {
        try (InputStream input = AppConfig.class.getClassLoader().getResourceAsStream("config.properties")) {
            if (input == null) {
                System.out.println("Sorry, unable to find config.properties");
            } else {
                properties.load(input);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static String getUploadPath() {
        return properties.getProperty("upload.path");
    }
}