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
     * Naver 이미지 검색 API를 호출하여 이미지 URL 목록을 반환합니다.
     * @param query 검색할 키워드 (가게 이름 등)
     * @param display 가져올 이미지 개수
     * @return 이미지 링크(URL) 목록
     */
    public static List<String> searchImages(String query, int display) {
        // ApiKeyLoader를 통해 api.properties 파일에서 네이버 API 키를 불러옵니다.
        String clientId = AppConfigListener.getApiKey("naverClientId");
        String clientSecret = AppConfigListener.getApiKey("naverClientSecret");
        List<String> imageLinks = new ArrayList<>();

        if (clientId == null || clientSecret == null) {
            System.err.println("Naver API credentials (naverClientId, naverClientSecret) not found in api.properties.");
            return imageLinks;
        }

        try {
            String encodedQuery = URLEncoder.encode(query, "UTF-8");
            // sort=sim은 유사도순 정렬을 의미합니다.
            String apiURL = "https://openapi.naver.com/v1/search/image?query=" + encodedQuery + "&display=" + display + "&sort=sim";
            
            URL url = new URL(apiURL);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");
            con.setRequestProperty("X-Naver-Client-Id", clientId);
            con.setRequestProperty("X-Naver-Client-Secret", clientSecret);

            int responseCode = con.getResponseCode();
            BufferedReader br;
            if (responseCode == 200) { // 정상 호출
                br = new BufferedReader(new InputStreamReader(con.getInputStream()));
            } else { // 에러 발생
                br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
            }

            String inputLine;
            StringBuffer response = new StringBuffer();
            while ((inputLine = br.readLine()) != null) {
                response.append(inputLine);
            }
            br.close();

            if (responseCode == 200) {
                JSONObject jsonResponse = new JSONObject(response.toString());
                JSONArray items = jsonResponse.getJSONArray("items");
                for (int i = 0; i < items.length(); i++) {
                    JSONObject item = items.getJSONObject(i);
                    // 썸네일(thumbnail)이 아닌 원본 이미지(link)의 URL을 추가합니다.
                    imageLinks.add(item.getString("link"));
                }
            } else {
                 System.err.println("Naver API Error: " + response.toString());
            }

        } catch (Exception e) {
            System.err.println("Error during Naver Image Search: " + e.getMessage());
            e.printStackTrace();
        }
        return imageLinks;
    }
}
