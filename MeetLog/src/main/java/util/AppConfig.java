package util;

import java.io.InputStream;
import java.util.Properties;

public class AppConfig {
    private static Properties properties = new Properties();

    static {
        loadProperties("config.properties");
        loadProperties("api.properties");
    }

    private static void loadProperties(String resourceName) {
        try (InputStream input = AppConfig.class.getClassLoader().getResourceAsStream(resourceName)) {
            if (input == null) {
                System.out.println("Unable to find " + resourceName);
                return;
            }
            Properties temp = new Properties();
            temp.load(input);
            properties.putAll(temp);
        } catch (Exception e) {
            System.err.println("Failed to load properties from " + resourceName);
            e.printStackTrace();
        }
    }

    public static String getUploadPath() {
        return properties.getProperty("upload.path");
    }

    public static String getProperty(String key) {
        return properties.getProperty(key);
    }

    public static String getProperty(String key, String defaultValue) {
        return properties.getProperty(key, defaultValue);
    }
}
