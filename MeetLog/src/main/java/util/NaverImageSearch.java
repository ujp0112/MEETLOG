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

    /**
     * [개선] 장소 검색을 먼저 시도하고, 실패 시 이미지 검색을 실행하는 메인 메소드
     */
    public static String findBestImage(String query) {
        String imageUrl = searchLocalAndGetThumbnail(query);

        // [수정] 장소 검색 결과가 실제 이미지 URL이 아닐 경우(예: 블로그 링크)를 대비해 2순위 검색 실행
        if (imageUrl == null || !isImageUrl(imageUrl)) {
            List<String> images = searchImages(query, 1);
            if (images != null && !images.isEmpty()) {
                imageUrl = images.get(0);
            }
        }
        return imageUrl;
    }
    
    /**
     * [기존] searchImages는 ExternalRestaurantDetailServlet에서 사용하므로 public 유지
     */
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

    /**
     * [신규] Naver 장소 검색 API를 호출하여 대표 썸네일 이미지 URL을 반환
     */
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
                    // [수정] 장소 검색 결과에는 'thumbnail' 필드가 있습니다. 이것을 우선적으로 사용합니다.
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
    
    /**
     * [신규] API 호출 로직 중복 제거를 위한 헬퍼 메소드
     */
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

    /**
     * [신규] 반환된 URL이 실제 이미지 파일인지 간단하게 확인하는 헬퍼 메소드
     */
    private static boolean isImageUrl(String url) {
        if (url == null || url.isEmpty()) return false;
        String lowerCaseUrl = url.toLowerCase();
        // 네이버 썸네일은 ?type=... 파라미터가 붙으므로, 파라미터 앞부분을 기준으로 확장자를 체크합니다.
        String path = lowerCaseUrl.split("\\?")[0];
        return path.endsWith(".jpg") || path.endsWith(".jpeg") || 
               path.endsWith(".png") || path.endsWith(".gif");
    }
}

