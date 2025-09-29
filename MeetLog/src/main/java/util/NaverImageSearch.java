package util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONObject;

public class NaverImageSearch {

    public static String findBestImage(String query) {
//        String imageUrl = searchLocalAndGetThumbnail(query);
    	String imageUrl = null;
        if (imageUrl == null || !isImageUrl(imageUrl)) {
            List<String> images = searchImages(query, 1);
            if (images != null && !images.isEmpty()) {
                imageUrl = images.get(0);
            }
        }
        return imageUrl;
    }
    
    public static List<String> searchImages(String query, int display) {
        String clientId = AppConfigListener.getApiKey("naverClientId");
        String clientSecret = AppConfigListener.getApiKey("naverClientSecret");
        List<String> imageLinks = new ArrayList<>();
        if (clientId == null || clientSecret == null) return imageLinks;

        try {
            String encodedQuery = URLEncoder.encode(query, "UTF-8");
            String apiURL = "https://openapi.naver.com/v1/search/image?query=" + encodedQuery + "&display=" + display + "&sort=sim";
            JSONObject jsonResponse = executeApiCall(apiURL, clientId, clientSecret);
            if (jsonResponse != null && jsonResponse.has("items")) {
                JSONArray items = jsonResponse.getJSONArray("items");
                for (int i = 0; i < items.length(); i++) {
                    imageLinks.add(items.getJSONObject(i).getString("link"));
                }
            }
        } catch (Exception e) {
            System.err.println("Error during Naver Image Search: " + e.getMessage());
        }
        return imageLinks;
    }

    private static String searchLocalAndGetThumbnail(String query) {
        String clientId = AppConfigListener.getApiKey("naverClientId");
        String clientSecret = AppConfigListener.getApiKey("naverClientSecret");
        if (clientId == null || clientSecret == null) return null;

        try {
            String encodedQuery = URLEncoder.encode(query, "UTF-8");
            String apiURL = "https://openapi.naver.com/v1/search/local.json?query=" + encodedQuery + "&display=1&sort=random";
            
            JSONObject jsonResponse = executeApiCall(apiURL, clientId, clientSecret);
            if (jsonResponse != null && jsonResponse.has("items")) {
                JSONArray items = jsonResponse.getJSONArray("items");
                if (items.length() > 0) {
                    JSONObject item = items.getJSONObject(0);
                    if (item.has("thumbnail") && !item.getString("thumbnail").isEmpty()) {
                        return item.getString("thumbnail"); 
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Error during Naver Local Search: " + e.getMessage());
        }
        return null;
    }
    
    private static JSONObject executeApiCall(String apiUrl, String clientId, String clientSecret) {
        try {
            URL url = new URL(apiUrl);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");
            con.setRequestProperty("X-Naver-Client-Id", clientId);
            con.setRequestProperty("X-Naver-Client-Secret", clientSecret);
            int responseCode = con.getResponseCode();
            BufferedReader br = new BufferedReader(new InputStreamReader(
                responseCode == 200 ? con.getInputStream() : con.getErrorStream()
            ));
            StringBuffer response = new StringBuffer();
            String inputLine;
            while ((inputLine = br.readLine()) != null) {
                response.append(inputLine);
            }
            br.close();
            if (responseCode == 200) {
                return new JSONObject(response.toString());
            } else {
                System.err.println("Naver API Error for URL (" + apiUrl + "): " + response.toString());
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private static boolean isImageUrl(String url) {
        if (url == null || url.isEmpty()) return false;
        String lowerCaseUrl = url.toLowerCase();
        String path = lowerCaseUrl.split("\\?")[0];
        return path.endsWith(".jpg") || path.endsWith(".jpeg") || 
               path.endsWith(".png") || path.endsWith(".gif");
    }
}

